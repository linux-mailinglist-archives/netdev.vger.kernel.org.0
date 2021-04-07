Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B129135750D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 21:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355663AbhDGTk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 15:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbhDGTk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 15:40:29 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CE7C06175F;
        Wed,  7 Apr 2021 12:40:19 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i144so15740ybg.1;
        Wed, 07 Apr 2021 12:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2g5D0xOA3ujEGqGeN4cMLv0+uOERBTSZIDhrkslcITw=;
        b=cQxM9qZSdgS1JRFQoRkDGN4e9JsBmUo2NpuRsj+EdWNnp/FbLns980SvWWQPGS0+Ju
         7RA5Lo/XsW0drcVFMr1MQHNrelcok6T0zA9+vUxgUeP4Z1jiukE3XumGRpu1KRWKC4NM
         lzzQGDy9sYxb5nDgxGLrJRRM/0b4bDSfRyAHL7CmM2Lub5nvw4SuIvDCQQ7G6zKgp5WY
         9WjfSuM7+WEj+wcIZ0zV33Q4Y4OpyW9r22jSlW6Qxh3pmyhVnrZdlWR2b5COg6j2EKJh
         6HgU568zdHsSF3Zz61ssZuKg9nLE0GPO+S61cHSdOBBTRoBBqg/xTNesa8Wrf8+nQ46N
         0sUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2g5D0xOA3ujEGqGeN4cMLv0+uOERBTSZIDhrkslcITw=;
        b=NLPtoqwHMF+uyW3sPBsfAwvfi6lOtVZHsV5XEWeJg58z4OIR6BzHn/871yj8/1D45L
         ONd2aQeED0Os2TQxLNhNmZIOIlZPD3Fb3IHEiu2WM+Fju9HPf+pxMd7b1PUTcW7Gr2SD
         cVXZ8xfHkBIxtGJyQtLYin1JC2itHav+LbtChbVORbizYBW6nR2IauePhSTAmPa01yNI
         xW8cJQ2cTw1xwuw7baBZf2W9uANPUODSc8OMSJM3OATSWb0OFoVgdECXvpVmTr6dW/O5
         u8Pb8WEOoHt7ZEj/ok94BQfMc0bSE9AF1/hXF5jl93qtva+kZ7NQsDcdjAPwjoODYrRR
         cdmQ==
X-Gm-Message-State: AOAM531FWH2ST6DYj+WD1OKuK4E05ujpwn3K1iRkbViYAzydg10IRLA8
        OKyfolXX6HgM8eF1XI25vx5q5LXQdhszYiFggic=
X-Google-Smtp-Source: ABdhPJyS6Ankjq1MROF4o6dv8wdv+2vP43HGx123bOujNFiB3GBQqrLWQih3TcMAa24IMfMgztko6Dfpu9TbtGA9PbA=
X-Received: by 2002:a25:ab03:: with SMTP id u3mr7005745ybi.347.1617824418240;
 Wed, 07 Apr 2021 12:40:18 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c7bbd305bededd29@google.com>
In-Reply-To: <000000000000c7bbd305bededd29@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Apr 2021 12:40:07 -0700
Message-ID: <CAEf4BzYk+dqs+jwu6VKXP-RttcTEGFe+ySTGWT9CRNkagDiJVA@mail.gmail.com>
Subject: Re: [syzbot] memory leak in bpf (2)
To:     syzbot <syzbot+5d895828587f49e7fe9b@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 6:08 PM syzbot
<syzbot+5d895828587f49e7fe9b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0f4498ce Merge tag 'for-5.12/dm-fixes-2' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1250e126d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=49f2683f4e7a4347
> dashboard link: https://syzkaller.appspot.com/bug?extid=5d895828587f49e7fe9b
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a17016d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a32016d00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5d895828587f49e7fe9b@syzkaller.appspotmail.com
>
> Warning: Permanently added '10.128.0.74' (ECDSA) to the list of known hosts.
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff8881133295c0 (size 64):
>   comm "syz-executor529", pid 8395, jiffies 4294943939 (age 8.130s)
>   hex dump (first 32 bytes):
>     40 48 3c 04 00 ea ff ff 00 48 3c 04 00 ea ff ff  @H<......H<.....
>     c0 e7 3c 04 00 ea ff ff 80 e7 3c 04 00 ea ff ff  ..<.......<.....
>   backtrace:
>     [<ffffffff8139511c>] kmalloc_node include/linux/slab.h:577 [inline]
>     [<ffffffff8139511c>] __bpf_map_area_alloc+0xfc/0x120 kernel/bpf/syscall.c:300
>     [<ffffffff813d2414>] bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:90 [inline]
>     [<ffffffff813d2414>] bpf_ringbuf_alloc kernel/bpf/ringbuf.c:131 [inline]
>     [<ffffffff813d2414>] ringbuf_map_alloc kernel/bpf/ringbuf.c:170 [inline]
>     [<ffffffff813d2414>] ringbuf_map_alloc+0x134/0x350 kernel/bpf/ringbuf.c:146
>     [<ffffffff8139c8d3>] find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
>     [<ffffffff8139c8d3>] map_create kernel/bpf/syscall.c:828 [inline]
>     [<ffffffff8139c8d3>] __do_sys_bpf+0x7c3/0x2fe0 kernel/bpf/syscall.c:4375
>     [<ffffffff842df20d>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
>

I think either kmemleak or syzbot are mis-reporting this. I've added a
bunch of printks around all allocations performed by BPF ringbuf. When
I run repro, I see this:

[   26.013500] ALLOC rb_map ffff888118d7d000
[   26.013946] ALLOC KMALLOC AREA ffff88810d538c00
[   26.014439] ALLOC PAGES ffff88810d538c00
[   26.014826] ALLOC PAGE[0] ffffea000419af00
[   26.015272] ALLOC PAGE[1] ffffea000419aec0
[   26.015686] ALLOC PAGE[2] ffffea000419ae80
[   26.016090] ALLOC PAGE[3] ffffea00042e29c0
[   26.016513] ALLOC PAGE[4] ffffea00042a1000
[   26.016928] VMAP rb ffffc90000539000
[   26.017291] ALLOC rb_map->rb ffffc90000539000
[   26.017712] FINISHED ALLOC BPF_MAP ffff888118d7d000
[   32.105069] ALLOC rb_map ffff888118d7d200
[   32.105568] ALLOC KMALLOC AREA ffff88810d538c80
[   32.106005] ALLOC PAGES ffff88810d538c80
[   32.106407] ALLOC PAGE[0] ffffea000419aa80
[   32.106805] ALLOC PAGE[1] ffffea000419ab00
[   32.107206] ALLOC PAGE[2] ffffea000419abc0
[   32.107607] ALLOC PAGE[3] ffffea0004284480
[   32.108003] ALLOC PAGE[4] ffffea0004284440
[   32.108419] VMAP rb ffffc900005ad000
[   32.108765] ALLOC rb_map->rb ffffc900005ad000
[   32.109186] FINISHED ALLOC BPF_MAP ffff888118d7d200
[   33.592874] kmemleak: 1 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)
[   40.526922] kmemleak: 1 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)

On repro side I get these two warnings:

[vmuser@archvm bpf]$ sudo ./repro
BUG: memory leak
unreferenced object 0xffff88810d538c00 (size 64):
  comm "repro", pid 2140, jiffies 4294692933 (age 14.540s)
  hex dump (first 32 bytes):
    00 af 19 04 00 ea ff ff c0 ae 19 04 00 ea ff ff  ................
    80 ae 19 04 00 ea ff ff c0 29 2e 04 00 ea ff ff  .........)......
  backtrace:
    [<0000000077bfbfbd>] __bpf_map_area_alloc+0x31/0xc0
    [<00000000587fa522>] ringbuf_map_alloc.cold.4+0x48/0x218
    [<0000000044d49e96>] __do_sys_bpf+0x359/0x1d90
    [<00000000f601d565>] do_syscall_64+0x2d/0x40
    [<0000000043d3112a>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810d538c80 (size 64):
  comm "repro", pid 2143, jiffies 4294699025 (age 8.448s)
  hex dump (first 32 bytes):
    80 aa 19 04 00 ea ff ff 00 ab 19 04 00 ea ff ff  ................
    c0 ab 19 04 00 ea ff ff 80 44 28 04 00 ea ff ff  .........D(.....
  backtrace:
    [<0000000077bfbfbd>] __bpf_map_area_alloc+0x31/0xc0
    [<00000000587fa522>] ringbuf_map_alloc.cold.4+0x48/0x218
    [<0000000044d49e96>] __do_sys_bpf+0x359/0x1d90
    [<00000000f601d565>] do_syscall_64+0x2d/0x40
    [<0000000043d3112a>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Note that both reported leaks (ffff88810d538c80 and ffff88810d538c00)
correspond to pages array bpf_ringbuf is allocating and tracking
properly internally.

Note also that syzbot repro doesn't close FD of created BPF ringbufs,
and even when ./repro itself exits with error, there are still two
forked processes hanging around in my system. So clearly ringbuf maps
are alive at that point. So reporting any memory leak looks weird at
that point, because that memory is being used by active referenced BPF
ringbuf.

It's also a question why repro doesn't clean up its forks. But if I do
`pkill repro`, I do see that all the allocated memory is properly
cleaned up:


[   84.039790] MAP RELEASE MAP ffff888118d7d000
[   84.039980] MAP RELEASE MAP ffff888118d7d200
[   84.040421] MAP ffff888118d7d000 PUT USERCNT 0
[   84.040849] MAP ffff888118d7d200 PUT USERCNT 0
[   84.040854] MAP ffff888118d7d200 PUT REFCNT 0
[   84.041485] MAP ffff888118d7d000 PUT REFCNT 0
[   84.041513] MAP FREE DEFERRED MAP ffff888118d7d000
[   84.041921] MAP FREE DEFERRED MAP ffff888118d7d200
[   84.042530] VUNMAP rb ffffc90000539000
[   84.043127] VUNMAP rb ffffc900005ad000
[   84.043802] DEALLOC page[0] ffffea000419af00
[   84.044258] DEALLOC page[0] ffffea000419aa80
[   84.044814] DEALLOC page[1] ffffea000419aec0
[   84.045180] DEALLOC page[1] ffffea000419ab00
[   84.045772] DEALLOC page[2] ffffea000419ae80
[   84.046188] DEALLOC page[2] ffffea000419abc0
[   84.046817] DEALLOC page[3] ffffea00042e29c0
[   84.047245] DEALLOC page[3] ffffea0004284480
[   84.047895] DEALLOC page[4] ffffea00042a1000
[   84.048371] DEALLOC page[4] ffffea0004284440
[   84.048373] DEALLOC pages ffff88810d538c80
[   84.048375] DEALLOC rb_map ffff888118d7d200
[   84.052392] DEALLOC pages ffff88810d538c00
[   84.053015] DEALLOC rb_map ffff888118d7d000


Note that "leaks" are deallocated properly:

[   84.048373] DEALLOC pages ffff88810d538c80
[   84.052392] DEALLOC pages ffff88810d538c00


BTW, if I add close() right after bpf() syscall in syzbot repro, I see
that everything is immediately deallocated, like designed. And no
memory leak is reported.

So I don't think the problem is anywhere in bpf_ringbuf code, rather
in the leak detection and/or repro itself. Any suggestions how to
silence or fix these reports?

>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
