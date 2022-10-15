Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7084F5FFB6C
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 19:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJORYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 13:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJORYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 13:24:43 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CDE1CB31
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 10:24:39 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id q12-20020a5d834c000000b006bc2cb1994aso4915133ior.15
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 10:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXDSuoFbN7ibdHQJGHhqaFHsM+PEsrRvhPrQr4NT61Q=;
        b=XtZLYVDqGNjs7oGnS76ArP69KubEtFgF1/4P2+HaYHr+zoAyvB/aEBzZd2LTb/Q0KS
         kZTosGJIB/rk7Ikx539woh33iJkwdLll4yNNrbvL4scI8ewkQB/9q1fjEZoQ5kYLoej/
         ox4qc+mWtlzNGa3MUGuz1TID8F8Vcdee6OjX4lY0V4E0NEGIc0EYwPKrKnvyu+uvarhk
         BTeauomXLHryEa8VLqYaYjb0duGCJNUOSx5q1LjDeb/vkSQoMTsjPVRG4oQ05uxwXeIf
         onEaMLfck53BixdJq6NhaN1Mobe1O65pQAwxOR2rCaIx6Yw2xTszb4quo8Lo9dv9no4k
         9MgA==
X-Gm-Message-State: ACrzQf0K1VTL0yhB/eKn80cnmmRqVHVup3z/Mv6GVDyvxhh3TpZZr8tx
        E5gj9X2dqIp5wi0Q2277RDqUxspLGuv69EmI+EyE+sII1Qcn
X-Google-Smtp-Source: AMsMyM7LsjR7kpP4xhca/8DFkSor8LrpGNZj5UjiIW5s6h0+tgtpLA8uyA22mZlK8EKO7jg9DEgb2XIEE8zWDvg9vntFqhtQxRaP
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1588:b0:6bc:d49a:61cc with SMTP id
 e8-20020a056602158800b006bcd49a61ccmr1519089iow.154.1665854678860; Sat, 15
 Oct 2022 10:24:38 -0700 (PDT)
Date:   Sat, 15 Oct 2022 10:24:38 -0700
In-Reply-To: <0000000000008caae305ab9a5318@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000618a8205eb160404@google.com>
Subject: Re: [syzbot] general protection fault in security_inode_getattr
From:   syzbot <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, dvyukov@google.com, hdanton@sina.com,
        jmorris@namei.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        netdev@vger.kernel.org, omosnace@redhat.com, paul@paul-moore.com,
        serge@hallyn.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com,
        yhs@fb.com
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=147637c6880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
dashboard link: https://syzkaller.appspot.com/bug?extid=f07cc9be8d1d226947ed
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1585a0c2880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1480a464880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6c791937c012/disk-55be6084.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cb21a2879b4c/vmlinux-55be6084.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2d56267ed26f/mount_1.gz

The issue was bisected to:

commit 35697c12d7ffd31a56d3c9604066a166b75d0169
Author: Yonghong Song <yhs@fb.com>
Date:   Thu Jan 16 17:40:04 2020 +0000

    selftests/bpf: Fix test_progs send_signal flakiness with nmi mode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13032139900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10832139900000
console output: https://syzkaller.appspot.com/x/log.txt?x=17032139900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com
Fixes: 35697c12d7ff ("selftests/bpf: Fix test_progs send_signal flakiness with nmi mode")

general protection fault, probably for non-canonical address 0xdffffc000000000d: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
CPU: 0 PID: 3761 Comm: syz-executor352 Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:d_backing_inode include/linux/dcache.h:542 [inline]
RIP: 0010:security_inode_getattr+0x46/0x140 security/security.c:1345
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 04 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 68 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d7 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc9000400f578 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000000d RSI: ffffffff83bd72fe RDI: 0000000000000068
RBP: ffffc9000400f750 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000008c07d R12: ffff8880763dca48
R13: ffffc9000400f750 R14: 00000000000007ff R15: 0000000000000000
FS:  00007f246f27e700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f246f27e718 CR3: 00000000717a9000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 vfs_getattr+0x22/0x60 fs/stat.c:158
 ovl_copy_up_one+0x12c/0x2870 fs/overlayfs/copy_up.c:965
 ovl_copy_up_flags+0x150/0x1d0 fs/overlayfs/copy_up.c:1047
 ovl_maybe_copy_up+0x140/0x190 fs/overlayfs/copy_up.c:1079
 ovl_open+0xf1/0x2d0 fs/overlayfs/file.c:152
 do_dentry_open+0x6cc/0x13f0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x1c92/0x28f0 fs/namei.c:3691
 do_filp_open+0x1b6/0x400 fs/namei.c:3718
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_open fs/open.c:1334 [inline]
 __se_sys_open fs/open.c:1330 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1330
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f246f2f2b49
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f246f27e2f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f246f3774b0 RCX: 00007f246f2f2b49
RDX: 0000000000000000 RSI: 0000000000000300 RDI: 0000000020000140
RBP: 00007f246f3442ac R08: 00007f246f27e700 R09: 0000000000000000
R10: 00007f246f27e700 R11: 0000000000000246 R12: 0031656c69662f2e
R13: 79706f636174656d R14: 0079616c7265766f R15: 00007f246f3774b8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:d_backing_inode include/linux/dcache.h:542 [inline]
RIP: 0010:security_inode_getattr+0x46/0x140 security/security.c:1345
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 04 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 68 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d7 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc9000400f578 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000000d RSI: ffffffff83bd72fe RDI: 0000000000000068
RBP: ffffc9000400f750 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000008c07d R12: ffff8880763dca48
R13: ffffc9000400f750 R14: 00000000000007ff R15: 0000000000000000
FS:  00007f246f27e700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643c9471000 CR3: 00000000717a9000 CR4: 0000000000350ee0
----------------
Code disassembly (best guess):
   0:	48 89 fa             	mov    %rdi,%rdx
   3:	48 c1 ea 03          	shr    $0x3,%rdx
   7:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   b:	0f 85 04 01 00 00    	jne    0x115
  11:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  18:	fc ff df
  1b:	49 8b 5d 08          	mov    0x8(%r13),%rbx
  1f:	48 8d 7b 68          	lea    0x68(%rbx),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 d7 00 00 00    	jne    0x10b
  34:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  3b:	fc ff df
  3e:	48                   	rex.W
  3f:	8b                   	.byte 0x8b

