Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B524D54C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFTRdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:33:51 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32786 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTRdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 13:33:51 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so1680539plo.0
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 10:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQqEfv3UpRWp6Dt7KK/Wm/iXTV5IlIFQTO5HkcqCWkU=;
        b=Y3lDTsVkncrgNbv3u6+zlQ1u0Uo5xgxjEzouyL7IIXM4mf4KkzUd4qYf5KQkJvJcWM
         A6Q3+dNQ6lamSmVqIdOd/q1XqYL4wLKn+0EYwH2/Z/FEZktXwHTxl5iwKPrjMT78B4Ia
         zx/ogtLORGxTRa5QoFNdnNITSJ2EKRvR6Yiyxo9GDZRPrmFVhNoBzGPNlFmMOY1fE5IC
         8wS8t+87WISSfPFHrYTBfUHZNIcLiKmWejVsi2AEiucF66ErpBvAnWSzLkKCCLKjDBZv
         V/lQ1Zp1rNqtRju/y4/0Pst3hvlB1ZQKe3LFmCi3fUVxV/YFK7NmdrrXiNk4ZSjeypBT
         KbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQqEfv3UpRWp6Dt7KK/Wm/iXTV5IlIFQTO5HkcqCWkU=;
        b=D2L9+qAUM2G62MiF2ax7nHCqFaGgh7en5EdRq9mkYoids6ZRLeoUzpbgLETQBUlzaL
         UK306Iedstov6Ve5JU+Z8Lt3/DpIjE0iDxJMoIYmePJPnFCC4kxlEitw4UDAFyI1mjMJ
         /juE2yDbcVE6adICOCyQyEgcCCC+Bd1t8RpiTdhdkntj+MEKEuy7F4eDFFsenQO5EGn5
         EqKQr47MK+oiI8erckkpA+VNI47Yiy7sR/i3AkCUn3UPQfSws8K05OSBiwUpwSSocUN1
         lUdvubUffajduTNVtDP3R4sk3ls8rLkw1QhShU1rNpryQOHwamlfaFXDZ9crc5SgP3z8
         X7Uw==
X-Gm-Message-State: APjAAAWsU2+GyC0c2CV3sF6EdcxZFXDOiTtfp27dO0jKoTrEBUBC2kkp
        Lg79hiFAul04/h115TQ2B2Gbfevtaxo9zLsVhFcFOw5ZnqY=
X-Google-Smtp-Source: APXvYqzhWwLHgyVfOZjp2sPXuWTigLTaKLH4U9jFm7Gy087GG+hzFz3+efZtlTev/oGU54w6scNxyfOnPuIqBfg5S1Y=
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr48491243plr.12.1561052030491;
 Thu, 20 Jun 2019 10:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
 <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com> <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
In-Reply-To: <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 20 Jun 2019 10:33:38 -0700
Message-ID: <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 5:52 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> hello Cong, thanks for reading.
>
> On Wed, 2019-06-19 at 15:04 -0700, Cong Wang wrote:
> > On Wed, Jun 19, 2019 at 2:10 PM Davide Caratti <dcaratti@redhat.com> wrote:
> > > on some CPUs (e.g. i686), tcf_walker.cookie has the same size as the IDR.
> > > In this situation, the following script:
> > >
> > >  # tc filter add dev eth0 ingress handle 0xffffffff flower action ok
> > >  # tc filter show dev eth0 ingress
> > >
> > > results in an infinite loop. It happened also on other CPUs (e.g x86_64),
> > > before commit 061775583e35 ("net: sched: flower: introduce reference
> > > counting for filters"), because 'handle' + 1 made the u32 overflow before
> > > it was assigned to 'cookie'; but that commit replaced the assignment with
> > > a self-increment of 'cookie', so the problem was indirectly fixed.
> >
> > Interesting... Is this really specific to cls_flower? To me it looks like
> > a bug of idr_*_ul() API's, especially for idr_for_each_entry_ul().
>
> good question, I have to investigate this better (idr_for_each_entry_ul()
> expands in a iteration of idr_get_next_ul()). It surely got in cls_flower
> when it was converted to use IDRs, but it's true that there might be other
> points in TC where IDR are used and the same pattern is present (see
> below).


Yeah, this means we probably want to fix it in idr_get_next_ul() or its
callers like idr_for_each_entry_ul().

>
> > Can you test if the following command has the same problem on i386?
> >
> > tc actions add action ok index 4294967295
>
> the action is added, but then reading it back results in an infinite loop.
> And again, the infinite loop happens on i686 and not on x86_64. I will try
> to see where's the problem also here.

Right, this is what I expect, thanks for confirming it.

I am not sure it is better to handle this overflow inside idr_get_next_ul()
or just let its callers to handle it. According to the comments above
idr_get_next_ul() it sounds like it is not expected to overflow, so...

diff --git a/lib/idr.c b/lib/idr.c
index c34e256d2f01..a38f5e391cec 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -267,6 +267,9 @@ void *idr_get_next_ul(struct idr *idr, unsigned
long *nextid)
        if (!slot)
                return NULL;

+       /* overflow */
+       if (iter.index < id)
+               return NULL;
        *nextid = iter.index + base;
        return rcu_dereference_raw(*slot);
 }
