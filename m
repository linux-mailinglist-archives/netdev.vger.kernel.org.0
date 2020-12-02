Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9302CBA1B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgLBKGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:06:05 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:36922 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728459AbgLBKGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 05:06:03 -0500
Received: by mail-io1-f69.google.com with SMTP id y1so803429ioj.4
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 02:05:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=O8RtAbzcSSTDxjcEMF5CfzqbJfEiDGNZZoY0KVn/1T0=;
        b=o8SZb+nuudX+D1toNXjRz3Meht76d1MnynuoXucW0rWfm8q+nl7ZYELEpXYEQu2du9
         aUcNiL2K/muAANbMP2V0aZEtjLR+TNuHdjJezTEnRvFZ7FriCBvVskEh0ygFnmx4k928
         qhZLZzCCTuwbipd5Upaee9gTYU37vd466N/hDyqRUk50FqyVOiFtM8dF1df1Z0oFNSmo
         jYhjgqxsK5yzWdwCGyEra9B8ig+ItLiAqBDvhAK1bXSZINDBLvgXAn8Qkvz6q0q6UYHE
         eug6TTSGpN8XVXVtYcFJBTNL/kcCsIhGdODm+xFX9O/vu2WHufFvg1BFlm4B/eBu3Ld2
         kcrA==
X-Gm-Message-State: AOAM533LFQsJUsC2e8AC3SClswR259mRC6PcPD5gTyTZSjWaqzFPUlVJ
        PYL3DF9bNsOj8K0FGQZXdL8eWWkLg+szUpdTbZwsxVipLnmb
X-Google-Smtp-Source: ABdhPJwX5bfGqmJZJTx1CKf+Gj31Bf/rg1E9WhEp/D+oWJghr5aG1ZL6Pl6B1FZ5CgJGK+qf0MlV8c9EiDso7/oaDVeh6yPB3i6k
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f88:: with SMTP id v8mr1662162ilo.270.1606903522038;
 Wed, 02 Dec 2020 02:05:22 -0800 (PST)
Date:   Wed, 02 Dec 2020 02:05:22 -0800
In-Reply-To: <0000000000001750e305b52c8d02@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009e9aee05b5786171@google.com>
Subject: Re: KMSAN: uninit-value in validate_beacon_head
From:   syzbot <syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=153d4607500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eef728deea880383
dashboard link: https://syzkaller.appspot.com/bug?extid=72b99dcf4607e8c770f3
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c1cec3500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=160b6cd3500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in validate_beacon_head+0x51e/0x5c0 net/wireless/nl80211.c:225
CPU: 0 PID: 8275 Comm: syz-executor237 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 validate_beacon_head+0x51e/0x5c0 net/wireless/nl80211.c:225
 validate_nla lib/nlattr.c:544 [inline]
 __nla_validate_parse+0x241a/0x4e00 lib/nlattr.c:588
 __nla_parse+0x141/0x150 lib/nlattr.c:685
 __nlmsg_parse include/net/netlink.h:733 [inline]
 nlmsg_parse_deprecated include/net/netlink.h:772 [inline]
 nl80211_prepare_wdev_dump+0x6fd/0xbb0 net/wireless/nl80211.c:891
 nl80211_dump_station+0x143/0x740 net/wireless/nl80211.c:5810
 netlink_dump+0xb92/0x1670 net/netlink/af_netlink.c:2268
 __netlink_dump_start+0xcf1/0xea0 net/netlink/af_netlink.c:2373
 genl_family_rcv_msg_dumpit net/netlink/genetlink.c:697 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
 genl_rcv_msg+0xff0/0x1610 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4418a9
Code: e8 fc a9 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe906479e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004418a9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402430
R13: 00000000004024c0 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2906 [inline]
 __kmalloc_node_track_caller+0xc61/0x15f0 mm/slub.c:4512
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x309/0xae0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1176 [inline]
 netlink_sendmsg+0xdb8/0x1840 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================

