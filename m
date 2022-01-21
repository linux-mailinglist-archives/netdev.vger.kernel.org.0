Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4838495737
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 01:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378330AbiAUAJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 19:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378263AbiAUAJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 19:09:45 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4208FC061574;
        Thu, 20 Jan 2022 16:09:45 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z22so35550346edd.12;
        Thu, 20 Jan 2022 16:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gw/h4vDMmF3+S7EBe5K4ziFvlvlytBdM5BlobMQKulw=;
        b=j3VgtGIHCzMGUtcaBUk3HX8vfsoCeSRq7WWcOr7aa2IhB3v+sw8BThefgpNAnXJVVc
         gVn6gBHaPBOgFRKj2Pg0/To0quSEgThemkcP1mB7oODgJ8qFKcs0hy17T+E0TZC7swIR
         EjCItK5kqdPE/O7JZF1tSHiSmTi/FP5J3tov4sl9K245WJChDRR8gyX0Ut95LOTO5nJi
         eAiS2I3GFGCqUubXnAj+035pOxE/0VheoL5SoR4GPZGuimg3asZHMwiHUEjVCCA/xQdU
         m3j1cta3ux6Pny6G5QQAyfYuhhu/3JLpZX7hkthTX7ebdTSCZjE5Y2bq7axLiz9uulmE
         NtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gw/h4vDMmF3+S7EBe5K4ziFvlvlytBdM5BlobMQKulw=;
        b=iJJDUrzuzfKiiCwjgC0VD+soxgfA+gVkqESLFQ1VxvYipu5VAB4LknB7Ufgvh8VeC9
         chqFzABHTlt1UfU4RwF5sD6ywVeOtRnFOcztYkOxxiWLfRoVxDj6r5y/dKApLKzKFRTY
         8OeHSoL3ulIqvlHp3f4jjtZO14SJjJOEBcJSg1hud/Po6Ej25rrz9EpMkOouiuhesv7Q
         W55FeQzY0EsL/G8KlJUyqqo4IKGJELRh0S06fiW4MKiTPWg4ilq8ks/QmONbEO3nN9rf
         u/DzhP5QjkrAJHNwDViXsb4BkRdTm95honU18HC3yTC7ovXTKqKR7GquREjGAVTKhabU
         88+Q==
X-Gm-Message-State: AOAM530NJ/6Zt/mmYtu9GPss3vDuczEr8x/WIu/D6ry33UXzEIE7SZ0a
        4URS/FLj5UtqA6g4zzW7n4PDipHNzBZI/YAMNC8=
X-Google-Smtp-Source: ABdhPJyQn+mOHFJZrOYebRjS+uMv8nCAFM5TjZduZoR2Fj7UZv7m7Bg4fmpRmyg5QPHtTZ27s7tJtbZkOhWluzSfePU=
X-Received: by 2002:a17:907:a42a:: with SMTP id sg42mr1185976ejc.413.1642723783502;
 Thu, 20 Jan 2022 16:09:43 -0800 (PST)
MIME-Version: 1.0
References: <20220120130605.55741-1-dzm91@hust.edu.cn> <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
In-Reply-To: <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 21 Jan 2022 08:09:17 +0800
Message-ID: <CAD-N9QWvfoo_HtQ+KT-7JNFumQMaq8YqMkHGR2t7pDKsDW0hkQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: remove a dangling pointer in peak_usb_create_dev
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 10:27 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Hi Dongliang,
>
> On 1/20/22 16:05, Dongliang Mu wrote:
> > From: Dongliang Mu <mudongliangabcd@gmail.com>
> >
> > The error handling code of peak_usb_create_dev forgets to reset the
> > next_siblings of previous entry.
> >
> > Fix this by nullifying the (dev->prev_siblings)->next_siblings in the
> > error handling code.
> >
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >   drivers/net/can/usb/peak_usb/pcan_usb_core.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > index b850ff8fe4bd..f858810221b6 100644
> > --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > @@ -894,6 +894,9 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
> >               dev->adapter->dev_free(dev);
> >
> >   lbl_unregister_candev:
> > +     /* remove the dangling pointer in next_siblings */
> > +     if (dev->prev_siblings)
> > +             (dev->prev_siblings)->next_siblings = NULL;
> >       unregister_candev(netdev);
> >
> >   lbl_restore_intf_data:
>
>
> Is this pointer used somewhere? I see, that couple of
> struct peak_usb_adapter::dev_free() functions use it, but
> peak_usb_disconnect() sets dev->next_siblings to NULL before calling
> ->dev_free().
>
> Do you have a calltrace or oops log?

Hi Pavel,

I have no calltrace or log since this dangling pointer may not be
dereferenced in the following code. But I am not sure. So the commit
title of this patch is "remove a dangling pointer in
peak_usb_create_dev".

>
>
>
>
> With regards,
> Pavel Skripkin
