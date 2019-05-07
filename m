Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E837616D9D
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 00:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEGWsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 18:48:33 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37442 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGWsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 18:48:32 -0400
Received: by mail-qk1-f194.google.com with SMTP id c1so1976055qkk.4
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 15:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xxk1I9iNW8G6154lt9spaBJJd7VgHW36j4K0WHRcyow=;
        b=l69sznhGwxe1nQgn6oxo52fenPGAnolimIs47b9+djCmMsyaO5sSy7wxLA1EkAK2D9
         Ogwc8X6C/P5xKukKPWVeM+ojSJvK0ZPxyWjevAizgd9m/bOLgEMnBbUOgJKTXD0TrOI6
         jyKSLHIqhXmIwaKh2Qd9U5RuuuzcDG6LdXQaKcugEjpT2ttzlYrNCcu1GZYRilZU0nwz
         ToI3exO4jnbQTK74obnVqFjqQlBKJBuolE9ZGG8vdYlb9DyS+GaCTtn671TxyxBKBto+
         8ZkbJMwPJ7dFLYiuAqHpR0o2ZMsVDKhA8PfqIY1x5ceXgzcgSovzWZL0Jr2xhvC3nyu+
         387w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xxk1I9iNW8G6154lt9spaBJJd7VgHW36j4K0WHRcyow=;
        b=jQzXlYkX8PPCZiwSHURi3GThB4Wy+IN9wvM5XzBdZfU24vru3I+ov2WGKtY/aRzg0w
         QM6qKfT3GHI9LnagwJSekgNkG+vAs85BbUAv8vJqqV2w/+x9XKDv9M7nbyBeuUerNDdx
         T8jhhcWSi3mAYJlGLj6Coag1cyRFQLI0sKUkN23D05GfoluFtyPl4roIUrnYhd32bn7g
         xP891G9fRne9MNK4gY0UPUNFNRMrDl+2Rt1kBng79lvbOCgE//Iy2pSuMxn2w2GJ3DLB
         Lf3aeGziMkmp+Msz9U1EuyAu5N+tErnAcZHOcjfhWCsbSAMpkHt8KqJejH66UN63x3WK
         4w0g==
X-Gm-Message-State: APjAAAWEMryyMCTQyHDHY7nJ/A0zojn65zAMRCpBIYntgnfuBTTln+al
        hka8sL/El4dv4wAXEXzHVGZU0Q==
X-Google-Smtp-Source: APXvYqy9K+QwTsgkQpI2AW+V0xRPiKAtUOLm3ktla5vxOmCdm5ertpiO/mGcasVbRdz8N8oPmbAstA==
X-Received: by 2002:a37:b404:: with SMTP id d4mr4847748qkf.111.1557269311293;
        Tue, 07 May 2019 15:48:31 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s1sm8793121qkm.93.2019.05.07.15.48.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 07 May 2019 15:48:31 -0700 (PDT)
Date:   Tue, 7 May 2019 15:48:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+13d91ed9bbcd7dc13230@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, doronrk@fb.com,
        kafai@fb.com, kjlu@umn.edu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, vakul.garg@nxp.com, yhs@fb.com,
        yuehaibing@huawei.com, John Fastabend <john.fastabend@gmail.com>
Subject: Re: WARNING: ODEBUG bug in del_timer (3)
Message-ID: <20190507154821.1b04f4aa@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <000000000000dace5e0588529558@google.com>
References: <000000000000dace5e0588529558@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CCing John, looks like John's upcoming fix may address this:

bpf: sockmap, only stop/flush strp if it was enabled at some point

On Tue, 07 May 2019 14:06:06 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    71ae5fc8 Merge tag 'linux-kselftest-5.2-rc1' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=136c06f0a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=511168bc7720867
> dashboard link: https://syzkaller.appspot.com/bug?extid=13d91ed9bbcd7dc13230
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17128012a00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+13d91ed9bbcd7dc13230@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> ODEBUG: assert_init not available (active state 0) object type: timer_list  
> hint:           (null)
> WARNING: CPU: 1 PID: 22 at lib/debugobjects.c:325  
> debug_print_object+0x16a/0x250 lib/debugobjects.c:325
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 22 Comm: kworker/1:1 Not tainted 5.1.0+ #1
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011
> Workqueue: events sk_psock_destroy_deferred
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>   panic+0x2cb/0x65c kernel/panic.c:214
>   __warn.cold+0x20/0x45 kernel/panic.c:566
>   report_bug+0x263/0x2b0 lib/bug.c:186
>   fixup_bug arch/x86/kernel/traps.c:179 [inline]
>   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
>   do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
>   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:972
> RIP: 0010:debug_print_object+0x16a/0x250 lib/debugobjects.c:325
> Code: dd 60 f4 a1 87 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48  
> 8b 14 dd 60 f4 a1 87 48 c7 c7 00 ea a1 87 e8 44 02 12 fe <0f> 0b 83 05 31  
> 10 2d 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
> RSP: 0018:ffff8880a9a3f970 EFLAGS: 00010086
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815aec76 RDI: ffffed1015347f20
> RBP: ffff8880a9a3f9b0 R08: ffff8880a9a2a5c0 R09: ffffed1015d240f1
> R10: ffffed1015d240f0 R11: ffff8880ae920787 R12: 0000000000000001
> R13: ffffffff889ac720 R14: ffffffff81605b60 R15: ffff8880990fdba8
>   debug_object_assert_init lib/debugobjects.c:694 [inline]
>   debug_object_assert_init+0x23d/0x2f0 lib/debugobjects.c:665
>   debug_timer_assert_init kernel/time/timer.c:725 [inline]
>   debug_assert_init kernel/time/timer.c:770 [inline]
>   del_timer+0x7c/0x120 kernel/time/timer.c:1192
>   try_to_grab_pending+0x2d7/0x710 kernel/workqueue.c:1249
>   __cancel_work_timer+0xc4/0x520 kernel/workqueue.c:3079
>   cancel_delayed_work_sync+0x1b/0x20 kernel/workqueue.c:3252
>   strp_done+0x5d/0xf0 net/strparser/strparser.c:526
>   sk_psock_destroy_deferred+0x3a/0x6c0 net/core/skmsg.c:558
>   process_one_work+0x98e/0x1790 kernel/workqueue.c:2263
>   worker_thread+0x98/0xe40 kernel/workqueue.c:2409
>   kthread+0x357/0x430 kernel/kthread.c:253
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

