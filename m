Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F567633671
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiKVH5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiKVH5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:57:40 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E64C13CC6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 23:57:37 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id d19-20020a056e020c1300b00300b5a12c44so10123365ile.15
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 23:57:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bc8RrsqreLFi7HYFtgQkTdL3TrNOh9evIgWdfmzeQJw=;
        b=aoCCBLlJIeVkrNB4KXAdMZWXZHevOIXbyoTXiZ7IBG33Jleftx9xDyyDs4I+pKLpxJ
         Sv+N25z3OA2Af1IrhkgkpX7taFrYU4wZweqKxokENUXt9u7kVBxinZfHldsuSKoDAGAD
         cKfNeRNUzHWPP08YbQXSS/UYa4s2Zyz6BQH5EjIxIpt/9tAXd1SohaPZ/NK6TQA94yot
         FfVICPkiciwtGmOGTHZunfjpSU00aBaVj1flRgysSZCiOLuWIhR2XFZon90vXISOsJh2
         4a3F/0dl4VZuW1LcmzLFjxXBlnHgvFcvEKgRqbM+u4hEl8fK3oP8YpzuHn0xMp4AkeIT
         Q53w==
X-Gm-Message-State: ANoB5pld5fxtNSO5CQYB1F0+zU7OrAKwms9kHkQXv/LqovUP3KBveyC2
        hhyt/nAW+2cMd+M9cjK1hheN2KlmlpE/83cy8t0JsTXFVkB5
X-Google-Smtp-Source: AA0mqf718VO4ONghTLkTuhGLusUX0QQ9d+60ngsXijMXAQvGYJ/YErkU9mcLtkcRZDbW4k3SOLkrwRrGIKkwoFaJ0uw3Fg+EWRKj
MIME-Version: 1.0
X-Received: by 2002:a5e:8806:0:b0:6d2:4c85:c7b2 with SMTP id
 l6-20020a5e8806000000b006d24c85c7b2mr1178024ioj.32.1669103856657; Mon, 21 Nov
 2022 23:57:36 -0800 (PST)
Date:   Mon, 21 Nov 2022 23:57:36 -0800
In-Reply-To: <000000000000c1e64305ed9dc5e8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000782c8605ee0a8612@google.com>
Subject: Re: [syzbot] BUG: MAX_LOCKDEP_ENTRIES too low! (3)
From:   syzbot <syzbot+b04c9ffbbd2f303d00d9@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        pabeni@redhat.com, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    9ab000d9ac54 Merge branch 'nfc-leaks'
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=178f3db5880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f4e5e9899396248
dashboard link: https://syzkaller.appspot.com/bug?extid=b04c9ffbbd2f303d00d9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15051edd880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b9d365880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0db12aff8b37/disk-9ab000d9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/62dc4dacf73e/vmlinux-9ab000d9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0cc1ecdd9ab6/bzImage-9ab000d9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b04c9ffbbd2f303d00d9@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device batadv968
BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.
CPU: 1 PID: 5813 Comm: syz-executor248 Not tainted 6.1.0-rc5-syzkaller-00128-g9ab000d9ac54 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 alloc_list_entry.cold+0x11/0x18 kernel/locking/lockdep.c:1402
 add_lock_to_list kernel/locking/lockdep.c:1423 [inline]
 check_prev_add kernel/locking/lockdep.c:3167 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain kernel/locking/lockdep.c:3831 [inline]
 __lock_acquire+0x3626/0x56d0 kernel/locking/lockdep.c:5055
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:355 [inline]
 batadv_tt_local_event+0x1f6/0x7e0 net/batman-adv/translation-table.c:482
 batadv_tt_local_add+0x638/0x1f50 net/batman-adv/translation-table.c:758
 batadv_softif_create_vlan+0x2ed/0x530 net/batman-adv/soft-interface.c:586
 batadv_interface_add_vid+0xd7/0x110 net/batman-adv/soft-interface.c:646
 vlan_add_rx_filter_info+0x149/0x1d0 net/8021q/vlan_core.c:211
 __vlan_vid_add net/8021q/vlan_core.c:306 [inline]
 vlan_vid_add+0x3f6/0x7f0 net/8021q/vlan_core.c:336
 vlan_device_event.cold+0x28/0x2d net/8021q/vlan.c:385
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 dev_open net/core/dev.c:1473 [inline]
 dev_open+0x136/0x150 net/core/dev.c:1461
 team_port_add drivers/net/team/team.c:1215 [inline]
 team_add_slave+0xa03/0x1b90 drivers/net/team/team.c:1984
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2578
 rtnl_newlink_create net/core/rtnetlink.c:3381 [inline]
 __rtnl_newlink+0x13ac/0x17e0 net/core/rtnetlink.c:3581
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3594
 rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6091
 netlink_rcv_skb+0x157/0x430 net/netlink/af_netlink.c:2540
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2d5511cab9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffddb541428 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000003d335 RCX: 00007f2d5511cab9
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000004
RBP: 0000000000000000 R08: 00007ffddb5415c8 R09: 00007ffddb5415c8
R10: 00007ffddb5415c8 R11: 0000000000000246 R12: 00007ffddb54143c
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
team968: Port device batadv968 added

