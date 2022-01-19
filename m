Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE774943E5
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 00:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344538AbiASXfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 18:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiASXfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 18:35:02 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69DDC061574;
        Wed, 19 Jan 2022 15:35:01 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id e9-20020a05600c4e4900b0034d23cae3f0so9266122wmq.2;
        Wed, 19 Jan 2022 15:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9YlhDwZwhJdseLFri8B+QmEyJ1DKDdqZmCn1rJgVyQ8=;
        b=M+Qx+tUaIlaog0g0TlMl8WptFfR4UZgFar8XgUCC4h2Ve+b4eZIsBzPqhjBFs3KSjM
         QIEeT7O6VSswkKrGMtxAJs07R5OR1tZUDjmQvj+QeznNS9H73YuaxSajdOiyXyzJy8zx
         k1MKUZEzJvOIkzjMqprp80dSOtJmZwzthzYuJCBP9kUSIa2bBDQ3PjisY7j0TUem+JEk
         1RLe4tpcW1ckQg5jlipopAmDxpBewqrWDhpVky052r1dZIqLR5kxHxwEYUOuZWerq3Qg
         wm9PEjV33eTIgBHG4BVKoyAFz3Ihg7lLFj/ikkFm+KUfvvKdZkU6KOxOlU/2TQ0zAqbt
         mJNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9YlhDwZwhJdseLFri8B+QmEyJ1DKDdqZmCn1rJgVyQ8=;
        b=ewNhdmmeDmUx+0ui3dxuiZoacOrYuwTCfkBrUnYhEoyQ1Z+CGoMftkm//XWYC9pcBt
         tbsJCbcoNCZgv435jMdjh6bEQzaX9MSsGM/rjO0AGNtUBzG+ANilDi6RuOGkOcI4R6Z0
         +g9rKXJobEfNz3iWPDycFEL0pamDNSSulvjZQjsLk8OPD28i2szu3kkWHPiwvm2Jl3jg
         VUimwGGdvoOA0Q+vj6YdpziMWAN7KjBI8hOQfpFvUstBL5Mg7UQzx+L5ZmmZNP1vvq41
         rr6cJc9P9vZzQjhuTSyaEZ5HM1asZ3qxIuRqSS+h+pcZZfdw5XZiDfRNjEdbb0+VNdh3
         VrWw==
X-Gm-Message-State: AOAM530PK9SLdn44rWX2MO5AS/v/bm+Uu32LfUN8O/+TKx37JUunycci
        EaJj2Sez2gqHR4FjDOKX+Q8Pnuo3hoohp9EQ7VuepuKWF56xBA==
X-Google-Smtp-Source: ABdhPJwkrFTcJtiN4MoGeyGFPFKtOyTMqGuf36PzelChwHd63J6t647y6fKToUm2BmWU22EqVFyJr0V2a735b++vGn0=
X-Received: by 2002:adf:fa8d:: with SMTP id h13mr7838453wrr.154.1642635300064;
 Wed, 19 Jan 2022 15:35:00 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
 <20220117115440.60296-18-miquel.raynal@bootlin.com> <CAB_54W76X5vhaVMUv=s3e0pbWZgHRK3W=27N9m5LgEdLgAPAcA@mail.gmail.com>
 <CAB_54W5Uu9_hpqmeL0MC+1ps=yfn2j0-o46cBL7BeBxKXKHa4w@mail.gmail.com> <20220119235600.48173f5b@xps13>
In-Reply-To: <20220119235600.48173f5b@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 19 Jan 2022 18:34:49 -0500
Message-ID: <CAB_54W4Dy13=EMD0ZEvwX6HLC3bM=nAp0esqDXBj9T+9Jjd_aw@mail.gmail.com>
Subject: Re: [PATCH v3 17/41] net: ieee802154: at86rf230: Call the complete
 helper when a transmission is over
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 19 Jan 2022 at 17:56, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Mon, 17 Jan 2022 19:36:39 -0500:
>
> > Hi,
> >
> > On Mon, 17 Jan 2022 at 19:34, Alexander Aring <alex.aring@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > ieee802154_xmit_complete() is the right helper to call when a
> > > > transmission is over. The fact that it completed or not is not really a
> > > > question, but drivers must tell the core that the completion is over,
> > > > even if it was canceled. Do not call ieee802154_wake_queue() manually,
> > > > in order to let full control of this task to the core.
> > > >
> > > > By using the complete helper we also avoid leacking the skb structure.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  drivers/net/ieee802154/at86rf230.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> > > > index 583f835c317a..1941e1f3d2ef 100644
> > > > --- a/drivers/net/ieee802154/at86rf230.c
> > > > +++ b/drivers/net/ieee802154/at86rf230.c
> > > > @@ -343,7 +343,7 @@ at86rf230_async_error_recover_complete(void *context)
> > > >         if (ctx->free)
> > > >                 kfree(ctx);
> > > >
> > > > -       ieee802154_wake_queue(lp->hw);
> > > > +       ieee802154_xmit_complete(lp->hw, lp->tx_skb, false);
> > >
> > > also this lp->tx_skb can be a dangled pointer, after xmit_complete()
> > > we need to set it to NULL in a xmit_error() we can check on NULL
> > > before calling kfree_skb().
> > >
> >
> > forget the NULL checking, it's already done by core. However in some
> > cases this is called with a dangled pointer on lp->tx_skb.
>
> Actually I don't see why tx_skb is dangling?
>
> There is no function that could accesses lp->tx_skb between the free
> operation and the next call to ->xmit() which does a lp->tx_skb = skb.
> Am I missing something?
>

look into at86rf230_sync_state_change() it is a sync over async and
the function "at86rf230_async_error_recover_complete()" is a generic
error handling to recover from a state change. It's e.g. being used in
e.g. at86rf230_start() which can occur in cases which are not xmit
related.

Indeed there is no dangled pointer in the irq handling, sorry. I
thought maybe the receive handling but the transceiver is doing a lot
of its own state change handling because of some framebuffer
protection which is not the case.

- Alex
