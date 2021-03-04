Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB9032CB65
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 05:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhCDEdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 23:33:12 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:44641 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbhCDEdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 23:33:00 -0500
Received: by mail-il1-f198.google.com with SMTP id c11so9551541ilq.11
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 20:32:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=438ryhskUK23Uad5Y6ZFyNz3as0ZaRCtJbK9Brlm7wg=;
        b=OX+V5kOdj9aRJDJc9zr6miPia+swNTwFeqIftERkUUQt1LookLsCtJFh1cFxnMzQGK
         h4lPYbKHogzVDpg7Y9nu7vj29nzaShVV8Gv2D+L0WqFB2dixT8MfMl1EubX3UiUemOse
         TjmB2QQCIfvKAMCzs87hxV/CSrcT0Fu0DAthhIB6Fq776VPi2IceyHT53BICf9CskwlI
         rSQFSs6gZHPbtC5Qn4wXFTVXkJOgSCkLW9/ff1rBF1CeJBYv+rwWeAdc+i+n93leZSJS
         lSE98shAkoYDyr6MMRoD40wjwXJ/IVuPtxRkiweDwQnXZy+/ovVcupTCESvQ1go/drlJ
         TYhg==
X-Gm-Message-State: AOAM5302cgs/hcjPS95/q/e0KN5PW1KQ43gAUoLt5DPeTF42J8B+ZAmV
        rcVwQJ4Ywyqrvl4cnpZRjS8KOcgC8Wz/mWq9Hx4WYF50T2Eu
X-Google-Smtp-Source: ABdhPJyU3YrzRSC8SrKnWA0f9PvpaP56ILm6xqVpMCk15bxQpZFe7WB7bWcEea3qVxtjZO0AFUGaMHAn8O4QplNojp6/I3QR2OOv
MIME-Version: 1.0
X-Received: by 2002:a02:cc1b:: with SMTP id n27mr2336010jap.106.1614832339741;
 Wed, 03 Mar 2021 20:32:19 -0800 (PST)
Date:   Wed, 03 Mar 2021 20:32:19 -0800
In-Reply-To: <000000000000de949705bc59e0f6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fb718e05bcae7372@google.com>
Subject: Re: general protection fault in crypto_destroy_tfm
From:   syzbot <syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, ardb@kernel.org, davem@davemloft.net,
        ebiggers@google.com, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d310ec03 Merge tag 'perf-core-2021-02-17' of git://git.ker..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13e7a292d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b8307379601586a
dashboard link: https://syzkaller.appspot.com/bug?extid=12cf5fbfdeba210a89dd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103b89b6d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 9813 Comm: syz-executor.2 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:crypto_destroy_tfm+0x38/0x210 crypto/api.c:568
Code: f5 53 e8 ab c9 dd fd 4d 85 ed 0f 84 a2 00 00 00 e8 9d c9 dd fd 4c 8d 75 10 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 8c 01 00 00 4c 8d 7d 08 4c 8b 65 10 48 b8 00 00
RSP: 0018:ffffc9000adff360 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff83951013 RDI: fffffffffffffffe
RBP: 0000000000000006 R08: fffffffffffff000 R09: ffffffff8fa99847
R10: ffffffff8891f97e R11: 0000000000000000 R12: ffff8880133ed000
R13: fffffffffffffffe R14: 0000000000000016 R15: fffffffffffffffe
FS:  00007f0265ee2700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000002631b000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 crypto_free_aead include/crypto/aead.h:191 [inline]
 llsec_key_alloc net/mac802154/llsec.c:156 [inline]
 mac802154_llsec_key_add+0x9e0/0xcc0 net/mac802154/llsec.c:249
 ieee802154_add_llsec_key+0x56/0x80 net/mac802154/cfg.c:338
 rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
 nl802154_add_llsec_key+0x3d3/0x560 net/ieee802154/nl802154.c:1584
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0265ee2188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c008 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00000000004bfa34 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c008
R13: 00007fff0057718f R14: 00007f0265ee2300 R15: 0000000000022000
Modules linked in:
---[ end trace 8a3ba3ae0abac852 ]---
RIP: 0010:crypto_destroy_tfm+0x38/0x210 crypto/api.c:568
Code: f5 53 e8 ab c9 dd fd 4d 85 ed 0f 84 a2 00 00 00 e8 9d c9 dd fd 4c 8d 75 10 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 8c 01 00 00 4c 8d 7d 08 4c 8b 65 10 48 b8 00 00
RSP: 0018:ffffc9000adff360 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff83951013 RDI: fffffffffffffffe
RBP: 0000000000000006 R08: fffffffffffff000 R09: ffffffff8fa99847
R10: ffffffff8891f97e R11: 0000000000000000 R12: ffff8880133ed000
R13: fffffffffffffffe R14: 0000000000000016 R15: fffffffffffffffe
FS:  00007f0265ee2700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000002631b000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

