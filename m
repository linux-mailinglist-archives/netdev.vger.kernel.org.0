Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7383E232619
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgG2UXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:23:20 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46280 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbgG2UXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 16:23:19 -0400
Received: by mail-io1-f72.google.com with SMTP id n1so3547871ion.13
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 13:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SFOYc9QJsN32c68HMrVfj1JqMrsQS93FcU4Q9C3mXf8=;
        b=koPY799MvOg/EtnuGHXLBxdmU8xNe4EcAXMJkveuOQYzgU+Pi23HCM3Vds4IIY1+hO
         VCtH1hItp/BsTgh7XLX1wfrspx7t0EyGFZ/cZWeMBNRUWVQtkf4BxRpzghR64Eun4ydc
         KFrKJ0TRgWEXUpIqh1EPu4ecYb0Vy+ZUTpWeWJuXfrZlR5eMVPxJDvrmtFaDj9ZWgOcj
         iGoRaEVB8Wbk56V6ce1h51Lggq1fR7tc0NIg+UkcqyruVPa+HLPISLptEYE2gVIEY7/F
         lBXh0rD3eiUCOnXmWIXmZPBGywK5rA7Cxp4NSyoG6NLs4mF5Rp1TWk3mfjK8J+sQJA/n
         lG0g==
X-Gm-Message-State: AOAM531Ef1X1FFybzIQPnUqivHe/y0W+0Sywd3pYcwUNuO/Tz+ZA6KVn
        cbdGc9AKC0nyYWB8NABo14Hf3O8l1Sz2+tpjVAo1Ulv9yyzq
X-Google-Smtp-Source: ABdhPJxbV+cdUBH6DFzxJ+/nfvfsKrP4dUWI8e7yDBknNiQv0kletRB6o2eHPxypXYe1vaS1BKFPD++GJFnVefmIpp6fno3Rm1nt
MIME-Version: 1.0
X-Received: by 2002:a92:dc8c:: with SMTP id c12mr36077018iln.243.1596054198592;
 Wed, 29 Jul 2020 13:23:18 -0700 (PDT)
Date:   Wed, 29 Jul 2020 13:23:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008caae305ab9a5318@google.com>
Subject: general protection fault in security_inode_getattr
From:   syzbot <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, jmorris@namei.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        serge@hallyn.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    92ed3019 Linux 5.8-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=140003ac900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=84f076779e989e69
dashboard link: https://syzkaller.appspot.com/bug?extid=f07cc9be8d1d226947ed
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
CPU: 0 PID: 9214 Comm: syz-executor.3 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:d_backing_inode include/linux/dcache.h:549 [inline]
RIP: 0010:security_inode_getattr+0x46/0x140 security/security.c:1276
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 04 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d7 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc9000d41f638 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000f539000
RDX: 000000000000000c RSI: ffffffff8354f8ee RDI: 0000000000000060
RBP: ffffc9000d41f810 R08: 0000000000000001 R09: ffff88804edc2dc8
R10: 0000000000000000 R11: 00000000000ebc58 R12: ffff888089f10170
R13: ffffc9000d41f810 R14: 00000000000007ff R15: 0000000000000000
FS:  00007f3599717700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2c12c000 CR3: 0000000099919000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 vfs_getattr+0x22/0x60 fs/stat.c:121
 ovl_copy_up_one+0x13b/0x1870 fs/overlayfs/copy_up.c:850
 ovl_copy_up_flags+0x14b/0x1d0 fs/overlayfs/copy_up.c:931
 ovl_maybe_copy_up+0x140/0x190 fs/overlayfs/copy_up.c:963
 ovl_open+0xba/0x270 fs/overlayfs/file.c:147
 do_dentry_open+0x501/0x1290 fs/open.c:828
 do_open fs/namei.c:3243 [inline]
 path_openat+0x1bb9/0x2750 fs/namei.c:3360
 do_filp_open+0x17e/0x3c0 fs/namei.c:3387
 file_open_name+0x290/0x400 fs/open.c:1124
 acct_on+0x78/0x770 kernel/acct.c:207
 __do_sys_acct kernel/acct.c:286 [inline]
 __se_sys_acct kernel/acct.c:273 [inline]
 __x64_sys_acct+0xab/0x1f0 kernel/acct.c:273
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c369
Code: 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3599716c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a3
RAX: ffffffffffffffda RBX: 0000000000000700 RCX: 000000000045c369
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000440
RBP: 000000000078bf30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007ffda41ffbef R14: 00007f35997179c0 R15: 000000000078bf0c
Modules linked in:
---[ end trace d1398a63985d3915 ]---
RIP: 0010:d_backing_inode include/linux/dcache.h:549 [inline]
RIP: 0010:security_inode_getattr+0x46/0x140 security/security.c:1276
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 04 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d7 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc9000d41f638 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000f539000
RDX: 000000000000000c RSI: ffffffff8354f8ee RDI: 0000000000000060
RBP: ffffc9000d41f810 R08: 0000000000000001 R09: ffff88804edc2dc8
R10: 0000000000000000 R11: 00000000000ebc58 R12: ffff888089f10170
R13: ffffc9000d41f810 R14: 00000000000007ff R15: 0000000000000000
FS:  00007f3599717700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000440 CR3: 0000000099919000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
