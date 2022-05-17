Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C7D52A36F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347813AbiEQNbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347847AbiEQNay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:30:54 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2E0DFD0;
        Tue, 17 May 2022 06:30:50 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 56CC8240012;
        Tue, 17 May 2022 13:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652794249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMfOpTgcEbu3EpZVSKfpa5HDynTgAT8/eYq8vW0Qg0w=;
        b=Kksfx9sL7zOWrnb2cgknIEscypRaYPv7+qWkollCVn8QqxIgIizjUswXGjYGzZHJmiaabL
        7jcJksId8F8EohJ34M336M5PSpMqBf/sHkA/wrmiARWIedQFq4x+cRHh4Yoro1QOhVJAz0
        4+3lrtcLs0bml2+ECMiCDFUFbYF3/5z2AWQRqxL9SyMtoxTg9ohfggp9V15FqnUO3CeB/9
        eg+SjCmXTSEsnXIlJxdbr0EnuPzJt9e5VYLx8pOFW61onTXzxu/DQuSWBQy198BTH1L/mc
        eHMyKCPUiKA9z67yQlfoJYEmLoOj9tfH5RLmNVpzJJQP++Jx0bH6em/rJK5K2w==
Date:   Tue, 17 May 2022 15:30:45 +0200
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
Message-ID: <20220517153045.73fda4ee@xps-13>
In-Reply-To: <CAK-6q+i_T+FaK0tX6tF38VjyEfSzDi-QC85MTU2=4soepAag8g@mail.gmail.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
        <20220512143314.235604-10-miquel.raynal@bootlin.com>
        <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
        <CAK-6q+i_T+FaK0tX6tF38VjyEfSzDi-QC85MTU2=4soepAag8g@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


aahringo@redhat.com wrote on Sun, 15 May 2022 19:03:53 -0400:

> Hi,
>=20
> On Sun, May 15, 2022 at 6:28 PM Alexander Aring <aahringo@redhat.com> wro=
te:
> >
> > Hi,
> >
> > On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote: =20
> > >
> > > This is the slow path, we need to wait for each command to be process=
ed
> > > before continuing so let's introduce an helper which does the
> > > transmission and blocks until it gets notified of its asynchronous
> > > completion. This helper is going to be used when introducing scan
> > > support.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  net/mac802154/ieee802154_i.h |  1 +
> > >  net/mac802154/tx.c           | 25 +++++++++++++++++++++++++
> > >  2 files changed, 26 insertions(+)
> > >
> > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_=
i.h
> > > index a057827fc48a..f8b374810a11 100644
> > > --- a/net/mac802154/ieee802154_i.h
> > > +++ b/net/mac802154/ieee802154_i.h
> > > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_=
wpan;
> > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *s=
kb);
> > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buf=
f *skb);
> > >  netdev_tx_t
> > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device=
 *dev);
> > >  netdev_tx_t
> > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > index 38f74b8b6740..ec8d872143ee 100644
> > > --- a/net/mac802154/tx.c
> > > +++ b/net/mac802154/tx.c
> > > @@ -128,6 +128,31 @@ int ieee802154_sync_and_hold_queue(struct ieee80=
2154_local *local)
> > >         return ieee802154_sync_queue(local);
> > >  }
> > >
> > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buf=
f *skb)
> > > +{
> > > +       int ret;
> > > +
> > > +       /* Avoid possible calls to ->ndo_stop() when we asynchronousl=
y perform
> > > +        * MLME transmissions.
> > > +        */
> > > +       rtnl_lock(); =20
> >
> > I think we should make an ASSERT_RTNL() here, the lock needs to be
> > earlier than that over the whole MLME op. MLME can trigger more than =20
>=20
> not over the whole MLME_op, that's terrible to hold the rtnl lock so
> long... so I think this is fine that some netdev call will interfere
> with this transmission.
> So forget about the ASSERT_RTNL() here, it's fine (I hope).
>=20
> > one message, the whole sync_hold/release queue should be earlier than
> > that... in my opinion is it not right to allow other messages so far
> > an MLME op is going on? I am not sure what the standard says to this,
> > but I think it should be stopped the whole time? All those sequence =20
>=20
> Whereas the stop of the netdev queue makes sense for the whole mlme-op
> (in my opinion).

I might still implement an MLME pre/post helper and do the queue
hold/release calls there, while only taking the rtnl from the _tx.

And I might create an mlme_tx_one() which does the pre/post calls as
well.

Would something like this fit?

Thanks,
Miqu=C3=A8l
