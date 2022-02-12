Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2618D4B3870
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 23:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiBLWr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 17:47:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiBLWr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 17:47:27 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DAF23BE1
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 14:47:23 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id k20-20020a5d91d4000000b0061299fad2fdso8594487ior.21
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 14:47:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=P2jL7sQj/TjQng7PKMAkeDTbtim/XRQtA01kz0TN724=;
        b=dxtH3tleV75r6cU4OGPg9up8X82CwDJbsL45EK8sT7jmyooGRrVQa814ezm+sGaCDg
         S28rB8XdanPil3VoYy2qMWygukGGyXGtQ9xpt9ToOLVRDYPz/LDCP6r2cB3qnWEc6/Uy
         XqFLANdQrts1uCaS/iofwB8r+2wJezfe6oGkzSAZQtkL0cNq1IuO1vZMdC7g34C9/f+y
         sjtHfCwqmqSgftoYJ2Dwg0R6c6Mx2ptyzi5GB6uc364BcZVRaZdoh9SWktaySa/5PpFH
         eV4buuw/0FMR/DlkcocHDcGlECsRWTT+BIbeJ64RZBNbno8EirUesoRLk8Q8EUhUUYO9
         k1qQ==
X-Gm-Message-State: AOAM530BchBLN4KtaJnKKvxkyBWWO5Y8fh4v+9p8M4r8eRKAblptCYbV
        NieNDVSQlbIYgWR1UF42+mLMY2twhuhyCxZCIwpbAosQoNi4
X-Google-Smtp-Source: ABdhPJzYFI6mQUpc72tbVCAcFfNBWcmMCEo8fuxfc/6Lc9bJZ0i5JB6ueuzKE6M7SySVfHYDwJiwU1JMb7DLEwuxIqpE+Z3hbmYP
MIME-Version: 1.0
X-Received: by 2002:a92:bd08:: with SMTP id c8mr4213452ile.110.1644706042783;
 Sat, 12 Feb 2022 14:47:22 -0800 (PST)
Date:   Sat, 12 Feb 2022 14:47:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000070ac6505d7d9f7a8@google.com>
Subject: [syzbot] kernel BUG in vhost_get_vq_desc
From:   syzbot <syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
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

HEAD commit:    83e396641110 Merge tag 'soc-fixes-5.17-1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1282df74700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
dashboard link: https://syzkaller.appspot.com/bug?extid=3140b17cb44a7b174008
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at drivers/vhost/vhost.c:2335!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9449 Comm: vhost-9447 Not tainted 5.17.0-rc3-syzkaller-00247-g83e396641110 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:vhost_get_vq_desc+0x1d43/0x22c0 drivers/vhost/vhost.c:2335
Code: 00 00 00 48 c7 c6 00 ac 9c 8a 48 c7 c7 28 27 8e 8d 48 89 ca 48 c1 e1 04 48 01 d9 e8 77 23 29 fd e9 74 ff ff ff e8 bd 3f a3 fa <0f> 0b e8 b6 3f a3 fa 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc9000f527b88 EFLAGS: 00010212

RAX: 0000000000000133 RBX: 0000000000000001 RCX: ffffc9000ef65000
RDX: 0000000000040000 RSI: ffffffff86d46e33 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff86d45f2c R11: 0000000000000000 R12: ffff88802bac4d68
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff88802bac4bb0
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c74f8a718 CR3: 000000002bb11000 CR4: 00000000003526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vhost_vsock_handle_tx_kick+0x277/0xa20 drivers/vhost/vsock.c:522
 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:vhost_get_vq_desc+0x1d43/0x22c0 drivers/vhost/vhost.c:2335
Code: 00 00 00 48 c7 c6 00 ac 9c 8a 48 c7 c7 28 27 8e 8d 48 89 ca 48 c1 e1 04 48 01 d9 e8 77 23 29 fd e9 74 ff ff ff e8 bd 3f a3 fa <0f> 0b e8 b6 3f a3 fa 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc9000f527b88 EFLAGS: 00010212

RAX: 0000000000000133 RBX: 0000000000000001 RCX: ffffc9000ef65000
RDX: 0000000000040000 RSI: ffffffff86d46e33 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff86d45f2c R11: 0000000000000000 R12: ffff88802bac4d68
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff88802bac4bb0
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c7679a1b8 CR3: 000000002bb11000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
