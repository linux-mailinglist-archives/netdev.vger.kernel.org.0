Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B4D40B602
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhINRir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:38:47 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:42536 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhINRip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 13:38:45 -0400
Received: by mail-il1-f197.google.com with SMTP id p10-20020a92d28a000000b0022b5f9140f7so19205357ilp.9
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 10:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ATCgKLO9n3GamsUnOnt5kLvtcJYFA9pwPWjRgjaEo5o=;
        b=MLZFHBBeaSbpgUlQex382jBUuuKq72FGaRGZU2VnHkOX++8e2lcUCJjImgHtviZvhe
         dUhdpWt6tBZNG4mlLfrk7ehTDb4VhQTDg2/BW/8nvaItNNvrttZ/E53F+4nH0aQgHph2
         QoLfBy93PfTMJXRwPtgw6ma6Qc/V5mI3f2XVWdkj7Cp3YTtN1Y1a1qKC1vEgywdaP7vC
         ahMDFNtmAfusQxSrpFiXR9Nmr+Ou5pWVY1pPqj9ciBayS/4ceF6+298EKQunpVzfi0Gr
         ObVUFIyMWrvapeqVZSwC9rjA02FJpyvLTF4BwxUCs4F9Tf7kQIShCdTDnGdtDAP70JJ1
         Sk7w==
X-Gm-Message-State: AOAM5315R0Pf+HmLvrnI9tCT4AmHLoDJ0VxIPeDJ1H9YLh76+kpoM137
        S+uNIp3HMvlk5msB2t2Kk0W47nNDo4yqFl0lI+g41kBxnjSd
X-Google-Smtp-Source: ABdhPJzjK4K3/9mPPr1ed/2ix/JTjNgPF6bgEk8tGxBzYYeMWG5otRA095e+TUbmNeqRTIAhuSJ5qKn5kCfpS0YOu9RmdpUo5KwW
MIME-Version: 1.0
X-Received: by 2002:a02:6d59:: with SMTP id e25mr2294116jaf.68.1631641048289;
 Tue, 14 Sep 2021 10:37:28 -0700 (PDT)
Date:   Tue, 14 Sep 2021 10:37:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001597e105cbf8090a@google.com>
Subject: [syzbot] WARNING: refcount bug in sco_conn_del
From:   syzbot <syzbot+284f5086a790a6246920@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bf9f243f23e6 Merge tag '5.15-rc-ksmbd-part2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=171c4ec7300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e87940ff463e6c56
dashboard link: https://syzkaller.appspot.com/bug?extid=284f5086a790a6246920
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+284f5086a790a6246920@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 8391 at lib/refcount.c:25 refcount_warn_saturate+0x13d/0x1a0 lib/refcount.c:25
Modules linked in:
CPU: 0 PID: 8391 Comm: syz-executor.4 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0x13d/0x1a0 lib/refcount.c:25
Code: c7 60 d4 b3 8a 31 c0 e8 61 22 3d fd 0f 0b eb a3 e8 28 eb 71 fd c6 05 65 2e b8 09 01 48 c7 c7 c0 d4 b3 8a 31 c0 e8 43 22 3d fd <0f> 0b eb 85 e8 0a eb 71 fd c6 05 48 2e b8 09 01 48 c7 c7 20 d5 b3
RSP: 0018:ffffc90006557a08 EFLAGS: 00010246
RAX: 7631d2209bb18500 RBX: 0000000000000002 RCX: 0000000000040000
RDX: ffffc90011c64000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: 0000000000000002 R08: ffffffff81681fd2 R09: ffffed10173857a8
R10: ffffed10173857a8 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88801f90c968 R14: ffff888078a85000 R15: 0000000000000067
FS:  00007f49f645e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2be21000 CR3: 000000008081c000 CR4: 00000000001526f0
Call Trace:
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:702 [inline]
 sco_conn_del+0x242/0x2f0 net/bluetooth/sco.c:193
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1518 [inline]
 hci_conn_hash_flush+0x112/0x240 net/bluetooth/hci_conn.c:1608
 hci_dev_do_close+0x93e/0xeb0 net/bluetooth/hci_core.c:1793
 hci_rfkill_set_block+0x10f/0x180 net/bluetooth/hci_core.c:2233
 rfkill_set_block+0x1f1/0x440 net/rfkill/core.c:344
 rfkill_fop_write+0x5a4/0x760 net/rfkill/core.c:1268
 vfs_write+0x320/0xe70 fs/read_write.c:592
 ksys_write+0x18f/0x2c0 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f49f645e188 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000008 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffdc243488f R14: 00007f49f645e300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
