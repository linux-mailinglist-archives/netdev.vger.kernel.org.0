Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7DF663D2C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbjAJJoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjAJJoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:44:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1205011C2C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673343799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dSxnd5SXqEnQUnDO6EQ905cS7Tb/Ja8GvnhP29cmOQA=;
        b=S/mRNgyf7yyw1Nq2+dKGF44n+BGZZj3CMcahvfuGyRQ1665688r6N9CoCaWzL1rN2txTkk
        RpQy3dmpsm29HGYgBX88HX+Di6RJCxTrJq5TP4paNVeG8KweLs3QRYuRRd7SRZPoREax84
        EheBY5Ci1hNc99cx8aR5r9Ngo/iYdjE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-662-7uaR9PFfOK6lKFRCu58uvA-1; Tue, 10 Jan 2023 04:43:18 -0500
X-MC-Unique: 7uaR9PFfOK6lKFRCu58uvA-1
Received: by mail-il1-f199.google.com with SMTP id z19-20020a921a53000000b0030b90211df1so7938744ill.2
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:43:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dSxnd5SXqEnQUnDO6EQ905cS7Tb/Ja8GvnhP29cmOQA=;
        b=SacbGszMiOQO5FQzV94fk3egZYDRr23goYzc3Tfd+wqGWEIPSsMdwr4bBY6KNsME3r
         a2oyFQRAm4ydfIRnAkbYXAXSlWgEW5Xkp2I72k7Af7aMgxL8mWtParOuyfxtjGem0wIL
         Y4yGQLGkr3INUHnKLts/mCEweqYr3cD41TcwuWWuWEhM/gchLD+ZrefeaYczPA2nwrjE
         Ec1PDq+jmdszMpj7r0KOy1Ib5//UycU5lCtWnRfvZv9ROqfXc5SEEKEJ7+O/CeKQzQ0/
         w+PmEiZdJOUEwyUw1EpWe2MEJ1uex1jtT71uKfkz06jchTVr4txLlHiQDZqkkuyVhEBP
         qQqQ==
X-Gm-Message-State: AFqh2koWuBl5CUnQ0yJAtxnoQ5kBVlD+yqp9eM3P4Onmw9nJhNbEqb3j
        UeqJi0/Fi12P5mCJz8RGtJJgJFDrhMyXgANODFBliRRMYOuvby8BIo4nxwQ6lykLA0KUtHpZgk3
        z0fdve0ldyTyP2+EFDK/ortVGHzAd5eAj
X-Received: by 2002:a92:6e0b:0:b0:302:ebf5:a7ae with SMTP id j11-20020a926e0b000000b00302ebf5a7aemr8000336ilc.34.1673343797027;
        Tue, 10 Jan 2023 01:43:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvVj0tphXwJdzA7J3H+xDYCmGHyDba/ChK+XzIuJ0MD0SBUPaK126vnBfYubtBmFVZLvUcN4GQWFwEqIiRgWqg=
X-Received: by 2002:a92:6e0b:0:b0:302:ebf5:a7ae with SMTP id
 j11-20020a926e0b000000b00302ebf5a7aemr8000320ilc.34.1673343796593; Tue, 10
 Jan 2023 01:43:16 -0800 (PST)
MIME-Version: 1.0
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
 <20230106102332.1019632-2-benjamin.tissoires@redhat.com> <Y7xTDbMChqSp//x7@google.com>
 <Y7xVY30ITrZrC1dm@google.com>
In-Reply-To: <Y7xVY30ITrZrC1dm@google.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 10 Jan 2023 10:43:05 +0100
Message-ID: <CAO-hwJJr1eAvR++V3Tv6cL8chj05PE_-vF+J8OoB1GpP2VQGig@mail.gmail.com>
Subject: Re: [PATCH HID for-next v1 1/9] selftests: hid: add vmtest.sh
To:     sdf@google.com
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 6:56 PM <sdf@google.com> wrote:
>
> On 01/09, Stanislav Fomichev wrote:
> > On 01/06, Benjamin Tissoires wrote:
> > > Similar-ish in many points from the script in selftests/bpf, with a few
> > > differences:
> > > - relies on boot2container instead of a plain qemu image (meaning that
> > >   we can take any container in a registry as a base)
> > > - runs in the hid selftest dir, and such uses the test program from
> > there
> > > - the working directory to store the config is in
> > >   tools/selftests/hid/results
> > >
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> > Sorry, I've completely missed this. I wasn't on CC and assumed
> > that was some sort of a repost. Going through the changes right now.
>
> Hmmm, or maybe I shouldn't? This seems to be bases on some other tree;
> can't find tools/testing/selftests/hid/Makefile (from patch #2) in neither
> bpf nor bpf-next.


These changes are based on
https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git/ branch
for-6.3/hid-bpf, so going through the HID tree, not the bpf one.

I Cce-ed the bpf mailing list for visibility, in case I made an
obvious error, but this doesn't impact bpf core, so reviews are
appreciated, but not mandatory from the bpf side of things :)


>
>
> Alexei/Daniel/Andrii, what's the process with these series?
>
> > One question here: is it worth it extending bpf/vmtest.sh instead
> > to support boot2container? Why new script with a bunch of copy-paste
> > is a better deal?

Good question. There were a few things that made me copy/paste part of
the script:
- the bpf one is relying on the bpf rootfs image that, as a subsystem
maintainer of another subsystem than bpf don't control
- the bpf one is hardcoding which program to launch, and I want another one
- the bpf one is in a different directory which would feel weird to
call when running selftests/hid
- I want a minimum control over the script so that a change in the bpf
tree doesn't accidentally break the hid tree

I think using the boot2container initramfs solves the rootfs issue,
because the initramfs is generic and just consists of a script around
podman to start a container. This way I can run the test suite on any
distribution without having to build any distro image. I should also
be able to start a scratch container without anything in it given that
the only thing that matters is the binary we start as a command
(though we won't be able to start a shell in the target VM).

Solving the second and third point could probably be done by
encapsulating the call to bpf/vmtest.sh from hid.

But for the fourth point, I believe that the bpf script is not generic
enough to be reused by other subsystems as it relies on the bpf CI,
mostly to generate the rootfs.

Also note that boot2container is a little bit more verbose in terms of
logs, as it's not just a plain qemu boot to a known rootfs, but it
starts podman and another container at the end to gather the results.

So maybe a solution would be to add a vmtest make target at the
selftests root directory, that would be generic enough to be run in
any subsystem. There are a few other users of qemu in selftests, but
each of them has a slightly different use of qemu.

Also, FWIW, boot2container is currently only providing initramfs for
x86_64 and arm64. Thus, using boot2container now for bpf means that we
would drop s390x, which is probably not the best move forward. We can
surely extend the targets, but not sure what plans Martin has on this
side.

For reference, boot2container project:
https://gitlab.freedesktop.org/mupuf/boot2container/

Cheers,
Benjamin

>
> > > ---
> > >  tools/testing/selftests/hid/.gitignore    |   1 +
> > >  tools/testing/selftests/hid/config.common | 241 ++++++++++++++++++
> > >  tools/testing/selftests/hid/config.x86_64 |   4 +
> > >  tools/testing/selftests/hid/vmtest.sh     | 284 ++++++++++++++++++++++
> > >  4 files changed, 530 insertions(+)
> > >  create mode 100644 tools/testing/selftests/hid/config.common
> > >  create mode 100644 tools/testing/selftests/hid/config.x86_64
> > >  create mode 100755 tools/testing/selftests/hid/vmtest.sh
> > >
> > > diff --git a/tools/testing/selftests/hid/.gitignore
> > b/tools/testing/selftests/hid/.gitignore
> > > index a462ca6ab2c0..995af0670f69 100644
> > > --- a/tools/testing/selftests/hid/.gitignore
> > > +++ b/tools/testing/selftests/hid/.gitignore
> > > @@ -2,3 +2,4 @@ bpftool
> > >  *.skel.h
> > >  /tools
> > >  hid_bpf
> > > +results
> > > diff --git a/tools/testing/selftests/hid/config.common
> > b/tools/testing/selftests/hid/config.common
> > > new file mode 100644
> > > index 000000000000..0617275d93cc
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/hid/config.common
> > > @@ -0,0 +1,241 @@
> > > +CONFIG_9P_FS_POSIX_ACL=y
> > > +CONFIG_9P_FS_SECURITY=y
> > > +CONFIG_9P_FS=y
> > > +CONFIG_AUDIT=y
> > > +CONFIG_BINFMT_MISC=y
> > > +CONFIG_BLK_CGROUP_IOLATENCY=y
> > > +CONFIG_BLK_CGROUP=y
> > > +CONFIG_BLK_DEV_BSGLIB=y
> > > +CONFIG_BLK_DEV_IO_TRACE=y
> > > +CONFIG_BLK_DEV_RAM_SIZE=16384
> > > +CONFIG_BLK_DEV_RAM=y
> > > +CONFIG_BLK_DEV_THROTTLING=y
> > > +CONFIG_BONDING=y
> > > +CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> > > +CONFIG_BOOTTIME_TRACING=y
> > > +CONFIG_BSD_DISKLABEL=y
> > > +CONFIG_BSD_PROCESS_ACCT=y
> > > +CONFIG_CFS_BANDWIDTH=y
> > > +CONFIG_CGROUP_CPUACCT=y
> > > +CONFIG_CGROUP_DEBUG=y
> > > +CONFIG_CGROUP_DEVICE=y
> > > +CONFIG_CGROUP_FREEZER=y
> > > +CONFIG_CGROUP_HUGETLB=y
> > > +CONFIG_CGROUP_NET_CLASSID=y
> > > +CONFIG_CGROUP_NET_PRIO=y
> > > +CONFIG_CGROUP_PERF=y
> > > +CONFIG_CGROUP_PIDS=y
> > > +CONFIG_CGROUP_RDMA=y
> > > +CONFIG_CGROUP_SCHED=y
> > > +CONFIG_CGROUPS=y
> > > +CONFIG_CGROUP_WRITEBACK=y
> > > +CONFIG_CMA_AREAS=7
> > > +CONFIG_CMA=y
> > > +CONFIG_COMPAT_32BIT_TIME=y
> > > +CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> > > +CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> > > +CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> > > +CONFIG_CPU_FREQ_GOV_USERSPACE=y
> > > +CONFIG_CPU_FREQ_STAT=y
> > > +CONFIG_CPU_IDLE_GOV_LADDER=y
> > > +CONFIG_CPUSETS=y
> > > +CONFIG_CRC_T10DIF=y
> > > +CONFIG_CRYPTO_BLAKE2B=y
> > > +CONFIG_CRYPTO_DEV_VIRTIO=y
> > > +CONFIG_CRYPTO_SEQIV=y
> > > +CONFIG_CRYPTO_XXHASH=y
> > > +CONFIG_DCB=y
> > > +CONFIG_DEBUG_ATOMIC_SLEEP=y
> > > +CONFIG_DEBUG_CREDENTIALS=y
> > > +CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
> > > +CONFIG_DEBUG_MEMORY_INIT=y
> > > +CONFIG_DEFAULT_FQ_CODEL=y
> > > +CONFIG_DEFAULT_RENO=y
> > > +CONFIG_DEFAULT_SECURITY_DAC=y
> > > +CONFIG_DEVTMPFS_MOUNT=y
> > > +CONFIG_DEVTMPFS=y
> > > +CONFIG_DMA_CMA=y
> > > +CONFIG_DNS_RESOLVER=y
> > > +CONFIG_EFI_STUB=y
> > > +CONFIG_EFI=y
> > > +CONFIG_EXPERT=y
> > > +CONFIG_EXT4_FS_POSIX_ACL=y
> > > +CONFIG_EXT4_FS_SECURITY=y
> > > +CONFIG_EXT4_FS=y
> > > +CONFIG_FAIL_FUNCTION=y
> > > +CONFIG_FAULT_INJECTION_DEBUG_FS=y
> > > +CONFIG_FAULT_INJECTION=y
> > > +CONFIG_FB_MODE_HELPERS=y
> > > +CONFIG_FB_TILEBLITTING=y
> > > +CONFIG_FB_VESA=y
> > > +CONFIG_FB=y
> > > +CONFIG_FONT_8x16=y
> > > +CONFIG_FONT_MINI_4x6=y
> > > +CONFIG_FONTS=y
> > > +CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> > > +CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> > > +CONFIG_FRAMEBUFFER_CONSOLE=y
> > > +CONFIG_FUSE_FS=y
> > > +CONFIG_FW_LOADER_USER_HELPER=y
> > > +CONFIG_GART_IOMMU=y
> > > +CONFIG_GENERIC_PHY=y
> > > +CONFIG_HARDLOCKUP_DETECTOR=y
> > > +CONFIG_HIGH_RES_TIMERS=y
> > > +CONFIG_HPET=y
> > > +CONFIG_HUGETLBFS=y
> > > +CONFIG_HUGETLB_PAGE=y
> > > +CONFIG_HWPOISON_INJECT=y
> > > +CONFIG_HZ_1000=y
> > > +CONFIG_INET=y
> > > +CONFIG_INTEL_POWERCLAMP=y
> > > +CONFIG_IP6_NF_FILTER=y
> > > +CONFIG_IP6_NF_IPTABLES=y
> > > +CONFIG_IP6_NF_NAT=y
> > > +CONFIG_IP6_NF_TARGET_MASQUERADE=y
> > > +CONFIG_IP_ADVANCED_ROUTER=y
> > > +CONFIG_IP_MROUTE=y
> > > +CONFIG_IP_MULTICAST=y
> > > +CONFIG_IP_MULTIPLE_TABLES=y
> > > +CONFIG_IP_NF_FILTER=y
> > > +CONFIG_IP_NF_IPTABLES=y
> > > +CONFIG_IP_NF_NAT=y
> > > +CONFIG_IP_NF_TARGET_MASQUERADE=y
> > > +CONFIG_IP_PIMSM_V1=y
> > > +CONFIG_IP_PIMSM_V2=y
> > > +CONFIG_IP_ROUTE_MULTIPATH=y
> > > +CONFIG_IP_ROUTE_VERBOSE=y
> > > +CONFIG_IPV6_MIP6=y
> > > +CONFIG_IPV6_ROUTE_INFO=y
> > > +CONFIG_IPV6_ROUTER_PREF=y
> > > +CONFIG_IPV6_SEG6_LWTUNNEL=y
> > > +CONFIG_IPV6_SUBTREES=y
> > > +CONFIG_IRQ_POLL=y
> > > +CONFIG_JUMP_LABEL=y
> > > +CONFIG_KARMA_PARTITION=y
> > > +CONFIG_KEXEC=y
> > > +CONFIG_KPROBES=y
> > > +CONFIG_KSM=y
> > > +CONFIG_LEGACY_VSYSCALL_NONE=y
> > > +CONFIG_LOG_BUF_SHIFT=21
> > > +CONFIG_LOG_CPU_MAX_BUF_SHIFT=0
> > > +CONFIG_LOGO=y
> > > +CONFIG_LSM="selinux,bpf,integrity"
> > > +CONFIG_MAC_PARTITION=y
> > > +CONFIG_MAGIC_SYSRQ=y
> > > +CONFIG_MCORE2=y
> > > +CONFIG_MEMCG=y
> > > +CONFIG_MEMORY_FAILURE=y
> > > +CONFIG_MINIX_SUBPARTITION=y
> > > +CONFIG_MODULES=y
> > > +CONFIG_NAMESPACES=y
> > > +CONFIG_NET_9P_VIRTIO=y
> > > +CONFIG_NET_9P=y
> > > +CONFIG_NET_ACT_BPF=y
> > > +CONFIG_NET_CLS_CGROUP=y
> > > +CONFIG_NETDEVICES=y
> > > +CONFIG_NET_EMATCH=y
> > > +CONFIG_NETFILTER_NETLINK_LOG=y
> > > +CONFIG_NETFILTER_NETLINK_QUEUE=y
> > > +CONFIG_NETFILTER_XTABLES=y
> > > +CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
> > > +CONFIG_NETFILTER_XT_MATCH_BPF=y
> > > +CONFIG_NETFILTER_XT_MATCH_COMMENT=y
> > > +CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> > > +CONFIG_NETFILTER_XT_MATCH_MARK=y
> > > +CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
> > > +CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
> > > +CONFIG_NETFILTER_XT_NAT=y
> > > +CONFIG_NETFILTER_XT_TARGET_MASQUERADE=y
> > > +CONFIG_NET_IPGRE_BROADCAST=y
> > > +CONFIG_NET_L3_MASTER_DEV=y
> > > +CONFIG_NETLABEL=y
> > > +CONFIG_NET_SCH_DEFAULT=y
> > > +CONFIG_NET_SCHED=y
> > > +CONFIG_NET_SCH_FQ_CODEL=y
> > > +CONFIG_NET_TC_SKB_EXT=y
> > > +CONFIG_NET_VRF=y
> > > +CONFIG_NET=y
> > > +CONFIG_NF_CONNTRACK=y
> > > +CONFIG_NF_NAT_MASQUERADE=y
> > > +CONFIG_NF_NAT=y
> > > +CONFIG_NLS_ASCII=y
> > > +CONFIG_NLS_CODEPAGE_437=y
> > > +CONFIG_NLS_DEFAULT="utf8"
> > > +CONFIG_NO_HZ=y
> > > +CONFIG_NR_CPUS=128
> > > +CONFIG_NUMA_BALANCING=y
> > > +CONFIG_NUMA=y
> > > +CONFIG_NVMEM=y
> > > +CONFIG_OSF_PARTITION=y
> > > +CONFIG_OVERLAY_FS_INDEX=y
> > > +CONFIG_OVERLAY_FS_METACOPY=y
> > > +CONFIG_OVERLAY_FS_XINO_AUTO=y
> > > +CONFIG_OVERLAY_FS=y
> > > +CONFIG_PACKET=y
> > > +CONFIG_PANIC_ON_OOPS=y
> > > +CONFIG_PARTITION_ADVANCED=y
> > > +CONFIG_PCIEPORTBUS=y
> > > +CONFIG_PCI_IOV=y
> > > +CONFIG_PCI_MSI=y
> > > +CONFIG_PCI=y
> > > +CONFIG_PHYSICAL_ALIGN=0x1000000
> > > +CONFIG_POSIX_MQUEUE=y
> > > +CONFIG_POWER_SUPPLY=y
> > > +CONFIG_PREEMPT=y
> > > +CONFIG_PRINTK_TIME=y
> > > +CONFIG_PROC_KCORE=y
> > > +CONFIG_PROFILING=y
> > > +CONFIG_PROVE_LOCKING=y
> > > +CONFIG_PTP_1588_CLOCK=y
> > > +CONFIG_RC_DEVICES=y
> > > +CONFIG_RC_LOOPBACK=y
> > > +CONFIG_RCU_CPU_STALL_TIMEOUT=60
> > > +CONFIG_SCHED_STACK_END_CHECK=y
> > > +CONFIG_SCHEDSTATS=y
> > > +CONFIG_SECURITY_NETWORK=y
> > > +CONFIG_SECURITY_SELINUX=y
> > > +CONFIG_SERIAL_8250_CONSOLE=y
> > > +CONFIG_SERIAL_8250_DETECT_IRQ=y
> > > +CONFIG_SERIAL_8250_EXTENDED=y
> > > +CONFIG_SERIAL_8250_MANY_PORTS=y
> > > +CONFIG_SERIAL_8250_NR_UARTS=32
> > > +CONFIG_SERIAL_8250_RSA=y
> > > +CONFIG_SERIAL_8250_SHARE_IRQ=y
> > > +CONFIG_SERIAL_8250=y
> > > +CONFIG_SERIAL_NONSTANDARD=y
> > > +CONFIG_SERIO_LIBPS2=y
> > > +CONFIG_SGI_PARTITION=y
> > > +CONFIG_SMP=y
> > > +CONFIG_SOCK_CGROUP_DATA=y
> > > +CONFIG_SOLARIS_X86_PARTITION=y
> > > +CONFIG_SUN_PARTITION=y
> > > +CONFIG_SYNC_FILE=y
> > > +CONFIG_SYSVIPC=y
> > > +CONFIG_TASK_DELAY_ACCT=y
> > > +CONFIG_TASK_IO_ACCOUNTING=y
> > > +CONFIG_TASKSTATS=y
> > > +CONFIG_TASK_XACCT=y
> > > +CONFIG_TCP_CONG_ADVANCED=y
> > > +CONFIG_TCP_MD5SIG=y
> > > +CONFIG_TLS=y
> > > +CONFIG_TMPFS_POSIX_ACL=y
> > > +CONFIG_TMPFS=y
> > > +CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> > > +CONFIG_TRANSPARENT_HUGEPAGE=y
> > > +CONFIG_TUN=y
> > > +CONFIG_UNIXWARE_DISKLABEL=y
> > > +CONFIG_UNIX=y
> > > +CONFIG_USER_NS=y
> > > +CONFIG_VALIDATE_FS_PARSER=y
> > > +CONFIG_VETH=y
> > > +CONFIG_VIRT_DRIVERS=y
> > > +CONFIG_VIRTIO_BALLOON=y
> > > +CONFIG_VIRTIO_BLK=y
> > > +CONFIG_VIRTIO_CONSOLE=y
> > > +CONFIG_VIRTIO_FS=y
> > > +CONFIG_VIRTIO_NET=y
> > > +CONFIG_VIRTIO_PCI=y
> > > +CONFIG_VLAN_8021Q=y
> > > +CONFIG_XFRM_SUB_POLICY=y
> > > +CONFIG_XFRM_USER=y
> > > +CONFIG_ZEROPLUS_FF=y
> > > diff --git a/tools/testing/selftests/hid/config.x86_64
> > b/tools/testing/selftests/hid/config.x86_64
> > > new file mode 100644
> > > index 000000000000..a8721f403c21
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/hid/config.x86_64
> > > @@ -0,0 +1,4 @@
> > > +CONFIG_X86_ACPI_CPUFREQ=y
> > > +CONFIG_X86_CPUID=y
> > > +CONFIG_X86_MSR=y
> > > +CONFIG_X86_POWERNOW_K8=y
> > > diff --git a/tools/testing/selftests/hid/vmtest.sh
> > b/tools/testing/selftests/hid/vmtest.sh
> > > new file mode 100755
> > > index 000000000000..90f34150f257
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/hid/vmtest.sh
> > > @@ -0,0 +1,284 @@
> > > +#!/bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +
> > > +set -u
> > > +set -e
> > > +
> > > +# This script currently only works for x86_64
> > > +ARCH="$(uname -m)"
> > > +case "${ARCH}" in
> > > +x86_64)
> > > +   QEMU_BINARY=qemu-system-x86_64
> > > +   BZIMAGE="arch/x86/boot/bzImage"
> > > +   ;;
> > > +*)
> > > +   echo "Unsupported architecture"
> > > +   exit 1
> > > +   ;;
> > > +esac
> > > +DEFAULT_COMMAND="./hid_bpf"
> > > +SCRIPT_DIR="$(dirname $(realpath $0))"
> > > +OUTPUT_DIR="$SCRIPT_DIR/results"
> > >
> > +KCONFIG_REL_PATHS=("${SCRIPT_DIR}/config" "${SCRIPT_DIR}/config.common" "${SCRIPT_DIR}/config.${ARCH}")
> > >
> > +B2C_URL="https://gitlab.freedesktop.org/mupuf/boot2container/-/raw/master/vm2c.py"
> > > +NUM_COMPILE_JOBS="$(nproc)"
> > > +LOG_FILE_BASE="$(date +"hid_selftests.%Y-%m-%d_%H-%M-%S")"
> > > +LOG_FILE="${LOG_FILE_BASE}.log"
> > > +EXIT_STATUS_FILE="${LOG_FILE_BASE}.exit_status"
> > > +CONTAINER_IMAGE="registry.fedoraproject.org/fedora:36"
> > > +
> > > +usage()
> > > +{
> > > +   cat <<EOF
> > > +Usage: $0 [-i] [-s] [-d <output_dir>] -- [<command>]
> > > +
> > > +<command> is the command you would normally run when you are in
> > > +tools/testing/selftests/bpf. e.g:
> > > +
> > > +   $0 -- ./hid_bpf
> > > +
> > > +If no command is specified and a debug shell (-s) is not requested,
> > > +"${DEFAULT_COMMAND}" will be run by default.
> > > +
> > > +If you build your kernel using KBUILD_OUTPUT= or O= options, these
> > > +can be passed as environment variables to the script:
> > > +
> > > +  O=<kernel_build_path> $0 -- ./hid_bpf
> > > +
> > > +or
> > > +
> > > +  KBUILD_OUTPUT=<kernel_build_path> $0 -- ./hid_bpf
> > > +
> > > +Options:
> > > +
> > > +   -u)             Update the boot2container script to a newer version.
> > > +   -d)             Update the output directory (default: ${OUTPUT_DIR})
> > > +   -j)             Number of jobs for compilation, similar to -j in make
> > > +                   (default: ${NUM_COMPILE_JOBS})
> > > +   -s)             Instead of powering off the VM, start an interactive
> > > +                   shell. If <command> is specified, the shell runs after
> > > +                   the command finishes executing
> > > +EOF
> > > +}
> > > +
> > > +download()
> > > +{
> > > +   local file="$1"
> > > +
> > > +   echo "Downloading $file..." >&2
> > > +   curl -Lsf "$file" -o "${@:2}"
> > > +}
> > > +
> > > +recompile_kernel()
> > > +{
> > > +   local kernel_checkout="$1"
> > > +   local make_command="$2"
> > > +
> > > +   cd "${kernel_checkout}"
> > > +
> > > +   ${make_command} olddefconfig
> > > +   ${make_command}
> > > +}
> > > +
> > > +update_selftests()
> > > +{
> > > +   local kernel_checkout="$1"
> > > +   local selftests_dir="${kernel_checkout}/tools/testing/selftests/hid"
> > > +
> > > +   cd "${selftests_dir}"
> > > +   ${make_command}
> > > +}
> > > +
> > > +run_vm()
> > > +{
> > > +   local b2c="$1"
> > > +   local kernel_bzimage="$2"
> > > +   local command="$3"
> > > +   local post_command=""
> > > +
> > > +   if ! which "${QEMU_BINARY}" &> /dev/null; then
> > > +           cat <<EOF
> > > +Could not find ${QEMU_BINARY}
> > > +Please install qemu or set the QEMU_BINARY environment variable.
> > > +EOF
> > > +           exit 1
> > > +   fi
> > > +
> > > +   # alpine (used in post-container requires the PATH to have /bin
> > > +   export PATH=$PATH:/bin
> > > +
> > > +   if [[ "${debug_shell}" != "yes" ]]
> > > +   then
> > > +           touch ${OUTPUT_DIR}/${LOG_FILE}
> > > +           command="mount bpffs -t bpf /sys/fs/bpf/; set -o pipefail ;
> > ${command} 2>&1 | tee ${OUTPUT_DIR}/${LOG_FILE}"
> > > +           post_command="cat ${OUTPUT_DIR}/${LOG_FILE}"
> > > +   else
> > > +           command="mount bpffs -t bpf /sys/fs/bpf/; ${command}"
> > > +   fi
> > > +
> > > +   set +e
> > > +   $b2c --command "${command}" \
> > > +        --kernel ${kernel_bzimage} \
> > > +        --workdir ${OUTPUT_DIR} \
> > > +        --image ${CONTAINER_IMAGE}
> > > +
> > > +   echo $? > ${OUTPUT_DIR}/${EXIT_STATUS_FILE}
> > > +
> > > +   set -e
> > > +
> > > +   ${post_command}
> > > +}
> > > +
> > > +is_rel_path()
> > > +{
> > > +   local path="$1"
> > > +
> > > +   [[ ${path:0:1} != "/" ]]
> > > +}
> > > +
> > > +do_update_kconfig()
> > > +{
> > > +   local kernel_checkout="$1"
> > > +   local kconfig_file="$2"
> > > +
> > > +   rm -f "$kconfig_file" 2> /dev/null
> > > +
> > > +   for config in "${KCONFIG_REL_PATHS[@]}"; do
> > > +           local kconfig_src="${config}"
> > > +           cat "$kconfig_src" >> "$kconfig_file"
> > > +   done
> > > +}
> > > +
> > > +update_kconfig()
> > > +{
> > > +   local kernel_checkout="$1"
> > > +   local kconfig_file="$2"
> > > +
> > > +   if [[ -f "${kconfig_file}" ]]; then
> > > +           local local_modified="$(stat -c %Y "${kconfig_file}")"
> > > +
> > > +           for config in "${KCONFIG_REL_PATHS[@]}"; do
> > > +                   local kconfig_src="${config}"
> > > +                   local src_modified="$(stat -c %Y "${kconfig_src}")"
> > > +                   # Only update the config if it has been updated after the
> > > +                   # previously cached config was created. This avoids
> > > +                   # unnecessarily compiling the kernel and selftests.
> > > +                   if [[ "${src_modified}" -gt "${local_modified}" ]]; then
> > > +                           do_update_kconfig "$kernel_checkout" "$kconfig_file"
> > > +                           # Once we have found one outdated configuration
> > > +                           # there is no need to check other ones.
> > > +                           break
> > > +                   fi
> > > +           done
> > > +   else
> > > +           do_update_kconfig "$kernel_checkout" "$kconfig_file"
> > > +   fi
> > > +}
> > > +
> > > +main()
> > > +{
> > > +   local script_dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
> > pwd -P)"
> > > +   local kernel_checkout=$(realpath "${script_dir}"/../../../../)
> > > +   # By default the script searches for the kernel in the checkout
> > directory but
> > > +   # it also obeys environment variables O= and KBUILD_OUTPUT=
> > > +   local kernel_bzimage="${kernel_checkout}/${BZIMAGE}"
> > > +   local command="${DEFAULT_COMMAND}"
> > > +   local update_b2c="no"
> > > +   local debug_shell="no"
> > > +
> > > +   while getopts ':hsud:j:' opt; do
> > > +           case ${opt} in
> > > +           u)
> > > +                   update_b2c="yes"
> > > +                   ;;
> > > +           d)
> > > +                   OUTPUT_DIR="$OPTARG"
> > > +                   ;;
> > > +           j)
> > > +                   NUM_COMPILE_JOBS="$OPTARG"
> > > +                   ;;
> > > +           s)
> > > +                   command="/bin/sh"
> > > +                   debug_shell="yes"
> > > +                   ;;
> > > +           h)
> > > +                   usage
> > > +                   exit 0
> > > +                   ;;
> > > +           \? )
> > > +                   echo "Invalid Option: -$OPTARG"
> > > +                   usage
> > > +                   exit 1
> > > +                   ;;
> > > +           : )
> > > +                   echo "Invalid Option: -$OPTARG requires an argument"
> > > +                   usage
> > > +                   exit 1
> > > +                   ;;
> > > +           esac
> > > +   done
> > > +   shift $((OPTIND -1))
> > > +
> > > +   # trap 'catch "$?"' EXIT
> > > +
> > > +   if [[ "${debug_shell}" == "no" ]]; then
> > > +           if [[ $# -eq 0 ]]; then
> > > +                   echo "No command specified, will run ${DEFAULT_COMMAND} in the vm"
> > > +           else
> > > +                   command="$@"
> > > +
> > > +                   if [[ "${command}" == "/bin/bash" || "${command}" == "bash" ]]
> > > +                   then
> > > +                           debug_shell="yes"
> > > +                   fi
> > > +           fi
> > > +   fi
> > > +
> > > +   local kconfig_file="${OUTPUT_DIR}/latest.config"
> > > +   local make_command="make -j ${NUM_COMPILE_JOBS}
> > KCONFIG_CONFIG=${kconfig_file}"
> > > +
> > > +   # Figure out where the kernel is being built.
> > > +   # O takes precedence over KBUILD_OUTPUT.
> > > +   if [[ "${O:=""}" != "" ]]; then
> > > +           if is_rel_path "${O}"; then
> > > +                   O="$(realpath "${PWD}/${O}")"
> > > +           fi
> > > +           kernel_bzimage="${O}/${BZIMAGE}"
> > > +           make_command="${make_command} O=${O}"
> > > +   elif [[ "${KBUILD_OUTPUT:=""}" != "" ]]; then
> > > +           if is_rel_path "${KBUILD_OUTPUT}"; then
> > > +                   KBUILD_OUTPUT="$(realpath "${PWD}/${KBUILD_OUTPUT}")"
> > > +           fi
> > > +           kernel_bzimage="${KBUILD_OUTPUT}/${BZIMAGE}"
> > > +           make_command="${make_command} KBUILD_OUTPUT=${KBUILD_OUTPUT}"
> > > +   fi
> > > +
> > > +   local b2c="${OUTPUT_DIR}/vm2c.py"
> > > +
> > > +   echo "Output directory: ${OUTPUT_DIR}"
> > > +
> > > +   mkdir -p "${OUTPUT_DIR}"
> > > +   update_kconfig "${kernel_checkout}" "${kconfig_file}"
> > > +
> > > +   recompile_kernel "${kernel_checkout}" "${make_command}"
> > > +
> > > +   if [[ "${update_b2c}" == "no" && ! -f "${b2c}" ]]; then
> > > +           echo "vm2c script not found in ${b2c}"
> > > +           update_b2c="yes"
> > > +   fi
> > > +
> > > +   if [[ "${update_b2c}" == "yes" ]]; then
> > > +           download $B2C_URL $b2c
> > > +           chmod +x $b2c
> > > +   fi
> > > +
> > > +   update_selftests "${kernel_checkout}" "${make_command}"
> > > +   run_vm $b2c "${kernel_bzimage}" "${command}"
> > > +   if [[ "${debug_shell}" != "yes" ]]; then
> > > +           echo "Logs saved in ${OUTPUT_DIR}/${LOG_FILE}"
> > > +   fi
> > > +
> > > +   exit $(cat ${OUTPUT_DIR}/${EXIT_STATUS_FILE})
> > > +}
> > > +
> > > +main "$@"
> > > --
> > > 2.38.1
> > >
>

