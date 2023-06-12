Return-Path: <netdev+bounces-10155-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30FAD72C92B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD4F6280EF4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211C51C747;
	Mon, 12 Jun 2023 15:01:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874C2AD38
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4EFC433A1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686582111;
	bh=b9ANP3Hp1MF8lhPj5vX8FwH4gFUxMf9AygCj2ueMZLQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HwN9Ri5e8hxCA95hxfZZYGCL/wmVMSl6sAifLYWuFgTOTQ39S8LMHkRKX85RjlMr8
	 fk3YkqyuYlNR/NIr2ArOm8B8YZJTvgRUpqaO3zAPLC89YxPxxeJf7kHeWgWXnmMoKR
	 EVbMPMHjQIsH7iD1BOvD4Fs7ZbO3W6ouJHkq2Wd7pvr5WR4Ep4xju2TnfJ+RPPNALD
	 IYJ4Dan+O8HPs8PcSpBP1XOzoPoAvsjLrI4qW+a58RKGN6jWe1reTUQEJfRVuZotOW
	 9h/dZ8HfyBFk8+L7k8umrep/mTyGeaz5SZ5MngVXo0vv9v/UsxbNlG7R0uVAYstTFd
	 BAexUD0YD+7rA==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-51640b9ed95so7834839a12.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:01:50 -0700 (PDT)
X-Gm-Message-State: AC+VfDzmJ14KIZi022c36ODDP9Hje4UWLR4R6m6gXoiZEqNeS9GQw2js
	H8Fp2nUcTB2MyCx7L10A9TuF3mqTS+rqK+xJxZRyvA==
X-Google-Smtp-Source: ACHHUZ4NwpHBk4WiP9cW5gQV9nUavflhEpxk5+JEUepLjBFLDP6rLijhmwW+f3KnzKbFAwSkCD3lPdu8bgmYZg02v3M=
X-Received: by 2002:aa7:c489:0:b0:516:459d:d912 with SMTP id
 m9-20020aa7c489000000b00516459dd912mr4799830edq.28.1686582109044; Mon, 12 Jun
 2023 08:01:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230610152618.105518-1-clangllvm@126.com>
In-Reply-To: <20230610152618.105518-1-clangllvm@126.com>
From: KP Singh <kpsingh@kernel.org>
Date: Mon, 12 Jun 2023 17:01:38 +0200
X-Gmail-Original-Message-ID: <CACYkzJ5JwUt7vvOe3bEnaTErYdcp9D4EwEfOdc63Ck196ZynAg@mail.gmail.com>
Message-ID: <CACYkzJ5JwUt7vvOe3bEnaTErYdcp9D4EwEfOdc63Ck196ZynAg@mail.gmail.com>
Subject: Re: [PATCH] Add a sysctl option to disable bpf offensive helpers.
To: Yi He <clangllvm@126.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, song@kernel.org, 
	yhs@fb.com, john.fastabend@gmail.com, sdf@google.com, haoluo@google.com, 
	jolsa@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org, 
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 10, 2023 at 5:46=E2=80=AFPM Yi He <clangllvm@126.com> wrote:
>
> Some eBPF helper functions have been long regarded as problematic[1].
> More than just used for powerful rootkit, these features can also be
> exploited to harm the containers by perform various attacks to the
> processes outside the container in the enrtire VM, such as process
> DoS, information theft, and container escape.
>
> When a container is granted to run eBPF tracing programs (which
> need CAP_SYS_ADMIN), it can use the eBPF KProbe programs to hijack the
> process outside the contianer and to escape the containers. This kind
> of risks is limited as privieleged containers are warned and can hardly
>  be accessed by the attackers.
>
> Even without CAP_SYS_ADMIN, since Linux 5.6, programs with CAP_BPF +
> CAP_PERFMON can use dangerous eBPF helpers such as bpf_read_user to steal
> sensitive data (e.g., sshd/nginx private key) in other containers.
>
> Currently, eBPF users just enable CAP_SYS_ADMIN and also enable the
> offensive features. Since lots of eBPF tools are distributed via
> containers, attackers may perform supply chain attacks to create and

I don't understand "supply chain" here.

> spread their eBPF malware, To prevent the abuse of these helpers, we

Are you saying attackers will provide BPF programs that will be loaded
in privileged contexts (e.g. privileged containers)? Please understand
that this threat model does not hold well. Even without these helpers
a CAP_BPF + CAP_PERFMON container is a part of your trusted compute
base and needs to run trusted code.

> introduce a new sysctl option (sysctl_offensive_bpf_disabled) to
> cofine the usages of five dangerous helpers:
> - bpf_probe_write_user
> - bpf_probe_read_user
> - bpf_probe_read_kernel
> - bpf_send_signal
> - bpf_override_return
>
> The default value of sysctl_offensive_bpf_disabled is 0, which means
> all the five helpers are enabled. By setting sysctl_offensive_bpf_disable=
d
> to 1, these helpers cannot be used util a reboot. By setting it to 2,
> these helpers cannot be used but privieleged users can modify this flag
> to 0.
>
> For benign eBPF programs such as Cillium, they do not need these features
> and can set the sysctl_offensive_bpf_disabled to 1 after initialization.

Again, a container running Cilium needs to only run trusted code.
What's the threat model here? There are components in the cilium
container that are attacker controlled?

>
>
> [1] https://embracethered.com/blog/posts/2021/offensive-bpf/
>
>
> Signed-off-by: Yi He <clangllvm@126.com>
> ---
>  include/linux/bpf.h                       |  2 ++
>  kernel/bpf/syscall.c                      | 33 +++++++++++++++++++++++
>  kernel/configs/android-recommended.config |  1 +
>  kernel/trace/bpf_trace.c                  | 21 ++++++++-------
>  tools/testing/selftests/bpf/config        |  1 +
>  5 files changed, 48 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 456f33b9d205..61c723a589f8 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2043,6 +2043,8 @@ bpf_map_alloc_percpu(const struct bpf_map *map, siz=
e_t size, size_t align,
>
>  extern int sysctl_unprivileged_bpf_disabled;
>
> +extern int sysctl_offensive_bpf_disabled;
> +
>  static inline bool bpf_allow_ptr_leaks(void)
>  {
>         return perfmon_capable();
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 14f39c1e573e..6b8c8ee1ea22 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -58,6 +58,9 @@ static DEFINE_SPINLOCK(link_idr_lock);
>  int sysctl_unprivileged_bpf_disabled __read_mostly =3D
>         IS_BUILTIN(CONFIG_BPF_UNPRIV_DEFAULT_OFF) ? 2 : 0;
>
> +int sysctl_offensive_bpf_disabled __read_mostly =3D
> +       IS_BUILTIN(CONFIG_BPF_OFFENSIVE_BPF_OFF) ? 2 : 0;
> +
>  static const struct bpf_map_ops * const bpf_map_types[] =3D {
>  #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
>  #define BPF_MAP_TYPE(_id, _ops) \
> @@ -5385,6 +5388,27 @@ static int bpf_unpriv_handler(struct ctl_table *ta=
ble, int write,
>         return ret;
>  }
>
> +static int bpf_offensive_handler(struct ctl_table *table, int write,
> +                             void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +       int ret, offensive_enable =3D *(int *)table->data;
> +       bool locked_state =3D offensive_enable =3D=3D 1;
> +       struct ctl_table tmp =3D *table;
> +
> +       if (write && !capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       tmp.data =3D &offensive_enable;
> +       ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> +       if (write && !ret) {
> +               if (locked_state && offensive_enable !=3D 1)
> +                       return -EPERM;
> +               *(int *)table->data =3D offensive_enable;
> +       }
> +
> +       return ret;
> +}
> +
>  static struct ctl_table bpf_syscall_table[] =3D {
>         {
>                 .procname       =3D "unprivileged_bpf_disabled",
> @@ -5395,6 +5419,15 @@ static struct ctl_table bpf_syscall_table[] =3D {
>                 .extra1         =3D SYSCTL_ZERO,
>                 .extra2         =3D SYSCTL_TWO,
>         },
> +       {
> +               .procname       =3D "offensive_bpf_disabled",
> +               .data           =3D &sysctl_offensive_bpf_disabled,
> +               .maxlen         =3D sizeof(sysctl_offensive_bpf_disabled)=
,
> +               .mode           =3D 0644,
> +               .proc_handler   =3D bpf_offensive_handler,
> +               .extra1         =3D SYSCTL_ZERO,
> +               .extra2         =3D SYSCTL_TWO,
> +       },
>         {
>                 .procname       =3D "bpf_stats_enabled",
>                 .data           =3D &bpf_stats_enabled_key.key,
> diff --git a/kernel/configs/android-recommended.config b/kernel/configs/a=
ndroid-recommended.config
> index e400fbbc8aba..cca75258af72 100644
> --- a/kernel/configs/android-recommended.config
> +++ b/kernel/configs/android-recommended.config
> @@ -1,5 +1,6 @@
>  #  KEEP ALPHABETICALLY SORTED
>  # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
> +# CONFIG_BPF_OFFENSIVE_BPF_OFF is not set
>  # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
>  # CONFIG_INPUT_MOUSE is not set
>  # CONFIG_LEGACY_PTYS is not set
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 8deb22a99abe..5bdd0bee3e45 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1432,17 +1432,18 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
>         case BPF_FUNC_get_prandom_u32:
>                 return &bpf_get_prandom_u32_proto;
>         case BPF_FUNC_probe_write_user:
> -               return security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0 =
?
> -                      NULL : bpf_get_probe_write_proto();
> +               return (security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0=
 ||
> +                      sysctl_offensive_bpf_disabled) ? NULL : bpf_get_pr=
obe_write_proto();
>         case BPF_FUNC_probe_read_user:
> -               return &bpf_probe_read_user_proto;
> +               return sysctl_offensive_bpf_disabled ? NULL : &bpf_probe_=
read_user_proto;
>         case BPF_FUNC_probe_read_kernel:
> -               return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0=
 ?
> -                      NULL : &bpf_probe_read_kernel_proto;
> +               return (security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < =
0 ||
> +                      sysctl_offensive_bpf_disabled) ? NULL : &bpf_probe=
_read_kernel_proto;
>         case BPF_FUNC_probe_read_user_str:
> -               return &bpf_probe_read_user_str_proto;
> +               return sysctl_offensive_bpf_disabled ? NULL : &bpf_probe_=
read_user_str_proto;
>         case BPF_FUNC_probe_read_kernel_str:
> -               return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0=
 ?
> +               return (security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < =
0 ||
> +                      sysctl_offensive_bpf_disabled) ?
>                        NULL : &bpf_probe_read_kernel_str_proto;
>  #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>         case BPF_FUNC_probe_read:
> @@ -1459,9 +1460,9 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
>                 return &bpf_cgrp_storage_delete_proto;
>  #endif
>         case BPF_FUNC_send_signal:
> -               return &bpf_send_signal_proto;
> +               return sysctl_offensive_bpf_disabled ? NULL : &bpf_send_s=
ignal_proto;
>         case BPF_FUNC_send_signal_thread:
> -               return &bpf_send_signal_thread_proto;
> +               return sysctl_offensive_bpf_disabled ? NULL : &bpf_send_s=
ignal_thread_proto;
>         case BPF_FUNC_perf_event_read_value:
>                 return &bpf_perf_event_read_value_proto;
>         case BPF_FUNC_get_ns_current_pid_tgid:
> @@ -1527,7 +1528,7 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
>                 return &bpf_get_stack_proto;
>  #ifdef CONFIG_BPF_KPROBE_OVERRIDE
>         case BPF_FUNC_override_return:
> -               return &bpf_override_return_proto;
> +               return sysctl_offensive_bpf_disabled ? NULL : &bpf_overri=
de_return_proto;
>  #endif
>         case BPF_FUNC_get_func_ip:
>                 return prog->expected_attach_type =3D=3D BPF_TRACE_KPROBE=
_MULTI ?
> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests=
/bpf/config
> index 63cd4ab70171..1a15d7451f19 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config
> @@ -9,6 +9,7 @@ CONFIG_BPF_LSM=3Dy
>  CONFIG_BPF_STREAM_PARSER=3Dy
>  CONFIG_BPF_SYSCALL=3Dy
>  # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
> +# CONFIG_BPF_OFFENSIVE_BPF_OFF is not set
>  CONFIG_CGROUP_BPF=3Dy
>  CONFIG_CRYPTO_HMAC=3Dy
>  CONFIG_CRYPTO_SHA256=3Dy
> --
> 2.34.1
>

