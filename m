Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BF2377617
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 11:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhEIJn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 05:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhEIJn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 05:43:28 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3666C061573;
        Sun,  9 May 2021 02:42:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z18so4131536plg.8;
        Sun, 09 May 2021 02:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=osq21oo/pRLHDf/4dr8pVAgwlLU2iHtgI72VbG/Kutk=;
        b=ExOg7CDVTtLE34McWFTFmZ2xnh6oSX4bL86dD3qd0hx6y57SY6pN/QQEcz3o01Fjl5
         9MPS3LgSaMrU2mfXflKK76Rfi1XhqmrcrBs6X7q1OhPlDHrRMzzskN1JsQBV3Vi7QpIl
         bcpk+esswKbQ3r6XZyZQpGlVrcwPU8seg/YaJL8YBwC3QTPnPhcq9c8iOUJqXb56tkq1
         rWViAwa/b7hnCDeG+XlGodYmUUx3E3LzQkkaen+OxfvpDhtm7eeW2DweeFke17iLMoEu
         5aa+0Kwm194+b2B72gUZnnb+PbLFtz9CW0NgOcvFmfLrYOrVuVCWxJgKrFIDYLXSztgc
         cRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=osq21oo/pRLHDf/4dr8pVAgwlLU2iHtgI72VbG/Kutk=;
        b=JBQfAFGDT3Tnapfmfu/lIUpV8jPTMfX+KApROcEpz4t+NUeM+ZSQELb1lNwHmnF8zG
         AP7h4ed/C9r6TYfI67qX8Z0J9MqyzvwTeouMRB3p8uoqPqZF59D1vvsSFF8UH9iwMKqD
         TFlxELUTzITvpZyHnXAhjcUd/dtZvjLfNRz3hrMan4Ji/2RSJiywe6nzcF+OcXoNclr0
         Ja47+wRF0hqc4iQPH3hltg6J1dDI5400lF/Y5CgXX8nOVc246DD1AQR+rtYQHmUWZS00
         mc062/sZKKXltpj2hfVyWB1Xuw2yaMtXizFpLwQAsUi1JAUauHLW3W4KlejMXFD8OGEI
         f4OA==
X-Gm-Message-State: AOAM530uchFc/VJQ9T4ME5EIn97niLxYUG6reS/gVMYRtoJe7YKDFAU5
        4XS9LPMj/fLdlJBr6XheR4v3Azzh3QaQ1B3QPJA=
X-Google-Smtp-Source: ABdhPJxS/G8bgnKha6sxonMpWEB3Q2HfsON0oELtruM6eHw3yTIc4qcTmY+lxzoYFiLooPnCo6qRzaW7iIbqkvVcl6k=
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr3914834pja.181.1620553344888;
 Sun, 09 May 2021 02:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210508085738.6296-1-rocco.yue@mediatek.com>
In-Reply-To: <20210508085738.6296-1-rocco.yue@mediatek.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sun, 9 May 2021 12:42:08 +0300
Message-ID: <CAHp75VftbW7pgkfrSB6teKZO4EfGH9UWkhy1SAtijCLvKz8HTQ@mail.gmail.com>
Subject: Re: [PATCH][v2] rtnetlink: add rtnl_lock debug log
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Peter Enderborg <peter.enderborg@sony.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Vitor Massaru Iha <vitor@massaru.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Di Zhu <zhudi21@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, wsd_upsream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 8, 2021 at 12:11 PM Rocco Yue <rocco.yue@mediatek.com> wrote:
>
> We often encounter system hangs caused by certain process
> holding rtnl_lock for a long time. Even if there is a lock
> detection mechanism in Linux, it is a bit troublesome and
> affects the system performance. We hope to add a lightweight
> debugging mechanism for detecting rtnl_lock.
>
> Up to now, we have discovered and solved some potential bugs
> through this lightweight rtnl_lock debugging mechanism, which
> is helpful for us.
>
> When you say Y for RTNL_LOCK_DEBUG, then the kernel will detect
> if any function hold rtnl_lock too long and some key information
> will be printed out to help locate the problem.
>
> i.e: from the following logs, we can clearly know that the pid=2206
> RfxSender_4 process holds rtnl_lock for a long time, causing the
> system to hang. And we can also speculate that the delay operation
> may be performed in devinet_ioctl(), resulting in rtnl_lock was
> not released in time.
>
> <6>[   40.191481][    C6] rtnetlink: -- rtnl_print_btrace start --

You don't seem to get it. It's a quite long trace for the commit
message. Do you need all those lines below? Why?

> <6>[   40.191494][    C6] rtnetlink: RfxSender_4[2206][R] hold rtnl_lock
> more than 2 sec, start time: 38181400013
> <4>[   40.191510][    C6]  devinet_ioctl+0x1fc/0x75c
> <4>[   40.191517][    C6]  inet_ioctl+0xb8/0x1f8
> <4>[   40.191527][    C6]  sock_do_ioctl+0x70/0x2ac
> <4>[   40.191533][    C6]  sock_ioctl+0x5dc/0xa74
> <4>[   40.191541][    C6]  __arm64_sys_ioctl+0x178/0x1fc
> <4>[   40.191548][    C6]  el0_svc_common+0xc0/0x24c
> <4>[   40.191555][    C6]  el0_svc+0x28/0x88
> <4>[   40.191560][    C6]  el0_sync_handler+0x8c/0xf0
> <4>[   40.191566][    C6]  el0_sync+0x198/0x1c0
> <6>[   40.191571][    C6] Call trace:
> <6>[   40.191586][    C6]  rtnl_print_btrace+0xf0/0x124
> <6>[   40.191595][    C6]  call_timer_fn+0x5c/0x3b4
> <6>[   40.191602][    C6]  expire_timers+0xe0/0x49c
> <6>[   40.191609][    C6]  __run_timers+0x34c/0x48c
> <6>[   40.191616][    C6]  run_timer_softirq+0x28/0x58
> <6>[   40.191621][    C6]  efi_header_end+0x168/0x690
> <6>[   40.191628][    C6]  __irq_exit_rcu+0x108/0x124
> <6>[   40.191635][    C6]  __handle_domain_irq+0x130/0x1b4
> <6>[   40.191643][    C6]  gic_handle_irq.29882+0x6c/0x2d8
> <6>[   40.191648][    C6]  el1_irq+0xdc/0x1c0
> <6>[   40.191656][    C6]  __delay+0xc0/0x180
> <6>[   40.191663][    C6]  devinet_ioctl+0x21c/0x75c
> <6>[   40.191668][    C6]  inet_ioctl+0xb8/0x1f8
> <6>[   40.191675][    C6]  sock_do_ioctl+0x70/0x2ac
> <6>[   40.191682][    C6]  sock_ioctl+0x5dc/0xa74
> <6>[   40.191688][    C6]  __arm64_sys_ioctl+0x178/0x1fc
> <6>[   40.191694][    C6]  el0_svc_common+0xc0/0x24c
> <6>[   40.191699][    C6]  el0_svc+0x28/0x88
> <6>[   40.191705][    C6]  el0_sync_handler+0x8c/0xf0
> <6>[   40.191710][    C6]  el0_sync+0x198/0x1c0
> <6>[   40.191715][    C6] rtnetlink: -- rtnl_print_btrace end --
>
> <6>[   42.181879][ T2206] rtnetlink: rtnl_lock is held by [2206] from
> [38181400013] to [42181875177]

-- 
With Best Regards,
Andy Shevchenko
