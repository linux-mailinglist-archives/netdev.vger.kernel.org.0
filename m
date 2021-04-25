Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1545D36A7B9
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhDYORA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 10:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhDYOQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 10:16:59 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8C3C061756
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 07:16:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f15-20020a05600c4e8fb029013f5599b8a9so1681491wmq.1
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9jEHbT2HPU07YWp8UIpvxV0HKIyl8Sn3Z1db3mhpjS4=;
        b=Ot6WOmtm/69oaFZX0wjMQfJ2sx/lD+5YRiLSkyHDqkPn//qLX5oRVlSV6aUi/63fyF
         GTsO1Xu9iCa81pxXYuhl42cNlSlMzOff2IzfBqWfzUr54ihaDO+hw4MNxy86Fehnw2ix
         GevCs6aFgwukTpl5easln80WvfjLXLtWgK6g6u4ginkwzgjbfJ4w2SDoH9auDAchHmiA
         GojwaJAKttPQkouLBOybtbavQxv2c24FMd/cpODrOHyCqE4zSNgm+Ff9fkAORN+RhCU7
         0XxWru7EGVbFhdhNtS8OutwFnoO0mqCrYj5wba2NEsWzI0qHYcVQfcRKLey0U1ojPDNJ
         kOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9jEHbT2HPU07YWp8UIpvxV0HKIyl8Sn3Z1db3mhpjS4=;
        b=IqJ6exP5QCmi0uLeehLUmXM6mJkZ7RVOxjuKlNMzryyAW7etLX7QWBNmZV1UMZR1S8
         ye6/ExWZP47Awksxga2opkW6bxJOAZauURH1joppWR13W+nwRAPXT1dVwte93pG2gLUj
         BxHD2nKGUKWrv3K+2Y9L6JRq485zrzvZ8H5+nBPRzhx3jCxLaBChk3EmSRFyAycvF+H7
         lALoPDWwexaBbwWq7aUDDEf88wc2IdWC1BdusUkColxY8r1R+HEh9KoB1p20pWPi4tSa
         iQnyKgMjjIqxILA5eIhQ6S+a8i1/7PBpgPeOGKhvTorx3xPOf2hfU2GJb3zamnkl3Rn6
         PfSg==
X-Gm-Message-State: AOAM530fvz1LAaem+LtnuKhWUGhKsubRcd1VM1DR8wBNX6PYzd5aWvOB
        55GzJDDVlhQEiz1jVCr09s5pDcf9wkb9Bcm8Jtuc/w==
X-Google-Smtp-Source: ABdhPJx4DBUvbpkKeXuR8l7ZvZxnyRIpkd/fdESWjROrRlTUb9N7zU7ISNw3RLEjxk1i1gSXxoESGOHrz5JkpJPziFk=
X-Received: by 2002:a1c:3587:: with SMTP id c129mr14232332wma.80.1619360177569;
 Sun, 25 Apr 2021 07:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210425095249.177588-1-erik@flodin.me> <20210425122222.223839-1-erik@flodin.me>
 <20210425122701.qbalhfsbybip2fci@pengutronix.de>
In-Reply-To: <20210425122701.qbalhfsbybip2fci@pengutronix.de>
From:   Erik Flodin <erik@flodin.me>
Date:   Sun, 25 Apr 2021 16:16:06 +0200
Message-ID: <CAAMKmofSsfP4SZ_At4VqGYVfo7-i+q1Hqrxdfmk79kS+tjtsvg@mail.gmail.com>
Subject: Re: [PATCH v3] can: proc: fix rcvlist_* header alignment on 64-bit system
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 25 Apr 2021 at 14:27, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 25.04.2021 14:22:12, Erik Flodin wrote:
> > Before this fix, the function and userdata columns weren't aligned:
> >   device   can_id   can_mask  function  userdata   matches  ident
> >    vcan0  92345678  9fffffff  0000000000000000  0000000000000000         0  raw
> >    vcan0     123    00000123  0000000000000000  0000000000000000         0  raw
> >
> > After the fix they are:
> >   device   can_id   can_mask      function          userdata       matches  ident
> >    vcan0  92345678  9fffffff  0000000000000000  0000000000000000         0  raw
> >    vcan0     123    00000123  0000000000000000  0000000000000000         0  raw
> >
> > Signed-off-by: Erik Flodin <erik@flodin.me>
> > ---
> >  net/can/proc.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/can/proc.c b/net/can/proc.c
> > index 5ea8695f507e..35b6c7512785 100644
> > --- a/net/can/proc.c
> > +++ b/net/can/proc.c
> > @@ -205,8 +205,11 @@ static void can_print_recv_banner(struct seq_file *m)
> >        *                  can1.  00000000  00000000  00000000
> >        *                 .......          0  tp20
> >        */
> > -     seq_puts(m, "  device   can_id   can_mask  function"
> > -                     "  userdata   matches  ident\n");
> > +#ifdef CONFIG_64BIT
> > +     seq_puts(m, "  device   can_id   can_mask      function          userdata       matches  ident\n");
> > +#else
> > +     seq_puts(m, "  device   can_id   can_mask  function  userdata   matches  ident\n");
> > +#endif
>
> Please use "if (IS_ENABLED(CONFIG_64BIT))" as in your example in your
> previous mail.

Ok. I've sent a new patch, but of course I forgot to add -v4. Sorry about that.

// Erik
