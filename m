Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A35469475
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 11:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241931AbhLFK6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 05:58:47 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:51902 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbhLFK6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 05:58:46 -0500
Received: by mail-io1-f72.google.com with SMTP id s199-20020a6b2cd0000000b005ed3e776ad0so7987101ios.18
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 02:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EHCfJ7wZmAVfOk8+a03GCt1XLoCv1/UaIx/MGz2/dc0=;
        b=K8hMBm1rQKeFvd5HlQ7fM/hL6zMizM+2nXTnMGYhWcoh5/zSLFVpSpCIkPcg+rmPRx
         MVyWW/Ik57ZnlPxM0P/fwurtujfOnuQJpmZKML2rpCAxek/3OH+UUvtgG6OB2uasH2rU
         PBfl6UvY6bc4GNoyQGuCSLmBjXvjl1ohkGzGGtPjRFWi4rftZDAeyoR/xKOUrE/ZZlq5
         EMFflC6CEDdbLWU9pnFwDP4faHkxqUshjbcTBUPfP0QcLNobwDi1DxyaatbB5vE+xmtw
         0p+PiMewPte9Y2WZx69g4e/gWeC9XgKymSCOJAJiDUF/soJORVfxaG4q62L2F4e2SPCb
         MZ+A==
X-Gm-Message-State: AOAM5339HTDoDGK4jB5CEzNBVjXU6LANVKd9z2VOFe1C+DoOKcW3OS50
        3pprNJyY9go/7o2uP4S6RNHI+j8ggyqg+s5rUfAMXcJ52QRJ
X-Google-Smtp-Source: ABdhPJyExNltXGk2zEdbEsR0sCCMgtemlMwa7BJuvrMTGnwhbWbZehBCnvKTOMqc8a4LvOCwUVjrInnqyeC5dK1388wig4M8Bl+Z
MIME-Version: 1.0
X-Received: by 2002:a02:cc91:: with SMTP id s17mr41922040jap.3.1638788118041;
 Mon, 06 Dec 2021 02:55:18 -0800 (PST)
Date:   Mon, 06 Dec 2021 02:55:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a3571605d27817b5@google.com>
Subject: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
From:   syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bjorn@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a51e3ac43ddb Merge tag 'net-5.16-rc4' of git://git.kernel...
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17f04ebeb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b0eee8ab3ea1839
dashboard link: https://syzkaller.appspot.com/bug?extid=11421fbbff99b989670e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 20253 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 0 PID: 20253 Comm: syz-executor.1 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 3d f7 0c 00 49 89 c5 e9 69 ff ff ff e8 30 1e d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 1f 1e d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 06
RSP: 0018:ffffc900029a7c48 EFLAGS: 00010212
RAX: 00000000000000ff RBX: 0000000000000001 RCX: ffffc9000ac13000
RDX: 0000000000040000 RSI: ffffffff81a68ca1 RDI: 0000000000000003
RBP: 0000000000002dc0 R08: 000000007fffffff R09: 00000000ffffffff
R10: ffffffff81a68c5e R11: 0000000000000000 R12: 0000000708001000
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000f00
FS:  00007f1582971700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000100 CR3: 000000002a1b1000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvmalloc include/linux/slab.h:741 [inline]
 kvmalloc_array include/linux/slab.h:759 [inline]
 kvcalloc include/linux/slab.h:764 [inline]
 xdp_umem_pin_pages net/xdp/xdp_umem.c:102 [inline]
 xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
 xdp_umem_create+0x563/0x1180 net/xdp/xdp_umem.c:252
 xsk_setsockopt+0x73e/0x9e0 net/xdp/xsk.c:1053
 __sys_setsockopt+0x2db/0x610 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f158541cae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1582971188 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f1585530020 RCX: 00007f158541cae9
RDX: 0000000000000004 RSI: 000000000000011b RDI: 0000000000000005
RBP: 00007f1585476f6d R08: 0000000000000020 R09: 0000000000000000
R10: 00000000200000c0 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe483898ef R14: 00007f1582971300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
