Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2294752B95A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiERL7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbiERL7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:59:54 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45C58BD14;
        Wed, 18 May 2022 04:59:52 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id q130so2236046ljb.5;
        Wed, 18 May 2022 04:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8h/z95IOEEjwauf5QbXsG9VCwDDtDFcI9tc/RWrPhpc=;
        b=R8JyENQfy4HDMNsl5wBoII7M1IFdDwgdwiLppNwyqhxuS8Q1iRyS2l4ac5LJkBsAd9
         IN0dR1esDRlAKroABvUzt1nf0UqPoONEzm+bwGJrLs29hsJ3pMIIHNRvuJAeFSszwtkF
         CmtYUgN84Im8C0i0Zod092pH+PMM8VgdHfLn11IpaOyjPP3r/yYIrowNihLm1V9QU415
         UfDpEqCgWAJofBeCVS5azNomlMk7R2t95p1Yy4/4+uKtV0oZrsZM1n57qKMpX5H862eM
         3AUiAmuXZMcmgp0H81W+b4Hz6RN9oHp3tLX/OOk29ejRvavwepbOCaAEpF2fDX3g+0Hg
         p6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8h/z95IOEEjwauf5QbXsG9VCwDDtDFcI9tc/RWrPhpc=;
        b=cUWrVpD75tRbFcsX6pBT2BhjWCycBO4TSc7xce2Sjswxs9099fLaKyfqsOnn4+oqN3
         /r6MrQ3377RHTjHc2My6GdpO6wi9+Z+BObeDJ4CGyyKus10J6LJ+W0BT+CHJ++I32svY
         d4FfG1d+tffT4JM1B2mfBebdUExigLegrX2t2v9gvcgaqERLsJWgn/9hrR/34D0RbZK/
         dhxotawIqZzqkNVqbYc+W447q54gub1aQOrfdmDMw35T6nT3i1owbESdD8M2u78azaeW
         xmin9oLe67rcmuFgaZadnmTMVPMjkGAuTZ/6r4BESmYT7I0WsUAYAakYY4LxljlRR4sf
         MqZg==
X-Gm-Message-State: AOAM533lP7u9QXHzI6qoUPyvhM5ukxwr43lx7qeIgps1G/XKXO5/Z7fT
        t+jy4HygwpC1Nr829qFYvNf7lZwM1m8HKbmeSyUiInNzmSBDDQ==
X-Google-Smtp-Source: ABdhPJxG5bnk99I8hvYAMvEOU3/OM47ixg0eYd+9pD+ZMCLn28/7LnVFV3JqSKu/cr5zLgef1YgbeTOwJJcFfQkpuls=
X-Received: by 2002:a2e:b7ca:0:b0:253:a418:59af with SMTP id
 p10-20020a2eb7ca000000b00253a41859afmr12548409ljo.397.1652875191128; Wed, 18
 May 2022 04:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
 <20220517163450.240299-10-miquel.raynal@bootlin.com> <CAK-6q+jQL7cFJrL6XjuaJnNDggtO1d_sB+T+GrY9yT+Y+KC0oA@mail.gmail.com>
 <20220518104435.76f5c0d5@xps-13>
In-Reply-To: <20220518104435.76f5c0d5@xps-13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 18 May 2022 07:59:37 -0400
Message-ID: <CAB_54W7bLZ8i7W-ZzQ2WXgMvywcC=tEDHZqbj1yWYuKoVgm1sw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <aahringo@redhat.com>,
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

On Wed, May 18, 2022 at 4:44 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Tue, 17 May 2022 20:41:41 -0400:
>
> > Hi,
> >
> > On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote:
> > >
> > > This is the slow path, we need to wait for each command to be processed
> > > before continuing so let's introduce an helper which does the
> > > transmission and blocks until it gets notified of its asynchronous
> > > completion. This helper is going to be used when introducing scan
> > > support.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  net/mac802154/ieee802154_i.h |  1 +
> > >  net/mac802154/tx.c           | 46 ++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 47 insertions(+)
> > >
> > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > > index a057827fc48a..b42c6ac789f5 100644
> > > --- a/net/mac802154/ieee802154_i.h
> > > +++ b/net/mac802154/ieee802154_i.h
> > > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > > +int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb);
> > >  netdev_tx_t
> > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> > >  netdev_tx_t
> > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > index 38f74b8b6740..6cc4e5c7ba94 100644
> > > --- a/net/mac802154/tx.c
> > > +++ b/net/mac802154/tx.c
> > > @@ -128,6 +128,52 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> > >         return ieee802154_sync_queue(local);
> > >  }
> > >
> > > +static int ieee802154_mlme_op_pre(struct ieee802154_local *local)
> > > +{
> > > +       return ieee802154_sync_and_hold_queue(local);
> > > +}
> > > +
> > > +static int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > +{
> > > +       int ret;
> > > +
> > > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> > > +        * MLME transmissions.
> > > +        */
> > > +       rtnl_lock();
> > > +
> > > +       /* Ensure the device was not stopped, otherwise error out */
> > > +       if (!local->open_count)
> > > +               return -EBUSY;
> > > +
> >
> > No -EBUSY here, use ?-ENETDOWN?.
>
> Isn't it strange to return "Network is down" while we try to stop the
> device but fail to do so because, actually, it is still being used?
>

you are right. Maybe -EPERM, in a sense of whether the netdev state
allows it or not.

- Alex
