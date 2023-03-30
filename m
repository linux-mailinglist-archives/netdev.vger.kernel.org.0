Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E156D007C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjC3KBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjC3KAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:00:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37570869A;
        Thu, 30 Mar 2023 03:00:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y4so74305236edo.2;
        Thu, 30 Mar 2023 03:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680170423; x=1682762423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0EJhMz0vwwp9QLyvz78L2XADYLmd3+FXYQHpMYatqBE=;
        b=XTqPnuIv87oa6/kVHy9Pie002BcsnzZ6j4Q9wJBmlO84pDGIfpkN+1zQ/OgFzYtHR5
         NK0ybuglHr0dKT5GilASgcVs1pa9H78o2brK6qi+NSy5mLIMEoBlSzjVVI/KGToKIOLh
         H+cptOsh9fUDA1ycDhULb0q0wLVk6j8Btc3d4EdGrQTKcZxO38iNyOv/shdZGuwsEHsR
         NhGFxrRdUWWxjhG35PpBAexV2NxczglQCw8/WnNq3byEb5AvfB7uGRd7aEjHCqVzoFSl
         YyYOsGYs7eush3fWssW1Cq7N6/3WPcqWDy1R7ZhQoEjJIdRpTyf494G02gmEnKq19QhS
         JuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680170423; x=1682762423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0EJhMz0vwwp9QLyvz78L2XADYLmd3+FXYQHpMYatqBE=;
        b=HDQQsOJpYrCvSmiX/zEgmVX+QfykMEn2lVEDwV2Es7QuIKHbt2zwYGk7OTd/gWldqI
         vjnw/PO3HaDrpBA3tIQf/5Kit8IQ/8A5f2qbYpSUTSpqs6R3xVJjQ5rx5Xcw2Ln4vofR
         7cxgOLtZfq8WXdA8yrrCwrEh+gVREnYpdB5J0vn/riWLnk04AXAsx3chxVZ8EKMX/MT5
         Bjq9VdckAHucaMobQzi3UXcBPdA9roMfwk8rBxQ6MdxykFUu/CmhPW36n+Q52OHk6c1w
         dZhbrMmgg4F/keSdkcfyXfdSUXetpUWrBfWAhlb8HMG5+vqTj0f9MOh0F5X9txnx+U/n
         l2bA==
X-Gm-Message-State: AAQBX9foAc99pZy7jUEa6Qgk2HUSdag4I4FMhWYd2AZ7iFIdqpjmqam5
        KT87+gAseSZZH7LKZiGkZ7w9ZIsWmEKIYpga5fg=
X-Google-Smtp-Source: AKy350ZdnbDuO6+ZkJyDZ9ab1XF4mQQMjXviHEIohQ4mjWCZtLCM/OCXsW5CXAP4vVYef9E8Eot2tBTpP+t0P1438bE=
X-Received: by 2002:a50:c055:0:b0:502:227a:d0dc with SMTP id
 u21-20020a50c055000000b00502227ad0dcmr10554560edd.4.1680170423098; Thu, 30
 Mar 2023 03:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-3-kerneljasonxing@gmail.com> <20230316172020.5af40fe8@kernel.org>
 <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com> <20230316202648.1f8c2f80@kernel.org>
In-Reply-To: <20230316202648.1f8c2f80@kernel.org>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 30 Mar 2023 17:59:46 +0800
Message-ID: <CAL+tcoCRn7RfzgrODp+qGv_sYEfv+=1G0Jm=yEoCoi5K8NfSSA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 11:26=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Fri, 17 Mar 2023 10:27:11 +0800 Jason Xing wrote:
> > > That is the common case, and can be understood from the napi trace
> >
> > Thanks for your reply. It is commonly happening every day on many serve=
rs.
>
> Right but the common issue is the time squeeze, not budget squeeze,
> and either way the budget squeeze doesn't really matter because
> the softirq loop will call us again soon, if softirq itself is
> not scheduled out.
>
> So if you want to monitor a meaningful event in your fleet, I think
> a better event to monitor is the number of times ksoftirqd was woken
> up and latency of it getting onto the CPU.
>
> Did you try to measure that?
>
[...]
> (Please do *not* send patches to touch softirq code right now, just
> measure first. We are trying to improve the situation but the core
> kernel maintainers are weary of changes:
> https://lwn.net/Articles/925540/
> so if both of us start sending code they will probably take neither
> patches :()

Hello Jakub,

I'm wondering for now if I can update and resend this patch to have a
better monitor (actually we do need one) on this part since we have
touched the net_rx_action() in the rps optimization patch series?
Also, just like Jesper mentioned before, it can be considered as one
'fix' to a old problem but targetting to net-next is just fine. What
do you think about it ?

Thanks,
Jason

>
> > > point and probing the kernel with bpftrace. We should only add
> >
> > We probably can deduce (or guess) which one causes the latency because
> > trace_napi_poll() only counts the budget consumed per poll.
> >
> > Besides, tracing napi poll is totally ok with the testbed but not ok
> > with those servers with heavy load which bpftrace related tools
> > capturing the data from the hot path may cause some bad impact,
> > especially with special cards equipped, say, 100G nic card. Resorting
> > to legacy file softnet_stat is relatively feasible based on my limited
> > knowledge.
>
> Right, but we're still measuring something relatively irrelevant.
> As I said the softirq loop will call us again. In my experience
> network queues get long when ksoftirqd is woken up but not scheduled
> for a long time. That is the source of latency. You may have the same
> problem (high latency) without consuming the entire budget.
>
> I think if we wanna make new stats we should try to come up with a way
> of capturing the problem rather than one of the symptoms.
>
> > Paolo also added backlog queues into this file in 2020 (see commit:
> > 7d58e6555870d). I believe that after this patch, there are few or no
> > more new data that is needed to print for the next few years.
> >
> > > uAPI for statistics which must be maintained contiguously. For
> >
> > In this patch, I didn't touch the old data as suggested in the
> > previous emails and only separated the old way of counting
> > @time_squeeze into two parts (time_squeeze and budget_squeeze). Using
> > budget_squeeze can help us profile the server and tune it more
> > usefully.
> >
> > > investigations tracing will always be orders of magnitude more
> > > powerful :(
> >
> > > On the time squeeze BTW, have you found out what the problem was?
> > > In workloads I've seen the time problems are often because of noise
> > > in how jiffies are accounted (cgroup code disables interrupts
> > > for long periods of time, for example, making jiffies increment
> > > by 2, 3 or 4 rather than by 1).
> >
> > Yes ! The issue of jiffies increment troubles those servers more often
> > than not. For a small group of servers, budget limit is also a
> > problem. Sometimes we might treat guest OS differently.
