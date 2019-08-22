Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA9F9976D
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388487AbfHVOxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:53:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36169 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388081AbfHVOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 10:53:06 -0400
Received: by mail-io1-f72.google.com with SMTP id i6so6661194ioi.3
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 07:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kfIi0OSou2Ekw5QLTdZ8VtZ0z3hqSfowleVJYnTSHhc=;
        b=KnSLhHge5yYblw3fgPff9roNHCr4aj+ZfosEfDYA3RSb1bvVOkl0+rzSjhmFJlhODq
         TDipNySElVy8fgW8G5Bd+bie1TV8zypuS519NYWbRD7kNuMwxit+o+09B42IB2JYq8Mo
         nKtfOeXrhhamq/gSY7uFq+L/S+M2CBxGnXf7ML+QchX/rhLszC/4kbVAghmuWbh3e2nC
         LjEHmbAs+DXz5mR6/DK++Hk0mtOYpzPT9IkT0n/xwfNoXV1UPQfuyBnppzulpYHX78b4
         aoZm5+4XeCiLl1MaVparclJsI33rE8saxgD+yfImH8jwj42QALw4M0ntNZam1IIvNScc
         FVlw==
X-Gm-Message-State: APjAAAWW26SW4o3hoMPtxkEAGh0MogQZnYn/gv861cLPDIJ/wtxIHE+S
        yqkQMtoUpIspGo5IcI4MEoervaeNdJebA6OV2KUtiPm2DW42
X-Google-Smtp-Source: APXvYqw2pBMggwRHNC0lzjydaezprM8qkJSaYzg9R1+X41uK1S/e6CKOqbuqpYhbin1Rq+t39efQ14ItyMp4karQSg0YBWmMHNMl
MIME-Version: 1.0
X-Received: by 2002:a5e:8e09:: with SMTP id a9mr69752ion.238.1566485585548;
 Thu, 22 Aug 2019 07:53:05 -0700 (PDT)
Date:   Thu, 22 Aug 2019 07:53:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df5c7f0590b5d85d@google.com>
Subject: general protection fault in sctp_inq_pop
From:   syzbot <syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    20e79a0a net: hns: add phy_attached_info() to the hns driver
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10d6dfba600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ce5e88233f2f83b0
dashboard link: https://syzkaller.appspot.com/bug?extid=4a0643a653ac375612d1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 15509 Comm: syz-executor.1 Not tainted 5.3.0-rc3+ #139
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:sctp_inq_pop+0x294/0xd80 net/sctp/inqueue.c:201
Code: 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 e3 08 00 00 49 8d 7d 02 4d 89 6c  
24 60 48 b8 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <0f> b6 0c 01 48  
89 f8 83 e0 07 83 c0 01 38 c8 7c 08 84 c9 0f 85 4b
RSP: 0018:ffff888097d9ee40 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880968405d8 RCX: 0000000000000001
RDX: 0000000000005803 RSI: ffffffff86b236aa RDI: 000000000000000a
RBP: ffff888097d9ee90 R08: ffff88808fd44240 R09: fffffbfff14a914f
R10: fffffbfff14a914e R11: ffffffff8a548a77 R12: ffff888096840580
R13: 0000000000000008 R14: 0000000000000000 R15: ffff888097d9f478
FS:  00007f59f27b8700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f40b77fd000 CR3: 0000000063e8e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  sctp_endpoint_bh_rcv+0x184/0x8d0 net/sctp/endpointola.c:385
  sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
  sctp_rcv+0x2807/0x3590 net/sctp/input.c:256
  sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
  ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
  ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
  dst_input include/net/dst.h:442 [inline]
  ip6_sublist_rcv_finish+0x98/0x1e0 net/ipv6/ip6_input.c:84
  ip6_list_rcv_finish net/ipv6/ip6_input.c:118 [inline]
  ip6_sublist_rcv+0x80c/0xcf0 net/ipv6/ip6_input.c:282
  ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:316
  __netif_receive_skb_list_ptype net/core/dev.c:5049 [inline]
  __netif_receive_skb_list_core+0x1a2/0x9d0 net/core/dev.c:5087
  __netif_receive_skb_list net/core/dev.c:5149 [inline]
  netif_receive_skb_list_internal+0x7eb/0xe60 net/core/dev.c:5244
  gro_normal_list.part.0+0x1e/0xb0 net/core/dev.c:5757
  gro_normal_list net/core/dev.c:5755 [inline]
  gro_normal_one net/core/dev.c:5769 [inline]
  napi_frags_finish net/core/dev.c:5782 [inline]
  napi_gro_frags+0xa6a/0xea0 net/core/dev.c:5855
  tun_get_user+0x2e98/0x3fa0 drivers/net/tun.c:1974
  tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2020
  call_write_iter include/linux/fs.h:1870 [inline]
  do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
  do_iter_write fs/read_write.c:970 [inline]
  do_iter_write+0x184/0x610 fs/read_write.c:951
  vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
  do_writev+0x15b/0x330 fs/read_write.c:1058
  __do_sys_writev fs/read_write.c:1131 [inline]
  __se_sys_writev fs/read_write.c:1128 [inline]
  __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4596e1
Code: 75 14 b8 14 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 34 b9 fb ff c3 48  
83 ec 08 e8 fa 2c 00 00 48 89 04 24 b8 14 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 43 2d 00 00 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007f59f27b7ba0 EFLAGS: 00000293 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 000000000000010c RCX: 00000000004596e1
RDX: 0000000000000001 RSI: 00007f59f27b7c00 RDI: 00000000000000f0
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f59f27b86d4
R13: 00000000004c8783 R14: 00000000004df5a0 R15: 00000000ffffffff
Modules linked in:
---[ end trace 4d09ea96a0c7705b ]---
RIP: 0010:sctp_inq_pop+0x294/0xd80 net/sctp/inqueue.c:201
Code: 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 e3 08 00 00 49 8d 7d 02 4d 89 6c  
24 60 48 b8 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <0f> b6 0c 01 48  
89 f8 83 e0 07 83 c0 01 38 c8 7c 08 84 c9 0f 85 4b
RSP: 0018:ffff888097d9ee40 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880968405d8 RCX: 0000000000000001
RDX: 0000000000005803 RSI: ffffffff86b236aa RDI: 000000000000000a
RBP: ffff888097d9ee90 R08: ffff88808fd44240 R09: fffffbfff14a914f
R10: fffffbfff14a914e R11: ffffffff8a548a77 R12: ffff888096840580
R13: 0000000000000008 R14: 0000000000000000 R15: ffff888097d9f478
FS:  00007f59f27b8700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f40b77fd000 CR3: 0000000063e8e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
