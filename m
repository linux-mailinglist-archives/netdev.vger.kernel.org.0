Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CB765CA9C
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 01:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbjADAIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 19:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbjADAIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 19:08:52 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A6C13DE4
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 16:08:51 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id l3-20020a056e021aa300b00304be32e9e5so20339325ilv.12
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 16:08:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BdI30cbwiGsAahh561Kwaa0VX4PARo/97jT/k9Clyvs=;
        b=trWw0rpHePNZqkyrhVA4bV7CFCBtAzoEaLYNctVTIgJvHsAJ4NUpIYG03LkJrvD/1H
         3vPEZRDobKompRL/U4P2g0ijXkdh7HklvKcH9qQCXo0E9pmlFgJR3iMkJDWltfu9IcQP
         XHsq7AlesUXqu8go02c0K0wCmgZsc+4DSnUQd+rhqJdBEzOY8jxy9PHeCvd3WQiU8aPR
         /o0NgDb8U5JTRXoM7wgjMCFCdhR4te2NPcScC+Z9PVDUU7Totd/3rI0Ph8EeWgnlrBQ6
         G5JvWEVmGtNo+I7GbCdWR279cD5HLnQCIX5PeRqtxG/aHRbnUIBPeBrwb1ZKDfNEL6vs
         XfSA==
X-Gm-Message-State: AFqh2kqsJtDmTAklG8t26hQiyuzc3kMcYqpw25R/XlImckAV4ZdTQjMS
        ZaOYFhXd2zP4EHKLk9r2DmI/i0jeRyuXX3qplTMkE91J4h3e
X-Google-Smtp-Source: AMrXdXtktJUAQB0oiFltFeGqoxF0/+s/3kugRtELBcdbscMpvSKOmvlomBwz9opS/4d2r8Jg9d+HVmsDMz/M7SbAGadO2QdbHU8C
MIME-Version: 1.0
X-Received: by 2002:a05:6638:490b:b0:375:2ff:b633 with SMTP id
 cx11-20020a056638490b00b0037502ffb633mr519089jab.100.1672790931037; Tue, 03
 Jan 2023 16:08:51 -0800 (PST)
Date:   Tue, 03 Jan 2023 16:08:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003a68dc05f164fd69@google.com>
Subject: [syzbot] kernel BUG in vhost_vsock_handle_tx_kick
From:   syzbot <syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c76083fac3ba Add linux-next specific files for 20221226
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1723da42480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c217c755f1884ab6
dashboard link: https://syzkaller.appspot.com/bug?extid=30b72abaa17c07fe39dd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fc414c480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1604b20a480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e388f26357fd/disk-c76083fa.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e24f0bae36d5/vmlinux-c76083fa.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a5a69a059716/bzImage-c76083fa.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com

skbuff: skb_over_panic: text:ffffffff8768d6f1 len:25109 put:25109 head:ffff88802b5ac000 data:ffff88802b5ac02c tail:0x6241 end:0xc0 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:121!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5072 Comm: vhost-5071 Not tainted 6.2.0-rc1-next-20221226-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:121
Code: f7 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 40 04 5b 8b ff 74 24 10 ff 74 24 20 e8 09 8e bf ff <0f> 0b e8 1a 67 82 f7 4c 8b 64 24 18 e8 80 3d d0 f7 48 c7 c1 40 12
RSP: 0018:ffffc90003cefca0 EFLAGS: 00010282
RAX: 000000000000008d RBX: ffff88802b674500 RCX: 0000000000000000
RDX: ffff8880236bba80 RSI: ffffffff81663b9c RDI: fffff5200079df86
RBP: ffffffff8b5b1280 R08: 000000000000008d R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8768d6f1
R13: 0000000000006215 R14: ffffffff8b5b0400 R15: 00000000000000c0
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000380 CR3: 000000002985f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 skb_over_panic net/core/skbuff.c:126 [inline]
 skb_put.cold+0x24/0x24 net/core/skbuff.c:2218
 virtio_vsock_skb_rx_put include/linux/virtio_vsock.h:56 [inline]
 vhost_vsock_alloc_skb drivers/vhost/vsock.c:374 [inline]
 vhost_vsock_handle_tx_kick+0xad1/0xd00 drivers/vhost/vsock.c:509
 vhost_worker+0x241/0x3e0 drivers/vhost/vhost.c:364
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:121
Code: f7 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 40 04 5b 8b ff 74 24 10 ff 74 24 20 e8 09 8e bf ff <0f> 0b e8 1a 67 82 f7 4c 8b 64 24 18 e8 80 3d d0 f7 48 c7 c1 40 12
RSP: 0018:ffffc90003cefca0 EFLAGS: 00010282
RAX: 000000000000008d RBX: ffff88802b674500 RCX: 0000000000000000
RDX: ffff8880236bba80 RSI: ffffffff81663b9c RDI: fffff5200079df86
RBP: ffffffff8b5b1280 R08: 000000000000008d R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8768d6f1
R13: 0000000000006215 R14: ffffffff8b5b0400 R15: 00000000000000c0
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdc6f4a4298 CR3: 000000002985f000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
