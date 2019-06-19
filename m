Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5C84C046
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfFSRuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:50:01 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42052 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfFSRt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:49:57 -0400
Received: by mail-io1-f66.google.com with SMTP id u19so446095ior.9
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bmLaCWt5UCH3YXBEmMBN+/+tS5kXmSuF3wP3XuQD49w=;
        b=GW8nrYT3hnch00JV9geW9v2U4EcUTvUQqklHcdGkMTDPjwLHjXTK+HUjpkyElUcNAk
         Y+n5/o4kr/7NCjPzCvCy89PdWWHg6QOvAF8jHkuseDTySqOD0/C7HUbj3C1crVGHOYEw
         Fc+xbJ39sZVfYhKiqg5gfyC3WfzsBc2p3EdSCKrZIcPsjfZbPqkABDOHCGGEZFIDYPRR
         eNshs+1zPIF8a3zxs3arBF2f0k+WsGGr6lbIOiU9QakQqDIBnkBxOxjcrOv7s+KPcstA
         VXtXwri7RLydgiJlnmCWk6LQnbm0NARUbURfQwEeRRL8wg5RBdU/3OoaML59AatSPrvx
         LWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bmLaCWt5UCH3YXBEmMBN+/+tS5kXmSuF3wP3XuQD49w=;
        b=WZGAxSW+QA2S8s1q0g6qkJ35R1Kvp42GGzt4zeYKgfl7cYscar0yqoR5zLFN7jHHHc
         aA0zFernPPVTy3LcMdEK8CKArYw58fpS1bbGSqcj11tTvJeaXD/NRNFI7t/FRH1QUqry
         x0eco7aGrZ1BEwcF56BNuNouk9rydRKJktgVFAWjpneyNms9U2vHVKIQKBoj66D0Lm8I
         XOj4knQe2MMrO5V2j7jYHlynZv4rSS2M65oRiimE9jXnlmXxk3HLZ5EsDl4mNnnNPbRh
         +lKxF6h4QvYmVwPOswaBba1HFMxzF02GK0WJnKHgsBnil8oXrnsghSY5A7uT7NrX+rR8
         uquA==
X-Gm-Message-State: APjAAAWxihTOLd5Z/95F9FfPsU6RS3kbMd7UuGeon3KBz9lKIBtyEg/b
        QFWnqFkJaJHpow2BzgEA5+gZZkw819JS7pWN5LCEwg==
X-Google-Smtp-Source: APXvYqyDXf/rLJTkinFSKjWI6OcHc6C9BZFfI9H7BwpF2w1mPjKjkIm8Usoy8JL2pmtWWwahcBfnYN5wjzXSEAmulIg=
X-Received: by 2002:a6b:7d49:: with SMTP id d9mr24556639ioq.50.1560966595680;
 Wed, 19 Jun 2019 10:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190617150024.11787-1-leo.yan@linaro.org>
In-Reply-To: <20190617150024.11787-1-leo.yan@linaro.org>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Wed, 19 Jun 2019 11:49:44 -0600
Message-ID: <CANLsYkyMW=WG+=yWTLSyMT3JXqd_2kvsrx9c-EwCoKEnRZvErA@mail.gmail.com>
Subject: Re: [PATCH] perf cs-etm: Improve completeness for kernel address space
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Coresight ML <coresight@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leo,

On Mon, 17 Jun 2019 at 09:00, Leo Yan <leo.yan@linaro.org> wrote:
>
> Arm and arm64 architecture reserve some memory regions prior to the
> symbol '_stext' and these memory regions later will be used by device
> module and BPF jit.  The current code misses to consider these memory
> regions thus any address in the regions will be taken as user space
> mode, but perf cannot find the corresponding dso with the wrong CPU
> mode so we misses to generate samples for device module and BPF
> related trace data.
>
> This patch parse the link scripts to get the memory size prior to start
> address and reduce this size from 'etmq->etm->kernel_start', then can
> get a fixed up kernel start address which contain memory regions for
> device module and BPF.  Finally, cs_etm__cpu_mode() can return right
> mode for these memory regions and perf can successfully generate
> samples.
>
> The reason for parsing the link scripts is Arm architecture changes text
> offset dependent on different platforms, which define multiple text
> offsets in $kernel/arch/arm/Makefile.  This offset is decided when build
> kernel and the final value is extended in the link script, so we can
> extract the used value from the link script.  We use the same way to
> parse arm64 link script as well.  If fail to find the link script, the
> pre start memory size is assumed as zero, in this case it has no any
> change caused with this patch.
>
> Below is detailed info for testing this patch:
>
> - Build LLVM/Clang 8.0 or later version;
>
> - Configure perf with ~/.perfconfig:
>
>   root@debian:~# cat ~/.perfconfig
>   # this file is auto-generated.
>   [llvm]
>           clang-path =3D /mnt/build/llvm-build/build/install/bin/clang
>           kbuild-dir =3D /mnt/linux-kernel/linux-cs-dev/
>           clang-opt =3D "-DLINUX_VERSION_CODE=3D0x50200 -g"
>           dump-obj =3D true
>
>   [trace]
>           show_zeros =3D yes
>           show_duration =3D no
>           no_inherit =3D yes
>           show_timestamp =3D no
>           show_arg_names =3D no
>           args_alignment =3D 40
>           show_prefix =3D yes
>
> - Run 'perf trace' command with eBPF event:
>
>   root@debian:~# perf trace -e string \
>       -e $kernel/tools/perf/examples/bpf/augmented_raw_syscalls.c
>
> - Read eBPF program memory mapping in kernel:
>
>   root@debian:~# echo 1 > /proc/sys/net/core/bpf_jit_kallsyms
>   root@debian:~# cat /proc/kallsyms | grep -E "bpf_prog_.+_sys_[enter|exi=
t]"
>   ffff000000086a84 t bpf_prog_f173133dc38ccf87_sys_enter  [bpf]
>   ffff000000088618 t bpf_prog_c1bd85c092d6e4aa_sys_exit   [bpf]
>
> - Launch any program which accesses file system frequently so can hit
>   the system calls trace flow with eBPF event;
>
> - Capture CoreSight trace data with filtering eBPF program:
>
>   root@debian:~# perf record -e cs_etm/@20070000.etr/ \
>           --filter 'filter 0xffff000000086a84/0x800' -a sleep 5s
>
> - Annotate for symbol 'bpf_prog_f173133dc38ccf87_sys_enter':
>
>   root@debian:~# perf report
>   Then select 'branches' samples and press 'a' to annotate symbol
>   'bpf_prog_f173133dc38ccf87_sys_enter', press 'P' to print to the
>   bpf_prog_f173133dc38ccf87_sys_enter.annotation file:
>
>   root@debian:~# cat bpf_prog_f173133dc38ccf87_sys_enter.annotation
>
>   bpf_prog_f173133dc38ccf87_sys_enter() bpf_prog_f173133dc38ccf87_sys_ent=
er
>   Event: branches
>
>   Percent      int sys_enter(struct syscall_enter_args *args)
>                  stp  x29, x30, [sp, #-16]!
>
>                 int key =3D 0;
>                  mov  x29, sp
>
>                        augmented_args =3D bpf_map_lookup_elem(&augmented_=
filename_map, &key);
>                  stp  x19, x20, [sp, #-16]!
>
>                        augmented_args =3D bpf_map_lookup_elem(&augmented_=
filename_map, &key);
>                  stp  x21, x22, [sp, #-16]!
>
>                  stp  x25, x26, [sp, #-16]!
>
>                 return bpf_get_current_pid_tgid();
>                  mov  x25, sp
>
>                 return bpf_get_current_pid_tgid();
>                  mov  x26, #0x0                         // #0
>
>                  sub  sp, sp, #0x10
>
>                 return bpf_map_lookup_elem(pids, &pid) !=3D NULL;
>                  add  x19, x0, #0x0
>
>                  mov  x0, #0x0                          // #0
>
>                  mov  x10, #0xfffffffffffffff8          // #-8
>
>                 if (pid_filter__has(&pids_filtered, getpid()))
>                  str  w0, [x25, x10]
>
>                 probe_read(&augmented_args->args, sizeof(augmented_args->=
args), args);
>                  add  x1, x25, #0x0
>
>                 probe_read(&augmented_args->args, sizeof(augmented_args->=
args), args);
>                  mov  x10, #0xfffffffffffffff8          // #-8
>
>                 syscall =3D bpf_map_lookup_elem(&syscalls, &augmented_arg=
s->args.syscall_nr);
>                  add  x1, x1, x10
>
>                 syscall =3D bpf_map_lookup_elem(&syscalls, &augmented_arg=
s->args.syscall_nr);
>                  mov  x0, #0xffff8009ffffffff           // #-140694538682=
369
>
>                  movk x0, #0x6698, lsl #16
>
>                  movk x0, #0x3e00
>
>                  mov  x10, #0xffffffffffff1040          // #-61376
>
>                 if (syscall =3D=3D NULL || !syscall->enabled)
>                  movk x10, #0x1023, lsl #16
>
>                 if (syscall =3D=3D NULL || !syscall->enabled)
>                  movk x10, #0x0, lsl #32
>
>                 loop_iter_first()
>     3.69       =E2=86=92 blr  bpf_prog_f173133dc38ccf87_sys_enter
>                 loop_iter_first()
>                  add  x7, x0, #0x0
>
>                 loop_iter_first()
>                  add  x20, x7, #0x0
>
>                 int size =3D probe_read_str(&augmented_filename->value, f=
ilename_len, filename_arg);
>                  mov  x0, #0x1                          // #1
>
>   [...]
>
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
> Cc: coresight@lists.linaro.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/perf/Makefile.config | 24 ++++++++++++++++++++++++
>  tools/perf/util/cs-etm.c   | 26 +++++++++++++++++++++++++-
>  2 files changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 51dd00f65709..4776c2c1fb6d 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -418,6 +418,30 @@ ifdef CORESIGHT
>      endif
>      LDFLAGS +=3D $(LIBOPENCSD_LDFLAGS)
>      EXTLIBS +=3D $(OPENCSDLIBS)
> +    ifneq ($(wildcard $(srctree)/arch/arm64/kernel/vmlinux.lds),)
> +      # Extract info from lds:
> +      #  . =3D ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)=
) + (0x08000000))) + (0x08000000))) + 0x00080000;
> +      # ARM64_PRE_START_SIZE :=3D (0x08000000 + 0x08000000 + 0x00080000)
> +      ARM64_PRE_START_SIZE :=3D $(shell egrep ' \. \=3D \({8}0x[0-9a-fA-=
F]+\){2}' \
> +        $(srctree)/arch/arm64/kernel/vmlinux.lds | \
> +        sed -e 's/[(|)|.|=3D|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//=
' | \
> +        awk -F' ' '{print "("$$6 "+"  $$7 "+" $$8")"}' 2>/dev/null)
> +    else
> +      ARM64_PRE_START_SIZE :=3D 0
> +    endif
> +    CFLAGS +=3D -DARM64_PRE_START_SIZE=3D"$(ARM64_PRE_START_SIZE)"
> +    ifneq ($(wildcard $(srctree)/arch/arm/kernel/vmlinux.lds),)
> +      # Extract info from lds:
> +      #   . =3D ((0xC0000000)) + 0x00208000;
> +      # ARM_PRE_START_SIZE :=3D 0x00208000
> +      ARM_PRE_START_SIZE :=3D $(shell egrep ' \. \=3D \({2}0x[0-9a-fA-F]=
+\){2}' \
> +        $(srctree)/arch/arm/kernel/vmlinux.lds | \
> +        sed -e 's/[(|)|.|=3D|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//=
' | \
> +        awk -F' ' '{print "("$$2")"}' 2>/dev/null)
> +    else
> +      ARM_PRE_START_SIZE :=3D 0
> +    endif
> +    CFLAGS +=3D -DARM_PRE_START_SIZE=3D"$(ARM_PRE_START_SIZE)"
>      $(call detected,CONFIG_LIBOPENCSD)
>      ifdef CSTRACE_RAW
>        CFLAGS +=3D -DCS_DEBUG_RAW
> diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> index 0c7776b51045..ae831f836c70 100644
> --- a/tools/perf/util/cs-etm.c
> +++ b/tools/perf/util/cs-etm.c
> @@ -613,10 +613,34 @@ static void cs_etm__free(struct perf_session *sessi=
on)
>  static u8 cs_etm__cpu_mode(struct cs_etm_queue *etmq, u64 address)
>  {
>         struct machine *machine;
> +       u64 fixup_kernel_start =3D 0;
> +       const char *arch;
>
>         machine =3D etmq->etm->machine;
> +       arch =3D perf_env__arch(machine->env);
>
> -       if (address >=3D etmq->etm->kernel_start) {
> +       /*
> +        * Since arm and arm64 specify some memory regions prior to
> +        * 'kernel_start', kernel addresses can be less than 'kernel_star=
t'.
> +        *
> +        * For arm architecture, the 16MB virtual memory space prior to
> +        * 'kernel_start' is allocated to device modules, a PMD table if
> +        * CONFIG_HIGHMEM is enabled and a PGD table.
> +        *
> +        * For arm64 architecture, the root PGD table, device module memo=
ry
> +        * region and BPF jit region are prior to 'kernel_start'.
> +        *
> +        * To reflect the complete kernel address space, compensate these
> +        * pre-defined regions for kernel start address.
> +        */
> +       if (!strcmp(arch, "arm64"))
> +               fixup_kernel_start =3D etmq->etm->kernel_start -
> +                                    ARM64_PRE_START_SIZE;
> +       else if (!strcmp(arch, "arm"))
> +               fixup_kernel_start =3D etmq->etm->kernel_start -
> +                                    ARM_PRE_START_SIZE;

I will test your work but from a quick look wouldn't it be better to
have a single define name here?  From looking at the modifications you
did to Makefile.config there doesn't seem to be a reason to have two.

Thanks,
Mathieu

> +
> +       if (address >=3D fixup_kernel_start) {
>                 if (machine__is_host(machine))
>                         return PERF_RECORD_MISC_KERNEL;
>                 else
> --
> 2.17.1
>
