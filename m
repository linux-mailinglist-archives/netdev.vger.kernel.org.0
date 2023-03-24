Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53A66C74BF
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 01:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjCXAws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 20:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCXAwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 20:52:43 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917F92B29E
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 17:52:41 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id n9-20020a056e02100900b00325c9240af7so273536ilj.10
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 17:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679619161;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NbLgZ+ma1ZfiOVBSImtXnwlwTbasrfu4yCbRLpGR2oA=;
        b=Z9WEa2L6QWJOrKxBgaVjGalzl6zQ/xwA/D1bAfV161iYwk0LQu9aSKulyORsS70xxT
         biAvUpgFzS9Ys0eYm+iPlzlRrlgkZFVHkZIKAcgLSmtrZ6xof5ZTi5CK6FAlzJfDvKUC
         zw8/n87GM0/YgTGFApChvKjyGWtB0T5ml/a+8SGNyjTFUVyO9rnZA92zjFawM2aWYhKx
         lq4XovYoQljJakSR1qONo9FqBoJcA8ViHI6Pp+tI/h8FKPIizcGSMRx6FrvSY56MytNk
         qI+x9vO0A04QDsGKxRvY6M190CyTOb11Agfv8dUVg2hyGl3bdLsIiEaEX3BgrVAij2ey
         1EtQ==
X-Gm-Message-State: AO0yUKW82zVLwIvoGQTszkiLLb91rFKht8gHu2VWENLPd/RHXfTvVrwD
        6ix+zsMl+qMiVNoEEU6fsN7MinL06pMpMCXdnc7z7ULJc08k
X-Google-Smtp-Source: AK7set8LnygjG5RALTEKJa+rFuaxrdlQBozjX737gRU2FulKQ3Sy72CSddg5sjWT6V7nkHk1DUzoaYDwuwDaITDZVgjUcBBPeMTA
MIME-Version: 1.0
X-Received: by 2002:a02:6203:0:b0:3c5:19e6:b532 with SMTP id
 d3-20020a026203000000b003c519e6b532mr283859jac.6.1679619160834; Thu, 23 Mar
 2023 17:52:40 -0700 (PDT)
Date:   Thu, 23 Mar 2023 17:52:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000708b1005f79acf5c@google.com>
Subject: [syzbot] [kvm?] [net?] [virt?] general protection fault in virtio_transport_purge_skbs
From:   syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sgarzare@redhat.com,
        stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fff5a5e7f528 Merge tag 'for-linus' of git://git.armlinux.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1136e97ac80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aaa4b45720ca0519
dashboard link: https://syzkaller.appspot.com/bug?extid=befff0a9536049e7902e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14365781c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12eebc66c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/997791f5f9e1/disk-fff5a5e7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0b0155b5eac1/vmlinux-fff5a5e7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8d98dd2ba6b6/bzImage-fff5a5e7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 8759 Comm: syz-executor379 Not tainted 6.3.0-rc3-syzkaller-00026-gfff5a5e7f528 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:virtio_transport_purge_skbs+0x139/0x4c0 net/vmw_vsock/virtio_transport_common.c:1370
Code: 00 00 00 00 fc ff df 48 89 c2 48 89 44 24 28 48 c1 ea 03 48 8d 04 1a 48 89 44 24 10 eb 29 e8 ee 27 a3 f7 48 89 e8 48 c1 e8 03 <80> 3c 18 00 0f 85 a6 02 00 00 49 39 ec 48 8b 55 00 49 89 ef 0f 84
RSP: 0018:ffffc90006427b48 EFLAGS: 00010256
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff8880211157c0 RSI: ffffffff89dfbd12 RDI: ffff88802c11a018
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000c84f5b R11: 0000000000000000 R12: ffffffff92179188
R13: ffffc90006427ba0 R14: ffff88801e0f1100 R15: ffff88802c11a000
FS:  00007f01fdd51700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f01fdd30718 CR3: 000000002a3f9000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 vsock_loopback_cancel_pkt+0x1c/0x20 net/vmw_vsock/vsock_loopback.c:48
 vsock_transport_cancel_pkt net/vmw_vsock/af_vsock.c:1284 [inline]
 vsock_connect+0x852/0xcc0 net/vmw_vsock/af_vsock.c:1426
 __sys_connect_file+0x153/0x1a0 net/socket.c:2001
 __sys_connect+0x165/0x1a0 net/socket.c:2018
 __do_sys_connect net/socket.c:2028 [inline]
 __se_sys_connect net/socket.c:2025 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2025
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f01fdda0159
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f01fdd51308 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00007f01fde28428 RCX: 00007f01fdda0159
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f01fde28420 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f01fddf606c
R13: 0000000000000000 R14: 00007f01fdd51400 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:virtio_transport_purge_skbs+0x139/0x4c0 net/vmw_vsock/virtio_transport_common.c:1370
Code: 00 00 00 00 fc ff df 48 89 c2 48 89 44 24 28 48 c1 ea 03 48 8d 04 1a 48 89 44 24 10 eb 29 e8 ee 27 a3 f7 48 89 e8 48 c1 e8 03 <80> 3c 18 00 0f 85 a6 02 00 00 49 39 ec 48 8b 55 00 49 89 ef 0f 84
RSP: 0018:ffffc90006427b48 EFLAGS: 00010256
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff8880211157c0 RSI: ffffffff89dfbd12 RDI: ffff88802c11a018
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000c84f5b R11: 0000000000000000 R12: ffffffff92179188
R13: ffffc90006427ba0 R14: ffff88801e0f1100 R15: ffff88802c11a000
FS:  00007f01fdd51700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f01fdd30718 CR3: 000000002a3f9000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess), 6 bytes skipped:
   0:	df 48 89             	fisttps -0x77(%rax)
   3:	c2 48 89             	retq   $0x8948
   6:	44 24 28             	rex.R and $0x28,%al
   9:	48 c1 ea 03          	shr    $0x3,%rdx
   d:	48 8d 04 1a          	lea    (%rdx,%rbx,1),%rax
  11:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  16:	eb 29                	jmp    0x41
  18:	e8 ee 27 a3 f7       	callq  0xf7a3280b
  1d:	48 89 e8             	mov    %rbp,%rax
  20:	48 c1 e8 03          	shr    $0x3,%rax
* 24:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1) <-- trapping instruction
  28:	0f 85 a6 02 00 00    	jne    0x2d4
  2e:	49 39 ec             	cmp    %rbp,%r12
  31:	48 8b 55 00          	mov    0x0(%rbp),%rdx
  35:	49 89 ef             	mov    %rbp,%r15
  38:	0f                   	.byte 0xf
  39:	84                   	.byte 0x84


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
