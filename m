Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316323C68A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404609AbfFKIv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:51:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43986 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404014AbfFKIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:51:28 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so18841631edb.10
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 01:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=omJ/gQVCRHiP1mzn5vFGNqzD3Ej8FBhph57vNj7+2+U=;
        b=kUJTjpQuyMbXk93njpHM3k6QoX8RPZogTfl+8U8433P85C0qtQkomi2N3Ta3NwYpK8
         d3jnprLPROJiR7CcBOpw1oEakKM+siBt3nrXieW7Qy9wvruNhWOrjOC3JYbnqtOFXcUK
         s0BiQJn8siLUOn65av3Tjt06i6k0QCRN4LLPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=omJ/gQVCRHiP1mzn5vFGNqzD3Ej8FBhph57vNj7+2+U=;
        b=S64HxorTZTEf4SuWEcJwD1NIV33b7QM/UcBQYknWLyhDi/MeeU8TIh7u3f8iI5nxNY
         +47kioNncYt8DvdWun3T5qJPwGmAozBYf8gPwJm+Bsq4HdJf0ABZ4zEX1WfQOolDwnNn
         1a+ErkpbUXBIBUrC9LpPLsEvPXvklxXjr7SH7muKyeNNi64SxY5yXxBN4KqfBeyTj9dK
         hfn3F1xWvrretF9w+1P8FphbtHNBY7qUMLMF/iiGT99jQC+JxRBu2Pun9I7iym2d7LEu
         NZNxGzwqo09vcAxwFL6EgiRvy6ucYwGMgJqWuIf3DVk4ivMqzfEU1NpgFFTGyWNfzvYp
         nshg==
X-Gm-Message-State: APjAAAUC7KmB60i6hGVD7mrEznETpuvkAM03u2i//ADuySXvmbjaAsgj
        kqG+qL7Chg1ETQTgXlZXKGJdUw==
X-Google-Smtp-Source: APXvYqw3/aAUmVHCu0mGixW6kqJWcVN5+tdHtfvax9kpwDGm5hXz6VB7nLZ5jD0lSOSvFoX71EN+7w==
X-Received: by 2002:a17:906:9410:: with SMTP id q16mr28289475ejx.90.1560243086366;
        Tue, 11 Jun 2019 01:51:26 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id q11sm3583175edd.51.2019.06.11.01.51.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 01:51:25 -0700 (PDT)
Date:   Tue, 11 Jun 2019 10:51:23 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com>,
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
        xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: WARNING in bpf_jit_free
Message-ID: <20190611085123.GU21222@phenom.ffwll.local>
Mail-Followup-To: Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com>,
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
References: <000000000000e92d1805711f5552@google.com>
 <000000000000381684058ace28e5@google.com>
 <20190611080431.GP21222@phenom.ffwll.local>
 <CACT4Y+YMFKe1cq_XpP0o5fd+XLD_8qMVjqnVX5rx1UCWyCR5eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YMFKe1cq_XpP0o5fd+XLD_8qMVjqnVX5rx1UCWyCR5eg@mail.gmail.com>
X-Operating-System: Linux phenom 4.14.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 10:33:21AM +0200, Dmitry Vyukov wrote:
> On Tue, Jun 11, 2019 at 10:04 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > On Sat, Jun 08, 2019 at 04:22:06AM -0700, syzbot wrote:
> > > syzbot has found a reproducer for the following crash on:
> > >
> > > HEAD commit:    79c3ba32 Merge tag 'drm-fixes-2019-06-07-1' of git://anong..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1201b971a00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=2ff1e7cb738fd3c41113
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a3bf51a00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120d19f2a00000
> >
> > Looking at the reproducer I don't see any calls to ioctl which could end
> > up anywhere in drm.
> > >
> > > The bug was bisected to:
> > >
> > > commit 0fff724a33917ac581b5825375d0b57affedee76
> > > Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > Date:   Fri Jan 18 14:51:13 2019 +0000
> > >
> > >     drm/sun4i: backend: Use explicit fourcc helpers for packed YUV422 check
> >
> > And most definitely not in drm/sun4i. You can only hit this if you have
> > sun4i and run on arm, which per your config isn't the case.
> >
> > tldr; smells like bisect gone wrong.
> > -Daniel
> 
> From the bisection log it looks like the bug is too hard to trigger
> for reliable bisection. So it probably classified one bad commit as
> good. But it should got quite close to the right one.

Well statistically it'll get close, since there's a fair chance that it's
one of the later bisect results that got mischaracterized.

But you can be equally unlucky, and if it's one of the earliers, then it
can easily be a few thousand commits of. Looking at the log it's mostly
bad, with a few good sprinkled in, which could just be reproduction
failures. So might very well be that the very first "good" result is
wrong. And that very first "good" decision cuts away a big pile of bpf
related commits. The next "good" decision then only cuts away a pile of
drm commits, but at that point you're already off the rails most likely.

I'd say re-test on f90d64483ebd394958841f67f8794ab203b319a7 a few times,
I'm willing to bet that one is actually bad.

Cheers, Daniel

> 
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1467550f200000
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1667550f200000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1267550f200000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com
> > > Fixes: 0fff724a3391 ("drm/sun4i: backend: Use explicit fourcc helpers for
> > > packed YUV422 check")
> > >
> > > WARNING: CPU: 0 PID: 8951 at kernel/bpf/core.c:851 bpf_jit_free+0x157/0x1b0
> > > Kernel panic - not syncing: panic_on_warn set ...
> > > CPU: 0 PID: 8951 Comm: kworker/0:0 Not tainted 5.2.0-rc3+ #23
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > Workqueue: events bpf_prog_free_deferred
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> > >  panic+0x2cb/0x744 kernel/panic.c:219
> > >  __warn.cold+0x20/0x4d kernel/panic.c:576
> > >  report_bug+0x263/0x2b0 lib/bug.c:186
> > >  fixup_bug arch/x86/kernel/traps.c:179 [inline]
> > >  fixup_bug arch/x86/kernel/traps.c:174 [inline]
> > >  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
> > >  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
> > >  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
> > > RIP: 0010:bpf_jit_free+0x157/0x1b0
> > > Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5d 48 b8 00 02 00 00
> > > 00 00 ad de 48 39 43 70 0f 84 05 ff ff ff e8 f9 b5 f4 ff <0f> 0b e9 f9 fe ff
> > > ff e8 bd 53 2d 00 e9 d9 fe ff ff 48 89 7d e0 e8
> > > RSP: 0018:ffff88808886fcb0 EFLAGS: 00010293
> > > RAX: ffff88808cb6c480 RBX: ffff88809051d280 RCX: ffffffff817ae68d
> > > RDX: 00000000> >
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20190611080431.GP21222%40phenom.ffwll.local.
> > For more options, visit https://groups.google.com/d/optout.00000000 RSI: ffffffff817bf0f7 RDI: ffff88809051d2f0
> > > RBP: ffff88808886fcd0 R08: 1ffffffff14ccaa8 R09: fffffbfff14ccaa9
> > > R10: fffffbfff14ccaa8 R11: ffffffff8a665547 R12: ffffc90001925000
> > > R13: ffff88809051d2e8 R14: ffff8880a0e43900 R15: ffff8880ae834840
> > >  bpf_prog_free_deferred+0x27a/0x350 kernel/bpf/core.c:1984
> > >  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
> > >  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
> > >  kthread+0x354/0x420 kernel/kthread.c:255
> > >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > > Kernel Offset: disabled
> > > Rebooting in 86400 seconds..

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
