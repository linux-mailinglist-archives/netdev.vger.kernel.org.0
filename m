Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE6342154F
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 19:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhJDRqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 13:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhJDRqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 13:46:52 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BB8C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 10:45:03 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id r1so39521786ybo.10
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 10:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SlTTTmZt1ZVgLE+jjDqBMzzZLFDCuHXtf2U9sFgaH6Q=;
        b=TWS4dSPmIduBzhDM0RN2PYpnY5ZrFUzkoNW+Y5NWXoiTdHN1IW/ud0tKceMzcBdoJI
         ITmwsXIeBfIT6zL6qlEDzvStlNTykWjV7id2VhPWCvKIcsp2FgdH1tcn0HyNl0feq9rk
         9ewtI/KJ2IlNon+izaqUY6251N9hqmPOyxTIWjhJWzgIgJM5yHtA72eWtFQrH80fqOom
         2PcYPP3VsCnW+w8PspXvBWpN7WZn87OvVRiy4zPuR+r+90rO4GXiDxlI0skGhPCIwyMN
         Kc52mnYJ5T8XWbSKfOsFgrACbh5oUS9BReLKFjLnmQ3kCnVZJnwBmqru7JpWFDBcIFf2
         GFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SlTTTmZt1ZVgLE+jjDqBMzzZLFDCuHXtf2U9sFgaH6Q=;
        b=TnMm6+QQ5FD9egjyvZzi5pG9r17RVlEPW0aA0pr9aKQH4EuUrn1zovmtxkumTrI2X9
         uZBx6ekmLn+FSAz6DNpXrJDZ2Dr4QelEj1WBC0Ih85rUUAYZvGGyHzcOntgFRrzMkF4g
         h+EkP0ofw8EP/MqUElAWv6aUTxdjeS/GcPT5c557vfhmP9ujGC6zvq04+2vKxrUqSui2
         GpGVKgIaraDLoJtRgdJPRcBGYkcThf/Q/MxVk71H2Ze3bTj5VVrdJ2tKe9+V4QowgpWG
         ZFhQHCIG4d3pSmXJvp23jKbu22Bm9QXSz4M/3BXKfBnYasWJ+oIoGD/9TajpSH1uepGc
         Wg4Q==
X-Gm-Message-State: AOAM5317Dm5falm1R/xvTeF4hMF5WQVjvRHUrFSwaTxtOi6t/NfC8PPc
        EKMGKROwikxQF1b2YywKqofeaVPWjFvsve1nTj+W7A==
X-Google-Smtp-Source: ABdhPJyqpYfb6ZH+pqgsTR8AfmpOK0vhVYDoUCdYKxJIsPTtzguTWOrDbkBdcY0/s5CHuB3svVp80yKscYUo8cXaxzw=
X-Received: by 2002:a25:dd46:: with SMTP id u67mr17337000ybg.295.1633369501804;
 Mon, 04 Oct 2021 10:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211004125033.572932188@linuxfoundation.org> <CA+G9fYtyzfpSnapCFEVgeWGD8ZwS2_Lv5KPwjX4hUwDAv52kFg@mail.gmail.com>
In-Reply-To: <CA+G9fYtyzfpSnapCFEVgeWGD8ZwS2_Lv5KPwjX4hUwDAv52kFg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 4 Oct 2021 10:44:50 -0700
Message-ID: <CANn89iKPvyS1FB2z9XFr4Y1i8XXc34CTdbSAakjMC=NVYvwzXw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc1 review
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
        Netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 4, 2021 at 10:40 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Mon, 4 Oct 2021 at 18:32, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.209 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.209-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regression found on arm, arm64, i386 and x86.
> following kernel crash reported on stable-rc linux-4.19.y.
>

Stable teams should backport cred: allow get_cred() and put_cred() to
be given NULL.

f06bc03339ad4c1baa964a5f0606247ac1c3c50b

Or they should have tweaked my patch before backporting it.

> metadata:
>   git branch: linux-4.19.y
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git commit: ee3e528d83e91547f386a30677ccb96c28e78218
>   git describe: v4.19.208-96-gee3e528d83e9
>   make_kernelversion: 4.19.209-rc1
>   kernel-config: https://builds.tuxbuild.com/1z2izwX1xMgF2OSYM5EN6ELHEij/config
>
>
> Kernel crash:
> --------------
> [   14.900875] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000000
> [   14.908699] PGD 0 P4D 0
> [   14.911230] Oops: 0002 [#1] SMP PTI
> [   14.914714] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.209-rc1 #1
> [   14.921147] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [   14.928531] RIP: 0010:__sk_destruct+0xb9/0x190
> [   14.932965] Code: 48 8b 47 08 48 8d 50 ff a8 01 48 0f 45 fa f0 ff
> 4f 34 0f 84 d9 00 00 00 48 c7 83 00 ff ff ff 00 00 00 00 48 8b bb 78
> ff ff ff <f0> ff 0f 0f 84 a0 00 00 00 48 8b bb 70 ff ff ff e8 32 41 6d
> ff f6
> [   14.951704] RSP: 0000:ffff9e242f803dc0 EFLAGS: 00010246
> [   14.956920] RAX: 0000000000000000 RBX: ffff9e242cfc82c0 RCX: 0000000000000001
> [   14.964043] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [   14.971167] RBP: ffff9e242f803de0 R08: ffff9e242cfc8000 R09: 0000000000000000
> [   14.978291] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9e242cfc8000
> [   14.985415] R13: ffff9e242cfc82c0 R14: ffff9e242cde8600 R15: 00000000ffffff0c
> [   14.992540] FS:  0000000000000000(0000) GS:ffff9e242f800000(0000)
> knlGS:0000000000000000
> [   15.000617] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   15.006359] CR2: 0000000000000000 CR3: 0000000013c0a001 CR4: 00000000003606f0
> [   15.013504] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   15.020628] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   15.027752] Call Trace:
> [   15.030198]  <IRQ>
> [   15.032207]  __sk_free+0x71/0x110
> [   15.035518]  __sock_wfree+0x2c/0x30
> [   15.039002]  skb_release_head_state+0x56/0xa0
> [   15.043359]  napi_consume_skb+0x5a/0x140
> [   15.047297]  igb_poll+0xc7/0xf30
> [   15.050522]  net_rx_action+0x13a/0x3a0
> [   15.054273]  ? __napi_schedule+0x54/0x70
> [   15.058189]  __do_softirq+0xf6/0x2ed
> [   15.061760]  irq_exit+0xab/0xe0
> [   15.064897]  do_IRQ+0x86/0xe0
> [   15.067862]  common_interrupt+0xf/0xf
> [   15.071519]  </IRQ>
> [   15.073618] RIP: 0010:cpuidle_enter_state+0x119/0x2c0
> [   15.078669] Code: 77 ff 80 7d c7 00 74 12 9c 58 f6 c4 02 0f 85 8e
> 01 00 00 31 ff e8 07 1d 7d ff e8 b2 84 82 ff fb 48 ba cf f7 53 e3 a5
> 9b c4 20 <4c> 2b 7d c8 4c 89 f8 49 c1 ff 3f 48 f7 ea b8 ff ff ff 7f 48
> c1 fa
> [   15.097405] RSP: 0000:ffffffff9ce03e00 EFLAGS: 00000282 ORIG_RAX:
> ffffffffffffffdc
> [   15.104961] RAX: ffffffff9ce03e40 RBX: ffff9e242d6ce000 RCX: 000000000000001f
> [   15.112085] RDX: 20c49ba5e353f7cf RSI: ffffffff9c028777 RDI: ffffffff9c02858e
> [   15.119210] RBP: ffffffff9ce03e40 R08: 0000000378293f7f R09: 0000000000000022
> [   15.126358] R10: 0000000000000034 R11: ffff9e242f81ed08 R12: 0000000000000001
> [   15.133510] R13: ffffffff9ceca620 R14: ffffffff9ceca680 R15: 0000000378293f7f
> [   15.140636]  ? cpuidle_enter+0x17/0x20
> [   15.144415]  ? cpuidle_enter_state+0x10e/0x2c0
> [   15.148859]  cpuidle_enter+0x17/0x20
> [   15.152430]  call_cpuidle+0x23/0x40
> [   15.155914]  do_idle+0x1b9/0x240
> [   15.159138]  cpu_startup_entry+0x73/0x80
> [   15.163055]  rest_init+0xa3/0xa5
> [   15.166280]  start_kernel+0x483/0x4a5
> [   15.169937]  x86_64_start_reservations+0x24/0x26
> [   15.174547]  x86_64_start_kernel+0x70/0x74
> [   15.178637]  secondary_startup_64+0xa4/0xb0
> [   15.182813] Modules linked in:
> [   15.185866] CR2: 0000000000000000
> [   15.189177] ---[ end trace 87e25bcdd88d2b4b ]---
> [   15.193785] RIP: 0010:__sk_destruct+0xb9/0x190
> [   15.198222] Code: 48 8b 47 08 48 8d 50 ff a8 01 48 0f 45 fa f0 ff
> 4f 34 0f 84 d9 00 00 00 48 c7 83 00 ff ff ff 00 00 00 00 48 8b bb 78
> ff ff ff <f0> ff 0f 0f 84 a0 00 00 00 48 8b bb 70 ff ff ff e8 32 41 6d
> ff f6
> [   15.216960] RSP: 0000:ffff9e242f803dc0 EFLAGS: 00010246
> [   15.222176] RAX: 0000000000000000 RBX: ffff9e242cfc82c0 RCX: 0000000000000001
> [   15.229302] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [   15.236424] RBP: ffff9e242f803de0 R08: ffff9e242cfc8000 R09: 0000000000000000
> [   15.243548] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9e242cfc8000
> [   15.250673] R13: ffff9e242cfc82c0 R14: ffff9e242cde8600 R15: 00000000ffffff0c
> [   15.257796] FS:  0000000000000000(0000) GS:ffff9e242f800000(0000)
> knlGS:0000000000000000
> [   15.265872] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   15.271613] CR2: 0000000000000000 CR3: 0000000013c0a001 CR4: 00000000003606f0
> [   15.278734] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   15.285858] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   15.292982] Kernel panic - not syncing: Fatal exception in interrupt
> [   15.299375] Kernel Offset: 0x1a600000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ref:
> https://lkft.validation.linaro.org/scheduler/job/3657592#L928
> https://lkft.validation.linaro.org/scheduler/job/3657638#L933
> https://lkft.validation.linaro.org/scheduler/job/3657762#L949
> https://lkft.validation.linaro.org/scheduler/job/3657822#L1899
>
> --
> Linaro LKFT
> https://lkft.linaro.org
