Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D6852B79F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiERKMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 06:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbiERKMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 06:12:13 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181B254BE2;
        Wed, 18 May 2022 03:12:05 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 083F024000D;
        Wed, 18 May 2022 10:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652868724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zKOUE0TgP5jaR7ivGzIVvaKmVq+SAlnHg4cFTu46AG8=;
        b=dDyEqKE57zPFmAdYArPS75gz7yw066DLEznh5H32h54lkKQd84vj2AbX7xM5m8Ar8wUL8V
        JuC10JSafSQMlkSVAg4iAvlRsvwrPbEFwkzUVsR6Sd5vrjjeSGQBk3jt6hXRpVH6BET6BW
        cGznbrTjiznmDmSMHpNBWfcoHkh80SvlesD76nhf4gEg0mNJ62c77xRDQ2cwQLucz19q3H
        uH5KV8PXnTF+/B9Hqkf5GF1zl/SqkLBOhyZZ8F8RfO01lcMJnLowClu2HG2aiU0OlzkTWj
        zPaW2Sj01PR0QVTBuWtS+6MeqAd+f4UxBUIE0D3bzn6kLgkU1U75Ki9hY4DEbA==
Date:   Wed, 18 May 2022 12:12:00 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
Message-ID: <20220518121200.2f08a6b1@xps-13>
In-Reply-To: <CAK-6q+h1fmJZobmUG5bUL3uXuQLv0kvHUv=7dW+fOCcgbrdPiA@mail.gmail.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
        <20220512143314.235604-10-miquel.raynal@bootlin.com>
        <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
        <CAK-6q+i_T+FaK0tX6tF38VjyEfSzDi-QC85MTU2=4soepAag8g@mail.gmail.com>
        <20220517153045.73fda4ee@xps-13>
        <CAK-6q+h1fmJZobmUG5bUL3uXuQLv0kvHUv=7dW+fOCcgbrdPiA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


aahringo@redhat.com wrote on Tue, 17 May 2022 21:14:03 -0400:

> Hi,
> 
> On Tue, May 17, 2022 at 9:30 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> >
> > aahringo@redhat.com wrote on Sun, 15 May 2022 19:03:53 -0400:
> >  
> > > Hi,
> > >
> > > On Sun, May 15, 2022 at 6:28 PM Alexander Aring <aahringo@redhat.com> wrote:  
> > > >
> > > > Hi,
> > > >
> > > > On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
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
> > > > >  net/mac802154/tx.c           | 25 +++++++++++++++++++++++++
> > > > >  2 files changed, 26 insertions(+)
> > > > >
> > > > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > > > > index a057827fc48a..f8b374810a11 100644
> > > > > --- a/net/mac802154/ieee802154_i.h
> > > > > +++ b/net/mac802154/ieee802154_i.h
> > > > > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> > > > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> > > > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > > > >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > > > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
> > > > >  netdev_tx_t
> > > > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> > > > >  netdev_tx_t
> > > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > > index 38f74b8b6740..ec8d872143ee 100644
> > > > > --- a/net/mac802154/tx.c
> > > > > +++ b/net/mac802154/tx.c
> > > > > @@ -128,6 +128,31 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> > > > >         return ieee802154_sync_queue(local);
> > > > >  }
> > > > >
> > > > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > > +{
> > > > > +       int ret;
> > > > > +
> > > > > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> > > > > +        * MLME transmissions.
> > > > > +        */
> > > > > +       rtnl_lock();  
> > > >
> > > > I think we should make an ASSERT_RTNL() here, the lock needs to be
> > > > earlier than that over the whole MLME op. MLME can trigger more than  
> > >
> > > not over the whole MLME_op, that's terrible to hold the rtnl lock so
> > > long... so I think this is fine that some netdev call will interfere
> > > with this transmission.
> > > So forget about the ASSERT_RTNL() here, it's fine (I hope).
> > >  
> > > > one message, the whole sync_hold/release queue should be earlier than
> > > > that... in my opinion is it not right to allow other messages so far
> > > > an MLME op is going on? I am not sure what the standard says to this,
> > > > but I think it should be stopped the whole time? All those sequence  
> > >
> > > Whereas the stop of the netdev queue makes sense for the whole mlme-op
> > > (in my opinion).  
> >
> > I might still implement an MLME pre/post helper and do the queue
> > hold/release calls there, while only taking the rtnl from the _tx.
> >
> > And I might create an mlme_tx_one() which does the pre/post calls as
> > well.
> >
> > Would something like this fit?  
> 
> I think so, I've heard for some transceiver types a scan operation can
> take hours... but I guess whoever triggers that scan in such an
> environment knows that it has some "side-effects"...

Yeah, a scan requires the data queue to be stopped and all incoming
packets to be dropped (others than beacons, ofc), so users must be
aware of this limitation.
