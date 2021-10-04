Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4A9421589
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 19:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhJDRw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 13:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbhJDRwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 13:52:49 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D877C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 10:51:00 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i84so39555086ybc.12
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 10:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zvmTFKzKgEIuA+Q0tlaR0l2mg27OHQw0YQJv/ZV4dVA=;
        b=ocbV7nFNOcTVuPI0eib00cfR/g2mXJ8R7cHMwxo3LGyGVNDYX2VVLIpCwLfcFRX96y
         NYQZIrBVsPaCAsI4vNLf+oXs0fo7TjqTKSZ6kMOMxwiH9fiW4U2qPQMTI5Wpkk5JGzQn
         M5SF/8zliuHltaQf59+mwCQHja79GOgsCjTisLYKjAFRInL4zwuwKDadWkruuIDZyEh2
         eKOYRliHeVK7YrtESgUZkPwKfk/6u444pe9vlbbWxe7fSIg0GDD/XradO/jkiANvkbHj
         RdkJHrd0wWvPjIgjbH0JTbEav/BebuDyUyE34GyC+HvAut7XUS4LEjcbI21DkwUGEtya
         UAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zvmTFKzKgEIuA+Q0tlaR0l2mg27OHQw0YQJv/ZV4dVA=;
        b=r7yRhmNG8+89j8AE7ucqi4WeFDNm0M7hA3+6VOSQTfvpZKOgwYX9kTL7B5u8l+Zexa
         CXgclscTgPwU5fWS8AhblLME4RzVKXawYhNSMXzSIHAsiSrjPn4OBXI6rfgIarLjBVur
         /J+YjiK71/2WmBcLtoK531rieb+RP6OKBYXIw7fASX1OHWUSK8iCIb3oKPjt7e8mODSW
         BVhTbebgYiUHCdaiZIbDsw+vo8FlD/WSL45pY3E5Pgc3I7G0pDR8MEy1iT9tW8+0LRni
         M4O4X+PQZYnscF4SKMPpoaqKA80YdtpkVxmHLUsVjfTtkWvtwPcGvHcszkmuDh509jl3
         f7bw==
X-Gm-Message-State: AOAM532WfVrqCl952k+y5ZG29M9qg+eVyx1Lsaa/trERCcrQdOJVLpK3
        b+xaeb2f5hhwybyKAjvdu6iFQs1pfRZ5GHZArY2aJA==
X-Google-Smtp-Source: ABdhPJxh/qbMcK0PHKj98tVo0N71N582rlvmfGeqOU8NnU8vKgGjrTamnDiQ2yoxjAZTTvrvKWfld4/cMZdbpeHoz8w=
X-Received: by 2002:a25:dd46:: with SMTP id u67mr17377538ybg.295.1633369856285;
 Mon, 04 Oct 2021 10:50:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211004125031.530773667@linuxfoundation.org> <CA+G9fYsDP=N0WeZhcBA=_0PQVKbTm=r=qA7ctLB9+Ck8WWP2dw@mail.gmail.com>
In-Reply-To: <CA+G9fYsDP=N0WeZhcBA=_0PQVKbTm=r=qA7ctLB9+Ck8WWP2dw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 4 Oct 2021 10:50:45 -0700
Message-ID: <CANn89iL1OfZxJTifDcPbsw0U57s3FM257PpH_nFoRLv7sZOHCQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/75] 4.14.249-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 4, 2021 at 10:49 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Mon, 4 Oct 2021 at 18:29, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.14.249 release.
> > There are 75 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.249-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regression found on arm, arm64, i386 and x86.
> following kernel crash reported on stable-rc linux-4.14.y.
>
> The regression found to be the same as linux-4.19.y regression report.
>

Same comment really.

Please backport f06bc03339ad4c1baa964a5f0606247ac1c3c50b
("cred: allow get_cred() and put_cred() to be given NULL.")


> metadata:
>   git branch: linux-4.14.y
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git commit: 7f6d4fdae68d03504a8db861c9b0b7d141fc8e1b
>   git describe: v4.14.248-76-g7f6d4fdae68d
>   make_kernelversion: 4.14.249-rc1
>   kernel-config: https://builds.tuxbuild.com/1z2iunDwXCLi5DKUEpJHnhM0ySR/config
>
> Kernel crash:
> --------------
> [   14.317412] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [   14.325232] IP: __sk_destruct+0xb9/0x190
> [   14.329155] PGD 0 P4D 0
> [   14.331687] Oops: 0002 [#1] SMP PTI
> [   14.335171] Modules linked in:
> [   14.338222] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.14.249-rc1 #1
> [   14.344652] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [   14.352122] task: ffff8dc95d6dac40 task.stack: ffffaa1401930000
> [   14.358052] RIP: 0010:__sk_destruct+0xb9/0x190
> [   14.362514] RSP: 0000:ffff8dc96fd03dc8 EFLAGS: 00010246
> [   14.367730] RAX: 0000000000000000 RBX: ffff8dc95ba682c0 RCX: 0000000000000002
> [   14.374856] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [   14.381978] RBP: ffff8dc96fd03de8 R08: ffff8dc95ba68000 R09: 0000000000000000
> [   14.389103] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8dc95ba68000
> [   14.396226] R13: ffff8dc95ba682c0 R14: ffff8dc95c33b540 R15: 00000000ffffff0c
> [   14.403351] FS:  0000000000000000(0000) GS:ffff8dc96fd00000(0000)
> knlGS:0000000000000000
> [   14.411428] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   14.417164] CR2: 0000000000000000 CR3: 0000000310c0a001 CR4: 00000000003606e0
> [   14.424291] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   14.431414] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   14.438538] Call Trace:
> [   14.440982]  <IRQ>
> [   14.442994]  __sk_free+0x5d/0x100
> [   14.446311]  __sock_wfree+0x2c/0x30
> [   14.449796]  skb_release_head_state+0x52/0xa0
> [   14.454146]  napi_consume_skb+0x5a/0x140
> [   14.458081]  igb_poll+0xc7/0xf40
> [   14.461305]  net_rx_action+0x12c/0x3c0
> [   14.465049]  ? __napi_schedule+0x54/0x70
> [   14.468993]  __do_softirq+0xf6/0x316
> [   14.472565]  irq_exit+0xab/0xe0
> [   14.475710]  do_IRQ+0x90/0xe0
> [   14.478673]  common_interrupt+0x97/0x97
> [   14.482503]  </IRQ>
> [   14.484601] RIP: 0010:cpuidle_enter_state+0x10b/0x270
> [   14.489644] RSP: 0000:ffffaa1401933e90 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffffbd
> [   14.497200] RAX: ffff8dc96fd1fb00 RBX: ffff8dc95ce2b400 RCX: 000000000000001f
> [   14.504326] RDX: 20c49ba5e353f7cf RSI: ffffffeef3e739ed RDI: 0000000000000000
> [   14.511448] RBP: ffffaa1401933ec8 R08: 0000000355625095 R09: 0000000000000002
> [   14.518574] R10: 0000000000000032 R11: ffff8dc95ce2b400 R12: 0000000000000001
> [   14.525697] R13: ffffffff8accb7c0 R14: ffffffff8accb820 R15: 0000000355625095
> [   14.532824]  cpuidle_enter+0x17/0x20
> [   14.536401]  call_cpuidle+0x23/0x40
> [   14.539886]  do_idle+0x15c/0x1b0
> [   14.543109]  cpu_startup_entry+0x20/0x30
> [   14.547052]  start_secondary+0x179/0x1b0
> [   14.550995]  secondary_startup_64+0xa5/0xb0
> [   14.555174] Code: 23 48 8b 47 20 48 8d 50 ff a8 01 48 0f 45 fa f0
> ff 4f 1c 0f 84 d3 00 00 00 48 c7 83 08 ff ff ff 00 00 00 00 48 8b bb
> 78 ff ff ff <f0> ff 0f 0f 84 9a 00 00 00 48 8b bb 70 ff ff ff e8 52 29
> 77 ff
> [   14.574049] RIP: __sk_destruct+0xb9/0x190 RSP: ffff8dc96fd03dc8
> [   14.579984] CR2: 0000000000000000
> [   14.583297] ---[ end trace 60cf825c79b13148 ]---
> [   14.587914] Kernel panic - not syncing: Fatal exception in interrupt
> [   14.594301] Kernel Offset: 0x8400000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [   14.604987] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ref:
> https://lkft.validation.linaro.org/scheduler/job/3657328#L932
>
> --
> Linaro LKFT
> https://lkft.linaro.org
