Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECEA68859B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjBBRiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjBBRiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:38:09 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE1122A22;
        Thu,  2 Feb 2023 09:38:07 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id y19so2657126ljq.7;
        Thu, 02 Feb 2023 09:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Pu18wvor/2098cGUOM60SazY3XVfambrBIsbWzTxNr8=;
        b=Bk7w/t2k4mB45Fer5doVPaURa09g7dbhJw9s2BkR8cwRQAivrlJKyhA/Kdp0Qf1srt
         4YAbN/fuLmaplDGuGYCLCyPSTPrTQF7VyWxpf/FHCD46FpZ7hgX/0UYNr95gBKz/wup2
         duJSZLd4mqFVNCEGzpTJy72YhZcNTugIpm00pZGouLKrx8MQRixFxckIsQkrgGXVPXTH
         KvUy2WPHAuVa63tjx9phzOI7meJ9Ijz80a89tAfQ9Z3jPakXuAknX8+S5EpYty8zovZh
         N0FRF1HAgZZhw92PawOV6mkODqdPd5NV0TMXHJigFKZZr4H8/mcJdQOC0jPupsNVq5It
         sw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pu18wvor/2098cGUOM60SazY3XVfambrBIsbWzTxNr8=;
        b=pCUz4O+dybV4L247IGCSxvjzQiiMwoUduVJagiqh7d8h3Y3QBxcKkyGT2YOWNYrBWr
         s5Y7XXOcVKe3Wkc9Tg/dXPrcOrXGyL4o9Hew9Tx5zuLkqN7WNOfvlXlEQYIp0AspB4N0
         joZuNQcjeLdq7wjfDYulzYPejY0KB6oUUZEHcvyQUicRfdAzZsFCOzuX0ny43sU2aEt4
         wPcaI8J1CvwYMI4omBOZYPUf071iPc/2ClBYiTp+z682lQxgF2CSzj4oJJ0vt+iuPwh7
         VNPCmZHh73Dz6N4gAQcCtjeuihfxxKUsDhs6hWPGaGWFJmgyB/QlKOqBNpBgmaliVZ59
         sVfg==
X-Gm-Message-State: AO0yUKVC2nuKgjlNiE7Kv5+yB5lyIMKKgj403sAZ3zQGxYdKhFJd6njT
        bphoNrRe6El1vLZy2Lp1VWi/l/jeBV+avdO3Klg=
X-Google-Smtp-Source: AK7set9q3fCCrZR/wdr+F6ByZDjLnzGzS47BOOGjK/rvKj3YSOHJWox6kHztbQjG4aCqZPytddEKs4/NHwjssZ51PTI=
X-Received: by 2002:a2e:5405:0:b0:290:613e:d49a with SMTP id
 i5-20020a2e5405000000b00290613ed49amr1077923ljb.133.1675359485897; Thu, 02
 Feb 2023 09:38:05 -0800 (PST)
MIME-Version: 1.0
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com> <xhsmhv8kxh8tk.mognet@vschneid.remote.csb>
 <4fa5d53d-d614-33b6-2d33-156281420507@gmail.com> <20230130122206.3b55a0a7@kernel.org>
 <20230202093335.43586ecf@kernel.org>
In-Reply-To: <20230202093335.43586ecf@kernel.org>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Thu, 2 Feb 2023 09:37:54 -0800
Message-ID: <CAAH8bW-JE1d97EgvaiY_-dHL8Tf585=vK_tjabUingZeCh5K2Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/9] sched: cpumask: improve on cpumask_local_spread()
 locality
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 9:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 30 Jan 2023 12:22:06 -0800 Jakub Kicinski wrote:
> > On Sun, 29 Jan 2023 10:07:58 +0200 Tariq Toukan wrote:
> > > > Peter/Ingo, any objections to stashing this in tip/sched/core?
> > >
> > > Can you please look into it? So we'll have enough time to act (in
> > > case...) during this kernel.
> > >
> > > We already missed one kernel...
> >
> > We really need this in linux-next by the end of the week. PTAL.
>
> Peter, could you please take a look? Linux doesn't have an API for
> basic, common sense IRQ distribution on AMD systems. It's important :(

FWIW, it's already been in linux-next since mid-December through the
bitmap branch, and no issues were reported so far.

Thanks,
Yury
