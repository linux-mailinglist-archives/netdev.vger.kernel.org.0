Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A87920EABC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgF3BPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgF3BPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:15:53 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60897C061755;
        Mon, 29 Jun 2020 18:15:53 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id k18so17144173qke.4;
        Mon, 29 Jun 2020 18:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bluXrv2i9iRY9NcyhAJF7V1sF2baNdUR1fqtdj+ICac=;
        b=eaUHkyaXTMQMuAYCNYLWbSS1H1QXQucyCmSFbTjYh7dAlIXL3ZcYCs7Bez6CnWobx1
         U8KHz9BDLmgrKV6FDa2iCmhxPJwjTTKQ/zo4miQBzrx8jAnAGEc+uF+I0rtiDm0s7XBt
         sNnrS3XFEr5J2Nm4SjRZkP1iU8bBdg4djCJxvNEMuq7liD8Pu1xUs+PgoGoJeiyizJZK
         gT0DEs6R1+ufBzThDKCSh3C12a5x1sgASPKTchzM4EToHsdQog52piqoyg79wj+rj1DS
         vpcwpl2R8slQYoQZHKsheYORfaCMzfqrj0RFqKLyVZSQ8fCSGIUqjGseBqNglXmINrwO
         S43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bluXrv2i9iRY9NcyhAJF7V1sF2baNdUR1fqtdj+ICac=;
        b=Jw6HzXp62zbpHZi32kprk0f/YJPRuB8Mz1LrOp6lW8CBHGeRweT89y+hxChRFneJKT
         JVs+PQSNGxHWtTaJ3lYLxf6yz2wwFJrweuuaIOaX3qq0cdVzTETcox8IeFTW4LEwrI8k
         YybHRYsKjwad5skBzg3HXwH/JijIMSwI+4wvWhi/55f+fnkFtlMT0+AgKjiBn5o5mUgX
         8qFPFjipNy72ZrEsaDmLX6CXaAASuEQC6V8WleBethtYqFcOCpx9WM8p71/u0regK6gP
         91sD02ti3jevVykpwfr8wMeqbUY4/4ByFELHspKJyD8puuWL1s35RlpCr5cwayFTHsF4
         sPAw==
X-Gm-Message-State: AOAM531ouZU+ongDQQ9oRlr3ZbXjn0QTjZZiHq3whFFwZJpHhD+W4ThZ
        9lFAMnr3B5yS0Lrrv2Ow7Xz1U1jX4x0w2ginUxc=
X-Google-Smtp-Source: ABdhPJwWTyAB44Pht91Lxg8kP0ZRrFUyWrIkyTxCRNFpFBpjQdAeAMDiCiAkGJnhmGBeICCXrGjns5oF0rD+YRbpzr4=
X-Received: by 2002:a05:620a:1666:: with SMTP id d6mr17593699qko.449.1593479752371;
 Mon, 29 Jun 2020 18:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com> <20200630003441.42616-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20200630003441.42616-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 18:15:41 -0700
Message-ID: <CAEf4BzZPmtsJu8L42rMrFc3mW+h=a9ZPH_kR+dv35szi04Dz5g@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 5:35 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce sleepable BPF programs that can request such property for themselves
> via BPF_F_SLEEPABLE flag at program load time. In such case they will be able
> to use helpers like bpf_copy_from_user() that might sleep. At present only
> fentry/fexit/fmod_ret and lsm programs can request to be sleepable and only
> when they are attached to kernel functions that are known to allow sleeping.
>
> The non-sleepable programs are relying on implicit rcu_read_lock() and
> migrate_disable() to protect life time of programs, maps that they use and
> per-cpu kernel structures used to pass info between bpf programs and the
> kernel. The sleepable programs cannot be enclosed into rcu_read_lock().
> migrate_disable() maps to preempt_disable() in non-RT kernels, so the progs
> should not be enclosed in migrate_disable() as well. Therefore
> rcu_read_lock_trace is used to protect the life time of sleepable progs.
>
> There are many networking and tracing program types. In many cases the
> 'struct bpf_prog *' pointer itself is rcu protected within some other kernel
> data structure and the kernel code is using rcu_dereference() to load that
> program pointer and call BPF_PROG_RUN() on it. All these cases are not touched.
> Instead sleepable bpf programs are allowed with bpf trampoline only. The
> program pointers are hard-coded into generated assembly of bpf trampoline and
> synchronize_rcu_tasks_trace() is used to protect the life time of the program.
> The same trampoline can hold both sleepable and non-sleepable progs.
>
> When rcu_read_lock_trace is held it means that some sleepable bpf program is running
> from bpf trampoline. Those programs can use bpf arrays and preallocated hash/lru
> maps. These map types are waiting on programs to complete via
> synchronize_rcu_tasks_trace();
>
> Updates to trampoline now has to do synchronize_rcu_tasks_trace() and
> synchronize_rcu_tasks() to wait for sleepable progs to finish and for
> trampoline assembly to finish.
>
> This is the first step of introducing sleepable progs.
>
> After that dynamically allocated hash maps can be allowed. All map elements
> would have to be rcu_trace protected instead of normal rcu.
> per-cpu maps will be allowed. Either via the following pattern:
> void *elem = bpf_map_lookup_elem(map, key);
> if (elem) {
>    // access elem
>    bpf_map_release_elem(map, elem);
> }
> where modified lookup() helper will do migrate_disable() and
> new bpf_map_release_elem() will do corresponding migrate_enable().
> Or explicit bpf_migrate_disable/enable() helpers will be introduced.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  arch/x86/net/bpf_jit_comp.c    | 32 ++++++++++++------
>  include/linux/bpf.h            |  3 ++
>  include/uapi/linux/bpf.h       |  8 +++++
>  init/Kconfig                   |  1 +
>  kernel/bpf/arraymap.c          |  1 +
>  kernel/bpf/hashtab.c           | 12 +++----
>  kernel/bpf/syscall.c           | 13 +++++--
>  kernel/bpf/trampoline.c        | 33 ++++++++++++++++--
>  kernel/bpf/verifier.c          | 62 +++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h |  8 +++++
>  10 files changed, 149 insertions(+), 24 deletions(-)
>

[...]

> @@ -394,6 +406,21 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
>         rcu_read_unlock();
>  }
>
> +/* when rcu_read_lock_trace is held it means that some sleepable bpf program is
> + * running. Those programs can use bpf arrays and preallocated hash maps. These
> + * map types are waiting on programs to complete via
> + * synchronize_rcu_tasks_trace();

Wanted to leave comment that "map types are waiting" is outdated after
patch #1 and then recalled map-in-map complexities. So depending if
I'm right or wrong regarding issue in patch #1, this would stay or has
to be removed.

> + */
> +void notrace __bpf_prog_enter_sleepable(void)
> +{
> +       rcu_read_lock_trace();
> +}
> +
> +void notrace __bpf_prog_exit_sleepable(void)
> +{
> +       rcu_read_unlock_trace();
> +}
> +
>  int __weak
>  arch_prepare_bpf_trampoline(void *image, void *image_end,
>                             const struct btf_func_model *m, u32 flags,
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7de98906ddf4..05aa990ba9a4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9112,6 +9112,23 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
>                 return -EINVAL;
>         }
>
> +       if (prog->aux->sleepable)
> +               switch (map->map_type) {
> +               case BPF_MAP_TYPE_HASH:
> +               case BPF_MAP_TYPE_LRU_HASH:
> +               case BPF_MAP_TYPE_ARRAY:
> +                       if (!is_preallocated_map(map)) {
> +                               verbose(env,
> +                                       "Sleepable programs can only use preallocated hash maps\n");
> +                               return -EINVAL;
> +                       }
> +                       break;
> +               default:
> +                       verbose(env,
> +                               "Sleepable programs can only use array and hash maps\n");

nit: message is a bit misleading. per-cpu array is also an array, yet
is not supported.

> +                       return -EINVAL;
> +               }
> +
>         return 0;
>  }
>
> @@ -10722,6 +10739,22 @@ static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
>         return -EINVAL;
>  }
>

[...]
