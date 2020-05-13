Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1241D0990
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgEMHIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:08:15 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:51362 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbgEMHIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 03:08:14 -0400
Received: by mail-il1-f200.google.com with SMTP id h19so13292371ilo.18
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 00:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4QBNP2HR3gpc8LrPnQK6peZDQZdUtluaIGBLQtNra78=;
        b=s9rhA6boQI23oqghBN/bB0oOIvwqzecHWoolpbqqhQG/xQRLC6GY0Hldw/G805rmPu
         1j370gIrV7HNvbNB/GVACNB9ufeUGdNjTm/bn4rWFuxeBLHoPfE/Tk+yFtSuLOzhe/ZP
         F4NBIYRpwi/WAGgD7wQBN+XbACqwhbgoN6iFxrAsFD7vXaUON/Fq/CtQGKxuczOgcc89
         isqbiLvzl5HoiAaGXEfclPBxgZWuG5KyOOpujmEq1yEkIhcg/JZnYfPGBIHpbspA1Zgj
         c4pGR1e2v94NAINuFi/smsmkCVdUHwRq+OtsIzXQkdPCdfUsY4qS1BHzLUgiTqaqQ60D
         RV1Q==
X-Gm-Message-State: AGi0Pua6vUZl9ZD2sB1hvEQbUCyn6Lx+jS9Woin7hh7YG+IH8ChH+u1L
        6MXMe2ka3msZKpQFTa5BX5NT06UhO2dLanD/z4xSBF82eenC
X-Google-Smtp-Source: APiQypLP0LNvw//Am9YDhcfBkp/su2qZOVPUWsaX+yXrrHireJ83TAFbcTVPzbJ28ZGsP7fsJVILtpmiMGJgNjNbDqe9EvEYhVeK
MIME-Version: 1.0
X-Received: by 2002:a6b:c706:: with SMTP id x6mr23750484iof.112.1589353693496;
 Wed, 13 May 2020 00:08:13 -0700 (PDT)
Date:   Wed, 13 May 2020 00:08:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000052cae405a5823e68@google.com>
Subject: general protection fault in cfg80211_dev_rename
From:   syzbot <syzbot+fd5332e429401bf42d18@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2b6c6f07 bpf, i386: Remove unneeded conversion to bool
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=142a6eec100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da7097535df759be
dashboard link: https://syzkaller.appspot.com/bug?extid=fd5332e429401bf42d18
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fd5332e429401bf42d18@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 PID: 17548 Comm: syz-executor.2 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cfg80211_dev_rename+0x12b/0x210 net/wireless/core.c:146
Code: ef 00 00 00 4c 8b b5 10 0c 00 00 4d 85 f6 74 36 e8 0a 6f 20 fa 49 8d 7e 48 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c9 00 00 00 49 8b 7e 48 4c 89 e9 4c 89 f6 48 89
RSP: 0018:ffffc900055774e0 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffffc90005577748 RCX: ffffc90010d1f000
RDX: 0000000000000006 RSI: ffffffff8752bd86 RDI: 0000000000000037
RBP: ffff888088b40000 R08: ffff8880624a85c0 R09: fffffbfff185d748
R10: ffffffff8c2eba3f R11: fffffbfff185d747 R12: 0000000000000000
R13: ffffc90005e19018 R14: ffffffffffffffef R15: ffff888088b40000
FS:  00007fce5b9b5700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000048a140 CR3: 0000000097525000 CR4: 00000000001406e0
DR0: 0000000020000900 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 nl80211_set_wiphy+0x29d/0x2b70 net/wireless/nl80211.c:3009
 genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
 genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
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
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fce5b9b4c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000500b20 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009fd R14: 00000000004ccb59 R15: 00007fce5b9b56d4
Modules linked in:
---[ end trace 90c3adb6c5fb6794 ]---
RIP: 0010:cfg80211_dev_rename+0x12b/0x210 net/wireless/core.c:146
Code: ef 00 00 00 4c 8b b5 10 0c 00 00 4d 85 f6 74 36 e8 0a 6f 20 fa 49 8d 7e 48 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c9 00 00 00 49 8b 7e 48 4c 89 e9 4c 89 f6 48 89
RSP: 0018:ffffc900055774e0 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffffc90005577748 RCX: ffffc90010d1f000
RDX: 0000000000000006 RSI: ffffffff8752bd86 RDI: 0000000000000037
RBP: ffff888088b40000 R08: ffff8880624a85c0 R09: fffffbfff185d748
R10: ffffffff8c2eba3f R11: fffffbfff185d747 R12: 0000000000000000
R13: ffffc90005e19018 R14: ffffffffffffffef R15: ffff888088b40000
FS:  00007fce5b9b5700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b3103e000 CR3: 0000000097525000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
