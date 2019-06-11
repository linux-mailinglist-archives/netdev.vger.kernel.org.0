Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D5B3C589
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404555AbfFKIEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:04:38 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38134 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404546AbfFKIEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:04:37 -0400
Received: by mail-ed1-f68.google.com with SMTP id g13so18637617edu.5
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 01:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1VpP4BQl0scWmMIfvVrIwxl9EaLNPQUpAZnq/R1E08A=;
        b=ZIa8H2Jy5lWKWQz1TT7B/cBLsAJV/t0RUOsjzlAUmvjxv48OR/2G2Z3xwj89VqyCSC
         Y7NCdLF+j+Zb7j9MlTsh2N8qAd9mQSkTkGybODE0RYNXFT6BGqim8aTZFx8ccV9Ema2X
         VHizYVWLs+TJqJRySt+NsoMrmPz7kLRDwVbHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=1VpP4BQl0scWmMIfvVrIwxl9EaLNPQUpAZnq/R1E08A=;
        b=IMqc9WBOHK/ZNpvm6fcSEsfJspeNsIVisjHsIIc9cudVx/bt4AR4BVmSXkTpdtBIAB
         bC0oWS4LGNZ2AUsbv7GQ/cZKLD1NrzdombFFLZeNbycB70PexGOJHyjDKRcPgseZQ5DP
         wzdZDP0E1eqIfRc23NkG7LEKNCn624QrBpfoXn+gZC2GPu2hlB5wHsuPShfjbPNuzgny
         qZpiwwQPhnCyhAc3wNNJesB8Aj9FET/ZIH7gWb1L5BO2ncDJxgZUHdRjXLUOYKCqaQiu
         bQvbj/858zyxD7ZVJnWaUX+uwZeYpg6h2L/qcZ7J2t2VN7gX1qczxZSHLBQlng5o1e/d
         KlqA==
X-Gm-Message-State: APjAAAVMduYbyQ3AmKZ5GiguJlmvFt6ns8j+hnmdafqzL3108ecxtuEl
        mTnGYuC6GuFSWW68e4RwdCXZI+vNI1E=
X-Google-Smtp-Source: APXvYqxTt4reyZxOwFM7gpLn44B2/syN7stLMXz/LTQgDQdiH76jkBmOlBKjhtvaB3E/mb8+p5bIJQ==
X-Received: by 2002:a17:906:ad86:: with SMTP id la6mr44226340ejb.43.1560240275503;
        Tue, 11 Jun 2019 01:04:35 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id y11sm3576596edj.96.2019.06.11.01.04.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 01:04:34 -0700 (PDT)
Date:   Tue, 11 Jun 2019 10:04:31 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     syzbot <syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com>
Cc:     airlied@linux.ie, ast@kernel.org, bpf@vger.kernel.org,
        daniel@ffwll.ch, daniel@iogearbox.net, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maxime.ripard@bootlin.com,
        netdev@vger.kernel.org, paul.kocialkowski@bootlin.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        wens@csie.org, xdp-newbies@vger.kernel.org, yhs@fb.com
Subject: Re: WARNING in bpf_jit_free
Message-ID: <20190611080431.GP21222@phenom.ffwll.local>
Mail-Followup-To: syzbot <syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com>,
        airlied@linux.ie, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maxime.ripard@bootlin.com,
        netdev@vger.kernel.org, paul.kocialkowski@bootlin.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        wens@csie.org, xdp-newbies@vger.kernel.org, yhs@fb.com
References: <000000000000e92d1805711f5552@google.com>
 <000000000000381684058ace28e5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000381684058ace28e5@google.com>
X-Operating-System: Linux phenom 4.14.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 04:22:06AM -0700, syzbot wrote:
> syzbot has found a reproducer for the following crash on:
> 
> HEAD commit:    79c3ba32 Merge tag 'drm-fixes-2019-06-07-1' of git://anong..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1201b971a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
> dashboard link: https://syzkaller.appspot.com/bug?extid=2ff1e7cb738fd3c41113
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a3bf51a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120d19f2a00000

Looking at the reproducer I don't see any calls to ioctl which could end
up anywhere in drm.
> 
> The bug was bisected to:
> 
> commit 0fff724a33917ac581b5825375d0b57affedee76
> Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Date:   Fri Jan 18 14:51:13 2019 +0000
> 
>     drm/sun4i: backend: Use explicit fourcc helpers for packed YUV422 check

And most definitely not in drm/sun4i. You can only hit this if you have
sun4i and run on arm, which per your config isn't the case.

tldr; smells like bisect gone wrong.
-Daniel

> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1467550f200000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1667550f200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1267550f200000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com
> Fixes: 0fff724a3391 ("drm/sun4i: backend: Use explicit fourcc helpers for
> packed YUV422 check")
> 
> WARNING: CPU: 0 PID: 8951 at kernel/bpf/core.c:851 bpf_jit_free+0x157/0x1b0
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 8951 Comm: kworker/0:0 Not tainted 5.2.0-rc3+ #23
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: events bpf_prog_free_deferred
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  panic+0x2cb/0x744 kernel/panic.c:219
>  __warn.cold+0x20/0x4d kernel/panic.c:576
>  report_bug+0x263/0x2b0 lib/bug.c:186
>  fixup_bug arch/x86/kernel/traps.c:179 [inline]
>  fixup_bug arch/x86/kernel/traps.c:174 [inline]
>  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
>  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
>  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
> RIP: 0010:bpf_jit_free+0x157/0x1b0
> Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5d 48 b8 00 02 00 00
> 00 00 ad de 48 39 43 70 0f 84 05 ff ff ff e8 f9 b5 f4 ff <0f> 0b e9 f9 fe ff
> ff e8 bd 53 2d 00 e9 d9 fe ff ff 48 89 7d e0 e8
> RSP: 0018:ffff88808886fcb0 EFLAGS: 00010293
> RAX: ffff88808cb6c480 RBX: ffff88809051d280 RCX: ffffffff817ae68d
> RDX: 0000000000000000 RSI: ffffffff817bf0f7 RDI: ffff88809051d2f0
> RBP: ffff88808886fcd0 R08: 1ffffffff14ccaa8 R09: fffffbfff14ccaa9
> R10: fffffbfff14ccaa8 R11: ffffffff8a665547 R12: ffffc90001925000
> R13: ffff88809051d2e8 R14: ffff8880a0e43900 R15: ffff8880ae834840
>  bpf_prog_free_deferred+0x27a/0x350 kernel/bpf/core.c:1984
>  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
>  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
>  kthread+0x354/0x420 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
