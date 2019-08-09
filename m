Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069F987429
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405931AbfHIId0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:33:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37092 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfHIId0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:33:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id b3so5053275wro.4;
        Fri, 09 Aug 2019 01:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRsFWJCGEg81aEIDlBzmTAhEZn5T+q9bOuC2TQ0ccOc=;
        b=vhprXY5oe3sC3J0Yg4nK27TJkzyVahLpZSzOQtoVrUl7MijMNYfln7lCwsZBdGAHoL
         QVTUz651AN9ouubzBead0CyeDvVZzqzo8sEhzQMbV9UE4mcdQ37GkEknm6s0DdtRwvyQ
         VP3iyYsX4Yisr8VdajI0/EOyyTZUWOlBP0rfPkbJ4AymqpxlDEzV1dkPb1FzDBOOKycp
         vdgREuUnbcIeXi2vHRcttpPYrI0ZDwx6BcvHvuNhBSBklQ5luv0ZDpOI2DgTOPigumcK
         p+v8pFcr+DS3TFtAbwFnUvqBq1i8Y+KAJmKXed9ipE3GxlgedUcLumHYxSWsh2ARRVC+
         156A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRsFWJCGEg81aEIDlBzmTAhEZn5T+q9bOuC2TQ0ccOc=;
        b=iy5a2tv3WSHEztvqor1n/CgnE4RKdYfCp5nLStO0EstYI2uKv59WNTRsYlZEX0zPv2
         PmklHDXfwg8L5zb6Xc67Q0H1zq8Inhw0KoXh62+4xyMUTRkEX6gTZDe5Ba6DxDPHotK+
         NVd1mz3bG0aMwfFZjw7uP64G6YlzmSxvSVfwzTCsmwOarCR385245mGcn4KDNiHBR2rD
         I5GSdRaJtNjsx5Ikq/IBGGLXY4VIrgD2qXlpP8jBXTj/bO7c3cK8mcHqH/ZYJcmyH8lX
         UKb/GyzXZ0gTCKGM/woMYpj7i4wv99EBaEi2p8HHIkGoGxvf12Mp9xBeTIVIMBCAmPeA
         nzIw==
X-Gm-Message-State: APjAAAWBnTEgbap0zyBKBZaYAwian24MeY6uACJmBJBih+WXr8bwxdi2
        uMdmze4/jFfOhcqF40J1ePSDTtO4AhpP49tBpkEbh6WIws0=
X-Google-Smtp-Source: APXvYqxTnFm0PrXhSF/1W7K+W/Sofn9fBna7h+3iKBXURFL0sqXTaaElMBoHX0mQnCdGmD58vNgzbo+u2HuqmJiXlTY=
X-Received: by 2002:a5d:490a:: with SMTP id x10mr18443111wrq.152.1565339602619;
 Fri, 09 Aug 2019 01:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f93dd2058f9c4873@google.com>
In-Reply-To: <000000000000f93dd2058f9c4873@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 9 Aug 2019 16:33:11 +0800
Message-ID: <CADvbK_dqTGZKWNmapcbyYVfLjuwzjSaqs0PHv687AjAvtPo3Zw@mail.gmail.com>
Subject: Re: memory leak in sctp_get_port_local (2)
To:     syzbot <syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 11:01 PM syzbot
<syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    0eb0ce0a Merge tag 'spi-fix-v5.3-rc3' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1234588c600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=39113f5c48aea971
> dashboard link: https://syzkaller.appspot.com/bug?extid=2d7ecdf99f15689032b3
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160e1906600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140ab906600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com
>
> executing program
> executing program
> executing program
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff88810fa4b380 (size 64):
>    comm "syz-executor900", pid 7117, jiffies 4294946947 (age 16.560s)
>    hex dump (first 32 bytes):
>      20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
>      58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
>    backtrace:
>      [<00000000f1461735>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>      [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
>      [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
>      [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>      [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
>      [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0
> net/sctp/socket.c:8121
>      [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
>      [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
>      [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
>      [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
>      [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
>      [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
>      [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
>      [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:296
>      [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff88810fa4b380 (size 64):
>    comm "syz-executor900", pid 7117, jiffies 4294946947 (age 19.260s)
>    hex dump (first 32 bytes):
>      20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
>      58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
>    backtrace:
>      [<00000000f1461735>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>      [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
>      [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
>      [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>      [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
>      [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0
> net/sctp/socket.c:8121
>      [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
>      [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
>      [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
>      [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
>      [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
>      [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
>      [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
>      [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:296
>      [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff88810fa4b380 (size 64):
>    comm "syz-executor900", pid 7117, jiffies 4294946947 (age 21.990s)
>    hex dump (first 32 bytes):
>      20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
>      58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
>    backtrace:
>      [<00000000f1461735>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>      [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
>      [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
>      [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>      [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
>      [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0
> net/sctp/socket.c:8121
>      [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
>      [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
>      [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
>      [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
>      [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
>      [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
>      [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
>      [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:296
>      [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff88810fa4b380 (size 64):
>    comm "syz-executor900", pid 7117, jiffies 4294946947 (age 22.940s)
>    hex dump (first 32 bytes):
>      20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
>      58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
>    backtrace:
>      [<00000000f1461735>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>      [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
>      [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
>      [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>      [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
>      [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0
> net/sctp/socket.c:8121
>      [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
>      [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
>      [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
>      [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
>      [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
>      [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
>      [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
>      [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:296
>      [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> executing program
> executing program
> executing program
> executing program
should be fixed by:
commit 9b6c08878e23adb7cc84bdca94d8a944b03f099e
Author: Xin Long <lucien.xin@gmail.com>
Date:   Wed Jun 26 16:31:39 2019 +0800

    sctp: not bind the socket in sctp_connect

was this commit included in the testing kernel?

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
