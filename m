Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D033CCF3
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 15:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390986AbfFKN2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 09:28:42 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:55017 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbfFKN2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 09:28:39 -0400
Received: by mail-it1-f194.google.com with SMTP id m138so4865750ita.4
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 06:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=StBa2k+etv+yvC2hGS7t8gT8g83jR2U1gV0NJrb3dU4=;
        b=aCngYCT5L3a5Yjl7hu4dwEPNfuMl/AcJvX/pc8Y+U5k9EXPW0zcPincay+tcutm2Qr
         mKst9z4KTyuAu9YcO9UWjOy6HAihkn84cM5sTgw1oDRS/XNO6c2+l06sO03muuvT0tN7
         whNEY14ieDHWAf78arnKntl6QUoA/wvSufv9IJ54NYsL5dry6ccfdDyd5ngn8HCq6X2m
         9qksq/+geoM69U6LUgSy7QFox8gKdb7uWEml6lH5m1gRuV3dK3w6FPhkFubTm1Fwr0Uq
         MPomI1vNhY2yuyQhrUPGHT7AeD/IRkb/aK0Vz4aS/2ciIG3z0d6cy8oG2mOULQ8jVASO
         XQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=StBa2k+etv+yvC2hGS7t8gT8g83jR2U1gV0NJrb3dU4=;
        b=bM/SsGF+gDUTtYkxjhEdCPeCv/ebwJJQwkyAoR/Osn7TnroWg99HPfGgLt8xVxw7xU
         wm4TtPwZHafFppfQJ73gf6LMaG1BdVJcjfU0K6RwbtP+79Q6/9ddBCj6b9IRivB1IHcM
         c2U2W7uphE8TNetkqdzkEqVGbrAZVou6JUoL0UECjWzmzXsBljomMoCSBiKQdOz3KvVS
         V0KoeYbRuI8Ip+u1g5rg+ttrQ1U7N/T5Cikxg8yDSqmiLECg2RBFARi+rsfU4pYqcOx8
         CJWFvQ5l13WDYjNFTeFS3t/XTJ67F0CU7NwxWXRlbGwH1N2/pwYLNFYeAeCOxKeJaE2j
         vQyw==
X-Gm-Message-State: APjAAAUpohsV4dD7qXKAP8RUyX0LCtLJSQdLHRKrX6VCtVG4jv3jqcCg
        kmQBvCEdPvDfgBqYrcv/9NxmiolJbnKdsZ3dpFPouA==
X-Google-Smtp-Source: APXvYqxkjEvDEtWdUFmVIoicaX4pEEWaZm+wR5T/qhnBObqDkFxv0BUFXesB42L6lVK/owm9xJGYvvmNpELiDC+azBU=
X-Received: by 2002:a02:1384:: with SMTP id 126mr46141904jaz.72.1560259718591;
 Tue, 11 Jun 2019 06:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007ce6f5058b0715ea@google.com> <CAK8P3a1akOXWgAWXM0g_FYSdWUynBDRR2dAwZt8Xg5RiXhMZag@mail.gmail.com>
In-Reply-To: <CAK8P3a1akOXWgAWXM0g_FYSdWUynBDRR2dAwZt8Xg5RiXhMZag@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 11 Jun 2019 15:28:27 +0200
Message-ID: <CACT4Y+Zhqor0pYfqTOPoom+438aC5ut4pXcOfePmNT63N=pjBw@mail.gmail.com>
Subject: Re: KASAN: null-ptr-deref Read in x25_connect
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     syzbot <syzbot+777a2aab6ffd397407b5@syzkaller.appspotmail.com>,
        allison@lohutok.net, Andrew Hendry <andrew.hendry@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x25@vger.kernel.org, ms@dev.tdt.de,
        Networking <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 2:39 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Jun 11, 2019 at 9:18 AM syzbot
> <syzbot+777a2aab6ffd397407b5@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    f4cfcfbd net: dsa: sja1105: Fix link speed not working at ..
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16815cd2a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=4f721a391cd46ea
> > dashboard link: https://syzkaller.appspot.com/bug?extid=777a2aab6ffd397407b5
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+777a2aab6ffd397407b5@syzkaller.appspotmail.com
>
> Not sure why I was on Cc on this (I know nothing about x25),

syzbot uses get_maintainer.pl to find relevant people. This was
attributed to net/x25/af_x25.c file, which looks correct. And then
get_maintainer.pl points to you for this file:

$ scripts/get_maintainer.pl -f net/x25/af_x25.c
Andrew Hendry <andrew.hendry@gmail.com> (odd fixer:X.25 NETWORK LAYER)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING
[GENERAL],commit_signer:7/9=78%)
Eric Dumazet <edumazet@google.com>
(commit_signer:4/9=44%,authored:4/9=44%,added_lines:16/30=53%,removed_lines:10/50=20%)
Martin Schiller <ms@dev.tdt.de>
(commit_signer:2/9=22%,authored:2/9=22%,added_lines:11/30=37%,removed_lines:7/50=14%)
Marc Kleine-Budde <mkl@pengutronix.de> (commit_signer:1/9=11%)
Willem de Bruijn <willemb@google.com> (commit_signer:1/9=11%)
Arnd Bergmann <arnd@arndb.de> (authored:1/9=11%,removed_lines:26/50=52%)
Thomas Gleixner <tglx@linutronix.de> (authored:1/9=11%,removed_lines:6/50=12%)
linux-x25@vger.kernel.org (open list:X.25 NETWORK LAYER)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)




> but I had
> a brief look and found that this is in the error path of x25_connect,
> after "goto out_put_neigh", with x25->neighbour==NULL.
>
> This would indicate that either 'x25' is being freed between the
> "if (!x25->neighbour)" check in that function and the
> x25_neigh_put(x25->neighbour), or that there are two concurrent
> calls to x25_connect, with both failing, so one sets
> x25->neighbour=NULL before the other one checks it.
>
>     Arnd
>
> > ==================================================================
> > BUG: KASAN: null-ptr-deref in atomic_read
> > include/asm-generic/atomic-instrumented.h:26 [inline]
> > BUG: KASAN: null-ptr-deref in refcount_sub_and_test_checked+0x87/0x200
> > lib/refcount.c:182
> > Read of size 4 at addr 00000000000000c8 by task syz-executor.2/16959
> >
> > CPU: 0 PID: 16959 Comm: syz-executor.2 Not tainted 5.2.0-rc2+ #40
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> >   __kasan_report.cold+0x5/0x40 mm/kasan/report.c:321
> >   kasan_report+0x12/0x20 mm/kasan/common.c:614
> >   check_memory_region_inline mm/kasan/generic.c:185 [inline]
> >   check_memory_region+0x123/0x190 mm/kasan/generic.c:191
> >   kasan_check_read+0x11/0x20 mm/kasan/common.c:94
> >   atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
> >   refcount_sub_and_test_checked+0x87/0x200 lib/refcount.c:182
> >   refcount_dec_and_test_checked+0x1b/0x20 lib/refcount.c:220
> >   x25_neigh_put include/net/x25.h:252 [inline]
> >   x25_connect+0x8d8/0xea0 net/x25/af_x25.c:820
> >   __sys_connect+0x264/0x330 net/socket.c:1840
> >   __do_sys_connect net/socket.c:1851 [inline]
> >   __se_sys_connect net/socket.c:1848 [inline]
> >   __x64_sys_connect+0x73/0xb0 net/socket.c:1848
> >   do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x459279
> > Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> > 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> > ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007f09776b4c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
> > RDX: 0000000000000012 RSI: 0000000020000280 RDI: 0000000000000004
> > RBP: 000000000075bfc0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007f09776b56d4
> > R13: 00000000004bf854 R14: 00000000004d0e08 R15: 00000000ffffffff
> > ==================================================================
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CAK8P3a1akOXWgAWXM0g_FYSdWUynBDRR2dAwZt8Xg5RiXhMZag%40mail.gmail.com.
> For more options, visit https://groups.google.com/d/optout.
