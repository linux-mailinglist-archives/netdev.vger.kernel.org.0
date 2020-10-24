Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC3E297D5E
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 18:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762179AbgJXQXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 12:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761417AbgJXQXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 12:23:07 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25604C0613CE;
        Sat, 24 Oct 2020 09:23:07 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j5so2597086plk.7;
        Sat, 24 Oct 2020 09:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K3qnupm0fkGef24gFy6Jm7JNRaxoKrZngc8mAx+HRV0=;
        b=qo65wXCYdejGx/sdVW+LTh3iYXOg3EK7FfDCoMt0Ca44KDAWLJ2SK3fX86RE8QHRic
         rfoxYdKWcwZOPli10V0VG6SwzAVzazwmJypZlFzRr4u3fBdE8n2h4svWnqRZzDkiF6L+
         26sWD0zHqh6pirToK4xjEkhYVmoclVXYzj30gRmE234TBisUuMigv3VxMXDe/EBTXSrA
         hp6SXc/e3fV9PWy1nG92TDtW+xH1notnqk+81CccS7OG2x0LSy2Cem5msARvMGQjAvld
         G4QqRQsAo62qRQwQQloHodsajNHuQatZmGNTOl7O6qUGAcAS0KfuB9KPUJg6yOZvyKnf
         YqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K3qnupm0fkGef24gFy6Jm7JNRaxoKrZngc8mAx+HRV0=;
        b=mEHpJQB/YPj9Iil1i8u+UVRMUa6K0l0VRuzXgjF0wvFwP/hrOibfuXyhzqK+KBHviR
         7VGrmFhsYBfbJwmJpcXXwOtQ+kV9JJ8s+kvvkfHG6ijr85YjKxB2Rqbw1Q7CQ8d2PmlY
         KDWMw4iyUeYVsXTOwgVmfBZDTDHarnvfDR1wxwQ4rjNEu3V3wp9EHWV1aM61dalhjG2O
         8kS9/wmXFwBDooDEhhv8AJYM5DdDQcpYWUhLwa+bjYo04vBbtBya7nRD8vE3TnyC+KrT
         a6EH1OxC6mIbRI7VT341xoCdL6RvEXKc+LYvx9r9AJfeQwIN/xvswVfjzZRo4cmOxvom
         EtUg==
X-Gm-Message-State: AOAM532rw9DQFrsqPQTkX5Jvl/OgnLJ1T/5N7yqaxfAXo7GCZuzwpLoI
        774S3CqmDAlbvqQ2ufzDerRBid/dLlgFHVpxvkY=
X-Google-Smtp-Source: ABdhPJxGWFDPGO1nbktZNanE1cDwknBbIRm80DHes+JRDRygoFunA9RoqKMTwemCu9nkMgblYByVxMxaLembWDC2cho=
X-Received: by 2002:a17:90a:d80e:: with SMTP id a14mr9590759pjv.168.1603556586725;
 Sat, 24 Oct 2020 09:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006bb5d505b2575d29@google.com>
In-Reply-To: <0000000000006bb5d505b2575d29@google.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Sat, 24 Oct 2020 18:22:55 +0200
Message-ID: <CAJ8uoz2Nctogipe=q+rqxYJ5aoo1vTkpY4vp7q=xD7bOVmQ_5g@mail.gmail.com>
Subject: Re: memory leak in xdp_umem_create
To:     syzbot <syzbot+eb71df123dc2be2c1456@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@chromium.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 6:24 PM syzbot
<syzbot+eb71df123dc2be2c1456@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    f804b315 Merge tag 'linux-watchdog-5.10-rc1' of git://www...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1797677f900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=504c0405f28172a
> dashboard link: https://syzkaller.appspot.com/bug?extid=eb71df123dc2be2c1456
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f27544500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fc4de8500000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+eb71df123dc2be2c1456@syzkaller.appspotmail.com
>
> Warning: Permanently added '10.128.10.22' (ECDSA) to the list of known hosts.
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff888110c1e400 (size 96):
>   comm "syz-executor230", pid 8462, jiffies 4294942469 (age 13.280s)
>   hex dump (first 32 bytes):
>     00 50 e0 00 00 c9 ff ff 00 00 02 00 00 00 00 00  .P..............
>     00 00 00 00 00 10 00 00 20 00 00 00 20 00 00 00  ........ ... ...
>   backtrace:
>     [<00000000c4608c2b>] kmalloc include/linux/slab.h:554 [inline]
>     [<00000000c4608c2b>] kzalloc include/linux/slab.h:666 [inline]
>     [<00000000c4608c2b>] xdp_umem_create+0x33/0x630 net/xdp/xdp_umem.c:229
>     [<00000000551a05ed>] xsk_setsockopt+0x4ad/0x590 net/xdp/xsk.c:852
>     [<00000000f143ff32>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2132
>     [<0000000076c65982>] __do_sys_setsockopt net/socket.c:2143 [inline]
>     [<0000000076c65982>] __se_sys_setsockopt net/socket.c:2140 [inline]
>     [<0000000076c65982>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2140
>     [<00000000d47a7174>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<00000000fb8e5852>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff88810e018f00 (size 256):
>   comm "syz-executor230", pid 8462, jiffies 4294942469 (age 13.280s)
>   hex dump (first 32 bytes):
>     00 00 4f 04 00 ea ff ff 40 00 4f 04 00 ea ff ff  ..O.....@.O.....
>     80 00 4f 04 00 ea ff ff c0 00 4f 04 00 ea ff ff  ..O.......O.....
>   backtrace:
>     [<00000000257d0c74>] kmalloc_array include/linux/slab.h:594 [inline]
>     [<00000000257d0c74>] kcalloc include/linux/slab.h:605 [inline]
>     [<00000000257d0c74>] xdp_umem_pin_pages net/xdp/xdp_umem.c:89 [inline]
>     [<00000000257d0c74>] xdp_umem_reg net/xdp/xdp_umem.c:207 [inline]
>     [<00000000257d0c74>] xdp_umem_create+0x3cc/0x630 net/xdp/xdp_umem.c:240
>     [<00000000551a05ed>] xsk_setsockopt+0x4ad/0x590 net/xdp/xsk.c:852
>     [<00000000f143ff32>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2132
>     [<0000000076c65982>] __do_sys_setsockopt net/socket.c:2143 [inline]
>     [<0000000076c65982>] __se_sys_setsockopt net/socket.c:2140 [inline]
>     [<0000000076c65982>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2140
>     [<00000000d47a7174>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<00000000fb8e5852>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
>
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

Thank you Mr Syzbot! I will take a look at this.
