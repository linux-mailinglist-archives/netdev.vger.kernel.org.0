Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F024662DD3
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbjAIR7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbjAIR7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:59:12 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1B658FA0
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:56:53 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k16-20020a635a50000000b0042986056df6so3948397pgm.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0tcoMoEoQGxINU/ZQaE8VJXCHo160TANSi/OMsgBKSQ=;
        b=g7+Wakovn0CMkEsNT73EFpmTgkOtIjt5jh7ex6mce3JjmXsvP6ElcSQ0RcDwVVNfJd
         irQM6kl3d/DPGBkIJNK3NhE9/J3ngBzhIJwbc+UZ1H3AgDUKvYQoQ68Oo+b7kbZrGaTF
         e47Slok8tuxvLf3H5ALxkG2N7eztc80A5+16lihO38LHWP6S/t88z2Pbtly5ZUvERFnG
         7mANQfn0Ff8XjtLPKo31skgTcU0VlndKICZF9VemEAybZrDQC3V3+s1f8eQuAh3jZBQA
         W1Ymv371Tx7GgqwI1ummD/lRv9TuFCRV32pFKSIxTomV2YzPQIMtaCltuVpPn4VXOOVt
         qe3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0tcoMoEoQGxINU/ZQaE8VJXCHo160TANSi/OMsgBKSQ=;
        b=oj5rFxwmz1Rk4b3uji1W4NeNdziIqE8v+hKUYkc+z5cSJ+awoIBqUYPa6WQ1VadlRx
         0dfjVoMUtXOT1/+1mYFK3/lGo+CTHDTcnQmI4I1GRIt42qTq4SX9nw2gmuujBOhWnH6x
         aXTgARecDZO6SVWEOcC2rrUzi4Ka3vof1a9YeZgB0MPk8I+5Cksn/tQ3dn3eIK3/8XjF
         CCCNyLP4eb+1vsn/q4pbCSBtOKHiDrK13ykU9AcLythsEjyxip2otPXOOf8hqxg2BLVm
         e1D9KAFJSO/sdNrMb7X9VHf1zqFv2DVN7QitOEzQn7zcqCY72dxNPjeFFGjDxjfEuw6l
         9R6w==
X-Gm-Message-State: AFqh2kpBvqTdDYAYzfEn86WPLzKUCNNlhMSffQV5CPm6RzB+vnis7eYz
        ubbRSEueAqtNKZWOs+DdrEcEfk8=
X-Google-Smtp-Source: AMrXdXsGFs+kij2twxhA27xJ8eO4fNpm16LNhgaZeYUQlGLm8/6a27gf2tyiGxs9Bb/DV4IRB8E6+90=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:41c7:b0:189:d292:af70 with SMTP id
 u7-20020a17090341c700b00189d292af70mr3397833ple.104.1673287012972; Mon, 09
 Jan 2023 09:56:52 -0800 (PST)
Date:   Mon, 9 Jan 2023 09:56:51 -0800
In-Reply-To: <Y7xTDbMChqSp//x7@google.com>
Mime-Version: 1.0
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
 <20230106102332.1019632-2-benjamin.tissoires@redhat.com> <Y7xTDbMChqSp//x7@google.com>
Message-ID: <Y7xVY30ITrZrC1dm@google.com>
Subject: Re: [PATCH HID for-next v1 1/9] selftests: hid: add vmtest.sh
From:   sdf@google.com
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/09, Stanislav Fomichev wrote:
> On 01/06, Benjamin Tissoires wrote:
> > Similar-ish in many points from the script in selftests/bpf, with a few
> > differences:
> > - relies on boot2container instead of a plain qemu image (meaning that
> >   we can take any container in a registry as a base)
> > - runs in the hid selftest dir, and such uses the test program from  
> there
> > - the working directory to store the config is in
> >   tools/selftests/hid/results
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

> Sorry, I've completely missed this. I wasn't on CC and assumed
> that was some sort of a repost. Going through the changes right now.

Hmmm, or maybe I shouldn't? This seems to be bases on some other tree;
can't find tools/testing/selftests/hid/Makefile (from patch #2) in neither
bpf nor bpf-next.

Alexei/Daniel/Andrii, what's the process with these series?

> One question here: is it worth it extending bpf/vmtest.sh instead
> to support boot2container? Why new script with a bunch of copy-paste
> is a better deal?

> > ---
> >  tools/testing/selftests/hid/.gitignore    |   1 +
> >  tools/testing/selftests/hid/config.common | 241 ++++++++++++++++++
> >  tools/testing/selftests/hid/config.x86_64 |   4 +
> >  tools/testing/selftests/hid/vmtest.sh     | 284 ++++++++++++++++++++++
> >  4 files changed, 530 insertions(+)
> >  create mode 100644 tools/testing/selftests/hid/config.common
> >  create mode 100644 tools/testing/selftests/hid/config.x86_64
> >  create mode 100755 tools/testing/selftests/hid/vmtest.sh
> >
> > diff --git a/tools/testing/selftests/hid/.gitignore  
> b/tools/testing/selftests/hid/.gitignore
> > index a462ca6ab2c0..995af0670f69 100644
> > --- a/tools/testing/selftests/hid/.gitignore
> > +++ b/tools/testing/selftests/hid/.gitignore
> > @@ -2,3 +2,4 @@ bpftool
> >  *.skel.h
> >  /tools
> >  hid_bpf
> > +results
> > diff --git a/tools/testing/selftests/hid/config.common  
> b/tools/testing/selftests/hid/config.common
> > new file mode 100644
> > index 000000000000..0617275d93cc
> > --- /dev/null
> > +++ b/tools/testing/selftests/hid/config.common
> > @@ -0,0 +1,241 @@
> > +CONFIG_9P_FS_POSIX_ACL=y
> > +CONFIG_9P_FS_SECURITY=y
> > +CONFIG_9P_FS=y
> > +CONFIG_AUDIT=y
> > +CONFIG_BINFMT_MISC=y
> > +CONFIG_BLK_CGROUP_IOLATENCY=y
> > +CONFIG_BLK_CGROUP=y
> > +CONFIG_BLK_DEV_BSGLIB=y
> > +CONFIG_BLK_DEV_IO_TRACE=y
> > +CONFIG_BLK_DEV_RAM_SIZE=16384
> > +CONFIG_BLK_DEV_RAM=y
> > +CONFIG_BLK_DEV_THROTTLING=y
> > +CONFIG_BONDING=y
> > +CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> > +CONFIG_BOOTTIME_TRACING=y
> > +CONFIG_BSD_DISKLABEL=y
> > +CONFIG_BSD_PROCESS_ACCT=y
> > +CONFIG_CFS_BANDWIDTH=y
> > +CONFIG_CGROUP_CPUACCT=y
> > +CONFIG_CGROUP_DEBUG=y
> > +CONFIG_CGROUP_DEVICE=y
> > +CONFIG_CGROUP_FREEZER=y
> > +CONFIG_CGROUP_HUGETLB=y
> > +CONFIG_CGROUP_NET_CLASSID=y
> > +CONFIG_CGROUP_NET_PRIO=y
> > +CONFIG_CGROUP_PERF=y
> > +CONFIG_CGROUP_PIDS=y
> > +CONFIG_CGROUP_RDMA=y
> > +CONFIG_CGROUP_SCHED=y
> > +CONFIG_CGROUPS=y
> > +CONFIG_CGROUP_WRITEBACK=y
> > +CONFIG_CMA_AREAS=7
> > +CONFIG_CMA=y
> > +CONFIG_COMPAT_32BIT_TIME=y
> > +CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> > +CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> > +CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> > +CONFIG_CPU_FREQ_GOV_USERSPACE=y
> > +CONFIG_CPU_FREQ_STAT=y
> > +CONFIG_CPU_IDLE_GOV_LADDER=y
> > +CONFIG_CPUSETS=y
> > +CONFIG_CRC_T10DIF=y
> > +CONFIG_CRYPTO_BLAKE2B=y
> > +CONFIG_CRYPTO_DEV_VIRTIO=y
> > +CONFIG_CRYPTO_SEQIV=y
> > +CONFIG_CRYPTO_XXHASH=y
> > +CONFIG_DCB=y
> > +CONFIG_DEBUG_ATOMIC_SLEEP=y
> > +CONFIG_DEBUG_CREDENTIALS=y
> > +CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
> > +CONFIG_DEBUG_MEMORY_INIT=y
> > +CONFIG_DEFAULT_FQ_CODEL=y
> > +CONFIG_DEFAULT_RENO=y
> > +CONFIG_DEFAULT_SECURITY_DAC=y
> > +CONFIG_DEVTMPFS_MOUNT=y
> > +CONFIG_DEVTMPFS=y
> > +CONFIG_DMA_CMA=y
> > +CONFIG_DNS_RESOLVER=y
> > +CONFIG_EFI_STUB=y
> > +CONFIG_EFI=y
> > +CONFIG_EXPERT=y
> > +CONFIG_EXT4_FS_POSIX_ACL=y
> > +CONFIG_EXT4_FS_SECURITY=y
> > +CONFIG_EXT4_FS=y
> > +CONFIG_FAIL_FUNCTION=y
> > +CONFIG_FAULT_INJECTION_DEBUG_FS=y
> > +CONFIG_FAULT_INJECTION=y
> > +CONFIG_FB_MODE_HELPERS=y
> > +CONFIG_FB_TILEBLITTING=y
> > +CONFIG_FB_VESA=y
> > +CONFIG_FB=y
> > +CONFIG_FONT_8x16=y
> > +CONFIG_FONT_MINI_4x6=y
> > +CONFIG_FONTS=y
> > +CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> > +CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> > +CONFIG_FRAMEBUFFER_CONSOLE=y
> > +CONFIG_FUSE_FS=y
> > +CONFIG_FW_LOADER_USER_HELPER=y
> > +CONFIG_GART_IOMMU=y
> > +CONFIG_GENERIC_PHY=y
> > +CONFIG_HARDLOCKUP_DETECTOR=y
> > +CONFIG_HIGH_RES_TIMERS=y
> > +CONFIG_HPET=y
> > +CONFIG_HUGETLBFS=y
> > +CONFIG_HUGETLB_PAGE=y
> > +CONFIG_HWPOISON_INJECT=y
> > +CONFIG_HZ_1000=y
> > +CONFIG_INET=y
> > +CONFIG_INTEL_POWERCLAMP=y
> > +CONFIG_IP6_NF_FILTER=y
> > +CONFIG_IP6_NF_IPTABLES=y
> > +CONFIG_IP6_NF_NAT=y
> > +CONFIG_IP6_NF_TARGET_MASQUERADE=y
> > +CONFIG_IP_ADVANCED_ROUTER=y
> > +CONFIG_IP_MROUTE=y
> > +CONFIG_IP_MULTICAST=y
> > +CONFIG_IP_MULTIPLE_TABLES=y
> > +CONFIG_IP_NF_FILTER=y
> > +CONFIG_IP_NF_IPTABLES=y
> > +CONFIG_IP_NF_NAT=y
> > +CONFIG_IP_NF_TARGET_MASQUERADE=y
> > +CONFIG_IP_PIMSM_V1=y
> > +CONFIG_IP_PIMSM_V2=y
> > +CONFIG_IP_ROUTE_MULTIPATH=y
> > +CONFIG_IP_ROUTE_VERBOSE=y
> > +CONFIG_IPV6_MIP6=y
> > +CONFIG_IPV6_ROUTE_INFO=y
> > +CONFIG_IPV6_ROUTER_PREF=y
> > +CONFIG_IPV6_SEG6_LWTUNNEL=y
> > +CONFIG_IPV6_SUBTREES=y
> > +CONFIG_IRQ_POLL=y
> > +CONFIG_JUMP_LABEL=y
> > +CONFIG_KARMA_PARTITION=y
> > +CONFIG_KEXEC=y
> > +CONFIG_KPROBES=y
> > +CONFIG_KSM=y
> > +CONFIG_LEGACY_VSYSCALL_NONE=y
> > +CONFIG_LOG_BUF_SHIFT=21
> > +CONFIG_LOG_CPU_MAX_BUF_SHIFT=0
> > +CONFIG_LOGO=y
> > +CONFIG_LSM="selinux,bpf,integrity"
> > +CONFIG_MAC_PARTITION=y
> > +CONFIG_MAGIC_SYSRQ=y
> > +CONFIG_MCORE2=y
> > +CONFIG_MEMCG=y
> > +CONFIG_MEMORY_FAILURE=y
> > +CONFIG_MINIX_SUBPARTITION=y
> > +CONFIG_MODULES=y
> > +CONFIG_NAMESPACES=y
> > +CONFIG_NET_9P_VIRTIO=y
> > +CONFIG_NET_9P=y
> > +CONFIG_NET_ACT_BPF=y
> > +CONFIG_NET_CLS_CGROUP=y
> > +CONFIG_NETDEVICES=y
> > +CONFIG_NET_EMATCH=y
> > +CONFIG_NETFILTER_NETLINK_LOG=y
> > +CONFIG_NETFILTER_NETLINK_QUEUE=y
> > +CONFIG_NETFILTER_XTABLES=y
> > +CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
> > +CONFIG_NETFILTER_XT_MATCH_BPF=y
> > +CONFIG_NETFILTER_XT_MATCH_COMMENT=y
> > +CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> > +CONFIG_NETFILTER_XT_MATCH_MARK=y
> > +CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
> > +CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
> > +CONFIG_NETFILTER_XT_NAT=y
> > +CONFIG_NETFILTER_XT_TARGET_MASQUERADE=y
> > +CONFIG_NET_IPGRE_BROADCAST=y
> > +CONFIG_NET_L3_MASTER_DEV=y
> > +CONFIG_NETLABEL=y
> > +CONFIG_NET_SCH_DEFAULT=y
> > +CONFIG_NET_SCHED=y
> > +CONFIG_NET_SCH_FQ_CODEL=y
> > +CONFIG_NET_TC_SKB_EXT=y
> > +CONFIG_NET_VRF=y
> > +CONFIG_NET=y
> > +CONFIG_NF_CONNTRACK=y
> > +CONFIG_NF_NAT_MASQUERADE=y
> > +CONFIG_NF_NAT=y
> > +CONFIG_NLS_ASCII=y
> > +CONFIG_NLS_CODEPAGE_437=y
> > +CONFIG_NLS_DEFAULT="utf8"
> > +CONFIG_NO_HZ=y
> > +CONFIG_NR_CPUS=128
> > +CONFIG_NUMA_BALANCING=y
> > +CONFIG_NUMA=y
> > +CONFIG_NVMEM=y
> > +CONFIG_OSF_PARTITION=y
> > +CONFIG_OVERLAY_FS_INDEX=y
> > +CONFIG_OVERLAY_FS_METACOPY=y
> > +CONFIG_OVERLAY_FS_XINO_AUTO=y
> > +CONFIG_OVERLAY_FS=y
> > +CONFIG_PACKET=y
> > +CONFIG_PANIC_ON_OOPS=y
> > +CONFIG_PARTITION_ADVANCED=y
> > +CONFIG_PCIEPORTBUS=y
> > +CONFIG_PCI_IOV=y
> > +CONFIG_PCI_MSI=y
> > +CONFIG_PCI=y
> > +CONFIG_PHYSICAL_ALIGN=0x1000000
> > +CONFIG_POSIX_MQUEUE=y
> > +CONFIG_POWER_SUPPLY=y
> > +CONFIG_PREEMPT=y
> > +CONFIG_PRINTK_TIME=y
> > +CONFIG_PROC_KCORE=y
> > +CONFIG_PROFILING=y
> > +CONFIG_PROVE_LOCKING=y
> > +CONFIG_PTP_1588_CLOCK=y
> > +CONFIG_RC_DEVICES=y
> > +CONFIG_RC_LOOPBACK=y
> > +CONFIG_RCU_CPU_STALL_TIMEOUT=60
> > +CONFIG_SCHED_STACK_END_CHECK=y
> > +CONFIG_SCHEDSTATS=y
> > +CONFIG_SECURITY_NETWORK=y
> > +CONFIG_SECURITY_SELINUX=y
> > +CONFIG_SERIAL_8250_CONSOLE=y
> > +CONFIG_SERIAL_8250_DETECT_IRQ=y
> > +CONFIG_SERIAL_8250_EXTENDED=y
> > +CONFIG_SERIAL_8250_MANY_PORTS=y
> > +CONFIG_SERIAL_8250_NR_UARTS=32
> > +CONFIG_SERIAL_8250_RSA=y
> > +CONFIG_SERIAL_8250_SHARE_IRQ=y
> > +CONFIG_SERIAL_8250=y
> > +CONFIG_SERIAL_NONSTANDARD=y
> > +CONFIG_SERIO_LIBPS2=y
> > +CONFIG_SGI_PARTITION=y
> > +CONFIG_SMP=y
> > +CONFIG_SOCK_CGROUP_DATA=y
> > +CONFIG_SOLARIS_X86_PARTITION=y
> > +CONFIG_SUN_PARTITION=y
> > +CONFIG_SYNC_FILE=y
> > +CONFIG_SYSVIPC=y
> > +CONFIG_TASK_DELAY_ACCT=y
> > +CONFIG_TASK_IO_ACCOUNTING=y
> > +CONFIG_TASKSTATS=y
> > +CONFIG_TASK_XACCT=y
> > +CONFIG_TCP_CONG_ADVANCED=y
> > +CONFIG_TCP_MD5SIG=y
> > +CONFIG_TLS=y
> > +CONFIG_TMPFS_POSIX_ACL=y
> > +CONFIG_TMPFS=y
> > +CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> > +CONFIG_TRANSPARENT_HUGEPAGE=y
> > +CONFIG_TUN=y
> > +CONFIG_UNIXWARE_DISKLABEL=y
> > +CONFIG_UNIX=y
> > +CONFIG_USER_NS=y
> > +CONFIG_VALIDATE_FS_PARSER=y
> > +CONFIG_VETH=y
> > +CONFIG_VIRT_DRIVERS=y
> > +CONFIG_VIRTIO_BALLOON=y
> > +CONFIG_VIRTIO_BLK=y
> > +CONFIG_VIRTIO_CONSOLE=y
> > +CONFIG_VIRTIO_FS=y
> > +CONFIG_VIRTIO_NET=y
> > +CONFIG_VIRTIO_PCI=y
> > +CONFIG_VLAN_8021Q=y
> > +CONFIG_XFRM_SUB_POLICY=y
> > +CONFIG_XFRM_USER=y
> > +CONFIG_ZEROPLUS_FF=y
> > diff --git a/tools/testing/selftests/hid/config.x86_64  
> b/tools/testing/selftests/hid/config.x86_64
> > new file mode 100644
> > index 000000000000..a8721f403c21
> > --- /dev/null
> > +++ b/tools/testing/selftests/hid/config.x86_64
> > @@ -0,0 +1,4 @@
> > +CONFIG_X86_ACPI_CPUFREQ=y
> > +CONFIG_X86_CPUID=y
> > +CONFIG_X86_MSR=y
> > +CONFIG_X86_POWERNOW_K8=y
> > diff --git a/tools/testing/selftests/hid/vmtest.sh  
> b/tools/testing/selftests/hid/vmtest.sh
> > new file mode 100755
> > index 000000000000..90f34150f257
> > --- /dev/null
> > +++ b/tools/testing/selftests/hid/vmtest.sh
> > @@ -0,0 +1,284 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +set -u
> > +set -e
> > +
> > +# This script currently only works for x86_64
> > +ARCH="$(uname -m)"
> > +case "${ARCH}" in
> > +x86_64)
> > +	QEMU_BINARY=qemu-system-x86_64
> > +	BZIMAGE="arch/x86/boot/bzImage"
> > +	;;
> > +*)
> > +	echo "Unsupported architecture"
> > +	exit 1
> > +	;;
> > +esac
> > +DEFAULT_COMMAND="./hid_bpf"
> > +SCRIPT_DIR="$(dirname $(realpath $0))"
> > +OUTPUT_DIR="$SCRIPT_DIR/results"
> >  
> +KCONFIG_REL_PATHS=("${SCRIPT_DIR}/config" "${SCRIPT_DIR}/config.common" "${SCRIPT_DIR}/config.${ARCH}")
> >  
> +B2C_URL="https://gitlab.freedesktop.org/mupuf/boot2container/-/raw/master/vm2c.py"
> > +NUM_COMPILE_JOBS="$(nproc)"
> > +LOG_FILE_BASE="$(date +"hid_selftests.%Y-%m-%d_%H-%M-%S")"
> > +LOG_FILE="${LOG_FILE_BASE}.log"
> > +EXIT_STATUS_FILE="${LOG_FILE_BASE}.exit_status"
> > +CONTAINER_IMAGE="registry.fedoraproject.org/fedora:36"
> > +
> > +usage()
> > +{
> > +	cat <<EOF
> > +Usage: $0 [-i] [-s] [-d <output_dir>] -- [<command>]
> > +
> > +<command> is the command you would normally run when you are in
> > +tools/testing/selftests/bpf. e.g:
> > +
> > +	$0 -- ./hid_bpf
> > +
> > +If no command is specified and a debug shell (-s) is not requested,
> > +"${DEFAULT_COMMAND}" will be run by default.
> > +
> > +If you build your kernel using KBUILD_OUTPUT= or O= options, these
> > +can be passed as environment variables to the script:
> > +
> > +  O=<kernel_build_path> $0 -- ./hid_bpf
> > +
> > +or
> > +
> > +  KBUILD_OUTPUT=<kernel_build_path> $0 -- ./hid_bpf
> > +
> > +Options:
> > +
> > +	-u)		Update the boot2container script to a newer version.
> > +	-d)		Update the output directory (default: ${OUTPUT_DIR})
> > +	-j)		Number of jobs for compilation, similar to -j in make
> > +			(default: ${NUM_COMPILE_JOBS})
> > +	-s)		Instead of powering off the VM, start an interactive
> > +			shell. If <command> is specified, the shell runs after
> > +			the command finishes executing
> > +EOF
> > +}
> > +
> > +download()
> > +{
> > +	local file="$1"
> > +
> > +	echo "Downloading $file..." >&2
> > +	curl -Lsf "$file" -o "${@:2}"
> > +}
> > +
> > +recompile_kernel()
> > +{
> > +	local kernel_checkout="$1"
> > +	local make_command="$2"
> > +
> > +	cd "${kernel_checkout}"
> > +
> > +	${make_command} olddefconfig
> > +	${make_command}
> > +}
> > +
> > +update_selftests()
> > +{
> > +	local kernel_checkout="$1"
> > +	local selftests_dir="${kernel_checkout}/tools/testing/selftests/hid"
> > +
> > +	cd "${selftests_dir}"
> > +	${make_command}
> > +}
> > +
> > +run_vm()
> > +{
> > +	local b2c="$1"
> > +	local kernel_bzimage="$2"
> > +	local command="$3"
> > +	local post_command=""
> > +
> > +	if ! which "${QEMU_BINARY}" &> /dev/null; then
> > +		cat <<EOF
> > +Could not find ${QEMU_BINARY}
> > +Please install qemu or set the QEMU_BINARY environment variable.
> > +EOF
> > +		exit 1
> > +	fi
> > +
> > +	# alpine (used in post-container requires the PATH to have /bin
> > +	export PATH=$PATH:/bin
> > +
> > +	if [[ "${debug_shell}" != "yes" ]]
> > +	then
> > +		touch ${OUTPUT_DIR}/${LOG_FILE}
> > +		command="mount bpffs -t bpf /sys/fs/bpf/; set -o pipefail ;  
> ${command} 2>&1 | tee ${OUTPUT_DIR}/${LOG_FILE}"
> > +		post_command="cat ${OUTPUT_DIR}/${LOG_FILE}"
> > +	else
> > +		command="mount bpffs -t bpf /sys/fs/bpf/; ${command}"
> > +	fi
> > +
> > +	set +e
> > +	$b2c --command "${command}" \
> > +	     --kernel ${kernel_bzimage} \
> > +	     --workdir ${OUTPUT_DIR} \
> > +	     --image ${CONTAINER_IMAGE}
> > +
> > +	echo $? > ${OUTPUT_DIR}/${EXIT_STATUS_FILE}
> > +
> > +	set -e
> > +
> > +	${post_command}
> > +}
> > +
> > +is_rel_path()
> > +{
> > +	local path="$1"
> > +
> > +	[[ ${path:0:1} != "/" ]]
> > +}
> > +
> > +do_update_kconfig()
> > +{
> > +	local kernel_checkout="$1"
> > +	local kconfig_file="$2"
> > +
> > +	rm -f "$kconfig_file" 2> /dev/null
> > +
> > +	for config in "${KCONFIG_REL_PATHS[@]}"; do
> > +		local kconfig_src="${config}"
> > +		cat "$kconfig_src" >> "$kconfig_file"
> > +	done
> > +}
> > +
> > +update_kconfig()
> > +{
> > +	local kernel_checkout="$1"
> > +	local kconfig_file="$2"
> > +
> > +	if [[ -f "${kconfig_file}" ]]; then
> > +		local local_modified="$(stat -c %Y "${kconfig_file}")"
> > +
> > +		for config in "${KCONFIG_REL_PATHS[@]}"; do
> > +			local kconfig_src="${config}"
> > +			local src_modified="$(stat -c %Y "${kconfig_src}")"
> > +			# Only update the config if it has been updated after the
> > +			# previously cached config was created. This avoids
> > +			# unnecessarily compiling the kernel and selftests.
> > +			if [[ "${src_modified}" -gt "${local_modified}" ]]; then
> > +				do_update_kconfig "$kernel_checkout" "$kconfig_file"
> > +				# Once we have found one outdated configuration
> > +				# there is no need to check other ones.
> > +				break
> > +			fi
> > +		done
> > +	else
> > +		do_update_kconfig "$kernel_checkout" "$kconfig_file"
> > +	fi
> > +}
> > +
> > +main()
> > +{
> > +	local script_dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" &&  
> pwd -P)"
> > +	local kernel_checkout=$(realpath "${script_dir}"/../../../../)
> > +	# By default the script searches for the kernel in the checkout  
> directory but
> > +	# it also obeys environment variables O= and KBUILD_OUTPUT=
> > +	local kernel_bzimage="${kernel_checkout}/${BZIMAGE}"
> > +	local command="${DEFAULT_COMMAND}"
> > +	local update_b2c="no"
> > +	local debug_shell="no"
> > +
> > +	while getopts ':hsud:j:' opt; do
> > +		case ${opt} in
> > +		u)
> > +			update_b2c="yes"
> > +			;;
> > +		d)
> > +			OUTPUT_DIR="$OPTARG"
> > +			;;
> > +		j)
> > +			NUM_COMPILE_JOBS="$OPTARG"
> > +			;;
> > +		s)
> > +			command="/bin/sh"
> > +			debug_shell="yes"
> > +			;;
> > +		h)
> > +			usage
> > +			exit 0
> > +			;;
> > +		\? )
> > +			echo "Invalid Option: -$OPTARG"
> > +			usage
> > +			exit 1
> > +			;;
> > +		: )
> > +			echo "Invalid Option: -$OPTARG requires an argument"
> > +			usage
> > +			exit 1
> > +			;;
> > +		esac
> > +	done
> > +	shift $((OPTIND -1))
> > +
> > +	# trap 'catch "$?"' EXIT
> > +
> > +	if [[ "${debug_shell}" == "no" ]]; then
> > +		if [[ $# -eq 0 ]]; then
> > +			echo "No command specified, will run ${DEFAULT_COMMAND} in the vm"
> > +		else
> > +			command="$@"
> > +
> > +			if [[ "${command}" == "/bin/bash" || "${command}" == "bash" ]]
> > +			then
> > +				debug_shell="yes"
> > +			fi
> > +		fi
> > +	fi
> > +
> > +	local kconfig_file="${OUTPUT_DIR}/latest.config"
> > +	local make_command="make -j ${NUM_COMPILE_JOBS}  
> KCONFIG_CONFIG=${kconfig_file}"
> > +
> > +	# Figure out where the kernel is being built.
> > +	# O takes precedence over KBUILD_OUTPUT.
> > +	if [[ "${O:=""}" != "" ]]; then
> > +		if is_rel_path "${O}"; then
> > +			O="$(realpath "${PWD}/${O}")"
> > +		fi
> > +		kernel_bzimage="${O}/${BZIMAGE}"
> > +		make_command="${make_command} O=${O}"
> > +	elif [[ "${KBUILD_OUTPUT:=""}" != "" ]]; then
> > +		if is_rel_path "${KBUILD_OUTPUT}"; then
> > +			KBUILD_OUTPUT="$(realpath "${PWD}/${KBUILD_OUTPUT}")"
> > +		fi
> > +		kernel_bzimage="${KBUILD_OUTPUT}/${BZIMAGE}"
> > +		make_command="${make_command} KBUILD_OUTPUT=${KBUILD_OUTPUT}"
> > +	fi
> > +
> > +	local b2c="${OUTPUT_DIR}/vm2c.py"
> > +
> > +	echo "Output directory: ${OUTPUT_DIR}"
> > +
> > +	mkdir -p "${OUTPUT_DIR}"
> > +	update_kconfig "${kernel_checkout}" "${kconfig_file}"
> > +
> > +	recompile_kernel "${kernel_checkout}" "${make_command}"
> > +
> > +	if [[ "${update_b2c}" == "no" && ! -f "${b2c}" ]]; then
> > +		echo "vm2c script not found in ${b2c}"
> > +		update_b2c="yes"
> > +	fi
> > +
> > +	if [[ "${update_b2c}" == "yes" ]]; then
> > +		download $B2C_URL $b2c
> > +		chmod +x $b2c
> > +	fi
> > +
> > +	update_selftests "${kernel_checkout}" "${make_command}"
> > +	run_vm $b2c "${kernel_bzimage}" "${command}"
> > +	if [[ "${debug_shell}" != "yes" ]]; then
> > +		echo "Logs saved in ${OUTPUT_DIR}/${LOG_FILE}"
> > +	fi
> > +
> > +	exit $(cat ${OUTPUT_DIR}/${EXIT_STATUS_FILE})
> > +}
> > +
> > +main "$@"
> > --
> > 2.38.1
> >
