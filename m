Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F035552BC06
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbiERNCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbiERNC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:02:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D0931A15E5
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652878947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=26+FtxAyDSee114FFzjWc880ZgZ9UasEOBq5NaLMQQw=;
        b=ErM/iy/ZRmFR3JvTPymtGstmc+hTNMmtLvDpuRGfZNQzMozrhjiYEiZ03QpbVTYLL1ZyEe
        yqokuORdk+H4xPF2BWMzVyNCQTiTrg0ISRKDmVWFceg5wiT2JLMacuPH5AH6zCh6H57sMb
        tTgW7+HBQlSH984lSerrn67P/zRX13Q=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-M-1kaDl0Pf2LESQeXyH_qA-1; Wed, 18 May 2022 09:02:18 -0400
X-MC-Unique: M-1kaDl0Pf2LESQeXyH_qA-1
Received: by mail-qk1-f199.google.com with SMTP id 63-20020a370c42000000b006a063777620so1459768qkm.21
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=26+FtxAyDSee114FFzjWc880ZgZ9UasEOBq5NaLMQQw=;
        b=tLJywjkwr1F/7RTfSOJRYOeG2+AN2zHri0pFwGSkaZa9y7AcJOuojT2i2naRhtcFSS
         ZWT47p9U0TuH3qt+3hNQGFeRtfzu2QbSwG/NqoVEyWs0YJMAhEe6bvwvosSRESnlECzj
         5sOvP/5WJbZVqTPxLu9vec4ShIoxjZpYzkpJceWCfPPYoJVMgCwbVDsBXIlulD944e+T
         6rgsYuPm3XSkZvmjK4GLG+R5mhHfm0OH4ctqmEDui+sVQJQvVhNF957M7PY0XutvJ84X
         kh1ktEa/HBfWkEVtQj9jmbUiFNyHbzcbZXvaS649wQzW8IdcgJsF5GFKtyUn07SpI04I
         2zUQ==
X-Gm-Message-State: AOAM532aZz2rshkifS+0mORNqBUkBjM8b48ZdkD7Im3FAjBVEFLp8bz0
        gPnMX1MtKdcoi6elBIMKjLTDlMx4VkKfsZF9VVgpfVV57dPo1iIi7A3tzPt2Gs1eqiv6y5xwds4
        K5X6hbmP/QlhCXSWzotPZjmUA+AbrJ0Jr
X-Received: by 2002:a05:620a:40c2:b0:6a0:2b1b:2b86 with SMTP id g2-20020a05620a40c200b006a02b1b2b86mr19835932qko.80.1652878937552;
        Wed, 18 May 2022 06:02:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnFWyk/GFoqRtsoFDMM4I4sdLDOupubSU3bNq6KIaRSKj4+PPP/KbaemKa+vrhaEm7pC3RYyUdTfgir3t456M=
X-Received: by 2002:a05:620a:40c2:b0:6a0:2b1b:2b86 with SMTP id
 g2-20020a05620a40c200b006a02b1b2b86mr19835901qko.80.1652878937233; Wed, 18
 May 2022 06:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
 <20220517163450.240299-10-miquel.raynal@bootlin.com> <CAK-6q+jQL7cFJrL6XjuaJnNDggtO1d_sB+T+GrY9yT+Y+KC0oA@mail.gmail.com>
 <20220518104435.76f5c0d5@xps-13> <CAB_54W7bLZ8i7W-ZzQ2WXgMvywcC=tEDHZqbj1yWYuKoVgm1sw@mail.gmail.com>
 <20220518144405.3ff900ea@xps-13>
In-Reply-To: <20220518144405.3ff900ea@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 18 May 2022 09:02:06 -0400
Message-ID: <CAK-6q+iq3FPC8+bCtRRdYAT7vJuyWKc=KcfqqvT4EJRTBuOmHg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, May 18, 2022 at 8:44 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
>
> alex.aring@gmail.com wrote on Wed, 18 May 2022 07:59:37 -0400:
>
> > Hi,
> >
> > On Wed, May 18, 2022 at 4:44 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Tue, 17 May 2022 20:41:41 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> > > > <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > This is the slow path, we need to wait for each command to be processed
> > > > > before continuing so let's introduce an helper which does the
> > > > > transmission and blocks until it gets notified of its asynchronous
> > > > > completion. This helper is going to be used when introducing scan
> > > > > support.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  net/mac802154/ieee802154_i.h |  1 +
> > > > >  net/mac802154/tx.c           | 46 ++++++++++++++++++++++++++++++++++++
> > > > >  2 files changed, 47 insertions(+)
> > > > >
> > > > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > > > > index a057827fc48a..b42c6ac789f5 100644
> > > > > --- a/net/mac802154/ieee802154_i.h
> > > > > +++ b/net/mac802154/ieee802154_i.h
> > > > > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> > > > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> > > > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > > > >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > > > > +int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb);
> > > > >  netdev_tx_t
> > > > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> > > > >  netdev_tx_t
> > > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > > index 38f74b8b6740..6cc4e5c7ba94 100644
> > > > > --- a/net/mac802154/tx.c
> > > > > +++ b/net/mac802154/tx.c
> > > > > @@ -128,6 +128,52 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> > > > >         return ieee802154_sync_queue(local);
> > > > >  }
> > > > >
> > > > > +static int ieee802154_mlme_op_pre(struct ieee802154_local *local)
> > > > > +{
> > > > > +       return ieee802154_sync_and_hold_queue(local);
> > > > > +}
> > > > > +
> > > > > +static int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > > +{
> > > > > +       int ret;
> > > > > +
> > > > > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> > > > > +        * MLME transmissions.
> > > > > +        */
> > > > > +       rtnl_lock();
> > > > > +
> > > > > +       /* Ensure the device was not stopped, otherwise error out */
> > > > > +       if (!local->open_count)
> > > > > +               return -EBUSY;
> > > > > +
> > > >
> > > > No -EBUSY here, use ?-ENETDOWN?.
> > >
> > > Isn't it strange to return "Network is down" while we try to stop the
> > > device but fail to do so because, actually, it is still being used?
> > >
> >
> > you are right. Maybe -EPERM, in a sense of whether the netdev state
> > allows it or not.
>
> Actually you were right in your fist review, "!open_count" means
> that the net iface is down, so returning -ENETDOWN is fine, I believe.
>
ah yes, you confused me!

- Alex

