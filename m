Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7046274D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391062AbfGHReM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:34:12 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35822 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729791AbfGHReL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 13:34:11 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so27640905ioo.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 10:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E09i/YUwdjXE+zo+DlBVwd0NYopalsR3eUNo0Jmptng=;
        b=VgimgcdvvuaagysekxqyiAFNn6FzQEgkoEVZR6OnGOhGuHCDV3YPYViEL8XFMnFO30
         34dU9OQXaAiYdl0GJZGXDj7KCI/cC16xjW6duojoMXWMPxbb3OLrgmDyHg8OM4GO8fyo
         cHZpir4Q4OMZMfqKSIaIWtXU0TCeLIZnCII8JOO4yiQ4/yG/7p+N0kVjxjeTB6eayIDq
         mq5vmZaivs4zREBp4jV3fDnvgiXgD5Ug75N8g5dbWmUTp4c96uqeEZhwHWfH9Sg1/H7D
         Jc1KkAckFKRk6amhbaqu1uz/Xji3ykKJ2frePRYLM0V6/GJL2X02zbh8lzpG5kFA/IX5
         329w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E09i/YUwdjXE+zo+DlBVwd0NYopalsR3eUNo0Jmptng=;
        b=sN/YBFvaFD4FZhpUyCubtg1OL2+I7aDX9pJ0EXejY3N7K97mrkk2ngmYyrwuumE9Ov
         y5dLImkMQai4xbhzBJjwAfVB+BPNEuw/GwEKdAUhF/Ek4GmuoR/0sWGOZGFh7iDqUkAn
         5Wc3Ubv8n4GSPyYWaRvnDcomogI4co54PjT0FdtzCmor4XGsqDUn4kmF78nllTugp9X7
         vaPI73oqvBFD9MopqEU+L516msFZENMY1GeUpjnsfiIMV9Fx5xyyH4SVRxpFIRg4Y+Gi
         7yWDznwldZMHfE5qNqtAJNKzORwy54gkUthU7GU1vtUIBnk7OXZsoyohF57z5PurX5ck
         /MIg==
X-Gm-Message-State: APjAAAU1FFEIRP3liue0D9zvlyMz7BIc7Pr5DcRUeIG0MtqJmW6MuyNX
        Hl2WoM0sw1n4v05D+kbuDaqWAxGoZ0GfAItjnUN2mQ==
X-Google-Smtp-Source: APXvYqwrTeFpeJfKhWrPqeVS2WnW9G1OY3V4ftQkqRCW+JMD3tb0Mg4O0PEkcMIIu8DZXDEe45lalIuI+L2dK3e1gQg=
X-Received: by 2002:a5d:8e08:: with SMTP id e8mr2766517iod.139.1562607250441;
 Mon, 08 Jul 2019 10:34:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190620034446.25561-1-leo.yan@linaro.org>
In-Reply-To: <20190620034446.25561-1-leo.yan@linaro.org>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Mon, 8 Jul 2019 11:33:59 -0600
Message-ID: <CANLsYkwjJ57RWEqS9suLm1+JKicG1LzcHtP8k5qTK1d7bw=1MA@mail.gmail.com>
Subject: Re: [PATCH v3] perf cs-etm: Improve completeness for kernel address space
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Coresight ML <coresight@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jun 2019 at 21:45, Leo Yan <leo.yan@linaro.org> wrote:
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
>           clang-opt =3D "-g"
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

I'm not sure all this information about annotation should be in the
changelog.  This patch is about being able to decode traces that
executed outside the current kernel addresse range and as such simply
using "perf report" or "perf script" successfully is enough to test
this set.  Any information that goes beyond that muddies the water.

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
>  tools/perf/Makefile.config | 22 ++++++++++++++++++++++
>  tools/perf/util/cs-etm.c   | 19 ++++++++++++++++++-
>  2 files changed, 40 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 51dd00f65709..a58cd5a43a98 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -418,6 +418,28 @@ ifdef CORESIGHT
>      endif
>      LDFLAGS +=3D $(LIBOPENCSD_LDFLAGS)
>      EXTLIBS +=3D $(OPENCSDLIBS)
> +    PRE_START_SIZE :=3D 0
> +    ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
> +      ifeq ($(SRCARCH),arm64)
> +        # Extract info from lds:
> +        #  . =3D ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (=
0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
> +        # PRE_START_SIZE :=3D (0x08000000 + 0x08000000 + 0x00080000) =3D=
 0x10080000
> +        PRE_START_SIZE :=3D $(shell egrep ' \. \=3D \({8}0x[0-9a-fA-F]+\=
){2}' \
> +          $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
> +          sed -e 's/[(|)|.|=3D|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*=
//' | \
> +          awk -F' ' '{printf "0x%x", $$6+$$7+$$8}' 2>/dev/null)
> +      endif
> +      ifeq ($(SRCARCH),arm)
> +        # Extract info from lds:
> +        #   . =3D ((0xC0000000)) + 0x00208000;
> +        # PRE_START_SIZE :=3D 0x00208000
> +        PRE_START_SIZE :=3D $(shell egrep ' \. \=3D \({2}0x[0-9a-fA-F]+\=
){2}' \
> +          $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
> +          sed -e 's/[(|)|.|=3D|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*=
//' | \
> +          awk -F' ' '{printf "0x%x", $$2}' 2>/dev/null)
> +      endif
> +    endif
> +    CFLAGS +=3D -DARM_PRE_START_SIZE=3D$(PRE_START_SIZE)

It might be useful to do this for arm and arm64 regardless of
CoreSight but I'll let Arnaldo decide on this.

>      $(call detected,CONFIG_LIBOPENCSD)
>      ifdef CSTRACE_RAW
>        CFLAGS +=3D -DCS_DEBUG_RAW
> diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> index 0c7776b51045..5fa0be3a3904 100644
> --- a/tools/perf/util/cs-etm.c
> +++ b/tools/perf/util/cs-etm.c
> @@ -613,10 +613,27 @@ static void cs_etm__free(struct perf_session *sessi=
on)
>  static u8 cs_etm__cpu_mode(struct cs_etm_queue *etmq, u64 address)
>  {
>         struct machine *machine;
> +       u64 fixup_kernel_start =3D 0;
>
>         machine =3D etmq->etm->machine;
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
> +       fixup_kernel_start =3D etmq->etm->kernel_start - ARM_PRE_START_SI=
ZE;
> +
> +       if (address >=3D fixup_kernel_start) {
>                 if (machine__is_host(machine))
>                         return PERF_RECORD_MISC_KERNEL;
>                 else

Tested-by: Mathieu Poirier <mathieu.poirier@linaro.org>

> --
> 2.17.1
>
