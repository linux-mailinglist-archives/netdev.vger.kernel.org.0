Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F725FFCCE
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 03:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJPBAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 21:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJPBAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 21:00:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938A42C10D
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 18:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665882009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hYsQV77jSVZ1xo/DJ7SyfJsKSPF5nuGhpJ71epheuCI=;
        b=bx0VOb3OP6AQkaQ9mGu59n22wbGpKKh5Jom/6o5tDlijSsJ7EKxivC9XcCCMsIpxyKctMT
        fKDvnJPIAr7bJBzrt8QE18BY0UA4QwKhwYapFa4vrl5jRqaScTfrDMmWCWHys5p/D0wJ/l
        CzXSFZunI4oPu6drLMkC/Hhf+IOzyvE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-OqrHrCyZN3Wbdx3ymrwZXQ-1; Sat, 15 Oct 2022 21:00:08 -0400
X-MC-Unique: OqrHrCyZN3Wbdx3ymrwZXQ-1
Received: by mail-wm1-f72.google.com with SMTP id c3-20020a7bc843000000b003b486fc6a40so3863754wml.7
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 18:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYsQV77jSVZ1xo/DJ7SyfJsKSPF5nuGhpJ71epheuCI=;
        b=WUaZ4jFNOY1bDlCU1USMXDO4MFKriCiizXU4nbeA3RXvGfK/g9U/RYfy5rDiIAaDMk
         BWg+4FwNFji4n30KwgoksmQJZDJxi8T4d0lJO1vLaUuVzndzdFN2OH0RBI3x/aoXiUpp
         KhBXNfK6TrBJ/n46ITpvNvR0ug2KcrWZ4rFuquaubGwY5dEkKAj0QDxXTyZ/PCaNwv1c
         58ogX4NpmaniqhL1m26EDO+ZcHYM2l4W2T44XLsFttNjTXkAL2mA+2FMf6MQV0mtEVE5
         vozfs04HXLb5XnE6keEGzQyrh74BpHQFQNneDTAwuOcBA/ygj6+IrMh1mDJVI7xo1rld
         bY0g==
X-Gm-Message-State: ACrzQf1iyNvbHvq5r3hv1pf/xm1lPhoqfx3ieYfm9yfzaj0qrFN9QcQV
        hyMM/iXt58VuniCMq2ejwyQnebjSr1jMJmztzyBa3NpQ0e91miw+/ASjCsyrRgv1z4jPKc8v968
        19f+87OLDismATrZjZavmY6aQOJbdP3lB
X-Received: by 2002:a05:600c:510e:b0:3b4:fed8:e65c with SMTP id o14-20020a05600c510e00b003b4fed8e65cmr2883878wms.93.1665882007018;
        Sat, 15 Oct 2022 18:00:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM66HPDxlXvYzsqrga5jABjfOB5xiJMXx7sbgnn4jYzeoaIdfmXlF6XrUgOtw9Z8Dmo+83EndNOj/1gwm66a0gw=
X-Received: by 2002:a05:600c:510e:b0:3b4:fed8:e65c with SMTP id
 o14-20020a05600c510e00b003b4fed8e65cmr2883860wms.93.1665882006813; Sat, 15
 Oct 2022 18:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
 <20221007085310.503366-6-miquel.raynal@bootlin.com> <CAK-6q+iun+K8F6Mv3=WLL92iZnv-9oSnoRYtY4Zex2DZqS8ABQ@mail.gmail.com>
 <CAK-6q+iKf5bXX+EPBw9utCpAoBVjZ678na0V_n4GUes5O=NLLw@mail.gmail.com>
 <CAK-6q+hO1AFzdH_DRYVM77VJhotsoeiBzqL0o7ND7sPYJhSrbQ@mail.gmail.com> <20221012155828.5a5cade8@xps-13>
In-Reply-To: <20221012155828.5a5cade8@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 15 Oct 2022 20:59:55 -0400
Message-ID: <CAK-6q+jAr9qFY6dB6tYuycHyMNX=Ge9k4sJS38O_eRdvgLhnAA@mail.gmail.com>
Subject: Re: [PATCH wpan/next v4 5/8] ieee802154: hwsim: Implement address filtering
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Oct 15, 2022 at 4:59 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Mon, 10 Oct 2022 21:21:17 -0400:
>
> > Hi,
> >
> > On Mon, Oct 10, 2022 at 9:13 PM Alexander Aring <aahringo@redhat.com> wrote:
> > >
> > > Hi,
> > >
> > > On Mon, Oct 10, 2022 at 9:04 PM Alexander Aring <aahringo@redhat.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Fri, Oct 7, 2022 at 4:53 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > We have access to the address filters being theoretically applied, we
> > > > > also have access to the actual filtering level applied, so let's add a
> > > > > proper frame validation sequence in hwsim.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  drivers/net/ieee802154/mac802154_hwsim.c | 111 ++++++++++++++++++++++-
> > > > >  include/net/ieee802154_netdev.h          |   8 ++
> > > > >  2 files changed, 117 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> > > > > index 458be66b5195..84ee948f35bc 100644
> > > > > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > > > > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > > > > @@ -18,6 +18,7 @@
> > > > >  #include <linux/netdevice.h>
> > > > >  #include <linux/device.h>
> > > > >  #include <linux/spinlock.h>
> > > > > +#include <net/ieee802154_netdev.h>
> > > > >  #include <net/mac802154.h>
> > > > >  #include <net/cfg802154.h>
> > > > >  #include <net/genetlink.h>
> > > > > @@ -139,6 +140,113 @@ static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > +static void hwsim_hw_receive(struct ieee802154_hw *hw, struct sk_buff *skb,
> > > > > +                            u8 lqi)
> > > > > +{
> > > > > +       struct ieee802154_hdr hdr;
> > > > > +       struct hwsim_phy *phy = hw->priv;
> > > > > +       struct hwsim_pib *pib;
> > > > > +
> > > > > +       rcu_read_lock();
> > > > > +       pib = rcu_dereference(phy->pib);
> > > > > +
> > > > > +       if (!pskb_may_pull(skb, 3)) {
> > > > > +               dev_dbg(hw->parent, "invalid frame\n");
> > > > > +               goto drop;
> > > > > +       }
> > > > > +
> > > > > +       memcpy(&hdr, skb->data, 3);
> > > > > +
> > > > > +       /* Level 4 filtering: Frame fields validity */
> > > > > +       if (hw->phy->filtering == IEEE802154_FILTERING_4_FRAME_FIELDS) {
> > >
> > > I see, there is this big if handling. But it accesses the
> > > hw->phy->filtering value. It should be part of the hwsim pib setting
> > > set by the driver callback. It is a question here of mac802154 layer
> > > setting vs driver layer setting. We should do what the mac802154 tells
> > > the driver to do, this way we do what the mac802154 layer is set to.
> > >
> > > However it's a minor thing and it's okay to do it so...
> >
> > * whereas we never let the driver know at any time of what different
> > filter levels exist _currently_ we have only the promiscuous mode
> > on/off switch which is do nothing or 4_FRAME_FIELDS.
> > It will work for now, changing anything in the mac802154 filtering
> > fields or something will end in probably breakage in this handling. In
> > my point of view as the current state is it should not do that, as
> > remember that hwsim will "simulate" hardware it should not be able to
> > access mac802154 fields (especially when doing receiving of frames) as
> > other hardware will only set register bits (as hwsim pib values is
> > there for)...
> >
> > Still I think it's fine for now.
>
> I see your point, indeed I could have added another PIB attribute
> instead of accessing the PHY state.
>
> I am fine doing it in a followup patch if this what you prefer. Shall I
> do it?

okay, note that you did it right with the address filter patches by
copying them from the drivers-ops.

- Alex

