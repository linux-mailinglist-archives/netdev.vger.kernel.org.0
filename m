Return-Path: <netdev+bounces-4891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 460B570EFF9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AE3F28117A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10617C144;
	Wed, 24 May 2023 07:54:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0532CC143
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:54:29 +0000 (UTC)
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590BA9E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 00:54:27 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-43278f6d551so208532137.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 00:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684914866; x=1687506866;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7yDLtXG+mhBJETNEwxHXiFJwTxzzOPoRqHlYdybJ4KE=;
        b=OoVemZQH79NVLdb52sToFqaDsrsDL3HxgRc5GffvrRf5SyN6/yD36Dw1R7U+rP3qMU
         st5NiAXFPY+lvQx4RCfwKyoU5IyWb/yz/pQUiQor7Li5FTiYjXJyF1b2KuBM8AEgjNrL
         E9WaZrD/t0jiXJpeAb0gPQVLsjCe5ivGuZV2jbMbcBLJHM0ddaq/VXjwyQLnfWRWC6eu
         54wAxl7pXIW59Nig/I19QCCadX7s+Iml6rJpiOW1OAR7BPY0Jn3OfcgYFH3nndKRpNDD
         rWYro2kzlLp+8/Knu5JqY8/67+igbwgzt3T0xuWHk2+sJMMdgHaqROaFu88idal0zgwm
         o7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684914866; x=1687506866;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7yDLtXG+mhBJETNEwxHXiFJwTxzzOPoRqHlYdybJ4KE=;
        b=kIoXDlC2LiIxVteYVJgFbvVSKu61MTjycXlYaeNdr4R6+gixBKfShqn7q/IImOkTR3
         xACT+0eg4RK1vuaNXfFtMKMYGIWwmaJzXKZEX0poNjPL6mASqHHI/MhOVI8rwr6h1wFR
         7SvlXRVzFXBGEg33EMiPuR0WF3leyyku2E0Yv8hLyJwbEEvFRj5aGKBsKlfWpWiGULtJ
         n8LkLExhCP+UIGrbSqthktU0MoB7zE+42yc1Hj5xu9nhNJIheI+sV3TmEt4ekZL6ECGv
         EbXWw/NEBsCfvUVnkHSaHAdt0Vm4V2Mrc5fcM/s8uU8a8YYrIxAor5UpVskvYqzajjDE
         c+TA==
X-Gm-Message-State: AC+VfDzrj+pcAy7No5m09Uuv2E92QFxjsXeDCGiKuMLCw95cCTfMWOwL
	3Eq1F8d2Yj5tYO13gelHOldzzlM8ssd5QNV/1TwaTw==
X-Google-Smtp-Source: ACHHUZ4dsjBg4MOyLc4SIdOK3+lx+zNdtYvoOnkCjQqC/h2K7KYFoT5ODP+XirOYhoqPgpEPVsZS4CmSt9l36mCr0sg=
X-Received: by 2002:a05:6102:34d1:b0:437:da98:e7d2 with SMTP id
 a17-20020a05610234d100b00437da98e7d2mr3923812vst.18.1684914866261; Wed, 24
 May 2023 00:54:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 May 2023 13:24:15 +0530
Message-ID: <CA+G9fYsbr-kTpw3fEF-XEJWv2PHRZ9kaxOrF_OzVkfpLnk3r1A@mail.gmail.com>
Subject: selftests: net: udpgso_bench.sh: RIP: 0010:lookup_reuseport
To: open list <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, 
	linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc: "David S. Miller" <davem@davemloft.net>, Xin Long <lucien.xin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

While running selftests: net: udpgso_bench.sh on qemu-x86_64 the following
kernel crash noticed on stable rc 6.3.4-rc2 kernel.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Test run log:
=========

<12>[   38.049122] kselftest: Running tests in net
TAP version 13
1..16
# selftests: net: udpgso_bench.sh
# ipv4
# tcp
# tcp tx:    230 MB/s     3905 calls/s   3905 msg/s
# tcp rx:    231 MB/s     3668 calls/s
# tcp tx:    225 MB/s     3817 calls/s   3817 msg/s
# tcp rx:    225 MB/s     3525 calls/s
# tcp tx:    225 MB/s     3820 calls/s   3820 msg/s
# tcp zerocopy
# tcp tx:    198 MB/s     3369 calls/s   3369 msg/s
# tcp rx:    197 MB/s     2855 calls/s
# tcp tx:    195 MB/s     3318 calls/s   3318 msg/s
# tcp rx:    197 MB/s     2845 calls/s
# udp
# udp rx:      8 MB/s     5811 calls/s
# udp tx:     11 MB/s     7938 calls/s    189 msg/s
# udp rx:     10 MB/s     7523 calls/s
# udp tx:     10 MB/s     7308 calls/s    174 msg/s
# udp rx:     10 MB/s     7338 calls/s
# udp gso
# udp rx:     19 MB/s    14080 calls/s
# udp tx:    118 MB/s     2012 calls/s   2012 msg/s
# udp rx:     26 MB/s    18688 calls/s
# udp tx:    117 MB/s     2000 calls/s   2000 msg/s
# udp rx:     26 MB/s    18688 calls/s
# udp tx:    118 MB/s     2008 calls/s   2008 msg/s
# udp gso zerocopy
# udp rx:     19 MB/s    13824 calls/s
# udp tx:    102 MB/s     1736 calls/s   1736 msg/s
# udp rx:     25 MB/s    18176 calls/s
# udp tx:    101 MB/s     1714 calls/s   1714 msg/s
# udp rx:     25 MB/s    18176 calls/s
# udp tx:     98 MB/s     1679 calls/s   1679 msg/s
# udp gso timestamp
# udp rx:     19 MB/s    13824 calls/s
# udp tx:     94 MB/s     1606 calls/s   1606 msg/s
# udp rx:     25 MB/s    18432 calls/s
# udp tx:     92 MB/s     1574 calls/s   1574 msg/s
# udp rx:     27 MB/s    19309 calls/s
# udp tx:     88 MB/s     1502 calls/s   1502 msg/s
# udp gso zerocopy audit
# udp rx:     19 MB/s    14080 calls/s
# udp tx:    101 MB/s     1728 calls/s   1728 msg/s
# udp rx:     25 MB/s    18432 calls/s
# udp tx:    100 MB/s     1699 calls/s   1699 msg/s
# udp rx:     26 MB/s    18688 calls/s
# udp tx:    101 MB/s     1724 calls/s   1724 msg/s
# Summary over 3.000 seconds...
# sum udp tx:    103 MB/s       5151 calls (1717/s)       5151 msgs (1717/s)
# Zerocopy acks:                5151
# udp gso timestamp audit
# udp rx:     19 MB/s    13843 calls/s
# udp tx:     92 MB/s     1571 calls/s   1571 msg/s
# udp rx:     26 MB/s    18568 calls/s
# udp tx:     95 MB/s     1614 calls/s   1614 msg/s
# udp rx:     26 MB/s    19200 calls/s
# udp tx:     93 MB/s     1589 calls/s   1589 msg/s
# Summary over 3.000 seconds...
# sum udp tx:     96 MB/s       4774 calls (1591/s)       4774 msgs (1591/s)
# Tx Timestamps:                4774 received                 0 errors
# udp gso zerocopy timestamp audit
# udp rx:     18 MB/s    13312 calls/s
# udp tx:     76 MB/s     1297 calls/s   1297 msg/s
# udp rx:     26 MB/s    18524 calls/s
# udp tx:     74 MB/s     1269 calls/s   1269 msg/s
# udp rx:     25 MB/s    18176 calls/s
# udp tx:     75 MB/s     1289 calls/s   1289 msg/s
# Summary over 3.000 seconds...
# sum udp tx:     77 MB/s       3855 calls (1285/s)       3855 msgs (1285/s)
# Tx Timestamps:                3855 received                 0 errors
# Zerocopy acks:                3855
# ipv6
# tcp
# tcp tx:    215 MB/s     3657 calls/s   3657 msg/s
# tcp rx:    216 MB/s     3431 calls/s
# tcp tx:    211 MB/s     3590 calls/s   3590 msg/s
# tcp rx:    211 MB/s     3319 calls/s
# tcp tx:    211 MB/s     3579 calls/s   3579 msg/s
# tcp zerocopy
# tcp tx:    191 MB/s     3245 calls/s   3245 msg/s
# tcp rx:    193 MB/s     2908 calls/s
# tcp tx:    184 MB/s     3135 calls/s   3135 msg/s
# tcp rx:    185 MB/s     2830 calls/s
# tcp tx:    191 MB/s     3254 calls/s   3254 msg/s
# udp
<4>[   88.821235] int3: 0000 [#1] PREEMPT SMP PTI
<4>[   88.821491] CPU: 1 PID: 561 Comm: udpgso_bench_tx Not tainted 6.3.4-rc2 #1
<4>[   88.821576] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.14.0-2 04/01/2014
<4>[   88.821685] RIP: 0010:lookup_reuseport+0x4a/0x200
<4>[   88.822122] Code: 74 0b 49 89 f6 0f b6 46 12 3c 01 75 07 31 c0
e9 ed 00 00 00 4d 89 cf 44 89 c5 49 89 cd 49 89 fc 0f 1f 44 00 00 8b
5c 24 50 0f <1f> 44 00 00 41 8b 45 04 41 33 45 00 8b 0d b0 c5 ed 00 44
8d 04 08
<4>[   88.822175] RSP: 0018:ffffa95c800c0b90 EFLAGS: 00000206
<4>[   88.822215] RAX: 0000000000000007 RBX: 0000000000001f40 RCX:
ffff966c02b66020
<4>[   88.822228] RDX: ffff966c01a9aa00 RSI: ffff966c02801500 RDI:
ffff966c03ae2e80
<4>[   88.822241] RBP: 00000000000093bf R08: 00000000000093bf R09:
ffffffffb0b2c8a0
<4>[   88.822254] R10: 0000000042388386 R11: 00000000000093bf R12:
ffff966c03ae2e80
<4>[   88.822266] R13: ffff966c02b66020 R14: ffff966c02801500 R15:
ffffffffb0b2c8a0
<4>[   88.822312] FS:  00007f4e6ede4740(0000)
GS:ffff966c7bd00000(0000) knlGS:0000000000000000
<4>[   88.822330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[   88.822343] CR2: 000055a1c0b90bf0 CR3: 0000000103b0e000 CR4:
00000000000006e0
<4>[   88.822438] Call Trace:
<4>[   88.823080]  <IRQ>
<4>[   88.823274]  udp6_lib_lookup2+0xf8/0x1c0
<4>[   88.823368]  __udp6_lib_lookup+0x113/0x3c0
<4>[   88.823382]  ? __wake_up_common_lock+0x79/0x190
<4>[   88.823403]  __udp6_lib_lookup_skb+0x76/0x90
<4>[   88.823426]  __udp6_lib_rcv+0x295/0x400
<4>[   88.823440]  ip6_protocol_deliver_rcu+0x34e/0x5c0
<4>[   88.823483]  ip6_input+0x60/0x110
<4>[   88.823496]  ? ip6_rcv_core+0x311/0x450
<4>[   88.823509]  ipv6_rcv+0x47/0xf0
<4>[   88.823523]  __netif_receive_skb+0x65/0x170
<4>[   88.823539]  process_backlog+0xd7/0x180
<4>[   88.823553]  __napi_poll+0x2c/0x1b0
<4>[   88.823565]  net_rx_action+0x178/0x2e0
<4>[   88.823580]  __do_softirq+0xc4/0x274
<4>[   88.823595]  do_softirq+0x7e/0xb0
<4>[   88.823751]  </IRQ>
<4>[   88.823769]  <TASK>
<4>[   88.823773]  __local_bh_enable_ip+0x6e/0x70
<4>[   88.823786]  ip6_finish_output2+0x3fc/0x560
<4>[   88.823803]  ip6_finish_output+0x1ab/0x320
<4>[   88.823816]  ip6_output+0x6b/0x130
<4>[   88.823827]  ? __pfx_ip6_finish_output+0x10/0x10
<4>[   88.823839]  ip6_send_skb+0x1e/0x80
<4>[   88.823850]  udp_v6_send_skb+0x26e/0x400
<4>[   88.823865]  udpv6_sendmsg+0xb33/0xc60
<4>[   88.823879]  ? __pfx_ip_generic_getfrag+0x10/0x10
<4>[   88.823902]  sock_sendmsg+0x42/0xa0
<4>[   88.823915]  __sys_sendto+0x281/0x2f0
<4>[   88.823938]  __x64_sys_sendto+0x21/0x30
<4>[   88.823949]  do_syscall_64+0x48/0xa0
<4>[   88.823969]  ? exit_to_user_mode_prepare+0x2a/0x80
<4>[   88.823981]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
<4>[   88.824104] RIP: 0033:0x7f4e6eef1973
<4>[   88.824267] Code: 8b 15 91 74 0c 00 f7 d8 64 89 02 48 c7 c0 ff
ff ff ff eb b8 0f 1f 00 80 3d 71 fc 0c 00 00 41 89 ca 74 14 b8 2c 00
00 00 0f 05 <48> 3d 00 f0 ff ff 77 75 c3 0f 1f 40 00 55 48 83 ec 30 44
89 4c 24
<4>[   88.824276] RSP: 002b:00007ffc3a3d79f8 EFLAGS: 00000202
ORIG_RAX: 000000000000002c
<4>[   88.824293] RAX: ffffffffffffffda RBX: 00005596927cf110 RCX:
00007f4e6eef1973
<4>[   88.824298] RDX: 00000000000005ac RSI: 00005596927cf110 RDI:
0000000000000005
<4>[   88.824304] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
<4>[   88.824309] R10: 0000000000000000 R11: 0000000000000202 R12:
0000000000000002
<4>[   88.824313] R13: 0000000000000005 R14: 000000000000e628 R15:
00000000000005ac
<4>[   88.824335]  </TASK>
<4>[   88.824377] Modules linked in: mptcp_diag tcp_diag inet_diag
ip_tables x_tables
<4>[   88.845108] ---[ end trace 0000000000000000 ]---
<4>[   88.845178] RIP: 0010:lookup_reuseport+0x4a/0x200
<4>[   88.845216] Code: 74 0b 49 89 f6 0f b6 46 12 3c 01 75 07 31 c0
e9 ed 00 00 00 4d 89 cf 44 89 c5 49 89 cd 49 89 fc 0f 1f 44 00 00 8b
5c 24 50 0f <1f> 44 00 00 41 8b 45 04 41 33 45 00 8b 0d b0 c5 ed 00 44
8d 04 08
<4>[   88.845232] RSP: 0018:ffffa95c800c0b90 EFLAGS: 00000206
<4>[   88.845249] RAX: 0000000000000007 RBX: 0000000000001f40 RCX:
ffff966c02b66020
<4>[   88.845257] RDX: ffff966c01a9aa00 RSI: ffff966c02801500 RDI:
ffff966c03ae2e80
<4>[   88.845266] RBP: 00000000000093bf R08: 00000000000093bf R09:
ffffffffb0b2c8a0
<4>[   88.845273] R10: 0000000042388386 R11: 00000000000093bf R12:
ffff966c03ae2e80
<4>[   88.845281] R13: ffff966c02b66020 R14: ffff966c02801500 R15:
ffffffffb0b2c8a0
<4>[   88.845290] FS:  00007f4e6ede4740(0000)
GS:ffff966c7bd00000(0000) knlGS:0000000000000000
<4>[   88.845302] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[   88.845311] CR2: 000055a1c0b90bf0 CR3: 0000000103b0e000 CR4:
00000000000006e0
<0>[   88.845862] Kernel panic - not syncing: Fatal exception in interrupt
<0>[   88.848258] Kernel Offset: 0x2e800000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)


log:
====
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2QCexh5uf81VW7HjLpuo5vu2LCe
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2QCeuW0pJ8XVzYeG3rpgza2cZDW/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.3.3-364-ga37c304c022d/testrun/17170111/suite/log-parser-test/tests/


--
Linaro LKFT
https://lkft.linaro.org

