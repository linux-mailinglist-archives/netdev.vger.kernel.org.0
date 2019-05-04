Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCDF13B7A
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 19:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfEDRtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 13:49:17 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38200 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfEDRtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 13:49:16 -0400
Received: by mail-pl1-f196.google.com with SMTP id a59so4264888pla.5
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PCboX55ASlpLi6KIdXMC9RHxIJvL+h6jlK0JFCCxmCA=;
        b=NhUEbbvwId2cLbyIlPh8YxJHlYFYNku8darEo1eJ9GBl2j3pDaveeP72gidsbEOCcF
         mqC2XdR+x0Rc6fNipU6CMKImb49/Osaup5Hm016aiK1AqoSkRxsF/tTTGVogZPfnY4Vv
         mOeZk0THt6t6NGmuOynMs2Iests3UA/+n1R7KB7ZFIlaS6T4lgw333R8eHcawpeJ7HUq
         fnrEEV9OS0CwsUCkl2koLo2FpZA3iDDgtXb7DadFwr/GMQxvIMno+g0dvfxGxnLiWUUp
         vm/gZHm7Lr+LnZjLwJAr9hM5fT1Z6fUBHIrgg/9LKOynQbCQO5P6dxKIWXpF+Z6ebdeU
         o2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PCboX55ASlpLi6KIdXMC9RHxIJvL+h6jlK0JFCCxmCA=;
        b=iR4qsJwmn8v/HZFck2O1FLGkD77QkHC0HoAEZDTgA4weCrmeuTHnPTTVdgcIRzSFHU
         LgSD34DugMxHZSxUAxo80UpGNtMGkwCebXoDp8itbPooRPrwNgQvM9IHe5NDIKl5C/b+
         zWgbF7w3IG2p3L8egqMsbDr9UmMvMAo0wMTsRb+Rdf8Wy0+gSajz5tbdQunr7GtogtVc
         gbdBR5wJyiRkYrpzKAEa+4hSLIjxqgdKlceh//CCLPGkJw2tDU6M5NB3dSMOWmxm+hHD
         21K3B+yEol4tUld+YPkIBAsUbAwcU7hwqT/gH3bCbIYH4Kx/SqIQqUSv/N4RwkC30pUr
         JDkw==
X-Gm-Message-State: APjAAAX6h1AEupMGpmVf9DMbuFyQ6L32i++wUNVFGMh0zbt3qKjSdk9f
        1oxs+knTF+nldkuucQaoJARaauYkUpBnzQorQBw=
X-Google-Smtp-Source: APXvYqzjPGCgSK5jvyfOK1rFXcc4DrT0bQqkQptYvU8BqPFCVy7RWZrYNkLjK7Jmn4EOlm8vejzXPFUJbvc918ALk2o=
X-Received: by 2002:a17:902:e405:: with SMTP id ci5mr19513402plb.224.1556992156123;
 Sat, 04 May 2019 10:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190502180610.10369-1-xiyou.wangcong@gmail.com> <4d2d89b1-f52b-a978-75a5-39522e3eef05@gmail.com>
In-Reply-To: <4d2d89b1-f52b-a978-75a5-39522e3eef05@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 4 May 2019 10:49:05 -0700
Message-ID: <CAM_iQpV4CJVXP0STJs-MWREkU1uxg5HsvMpTkiRfpK7Smz-J9g@mail.gmail.com>
Subject: Re: [Patch net-next] sch_htb: redefine htb qdisc overlimits
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 4, 2019 at 8:41 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/2/19 2:06 PM, Cong Wang wrote:
> > In commit 3c75f6ee139d ("net_sched: sch_htb: add per class overlimits counter")
> > we added an overlimits counter for each HTB class which could
> > properly reflect how many times we use up all the bandwidth
> > on each class. However, the overlimits counter in HTB qdisc
> > does not, it is way bigger than the sum of each HTB class.
> > In fact, this qdisc overlimits counter increases when we have
> > no skb to dequeue, which happens more often than we run out of
> > bandwidth.
> >
> > It makes more sense to make this qdisc overlimits counter just
> > be a sum of each HTB class, in case people still get confused.
> >
> > I have verified this patch with one single HTB class, where HTB
> > qdisc counters now always match HTB class counters as expected.
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/sched/sch_htb.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> > index d27d9bc9d010..cece0d455985 100644
> > --- a/net/sched/sch_htb.c
> > +++ b/net/sched/sch_htb.c
> > @@ -177,6 +177,7 @@ struct htb_sched {
> >       int                     row_mask[TC_HTB_MAXDEPTH];
> >
> >       struct htb_level        hlevel[TC_HTB_MAXDEPTH];
> > +     u32                     overlimits;
> >  };
>
>
> Hi Cong, your patch makes sense, but I am not sure about the location of this field,
> as this might need another cache line miss.
>
> Maybe instead reduce 'long            direct_pkts;'  to 'u32 direct_pkts;' since we only export
> direct_pkts as 32bit quantity in the struct tc_htb_glob.
>
> Then move the 'u32 overlimits;' right after direct_pkts to fill the new hole.

Sure, v2 is coming. :)

Thanks for catching it.
