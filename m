Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6A919C446
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgDBOcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:32:13 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:45500 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387737AbgDBOcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:32:11 -0400
Received: by mail-qv1-f65.google.com with SMTP id g4so1708497qvo.12
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 07:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nEm39zdPpGwdrSWdhPm/fhoaJJGSTcSstNUDzJRA8Fo=;
        b=XpOJz5aVad5ILzm1UZMEQ/guQhRlhu5uHMvExQNsl9PvPJivkFmdWAQmilUhNBNZ00
         GznZ/zVwqZZKLAR9q/s6lsHrMZZwxJ5klD2dvq5rpQR2cm9GpCWQPV3hqGnUsml5eGT7
         ec9ObLpOFpNM7wgCSHdYtfRV95vIVusLz+UItV2LZlhwnkh6B3V5EdunYBYz2aW1qIoQ
         D/axIB3E7dDHIzj8eJBHVBLvdjevUBNytTHq1kZEcUCbBEVCb0tdaLx6bRGuGGPqk1Pw
         Oc3Npi2KhsIErtTFeTfGXWR2KKmNn1YNQlxoFJb+13RWdvobDd7J+vsbPdPSK5rKVA+C
         XLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nEm39zdPpGwdrSWdhPm/fhoaJJGSTcSstNUDzJRA8Fo=;
        b=k0i5Fql8o/rhdSpRBRNqOzeaHx+L1b+PDeW789RrVntyr29+ns3hHj+haRVO+IA5KM
         YgKAjbwSXMqNYoEaVQhWSNS/nqCd8avgAGzQUDX1ft0adb+afaA1oJblsfiZId+5Z7hF
         c+L0sMQzZTJXj38dtbS99iArMWuWiqf/ncYWzuAQizBukvmEuk5KNznkXQpcZq5Fw/QF
         FXV2tRpBXywhUgMHZsTx7sLHv3W/+64Q0auYN3r/zAXJ0V0OPc8vMBJrLKGupz7YCbhQ
         mibrz3IxIcLWYq/QNkr9/IsN/6rGo+YUbpY7UwHljwPIgnTmsKliCNaiZV1UzjK5jnnA
         vB8A==
X-Gm-Message-State: AGi0PubSp/66CfxA/MK6Q911yiUiRaDue/3E5yffh8AomSGccOErnpxz
        W19ut2XK5P5ugoW60aO/j3ZwXXk8sd8gAacygSsmKQ==
X-Google-Smtp-Source: APiQypJwqfcLWhsYN3F97f6DqmbK/ct6u6QjagEjXfdiopJ7JHUgbfygP+NXFOBTG1tjYFE36Me19lRiNXiQ7Mb7iCY=
X-Received: by 2002:a05:6214:1367:: with SMTP id c7mr1857836qvw.22.1585837928739;
 Thu, 02 Apr 2020 07:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008c5a4605a24cbb16@google.com> <2094673.WoIe4zePQG@kermit.br.ibm.com>
In-Reply-To: <2094673.WoIe4zePQG@kermit.br.ibm.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 2 Apr 2020 16:31:56 +0200
Message-ID: <CACT4Y+YpJt=qMSWKGneTCgzGOErxAE3n3WX+6FYFii2LoBuNQQ@mail.gmail.com>
Subject: Re: WARNING in ext4_da_update_reserve_space
To:     =?UTF-8?Q?Murilo_Opsfelder_Ara=C3=BAjo?= <muriloo@linux.ibm.com>
Cc:     syzbot <syzbot+67e4f16db666b1c8253c@syzkaller.appspotmail.com>,
        a@unstable.cc, Andreas Dilger <adilger.kernel@dilger.ca>,
        b.a.t.m.a.n@lists.open-mesh.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        mareklindner@neomailbox.ch, Michael Ellerman <mpe@ellerman.id.au>,
        netdev <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 2, 2020 at 4:06 PM Murilo Opsfelder Ara=C3=BAjo
<muriloo@linux.ibm.com> wrote:
>
> On Thursday, April 2, 2020 8:02:11 AM -03 syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    1a147b74 Merge branch 'DSA-mtu'
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14237713e00=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D46ee14d4915=
944bc
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D67e4f16db666b=
1c8253c
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12237713e=
00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10ec7c97e00=
000
> >
> > The bug was bisected to:
> >
> > commit 658b0f92bc7003bc734471f61bf7cd56339eb8c3
> > Author: Murilo Opsfelder Araujo <muriloo@linux.ibm.com>
> > Date:   Wed Aug 1 21:33:15 2018 +0000
> >
> >     powerpc/traps: Print unhandled signals in a separate function
>
> This commit is specific to powerpc and the crash is from an x86_64 system=
.
>
> There is a bunch of scp errors in the logs:
>
> scp: ./syz-executor998635077: No space left on device
>
> Is it possible that these errors might be misleading the syzbot?

You may see how it reacted on them based on
# git bisect bad/good
lines. As far as I see these errors did not confuse it.

But this guy did:
run #0: crashed: general protection fault in batadv_iv_ogm_queue_add






> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D15979f5b=
e00000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=3D17979f5b=
e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D13979f5be00=
000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+67e4f16db666b1c8253c@syzkaller.appspotmail.com
> > Fixes: 658b0f92bc70 ("powerpc/traps: Print unhandled signals in a separ=
ate
> > function")
> >
> > EXT4-fs warning (device sda1): ext4_da_update_reserve_space:344:
> > ext4_da_update_reserve_space: ino 15722, used 1 with only 0 reserved da=
ta
> > blocks ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 359 at fs/ext4/inode.c:348
> > ext4_da_update_reserve_space+0x622/0x7d0 fs/ext4/inode.c:344 Kernel pan=
ic -
> > not syncing: panic_on_warn set ...
> > CPU: 1 PID: 359 Comm: kworker/u4:5 Not tainted 5.6.0-rc7-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011 Workqueue: writeback wb_workfn (flush-8:0)
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x188/0x20d lib/dump_stack.c:118
> >  panic+0x2e3/0x75c kernel/panic.c:221
> >  __warn.cold+0x2f/0x35 kernel/panic.c:582
> >  report_bug+0x27b/0x2f0 lib/bug.c:195
> >  fixup_bug arch/x86/kernel/traps.c:174 [inline]
> >  fixup_bug arch/x86/kernel/traps.c:169 [inline]
> >  do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
> >  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
> >  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> > RIP: 0010:ext4_da_update_reserve_space+0x622/0x7d0 fs/ext4/inode.c:348
> > Code: 02 00 0f 85 94 01 00 00 48 8b 7d 28 49 c7 c0 20 72 3c 88 41 56 48=
 c7
> > c1 80 60 3c 88 53 ba 58 01 00 00 4c 89 c6 e8 1e 6d 0d 00 <0f> 0b 48 b8 =
00
> > 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 0f b6 04 RSP:
> > 0018:ffffc90002197288 EFLAGS: 00010296
> > RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff820bf066 RDI: fffff52000432e21
> > RBP: ffff888086b744c8 R08: 0000000000000091 R09: ffffed1015ce6659
> > R10: ffffed1015ce6658 R11: ffff8880ae7332c7 R12: 0000000000000001
> > R13: ffff888086b74990 R14: 0000000000000000 R15: ffff888086b74a40
> >  ext4_ext_map_blocks+0x24aa/0x37d0 fs/ext4/extents.c:4500
> >  ext4_map_blocks+0x4cb/0x1650 fs/ext4/inode.c:622
> >  mpage_map_one_extent fs/ext4/inode.c:2365 [inline]
> >  mpage_map_and_submit_extent fs/ext4/inode.c:2418 [inline]
> >  ext4_writepages+0x19eb/0x3080 fs/ext4/inode.c:2772
> >  do_writepages+0xfa/0x2a0 mm/page-writeback.c:2344
> >  __writeback_single_inode+0x12a/0x1410 fs/fs-writeback.c:1452
> >  writeback_sb_inodes+0x515/0xdd0 fs/fs-writeback.c:1716
> >  wb_writeback+0x2a5/0xd90 fs/fs-writeback.c:1892
> >  wb_do_writeback fs/fs-writeback.c:2037 [inline]
> >  wb_workfn+0x339/0x11c0 fs/fs-writeback.c:2078
> >  process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
> >  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
> >  kthread+0x357/0x430 kernel/kthread.c:255
> >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Kernel Offset: disabled
> > Rebooting in 86400 seconds..
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bise=
ction
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>
> --
> Murilo
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/2094673.WoIe4zePQG%40kermit.br.ibm.com.
