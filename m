Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153B042F754
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 17:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240991AbhJOPv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 11:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbhJOPv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 11:51:57 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0DDC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 08:49:50 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id ay35so8868941qkb.10
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 08:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2yLwQb93aH0FM1hmWYFkH8vl9eYYsDnVtvQjWjn4tI=;
        b=nRv4SixzkY8ZfUAk/qN2LMpnYFbOAGblZjB076DOa51lGBi7sUGUAHR1OkKBlw7akf
         0ixMt8bAwDdFTnJ9g+IsQCiGbxw0ij07cM1GD0jjZsqSQzGhvd6ReqBfg6LuhIqM6TuD
         2N1Lor6JMFKg9osm2WPe6iUGCDOCnXirf+R0RiU0aRqkbAFQMPerloJufd1NImsljGGY
         /RZTLs8GZC0jqNXIHB5jX8YKMJml8dh66DFP353348gVDgWCNh8sC1670hQQfr/3Kx7/
         KHM1uD6aD8t1O3jXcdNUsWKs9xiph1BNLRqII3+TibvKUkSuAGjjmGrMbRyk86RJIefJ
         FJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2yLwQb93aH0FM1hmWYFkH8vl9eYYsDnVtvQjWjn4tI=;
        b=DmsMbOVb8ximPqnsv1msRRJfPkKx1dn8+RbE9m4N1EzwK1vyPe+w/aeYzICqs3VRlm
         vmu1C06Ikob1lbwsD8xjKrOBJlmq9dTdnh5z3d2bjaxBU14m47esMKuNeI0rqOovCKWJ
         LzJ5Ulv358xwHezwjMU8CxR8pGrNJD6qQUDkF6+AFljVIf0m0DomZ9zz7V7MSRDNiN13
         JdNbiZ122VJ/coK8zZ5wSeB2IOk22iqf4m/j124rdvlZgpu7aXzegRvNpWmDv2ngZ0Uo
         tR3FPwVX4dbp/69caAK8Wn6vdeKOtVixDY+UXl0C2WBpVrZRF1PlvSInoFnCqf8H5TUY
         eufw==
X-Gm-Message-State: AOAM532RLZnCqbcjC4KWxl5YhvctEdz+R8gJHft+RXB2Cuu7k8sQjCSU
        uMm6QGidecqJ1mUZOSl8EMcf+GLNj2QkTZrfGfzojFKYQK2E0g==
X-Google-Smtp-Source: ABdhPJx4/qIVzqjI2Ff0m/HpO7L15B6kLx5Wkm+l9yg3DeU8gpj5MDVkoJJW5dMcE0QT+RnOwtmygpscwdn71MgBxf8=
X-Received: by 2002:a37:b0c6:: with SMTP id z189mr10396883qke.344.1634312989840;
 Fri, 15 Oct 2021 08:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com> <9608bf7c-a6a2-2a30-2d96-96bd1dfb25e3@bobbriscoe.net>
 <CANn89iKavhJGi0NE873v+qCjZL=NRbMjVCsLJJv2o9nXyDSmUQ@mail.gmail.com>
In-Reply-To: <CANn89iKavhJGi0NE873v+qCjZL=NRbMjVCsLJJv2o9nXyDSmUQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 15 Oct 2021 11:49:32 -0400
Message-ID: <CADVnQyn5qjonOejvmsQh+KJ04NV0f+NoGWXB-AQBPXLUkqPU6w@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
To:     Eric Dumazet <edumazet@google.com>
Cc:     Bob Briscoe <ietf@bobbriscoe.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 10:08 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Oct 15, 2021 at 5:59 AM Bob Briscoe <ietf@bobbriscoe.net> wrote:
> >
> > Eric,
> >
> > Because the threshold is in time units, I suggest the condition for
> > exceeding it needs to be AND'd with (*backlog > mtu), otherwise you can
> > get 100% solid marking at low link rates.
> >
> > When ce_threshold is for DCs, low link rates are unlikely.
> > However, given ce_threshold_ect1 is mainly for the Internet, during
> > testing with 1ms threshold we encountered solid marking at low link
> > rates, so we had to add a 1 packet floor:
> > https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf
> >
> > Sorry to chime in after your patch went to net-next.
> >
>
> What you describe about a minimal backlog was already there with
> ce_threshold handling ?

For my education, do you have a pointer to where the ce_threshold
marking logic has a minimum backlog size requirement in packets or
bytes? AFAICT the ce_threshold marking in include/net/codel_impl.h
happens regardless of the current size of the backlog.

> Or is it something exclusive to L4S ?

I don't think it's exclusive to L4S. I think Bob is raising a general
issue about improving ECN marking based on ce_threshold. My
interpretation of Bob's point is that there is sort of a quantization
issue at very low link speeds, where the serialization delay for a
packet is at or above the ce_threshold delay. In such cases it seems
there can be behavior where the bottleneck marks every packet CE all
the time, causing any ECN-based algorithm (even DCTCP) to suffer poor
utilization.

I suppose with a fixed-speed link the operator could adjust the
ce_threshold based on the serialization delays implied by the link
speed, but perhaps in general this is infeasible due to variable-speed
(e.g., radio) links.

I guess perhaps this could be reproduced/tested with DCTCP (using
ECT(0)), a ce_threshold of 1ms (for ECT(0)), and an emulated
bottleneck link speed with a serialization delay well above 1ms (so a
link speed well below 12Mbps).

> This deserves a separate patch, if anything :)

Agreed, in the Linux development model this would make sense as a
separate patch, since it is conceptually separate and there do not
need to be any dependencies between the two changes. :-)

neal
