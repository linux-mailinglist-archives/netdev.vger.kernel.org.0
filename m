Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794F54BEBE5
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiBUUdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:33:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiBUUdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:33:37 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C41237CD;
        Mon, 21 Feb 2022 12:33:13 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id j15so20695154lfe.11;
        Mon, 21 Feb 2022 12:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lT/cTFTGuOMVY562Zcq6QgiQHBlKGMHAuT7cWShl1IU=;
        b=Lssx73IWPVPyrcM++eGPDsnnRqprvn/CA7h/khwYZOlhp1PDqSbHnF6uAwe2kPOsqN
         +2dkn7dtzjQS1Id0zIQoAU6Vp50pOI/+NnyMVIVgFMZUU5ZEmFix09Sgg5ouJ/rsQ1se
         ZQBi/2jWmaccMAyMw/0YKG59/xcTWxkbPOqDw1JIX1yv3JhOZ+REb7xtwOGpTp9pHDuP
         xi+Q5jDiixQgMpg/1wiwJmPVSxIs2LXAYCNchuQGiUSCkKX0tIq9VowpQg1Br91PYN7M
         fg6SbP9CNnHFcoKMXSyzbty6Cn3ONUnH/KBE7cWPRNeQUFBnERkgY251+WIKl4NVcl/7
         OiTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lT/cTFTGuOMVY562Zcq6QgiQHBlKGMHAuT7cWShl1IU=;
        b=PMI0L31ZpL+8nui3idA5LV6ZgoNjil4bBQFTec5vAz07aodXZnT5sG4x7sbsh3m88M
         29gJxAsw8rIW+LZ4nIb7ZbWvYI5p0An3obB7AuH5Mq8mBIBdSvxEQmLtrEOYWI8Ugpj2
         NR+3fMQJZ/i9WVdB2AZK7j8RayvRONyPWbU76LXAM5hmMeT0T3ypxboNCpRh2WJCde8q
         3jsdVtZrFg8935fhE16/DeAF8kLTUo1y7CDQ501CNvmaav4nwPLXwuAoF1e2oUECvy6C
         4Ev7SzyDoPnfhDiBYncRq42KTN9bNbX42eAJFVUmscVmv4yLFOtUPYrGqzT0qQF2VI9M
         iKGQ==
X-Gm-Message-State: AOAM531cAgFCHVA7o1joa2m0I7jZ52UZ5lszjYBEBl2zoYyU12XNxmWy
        phM/8qK9mmdjXabDRvwNmMMQssZsNWqKOkbp2Qo=
X-Google-Smtp-Source: ABdhPJzGsEiO7mztlvKhsV/v7X1ZRJQzwh79nu27J+9X9hVD177RWQEt4yGLy73i7MVfGq3HWZmzWdz6YLV4RZcWKw0=
X-Received: by 2002:a05:6512:1194:b0:43e:8e84:4eca with SMTP id
 g20-20020a056512119400b0043e8e844ecamr14595656lfr.611.1645475591888; Mon, 21
 Feb 2022 12:33:11 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
 <20220207144804.708118-15-miquel.raynal@bootlin.com> <CAB_54W45p6e5sY6O=yHq39vsN+h_Yi6e9=GGky+1vO_H3oUj9A@mail.gmail.com>
In-Reply-To: <CAB_54W45p6e5sY6O=yHq39vsN+h_Yi6e9=GGky+1vO_H3oUj9A@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 21 Feb 2022 15:33:00 -0500
Message-ID: <CAB_54W5YHhcOtZ6D7cgSvDb0cakoL5tJjrN7fX9jiK6x=gOTVQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 14/14] net: mac802154: Introduce a
 synchronous API for MLME commands
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

On Sun, Feb 20, 2022 at 6:52 PM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Mon, Feb 7, 2022 at 9:48 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > This is the slow path, we need to wait for each command to be processed
> > before continuing so let's introduce an helper which does the
> > transmission and blocks until it gets notified of its asynchronous
> > completion. This helper is going to be used when introducing scan
> > support.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/ieee802154_i.h | 1 +
> >  net/mac802154/tx.c           | 6 ++++++
> >  2 files changed, 7 insertions(+)
> >
> > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > index 295c9ce091e1..ad76a60af087 100644
> > --- a/net/mac802154/ieee802154_i.h
> > +++ b/net/mac802154/ieee802154_i.h
> > @@ -123,6 +123,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> >  void ieee802154_sync_and_stop_tx(struct ieee802154_local *local);
> > +void ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
> >  netdev_tx_t
> >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> >  netdev_tx_t
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index 06ae2e6cea43..7c281458942e 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -126,6 +126,12 @@ void ieee802154_sync_and_stop_tx(struct ieee802154_local *local)
> >         atomic_dec(&local->phy->hold_txs);
> >  }
> >
> > +void ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > +{
> > +       ieee802154_tx(local, skb);
> > +       ieee802154_sync_and_stop_tx(local);
>
> Some of those functions can fail, in async case we can do some stats
> but here we can deliver the caller an error. Please do so.
>

to more specify what I mean here is also to get an error if the async
transmit path ends with the error case and not success. You need to
put a tx result int a global pointer to return it here and fetch it
before wake_up() "ieee802154_sync_and_stop_tx()".

Also I think we ignore here the case that the interface goes down
waiting for tx completion which means we are calling stop() callback
on the driver layer. I am worried that if stop() happens during
ieee802154_mlme_tx() we are running in a deadlock because a "tx
complete" will never occur?

- Alex
