Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5D44C2170
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiBXCBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 21:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiBXCBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 21:01:07 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AE911475D;
        Wed, 23 Feb 2022 18:00:37 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id g39so1358220lfv.10;
        Wed, 23 Feb 2022 18:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jr3vLCh3McX6Cb5cZOVDkIoTNKV1Xdcfb9Z/9yFm1nk=;
        b=TMbydranrHntVLdwvABPy5OpskFbUlNXtl3SAkDQ3KNl9hx+MgcFXGDqm0f5yrgCoF
         E7i1U0KWVk2SpIy7iskx5iDKZuQxX080gK4ocYTZhChGysp755umdR675oRT48RZr6QA
         K0Z1PSBtX9e4WBXSIHfwjkz5nwo+cXVRHJzlUG/ITzVhoE6zuAV+petxbSD14hXi5Dki
         yiFXDjDSizYZmvjxr2ONltv7WDMRmTS/sjb/FQPg4c7qG0a+s9X9OmrhiHj0ubBDiQ4I
         6O6sKIHKsFe1DA+7l/oLPNtkeQQPPXjOdT5ENuS/+tVqriyvKmWSJ3wHTtQMO0No361z
         8HFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jr3vLCh3McX6Cb5cZOVDkIoTNKV1Xdcfb9Z/9yFm1nk=;
        b=KG5wQDpU/FPgq3a5qQQHCQu1iwFEC14rlOPreWLtdvhFBMjut/7yRU1sHjw6D7bnhL
         VGqjH2ZCKf0/Om6sr03+KL7//hCZT1N8YT4pJtX/v55c5yl8GjI8Tm5S2XrH1Mt0AeG9
         9EvOfL5VXH6fr0M3clqos5n7mTWP/J5r8LNB+eRGjU+8nr47hd8ZzWFfxG950GlyybFD
         ctVqDcNnLAr5O+lW5VLIjUyuJcALiU5Dju+IQVGBdhTAlpunj/gsldeIzQpy+nrO3n3r
         YF+cz4z8+a3ufCRgQnhku6BNFEG5Kg6zGIFCmGPo4W3YIBiIYYjo8Y5YsG7Xapw6qjRm
         LTQA==
X-Gm-Message-State: AOAM532kJ1H77Rr2AHvJY7o1PnpQXuaJFAuiYM2uEKF/ARjIWPO7F2mR
        wGhHx8NccrZ1IP9o4i7Dqi28o9G2s/jpAOQZS88=
X-Google-Smtp-Source: ABdhPJzvXTmFTje2Am5pFcJEJaeRR1PFtouJqf93TA64f33iqawx3HtbeLWmi1WzD0rR0TcGxk+I0Okgal1Oy6/Xz5o=
X-Received: by 2002:a05:6512:114c:b0:443:4d18:86c0 with SMTP id
 m12-20020a056512114c00b004434d1886c0mr396497lfg.226.1645668035544; Wed, 23
 Feb 2022 18:00:35 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
 <20220207144804.708118-5-miquel.raynal@bootlin.com> <CAB_54W5X+zN1YvN9SL32NVFCbqFbiR2GE-r132SXkpMKN21FhQ@mail.gmail.com>
In-Reply-To: <CAB_54W5X+zN1YvN9SL32NVFCbqFbiR2GE-r132SXkpMKN21FhQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 23 Feb 2022 21:00:23 -0500
Message-ID: <CAB_54W6Rs1tkzkOvgQuMKNtFrWY+OZjhUZ-t2qh9QdmZOHAsvw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 04/14] net: ieee802154: atusb: Call
 _xmit_error() when a transmission fails
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Feb 20, 2022 at 6:35 PM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Mon, Feb 7, 2022 at 9:48 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > ieee802154_xmit_error() is the right helper to call when a transmission
> > has failed. Let's use it instead of open-coding it.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/atusb.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> > index f27a5f535808..0e6f180b4e79 100644
> > --- a/drivers/net/ieee802154/atusb.c
> > +++ b/drivers/net/ieee802154/atusb.c
> > @@ -271,9 +271,7 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
> >                  * unlikely case now that seq == expect is then true, but can
> >                  * happen and fail with a tx_skb = NULL;
> >                  */
> > -               ieee802154_wake_queue(atusb->hw);
> > -               if (atusb->tx_skb)
> > -                       dev_kfree_skb_irq(atusb->tx_skb);
> > +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb, false);
> >
> Are you sure you can easily convert this? You should introduce a
> "ieee802154_xmit_error_irq()"?

Should be fine as you are using dev_kfree_skb_any().

- Alex
