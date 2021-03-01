Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2872C32926B
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243489AbhCAUpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240317AbhCAUkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 15:40:36 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD47C061756;
        Mon,  1 Mar 2021 12:39:55 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id i14so357829pjz.4;
        Mon, 01 Mar 2021 12:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9aJvPPQuZOpMY5U+SSFHkmCbcWziEboEri+b50pt18s=;
        b=Foc7dKiKq0pS9eOW40ho/yQRRK//jiZs/Zh6NRRVj1pvIYOj8bmLL2yFr9XRD11k/w
         ynM76PCezUSFZcZRyygKqLDO48Jbf9wzyXXAx4jUt1KRtrGS576qa2yqHmPgaoqVkI3+
         ca+u8Qd44VnDsUfuvi4b/gwHM8gwUqvfoHOc5uaQ5wk0zTNyCP805Dd+jY7DkdwmBIWl
         s0R3vuvkmrThI7iamIMiyS36grnNkE3RGzyE+qQTvJZjI04Kq/RWFZz6t6zq4qPTNtAR
         CoSFwVNAyshx/kNHhgbyLRvmX51I0a5ZGHYlmm8w1tiOBjZazpoW1fKftzw1bVc3uNoG
         TcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9aJvPPQuZOpMY5U+SSFHkmCbcWziEboEri+b50pt18s=;
        b=gxoMH/rNFnjT8raqIkwkr4sz5foCgPq5FJK5cbOCtTxp0qyc/ivWG+kuZ+vR4k6Fpx
         9d+Pl1mUUe+tpzAvo/Fe5LLi7MmsTzn/rG57npfPVxHxABCrTR15GaXZlPUp3TclDWNL
         N/ymLg1MLzu5JF3P6KtLbpT6szOmsdp1P46yivJlURk0Boo2E2pZhp/SpWsVrV0b09q8
         RM4acHec1pyKFZdQIsDRHKB95yRtaGPUtfA1uC6Ya2sxTYA8e2jJhg7IwTrLbBSqNl5G
         5MVN6W9pBDxCFTuhPuRzkiJSvPUopmxsFZct/f04diMyjny3QMQ2fUunVMAz7WKW36Fn
         q6AQ==
X-Gm-Message-State: AOAM532keWUE6hQNuhJOBC1nSM9CyfSCSGFi/q+WvTebAeYe5Hp9LDxE
        hH3pCD92/jox/rmE84jHFCc=
X-Google-Smtp-Source: ABdhPJy6VTT22G1FZFpqiWsBWNAjOQuuznlkE485OR/K6UjR7pxFhmQwQzh1JrQqX5AHxlgsqn1zsA==
X-Received: by 2002:a17:90a:d48b:: with SMTP id s11mr696019pju.67.1614631195101;
        Mon, 01 Mar 2021 12:39:55 -0800 (PST)
Received: from nuc10 (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id v123sm18661794pfc.63.2021.03.01.12.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 12:39:54 -0800 (PST)
Date:   Mon, 1 Mar 2021 12:39:47 -0800
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+f3694595248708227d35@syzkaller.appspotmail.com>,
        andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: memory leak in bpf
Message-ID: <YD1RE3O4FBkKK32l@nuc10>
References: <000000000000911d3905b459824c@google.com>
 <000000000000e56a2605b616b2d9@google.com>
 <YD0UjWjQmYgY4Qgh@nuc10>
 <CACT4Y+YQzTkk=UPNH5g96e+yPYyaPBemmhqXz5oaWEvW9xb-rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YQzTkk=UPNH5g96e+yPYyaPBemmhqXz5oaWEvW9xb-rQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 08:05:42PM +0100, Dmitry Vyukov wrote:
> On Mon, Mar 1, 2021 at 5:21 PM Rustam Kovhaev <rkovhaev@gmail.com> wrote:
> >
> > On Wed, Dec 09, 2020 at 10:58:10PM -0800, syzbot wrote:
> > > syzbot has found a reproducer for the following issue on:
> > >
> > > HEAD commit:    a68a0262 mm/madvise: remove racy mm ownership check
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=11facf17500000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=4305fa9ea70c7a9f
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=f3694595248708227d35
> > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159a9613500000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bf7123500000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+f3694595248708227d35@syzkaller.appspotmail.com
> > >
> > > Debian GNU/Linux 9 syzkaller ttyS0
> > > Warning: Permanently added '10.128.0.9' (ECDSA) to the list of known hosts.
> > > executing program
> > > executing program
> > > executing program
> > > BUG: memory leak
> > > unreferenced object 0xffff88810efccc80 (size 64):
> > >   comm "syz-executor334", pid 8460, jiffies 4294945724 (age 13.850s)
> > >   hex dump (first 32 bytes):
> > >     c0 cb 14 04 00 ea ff ff c0 c2 11 04 00 ea ff ff  ................
> > >     c0 56 3f 04 00 ea ff ff 40 18 38 04 00 ea ff ff  .V?.....@.8.....
> > >   backtrace:
> > >     [<0000000036ae98a7>] kmalloc_node include/linux/slab.h:575 [inline]
> > >     [<0000000036ae98a7>] bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:94 [inline]
> > >     [<0000000036ae98a7>] bpf_ringbuf_alloc kernel/bpf/ringbuf.c:135 [inline]
> > >     [<0000000036ae98a7>] ringbuf_map_alloc kernel/bpf/ringbuf.c:183 [inline]
> > >     [<0000000036ae98a7>] ringbuf_map_alloc+0x1be/0x410 kernel/bpf/ringbuf.c:150
> > >     [<00000000d2cb93ae>] find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
> > >     [<00000000d2cb93ae>] map_create kernel/bpf/syscall.c:825 [inline]
> > >     [<00000000d2cb93ae>] __do_sys_bpf+0x7d0/0x30a0 kernel/bpf/syscall.c:4381
> > >     [<000000008feaf393>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> > >     [<00000000e1f53cfd>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > >
> >
> > i am pretty sure that this one is a false positive
> > the problem with reproducer is that it does not terminate all of the
> > child processes that it spawns
> >
> > i confirmed that it is a false positive by tracing __fput() and
> > bpf_map_release(), i ran reproducer, got kmemleak report, then i
> > manually killed those running leftover processes from reproducer and
> > then both functions were executed and memory was freed
> >
> > i am marking this one as:
> > #syz invalid
> 
> Hi Rustam,
> 
> Thanks for looking into this.
> 
> I wonder how/where are these objects referenced? If they are not
> leaked and referenced somewhere, KMEMLEAK should not report them as
> leaks.
> So even if this is a false positive for BPF, this is a true positive
> bug and something to fix for KMEMLEAK ;)
> And syzbot will probably re-create this bug report soon as this still
> happens and is not a one-off thing.

hi Dmitry, i haven't thought of it this way, but i guess you are right,
it is a kmemleak bug, ideally kmemleak should be aware that there are
still running processes holding references to bpf fd/anonymous inodes
which in their turn hold references to allocated bpf maps

