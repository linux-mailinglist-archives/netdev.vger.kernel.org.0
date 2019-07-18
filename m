Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1F56D256
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfGRQsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:48:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39673 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRQsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:48:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so14193863pls.6;
        Thu, 18 Jul 2019 09:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=onFQXI0tdtzxB0bAf6ywKEC/3dkZA6cxWViofhvfOoc=;
        b=B4O6mUXnmoB1ks/cLV1Jspx2Kild7YQeRNjRAUoLBttgvDHiMK/pZ28U6KK17HeBxz
         vA1SLMT+K0BRtQcFUO42b7ZUwZ0mhTqDrFXFgMTATV7FcA4wW3CwNaR/SXV4n/gx3xkd
         pu4wBZbNLGTtCxQKH0Ga1LzutKKxFVCKDHQ75NypFtEhKzDGwFe7fWk4+jgcLZzOeIe2
         LY8Z+zkj27VbGaafX/SWtcBtFTW8wUPi0OXm4uwuT20SUXJfQT3f5F7NsyAuFfgU1QFa
         EsiavFAPJBPtsLyMs4k+8nnRbUwdZ17hMrKbytrBMG8CyL6jsi2YMtHbj2RAo5xg6Y3h
         L5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=onFQXI0tdtzxB0bAf6ywKEC/3dkZA6cxWViofhvfOoc=;
        b=OqsPpsUXNNKc3A4JFyUe7kZOJEiJw+1T4B+u9BeUO+MX/S8NCisNMnsTeVfNAXeoSH
         JWNKt8cZ6KrO+M8OY0gbqiX5gbLy11IrujGGdo/h5Y69LRpeJ4rdFulj9Z4iNouUl11s
         yLX6N0IehRIE3FTaXtTWktnZllD+GGbTdlwr1y7e5wkZ01vAIWjISEa1CnSBSp1Do2k9
         rSYuLaw3Lu0huCZeNedWlUfv7gl1oOK+C4NIlyAJZVvp/exx6RhaKy6geenazxkYybZo
         Tc6jA9rNtR7/6G7iGlKheNaWjNOIv54GxXhsSNhR0J+DO4xgnqHDfmVFreD7IHyPxP6p
         XAMw==
X-Gm-Message-State: APjAAAWX5aPmgfTyYDh0qc78FTDZXbKAtvH+KMLpYp0OT0onZq3q7VpS
        81ROnhwRNsw5SxX/XCN8Evq8Qk39FNorhW/dqiz2iuqrfx4=
X-Google-Smtp-Source: APXvYqxCR2KBDFjiX4m4HPfcemgl7VMl9sOXT5k/SDnEPPHbhrjeD7KnhRdeozieNjnYATYW4tGotfkpEVAwp27QG+U=
X-Received: by 2002:a17:902:a50d:: with SMTP id s13mr51585830plq.12.1563468520232;
 Thu, 18 Jul 2019 09:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000035f65d058df39aed@google.com>
In-Reply-To: <00000000000035f65d058df39aed@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 18 Jul 2019 09:48:28 -0700
Message-ID: <CAM_iQpUzYB4VgpDUtQ3AvLrAdQ2pmcRHKJ829oZRxoJ9mJidTA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in nr_insert_socket
To:     syzbot <syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-hams <linux-hams@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 5:18 AM syzbot
<syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    a5b64700 fix: taprio: Change type of txtime-delay paramete..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1588b458600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=87305c3ca9c25c70
> dashboard link: https://syzkaller.appspot.com/bug?extid=9399c158fcc09b21d0d2
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105a61a4600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153ef948600000
>
> The bug was bisected to:
>
> commit c8c8218ec5af5d2598381883acbefbf604e56b5e
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Thu Jun 27 21:30:58 2019 +0000
>
>      netrom: fix a memory leak in nr_rx_frame()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=159ef948600000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=179ef948600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=139ef948600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com
> Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")
>
> ==================================================================
> BUG: KASAN: use-after-free in atomic_read
> /./include/asm-generic/atomic-instrumented.h:26 [inline]
> BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x81/0x200
> /lib/refcount.c:123
> Read of size 4 at addr ffff8880a5d3f380 by task swapper/1/0
>
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.2.0+ #89
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   <IRQ>
>   __dump_stack /lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 /lib/dump_stack.c:113
>   print_address_description.cold+0xd4/0x306 /mm/kasan/report.c:351
>   __kasan_report.cold+0x1b/0x36 /mm/kasan/report.c:482
>   kasan_report+0x12/0x20 /mm/kasan/common.c:612
>   check_memory_region_inline /mm/kasan/generic.c:185 [inline]
>   check_memory_region+0x134/0x1a0 /mm/kasan/generic.c:192
>   __kasan_check_read+0x11/0x20 /mm/kasan/common.c:92
>   atomic_read /./include/asm-generic/atomic-instrumented.h:26 [inline]
>   refcount_inc_not_zero_checked+0x81/0x200 /lib/refcount.c:123
>   refcount_inc_checked+0x17/0x70 /lib/refcount.c:156
>   sock_hold /./include/net/sock.h:649 [inline]
>   sk_add_node /./include/net/sock.h:701 [inline]
>   nr_insert_socket+0x2d/0xe0 /net/netrom/af_netrom.c:137


Looks like nr_insert_socket() doesn't hold a refcnt before inserting
it into a global list.

Let me think about how to fix this.

Thanks.
