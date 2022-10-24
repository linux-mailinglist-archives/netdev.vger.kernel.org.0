Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E382A609844
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 04:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJXCho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 22:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJXChn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 22:37:43 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C25AC7C
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 19:37:42 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id y4-20020a5e9204000000b006bbffbc3d27so5662751iop.5
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 19:37:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pqgGKbSzRPOzqoqehlsfIN/1b+HXHoMpPvWZDhsF9YU=;
        b=XTg01Vra9LwQG9I+tdu8h3mZSqnP29VoFMtJ4XmcyivrZeQ026WvHXlY2Eumnc+1BK
         V0mEglUUK2sGX/tZ38yyWsnvAKtxZKKW35QTHfhn4YTxjegbNvURA1tt2jK9mpmFp51k
         bZS4esAmVe+baH1BAN+yPQrr//9wl3zLlv2Ldrcv7KjZ2lSxOmj5YGHvCRVJ3gOnmjA0
         SpyV8ystW53LXXhldJygyrP/QXe+5IkjmlyvTdIS04jX3y3bXVxuNvWDGgGXOSG4Vq9o
         vUwAL7LXY0Q3x8C3S8iEMBvR8AZUX0dZIXHcxDlArNAIucjLyUkxyPJHu0J0bScgNOWp
         /tGg==
X-Gm-Message-State: ACrzQf0Q0It7EI+9+RUhvKR6pFw/SQQyn/hSfJGtqt8o76gVSEJMSX7t
        I4M9AWCHujmXrANjTwZ37BybQiHRykHst2989vdoY61Bruue
X-Google-Smtp-Source: AMsMyM6WfW9QTf3LuJOw94Rw2zwOVYQH/HlU3ooWOnq7esII8NVov5/RVtdUgBUOP0Gzcg9sIouf0RLi9te40sWF1roACgmWqB4D
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4782:b0:363:c5a0:2aec with SMTP id
 cq2-20020a056638478200b00363c5a02aecmr20797316jab.242.1666579062166; Sun, 23
 Oct 2022 19:37:42 -0700 (PDT)
Date:   Sun, 23 Oct 2022 19:37:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd9a4005ebbeac67@google.com>
Subject: [syzbot] kernel BUG in warn_crc32c_csum_combine
From:   syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4d48f589d294 Add linux-next specific files for 20221021
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1224e236880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c4b7d600a5739a6
dashboard link: https://syzkaller.appspot.com/bug?extid=1e9af9185d8850e2c2fa
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f390f2880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171f9c8c880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0c86bd0b39a0/disk-4d48f589.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/074059d37f1f/vmlinux-4d48f589.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4a30bce99f60/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:120!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 3637 Comm: syz-executor164 Not tainted 6.1.0-rc1-next-20221021-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:skb_push.cold-0x2/0x24
Code: f8 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 80 69 d4 8a ff 74 24 10 ff 74 24 20 e8 b2 77 c1 ff <0f> 0b e8 d4 d0 f1 f7 4c 8b 64 24 18 e8 ba 52 3e f8 48 c7 c1 e0 76
RSP: 0018:ffffc90003e7ee70 EFLAGS: 00010286
RAX: 0000000000000086 RBX: ffff888079c00280 RCX: 0000000000000000
RDX: ffff888020a3ba80 RSI: ffffffff81621a58 RDI: fffff520007cfdc0
RBP: ffffffff8ad47720 R08: 0000000000000086 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000075626b73 R12: ffffffff883cc6c6
R13: 0000000000000048 R14: ffffffff8ad46940 R15: 00000000000000c0
FS:  00007f2b0a939700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9f0b184060 CR3: 00000000755db000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 skb_over_panic net/core/skbuff.c:125 [inline]
 warn_crc32c_csum_combine.cold+0x0/0x1d net/core/skbuff.c:2152
 dump_esp_combs net/key/af_key.c:3009 [inline]
 pfkey_send_acquire+0x1856/0x2520 net/key/af_key.c:3230
 km_query+0xac/0x220 net/xfrm/xfrm_state.c:2248
 xfrm_state_find+0x2bfe/0x4f10 net/xfrm/xfrm_state.c:1165
 xfrm_tmpl_resolve_one net/xfrm/xfrm_policy.c:2392 [inline]
 xfrm_tmpl_resolve+0x2f3/0xd40 net/xfrm/xfrm_policy.c:2437
 xfrm_resolve_and_create_bundle+0x123/0x2580 net/xfrm/xfrm_policy.c:2730
 xfrm_lookup_with_ifid+0x229/0x20f0 net/xfrm/xfrm_policy.c:3064
 xfrm_lookup net/xfrm/xfrm_policy.c:3193 [inline]
 xfrm_lookup_route+0x36/0x1e0 net/xfrm/xfrm_policy.c:3204
 ip_route_output_flow+0x114/0x150 net/ipv4/route.c:2880
 udp_sendmsg+0x1963/0x2740 net/ipv4/udp.c:1224
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:825
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x334/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmmsg+0x18b/0x460 net/socket.c:2622
 __do_sys_sendmmsg net/socket.c:2651 [inline]
 __se_sys_sendmmsg net/socket.c:2648 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2648
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2b0a9adf89
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2b0a9392f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f2b0aa334d0 RCX: 00007f2b0a9adf89
RDX: 000000000800001d RSI: 0000000020007fc0 RDI: 0000000000000003
RBP: 00007f2b0aa002b8 R08: 0000000000000000 R09: 0000000000000000
R10: 000000a742250118 R11: 0000000000000246 R12: 00007f2b0aa000b8
R13: 00007f2b0aa001b8 R14: 0100000000000000 R15: 00007f2b0aa334d8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_push.cold-0x2/0x24
Code: f8 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 80 69 d4 8a ff 74 24 10 ff 74 24 20 e8 b2 77 c1 ff <0f> 0b e8 d4 d0 f1 f7 4c 8b 64 24 18 e8 ba 52 3e f8 48 c7 c1 e0 76
RSP: 0018:ffffc90003e7ee70 EFLAGS: 00010286
RAX: 0000000000000086 RBX: ffff888079c00280 RCX: 0000000000000000
RDX: ffff888020a3ba80 RSI: ffffffff81621a58 RDI: fffff520007cfdc0
RBP: ffffffff8ad47720 R08: 0000000000000086 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000075626b73 R12: ffffffff883cc6c6
R13: 0000000000000048 R14: ffffffff8ad46940 R15: 00000000000000c0
FS:  00007f2b0a939700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcc1415d300 CR3: 00000000755db000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
