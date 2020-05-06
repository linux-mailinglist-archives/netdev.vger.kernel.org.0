Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BEF1C6634
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 05:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEFDLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 23:11:15 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:47592 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgEFDLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 23:11:14 -0400
Received: by mail-io1-f72.google.com with SMTP id v23so375355ioj.14
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 20:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iTrF1VFQ2sDo7T7Ae1ZffEHPykO9GM5of0TMBgs2Xw4=;
        b=gdDx2kecllAIumVOlO+YHcUAMyniYjwcs88fd1/YZjf8bVcaY4S6iUA/W2RQ8iKwe2
         LVzsyZ7RtqMLwiVHDFhL8gGmy61ccGsU21zqXJHdFBynIFjVxsISaTzm+luDBiHsDesx
         8zbkQemcR63qpCHBWfD9RfcksJ1GZlWimTSD2Akup7EzunrmfQjvRTqu2u757Tut5tdU
         RypG7Dcn8SY5DjWzho+euoa9jVo6k4vuBoTUcBB5vUbLHp6sbfrFw4J9r3xfA3ZxRmE0
         UQOMVWBqL+ju4dokF8+pMF7qMB38f3unHiCQiAb+frnyIEzpUfe2mf2KnvW5qATnuAJs
         aQQg==
X-Gm-Message-State: AGi0PuZglTd9qC51MjpFP0oH2unmDDOEgUwz/2Q9F0zpV0IyISvOFJQk
        VoZ6ANy5goyeoXphLjPhzAAp3EwJQZjfT3G35AMITMj1aTBR
X-Google-Smtp-Source: APiQypKjt/8yXIRFd/dkjMOwBxxtFQvIHrYrNDmo8+PcyllJHVkiZrri0uSj0lS57HCFeK2ZfmBK5XZEo6mlERtsUvhcCwSYq3UO
MIME-Version: 1.0
X-Received: by 2002:a92:cb42:: with SMTP id f2mr7122859ilq.101.1588734673779;
 Tue, 05 May 2020 20:11:13 -0700 (PDT)
Date:   Tue, 05 May 2020 20:11:13 -0700
In-Reply-To: <000000000000ea641705a350d2ee@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df81d405a4f21d87@google.com>
Subject: Re: WARNING: proc registration bug in snmp6_register_dev
From:   syzbot <syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, hdanton@sina.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    ac935d22 Add linux-next specific files for 20200415
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17006f4c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
dashboard link: https://syzkaller.appspot.com/bug?extid=1d51c8b74efa4c44adeb
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148e6150100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115c379c100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com

------------[ cut here ]------------
proc_dir_entry 'dev_snmp6/hsr1' already registered
WARNING: CPU: 0 PID: 7289 at fs/proc/generic.c:362 proc_register+0x40b/0x580 fs/proc/generic.c:362
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7289 Comm: syz-executor779 Not tainted 5.7.0-rc1-next-20200415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:proc_register+0x40b/0x580 fs/proc/generic.c:362
Code: ff df 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 5c 01 00 00 48 8b 04 24 48 c7 c7 a0 7a 39 88 48 8b b0 d8 00 00 00 e8 4d 2d 61 ff <0f> 0b 48 c7 c7 a0 ac ac 89 e8 f7 5b f3 05 48 8b 4c 24 28 48 b8 00
RSP: 0018:ffffc90005956cc8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8880a9138ac8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ce211 RDI: fffff52000b2ad8b
RBP: ffff8880a1ab3a80 R08: ffff888087c40340 R09: ffffed1015cc66b1
R10: ffff8880ae633587 R11: ffffed1015cc66b0 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880a6561240 R15: 0000000000000004
 proc_create_single_data+0xdb/0x130 fs/proc/generic.c:631
 snmp6_register_dev+0xbe/0x140 net/ipv6/proc.c:254
 ipv6_add_dev net/ipv6/addrconf.c:408 [inline]
 ipv6_add_dev+0x54b/0x10b0 net/ipv6/addrconf.c:365
 addrconf_notify+0x960/0x2310 net/ipv6/addrconf.c:3503
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 register_netdevice+0xd70/0x10b0 net/core/dev.c:9423
 hsr_dev_finalize+0x516/0x746 net/hsr/hsr_device.c:486
 hsr_newlink+0x27c/0x520 net/hsr/hsr_netlink.c:83
 __rtnl_newlink+0xf18/0x1590 net/core/rtnetlink.c:3333
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3391
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5454
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x449409
Code: e8 cc 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa3c088fdb8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dfca8 RCX: 0000000000449409
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 000000000000000e
RBP: 00000000006dfca0 R08: 0000000000000014 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 00000000006dfcac
R13: 00007ffc318e2f1f R14: 00007fa3c08909c0 R15: 00000000006dfcac
Kernel Offset: disabled
Rebooting in 86400 seconds..

