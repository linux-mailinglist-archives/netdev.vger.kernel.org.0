Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CAE60000D
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 16:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiJPOw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 10:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJPOw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 10:52:56 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B147027FE3
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 07:52:53 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id k3so10709220ybk.9
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 07:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZdHbgEIqE71zqzvD5lFD1iP09tkUsZi6uBS+RZqLGJk=;
        b=xXVGCqLxPehqC5Kal6037wodgHSecfAsuPSBzWQ1Qeq8zBWBTXn9mdDlsJBBC86wgu
         BEu3uRO4I8S2rBj/1d0f+w3HAueW4w1XOC9ZVr9Lf4QHaBy+3VSrFcyT3D0ETHq0tro5
         WeQItCzXuyvYdRGjxz6MVk7LJmambgDKgjknFbutI5rOwqXi8PdxIXv9xrZ8/CsjD1M2
         nii1cSrUGoM6RoC80IICwGYWlPbJd3esCsbrdDZo9aXJC4FNMPHL9iICqeeE3oacb2A1
         mDtZ/ycDJq5IbDQWTm7H+hhCB9Jk1sGLLpAmZFXlW0qQbm867+JfIg1/pgPsalj8gjm5
         a7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZdHbgEIqE71zqzvD5lFD1iP09tkUsZi6uBS+RZqLGJk=;
        b=2TFEzzaFrF8y6vzxfzz3u7ANT7uIDqeh1MZBhxqktUvNuE1LwAis0CwxUkuQ7/HOVw
         rEBhn32976b9kPnv1MwT5jLt+rrbefR8OZ7OMrxA0FqS+7tIBZ5TA22LkkgmU9ekzmcl
         ovrJ2Xz6T+o6UzfP5xTk8brYxeTQ1qCaRkOGfAzN7YQYu5AoBhZoRbxlKf79skyNbHPv
         erTO/RscoMEL8/jhcD9piAkQhbjgtHvi8T2xG3bs1GReS+UyJMQG2/G66eqLypykoRU3
         24Nhhs2/lzm1YID5CG5YpQaNt846z9+e7bLd5OsOWCBXnTrqkA/vmdvu5ZX+ac0zcz14
         0q2A==
X-Gm-Message-State: ACrzQf2CJeW8a/qHkZ5q1qaucQB9YdS3NcRwx/vm8oAIrg/Ybt1HiNzr
        LY5DNzjInHrLcB131BW+zKYIxdHX2OTKmJ/Y56lE
X-Google-Smtp-Source: AMsMyM5gRTtPYzoabg/Y0bfdBfHZFAndDRmG+NHcskvOABLdhFlFTzIX3FhB4/EANoTxAQAz9MQgBJzs6ZnzTF97bUA=
X-Received: by 2002:a05:6902:724:b0:6c0:1784:b6c7 with SMTP id
 l4-20020a056902072400b006c01784b6c7mr5849058ybt.15.1665931972823; Sun, 16 Oct
 2022 07:52:52 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008caae305ab9a5318@google.com> <000000000000618a8205eb160404@google.com>
In-Reply-To: <000000000000618a8205eb160404@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 16 Oct 2022 10:52:41 -0400
Message-ID: <CAHC9VhRt2vpArZ=bOrkBOGiAuoTdEcp2PRP5NtbyEZkuMHvopA@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in security_inode_getattr
To:     syzbot <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, dvyukov@google.com, hdanton@sina.com,
        jmorris@namei.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        netdev@vger.kernel.org, omosnace@redhat.com, serge@hallyn.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tonymarislogistics@yandex.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 1:24 PM syzbot
<syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=147637c6880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
> dashboard link: https://syzkaller.appspot.com/bug?extid=f07cc9be8d1d226947ed
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1585a0c2880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1480a464880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6c791937c012/disk-55be6084.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cb21a2879b4c/vmlinux-55be6084.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/2d56267ed26f/mount_1.gz
>
> The issue was bisected to:
>
> commit 35697c12d7ffd31a56d3c9604066a166b75d0169
> Author: Yonghong Song <yhs@fb.com>
> Date:   Thu Jan 16 17:40:04 2020 +0000
>
>     selftests/bpf: Fix test_progs send_signal flakiness with nmi mode
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13032139900000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10832139900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17032139900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com
> Fixes: 35697c12d7ff ("selftests/bpf: Fix test_progs send_signal flakiness with nmi mode")
>
> general protection fault, probably for non-canonical address 0xdffffc000000000d: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
> CPU: 0 PID: 3761 Comm: syz-executor352 Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> RIP: 0010:d_backing_inode include/linux/dcache.h:542 [inline]
> RIP: 0010:security_inode_getattr+0x46/0x140 security/security.c:1345
> Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 04 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 68 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d7 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
> RSP: 0018:ffffc9000400f578 EFLAGS: 00010212
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 000000000000000d RSI: ffffffff83bd72fe RDI: 0000000000000068
> RBP: ffffc9000400f750 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 000000000008c07d R12: ffff8880763dca48
> R13: ffffc9000400f750 R14: 00000000000007ff R15: 0000000000000000
> FS:  00007f246f27e700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f246f27e718 CR3: 00000000717a9000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  vfs_getattr+0x22/0x60 fs/stat.c:158
>  ovl_copy_up_one+0x12c/0x2870 fs/overlayfs/copy_up.c:965
>  ovl_copy_up_flags+0x150/0x1d0 fs/overlayfs/copy_up.c:1047
>  ovl_maybe_copy_up+0x140/0x190 fs/overlayfs/copy_up.c:1079
>  ovl_open+0xf1/0x2d0 fs/overlayfs/file.c:152
>  do_dentry_open+0x6cc/0x13f0 fs/open.c:882
>  do_open fs/namei.c:3557 [inline]
>  path_openat+0x1c92/0x28f0 fs/namei.c:3691
>  do_filp_open+0x1b6/0x400 fs/namei.c:3718
>  do_sys_openat2+0x16d/0x4c0 fs/open.c:1310
>  do_sys_open fs/open.c:1326 [inline]
>  __do_sys_open fs/open.c:1334 [inline]
>  __se_sys_open fs/open.c:1330 [inline]
>  __x64_sys_open+0x119/0x1c0 fs/open.c:1330
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f246f2f2b49
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f246f27e2f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 00007f246f3774b0 RCX: 00007f246f2f2b49
> RDX: 0000000000000000 RSI: 0000000000000300 RDI: 0000000020000140
> RBP: 00007f246f3442ac R08: 00007f246f27e700 R09: 0000000000000000
> R10: 00007f246f27e700 R11: 0000000000000246 R12: 0031656c69662f2e
> R13: 79706f636174656d R14: 0079616c7265766f R15: 00007f246f3774b8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---

It doesn't look like this is a problem with
security_inode_getattr()/d_backing_inode() as it appears that the
passed path struct pointer has a bogus/NULL path->dentry pointer and
to the best of my knowledge it would appear that vfs_getattr() (the
caller) requires a valid path->dentry value.

Looking quickly at the code, I wonder if there is something wonky
going on in the overlayfs code, specifically ovl_copy_up_flags() and
ovl_copy_up_one() as they have to play a number of tricks to handle
the transparent overlays and copy up operations.  I'm not an overlayfs
expert, but that seems like a good place to start digging further into
this.

-- 
paul-moore.com
