Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787BC3995BC
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 00:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhFBWKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 18:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBWKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 18:10:15 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10937C06174A;
        Wed,  2 Jun 2021 15:08:21 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id n133so5961659ybf.6;
        Wed, 02 Jun 2021 15:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aA4K2DPEL8o6L752PRLDTSxNxg6g9AGy9xUxgV+YCRM=;
        b=Iknk9uWt/fpnDx4i61lV0+DHGSSGTDwqQWXZAFBnrMOHAhghsgSZ1QJq5tv01stH/B
         0w7JB8zQaNf/6e1OxIpSr5bI/AGKtHlx3j8o/r22fMYE8BPj6BDx/+9CJOCcsssHZVQS
         8xPRxt/AD7hJVnSm7k71B9JHLJBhUq+gxdX5OwfUpZ+VUYhmq4ARqgtU6LU0+RVWOk71
         X32AlYaShKUup4NaJA1QOB21m8FEp7TMG75rGNlN7THvhe3TWaFOhoeuHC7eLXvt0Mzu
         vMmTWISAFw1ar1/xQQVLzHvhJ9gJ9dfl/vw4Q0eUIzuyT5B83Gikx2x2toxkzRuLt+E+
         lXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aA4K2DPEL8o6L752PRLDTSxNxg6g9AGy9xUxgV+YCRM=;
        b=dTzlH4uxFM0VHQesgqh/bPqp8Ua2vR89uXsYx37HctzUjucHRUsrbqAJ/J6AOnMeWl
         kstA02K7we0RNSv2U32D8Wt5dCmVga357Im15PbtDfgsYGi/6l4ltD+np0Po26giQlKV
         81OPCoHzq/5TlRF33d5Ds8tjYkxGhapMzdFBiITTfRTmh7So+jPrPwq0AbZ8BT6dEGTm
         fXLLw0x/ru3XZTCvHj+NWD9o5IE16MQaWdmys721230b4bJU7YWRxs7YpHQf/1q9Tf+e
         OWoV7kq8eGIYMuEA38qa2LhngVZIqNOBQERC0p0h3/8kzOGFAWvOGy/I6YAsRx009Vte
         ceSg==
X-Gm-Message-State: AOAM531NIZrP9dMjCMk8esRLb6KMEOLvIWrag0fNjMKEozdDAgEoLNMR
        WvXG5La8vZYEgrU833a2iu+8ElcRACeLMFjMaTEBeSjb8cU=
X-Google-Smtp-Source: ABdhPJwo73qUOMhvbtfiwDfSy05GpxI1A1Y3hVON0/kjCC358VUTJiEAa2bBJcn/CI3JOaJXumyF35qxNtai26/OznA=
X-Received: by 2002:a25:4182:: with SMTP id o124mr29519191yba.27.1622671700042;
 Wed, 02 Jun 2021 15:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com> <20210527040259.77823-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20210527040259.77823-2-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Jun 2021 15:08:08 -0700
Message-ID: <CAEf4BzbyikY1b4vAzb+t88odbqWOR7K4TpwjM1zGF4Nmqu6ysg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 9:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce 'struct bpf_timer { __u64 :64; };' that can be embedded
> in hash/array/lru maps as regular field and helpers to operate on it:
> long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags);
> long bpf_timer_start(struct bpf_timer *timer, u64 nsecs);
> long bpf_timer_cancel(struct bpf_timer *timer);
>
> Here is how BPF program might look like:
> struct map_elem {
>     int counter;
>     struct bpf_timer timer;
> };
>
> struct {
>     __uint(type, BPF_MAP_TYPE_HASH);
>     __uint(max_entries, 1000);
>     __type(key, int);
>     __type(value, struct map_elem);
> } hmap SEC(".maps");
>
> struct bpf_timer global_timer;

Using bpf_timer as a global variable has at least two problems. We
discussed one offline but I realized another one reading the code in
this patch:
  1. this memory can and is memory-mapped as read-write, so user-space
can just write over this (intentionally or accidentally), so it's
quite unsafe
  2. with current restriction of having offset 0 for struct bpf_timer,
you have to use global variable for it, because clang will reorder
static variables after global variables.

I think it's better to disallow use of struct bpf_timer in
memory-mapped maps. Keep in mind that user can create memory-mapped
BPF_MAP_TYPE_ARRAY manually (without using global variables) and put
struct bpf_timer in it, so that should be disallowed as well.

>
> static int timer_cb1(void *map, int *key, __u64 *data);
> /* global_timer is in bss which is special bpf array of one element.
>  * data points to beginning of bss.
>  */
>
> static int timer_cb2(void *map, int *key, struct map_elem *val);
> /* val points to particular map element that contains bpf_timer. */
>
> SEC("fentry/bpf_fentry_test1")
> int BPF_PROG(test1, int a)
> {
>     struct map_elem *val;
>     int key = 0;
>     bpf_timer_init(&global_timer, timer_cb1, 0);
>     bpf_timer_start(&global_timer, 0 /* call timer_cb1 asap */);
>
>     val = bpf_map_lookup_elem(&hmap, &key);
>     if (val) {
>         bpf_timer_init(&val->timer, timer_cb2, 0);
>         bpf_timer_start(&val->timer, 1000 /* call timer_cb2 in 1 msec */);
>     }
> }
>
> This patch adds helper implementations that rely on hrtimers
> to call bpf functions as timers expire.
> The following patch adds necessary safety checks.
>
> Only programs with CAP_BPF are allowed to use bpf_timer.
>
> The amount of timers used by the program is constrained by
> the memcg recorded at map creation time.
>
> The bpf_timer_init() helper is receiving hidden 'map' and 'prog' arguments
> supplied by the verifier. The prog pointer is needed to do refcnting of bpf
> program to make sure that program doesn't get freed while timer is armed.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h            |   1 +
>  include/uapi/linux/bpf.h       |  26 ++++++
>  kernel/bpf/helpers.c           | 160 +++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          | 110 +++++++++++++++++++++++
>  kernel/trace/bpf_trace.c       |   2 +-
>  scripts/bpf_doc.py             |   2 +
>  tools/include/uapi/linux/bpf.h |  26 ++++++
>  7 files changed, 326 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 1e9a0ff3217b..925b8416ea0a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -314,6 +314,7 @@ enum bpf_arg_type {
>         ARG_PTR_TO_FUNC,        /* pointer to a bpf program function */
>         ARG_PTR_TO_STACK_OR_NULL,       /* pointer to stack or NULL */
>         ARG_PTR_TO_CONST_STR,   /* pointer to a null terminated read-only string */
> +       ARG_PTR_TO_TIMER,       /* pointer to bpf_timer */
>         __BPF_ARG_TYPE_MAX,
>  };
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 562adeac1d67..3da901d5076b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4774,6 +4774,25 @@ union bpf_attr {
>   *             Execute close syscall for given FD.
>   *     Return
>   *             A syscall result.
> + *
> + * long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags)
> + *     Description
> + *             Initialize the timer to call given static function.
> + *     Return
> + *             zero

-EBUSY is probably the most important to mention here, but generally
the way it's described right now it seems like it can't fail, which is
not true. Similar for bpf_timer_start() and bpf_timer_cancel().

> + *
> + * long bpf_timer_start(struct bpf_timer *timer, u64 nsecs)
> + *     Description
> + *             Start the timer and set its expiration N nanoseconds from
> + *             the current time.

The case of nsecs == 0 is a bit special and interesting, it's useful
to explain what will happen in that case. I'm actually curious as
well, in the code you say "call ASAP", but does it mean after the BPF
program exits? Or can it start immediately on another CPU? Or will it
interrupt the currently running BPF program to run the callback
(unlikely, but that might be someone's expectation).

> + *     Return
> + *             zero
> + *
> + * long bpf_timer_cancel(struct bpf_timer *timer)
> + *     Description
> + *             Deactivate the timer.
> + *     Return
> + *             zero
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -4945,6 +4964,9 @@ union bpf_attr {
>         FN(sys_bpf),                    \
>         FN(btf_find_by_name_kind),      \
>         FN(sys_close),                  \
> +       FN(timer_init),                 \
> +       FN(timer_start),                \
> +       FN(timer_cancel),               \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -6051,6 +6073,10 @@ struct bpf_spin_lock {
>         __u32   val;
>  };
>
> +struct bpf_timer {
> +       __u64 :64;
> +};
> +
>  struct bpf_sysctl {
>         __u32   write;          /* Sysctl is being read (= 0) or written (= 1).
>                                  * Allows 1,2,4-byte read, but no write.
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 544773970dbc..6f9620cbe95d 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -985,6 +985,160 @@ const struct bpf_func_proto bpf_snprintf_proto = {
>         .arg5_type      = ARG_CONST_SIZE_OR_ZERO,
>  };
>
> +struct bpf_hrtimer {
> +       struct hrtimer timer;
> +       spinlock_t lock;
> +       struct bpf_map *map;
> +       struct bpf_prog *prog;
> +       void *callback_fn;
> +       void *key;
> +       void *value;
> +};
> +
> +/* the actual struct hidden inside uapi struct bpf_timer */
> +struct bpf_timer_kern {
> +       struct bpf_hrtimer *timer;
> +};
> +
> +static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);
> +
> +static enum hrtimer_restart timer_cb(struct hrtimer *timer)

nit: can you please call it bpf_timer_cb, so it might be possible to
trace it a bit easier due to bpf_ prefix?

> +{
> +       struct bpf_hrtimer *t = container_of(timer, struct bpf_hrtimer, timer);
> +       unsigned long flags;
> +       int ret;
> +
> +       /* timer_cb() runs in hrtimer_run_softirq and doesn't migrate.
> +        * Remember the timer this callback is servicing to prevent
> +        * deadlock if callback_fn() calls bpf_timer_cancel() on the same timer.
> +        */
> +       this_cpu_write(hrtimer_running, t);
> +       ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)t->map,
> +                                           (u64)(long)t->key,
> +                                           (u64)(long)t->value, 0, 0);
> +       WARN_ON(ret != 0); /* todo: define 0 vs 1 or disallow 1 in the verifier */

if we define 0 vs 1, what would their meaning be?

> +       spin_lock_irqsave(&t->lock, flags);
> +       if (!hrtimer_is_queued(timer))
> +               bpf_prog_put(t->prog);
> +       spin_unlock_irqrestore(&t->lock, flags);
> +       this_cpu_write(hrtimer_running, NULL);

Don't know if it's a problem. Above you say that timer_cb doesn't
migrate, but can it be preempted? If yes, and timer_cb is called in
the meantime for another timer, setting hrtimer_running to NULL will
clobber the previous value, right? So no nesting is possible. Is this
a problem?

Also is there a chance for timer callback to be a sleepable BPF (sub-)program?

What if we add a field to struct bpf_hrtimer that will be inc/dec to
show whether it's active or not? That should bypass per-CPU
assumptions, but I haven't thought through races, worst case we might
need to take t->lock.

> +       return HRTIMER_NORESTART;
> +}
> +
> +BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, void *, cb, int, flags,
> +          struct bpf_map *, map, struct bpf_prog *, prog)
> +{
> +       struct bpf_hrtimer *t;
> +
> +       if (flags)
> +               return -EINVAL;
> +       if (READ_ONCE(timer->timer))
> +               return -EBUSY;
> +       /* allocate hrtimer via map_kmalloc to use memcg accounting */
> +       t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);
> +       if (!t)
> +               return -ENOMEM;
> +       t->callback_fn = cb;
> +       t->value = (void *)timer /* - offset of bpf_timer inside elem */;
> +       t->key = t->value - round_up(map->key_size, 8);
> +       t->map = map;
> +       t->prog = prog;
> +       spin_lock_init(&t->lock);
> +       hrtimer_init(&t->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
> +       t->timer.function = timer_cb;
> +       if (cmpxchg(&timer->timer, NULL, t)) {
> +               /* Parallel bpf_timer_init() calls raced. */
> +               kfree(t);
> +               return -EBUSY;
> +       }
> +       return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_init_proto = {
> +       .func           = bpf_timer_init,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_TIMER,
> +       .arg2_type      = ARG_PTR_TO_FUNC,
> +       .arg3_type      = ARG_ANYTHING,
> +};
> +
> +BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs)

Not entirely sure, but it feels like adding flags would be good here as well?

> +{
> +       struct bpf_hrtimer *t;
> +       unsigned long flags;
> +
> +       t = READ_ONCE(timer->timer);
> +       if (!t)
> +               return -EINVAL;
> +       spin_lock_irqsave(&t->lock, flags);
> +       /* Keep the prog alive until callback is invoked */
> +       if (!hrtimer_active(&t->timer))
> +               bpf_prog_inc(t->prog);
> +       hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
> +       spin_unlock_irqrestore(&t->lock, flags);
> +       return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_start_proto = {
> +       .func           = bpf_timer_start,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_TIMER,
> +       .arg2_type      = ARG_ANYTHING,
> +};
> +
> +BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
> +{
> +       struct bpf_hrtimer *t;
> +       unsigned long flags;
> +
> +       t = READ_ONCE(timer->timer);
> +       if (!t)
> +               return -EINVAL;
> +       if (this_cpu_read(hrtimer_running) == t)
> +               /* If bpf callback_fn is trying to bpf_timer_cancel()
> +                * its own timer the hrtimer_cancel() will deadlock
> +                * since it waits for callback_fn to finish
> +                */
> +               return -EBUSY;
> +       spin_lock_irqsave(&t->lock, flags);
> +       /* Cancel the timer and wait for associated callback to finish
> +        * if it was running.
> +        */
> +       if (hrtimer_cancel(&t->timer) == 1)
> +               /* If the timer was active then drop the prog refcnt,
> +                * since callback will not be invoked.
> +                */

So the fact whether the timer was cancelled or it's active/already
fired seems useful to know in BPF program (sometimes). I can't recall
an exact example, but in the past dealing with some timers (in
user-space, but the point stands) I remember it was important to know
this, so maybe we can communicate that as 0 or 1 returned from
bpf_timer_cancel?


> +               bpf_prog_put(t->prog);
> +       spin_unlock_irqrestore(&t->lock, flags);
> +       return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_cancel_proto = {
> +       .func           = bpf_timer_cancel,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_TIMER,
> +};
> +
> +void bpf_timer_cancel_and_free(void *val)
> +{
> +       struct bpf_timer_kern *timer = val;
> +       struct bpf_hrtimer *t;
> +
> +       t = READ_ONCE(timer->timer);
> +       if (!t)
> +               return;
> +       /* Cancel the timer and wait for callback to complete
> +        * if it was running
> +        */
> +       if (hrtimer_cancel(&t->timer) == 1)
> +               bpf_prog_put(t->prog);
> +       kfree(t);
> +       WRITE_ONCE(timer->timer, NULL);

this seems to race with bpf_timer_start, no? Doing WRITE_ONCE and then
kfree() timer would be a bit safer (we won't have dangling pointer at
any point in time), but I think that still is racy, because
bpf_start_timer can read timer->timer before WRITE_ONCE(NULL) here,
then we kfree(t), and then bpf_timer_start() proceeds to take t->lock
which might explode or might do whatever.

If there is a non-obvious mechanism preventing this (I haven't read
second patch thoroughly yet), it's probably a good idea to mention
that here.

A small nit, you added bpf_timer_cancel_and_free() prototype in the
next patch, but it should probably be done in this patch to avoid
unnecessary compiler warnings during bisecting.


> +}
> +
>  const struct bpf_func_proto bpf_get_current_task_proto __weak;
>  const struct bpf_func_proto bpf_probe_read_user_proto __weak;
>  const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
> @@ -1051,6 +1205,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>                 return &bpf_per_cpu_ptr_proto;
>         case BPF_FUNC_this_cpu_ptr:
>                 return &bpf_this_cpu_ptr_proto;
> +       case BPF_FUNC_timer_init:
> +               return &bpf_timer_init_proto;
> +       case BPF_FUNC_timer_start:
> +               return &bpf_timer_start_proto;
> +       case BPF_FUNC_timer_cancel:
> +               return &bpf_timer_cancel_proto;
>         default:
>                 break;
>         }
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1de4b8c6ee42..f386f85aee5c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4656,6 +4656,35 @@ static int process_spin_lock(struct bpf_verifier_env *env, int regno,
>         return 0;
>  }
>
> +static int process_timer_func(struct bpf_verifier_env *env, int regno,
> +                             struct bpf_call_arg_meta *meta)
> +{
> +       struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
> +       bool is_const = tnum_is_const(reg->var_off);
> +       struct bpf_map *map = reg->map_ptr;
> +       u64 val = reg->var_off.value;
> +
> +       if (!is_const) {
> +               verbose(env,
> +                       "R%d doesn't have constant offset. bpf_timer has to be at the constant offset\n",
> +                       regno);
> +               return -EINVAL;
> +       }
> +       if (!map->btf) {
> +               verbose(env, "map '%s' has to have BTF in order to use bpf_timer\n",
> +                       map->name);
> +               return -EINVAL;
> +       }
> +       if (val) {
> +               /* todo: relax this requirement */

Yeah, that's quite a non-obvious requirement. How hard is it to get
rid of it? If not, we should probably leave a comment new struct
bpf_timer definition in UAPI header.

> +               verbose(env, "bpf_timer field can only be first in the map value element\n");
> +               return -EINVAL;
> +       }
> +       WARN_ON(meta->map_ptr);
> +       meta->map_ptr = map;
> +       return 0;
> +}
> +

[...]

>         if (func_id == BPF_FUNC_snprintf) {
>                 err = check_bpf_snprintf_call(env, regs);
>                 if (err < 0)
> @@ -12526,6 +12605,37 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>                         insn      = new_prog->insnsi + i + delta;
>                         continue;
>                 }
> +               if (insn->imm == BPF_FUNC_timer_init) {
> +

nit: why empty line here?

> +                       aux = &env->insn_aux_data[i + delta];
> +                       if (bpf_map_ptr_poisoned(aux)) {
> +                               verbose(env, "bpf_timer_init abusing map_ptr\n");
> +                               return -EINVAL;
> +                       }
> +                       map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
> +                       {
> +                               struct bpf_insn ld_addrs[4] = {
> +                                       BPF_LD_IMM64(BPF_REG_4, (long)map_ptr),
> +                                       BPF_LD_IMM64(BPF_REG_5, (long)prog),
> +                               };
> +
> +                               insn_buf[0] = ld_addrs[0];
> +                               insn_buf[1] = ld_addrs[1];
> +                               insn_buf[2] = ld_addrs[2];
> +                               insn_buf[3] = ld_addrs[3];
> +                       }
> +                       insn_buf[4] = *insn;
> +                       cnt = 5;
> +
> +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> +                       if (!new_prog)
> +                               return -ENOMEM;
> +
> +                       delta    += cnt - 1;
> +                       env->prog = prog = new_prog;
> +                       insn      = new_prog->insnsi + i + delta;
> +                       goto patch_call_imm;
> +               }
>
>                 /* BPF_EMIT_CALL() assumptions in some of the map_gen_lookup
>                  * and other inlining handlers are currently limited to 64 bit
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d2d7cf6cfe83..453a46c2d732 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1065,7 +1065,7 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_snprintf:
>                 return &bpf_snprintf_proto;
>         default:
> -               return NULL;
> +               return bpf_base_func_proto(func_id);
>         }
>  }
>

[...]
