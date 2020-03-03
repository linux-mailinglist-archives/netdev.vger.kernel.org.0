Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B435F176D8E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCCDae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 22:30:34 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39599 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCCDad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 22:30:33 -0500
Received: by mail-qt1-f195.google.com with SMTP id e13so1803691qts.6
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 19:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=DaHLpdiBlyZ5aocxfIb4fu+kPG6RvfW349MD5J1GCAM=;
        b=DQ/BFr+N8OjmTZuuYxf+AwZYHFG4nvqJbsDZoslsQs1UZIR1qMEQawindjRA44GBje
         /QighAz9NVA0ZZ4O0Qa2wsTcNaEalRjxHAmGrZqxsI06rqM+rIrnzvI5PFwQOzbiCBVS
         lO+NMhYcYEM2xHnPeQxVEcG9KgL56qV6McBJNd5hjGbWc0/O7Im9B6mCRbK7b9K+TqgT
         IUmqFScu55/vg1yQfHKfcGnpIbhHlMpYpkfEG8oylfRYDhQYjnGrPJjc7DO2k7EEE0kl
         4McQVuZ166+WXkCHcSWqQcd0NDX6sLIenXOxLNNXe5P/WXTzcN5yHpr8T0SnZCa7jIJX
         COWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=DaHLpdiBlyZ5aocxfIb4fu+kPG6RvfW349MD5J1GCAM=;
        b=FnzANfQ1CHLhwSdBBDoCgIbAk3g16HS46pZS1cNzSEE2YD3yOz84Hca62tH4N8PFkw
         19xQLuQz6QfzUGO9hLC/sVFFecN+3gaBc5KH/Xr0ASVuGLE4HjWJpUMZdz3Wwwks27Oq
         Q2p8ORDic/6ZtFoQzGtlHT4SmrRl9BmoOUctman2DCo7475ULw3s2zC1pDsWDkpAxtRR
         D4GZtHvnT2K258T8P0QJIZPSXs1wIHhV96qqPCfbPurkSvEKDI5qZ/FIpgqoaj72mZtI
         XBldsq2UHmZkdoLoCuNvr/JseKy4wToJfk/GvgFlVqRKLOT8Ol6SSJ2P3uhPszxRd8Ar
         jtzA==
X-Gm-Message-State: ANhLgQ1/jmWpjAfPJx4u9iJag97RnZC3OupGw+IXQCbVD3NT3RIbSdjV
        J+mCmZ2M17s8p/N/b+6xHmhVkg==
X-Google-Smtp-Source: ADFU+vvqzorLufp6VGvDEkX7xhQQsZvcWgVAWNMnWB1qzrmDwjFW12GPtp7yL61xLPRg3QWt5sm6qA==
X-Received: by 2002:ac8:2784:: with SMTP id w4mr2645695qtw.218.1583206232090;
        Mon, 02 Mar 2020 19:30:32 -0800 (PST)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id v6sm10598859qtc.76.2020.03.02.19.30.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 19:30:31 -0800 (PST)
From:   Qian Cai <cai@lca.pw>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Crashes due to "s390/qeth: don't check for IFF_UP when scheduling
 napi"
Message-Id: <5281E33C-21F3-4879-A539-52826D82AFBD@lca.pw>
Date:   Mon, 2 Mar 2020 22:30:30 -0500
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        ubraun@linux.ibm.com
To:     jwi@linux.ibm.com
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reverted the linux-next commit 3d35dbe6224e =E2=80=9Cs390/qeth: don't =
check for IFF_UP when scheduling napi=E2=80=9D
fixed several crashes could happen during boot,

01: [   79.051526] XFS (dm-2): Mounting V5 Filesystem                    =
      =20
00: [   79.420398] XFS (dm-2): Ending clean mount                        =
      =20
00: [   79.439284] xfs filesystem being mounted at /home supports =
timestamps unt
00: il 2038 (0x7fffffff)                                                 =
      =20
00: [   98.203218] ------------[ cut here ]------------                  =
      =20
00: [   98.203640] kernel BUG at include/linux/netdevice.h:516!          =
      =20
00: [   98.203725] monitor event: 0040 ilc:2 [#1] SMP DEBUG_PAGEALLOC    =
      =20
00: [   98.203744] Modules linked in: ip_tables x_tables xfs =
dasd_fba_mod dasd_e
00: ckd_mod dm_mirror dm_region_hash dm_log dm_mod                       =
      =20
00: [   98.203779] CPU: 0 PID: 1127 Comm: NetworkManager Not tainted =
5.6.0-rc3-n
00: ext-20200302+ #4                                                     =
      =20
00: [   98.203794] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)          =
      =20
00: [   98.203808] Krnl PSW : 0704c00180000000 00000000309cccc4 =
(qeth_open+0x2f4
00: /0x320)                                                              =
      =20
00: [   98.203836]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 =
CC:0 PM:0
00:  RI:0 EA:3                                                           =
      =20
00: [   98.203853] Krnl GPRS: 0000000000000001 0000000000000010 =
000000004eca57bf
00:  000000004eca57bf                                                    =
      =20
00: [   98.203870]            0000030000000000 00000000309ccb02 =
00000000384e5400
00:  00000000384e5408                                                    =
      =20
00: [   98.203885]            000000004eca57a8 000000004eca57b8 =
00000000384e5000
00:  000000004eca5000                                                    =
      =20
00: [   98.203902]            0000000030fdd900 0000000030d78d00 =
00000000309ccb02
00:  000003e00412ea88                                                    =
      =20
00: [   98.203940] Krnl Code: 00000000309cccb4: c0200052cce6        larl =
   %r2,
00: 0000000031426680                                                     =
      =20
00: [   98.203940]            00000000309cccba: c0e5fff5bf4f        =
brasl   %r14
00: ,0000000030884b58                                                    =
      =20
00: [   98.203940]           #00000000309cccc0: af000000            mc   =
   0,0=20
00: [   98.203940]           >00000000309cccc4: c0200052ccfe        larl =
   %r2,
00: 00000000314266c0                                                     =
      =20
00: [   98.203940]            00000000309cccca: c0e5fff5bf47        =
brasl   %r14
00: ,0000000030884b58                                                    =
      =20
00: [   98.203940]            00000000309cccd0: a728fffb            lhi  =
   %r2,
00: -5                                                                   =
      =20
00: [   98.203940]            00000000309cccd4: a7f4ff55            brc  =
   15,0
00: 0000000309ccb7e                                                      =
      =20
00: [   98.203940]            00000000309cccd8: b9040039            lgr  =
   %r3,
00: %r9                                                                  =
      =20
00: [   98.204221] Call Trace:                                           =
      =20
00: [   98.204277]  [<00000000309cccc4>] qeth_open+0x2f4/0x320 =20
napi_enable at include/linux/netdevice.h:516
(inlined by) qeth_open at drivers/s390/net/qeth_core_main.c:6591         =
      =20
00: [   98.204292] ([<00000000309ccaf8>] qeth_open+0x128/0x320)          =
      =20
00: [   98.204308]  [<0000000030a3c778>] __dev_open+0x190/0x268          =
      =20
00: [   98.204324]  [<0000000030a3ce80>] __dev_change_flags+0x2e8/0x378  =
      =20
00: [   98.204340]  [<0000000030a3cf6e>] dev_change_flags+0x5e/0xb0      =
      =20
00: [   98.204357]  [<0000000030a60a16>] do_setlink+0x59e/0x1728         =
      =20
00: [   98.204372]  [<0000000030a62750>] __rtnl_newlink+0x708/0xbd0      =
      =20
00: [   98.204388]  [<0000000030a62c86>] rtnl_newlink+0x6e/0x90          =
      =20
00: [   98.204404]  [<0000000030a59004>] rtnetlink_rcv_msg+0x29c/0x6e0   =
      =20
00: [   98.204421]  [<0000000030aa9cd2>] netlink_rcv_skb+0xea/0x218      =
      =20
00: [   98.204436]  [<0000000030aa8f5a>] netlink_unicast+0x2d2/0x3a0     =
      =20
00: [   98.204451]  [<0000000030aa95dc>] netlink_sendmsg+0x5b4/0x6c0     =
      =20
00: [   98.204469]  [<00000000309e76a6>] ____sys_sendmsg+0x32e/0x3c8     =
      =20
00: [   98.204485]  [<00000000309e8d08>] ___sys_sendmsg+0x108/0x148      =
      =20
00: [   98.204500]  [<00000000309ec2a8>] __sys_sendmsg+0xe0/0x148        =
      =20
00: [   98.204515]  [<00000000309ecda6>] =
__s390x_sys_socketcall+0x356/0x430    =20
00: [   98.204532]  [<0000000030be3568>] system_call+0xd8/0x2b4          =
      =20
00: [   98.204544] INFO: lockdep is turned off.                          =
      =20
00: [   98.204555] Last Breaking-Event-Address:                          =
      =20
00: [   98.204568]  [<00000000309ccb0c>] qeth_open+0x13c/0x320           =
      =20
00: [   98.204585] Kernel panic - not syncing: Fatal exception: =
panic_on_oops  =20
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP =
stop from
 CPU 01.                                                                 =
      =20
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP =
stop from
 CPU 00.                                                                 =
      =20
00: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 =
302A66EE



00: [   28.095006] illegal operation: 0001 ilc:1 [#1] SMP =
DEBUG_PAGEALLOC       =20
00: [   28.095045] Modules linked in: dm_mirror dm_region_hash dm_log =
dm_mod    =20
00: [   28.095075] CPU: 0 PID: 432 Comm: ccw_init Not tainted =
5.6.0-rc3-next-20 =20
00: 00302+ #2                                                            =
       =20
00: [   28.095090] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)          =
       =20
00: [   28.095103] Krnl PSW : 0704e00180000000 0000000000000002 (0x2)    =
       =20
00: [   28.095124]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 =
CC:2 PM:0=20
00:  RI:0 EA:3                                                           =
       =20
00: [   28.095141] Krnl GPRS: 0000000000000001 0000000000000000 =
00000000475597a8=20
00:  0000000000000000                                                    =
       =20
00: [   28.095157]            0000030000000000 0000000005e6b280 =
000000000639d197=20
00:  00000000475597a8                                                    =
       =20
00: [   28.095174]            000003e000000000 000003e00014fc78 =
000003e00014fbf8=20
00:  00000000475597a8                                                    =
       =20
00: [   28.095189]            000000000640d900 00000000061a8aa0 =
0000000005e6b29a=20
00:  000003e00014fa68                                                    =
       =20
00: [   28.095210] Krnl Code:#0000000000000000: 0000                =
illegal     =20
00: [   28.095210]           >0000000000000002: 0000                =
illegal     =20
00: [   28.095210]            0000000000000004: 0000                =
illegal     =20
00: [   28.095210]            0000000000000006: 0000                =
illegal     =20
00: [   28.095210]            0000000000000008: 0000                =
illegal     =20
00: [   28.095210]            000000000000000a: 0000                =
illegal     =20
00: [   28.095210]            000000000000000c: 0000                =
illegal     =20
00: [   28.095210]            000000000000000e: 0000                =
illegal     =20
00: [   28.095279] Call Trace:                                           =
       =20
00: [   28.095290]  [<0000000000000002>] 0x2                             =
       =20
00: [   28.095318] ([<0000000005e6b254>] net_rx_action+0x2c4/0x9e0)   =20=

arch_test_bit at arch/s390/include/asm/bitops.h:219
(inlined by) test_bit at =
include/asm-generic/bitops/instrumented-non-atomic.h:111
(inlined by) napi_poll at net/core/dev.c:6569
(inlined by) net_rx_action at net/core/dev.c:6638         =20
00: [   28.095338]  [<00000000060147f2>] __do_softirq+0x1da/0xa28        =
       =20
00: [   28.095362]  [<00000000056d488c>] do_softirq_own_stack+0xe4/0x100 =
       =20
00: [   28.095665]  [<000000000571f438>] irq_exit+0x148/0x1c0            =
       =20
00: [   28.095684]  [<00000000056d4048>] do_IRQ+0xb8/0x108               =
       =20
00: [   28.095702]  [<0000000006013a3c>] io_int_handler+0x12c/0x2b8      =
       =20
00: [   28.095719]  [<00000000057d4f48>] lock_acquire+0x248/0x460        =
       =20
00: [   28.095735] ([<00000000057d4f12>] lock_acquire+0x212/0x460)       =
       =20
00: [   28.095754]  [<0000000005a8c994>] lock_page_memcg+0x54/0x180      =
       =20
00: [   28.095772]  [<00000000059f0dd2>] page_remove_rmap+0x17a/0x8c0    =
       =20
00: [   28.095787]  [<00000000059cdde6>] unmap_page_range+0x956/0x1690   =
       =20
00: [   28.095801]  [<00000000059cebe0>] unmap_single_vma+0xc0/0x148     =
       =20
00: [   28.095816]  [<00000000059ceed4>] unmap_vmas+0x54/0x88            =
       =20
00: [   28.095831]  [<00000000059e3198>] exit_mmap+0x1b0/0x2a8           =
       =20
00: [   28.095846]  [<0000000005709ef6>] mmput+0xce/0x230                =
       =20
00: [   28.095860]  [<000000000571c750>] do_exit+0x5b0/0x1538            =
       =20
00: [   28.095875]  [<000000000571d7ce>] do_group_exit+0x7e/0x150        =
       =20
00: [   28.095889]  [<000000000571d8d2>] =
__s390x_sys_exit_group+0x32/0x38       =20
00: [   28.095905]  [<00000000060136b6>] system_call+0x296/0x2b4         =
       =20
00: [   28.095917] INFO: lockdep is turned off.                          =
       =20
00: [   28.095928] Last Breaking-Event-Address:                          =
       =20
00: [   28.095944]  [<0000000005e6b298>] net_rx_action+0x308/0x9e0   =20
napi_poll at net/core/dev.c:6570
(inlined by) net_rx_action at net/core/dev.c:6638          =20
00: [   28.095964] Kernel panic - not syncing: Fatal exception in =
interrupt


00: [   28.034050] qeth 0.0.8000: MAC address 02:de:ad:be:ef:87 =
successfully reg=20
00: istered                                                              =
       =20
00: [   28.040202] illegal operation: 0001 ilc:1 [#1] SMP =
DEBUG_PAGEALLOC       =20
00: [   28.040226] Modules linked in: dm_mirror dm_region_hash dm_log =
dm_mod    =20
00: [   28.040254] CPU: 0 PID: 402 Comm: systemd-udevd Not tainted =
5.6.0-rc3-nex=20
00: t-20200302+ #3                                                       =
       =20
00: [   28.040271] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)          =
       =20
00: [   28.040286] Krnl PSW : 0704e00180000000 0000000000000002 (0x2)    =
       =20
00: [   28.040307]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 =
CC:2 PM:0=20
00:  RI:0 EA:3                                                           =
       =20
00: [   28.040324] Krnl GPRS: 0000000000000001 0000000000000000 =
0000000001b517a8=20
00:  0000000000000000                                                    =
       =20
00: [   28.040340]            0000030000000000 00000000303eb2f0 =
000000003091d197=20
00:  0000000001b517a8                                                    =
       =20
00: [   28.040356]            000003e000000000 000003e00014fc78 =
000003e00014fbf8=20
00:  0000000001b517a8                                                    =
       =20
00: [   28.040371]            000000003098d900 0000000030728aa0 =
00000000303eb30 =20
00:  000003e00014fa68                                                    =
       =20
00: [   28.040393] Krnl Code:#0000000000000000: 0000                =
illegal     =20
00: [   28.040393]           >0000000000000002: 0000                =
illegal     =20
00: [   28.040393]            0000000000000004: 0000                =
illegal     =20
00: [   28.040393]            0000000000000006: 0000                =
illegal     =20
00: [   28.040393]            0000000000000008: 0000                =
illegal     =20
00: [   28.040393]            000000000000000a: 0000                =
illegal     =20
00: [   28.040393]            000000000000000c: 0000                =
illegal     =20
00: [   28.040393]            000000000000000e: 0000                =
illegal     =20
00: [   28.040462] Call Trace:                                           =
       =20
00: [   28.040792]  [<0000000000000002>] 0x2                             =
       =20
00: [   28.040907] ([<00000000303eb2c4>] net_rx_action+0x2c4/0x9e0)      =
       =20
00: [   28.040927]  [<0000000030594862>] __do_softirq+0x1da/0xa28        =
       =20
00: [   28.040949]  [<000000002fc5488c>] do_softirq_own_stack+0xe4/0x100 =
       =20
00: [   28.040966]  [<000000002fc9f438>] irq_exit+0x148/0x1c0            =
       =20
00: [   28.040981]  [<000000002fc54048>] do_IRQ+0xb8/0x108               =
       =20
00: [   28.040995]  [<0000000030593aac>] io_int_handler+0x12c/0x2b8      =
       =20
00: [   28.041014]  [<000000002ffe55b0>] __asan_store8+0x10/0x98         =
       =20
00: [   28.041032] ([<000000002fc5fa90>] unwind_next_frame+0x168/0x3e0)  =
       =20
00: [   28.041048]  [<000000002fc669b2>] arch_stack_walk+0x10a/0x178     =
       =20
00: [   28.041065]  [<000000002fda0232>] stack_trace_save+0xba/0xd0      =
       =20
00: [   28.041083]  [<0000000030025d7e>] create_object+0x1d6/0x5c8       =
       =20
00: [   28.041113]  [<000000002ffdb6f2>] kmem_cache_alloc+0x1f2/0x548    =
       =20
00: [   28.041141]  [<000000002ff72ece>] anon_vma_clone+0x96/0x248       =
       =20
00: [   28.041157]  [<000000002ff730de>] anon_vma_fork+0x5e/0x1f0        =
       =20
00: [   28.041175]  [<000000002fc8b9a6>] dup_mm+0x88e/0xa80              =
       =20
00: [   28.041190]  [<000000002fc8dc26>] copy_process+0x183e/0x2d20      =
       =20
00: [   28.041205]  [<000000002fc8f504>] _do_fork+0x134/0xab0            =
       =20
00: [   28.041220]  [<000000002fc9009e>] __do_sys_clone+0xce/0x110       =
       =20
00: [   28.041235]  [<000000002fc9038a>] __s390x_sys_clone+0x22/0x30     =
       =20
00: [   28.041251]  [<0000000030593726>] system_call+0x296/0x2b4         =
       =20
00: [   28.041263] INFO: lockdep is turned off.                          =
       =20
00: [   28.041274] Last Breaking-Event-Address:                          =
       =20
00: [   28.041289]  [<00000000303eb308>] net_rx_action+0x308/0x9e0       =
       =20
00: [   28.041308] Kernel panic - not syncing: Fatal exception in =
interrupt=
