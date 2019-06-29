Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F555AC4B
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 17:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfF2PrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 11:47:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:47571 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfF2PrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 11:47:07 -0400
Received: by mail-io1-f72.google.com with SMTP id r27so10181892iob.14
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 08:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jbJ2eKqYbg+CIxP4+lpCkdTZvmlLbaCmh2v1g2hcHF8=;
        b=DIWRjfnLwN8YZ5ch+1GSV/n0U3Bvq4/fKRi8DqC6el/yxfuqb27EXtrqdKkvxaHlWc
         eUpvdHldVD+32vSTwdyqhWuBNR9PmYjrYMpyOSAXZPgV+5kVscBcTnPO/hHpkKpvm9oj
         aESTonMSwQRIRVUkb4vY6yPBArvm/pt+WfX6nivOSnzuk6Yqn8n/i2A1fxemhWjRbn8d
         +nlYa4AhCarQJvPeVpsdfRr9j6n9PTdm43/wp2tysJBeRVLWGDEgoRxeJGrh3r3E39uR
         ZAsTybiQwQ1LIQqwSWDVU/9dS/7BJPcNF3Tlt28RgL8mpXOOL7uw/D6XRIMqIXIIXsG0
         7pkA==
X-Gm-Message-State: APjAAAVsCnXHowkrbBUISgIRQ8z+9e+LjrCx246s1xFTlITUfH3Dn/YJ
        o4XQNjf3lgjpEjUL5nD/QmSGz/JZT0K4pu2psOp+3rdDoCTH
X-Google-Smtp-Source: APXvYqxNRLTQeEwFkg5Ty+r0QiSHT6Pb6DAK60VfYIJUCqbJeILzjqq4R8zPoKo+l5lzugoCL4DGtkwklNMTekBeqokyjZaKvAp7
MIME-Version: 1.0
X-Received: by 2002:a02:7642:: with SMTP id z63mr6340791jab.36.1561823226887;
 Sat, 29 Jun 2019 08:47:06 -0700 (PDT)
Date:   Sat, 29 Jun 2019 08:47:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a40746058c784ef3@google.com>
Subject: BUG: using smp_processor_id() in preemptible [ADDR] code: syz-executor
From:   syzbot <syzbot+1a68504d96cd17b33a05@syzkaller.appspotmail.com>
To:     allison@lohutok.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, jon.maloy@ericsson.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tipc-discussion@lists.sourceforge.net,
        ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ee7dd773 sis900: remove TxIDLE
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17ceb9a9a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ac9edef4d37e5fb
dashboard link: https://syzkaller.appspot.com/bug?extid=1a68504d96cd17b33a05
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119b2a13a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13127bada00000

The bug was bisected to:

commit 52dfae5c85a4c1078e9f1d5e8947d4a25f73dd81
Author: Jon Maloy <jon.maloy@ericsson.com>
Date:   Thu Mar 22 19:42:52 2018 +0000

     tipc: obtain node identity from interface by default

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160ad903a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=150ad903a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=110ad903a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1a68504d96cd17b33a05@syzkaller.appspotmail.com
Fixes: 52dfae5c85a4 ("tipc: obtain node identity from interface by default")

Started in network mode
Own node identity 7f000001, cluster identity 4711
New replicast peer: 172.20.20.22
check_preemption_disabled: 3 callbacks suppressed
BUG: using smp_processor_id() in preemptible [00000000] code:  
syz-executor834/8612
caller is dst_cache_get+0x3d/0xb0 net/core/dst_cache.c:68
CPU: 0 PID: 8612 Comm: syz-executor834 Not tainted 5.2.0-rc6+ #48
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
  debug_smp_processor_id+0x251/0x280 lib/smp_processor_id.c:57
  dst_cache_get+0x3d/0xb0 net/core/dst_cache.c:68
  tipc_udp_xmit.isra.0+0xc4/0xb80 net/tipc/udp_media.c:164
  tipc_udp_send_msg+0x29a/0x4b0 net/tipc/udp_media.c:254
  tipc_bearer_xmit_skb+0x16c/0x360 net/tipc/bearer.c:503
  tipc_enable_bearer+0xabe/0xd20 net/tipc/bearer.c:328
  __tipc_nl_bearer_enable+0x2de/0x3a0 net/tipc/bearer.c:899
  tipc_nl_bearer_enable+0x23/0x40 net/tipc/bearer.c:907
  genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
  genl_rcv_msg+0xca/0x16c net/netlink/genetlink.c:654
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:665
  ___sys_sendmsg+0x803/0x920 net/socket.c:2286
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2324
  __do_sys_sendmsg net/socket.c:2333 [inline]
  __se_sys_sendmsg net/socket.c:2331 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2331
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x444679
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 1b d8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff0201a8b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 0000000000444679
RDX: 0000000000000000 RSI: 0000000020000580 RDI: 0000000000000003
RBP: 00000000006cf018 R08: 0000000000000001 R09: 00000000004002e0
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000402320
R13: 00000000004023b0 R14: 0000000000000000 R15: 0000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
