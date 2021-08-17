Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E693EE458
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 04:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhHQCZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 22:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbhHQCZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 22:25:16 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6BBC061764;
        Mon, 16 Aug 2021 19:24:44 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o1-20020a05600c5101b02902e676fe1f04so896545wms.1;
        Mon, 16 Aug 2021 19:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jAv1x91vaSPKkYNPHeFnu2BudVhGDtwqErw+4Y1kgqM=;
        b=eC6I0pFCXYqournwVvSssCdTP2epVgCEEU6ONcTfQX+Z5ALYwpW7rKEbZCZhqidY+j
         ck3jsfb0Z+q92Frb8YlgwyD6IhbLNmkLIhGTFejmaQXkEgjNBbCmhze/proaRou6nZ2N
         yFXbgVgT6kN+fDzsmIpQ62/RqOUEAR83Fog02xeXLsjRC8yngf18nyjCgXlqzJ7GLVV5
         R2RNHGjXcal37i+khEXnrSOg1sd07J3cEiCpCKt1HaWRObPuAO0O6jIv/TR+qCcSUCeK
         4m1fe1Iq7FfT9IDPyGhy4pxqXVx1fYyQ4++l/OS7sqcLrabbWCHQQG16vM8crVn4b79a
         //jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jAv1x91vaSPKkYNPHeFnu2BudVhGDtwqErw+4Y1kgqM=;
        b=nLId+AXSoZgcqExI9xAoIcKl6+xxpn8+ZKk9w39ZBj5vrnVbFHQSUE87w2yQxYxo9t
         vho1uYZRXGJzj2HfKorV+RdSwmScIFMM5MCGXoNzPQDNxrM21DPd03m7SK2aMkUjxEeD
         lpTB8STPXWEWS6vQNRXBXJbmJriVKzY6ocnnPP8KIDeBFpjmiRp/M2mTWDsAXRCrnVer
         copAZtWuQQlOKPXj5OM8q+sWNrzsV3GzWmT+bRTGFa8Qyi9O2tC4Xlf99qvpn6fWA6LO
         dGdXNil5fyIBb2NKoeO9E7dgQDl90fIe2SVdjzZRT0eFLus6ShJcqGlP0J6NJVhJjzOm
         2RLg==
X-Gm-Message-State: AOAM533SJ9x4/sz5Bs31t4uYrTQsnvadYh0+aB2u5NcKH0uyyVz1pGkz
        6vELnD+6OoKNykshbEGYJSaxtcME7bHZmxuWid0=
X-Google-Smtp-Source: ABdhPJyoNicIIj3VfjrMvBFpXqEth4q9yh5aGoXJ5c//oxeEc6OWmj9pbI0KQhqarLc4iVvFyebVB1sZvxQxs5sYxy0=
X-Received: by 2002:a1c:cc12:: with SMTP id h18mr974031wmb.12.1629167082962;
 Mon, 16 Aug 2021 19:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000789bcd05c9aa3d5d@google.com>
In-Reply-To: <000000000000789bcd05c9aa3d5d@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 17 Aug 2021 10:24:31 +0800
Message-ID: <CADvbK_fo_FQdxj0R67zU_RF9rHz9q52WT204oYgF7tUWOAvagw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __v9fs_get_acl
To:     syzbot <syzbot+56fdf7f6291d819b9b19@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, asmadeus@codewreck.org,
        b.a.t.m.a.n@lists.open-mesh.org, davem <davem@davemloft.net>,
        ericvh@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        lucho@ionkov.net, mareklindner@neomailbox.ch,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 5:58 PM syzbot
<syzbot+56fdf7f6291d819b9b19@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    761c6d7ec820 Merge tag 'arc-5.14-rc6' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11d87ca1300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
> dashboard link: https://syzkaller.appspot.com/bug?extid=56fdf7f6291d819b9b19
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ca6029300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13bf42a1300000
>
> The issue was bisected to:
>
> commit 0ac1077e3a549bf8d35971613e2be05bdbb41a00
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Tue Oct 16 07:52:02 2018 +0000
>
>     sctp: get pr_assoc and pr_stream all status with SCTP_PR_SCTP_ALL instead
can't see how this is related.

>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16f311fa300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15f311fa300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11f311fa300000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+56fdf7f6291d819b9b19@syzkaller.appspotmail.com
> Fixes: 0ac1077e3a54 ("sctp: get pr_assoc and pr_stream all status with SCTP_PR_SCTP_ALL instead")
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8426 at mm/page_alloc.c:5366 __alloc_pages+0x588/0x5f0 mm/page_alloc.c:5413
> Modules linked in:
> CPU: 1 PID: 8426 Comm: syz-executor477 Not tainted 5.14.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__alloc_pages+0x588/0x5f0 mm/page_alloc.c:5413
> Code: 00 48 ba 00 00 00 00 00 fc ff df e9 5e fd ff ff 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 6d fd ff ff e8 bd 62 0a 00 e9 63 fd ff ff <0f> 0b 45 31 e4 e9 7a fd ff ff 48 8d 4c 24 50 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc90000fff9a0 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000014 RCX: 0000000000000000
> RDX: 0000000000000028 RSI: 0000000000000000 RDI: ffffc90000fffa28
> RBP: ffffc90000fffaa8 R08: dffffc0000000000 R09: ffffc90000fffa00
> R10: fffff520001fff45 R11: 0000000000000000 R12: 0000000000040d40
> R13: ffffc90000fffa00 R14: 1ffff920001fff3c R15: 1ffff920001fff38
> FS:  000000000148e300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa1e9a97740 CR3: 000000003406e000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  kmalloc_order+0x41/0x170 mm/slab_common.c:955
>  kmalloc_order_trace+0x15/0x70 mm/slab_common.c:971
>  kmalloc_large include/linux/slab.h:520 [inline]
>  __kmalloc+0x292/0x390 mm/slub.c:4101
>  kmalloc include/linux/slab.h:596 [inline]
>  kzalloc include/linux/slab.h:721 [inline]
>  __v9fs_get_acl+0x40/0x110 fs/9p/acl.c:36
>  v9fs_get_acl+0xa5/0x290 fs/9p/acl.c:71
>  v9fs_mount+0x6ea/0x870 fs/9p/vfs_super.c:182
>  legacy_get_tree+0xea/0x180 fs/fs_context.c:610
>  vfs_get_tree+0x86/0x270 fs/super.c:1498
>  do_new_mount fs/namespace.c:2919 [inline]
>  path_mount+0x196f/0x2be0 fs/namespace.c:3249
>  do_mount fs/namespace.c:3262 [inline]
>  __do_sys_mount fs/namespace.c:3470 [inline]
>  __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3447
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43f2e9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcc30ccf58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f2e9
> RDX: 0000000020000200 RSI: 0000000020000000 RDI: 0000000000000000
> RBP: 0000000000403040 R08: 0000000020004440 R09: 0000000000400488
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004030d0
> R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
