Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC9F143734
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 07:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgAUGkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 01:40:09 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:32924 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgAUGkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 01:40:09 -0500
Received: by mail-io1-f69.google.com with SMTP id i8so1121138ioi.0
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 22:40:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VRitl32ZgVi8jJ8iDoSO0IiVKSdozfDuXzo2Yu5la8Q=;
        b=en+C2b0MAn2bEkCXzt409tYabClZ1aUGZWbv7CXtzsvYKVWxssLJNhqAOnt+B9VYIU
         iLKuwQbECPmD1rBU6mVxfUNELd7eXAJxAnfwPT44PhzagV4OyD0EYja2HeaH9M7JNWyz
         nIDsLuacpkug5E5KetU7nUPeRvUFMVmFbbrcHPbg3cbhqzrE1ZsVyytGkya+rhQgQ0Uw
         QTtT2ymzENiAz/VDawfmpwnZVrobwjp8Z1OPB0ANhSgyZXijecM8OM0Rhk7mXIUUCCLh
         AE2C2gd9f0teycOGi50dG4DpVzXUkR15BXQI/bEen/9ArSD213OaWFUFYs7DBulAlfhz
         hG6g==
X-Gm-Message-State: APjAAAWBF/+bdmDB75EKTva+lBarJdttXgt9UDuZWKo1OMoRj9ntqTLi
        1AROIelVhXRpLqVZWoZXCWIgBVNhI0F+I5pFo5dIrdnyHsaC
X-Google-Smtp-Source: APXvYqySbtxXbZlyaZABGQA4gd7GTyJ46ZhPFb75b3UyKRsPjM4zQwqZ5PNZlswvVpkPHGzZpnq9rUBGXSfp8nphBoe5CghEwLOr
MIME-Version: 1.0
X-Received: by 2002:a92:d18a:: with SMTP id z10mr2559332ilz.48.1579588808224;
 Mon, 20 Jan 2020 22:40:08 -0800 (PST)
Date:   Mon, 20 Jan 2020 22:40:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce3795059ca0ad2b@google.com>
Subject: general protection fault in __nf_tables_chain_type_lookup
From:   syzbot <syzbot+c4a099076c8ad98e282d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b3f7e3f2 Merge ra.kernel.org:/pub/scm/linux/kernel/git/net..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11f5dfaee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=25af05ec22c1bcef
dashboard link: https://syzkaller.appspot.com/bug?extid=c4a099076c8ad98e282d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c4a099076c8ad98e282d@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 24147 Comm: syz-executor.4 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:strlen+0x1f/0xa0 lib/string.c:527
Code: 00 66 2e 0f 1f 84 00 00 00 00 00 48 b8 00 00 00 00 00 fc ff df 55 48 89 fa 48 89 e5 48 c1 ea 03 41 54 49 89 fc 53 48 83 ec 08 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04 84 c0 75 4d 41 80 3c 24
RSP: 0018:ffffc90008d6f048 EFLAGS: 00010296
RAX: dffffc0000000000 RBX: fffffffffffffdc0 RCX: ffffc900114fb000
RDX: 0000000000000000 RSI: ffffffff83afcbcc RDI: 0000000000000000
RBP: ffffc90008d6f060 R08: ffff88805fb28640 R09: ffff888091274c48
R10: fffff520011ade2f R11: ffffc90008d6f17f R12: 0000000000000000
R13: ffff888091274c48 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f6a77110700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000024f0e80 CR3: 0000000093c3f000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 strlen include/linux/string.h:302 [inline]
 nla_strcmp+0x24/0x120 lib/nlattr.c:607
 __nf_tables_chain_type_lookup+0xa3/0x160 net/netfilter/nf_tables_api.c:562
 nf_tables_chain_type_lookup net/netfilter/nf_tables_api.c:613 [inline]
 nft_chain_parse_hook+0x2b8/0xa10 net/netfilter/nf_tables_api.c:1773
 nf_tables_addchain.constprop.0+0x1c1/0x1520 net/netfilter/nf_tables_api.c:1899
 nf_tables_newchain+0x1033/0x1820 net/netfilter/nf_tables_api.c:2207
 nfnetlink_rcv_batch+0xf42/0x17a0 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b349
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6a7710fc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6a771106d4 RCX: 000000000045b349
RDX: 0000000000000080 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000917 R14: 00000000004ca810 R15: 000000000075bf2c
Modules linked in:
---[ end trace ca4680ab3a32a755 ]---
RIP: 0010:strlen+0x1f/0xa0 lib/string.c:527
Code: 00 66 2e 0f 1f 84 00 00 00 00 00 48 b8 00 00 00 00 00 fc ff df 55 48 89 fa 48 89 e5 48 c1 ea 03 41 54 49 89 fc 53 48 83 ec 08 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04 84 c0 75 4d 41 80 3c 24
RSP: 0018:ffffc90008d6f048 EFLAGS: 00010296
RAX: dffffc0000000000 RBX: fffffffffffffdc0 RCX: ffffc900114fb000
RDX: 0000000000000000 RSI: ffffffff83afcbcc RDI: 0000000000000000
RBP: ffffc90008d6f060 R08: ffff88805fb28640 R09: ffff888091274c48
R10: fffff520011ade2f R11: ffffc90008d6f17f R12: 0000000000000000
R13: ffff888091274c48 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f6a77110700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcd75cf9c8 CR3: 0000000093c3f000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
