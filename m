Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B52562682
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391546AbfGHQkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:40:43 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43297 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730210AbfGHQkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:40:43 -0400
Received: by mail-lj1-f195.google.com with SMTP id 16so16567060ljv.10
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZRwJxYi8H6NXkLxGEoJ4R04LQeTYpqMdic2xdpDP/dc=;
        b=Z0uN5VFX5niSWbUptz7kikfHinLW9mzhxMrY6TVjnM9aGKplU8WRMLaZk3IsXEi4lM
         fMVmV/jc/9RkFwRKiOoOAD4j1SaX7RJPAWdQ9DFXK22MNKPej5Mc1dPFG+bxApyfhnzy
         7CHZizfoz7GfjbZMrFOAbedDQkL2i6kqwZbu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZRwJxYi8H6NXkLxGEoJ4R04LQeTYpqMdic2xdpDP/dc=;
        b=DWnIZBf8k1Dz4m5mIEKYwq9XJet1HDlm8DafisOiH6UD1v16HMCzr8f4xt00BfFRpn
         Adnl1YPjMp8Y3VyvhKxZoPdxZUkBUY1apLfQTZ18UlXg0RTwRf5y+pHpU3d5hmhbjdu8
         13GQbHxiHEXaQWVmJW5w0ZSHd62sBU+RkkJoS4NEGApJmuou3eq9YgxZuqiQfpIXMwLf
         gMpABqtXAD6MEhIInUprGoThSIoFu+ybmgGj4+9giorq/9au7rRVWUWhtZHQk7KORZWn
         N4FXM1sZNzPd0vFmuYqudyyNeReYnKgIAvCbmel/9Ygl4uP/X3gadm79W6WWFGbaHi0G
         RzGg==
X-Gm-Message-State: APjAAAXM8IQN5Kzf1okhZO7CGs1dgd8zRKxskGf+/jgPKTLV1GDf0noC
        if8GRxoR6MmZjiTO4zpDpcb+hCKr0GbrfpqRtL+tOg==
X-Google-Smtp-Source: APXvYqyclvPVzSTm5nW3xEr83a2GwouiqqOJQ/aS4vZWfqU7yj4V4bqI1iYNOJl/QO47uRkdrzz+lfDUEyOUqRNIK/8=
X-Received: by 2002:a2e:89c8:: with SMTP id c8mr11131376ljk.70.1562604039547;
 Mon, 08 Jul 2019 09:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-10-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-10-krzesimir@kinvolk.io>
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
Date:   Mon, 8 Jul 2019 18:40:28 +0200
Message-ID: <CAGGp+cGASrZ+e9mYqxO_QRPFFrpuZMxvYD8Ya5jm8E-G1JsOwg@mail.gmail.com>
Subject: Re: [bpf-next v3 09/12] bpf: Split out some helper functions
To:     linux-kernel@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 6:31 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote=
:
>
> The moved functions are generally useful for implementing
> bpf_prog_test_run for other types of BPF programs - they don't have
> any network-specific stuff in them, so I can use them in a test run
> implementation for perf event BPF program too.
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>

This patch has some whitespace issues (indentation with spaces instead
of tabs in some places), will fix them for v4. Sorry about that.

> ---
>  include/linux/bpf.h   |  28 +++++
>  kernel/bpf/Makefile   |   1 +
>  kernel/bpf/test_run.c | 212 ++++++++++++++++++++++++++++++++++
>  net/bpf/test_run.c    | 263 +++++++++++-------------------------------
>  4 files changed, 308 insertions(+), 196 deletions(-)
>  create mode 100644 kernel/bpf/test_run.c
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 18f4cc2c6acd..28db8ba57bc3 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1143,4 +1143,32 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(=
enum bpf_access_type type,
>  }
>  #endif /* CONFIG_INET */
>
> +/* Helper functions for bpf_prog_test_run implementations */
> +typedef u32 bpf_prog_run_helper_t(struct bpf_prog *prog, void *ctx,
> +                                  void *private_data);
> +
> +enum bpf_test_run_flags {
> +       BPF_TEST_RUN_PLAIN =3D 0,
> +       BPF_TEST_RUN_SETUP_CGROUP_STORAGE =3D 1 << 0,
> +};
> +
> +int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat, u32 flags=
,
> +                u32 *retval, u32 *duration);
> +
> +int bpf_test_run_cb(struct bpf_prog *prog, void *ctx, u32 repeat, u32 fl=
ags,
> +                   bpf_prog_run_helper_t run_prog, void *private_data,
> +                   u32 *retval, u32 *duration);
> +
> +int bpf_test_finish(union bpf_attr __user *uattr, u32 retval, u32 durati=
on);
> +
> +void *bpf_receive_ctx(const union bpf_attr *kattr, u32 max_size);
> +
> +int bpf_send_ctx(const union bpf_attr *kattr, union bpf_attr __user *uat=
tr,
> +                const void *data, u32 size);
> +
> +void *bpf_receive_data(const union bpf_attr *kattr, u32 max_size);
> +
> +int bpf_send_data(const union bpf_attr *kattr, union bpf_attr __user *ua=
ttr,
> +                 const void *data, u32 size);
> +
>  #endif /* _LINUX_BPF_H */
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 29d781061cd5..570fd40288f4 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_CGROUP_BPF) +=3D cgroup.o
>  ifeq ($(CONFIG_INET),y)
>  obj-$(CONFIG_BPF_SYSCALL) +=3D reuseport_array.o
>  endif
> +obj-$(CONFIG_BPF_SYSCALL) +=3D test_run.o
> diff --git a/kernel/bpf/test_run.c b/kernel/bpf/test_run.c
> new file mode 100644
> index 000000000000..0481373da8be
> --- /dev/null
> +++ b/kernel/bpf/test_run.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2017 Facebook
> + * Copyright (c) 2019 Tigera, Inc
> + */
> +
> +#include <asm/div64.h>
> +
> +#include <linux/bpf-cgroup.h>
> +#include <linux/bpf.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/filter.h>
> +#include <linux/gfp.h>
> +#include <linux/kernel.h>
> +#include <linux/limits.h>
> +#include <linux/preempt.h>
> +#include <linux/rcupdate.h>
> +#include <linux/sched.h>
> +#include <linux/sched/signal.h>
> +#include <linux/slab.h>
> +#include <linux/timekeeping.h>
> +#include <linux/uaccess.h>
> +
> +static void teardown_cgroup_storage(struct bpf_cgroup_storage **storage)
> +{
> +       enum bpf_cgroup_storage_type stype;
> +
> +       if (!storage)
> +               return;
> +       for_each_cgroup_storage_type(stype)
> +               bpf_cgroup_storage_free(storage[stype]);
> +       kfree(storage);
> +}
> +
> +static struct bpf_cgroup_storage **setup_cgroup_storage(struct bpf_prog =
*prog)
> +{
> +       enum bpf_cgroup_storage_type stype;
> +       struct bpf_cgroup_storage **storage;
> +       size_t size =3D MAX_BPF_CGROUP_STORAGE_TYPE;
> +
> +       size *=3D sizeof(struct bpf_cgroup_storage *);
> +       storage =3D kzalloc(size, GFP_KERNEL);
> +       for_each_cgroup_storage_type(stype) {
> +               storage[stype] =3D bpf_cgroup_storage_alloc(prog, stype);
> +               if (IS_ERR(storage[stype])) {
> +                       storage[stype] =3D NULL;
> +                       teardown_cgroup_storage(storage);
> +                       return ERR_PTR(-ENOMEM);
> +               }
> +       }
> +       return storage;
> +}
> +
> +static u32 run_bpf_prog(struct bpf_prog *prog, void *ctx, void *private_=
data)
> +{
> +       return BPF_PROG_RUN(prog, ctx);
> +}
> +
> +int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat, u32 flags=
,
> +                u32 *retval, u32 *duration)
> +{
> +       return bpf_test_run_cb(prog, ctx, repeat, flags, run_bpf_prog, NU=
LL,
> +                              retval, duration);
> +}
> +
> +int bpf_test_run_cb(struct bpf_prog *prog, void *ctx, u32 repeat, u32 fl=
ags,
> +                   bpf_prog_run_helper_t run_prog, void *private_data,
> +                   u32 *retval, u32 *duration)
> +{
> +       struct bpf_cgroup_storage **storage =3D NULL;
> +       u64 time_start, time_spent =3D 0;
> +       int ret =3D 0;
> +       u32 i;
> +
> +       if (flags & BPF_TEST_RUN_SETUP_CGROUP_STORAGE) {
> +               storage =3D setup_cgroup_storage(prog);
> +               if (IS_ERR(storage))
> +                       return PTR_ERR(storage);
> +       }
> +
> +       if (!repeat)
> +               repeat =3D 1;
> +
> +       rcu_read_lock();
> +       preempt_disable();
> +       time_start =3D ktime_get_ns();
> +       for (i =3D 0; i < repeat; i++) {
> +               if (storage)
> +                       bpf_cgroup_storage_set(storage);
> +               *retval =3D run_prog(prog, ctx, private_data);
> +
> +               if (signal_pending(current)) {
> +                       preempt_enable();
> +                       rcu_read_unlock();
> +                       teardown_cgroup_storage(storage);
> +                       return -EINTR;
> +               }
> +
> +               if (need_resched()) {
> +                       time_spent +=3D ktime_get_ns() - time_start;
> +                       preempt_enable();
> +                       rcu_read_unlock();
> +
> +                       cond_resched();
> +
> +                       rcu_read_lock();
> +                       preempt_disable();
> +                       time_start =3D ktime_get_ns();
> +               }
> +       }
> +       time_spent +=3D ktime_get_ns() - time_start;
> +       preempt_enable();
> +       rcu_read_unlock();
> +
> +       do_div(time_spent, repeat);
> +       *duration =3D time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> +
> +       teardown_cgroup_storage(storage);
> +
> +       return ret;
> +}
> +
> +int bpf_test_finish(union bpf_attr __user *uattr, u32 retval, u32 durati=
on)
> +{
> +       if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval)))
> +               return -EFAULT;
> +       if (copy_to_user(&uattr->test.duration, &duration, sizeof(duratio=
n)))
> +               return -EFAULT;
> +       return 0;
> +}
> +
> +static void *bpf_receive_mem(u64 in, u32 in_size, u32 max_size)
> +{
> +       void __user *data_in =3D u64_to_user_ptr(in);
> +       void *data;
> +       int err;
> +
> +       if (!data_in && in_size)
> +               return ERR_PTR(-EINVAL);
> +       data =3D kzalloc(max_size, GFP_USER);
> +       if (!data)
> +               return ERR_PTR(-ENOMEM);
> +
> +       if (data_in) {
> +               err =3D bpf_check_uarg_tail_zero(data_in, max_size, in_si=
ze);
> +               if (err) {
> +                       kfree(data);
> +                       return ERR_PTR(err);
> +               }
> +
> +               in_size =3D min_t(u32, max_size, in_size);
> +               if (copy_from_user(data, data_in, in_size)) {
> +                       kfree(data);
> +                       return ERR_PTR(-EFAULT);
> +               }
> +       }
> +       return data;
> +}
> +
> +static int bpf_send_mem(u64 out, u32 out_size, u32 *out_size_write,
> +                        const void *data, u32 data_size)
> +{
> +       void __user *data_out =3D u64_to_user_ptr(out);
> +       int err =3D -EFAULT;
> +       u32 copy_size =3D data_size;
> +
> +       if (!data_out && out_size)
> +               return -EINVAL;
> +
> +       if (!data || !data_out)
> +               return 0;
> +
> +       if (copy_size > out_size) {
> +               copy_size =3D out_size;
> +               err =3D -ENOSPC;
> +       }
> +
> +       if (copy_to_user(data_out, data, copy_size))
> +               goto out;
> +       if (copy_to_user(out_size_write, &data_size, sizeof(data_size)))
> +               goto out;
> +       if (err !=3D -ENOSPC)
> +               err =3D 0;
> +out:
> +       return err;
> +}
> +
> +void *bpf_receive_data(const union bpf_attr *kattr, u32 max_size)
> +{
> +       return bpf_receive_mem(kattr->test.data_in, kattr->test.data_size=
_in,
> +                               max_size);
> +}
> +
> +int bpf_send_data(const union bpf_attr *kattr, union bpf_attr __user *ua=
ttr,
> +                  const void *data, u32 size)
> +{
> +       return bpf_send_mem(kattr->test.data_out, kattr->test.data_size_o=
ut,
> +                           &uattr->test.data_size_out, data, size);
> +}
> +
> +void *bpf_receive_ctx(const union bpf_attr *kattr, u32 max_size)
> +{
> +       return bpf_receive_mem(kattr->test.ctx_in, kattr->test.ctx_size_i=
n,
> +                               max_size);
> +}
> +
> +int bpf_send_ctx(const union bpf_attr *kattr, union bpf_attr __user *uat=
tr,
> +                 const void *data, u32 size)
> +{
> +        return bpf_send_mem(kattr->test.ctx_out, kattr->test.ctx_size_ou=
t,
> +                            &uattr->test.ctx_size_out, data, size);
> +}
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 80e6f3a6864d..fe6b7b1af0cc 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -14,97 +14,6 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/bpf_test_run.h>
>
> -static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
> -                       u32 *retval, u32 *time)
> -{
> -       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] =
=3D { NULL };
> -       enum bpf_cgroup_storage_type stype;
> -       u64 time_start, time_spent =3D 0;
> -       int ret =3D 0;
> -       u32 i;
> -
> -       for_each_cgroup_storage_type(stype) {
> -               storage[stype] =3D bpf_cgroup_storage_alloc(prog, stype);
> -               if (IS_ERR(storage[stype])) {
> -                       storage[stype] =3D NULL;
> -                       for_each_cgroup_storage_type(stype)
> -                               bpf_cgroup_storage_free(storage[stype]);
> -                       return -ENOMEM;
> -               }
> -       }
> -
> -       if (!repeat)
> -               repeat =3D 1;
> -
> -       rcu_read_lock();
> -       preempt_disable();
> -       time_start =3D ktime_get_ns();
> -       for (i =3D 0; i < repeat; i++) {
> -               bpf_cgroup_storage_set(storage);
> -               *retval =3D BPF_PROG_RUN(prog, ctx);
> -
> -               if (signal_pending(current)) {
> -                       ret =3D -EINTR;
> -                       break;
> -               }
> -
> -               if (need_resched()) {
> -                       time_spent +=3D ktime_get_ns() - time_start;
> -                       preempt_enable();
> -                       rcu_read_unlock();
> -
> -                       cond_resched();
> -
> -                       rcu_read_lock();
> -                       preempt_disable();
> -                       time_start =3D ktime_get_ns();
> -               }
> -       }
> -       time_spent +=3D ktime_get_ns() - time_start;
> -       preempt_enable();
> -       rcu_read_unlock();
> -
> -       do_div(time_spent, repeat);
> -       *time =3D time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> -
> -       for_each_cgroup_storage_type(stype)
> -               bpf_cgroup_storage_free(storage[stype]);
> -
> -       return ret;
> -}
> -
> -static int bpf_test_finish(const union bpf_attr *kattr,
> -                          union bpf_attr __user *uattr, const void *data=
,
> -                          u32 size, u32 retval, u32 duration)
> -{
> -       void __user *data_out =3D u64_to_user_ptr(kattr->test.data_out);
> -       int err =3D -EFAULT;
> -       u32 copy_size =3D size;
> -
> -       /* Clamp copy if the user has provided a size hint, but copy the =
full
> -        * buffer if not to retain old behaviour.
> -        */
> -       if (kattr->test.data_size_out &&
> -           copy_size > kattr->test.data_size_out) {
> -               copy_size =3D kattr->test.data_size_out;
> -               err =3D -ENOSPC;
> -       }
> -
> -       if (data_out && copy_to_user(data_out, data, copy_size))
> -               goto out;
> -       if (copy_to_user(&uattr->test.data_size_out, &size, sizeof(size))=
)
> -               goto out;
> -       if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval)))
> -               goto out;
> -       if (copy_to_user(&uattr->test.duration, &duration, sizeof(duratio=
n)))
> -               goto out;
> -       if (err !=3D -ENOSPC)
> -               err =3D 0;
> -out:
> -       trace_bpf_test_finish(&err);
> -       return err;
> -}
> -
>  static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
>                            u32 headroom, u32 tailroom)
>  {
> @@ -125,63 +34,6 @@ static void *bpf_test_init(const union bpf_attr *katt=
r, u32 size,
>         return data;
>  }
>
> -static void *bpf_ctx_init(const union bpf_attr *kattr, u32 max_size)
> -{
> -       void __user *data_in =3D u64_to_user_ptr(kattr->test.ctx_in);
> -       void __user *data_out =3D u64_to_user_ptr(kattr->test.ctx_out);
> -       u32 size =3D kattr->test.ctx_size_in;
> -       void *data;
> -       int err;
> -
> -       if (!data_in && !data_out)
> -               return NULL;
> -
> -       data =3D kzalloc(max_size, GFP_USER);
> -       if (!data)
> -               return ERR_PTR(-ENOMEM);
> -
> -       if (data_in) {
> -               err =3D bpf_check_uarg_tail_zero(data_in, max_size, size)=
;
> -               if (err) {
> -                       kfree(data);
> -                       return ERR_PTR(err);
> -               }
> -
> -               size =3D min_t(u32, max_size, size);
> -               if (copy_from_user(data, data_in, size)) {
> -                       kfree(data);
> -                       return ERR_PTR(-EFAULT);
> -               }
> -       }
> -       return data;
> -}
> -
> -static int bpf_ctx_finish(const union bpf_attr *kattr,
> -                         union bpf_attr __user *uattr, const void *data,
> -                         u32 size)
> -{
> -       void __user *data_out =3D u64_to_user_ptr(kattr->test.ctx_out);
> -       int err =3D -EFAULT;
> -       u32 copy_size =3D size;
> -
> -       if (!data || !data_out)
> -               return 0;
> -
> -       if (copy_size > kattr->test.ctx_size_out) {
> -               copy_size =3D kattr->test.ctx_size_out;
> -               err =3D -ENOSPC;
> -       }
> -
> -       if (copy_to_user(data_out, data, copy_size))
> -               goto out;
> -       if (copy_to_user(&uattr->test.ctx_size_out, &size, sizeof(size)))
> -               goto out;
> -       if (err !=3D -ENOSPC)
> -               err =3D 0;
> -out:
> -       return err;
> -}
> -
>  /**
>   * range_is_zero - test whether buffer is initialized
>   * @buf: buffer to check
> @@ -238,6 +90,36 @@ static void convert_skb_to___skb(struct sk_buff *skb,=
 struct __sk_buff *__skb)
>         memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
>  }
>
> +static int bpf_net_prog_test_run_finish(const union bpf_attr *kattr,
> +                                        union bpf_attr __user *uattr,
> +                                        const void *data, u32 data_size,
> +                                        const void *ctx, u32 ctx_size,
> +                                        u32 retval, u32 duration)
> +{
> +       int ret;
> +       union bpf_attr fixed_kattr;
> +       const union bpf_attr *kattr_ptr =3D kattr;
> +
> +       /* Clamp copy (in bpf_send_mem) if the user has provided a
> +        * size hint, but copy the full buffer if not to retain old
> +        * behaviour.
> +        */
> +       if (!kattr->test.data_size_out && kattr->test.data_out) {
> +               fixed_kattr =3D *kattr;
> +               fixed_kattr.test.data_size_out =3D U32_MAX;
> +               kattr_ptr =3D &fixed_kattr;
> +       }
> +
> +       ret =3D bpf_send_data(kattr_ptr, uattr, data, data_size);
> +       if (!ret) {
> +               ret =3D bpf_test_finish(uattr, retval, duration);
> +               if (!ret && ctx)
> +                       ret =3D bpf_send_ctx(kattr_ptr, uattr, ctx, ctx_s=
ize);
> +       }
> +       trace_bpf_test_finish(&ret);
> +       return ret;
> +}
> +
>  int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *k=
attr,
>                           union bpf_attr __user *uattr)
>  {
> @@ -257,7 +139,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
>         if (IS_ERR(data))
>                 return PTR_ERR(data);
>
> -       ctx =3D bpf_ctx_init(kattr, sizeof(struct __sk_buff));
> +       ctx =3D bpf_receive_ctx(kattr, sizeof(struct __sk_buff));
>         if (IS_ERR(ctx)) {
>                 kfree(data);
>                 return PTR_ERR(ctx);
> @@ -307,7 +189,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
>         ret =3D convert___skb_to_skb(skb, ctx);
>         if (ret)
>                 goto out;
> -       ret =3D bpf_test_run(prog, skb, repeat, &retval, &duration);
> +       ret =3D bpf_test_run(prog, skb, repeat, BPF_TEST_RUN_SETUP_CGROUP=
_STORAGE,
> +                          &retval, &duration);
>         if (ret)
>                 goto out;
>         if (!is_l2) {
> @@ -327,10 +210,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, con=
st union bpf_attr *kattr,
>         /* bpf program can never convert linear skb to non-linear */
>         if (WARN_ON_ONCE(skb_is_nonlinear(skb)))
>                 size =3D skb_headlen(skb);
> -       ret =3D bpf_test_finish(kattr, uattr, skb->data, size, retval, du=
ration);
> -       if (!ret)
> -               ret =3D bpf_ctx_finish(kattr, uattr, ctx,
> -                                    sizeof(struct __sk_buff));
> +       ret =3D bpf_net_prog_test_run_finish(kattr, uattr, skb->data, siz=
e,
> +                                          ctx, sizeof(struct __sk_buff),
> +                                          retval, duration);
>  out:
>         kfree_skb(skb);
>         bpf_sk_storage_free(sk);
> @@ -365,32 +247,48 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, co=
nst union bpf_attr *kattr,
>         rxqueue =3D __netif_get_rx_queue(current->nsproxy->net_ns->loopba=
ck_dev, 0);
>         xdp.rxq =3D &rxqueue->xdp_rxq;
>
> -       ret =3D bpf_test_run(prog, &xdp, repeat, &retval, &duration);
> +       ret =3D bpf_test_run(prog, &xdp, repeat,
> +                          BPF_TEST_RUN_SETUP_CGROUP_STORAGE,
> +                          &retval, &duration);
>         if (ret)
>                 goto out;
>         if (xdp.data !=3D data + XDP_PACKET_HEADROOM + NET_IP_ALIGN ||
>             xdp.data_end !=3D xdp.data + size)
>                 size =3D xdp.data_end - xdp.data;
> -       ret =3D bpf_test_finish(kattr, uattr, xdp.data, size, retval, dur=
ation);
> +       ret =3D bpf_net_prog_test_run_finish(kattr, uattr, xdp.data, size=
,
> +                                          NULL, 0, retval, duration);
>  out:
>         kfree(data);
>         return ret;
>  }
>
> +struct bpf_flow_dissect_run_data {
> +       __be16 proto;
> +       int nhoff;
> +       int hlen;
> +};
> +
> +static u32 bpf_flow_dissect_run(struct bpf_prog *prog, void *ctx,
> +                               void *private_data)
> +{
> +       struct bpf_flow_dissect_run_data *data =3D private_data;
> +
> +       return bpf_flow_dissect(prog, ctx, data->proto, data->nhoff, data=
->hlen);
> +}
> +
>  int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>                                      const union bpf_attr *kattr,
>                                      union bpf_attr __user *uattr)
>  {
> +       struct bpf_flow_dissect_run_data run_data =3D {};
>         u32 size =3D kattr->test.data_size_in;
>         struct bpf_flow_dissector ctx =3D {};
>         u32 repeat =3D kattr->test.repeat;
>         struct bpf_flow_keys flow_keys;
> -       u64 time_start, time_spent =3D 0;
>         const struct ethhdr *eth;
>         u32 retval, duration;
>         void *data;
>         int ret;
> -       u32 i;
>
>         if (prog->type !=3D BPF_PROG_TYPE_FLOW_DISSECTOR)
>                 return -EINVAL;
> @@ -407,49 +305,22 @@ int bpf_prog_test_run_flow_dissector(struct bpf_pro=
g *prog,
>
>         eth =3D (struct ethhdr *)data;
>
> -       if (!repeat)
> -               repeat =3D 1;
> -
>         ctx.flow_keys =3D &flow_keys;
>         ctx.data =3D data;
>         ctx.data_end =3D (__u8 *)data + size;
>
> -       rcu_read_lock();
> -       preempt_disable();
> -       time_start =3D ktime_get_ns();
> -       for (i =3D 0; i < repeat; i++) {
> -               retval =3D bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH=
_HLEN,
> -                                         size);
> -
> -               if (signal_pending(current)) {
> -                       preempt_enable();
> -                       rcu_read_unlock();
> -
> -                       ret =3D -EINTR;
> -                       goto out;
> -               }
> -
> -               if (need_resched()) {
> -                       time_spent +=3D ktime_get_ns() - time_start;
> -                       preempt_enable();
> -                       rcu_read_unlock();
> -
> -                       cond_resched();
> -
> -                       rcu_read_lock();
> -                       preempt_disable();
> -                       time_start =3D ktime_get_ns();
> -               }
> -       }
> -       time_spent +=3D ktime_get_ns() - time_start;
> -       preempt_enable();
> -       rcu_read_unlock();
> -
> -       do_div(time_spent, repeat);
> -       duration =3D time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> +       run_data.proto =3D eth->h_proto;
> +       run_data.nhoff =3D ETH_HLEN;
> +       run_data.hlen =3D size;
> +       ret =3D bpf_test_run_cb(prog, &ctx, repeat, BPF_TEST_RUN_PLAIN,
> +                             bpf_flow_dissect_run, &run_data,
> +                             &retval, &duration);
> +       if (!ret)
> +               goto out;
>
> -       ret =3D bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_key=
s),
> -                             retval, duration);
> +       ret =3D bpf_net_prog_test_run_finish(kattr, uattr, &flow_keys,
> +                                          sizeof(flow_keys), NULL, 0,
> +                                          retval, duration);
>
>  out:
>         kfree(data);
> --
> 2.20.1
>


--=20
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago L=
=C3=B3pez Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
