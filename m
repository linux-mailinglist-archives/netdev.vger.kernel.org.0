Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7FC304D9A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732694AbhAZXMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405688AbhAZUyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 15:54:11 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D80C0613ED
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 12:53:30 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id n10so11617pgl.10
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 12:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ApIlj2m1tg9+idmfqK1mcM1QR+AeXvDwlCYdSEUBDFk=;
        b=QAG3ZnqTGFU5CTq5o3ooYo7MdlbYsnqIDwO3FFRvgDiCL8XJ1JyvXCmWy6yX6QmeEj
         wA+NtZgIPYCxajoi8ztD69jXW2Wvkhlp9UZpFvxQBqvAAx0ZXAs4Gmvyod3Wnd7bUkKj
         9Cl7MwYRbnQ69lDTmfYyLZflfei2znRtfFk1o+tMYrGdNVi0WBjyZCXrxbUwg57pYNta
         z75U3Jmj/sWPArOSsWrOxRDfzdJcdsBGvj4V3GPUsPFrs/xiy//3aWCTZUPyXZjfEVoF
         aWuKHNxXDKiWEBra7Z9LFmi9kbe/pFPMt7mqyTXF40JkcEeeXo9P5lzWOcQqpCl6ieTd
         jkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ApIlj2m1tg9+idmfqK1mcM1QR+AeXvDwlCYdSEUBDFk=;
        b=YKGn2QrdiFFlVQHTuE9dXFgZ/riDzYNQZ9Ti3yqIXkhW23/tR9MmA0rG69vqUxa1n5
         fUpZMDEct+lWZEA9qBsUFWzY4Sz9VucPHKKk7L4J6+0uIwTcRnj6zgnAGzI4PoIwzdrm
         SUbT3gATRZfiIIfPisGTnTMlHPfW2GRNSdNjzBstLbvxKznvVnv1eE7wQg6TYfO+rDFS
         eIhUV5KmbNq2zFRJcx1902NTAj6MlL9XfBs5f9q4w2vUK52V2PIAFfdtcc0Y2ZQXvXwZ
         Rx21RlbdSaSPp9FRVZC5gP/vT6dZ7KJCBQJbEjq7tlZ5C9NMCjFLwhHVUJBFnF7bcKm1
         cJCQ==
X-Gm-Message-State: AOAM5328sVeIjM9wrGNLAWDENbG9JVlh4Lg7/DArPjnqG+ZYuwmwB+xO
        i8xxcRaTUTNOBfB6L0MyHqW6uEsaGqDIiw==
X-Google-Smtp-Source: ABdhPJxlWhmj4JoERuzU2SehTcILCD19z2gzpb1x2VmANRXbwtwj8Af7+eysX5etNBZNdHuYXtHX2w==
X-Received: by 2002:a62:8801:0:b029:1b9:c4af:8148 with SMTP id l1-20020a6288010000b02901b9c4af8148mr6902925pfd.18.1611694409776;
        Tue, 26 Jan 2021 12:53:29 -0800 (PST)
Received: from hermes.local (76-14-222-244.or.wavecable.com. [76.14.222.244])
        by smtp.gmail.com with ESMTPSA id l13sm3110411pjh.2.2021.01.26.12.53.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 12:53:29 -0800 (PST)
Date:   Tue, 26 Jan 2021 12:53:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 211351] New: =?UTF-8?B?U3l6a2FsbGVy77yacmVhZC1vbmx5?=
 memory access caused with the __ro_after_init
Message-ID: <20210126125320.5dc8691d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 26 Jan 2021 14:20:52 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 211351] New: Syzkaller=EF=BC=9Aread-only memory access caused=
 with the __ro_after_init


https://bugzilla.kernel.org/show_bug.cgi?id=3D211351

            Bug ID: 211351
           Summary: Syzkaller=EF=BC=9Aread-only memory access caused with t=
he
                    __ro_after_init
           Product: Networking
           Version: 2.5
    Kernel Version: 4.19.90
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: kircherlike@outlook.com
        Regression: No

When we use the kernel 4.19 to perform the Syzkaller test, we find the
following problems:

[ 273.278134] Internal error: Oops: 9600004f [#1] SMP
[ 273.278883] Process modprobe (pid: 9664, stack limit =3D 0x000000004ac45a=
30)
[ 273.279822] CPU: 1 PID: 9664 Comm: modprobe Kdump: loaded Not tainted
4.19.90-aarch64 #1
[ 273.281370] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 273.282377] pstate: 60400005 (nZCv daif +PAN -UAO)
[ 273.283087] pc : genl_register_family+0x41c/0xc28
[ 273.283782] lr : genl_register_family+0x41c/0xc28
[ 273.284488] sp : ffff800161c0f820
[ 273.284981] x29: ffff800161c0f820 x28: ffff200083af0160
[ 273.285768] x27: ffff200083aef6e0 x26: 0000000000000007
[ 273.286554] x25: ffff20000354e048 x24: 0000000000000013
[ 273.287339] x23: ffff8001acbdf700 x22: ffff20000354e008
[ 273.288122] x21: 00000000000003ff x20: ffff200083aef000
[ 273.288927] x19: ffff20000354e000 x18: 0000000000000000
[ 273.289711] x17: 0000000000000000 x16: ffff200081153130
[ 273.290474] x15: 0000000000000000 x14: ffff2000802f0664
[ 273.291187] x13: ffff2000802eff34 x12: ffff2000802f29bc
[ 273.291899] x11: ffff20008008649c x10: ffff200003558030
[ 273.292621] x9 : ffff200081153540 x8 : ffff200080085150
[ 273.293335] x7 : ffff2000800aa958 x6 : ffff200083eec320
[ 273.294048] x5 : ffff80018ed2c000 x4 : ffff20000354e048
[ 273.294760] x3 : 0000000000001c80 x2 : dfff200000000000
[ 273.295472] x1 : 0000000000000007 x0 : 0000000000000000
[ 273.296187] Call trace:
[ 273.296538] genl_register_family+0x41c/0xc28
[ 273.297126] l2tp_nl_init+0x30/0x1000 [l2tp_netlink]
[ 273.297793] do_one_initcall+0xb4/0x508
[ 273.298311] do_init_module+0xe0/0x2ec
[ 273.298813] load_module+0x24ec/0x2760
[ 273.299317] __se_sys_finit_module+0x184/0x198
[ 273.299896] __arm64_sys_finit_module+0x4c/0x60
[ 273.300505] el0_svc_common+0xc8/0x2b8
[ 273.300999] el0_svc_handler+0xf8/0x160
[ 273.301503] el0_svc+0x10/0x218
[ 273.301917] Code: 97d20345 aa0003f7 aa1903e0 97d21ffa (f9002677)
[ 273.302719] kernel fault(0x1) notification starting on CPU 1
[ 273.303456] kernel fault(0x1) notification finished on CPU 1
[ 273.304177] Modules linked in: l2tp_netlink(+) l2tp_core pptp pppox
ppp_generic slhc vhost_net nf_conntrack_netlink nfnetlink_cttimeout
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 loop nf_tables nfnetlink sctp
vhost_vsock vmw_vsock_virtio_transport_common vhost vsock libcrc32c
scsi_transport_iscsi af_key drop_monitor ip6_vti ip_vti ip_gre ipip sit tun=
nel4
ip_tunnel geneve ip6_udp_tunnel udp_tunnel macsec macvtap tap ipvlan macvlan
8021q veth nlmon dummy bonding bridge stp llc ip6_gre ip6_tunnel tunnel6 gre
tun binfmt_misc rfkill sunrpc vfat fat aes_ce_blk crypto_simd cryptd
aes_ce_cipher ghash_ce sha2_ce sha256_arm64 sha1_ce sch_fq_codel ext4 mbcac=
he
jbd2 virtio_net virtio_gpu net_failover virtio_blk failover virtio_pci
virtio_mmio virtio_ring virtio dm_mirror dm_region_hash dm_log dm_mod
[ 273.313123] ---[ end trace ceac72010c07a5cf ]---
[ 273.320130] Kernel panic - not syncing: Fatal exception
[ 273.327168] kernel fault(0x5) notification starting on CPU 1
[ 273.334218] kernel fault(0x5) notification finished on CPU 1
[ 273.341137] SMP: stopping secondary CPUs
[ 273.347680] Kernel Offset: disabled
[ 273.353791] CPU features: 0x52,a2200238
[ 273.359831] Memory Limit: none
[ 273.366455] Starting crashdump kernel...
[ 273.372440] Bye!

This problem occurs not only on the L2TP module, but also on the DevLink
module.Their call stacks are even the same.


[  152.976384] Unable to handle kernel write to read-only memory at virtual
address ffff200001e77048
[  152.976398] Mem abort info:
[  152.976407]   ESR =3D 0x9600004f
[  152.976418]   Exception class =3D DABT (current EL), IL =3D 32 bits
[  152.976427]   SET =3D 0, FnV =3D 0
[  152.976435]   EA =3D 0, S1PTW =3D 0
[  152.976444] Data abort info:
[  152.976453]   ISV =3D 0, ISS =3D 0x0000004f
[  152.976461]   CM =3D 0, WnR =3D 1
[  152.976475] swapper pgtable: 4k pages, 48-bit VAs, pgdp =3D 000000009f1f=
ac8f
[  152.976484] [ffff200001e77048] pgd=3D0000000239bfe003, pud=3D00000001efd=
29003,
pmd=3D00000001de566003, pte=3D00600001bd5a1793
[  152.976514] Internal error: Oops: 9600004f [#1] SMP
[  152.977165] Process modprobe (pid: 9552, stack limit =3D 0x0000000028c88=
ea4)
[  152.977942] CPU: 0 PID: 9552 Comm: modprobe Kdump: loaded Not tainted
4.19.90-aarch64 #1
[  152.979414] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15
[  152.980325] pstate: 60400005 (nZCv daif +PAN -UAO)
[  152.980971] pc : genl_register_family+0x41c/0xc28
[  152.981596] lr : genl_register_family+0x41c/0xc28
[  152.982238] sp : ffff80018911f820
[  152.982690] x29: ffff80018911f820 x28: ffff200083af0160
[  152.983420] x27: ffff200083aef6e0 x26: 000000000000002d
[  152.984139] x25: ffff200001e77048 x24: 0000000000000013
[  152.984869] x23: ffff80019cdaf500 x22: ffff200001e77008
[  152.985605] x21: 00000000000003ff x20: ffff200083aef000
[  152.986319] x19: ffff200001e77000 x18: 0000000000000000
[  152.987049] x17: 0000000000000000 x16: ffff200081153130
[  152.987768] x15: 0000000000000000 x14: ffff2000802f0664
[  152.988472] x13: ffff2000802eff34 x12: ffff2000802f29bc
[  152.989183] x11: ffff20008008649c x10: ffff200001da8154
[  152.989892] x9 : ffff200081153540 x8 : ffff200080085150
[  152.990624] x7 : ffff2000800aa958 x6 : ffff200083eec320
[  152.991354] x5 : ffff800181dac000 x4 : ffff200001e77048
[  152.992077] x3 : 0000000000002080 x2 : dfff200000000000
[  152.992798] x1 : 0000000000000007 x0 : 0000000000000000
[  152.993530] Call trace:
[  152.993893]  genl_register_family+0x41c/0xc28
[  152.994504]  devlink_module_init+0x20/0xecc [devlink]
[  152.995199]  do_one_initcall+0xb4/0x508
[  152.995743]  do_init_module+0xe0/0x2ec
[  152.996276]  load_module+0x24ec/0x2760
[  152.996811]  __se_sys_finit_module+0x184/0x198
[  152.997438]  __arm64_sys_finit_module+0x4c/0x60
[  152.998071]  el0_svc_common+0xc8/0x2b8
[  152.998604]  el0_svc_handler+0xf8/0x160
[  152.999144]  el0_svc+0x10/0x218
[  152.999605] Code: 97d20345 aa0003f7 aa1903e0 97d21ffa (f9002677)
[  153.000433] kernel fault(0x1) notification starting on CPU 0
[  153.001205] kernel fault(0x1) notification finished on CPU 0
[  153.001985] Modules linked in: devlink(+) overlay camellia_generic ceph
libceph dns_resolver nfs lockd grace fscache ccm n_gsm ppp_synctty
nfnetlink_cthelper l2tp_ip6 nft_compat n_hdlc loop l2tp_ppp l2tp_netlink
vfio_iommu_type1 vfio cuse serpent_generic xcbc pptp nfnetlink_log
nf_conntrack_netlink nf_tables nfnetlink_cttimeout xt_osf nf_conntrack
nfnetlink_osf nf_defrag_ipv6 nf_defrag_ipv4 vhost_vsock af_key
vmw_vsock_virtio_transport_common vsock uhid nfnetlink_queue ppp_async fuse
pppoe pppox sctp ip_set tcp_diag l2tp_ip libcrc32c l2tp_core inet_diag
nfnetlink_acct ppp_generic slhc nfnetlink vhost_net vhost ip6_vti ip_vti ip=
_gre
ipip sit tunnel4 ip_tunnel geneve ip6_udp_tunnel udp_tunnel macsec macvtap =
tap
ipvlan macvlan 8021q veth nlmon dummy bonding bridge stp llc ip6_gre ip6_tu=
nnel
tunnel6
[  153.011231]  gre binfmt_misc tun rfkill sunrpc vfat fat aes_ce_blk
crypto_simd cryptd aes_ce_cipher ghash_ce sha2_ce sha256_arm64 sha1_ce
sch_fq_codel ext4 mbcache jbd2 virtio_net virtio_gpu net_failover failover
virtio_blk virtio_pci virtio_mmio virtio_ring virtio dm_mirror dm_region_ha=
sh
dm_log dm_mod [last unloaded: devlink]
[  153.015147] ---[ end trace 2f72347ddc77231c ]---
[  153.015779] Kernel panic - not syncing: Fatal exception
[  153.016477] kernel fault(0x5) notification starting on CPU 0
[  153.017242] kernel fault(0x5) notification finished on CPU 0
[  153.018004] SMP: stopping secondary CPUs
[  153.018566] Kernel Offset: disabled
[  153.019070] CPU features: 0x52,a2200238
[  153.019601] Memory Limit: none
[  153.021284] Starting crashdump kernel...
[  153.021843] Bye!

After reading the source code of the two modules, we find that they add the
__ro_after_init modifier to the declaration.

static struct genl_family l2tp_nl_family __ro_after_init =3D ...
static struct genl_family devlink_nl_family __ro_after_init =3D ...

When they enter the lower-level function, genl_register_family attempts to
initialize their id and attrbuf members (although attrbuf has been deleted =
in
the new kernel). Dmesg says they are read-only, which means they have been
initialized before.

When the __ro_after_init is deleted, the Syzkaller does not display this
problem.

We want to know if this is a problem with Syzkaller, or most __ro_after_init
modules do.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
