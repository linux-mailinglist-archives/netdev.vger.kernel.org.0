Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907B53C5FD
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404723AbfFKIde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:33:34 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:34991 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404634AbfFKIdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:33:33 -0400
Received: by mail-it1-f194.google.com with SMTP id n189so3437522itd.0
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 01:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B0Y3O12b1qmvyGKzErKcY2Z6E2KbcdPjV20vlFJhMxU=;
        b=BWg5U1gGfLRkwLfoAu8lH9SB/QqDRw4tOVtYw9KE2xrqLmWXWeT3EWucG3TlNuSZLh
         feVg/qrMTHbxZ05E/dm9fYUvbCebg649vufzVyPN1/o2Bp6O9Lbe8/AVXvPmGDYvcfa3
         DGG/Qr/QfYVB3sdoS0gBoSyr8zFkRcPwjpWI++OOemeeyu3OY+enYTEjHc+tUGK4nbMo
         Q1XnPEaFlSqO64tHLERIuUqZh/0TRbw4tkZxURrRyPKP0Ib2PLAnNc1MTSpv+WytPNP3
         nCfZM55QcZmCfXhdWa0tKZKg30VbCxlpp7Zt97K4EasEvGmn0zRfpY4rBAtfLrAzQ3r4
         Jt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B0Y3O12b1qmvyGKzErKcY2Z6E2KbcdPjV20vlFJhMxU=;
        b=ILBElv7NzAqqNZYP/X6LCcUWndr1OAskSwBKlyfCLpBoGRYmXv9+qLuVJZiOOf0pi5
         vMi3vlt9n2yhNjF7u3Y/5wcWdlL4BqyGv0tCBCxWd5O2jxD8UxOfAs2cCqx1H+ozQUml
         tTD9NOCpYZI/FPJusb1XsqvbrUCvGmhIuGxP/ukpnlKg9wSLa/ELn8HFw/AObwEFDI3P
         nnXn2uzzv0lqi9RMKGlI5o/U3w26UC7uWp0ph5456Fl3ILJCvmmeo6sACZrpzQyzBSMH
         VzKGL/HRmgm6h23sdnVqeH8pA9zPYQdPJbx8oXo0hFglwaiNglHKLccRtfTfPAH3ju/e
         AKjg==
X-Gm-Message-State: APjAAAXvx5Ab+q+h+BOkR9HfPuUaoDG2xw6Ae1FBW9oiEd0UY5LjLOCD
        NAwU/YG6sz5fic6JqyJDT+wTAgnUflsWlvYuqw8z6g==
X-Google-Smtp-Source: APXvYqyGRDEj+hGsvqMHlWAjCWLbR/yrf8USivwF+7Z+wkIgiAWU3j8sWSApndzgxwsYkARvyri0os2lim9tlenh+kI=
X-Received: by 2002:a02:22c6:: with SMTP id o189mr35904824jao.35.1560242012205;
 Tue, 11 Jun 2019 01:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e92d1805711f5552@google.com> <000000000000381684058ace28e5@google.com>
 <20190611080431.GP21222@phenom.ffwll.local>
In-Reply-To: <20190611080431.GP21222@phenom.ffwll.local>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 11 Jun 2019 10:33:21 +0200
Message-ID: <CACT4Y+YMFKe1cq_XpP0o5fd+XLD_8qMVjqnVX5rx1UCWyCR5eg@mail.gmail.com>
Subject: Re: WARNING in bpf_jit_free
To:     syzbot <syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com>,
        David Airlie <airlied@linux.ie>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        DRI <dri-devel@lists.freedesktop.org>, hawk@kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, maxime.ripard@bootlin.com,
        netdev <netdev@vger.kernel.org>, paul.kocialkowski@bootlin.com,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>, wens@csie.org,
        xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 10:04 AM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Sat, Jun 08, 2019 at 04:22:06AM -0700, syzbot wrote:
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    79c3ba32 Merge tag 'drm-fixes-2019-06-07-1' of git://anong..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1201b971a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=2ff1e7cb738fd3c41113
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a3bf51a00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120d19f2a00000
>
> Looking at the reproducer I don't see any calls to ioctl which could end
> up anywhere in drm.
> >
> > The bug was bisected to:
> >
> > commit 0fff724a33917ac581b5825375d0b57affedee76
> > Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > Date:   Fri Jan 18 14:51:13 2019 +0000
> >
> >     drm/sun4i: backend: Use explicit fourcc helpers for packed YUV422 check
>
> And most definitely not in drm/sun4i. You can only hit this if you have
> sun4i and run on arm, which per your config isn't the case.
>
> tldr; smells like bisect gone wrong.
> -Daniel

From the bisection log it looks like the bug is too hard to trigger
for reliable bisection. So it probably classified one bad commit as
good. But it should got quite close to the right one.

> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1467550f200000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1667550f200000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1267550f200000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com
> > Fixes: 0fff724a3391 ("drm/sun4i: backend: Use explicit fourcc helpers for
> > packed YUV422 check")
> >
> > WARNING: CPU: 0 PID: 8951 at kernel/bpf/core.c:851 bpf_jit_free+0x157/0x1b0
> > Kernel panic - not syncing: panic_on_warn set ...
> > CPU: 0 PID: 8951 Comm: kworker/0:0 Not tainted 5.2.0-rc3+ #23
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: events bpf_prog_free_deferred
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> >  panic+0x2cb/0x744 kernel/panic.c:219
> >  __warn.cold+0x20/0x4d kernel/panic.c:576
> >  report_bug+0x263/0x2b0 lib/bug.c:186
> >  fixup_bug arch/x86/kernel/traps.c:179 [inline]
> >  fixup_bug arch/x86/kernel/traps.c:174 [inline]
> >  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
> >  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
> >  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
> > RIP: 0010:bpf_jit_free+0x157/0x1b0
> > Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5d 48 b8 00 02 00 00
> > 00 00 ad de 48 39 43 70 0f 84 05 ff ff ff e8 f9 b5 f4 ff <0f> 0b e9 f9 fe ff
> > ff e8 bd 53 2d 00 e9 d9 fe ff ff 48 89 7d e0 e8
> > RSP: 0018:ffff88808886fcb0 EFLAGS: 00010293
> > RAX: ffff88808cb6c480 RBX: ffff88809051d280 RCX: ffffffff817ae68d
> > RDX: 00000000> >
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20190611080431.GP21222%40phenom.ffwll.local.
> For more options, visit https://groups.google.com/d/optout.00000000 RSI: ffffffff817bf0f7 RDI: ffff88809051d2f0
> > RBP: ffff88808886fcd0 R08: 1ffffffff14ccaa8 R09: fffffbfff14ccaa9
> > R10: fffffbfff14ccaa8 R11: ffffffff8a665547 R12: ffffc90001925000
> > R13: ffff88809051d2e8 R14: ffff8880a0e43900 R15: ffff8880ae834840
> >  bpf_prog_free_deferred+0x27a/0x350 kernel/bpf/core.c:1984
> >  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
> >  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
> >  kthread+0x354/0x420 kernel/kthread.c:255
> >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Kernel Offset: disabled
> > Rebooting in 86400 seconds..
