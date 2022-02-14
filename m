Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8285E4B3FC9
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 03:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbiBNCu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 21:50:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239502AbiBNCuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 21:50:25 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074305046E
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:50:18 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id a18-20020a923312000000b002b384dccc91so10455292ilf.1
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:50:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+jq+QysxQkWFCMcSOLTxGlsKrZFeW5BnbyJngHYSa6c=;
        b=niy53QiAK3rthT0uvGE5gYVLWMoC/1dtSFnjP73n0/ImDPe6HhO8xsz6jx9RYg6JcG
         xKAGdahbsps8qmm59RSUE1J3B36Q9JY5fV0UKD1SGBnnZYkFOeS7s8uiTt93IxaqF268
         agkbbGxAbZWL5Ecvb0U7JNXHe6MbQNOOVtFSZjXrYk9f8n7tEqmP1W9qV8KN/Bh5oZaj
         ZEJxZP3Uf6/z7/tmSGKlFZCMtmEieVnkVQeF/eRQEVUbLGexIQGY4na6ZaEfMAiVzxMD
         jvW1BgWoOq5S5xoohgcoc+2RZB4jAZiahGm/FZaDlh4Mk8jdzuOaSwJ1xUIRkc5k14y+
         9CtA==
X-Gm-Message-State: AOAM532txF3S8vPuIULnEjQfUb+8QgmBkTSpI0LQuDDvz1OcRnoFg2M9
        QkudaTfDzOyPue3y1VBl+i4cBzsJx+av+DYfl/hfGeW49Mdl
X-Google-Smtp-Source: ABdhPJzvtqd5odrpnUu7RRRQa+faT7ZRBKYCSLDaK9pFc/byhODAwwGkMKQXgDPoDS3o1oc3URVohypTQVpgtbK81olEaPSLlhw4
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2493:: with SMTP id x19mr7130809jat.219.1644807017384;
 Sun, 13 Feb 2022 18:50:17 -0800 (PST)
Date:   Sun, 13 Feb 2022 18:50:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fed00c05d7f179e0@google.com>
Subject: [syzbot] WARNING: kmalloc bug in xdp_umem_pin_pages
From:   syzbot <syzbot+1dd093e0edb4647f5b69@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bjorn@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c2aa3c700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88e0a6a3dbf057cf
dashboard link: https://syzkaller.appspot.com/bug?extid=1dd093e0edb4647f5b69
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1dd093e0edb4647f5b69@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5535 at mm/util.c:590 kvmalloc_node+0xd9/0xe0 mm/util.c:590
Modules linked in:
CPU: 1 PID: 5535 Comm: syz-executor.2 Not tainted 5.17.0-rc3-syzkaller-00043-gf4bc5bbb5fef #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0xd9/0xe0 mm/util.c:590
Code: 00 00 48 89 df 44 89 fa 44 89 f1 5b 41 5e 41 5f 5d e9 5b fd 0b 00 e8 46 46 cc ff 48 89 e8 5b 41 5e 41 5f 5d c3 e8 37 46 cc ff <0f> 0b 31 ed eb eb 90 41 56 53 49 89 f6 48 89 fb e8 22 46 cc ff 48
RSP: 0018:ffffc90009e67bb0 EFLAGS: 00010287
RAX: ffffffff81b96759 RBX: 00000007ff810000 RCX: 0000000000040000
RDX: ffffc90005534000 RSI: 0000000000001ca2 RDI: 0000000000001ca3
RBP: 0000000000000000 R08: ffffffff81b96719 R09: 00000000ffffffff
R10: fffff520013ccf49 R11: 0000000000000000 R12: ffff888023eb9d00
R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000002dc0
FS:  00007fc31c85f700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdaa9958058 CR3: 0000000075e10000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvmalloc include/linux/slab.h:732 [inline]
 kvmalloc_array include/linux/slab.h:750 [inline]
 kvcalloc include/linux/slab.h:755 [inline]
 xdp_umem_pin_pages+0x57/0x330 net/xdp/xdp_umem.c:102
 xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
 xdp_umem_create+0x790/0xb40 net/xdp/xdp_umem.c:252
 xsk_setsockopt+0x86f/0xac0 net/xdp/xsk.c:1051
 __sys_setsockopt+0x552/0x980 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0xb1/0xc0 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc31deea059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc31c85f168 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fc31dffcf60 RCX: 00007fc31deea059
RDX: 0000000000000004 RSI: 000000000000011b RDI: 0000000000000003
RBP: 00007fc31df4408d R08: 0000000000000020 R09: 0000000000000000
R10: 0000000020000080 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff15fae91f R14: 00007fc31c85f300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
