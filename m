Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB283C6D8
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 11:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404835AbfFKJBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 05:01:16 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45495 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403860AbfFKJBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 05:01:16 -0400
Received: by mail-ed1-f66.google.com with SMTP id a14so17022564edv.12
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 02:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GgEHcwpFv/NSxB4nhb8sGjpQD1wZwWQuCULhK2h4yOs=;
        b=cDL76hPFo48JwMplskS84bSNvgL97E7I7IHIAV6EnKwW0ST0eyJj45wq/IKb/QFdui
         FRj3NwSHFucvkvROyxH49N4dxfndyy+6oD0eeSiDXHHFCvzG2rFCwjTApsE06XM0wLH1
         8mK7xFxkELVMJ0ejg1B73BDTj2uzBbZ53dDug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=GgEHcwpFv/NSxB4nhb8sGjpQD1wZwWQuCULhK2h4yOs=;
        b=kLvv4nPt7aZjjrg2lodGwM56X3so64m9056cDOU1XAEoqnXBY4AG663p6hh4dfpuDN
         zYqe4qOZejuqHMSBD+iByrjOZPH0zWRCuRaFS05ck5sTUGSzVNm/JXSpqr65VrrTc0b6
         LGJSEh37UsVa8f+ysPFcYa2mkmHmcmPm6q8g+iU8/zhLSqKhpGSiLcScy4bLGXS+XDhz
         Q6eQ20+YduCivlQNfkmpyTCEKgTDpnK4hMCGIbhrsNLihvbL5VE6hNnocSkbwTbEgVAz
         k0M29MHk9ytzk1a5x2VSHyx+Cn08iHI6JSKhIL/BeXPmnLme/pNWS6NwgXLlTVbWN9Jc
         WqKg==
X-Gm-Message-State: APjAAAX4ZgPlqPUwmxEEhAP1Xk5Zh/Ka2CRjKgQ+aCMlbScOP2rYVgWZ
        ++8+WbwTIhU2aIpqoyb7HNiOhQ==
X-Google-Smtp-Source: APXvYqyXcj5UdsqzqojLSWbj0IZz3C5Eifs54JPrPx/Zay91g0pCgveR+6PscizV8JsXUwLUpIqVng==
X-Received: by 2002:a17:907:20db:: with SMTP id qq27mr44209049ejb.30.1560243673593;
        Tue, 11 Jun 2019 02:01:13 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id h26sm206855ejc.71.2019.06.11.02.01.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 02:01:12 -0700 (PDT)
Date:   Tue, 11 Jun 2019 11:01:10 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: WARNING in bpf_jit_free
Message-ID: <20190611090110.GY21222@phenom.ffwll.local>
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
 <20190611085123.GU21222@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611085123.GU21222@phenom.ffwll.local>
X-Operating-System: Linux phenom 4.14.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 10:51:23AM +0200, Daniel Vetter wrote:
> On Tue, Jun 11, 2019 at 10:33:21AM +0200, Dmitry Vyukov wrote:
> > On Tue, Jun 11, 2019 at 10:04 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> > >
> > > On Sat, Jun 08, 2019 at 04:22:06AM -0700, syzbot wrote:
> > > > syzbot has found a reproducer for the following crash on:
> > > >
> > > > HEAD commit:    79c3ba32 Merge tag 'drm-fixes-2019-06-07-1' of git://anong..
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1201b971a00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=2ff1e7cb738fd3c41113
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a3bf51a00000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120d19f2a00000
> > >
> > > Looking at the reproducer I don't see any calls to ioctl which could end
> > > up anywhere in drm.
> > > >
> > > > The bug was bisected to:
> > > >
> > > > commit 0fff724a33917ac581b5825375d0b57affedee76
> > > > Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > > Date:   Fri Jan 18 14:51:13 2019 +0000
> > > >
> > > >     drm/sun4i: backend: Use explicit fourcc helpers for packed YUV422 check
> > >
> > > And most definitely not in drm/sun4i. You can only hit this if you have
> > > sun4i and run on arm, which per your config isn't the case.
> > >
> > > tldr; smells like bisect gone wrong.
> > > -Daniel
> > 
> > From the bisection log it looks like the bug is too hard to trigger
> > for reliable bisection. So it probably classified one bad commit as
> > good. But it should got quite close to the right one.
> 
> Well statistically it'll get close, since there's a fair chance that it's
> one of the later bisect results that got mischaracterized.
> 
> But you can be equally unlucky, and if it's one of the earliers, then it
> can easily be a few thousand commits of. Looking at the log it's mostly
> bad, with a few good sprinkled in, which could just be reproduction
> failures. So might very well be that the very first "good" result is
> wrong. And that very first "good" decision cuts away a big pile of bpf
> related commits. The next "good" decision then only cuts away a pile of
> drm commits, but at that point you're already off the rails most likely.
> 
> I'd say re-test on f90d64483ebd394958841f67f8794ab203b319a7 a few times,
> I'm willing to bet that one is actually bad.

btw if this theory is right, we have a 1-in-4 chance of a spurious "good"
with your test. If you get 10 repeated "good" then that should be good
enough to make playing the lottery a better endeavor :-)
-Daniel


> 
> Cheers, Daniel
> 
> > 
> > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1467550f200000
> > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1667550f200000
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1267550f200000
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > Reported-by: syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com
> > > > Fixes: 0fff724a3391 ("drm/sun4i: backend: Use explicit fourcc helpers for
> > > > packed YUV422 check")
> > > >
> > > > WARNING: CPU: 0 PID: 8951 at kernel/bpf/core.c:851 bpf_jit_free+0x157/0x1b0
> > > > Kernel panic - not syncing: panic_on_warn set ...
> > > > CPU: 0 PID: 8951 Comm: kworker/0:0 Not tainted 5.2.0-rc3+ #23
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > > Google 01/01/2011
> > > > Workqueue: events bpf_prog_free_deferred
> > > > Call Trace:
> > > >  __dump_stack lib/dump_stack.c:77 [inline]
> > > >  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> > > >  panic+0x2cb/0x744 kernel/panic.c:219
> > > >  __warn.cold+0x20/0x4d kernel/panic.c:576
> > > >  report_bug+0x263/0x2b0 lib/bug.c:186
> > > >  fixup_bug arch/x86/kernel/traps.c:179 [inline]
> > > >  fixup_bug arch/x86/kernel/traps.c:174 [inline]
> > > >  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
> > > >  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
> > > >  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
> > > > RIP: 0010:bpf_jit_free+0x157/0x1b0
> > > > Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5d 48 b8 00 02 00 00
> > > > 00 00 ad de 48 39 43 70 0f 84 05 ff ff ff e8 f9 b5 f4 ff <0f> 0b e9 f9 fe ff
> > > > ff e8 bd 53 2d 00 e9 d9 fe ff ff 48 89 7d e0 e8
> > > > RSP: 0018:ffff88808886fcb0 EFLAGS: 00010293
> > > > RAX: ffff88808cb6c480 RBX: ffff88809051d280 RCX: ffffffff817ae68d
> > > > RDX: 00000000> >
> > >
> > > --
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > http://blog.ffwll.ch
> > >
> > > --
> > > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20190611080431.GP21222%40phenom.ffwll.local.
> > > For more options, visit https://groups.google.com/d/optout.00000000 RSI: ffffffff817bf0f7 RDI: ffff88809051d2f0
> > > > RBP: ffff88808886fcd0 R08: 1ffffffff14ccaa8 R09: fffffbfff14ccaa9
> > > > R10: fffffbfff14ccaa8 R11: ffffffff8a665547 R12: ffffc90001925000
> > > > R13: ffff88809051d2e8 R14: ffff8880a0e43900 R15: ffff8880ae834840
> > > >  bpf_prog_free_deferred+0x27a/0x350 kernel/bpf/core.c:1984
> > > >  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
> > > >  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
> > > >  kthread+0x354/0x420 kernel/kthread.c:255
> > > >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > > > Kernel Offset: disabled
> > > > Rebooting in 86400 seconds..
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
