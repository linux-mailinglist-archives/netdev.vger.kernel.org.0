Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F02280C11
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgJBBoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBBoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:44:55 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1423FC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 18:44:54 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id u9so344547ilj.7
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 18:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5khYW4AUWNDsLhf0D/UuZktn2Q5dXwEqrZD0Mk0ES4=;
        b=Xnyr16GA+nti5C3sQWpcIFNJCPyRMbR5D4AD5oyhsd1vNfFvK8vFjL43Jbh2O7iyz0
         nPQvs60U9CNtnDsh+Rs3dQTxPsHD7aT+OncSpIVNZjKSQHxYIi6Aja7HvGQONMpR6Zgb
         NpHuVvayHN3JoghsSsEayg5D+BTjGud8asixF5maaAosIu40maCj4sLBVnBRIx3jaVJc
         631jICifMNVrimWx82bPydAtlvf0bgYg7ZaHNizQSSIucrSWFDj/QYCWoIrbR0wzaWxZ
         r5KWKca/txCqtQGrJVoWfGAsvf2K9lkRCRuQaJAsALxn/43iHlO9oiU5+Q4237q5cABj
         kO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v5khYW4AUWNDsLhf0D/UuZktn2Q5dXwEqrZD0Mk0ES4=;
        b=G/ydUGcE2gNN8SVd2xO0RKrVREVYPaqiBuineCyWx1tpPpiHS4ed/iA4TPLDzNEiaZ
         jT/fvx5wHsP00hdmFDNMEzlxddliYGqw+Ys2WMm1+ZsXdlG9v4V9aN9eWQsY1V4g6bnk
         MknKrLtacHvAQ+BVXakF72YTwz49+CKFc6Yz2erjPOQrAnuVy0n342TvcKkjVMBk6AUR
         i+6l1Sm29h4y0N4ZzjIqg/FckudUIduDKVBdZMi98WTpIwkojXldQfCiwXVtrCRkoBGK
         WZkvUKluxTkaLxJdK7Qd2q2Dn6j9A+L+DM+b9ATv867O3cGaRrhoIqYco7vBvmFGUY/4
         41hA==
X-Gm-Message-State: AOAM532Aki3oM3x2WhHwsgYPdmWPKNRC500hiW+Fi0lLKYss/1irWeKl
        9CIIJTu+vHOf0Gb1KFhE1zByUEzmrV+B+Rbre09QBQ==
X-Google-Smtp-Source: ABdhPJxmo5+UgnH0bTlYooDYBjnewxeVAeapVp4r+T23A6Ugd8gyhJbIwm6ojRwGAj0+3FGjtvXCp2YS8ETgl/LO0s8=
X-Received: by 2002:a92:9a13:: with SMTP id t19mr4814731ili.269.1601603092037;
 Thu, 01 Oct 2020 18:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com>
 <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_DukokJByTLp4QeGRrbNgC-hb9P6YX5Qh=UswPubrEnVA@mail.gmail.com> <20201001164652.0e61b810@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001164652.0e61b810@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 1 Oct 2020 18:44:40 -0700
Message-ID: <CAEA6p_DWVGV9hOh3CcuWPcxSDmOSb94qHMft-o+Ts8KNoKqxxQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 4:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 1 Oct 2020 15:12:20 -0700 Wei Wang wrote:
> > Yes. I did a round of testing with workqueue as well. The "real
> > workload" I mentioned is a google internal application benchmark which
> > involves networking  as well as disk ops.
> > There are 2 types of tests there.
> > 1 is sustained tests, where the ops/s is being pushed to very high,
> > and keeps the overall cpu usage to > 80%, with various sizes of
> > payload.
> > In this type of test case, I see a better result with the kthread
> > model compared to workqueue in the latency metrics, and similar CPU
> > savings, with some tuning of the kthreads. (e.g., we limit the
> > kthreads to a pool of CPUs to run on, to avoid mixture with
> > application threads. I did the same for workqueue as well to be fair.)
>
> Can you share relative performance delta of this banchmark?
>
> Could you explain why threads are slower than ksoftirqd if you pin the
> application away? From your cover letter it sounded like you want the
> scheduler to see the NAPI load, but then you say you pinned the
> application away from the NAPI cores for the test, so I'm confused.
>

No. We did not explicitly pin the application threads away.
Application threads are free to run anywhere. What we do is we
restrict the NAPI kthreads to only those CPUs handling rx interrupts.
(For us, 8 cpus out of 56.) So the load on those CPUs are very high
when running the test. And the scheduler is smart enough to avoid
using those CPUs for the application threads automatically.
Here is the results of 1 representative test result:
                     cpu/op   50%tile     95%tile       99%tile
base            71.47        417us      1.01ms          2.9ms
kthread         67.84       396us      976us            2.4ms
workqueue   69.68       386us      791us             1.9ms

Actually, I remembered it wrong. It does seem workqueue is doing
better on latencies. But cpu/op wise, kthread seems to be a bit
better.

> > The other is trace based tests, where the load is based on the actual
> > trace taken from the real servers. This kind of test has less load and
> > ops/s overall. (~25% total cpu usage on the host)
> > In this test case, I observe a similar amount of latency savings with
> > both kthread and workqueue, but workqueue seems to have better cpu
> > saving here, possibly due to less # of threads woken up to process the
> > load.
> >
> > And one reason we would like to push forward with 1 kthread per NAPI,
> > is we are also trying to do busy polling with the kthread. And it
> > seems a good model to have 1 kthread dedicated to 1 NAPI to begin
> > with.
>
> And you'd pin those busy polling threads to a specific, single CPU, too?
> 1 cpu : 1 thread : 1 NAPI?
Yes. That is my thought.
