Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CFD2548BD
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgH0PLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgH0Lla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 07:41:30 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FB4C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:41:30 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id y2so1510000ilp.7
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2XR1Mc8dJ5lZuCbZST8KrY7/ZxwDrNjZ39kdQPvS71M=;
        b=DHNNLW7O8TNMDsLvBYn79ffz6n300qKSqKrTPoO68hDSCjkEQh+oHhJKQzkEk3xLYz
         VP4Yd5najj1hoFMVvcFOJevMTJM+wFEBjB8vwACxOyxf6m0+I6PhLfDl6gp7IWWXjWYV
         X92HIQOARMLiln2esTB1pkLQXcwQQjYmNahfa+9M5U+9q6uXw6IPtyK6KURD5Hwk++F3
         QBcmqv6wuNRjuX4yexJ4vxRYbxfJK81Cs1NGOVv3f7AekiFx+Y6YwGMRiNqW8oLesFDh
         +iqfBwmGqsYND/a2wog+Hp7WMVDnbageMYBTztSeyjy0t8ApG+NHVcgUHuOWG6OOoNbV
         gnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2XR1Mc8dJ5lZuCbZST8KrY7/ZxwDrNjZ39kdQPvS71M=;
        b=hjEk0Fv5frowSJolBuDINeNB1EdlmQK0tbcEKLeowVnAEfeLyZJs/ImnrPiVRecgo4
         GrPEFrVzAaj8LXGObqKVkJmTW9asJmY/eb3PpwFNysac21Q8sWXGCwhm+pLYLTSarph6
         DNWI6iIA8vH7pJBi+9J0yWXKthFru3hGcjBaTTUBQyXRE76K0qMTmYucunpO8+JEnWwc
         MTvboFyymZ5VR1Xf5QAQJbO0TMTZc4/tQ2rffzahzEl6SJ2ZTls65g3NVnNdCyn27F4/
         YC4FfVPx3XwNZvccvLg1JEDQKvAlIUqJKZgP8nOC7PUXsCqnKCy9ZPvCUTrc3XpI03Zs
         BnRQ==
X-Gm-Message-State: AOAM531MRZBPniuehcHUNphOlkSwhgeww4CyyYLiId799eRRkbI30Luu
        AZDonPUVlWb1SXTovKBQnyS25OBayteGmVlrak+tNw==
X-Google-Smtp-Source: ABdhPJxirTveMuJltE1A7KEaVSzcch70Qm4b9j8tuYr7BwIRss/J49Qeg0VNz7EM/z+tZJw3hkJ7KbjnBYT4QVul3T0=
X-Received: by 2002:a92:d086:: with SMTP id h6mr17190790ilh.205.1598528489329;
 Thu, 27 Aug 2020 04:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <5f479309.1c69fb81.9106e.e12bSMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <5f479309.1c69fb81.9106e.e12bSMTPIN_ADDED_BROKEN@mx.google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Aug 2020 04:41:18 -0700
Message-ID: <CANn89i+4Z-OCsaXUgZ9F-USGu+JyuHUL0aEctdif5mFJf_6HKA@mail.gmail.com>
Subject: Re: RFC: inet_timewait_sock->tw_timer list corruption
To:     Wang Long <w@laoqinren.net>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, opurdila@ixiacom.com,
        vegard.nossum@gmail.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 4:03 AM Wang Long <w@laoqinren.net> wrote:
>
> Hi=EF=BC=8C
>
> we encountered a kernel panic as following:
>
> [4394470.273792] general protection fault: 0000 [#1] SMP NOPTI
> [4394470.274038] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Tainted: G
>       W     --------- -  - 4.18.0-80.el8.x86_64 #1
> [4394470.274477] Hardware name: Sugon I620-G30/60P24-US, BIOS MJGS1223
> 04/07/2020
> [4394470.274727] RIP: 0010:run_timer_softirq+0x34e/0x440
> [4394470.274957] Code: 84 3f ff ff ff 49 8b 04 24 48 85 c0 74 58 49 8b
> 1c 24 48 89 5d 08 0f 1f 44 00 00 48 8b 03 48 8b 53 08 48 85 c0 48 89 02
> 74 04 <48> 89 50 08 f6 43 22 20 48 c7 43 08 00 00 00 00 48 89 ef 4c 89 2b
> [4394470.275505] RSP: 0018:ffff88f000803ee0 EFLAGS: 00010086
> [4394470.275783] RAX: dead000000000200 RBX: ffff88e5e33ea078 RCX:
> 0000000000000100
> [4394470.276087] RDX: ffff88f000803ee8 RSI: 0000000000000000 RDI:
> ffff88f00081aa00
> [4394470.276391] RBP: ffff88f00081aa00 R08: 0000000000000001 R09:
> 0000000000000000
> [4394470.276697] R10: ffff88e5e33eb1f0 R11: 0000000000000000 R12:
> ffff88f000803ee8
> [4394470.277030] R13: dead000000000200 R14: ffff88f000803ee0 R15:
> 0000000000000000
> [4394470.277350] FS:  0000000000000000(0000) GS:ffff88f000800000(0000)
> knlGS:0000000000000000
> [4394470.277684] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [4394470.278020] CR2: 00007f200eddd160 CR3: 0000000e0b20a002 CR4:
> 00000000007606f0
> [4394470.278412] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [4394470.278799] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [4394470.279194] PKRU: 55555554
> [4394470.279543] Call Trace:
> [4394470.279889]  <IRQ>
> [4394470.280237]  ? __hrtimer_init+0xb0/0xb0
> [4394470.280618]  ? sched_clock+0x5/0x10
> [4394470.281000]  __do_softirq+0xe8/0x2ef
> [4394470.281397]  irq_exit+0xf1/0x100
> [4394470.281761]  smp_apic_timer_interrupt+0x74/0x130
> [4394470.282132]  apic_timer_interrupt+0xf/0x20
> [4394470.282548]  </IRQ>
> [4394470.282954] RIP: 0010:cpuidle_enter_state+0xa0/0x2b0
> [4394470.283341] Code: 8b 3d 6c fb 59 4c e8 0f ed a6 ff 48 89 c3 0f 1f
> 44 00 00 31 ff e8 80 00 a7 ff 45 84 f6 0f 85 c3 01 00 00 fb 66 0f 1f 44
> 00 00 <4c> 29 fb 48 ba cf f7 53 e3 a5 9b c4 20 48 89 d8 48 c1 fb 3f 48 f7
> [4394470.284219] RSP: 0018:ffffffffb4603e78 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffff13
> [4394470.284671] RAX: ffff88f000823080 RBX: 000f9cbf579e86c6 RCX:
> 000000000000001f
> [4394470.285129] RDX: 000f9cbf579e86c6 RSI: 0000000037a6f674 RDI:
> 0000000000000000
> [4394470.285623] RBP: 0000000000000002 R08: 00000000000000c4 R09:
> 0000000000000027
> [4394470.286088] R10: ffffffffb4603e58 R11: 000000000000004c R12:
> ffff88f00082df00
> [4394470.286566] R13: ffffffffb4724118 R14: 0000000000000000 R15:
> 000f9cbf579d44e0
> [4394470.287045]  ? cpuidle_enter_state+0x90/0x2b0
> [4394470.287527]  do_idle+0x200/0x280
> [4394470.288010]  cpu_startup_entry+0x6f/0x80
> [4394470.288501]  start_kernel+0x533/0x553
> [4394470.288994]  secondary_startup_64+0xb7/0xc0
>
>
> After analysis, we found that the timer which expires has
> timer->entry.next =3D=3D POISON2 !(the list corruption )
>
> the crash scenario is the same as https://lkml.org/lkml/2017/3/21/732,
>
> I cannot reproduce this issue, but I found that the timer cause crash is
> the inet_timewait_sock->tw_timer(its callback function is
> tw_timer_handler), and the value of tcp_tw_reuse is 1.
>
> # cat /proc/sys/net/ipv4/tcp_tw_reuse
> 1
>
> In the production environment, we encountered this problem many times,
> and every time it was a problem with the inet_timewait_sock->tw_timer.
>
> Do anyone have any ideas for this issue? Thanks.
>

Nothing comes to mind, I am not aware of such crashes in stable linux kerne=
ls.
