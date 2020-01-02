Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B3B12E330
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 07:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgABGyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 01:54:50 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:42224 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgABGyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 01:54:49 -0500
Received: by mail-lj1-f174.google.com with SMTP id y4so25410647ljj.9
        for <netdev@vger.kernel.org>; Wed, 01 Jan 2020 22:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=s82264XRyod3Ls2XC7t2OJmG70X3mqI2X/kr7BgzOxQ=;
        b=VkbEwrcG+nQvocWjriZrVgVVJF0ifPzcWl+/m31Zi+zCOaZ81Y68BRVEQcTs2p2CS0
         fbXkvtJA4sGEuY5Du5gafJGFfNdIYsCSYzpgIm3D/ZdBEovjRJ6xRxj2DlNehwZXjUst
         c6vQ7d4xpuQaatkHrcObPJrFuywmHClyjso0r7WX3TwCTajl7Jsyia8v64lFsNJnSmBO
         BD2WK+TQH2vkBJXjCDm7+euXTeADoZKBwZbJi41R6lD6eDLb2tTMD2xX9f0Y5qb5dAfZ
         5uOCj5APj33iBFImTmNE8WT1AShGlRR1t93IroTBrID1iwuwedoWDG+E7tSVBuJKJFGv
         J6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=s82264XRyod3Ls2XC7t2OJmG70X3mqI2X/kr7BgzOxQ=;
        b=EF6/yRJhRpvOazc+OvYtwPudv7wMV+vSgjdHOjkFYRrU2IcLUfNNT7qEjOaWMLf4pJ
         7JTf6IHqguL82zaUi4tEnDexjpRia1LMLlE35LvGX5TuP16w/EGuBOQfR45dLmyLqdv8
         b9UboSqVOgw5iKO34TXac6P87QMr2yYZxx/Dz2gAA0T087puOvuIwI+fO6t/dOTDcYy5
         dBbkKewmHnzbTC5oH3/qIE7gh1habUoiZFKHTnsRtAFgHLijEufA/ij8VTl9XMk/6jRy
         PWRMTiaGTezUEvY75lxu0w3yCRtOWKH23AbSqFBqMEStMFBj8zx8CevDahXuCeBL7Zy1
         PRxw==
X-Gm-Message-State: APjAAAUi8OiznUj6R9wOpVxYgkmsLTdC0Pw2MEjEIIf7dzUrIHUwR/rc
        flMkauGARu3OXrpT/WGZEMm0HrdGymr/XB4y1KR1EA==
X-Google-Smtp-Source: APXvYqyMVB2vyX9/+6+KNiPDEDYSmob0A+2pJ3L1Ezi9S/2kvLMwVr4fObnfcbPTpAvbnthMCe9IWhwLA18ZdBqEzoE=
X-Received: by 2002:a2e:884f:: with SMTP id z15mr37068944ljj.46.1577948086775;
 Wed, 01 Jan 2020 22:54:46 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Jan 2020 12:24:35 +0530
Message-ID: <CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com>
Subject: stable-rc-4.19.93-rc1/4e040169e8b7 : kernel panic RIP: 0010:__inet_lookup_listener
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Firo Yang <firo.yang@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        rcu@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
Regressions on arm64, arm, x86_64, and i386.

While running LTP syscalls accept* test cases on stable-rc-4.19 branch kern=
el.
This report log extracted from qemu_x86_64.

metadata:
  git branch: linux-4.19.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  git commit: 4e040169e8b7f4e1c50ceb0f6596015ecc67a052
  git describe: v4.19.92-112-g4e040169e8b7
  make_kernelversion: 4.19.93-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkf=
t/linux-stable-rc-4.19/396/config

Crash log,

BUG: unable to handle kernel paging request at 0000000040000001
[   23.578222] PGD 138f25067 P4D 138f25067 PUD 0
er run is 0h 15m[   23.578222] Oops: 0000 [#1] SMP NOPTI
[   23.578222] CPU: 1 PID: 2216 Comm: accept02 Not tainted 4.19.93-rc1 #1
[   23.578222] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[   23.578222] RIP: 0010:__inet_lookup_listener+0x12d/0x300
 00s
[ts t_buffe r 23.578222] Code: 18 48 85 db 0f 84 fe 00 00 00 48 83 eb
68 0f 84 f4 00 00 00 0f b7 75 d0 44 8b 55 10 45 89 f1 45 31 ff 31 c0
45 89 de 89 75 b0 <4c> 3b 63 30 75 43 66 44 3b 6b 0e 75 3c 0f b6 73 13
40 f6 c6 20 75
[   23.578222] RSP: 0018:ffff9e0dbba83c38 EFLAGS: 00010206
[   23.578222] RAX: ffff9e0db6ff8a80 RBX: 000000003fffffd1 RCX: 00000000000=
00000
[   23.578222] RDX: 0000000000000006 RSI: 0000000000000000 RDI: 00000000fff=
fffff
[   23.578222] RBP: ffff9e0dbba83c88 R08: 000000000100007f R09: 00000000000=
00000
[   23.578222] R10: 000000000100007f R11: 0000000000000000 R12: ffffffffbeb=
2fe40
[   23.578222] R13: 000000000000d59f R14: 0000000000000000 R15: 00000000000=
00006
[   23.578222] FS:  00007fbb30e57700(0000) GS:ffff9e0dbba80000(0000)
knlGS:0000000000000000
[   23.578222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.578222] CR2: 0000000040000001 CR3: 000000013276c000 CR4: 00000000003=
406e0
[   23.578222] Call Trace:
[   23.578222]  <IRQ>
[   23.578222]  tcp_v4_rcv+0x4fe/0xc80
[   23.578222]  ip_local_deliver_finish+0xaf/0x390
[   23.578222]  ip_local_deliver+0x1a1/0x200
[   23.578222]  ? ip_sublist_rcv+0x420/0x420
[   23.578222]  ip_rcv_finish+0x88/0xd0
s.c:55: INFO: Te[   23.578222]  ip_rcv+0x142/0x200
[   23.578222]  ? ip_rcv_finish_core.isra.18+0x4e0/0x4e0
st is[ us ing guar  23.578222]  ? process_backlog+0x6d/0x230
[   23.578222]  __netif_receive_skb_one_core+0x57/0x80
ded [bu ffe rs
 ac2c3.578222]  __netif_receive_skb+0x18/0x60
[   23.578222]  process_backlog+0xd4/0x230
[   23.578222]  net_rx_action+0x13e/0x420
[   23.578222]  ? __do_softirq+0x9b/0x426
[   23.578222]  __do_softirq+0xc7/0x426
[   23.578222]  ? ip_finish_output2+0x255/0x660
[   23.578222]  do_softirq_own_stack+0x2a/0x40
[   23.578222]  </IRQ>
[   23.578222]  do_softirq.part.19+0x4d/0x60
[   23.578222]  __local_bh_enable_ip+0xd9/0xf0
[   23.578222]  ip_finish_output2+0x27e/0x660
[   23.578222]  ip_finish_output+0x235/0x370
[   23.578222]  ? ip_finish_output+0x235/0x370
[   23.578222]  ip_output+0x76/0x250
[   23.578222]  ? ip_fragment.constprop.50+0x80/0x80
[   23.578222]  ip_local_out+0x3f/0x70
[   23.578222]  __ip_queue_xmit+0x1ea/0x5f0
[   23.578222]  ? __lock_is_held+0x5a/0xa0
[   23.578222]  ip_queue_xmit+0x10/0x20
[   23.578222]  __tcp_transmit_skb+0x57c/0xb60
[   23.578222]  tcp_connect+0xccd/0x1030
[   23.578222]  tcp_v4_connect+0x515/0x550
[   23.578222]  __inet_stream_connect+0x249/0x390
[   23.578222]  ? __local_bh_enable_ip+0x7f/0xf0
[   23.578222]  inet_stream_connect+0x3b/0x60
[   23.578222]  __sys_connect+0xa3/0x120
[   23.578222]  ? kfree+0x203/0x240
[   23.578222]  ? syscall_trace_enter+0x1e3/0x350
[   23.578222]  ? trace_hardirqs_off_caller+0x22/0xf0
[   23.578222]  ? do_syscall_64+0x17/0x1a0
[   23.578222]  ? lockdep_hardirqs_on+0xef/0x180
[   23.578222]  ? do_syscall_64+0x17/0x1a0
[   23.578222]  __x64_sys_connect+0x1a/0x20
[   23.578222]  do_syscall_64+0x55/0x1a0
[   23.578222]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   23.578222] RIP: 0033:0x7fbb31a1c927
[   23.578222] Code: 44 00 00 41 54 41 89 d4 55 48 89 f5 53 89 fb 48
83 ec 10 e8 0b f9 ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2a 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 89 44 24 0c e8 45 f9 ff ff
8b 44
[   23.578222] RSP: 002b:00007fbb30e56e00 EFLAGS: 00000293 ORIG_RAX:
000000000000002a
[   23.578222] RAX: ffffffffffffffda RBX: 0000000000000008 RCX: 00007fbb31a=
1c927
[   23.578222] RDX: 0000000000000010 RSI: 00007fbb31e4bff0 RDI: 00000000000=
00008
[   23.578222] RBP: 00007fbb31e4bff0 R08: 0000000000000000 R09: 00000000000=
00010
[   23.578222] R10: 000000000000010b R11: 0000000000000293 R12: 00000000000=
00010
[   23.578222] R13: 0000000000412b64 R14: 0000000000000054 R15: 00000000000=
00000
[   23.578222] Modules linked in: fuse
[   23.578222] CR2: 0000000040000001
[   23.578222] ---[ end trace f7e2316fdadfb18a ]---
[   23.578222] RIP: 0010:__inet_lookup_listener+0x12d/0x300
[   23.578222] Code: 18 48 85 db 0f 84 fe 00 00 00 48 83 eb 68 0f 84
f4 00 00 00 0f b7 75 d0 44 8b 55 10 45 89 f1 45 31 ff 31 c0 45 89 de
89 75 b0 <4c> 3b 63 30 75 43 66 44 3b 6b 0e 75 3c 0f b6 73 13 40 f6 c6
20 75
[   23.578222] RSP: 0018:ffff9e0dbba83c38 EFLAGS: 00010206
[   23.578222] RAX: ffff9e0db6ff8a80 RBX: 000000003fffffd1 RCX: 00000000000=
00000
[   23.578222] RDX: 0000000000000006 RSI: 0000000000000000 RDI: 00000000fff=
fffff
[   23.578222] RBP: ffff9e0dbba83c88 R08: 000000000100007f R09: 00000000000=
00000
[   23.578222] R10: 000000000100007f R11: 0000000000000000 R12: ffffffffbeb=
2fe40
[   23.578222] R13: 000000000000d59f R14: 0000000000000000 R15: 00000000000=
00006
[   23.578222] FS:  00007fbb30e57700(0000) GS:ffff9e0dbba80000(0000)
knlGS:0000000000000000
[   23.578222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.578222] CR2: 0000000040000001 CR3: 000000013276c000 CR4: 00000000003=
406e0
[   23.578222] Kernel panic - not syncing: Fatal exception in interrupt
ept02.c:127: INFO: Starting listener on port: 54687
[   23.578222] Kernel Offset: 0x3c200000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   23.578222] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

crash log links,
https://lkft.validation.linaro.org/scheduler/job/1076789#L1033

--
Linaro LKFT
https://lkft.linaro.org
