Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AB73332DC
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 02:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhCJBsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 20:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCJBsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 20:48:15 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97695C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 17:48:14 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id dx17so34028012ejb.2
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 17:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jTgvBqQySss4c5yiYW3Pco6qn40GuvZl1mgVyGHofmU=;
        b=dSnJD1WfClg0IkJk551x4MiCJfkRuSV1FvNByLK2fz9CNM+VlGvtOK3PJj+2jIvlzd
         J+Q4zyKyza8zylfm04PnXGsmGGGA/oFoD69fKD3oJ9qTFEotBbLLYrMEbGTnh5FV+w8j
         YWkL5chubCYJWjNVe/hAYAwLKvgGWbtMfU81ADS+gTw9yBX1MYG3acko9XiQY8kYkiA6
         WoPZbYBaEiuAhvG7RaTgIQ2qYGK77hyfFnJRKGESbcx+FfHAG678PAm1w1uOi4+OityB
         D/t4p8a7ulap+1k+BL0nNehhmhPGtfq7X9JXxqX8ApTuf1oPAxjLHjuH6i8YoCltsdFE
         2ktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jTgvBqQySss4c5yiYW3Pco6qn40GuvZl1mgVyGHofmU=;
        b=dzhnBjMZAsOpbwW8Dnpi1XQLUjCt858U/f39WGg0y9t6aZnOU2E1TATIpAOi7H1XP5
         QEoDSIqV7TN7ORg7dFknGc4M80Q/XsIEDreB1FnZLgNLtdqah+RCD65XRF+S7J6BiwPp
         sBlaYM9P49AOiKtTaEp+XUdSxpHfTTrAqldJ66kIBK+FesjnRNnObT3Pp+w8dNdYI7a3
         gtr0oSdu78l6TaQtvvGMfRXKVC0fYBmX9HoVyou0zH9KKULJyxHg9jBjA5vjSGmLcy3K
         OAtAQhETXK2qb7zxK1Eprgq5+2/Qbe/Z5lhNy4SIJnoRdMZojMggmLMO/EYP1q7WV8gp
         uKSg==
X-Gm-Message-State: AOAM530F9S6AzgjSxQ1A8mUTFzK8TspK5JlSSu29gT1Z1QQas0y/p5mc
        w/gYvS5ic8oMS683uHO51EyrkFHPwerYudyS2JA=
X-Google-Smtp-Source: ABdhPJzGNhzO0m1glCaJXpNyHc4XQeIc6cgbCiMOngXVppZEQ7/MScEpL/jowZJrj8/w1q93KewqFJ1nOcbMEK96e+s=
X-Received: by 2002:a17:906:bc81:: with SMTP id lv1mr940424ejb.135.1615340893308;
 Tue, 09 Mar 2021 17:48:13 -0800 (PST)
MIME-Version: 1.0
References: <20210309031028.97385-1-xiangxia.m.yue@gmail.com> <CAKgT0UfZ0c4P4SMyCV9LAN=9PV=B6=0Ck+8jeZV4OxSGHnAuzg@mail.gmail.com>
In-Reply-To: <CAKgT0UfZ0c4P4SMyCV9LAN=9PV=B6=0Ck+8jeZV4OxSGHnAuzg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 10 Mar 2021 09:44:08 +0800
Message-ID: <CAMDZJNUobbEC0Z9Tu3jQcNu=Y-Fzzs2PpdZ-DE1v7TyMpc1R-w@mail.gmail.com>
Subject: Re: [PATCH] net: sock: simplify tw proto registration
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 1:39 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Mar 8, 2021 at 7:15 PM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Introduce a new function twsk_prot_init, inspired by
> > req_prot_init, to simplify the "proto_register" function.
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  net/core/sock.c | 44 ++++++++++++++++++++++++++++----------------
> >  1 file changed, 28 insertions(+), 16 deletions(-)
> >
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 0ed98f20448a..610de4295101 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -3475,6 +3475,32 @@ static int req_prot_init(const struct proto *prot)
> >         return 0;
> >  }
> >
> > +static int twsk_prot_init(const struct proto *prot)
> > +{
> > +       struct timewait_sock_ops *twsk_prot = prot->twsk_prot;
> > +
> > +       if (!twsk_prot)
> > +               return 0;
> > +
> > +       twsk_prot->twsk_slab_name = kasprintf(GFP_KERNEL, "tw_sock_%s",
> > +                                             prot->name);
> > +       if (!twsk_prot->twsk_slab_name)
> > +               return -ENOMEM;
> > +
> > +       twsk_prot->twsk_slab =
> > +               kmem_cache_create(twsk_prot->twsk_slab_name,
> > +                                 twsk_prot->twsk_obj_size, 0,
> > +                                 SLAB_ACCOUNT | prot->slab_flags,
> > +                                 NULL);
> > +       if (!twsk_prot->twsk_slab) {
> > +               pr_crit("%s: Can't create timewait sock SLAB cache!\n",
> > +                       prot->name);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
>
> So one issue here is that you have two returns but they both have the
> same error clean-up outside of the function. It might make more sense
> to look at freeing the kasprintf if the slab allocation fails and then
> using the out_free_request_sock_slab jump label below if the slab
> allocation failed.
Hi, thanks for your review.
if twsk_prot_init failed, (kasprintf, or slab alloc), we will invoke
the tw_prot_cleanup() to clean up
the sources allocated.
1. kfree(twsk_prot->twsk_slab_name); // if name is NULL, kfree() will
return directly
2. kmem_cache_destroy(twsk_prot->twsk_slab); // if slab is NULL,
kmem_cache_destroy() will return directly too.
so we don't care what err in twsk_prot_init().

and req_prot_cleanup() will clean up all sources allocated for req_prot_init().

> >  int proto_register(struct proto *prot, int alloc_slab)
> >  {
> >         int ret = -ENOBUFS;
> > @@ -3496,22 +3522,8 @@ int proto_register(struct proto *prot, int alloc_slab)
> >                 if (req_prot_init(prot))
> >                         goto out_free_request_sock_slab;
> >
> > -               if (prot->twsk_prot != NULL) {
> > -                       prot->twsk_prot->twsk_slab_name = kasprintf(GFP_KERNEL, "tw_sock_%s", prot->name);
> > -
> > -                       if (prot->twsk_prot->twsk_slab_name == NULL)
> > -                               goto out_free_request_sock_slab;
> > -
> > -                       prot->twsk_prot->twsk_slab =
> > -                               kmem_cache_create(prot->twsk_prot->twsk_slab_name,
> > -                                                 prot->twsk_prot->twsk_obj_size,
> > -                                                 0,
> > -                                                 SLAB_ACCOUNT |
> > -                                                 prot->slab_flags,
> > -                                                 NULL);
> > -                       if (prot->twsk_prot->twsk_slab == NULL)
> > -                               goto out_free_timewait_sock_slab;
> > -               }
> > +               if (twsk_prot_init(prot))
> > +                       goto out_free_timewait_sock_slab;
>
> So assuming the code above takes care of freeing the slab name in case
> of slab allocation failure then this would be better off jumping to
> out_free_request_sock_slab.
>
> >         }
> >
> >         mutex_lock(&proto_list_mutex);
> > --
> > 2.27.0
> >



-- 
Best regards, Tonghao
