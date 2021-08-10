Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497FF3E5300
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 07:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbhHJFlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 01:41:50 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:41490 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbhHJFlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 01:41:49 -0400
Received: by mail-io1-f70.google.com with SMTP id z10-20020a056602080ab02905a113250a04so2646234iow.8
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 22:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4k3xWVuvPtnO7/RXGNQCf+RD5uKUG8Fe1RKWCEcPJwo=;
        b=C8jyDuD1FyXKYeJa1G0Z6aOn92fo5EDHoEfXQQdSL5nDNwQPT1ARL/am23zn/JdESK
         hymuIK35ELOed905eaMeIMKZAU4UShCSmu/aY6wYuevtTWDkwY0pJ8g/I2Vwd9OP5kAv
         8vwQhy2EhnmPXSqulUyApVzjMURR1owqhVFqH2R+kxk9f1KZyVmw1PXcRTtcD8kMV+OQ
         puKGN5RNt5uEo1bHAo6k8QyWVfBOwwGvC/jFx555fCrA84SMakFpPZIZjh0W5C/8pYLX
         aJMEy7sG1t0fr4NHJRRG+h6j84GkQHVMBwCnBeCrPOmAEdgbJp2nV2XrXf8ui2D7iVAV
         6rSw==
X-Gm-Message-State: AOAM532SLAIXx9JcRCUCfxUuV6mIPlCgpgVo5zCqhFI7kxFyw0ZG1xLr
        TfMOS7j71DijZxjscZoQYf3L6qgJZADaYrKDWqJlBdu9h6hR
X-Google-Smtp-Source: ABdhPJw2Y4cmUsuL+QNQmnFFZz3f6/vxNEs3Dx7AIXnMWq7mXzVaULjZNUvNWeEqZ01SSCF0Cj1IIY53oII6KN9FE20Vgte83UNf
MIME-Version: 1.0
X-Received: by 2002:a5e:961a:: with SMTP id a26mr20924ioq.90.1628574087990;
 Mon, 09 Aug 2021 22:41:27 -0700 (PDT)
Date:   Mon, 09 Aug 2021 22:41:27 -0700
In-Reply-To: <0000000000007faf7505c91bb19d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000156a605c92df4b2@google.com>
Subject: Re: [syzbot] general protection fault in hwsim_new_edge_nl
From:   syzbot <syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        mudongliangabcd@gmail.com, netdev@vger.kernel.org,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    2a2b6e3640c4 devlink: Fix port_type_set function pointer c..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11abd8a1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=fafb46da3f65fdbacd16
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13371f79300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fabc4a300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8442 Comm: syz-executor760 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:hwsim_new_edge_nl+0xf4/0x8c0 drivers/net/ieee802154/mac802154_hwsim.c:425
Code: 00 0f 85 76 07 00 00 4d 85 ed 48 8b 5b 10 0f 84 5e 05 00 00 e8 0d e3 40 fc 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 87
RSP: 0018:ffffc9000178f568 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8534cab3 RDI: ffff88801dd72a10
RBP: ffffc9000178f678 R08: 0000000000000001 R09: ffffc9000178f6a8
R10: fffff520002f1ed6 R11: 0000000000000000 R12: ffffc9000178f698
R13: ffff888025fbd014 R14: ffff8880278afb40 R15: 0000000000000000
FS:  00000000013a1300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000744 CR3: 0000000031221000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ef39
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff22c3c298 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
R10: 00000000004ac018 R11: 0000000000000246 R12: 0000000000402fb0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
Modules linked in:
---[ end trace 63fa4e15cfb16ac5 ]---
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:hwsim_new_edge_nl+0xf4/0x8c0 drivers/net/ieee802154/mac802154_hwsim.c:425
Code: 00 0f 85 76 07 00 00 4d 85 ed 48 8b 5b 10 0f 84 5e 05 00 00 e8 0d e3 40 fc 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 87
RSP: 0018:ffffc9000178f568 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8534cab3 RDI: ffff88801dd72a10
RBP: ffffc9000178f678 R08: 0000000000000001 R09: ffffc9000178f6a8
R10: fffff520002f1ed6 R11: 0000000000000000 R12: ffffc9000178f698
R13: ffff888025fbd014 R14: ffff8880278afb40 R15: 0000000000000000
FS:  00000000013a1300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000744 CR3: 0000000031221000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

