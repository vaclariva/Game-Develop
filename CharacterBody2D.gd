extends CharacterBody2D


enum State {
	WALK,
	DIAM,
}

const WALK_SPEED = 100.0

var _state := State.WALK

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var tengah := $tengah as RayCast2D
@onready var kanan := $kanan as RayCast2D
@onready var kiri := $kiri as RayCast2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer

func _physics_process(delta: float) -> void:
	if _state == State.WALK and velocity.is_zero_approx():
		velocity.x = WALK_SPEED
	velocity.y += gravity * delta
	if not kanan.is_colliding():
		velocity.x = WALK_SPEED
	elif not kiri.is_colliding():
		velocity.x = -WALK_SPEED

	if is_on_wall():
		velocity.x = -velocity.x

	move_and_slide()

	if velocity.x > 0.0:
		sprite.scale.x = 1.0
	elif velocity.x < 0.0:
		sprite.scale.x = -1.0

	var animation := get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)



func get_new_animation() -> StringName:
	var animation_new: StringName
	if _state == State.WALK:
		if velocity.x == 0:
			animation_new = &"diam"
		else:
			animation_new = &"walk"
	else:
		animation_new = &"destroy"
	return animation_new
