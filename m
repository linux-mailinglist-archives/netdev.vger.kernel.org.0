Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7171E7838
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgE2IZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2IZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:25:18 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3082C03E969;
        Fri, 29 May 2020 01:25:17 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e16so1317126qtg.0;
        Fri, 29 May 2020 01:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YoEtSFtBP8cGgUk4ff4iMksAHYwJIZX+5j+0p/D2W5E=;
        b=VGoGOF09UmUSn/n2IWmzqTJ3saiIDNvRBnJflQdAdcZBpJjLa8prd9QUNpVVSFCZ7M
         8zHBJfdw1MqsqC7PtFidFCmFsatMVEIz7pcSjUzJ7jq2qdoR1cIanFIlwtGYksE/vfyV
         Jx/oHaCX95V/nyVk6naUDN8DuuFnjmGmMWR47qIGq4PKlKhQS1QeUB1i8upHfqBPovEV
         afIv4U/1Wc4vMzfhlAqwM6bgrDW9Nm/1DwPI6Y9MgK9u0s60ZqcPtiJRQFTk0lnXWLLP
         9r/1r0SOJ7ofk9gCC+Axs/Hi/ovbENLKQtnU5OEX5C1COMOY0e5k7nFiT41bJtNURVEz
         bojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YoEtSFtBP8cGgUk4ff4iMksAHYwJIZX+5j+0p/D2W5E=;
        b=Sot6n64NtIHQ/QT+tP0WF1wgVrx7e+BL17T7zlre0/7UzdO9k/XECgxUlXNa5GUedE
         laPvndlQbJprA4R8iQ3qEJp34wVPf5P3rHczTIihUVQ66T60IRSH2xo1WgzvUN06uVa+
         k0zt1SLYbgdGlzLYPBWI3sIUzYXVeU50Un8BFzBNmglgGAZjxeCNNizts0DRIsWzWt+s
         /7RsrsHnCPTPbfWNY15a8Daom5jWXhPOTXzjK4JltybvboN80Hc4Q1m4iFkZ3DEzWGua
         miP+DOWb5q1sPXVmF4GiYJPujA3HPiHk4VrRwU/f7OAD4fw1PFJxKCCmmKjSKhSLl7B+
         zSwA==
X-Gm-Message-State: AOAM530nrPRzQZO5utQE3bSPO0Rcb1vYhdkRvRdj8Xy2REJMsXS0kayp
        o0kDafe1nwBc5wZUaxGzT2zVOYNePHf8LL0AiQo07ZtlCkEljw==
X-Google-Smtp-Source: ABdhPJw9EeJyvRcfn3HeWTbv2CPTets27BeLykiY4w0lT69sk+hfjYxRqCRQkXg1Mx8Z8p4Kxrg9Uo41xcr5wZaYKfI=
X-Received: by 2002:aed:3f3b:: with SMTP id p56mr7212828qtf.93.1590740716981;
 Fri, 29 May 2020 01:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200529043839.15824-1-alexei.starovoitov@gmail.com> <20200529043839.15824-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20200529043839.15824-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 May 2020 01:25:06 -0700
Message-ID: <CAEf4BzZXnqLwhJaUVKX0ExVa+Sw5mnhg5FLJN-VKPX59f6EAoQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: Introduce sleepable BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 9:39 PM Alexei Starovoitov
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
> should not be enclosed in migrate_disable() as well. Therefore bpf_srcu is used
> to protect the life time of sleepable progs.
>
> There are many networking and tracing program types. In many cases the
> 'struct bpf_prog *' pointer itself is rcu protected within some other kernel
> data structure and the kernel code is using rcu_dereference() to load that
> program pointer and call BPF_PROG_RUN() on it. All these cases are not touched.
> Instead sleepable bpf programs are allowed with bpf trampoline only. The
> program pointers are hard-coded into generated assembly of bpf trampoline and
> synchronize_srcu(&bpf_srcu) is used to protect the life time of the program.
> The same trampoline can hold both sleepable and non-sleepable progs.
>
> When bpf_srcu lock is held it means that some sleepable bpf program is running
> from bpf trampoline. Those programs can use bpf arrays and preallocated hash/lru
> maps. These map types are waiting on programs to complete via
> synchronize_srcu(&bpf_srcu);
>
> Updates to trampoline now has to do synchronize_srcu + synchronize_rcu_tasks
> to wait for sleepable progs to finish and for trampoline assembly to finish.
>
> In the future srcu will be replaced with upcoming rcu_trace.
> That will complete the first step of introducing sleepable progs.
>
> After that dynamically allocated hash maps can be allowed. All map elements
> would have to be srcu protected instead of normal rcu.
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
> Acked-by: KP Singh <kpsingh@google.com>
> ---
>  arch/x86/net/bpf_jit_comp.c    | 36 ++++++++++++++------
>  include/linux/bpf.h            |  4 +++
>  include/uapi/linux/bpf.h       |  8 +++++
>  kernel/bpf/arraymap.c          |  5 +++
>  kernel/bpf/hashtab.c           | 19 +++++++----
>  kernel/bpf/syscall.c           | 12 +++++--
>  kernel/bpf/trampoline.c        | 33 +++++++++++++++++-
>  kernel/bpf/verifier.c          | 62 +++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h |  8 +++++
>  9 files changed, 165 insertions(+), 22 deletions(-)
>

[...]

> +/* If BPF_F_SLEEPABLE is used in BPF_PROG_LOAD command, the verifier will
> + * restrict map and helper usage for such programs. Sleepable BPF programs can
> + * only be attached to hooks where kernel execution context allows sleeping.
> + * Such programs are allowed to use helpers that may sleep like
> + * bpf_copy_from_user().
> + */
> +#define BPF_F_SLEEPABLE                (1U << 4)
> +
>  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
>   * two extensions:
>   *
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 11584618e861..26b18b6a3dbc 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -393,6 +393,11 @@ static void array_map_free(struct bpf_map *map)
>          */
>         synchronize_rcu();
>
> +       /* arrays could have been used by both sleepable and non-sleepable bpf
> +        * progs. Make sure to wait for both prog types to finish executing.
> +        */
> +       synchronize_srcu(&bpf_srcu);
> +

to minimize churn later on when you switch to rcu_trace, maybe extract
synchronize_rcu() + synchronize_srcu(&bpf_srcu) into a function (e.g.,
something like synchronize_sleepable_bpf?), exposed as an internal
API? That way you also wouldn't need to add bpf_srcu to linux/bpf.h?

>         if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
>                 bpf_array_free_percpu(array);
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index b4b288a3c3c9..b001957fdcbf 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -577,8 +577,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
>         struct htab_elem *l;
>         u32 hash, key_size;
>
> -       /* Must be called with rcu_read_lock. */
> -       WARN_ON_ONCE(!rcu_read_lock_held());
> +       /* Must be called with s?rcu_read_lock. */
> +       WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
>

Similar to above, might be worthwhile extracting into a function?

>         key_size = map->key_size;
>
> @@ -935,7 +935,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
>                 /* unknown flags */
>                 return -EINVAL;
>
> -       WARN_ON_ONCE(!rcu_read_lock_held());
> +       WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
>
>         key_size = map->key_size;
>

[...]

>  static int check_attach_btf_id(struct bpf_verifier_env *env)
>  {
>         struct bpf_prog *prog = env->prog;
> @@ -10549,6 +10582,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>         long addr;
>         u64 key;
>
> +       if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
> +           prog->type != BPF_PROG_TYPE_LSM) {
> +               verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
> +               return -EINVAL;
> +       }


BPF_PROG_TYPE_TRACING also includes iterator and raw tracepoint
programs. You mention only fentry/fexit/fmod_ret are allowed. What
about those two? I don't see any explicit checks for iterator and
raw_tracepoint attach types in a switch below, so just checking if
they should be allowed to be sleepable?

Also seems like freplace ones are also sleeepable, if they replace
sleepable programs, right?

> +
>         if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
>                 return check_struct_ops_btf_id(env);
>
> @@ -10762,8 +10801,29 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>                         if (ret)
>                                 verbose(env, "%s() is not modifiable\n",
>                                         prog->aux->attach_func_name);
> +               } else if (prog->aux->sleepable) {
> +                       switch (prog->type) {
> +                       case BPF_PROG_TYPE_TRACING:
> +                               /* fentry/fexit progs can be sleepable only if they are
> +                                * attached to ALLOW_ERROR_INJECTION or security_*() funcs.
> +                                */
> +                               ret = check_attach_modify_return(prog, addr);

I was so confused about this piece... check_attach_modify_return()
should probably be renamed to something else, it's not for fmod_ret
only anymore.

> +                               if (!ret)
> +                                       ret = check_sleepable_blacklist(addr);
> +                               break;
> +                       case BPF_PROG_TYPE_LSM:
> +                               /* LSM progs check that they are attached to bpf_lsm_*() funcs
> +                                * which are sleepable too.
> +                                */
> +                               ret = check_sleepable_blacklist(addr);
> +                               break;
> +                       default:
> +                               break;
> +                       }
> +                       if (ret)
> +                               verbose(env, "%s is not sleepable\n",
> +                                       prog->aux->attach_func_name);
>                 }
> -
>                 if (ret)
>                         goto out;
>                 tr->func.addr = (void *)addr;

[...]
