Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18C5B3B63
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387435AbfIPN3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:29:48 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42285 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733202AbfIPN3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:29:10 -0400
Received: by mail-io1-f70.google.com with SMTP id x9so50722282ior.9
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gp6BXS02784Q+j2978rR4itbmOMNyVWAv6mkP8abJDw=;
        b=ED/Yq7EsMh8nq643DgNgSQeGbod28Y5gVRUyx5r3bZeibeUpnrPThXmiV74JQVsss0
         SB8jqMlKF4HignFSWk9MRcDhd1JJa4iFs5NdGhvd+vLjWV8TXkAmJxBk0wsEdgHeOw0I
         DBexqK8z9ABvHbBViepoyI4c8DGn+hGVHx1oRadZjKrNFtXq3431y6TNVS/RcQFCxcAI
         Y78jaspuI+zBW+YLr/6O0PPbXT9Z+4mN1Rv/wn6EJZWIPHOuN3OgWg5yBcA+3+AMBBk2
         bfqpGqZ5qsdqiQOJ4MtJe9AaACk+n88wbZL8jNfpICe9V4Ju7+vdlW2kGkuEG4lK6MoB
         AfFQ==
X-Gm-Message-State: APjAAAURtbJSO2tAMDr9ii2BOkeIIYo+qsX/4SW57uK09crjAl0afsYR
        KNH3X6rqbrO85zrPuXUGgvKN4iKGUuyliYBwLI7pPfcKjXi5
X-Google-Smtp-Source: APXvYqx+rVlIWw2hxHib6XC5TZW5VKRXtZgbn/3IX4WajUqBN1xeCeJh8U6x5o8NikRLN1zg6EtYVXk8imvRjDpfT+ttB7fbMZqW
MIME-Version: 1.0
X-Received: by 2002:a02:a909:: with SMTP id n9mr24183092jam.57.1568640549596;
 Mon, 16 Sep 2019 06:29:09 -0700 (PDT)
Date:   Mon, 16 Sep 2019 06:29:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd36db0592ab9652@google.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in rds_bind
From:   syzbot <syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f4b752a6 mlx4: fix spelling mistake "veify" -> "verify"
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16cbebe6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
dashboard link: https://syzkaller.appspot.com/bug?extid=fae39afd2101a17ec624
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10753bc1600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111dfc11600000

The bug was bisected to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

     hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11005fc1600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13005fc1600000
console output: https://syzkaller.appspot.com/x/log.txt?x=15005fc1600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 9fef0067 P4D 9fef0067 PUD 9060d067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9884 Comm: syz-executor453 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffff8880a7c6fcd8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff8992bfe0 RCX: ffffffff86b9b636
RDX: 0000000000000000 RSI: ffff8880a7c6fd40 RDI: ffffffff897830c0
RBP: ffff8880a7c6fda8 R08: ffff888093150558 R09: 0000000000000000
R10: fffffbfff134af9f R11: ffff88809a008040 R12: ffff888093150080
R13: ffffffff897830c0 R14: 0000000000000000 R15: ffff8880a7c6fd40
FS:  000055555738a880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000008f04a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  rds_bind+0x420/0x800 net/rds/bind.c:247
  __sys_bind+0x239/0x290 net/socket.c:1647
  __do_sys_bind net/socket.c:1658 [inline]
  __se_sys_bind net/socket.c:1656 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1656
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412b9
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc7c28b228 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412b9
RDX: 0000000000000010 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000402030
R13: 00000000004020c0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: 0000000000000000
---[ end trace b47a1983319ea52a ]---
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffff8880a7c6fcd8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff8992bfe0 RCX: ffffffff86b9b636
RDX: 0000000000000000 RSI: ffff8880a7c6fd40 RDI: ffffffff897830c0
RBP: ffff8880a7c6fda8 R08: ffff888093150558 R09: 0000000000000000
R10: fffffbfff134af9f R11: ffff88809a008040 R12: ffff888093150080
R13: ffffffff897830c0 R14: 0000000000000000 R15: ffff8880a7c6fd40
FS:  000055555738a880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004bf788 CR3: 000000008f04a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
