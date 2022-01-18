Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996CF493148
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 00:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350245AbiARXRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 18:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350210AbiARXRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 18:17:12 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94BCC061574;
        Tue, 18 Jan 2022 15:17:11 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 25-20020a05600c231900b003497473a9c4so9725748wmo.5;
        Tue, 18 Jan 2022 15:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hpNABAszGuVpxLc3lpQ79Hz8gFpkuzCxa0RSxtlG1RI=;
        b=BRDNqNxZHOXG+8Jt349mcRICKlSguBVuby+UM69nKn+t+QlSDIi0xTcFkc+DFhzX/v
         8roefkeaDTpQOW5qvWEkmU2uXDtfmI+lAzWztLwXi+M7elCLe4AZ/0yKTVeL+YXVnTYP
         xv+dB6BI2Tn6eXNGOCx+eIogqGd2qgW1P9iuzulZVUOcDiMqqkDyjZu7MTJXnesLnDzH
         sXPw0HmZC4NLlwV2gPkhSWXcwi5AbPeOoKXVIZG/6xVECU/tvJSvXkxiwumF6TzMvNSn
         UmTPqHLxLCwcnoB4bCJTCu58hdqvdKgRZB5Eq8S01lYMG2Jdj9huNjo+6nJU+YV5yviE
         h16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hpNABAszGuVpxLc3lpQ79Hz8gFpkuzCxa0RSxtlG1RI=;
        b=xcKT1eGgmmmnRxhWelEga6zhJmmNd7apUnzPxfXzTs8sU+5EgW+9S/2+UXGZSBL/44
         +5WTJMsQcgejeKW9nph7b3dQi4XO4ZBjl87Ux3BYStoPIL2KScU4cf2UAivHL3MSY4wL
         bYzjq33SJi2t43s5Lql98985NdECzr3oAeeEMRDLyi8BboPwQPLdsaRIxMIOEZAYFbeF
         sIRtTSUG7Wl63x3G+Li9urvzRt6kEBCeD/BKykEvDllziugfmhnUY3JyVrh7t0zEvD+E
         AsYGRT4zIT0puv5In3ck464ifQp/0RTyPaJNheiWwtO4/cbPc7XdiNArOnFe1XLoLFlX
         yC6A==
X-Gm-Message-State: AOAM530Q2ZUuu3LafysxaubLnwtq7TBm2rEmV4wKgcfksOzJ8oxeTuro
        vnYTQVCmm1BBaZ1eaagTk41R9cPssfbhLHk3DXc=
X-Google-Smtp-Source: ABdhPJzlelPa9D9XssWdoFH+QStXJsK6EOXHLzDiIHOmXJ/Jy+KMDXjAe4ukSDLgVMib63OKAI8GBWzORyOrUEMo1s0=
X-Received: by 2002:adf:d1c7:: with SMTP id b7mr20769142wrd.81.1642547830541;
 Tue, 18 Jan 2022 15:17:10 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
 <20220117115440.60296-28-miquel.raynal@bootlin.com> <CAB_54W562uzk3NzXDTgRLbQzi=hgQDntJOqmMDVZwaJ_eDZZMQ@mail.gmail.com>
 <20220118191429.19ea3c7d@xps13>
In-Reply-To: <20220118191429.19ea3c7d@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 18 Jan 2022 18:16:59 -0500
Message-ID: <CAB_54W4XpccNtQa1MNH8uPwsi-95dHj8SJMXRgiWOJsy7FhRyA@mail.gmail.com>
Subject: Re: [PATCH v3 27/41] net: mac802154: Introduce a tx queue flushing mechanism
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

On Tue, 18 Jan 2022 at 13:14, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Mon, 17 Jan 2022 17:43:49 -0500:
>
> > Hi,
> >
> > On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...
> > >
> > >         /* stop hardware - this must stop RX */
> > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > > index 0291e49058f2..37d5438fdb3f 100644
> > > --- a/net/mac802154/ieee802154_i.h
> > > +++ b/net/mac802154/ieee802154_i.h
> > > @@ -122,6 +122,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> > >
> > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > > +void ieee802154_sync_tx(struct ieee802154_local *local);
> > >  netdev_tx_t
> > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> > >  netdev_tx_t
> > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > index de5ecda80472..d1fd2cc67cbe 100644
> > > --- a/net/mac802154/tx.c
> > > +++ b/net/mac802154/tx.c
> > > @@ -48,6 +48,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
> > >
> > >         kfree_skb(skb);
> > >         atomic_dec(&local->phy->ongoing_txs);
> > > +       wake_up(&local->phy->sync_txq);
> >
> > if (atomic_dec_and_test(&hw->phy->ongoing_txs))
> >       wake_up(&hw->phy->sync_txq);
>
> As we test this condition in the waiting path I assumed it was fine to
> do it this way, but the additional check does not hurt, so I'll add it.

it's just a nitpick... to avoid scheduling and this triggers a
checking if the condition is true in cases we know it can't....

although we can talk about this because ongoing_txs should never be
higher than 1... so any atomic_dec() should make the condition true...

- Alex
