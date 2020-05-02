Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2716C1C2438
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 10:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEBI7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 04:59:22 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40186 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgEBI7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 04:59:21 -0400
Received: by mail-io1-f69.google.com with SMTP id p138so7351945iod.7
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 01:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ywzji6QDZvXk0ZcBde6pSZ6jql6pppVQlFIwSdzVTS4=;
        b=iyme4Q0FZkixfnCSEeIBvr3wSDb8W7ZU/bCBrPXWucm/+4AOtIbvzfwyuldLkeFyv+
         smkzFt3hHL96sio0LqwdPvGJEqmqkmlFIC0xivVfCuvGePNUfHB1nW2y5nJ6FNit3u66
         WbHDnV508Wr1VLiVnV7i7L5BjwG/qChJ4XBsVoWajMLcJog+SOJtQkRFN1v9LurRQwc5
         PvVKs8rapYy/Ia3Md1esQKU3x7wZg4ItJThKmZvDt4/WH+js4EETAIUOdvVmoJ8icWCV
         ma3JiCpkVAURIsoIm521k4GwRwzCJPaM8lwSIAHD+vtaPmcewiN1Vmmhwpw435n8Oblg
         RBdQ==
X-Gm-Message-State: AGi0Pubyl1So2u/5PRNtDXCDe2fshEfDSq78xzHCvzRFSYb0fPz1QI12
        K574UH6VYdWdJul+kJ93fhl+DUtvJFIyEOJV4/LdHITWYcNZ
X-Google-Smtp-Source: APiQypJwe/QtiAdOMw0gg7Juii1+8c/8AdO98fvxzwSQCgaqOMbSqCF+kNPf6lF5yJ9UeT1YoICCgRp5DDiXxJnxxf/u5miIWFK9
MIME-Version: 1.0
X-Received: by 2002:a92:d8ca:: with SMTP id l10mr7408148ilo.118.1588409959328;
 Sat, 02 May 2020 01:59:19 -0700 (PDT)
Date:   Sat, 02 May 2020 01:59:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000622fdd05a4a6831d@google.com>
Subject: KASAN: global-out-of-bounds Read in inet_diag_bc_sk
From:   syzbot <syzbot+3f4c9f04a6740870299e@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4b4976a6 Merge branch 'net-ReST-part-three'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13e3824c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1494ce3fbc02154
dashboard link: https://syzkaller.appspot.com/bug?extid=3f4c9f04a6740870299e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3f4c9f04a6740870299e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: global-out-of-bounds in cgroup_id include/linux/cgroup.h:312 [inline]
BUG: KASAN: global-out-of-bounds in inet_diag_bc_sk+0xb6e/0xc70 net/ipv4/inet_diag.c:749
Read of size 8 at addr ffffffff8d22eed0 by task syz-executor.2/16922

CPU: 1 PID: 16922 Comm: syz-executor.2 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0x5/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 cgroup_id include/linux/cgroup.h:312 [inline]
 inet_diag_bc_sk+0xb6e/0xc70 net/ipv4/inet_diag.c:749
 inet_diag_dump_icsk+0xbe4/0x1306 net/ipv4/inet_diag.c:1061
 __inet_diag_dump+0x8d/0x240 net/ipv4/inet_diag.c:1113
 netlink_dump+0x50b/0xf50 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x63f/0x910 net/netlink/af_netlink.c:2353
 netlink_dump_start include/linux/netlink.h:246 [inline]
 inet_diag_handler_cmd+0x263/0x2c0 net/ipv4/inet_diag.c:1278
 __sock_diag_cmd net/core/sock_diag.c:233 [inline]
 sock_diag_rcv_msg+0x2fe/0x3e0 net/core/sock_diag.c:264
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:275
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 do_iter_readv_writev+0x5a8/0x850 fs/read_write.c:694
 do_iter_write fs/read_write.c:999 [inline]
 do_iter_write+0x18b/0x600 fs/read_write.c:980
 vfs_writev+0x1b3/0x2f0 fs/read_write.c:1072
 do_writev+0x27f/0x300 fs/read_write.c:1115
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6839177c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 000000000050d140 RCX: 000000000045c829
RDX: 0000000000000001 RSI: 00000000200000c0 RDI: 0000000000000007
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000d18 R14: 00000000004cb1f4 R15: 00007f68391786d4

The buggy address belongs to the variable:
 __key.82892+0x30/0x40

Memory state around the buggy address:
 ffffffff8d22ed80: fa fa fa fa 00 00 fa fa fa fa fa fa 00 00 fa fa
 ffffffff8d22ee00: fa fa fa fa 00 fa fa fa fa fa fa fa 00 00 fa fa
>ffffffff8d22ee80: fa fa fa fa 00 00 fa fa fa fa fa fa 00 00 fa fa
                                                 ^
 ffffffff8d22ef00: fa fa fa fa 00 00 fa fa fa fa fa fa 00 00 fa fa
 ffffffff8d22ef80: fa fa fa fa 00 00 fa fa fa fa fa fa 00 00 fa fa
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
