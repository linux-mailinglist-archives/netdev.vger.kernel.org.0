Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58CA27D7DA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgI2URP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2URM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:17:12 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901EDC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 13:17:11 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so6204190iol.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 13:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V4s2c+K/+Q9aySkWdLG9ZV8JwB6OkTAi/pq61FeG8d4=;
        b=uMHDw//Sbtq7MPaPDIAxHVuM5JGV4Vth1p+Fp0yn5QLJR/kI8gSwOYTpUmsEz6AwZ8
         8Z5xvArmwuqpCT0R3om0rJqoNP5neIL8b2Q3/YGfKaKGThDwWaOMCgZQqBi37Hhh80Xa
         CGTh+vmSgCbBqpmpsREpTy9Wl/npbXXIF3JTPxWXV7G5EJnIfZ4YQXauM1b5dgEcnSTl
         vSTudM+d0O9F7YPM/dCAF4ddGIp3pvjbSUQik5j5m+7TL/j7LnxSVBJqP1cFckjgpHwB
         KD5MXGa3VMfwt7TnW4BWAlejsI16deY2qrh8GzfClRFxWCl+4R1Y8x7jhli4se2R21JP
         jJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V4s2c+K/+Q9aySkWdLG9ZV8JwB6OkTAi/pq61FeG8d4=;
        b=T5iHccQHXmt1C3YHowh6u/d/XtjqldZ0/YczCW80YUC+YLsD2MZDt/dwHfoarevpOA
         EzN8Etu4c+e/eexzP0rOD9KA6SqABZlPbksRTzBAtIYrd07WH+oDpZ544G3r74PZIIzv
         34i99SVjTwTpoRAi7Y04K6YHDR7ZPfQkkSHQ5jGfHsrbPIBAMu3ldB+Hv9paAQMEH1VV
         rlXU4mo48x5mb+S2tfS+sbww1XDp6oPcOm4BOhxm3k+yK5CVIM0fcfp2JwEEnt5ewyZT
         W/wveFCm31/8u8unEHeCihkTraJb8GbiwSOn0o/vl0x2JyidTnNqhVGP6eeQmn8vCaXb
         X1iw==
X-Gm-Message-State: AOAM5339Ncg/+9MjUNl3qBg5dp5bQaFJ52kKQgUxizfuZo3l7GvpNhTE
        uIcf/s2MM3Dr8tikCuCwHGR8zV5CRONkpJiS9GP+gsQq5m9n/w==
X-Google-Smtp-Source: ABdhPJzxhd5nNvTRMRs2z+hsxs1qNTqG4FPiaRxJJCMmiNYu/G5AVhvRq7g5lDKia6FIMvpfEhlUUOIug9cXMh9BmAE=
X-Received: by 2002:a5d:9842:: with SMTP id p2mr3913085ios.113.1601410630635;
 Tue, 29 Sep 2020 13:17:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
 <20200929121902.7ee1c700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929121902.7ee1c700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 29 Sep 2020 13:16:59 -0700
Message-ID: <CAEA6p_BPT591fqFRqsM=k4urVXQ1sqL-31rMWjhvKQZm9-Lksg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 12:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 28 Sep 2020 19:43:36 +0200 Eric Dumazet wrote:
> > Wei, this is a very nice work.
> >
> > Please re-send it without the RFC tag, so that we can hopefully merge it ASAP.
>
> The problem is for the application I'm testing with this implementation
> is significantly slower (in terms of RPS) than Felix's code:
>
>               |        L  A  T  E  N  C  Y       |  App   |     C P U     |
>        |  RPS |   AVG  |  P50  |   P99  |   P999 | Overld |  busy |  PSI  |
> thread | 1.1% | -15.6% | -0.3% | -42.5% |  -8.1% | -83.4% | -2.3% | 60.6% |
> work q | 4.3% | -13.1% |  0.1% | -44.4% |  -1.1% |   2.3% | -1.2% | 90.1% |
> TAPI   | 4.4% | -17.1% | -1.4% | -43.8% | -11.0% | -60.2% | -2.3% | 46.7% |
>
> thread is this code, "work q" is Felix's code, TAPI is my hacks.
>
> The numbers are comparing performance to normal NAPI.
>
> In all cases (but not the baseline) I configured timer-based polling
> (defer_hard_irqs), with around 100us timeout. Without deferring hard
> IRQs threaded NAPI is actually slower for this app. Also I'm not
> modifying niceness, this again causes application performance
> regression here.
>

If I remember correctly, Felix's workqueue code uses HIGHPRIO flag
which by default uses -20 as the nice value for the workqueue threads.
But the kthread implementation leaves nice level as 20 by default.
This could be 1 difference.
I am not sure what the benchmark is doing, but one thing to try is to
limit the CPUs that run the kthreads to a smaller # of CPUs. This
could bring up the kernel cpu usage to a higher %, e.g. > 80%, so the
scheduler is less likely to schedule user threads on these CPUs, thus
providing isolations between kthreads and the user threads, and
reducing the scheduling overhead. This could help if the throughput
drop is caused by higher scheduling latency for the user threads.
Another thing to try is to raise the scheduling class of the kthread
from SCHED_OTHER to SCHED_FIFO. This could help if the throughput drop
is caused by the kthreads experiencing higher scheduling latency.


> 1 NUMA node. 18 NAPI instances each is around 25% of a single CPU.
>
> I was initially hoping that TAPI would fit nicely as an extension
> of this code, but I don't think that will be the case.
>
> Are there any assumptions you're making about the configuration that
> I should try to replicate?
