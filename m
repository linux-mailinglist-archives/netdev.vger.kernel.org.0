Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF82689E08
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjBCPXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjBCPWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:22:42 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D4ADB9E;
        Fri,  3 Feb 2023 07:20:35 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6F43A40010;
        Fri,  3 Feb 2023 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675437586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tp5Vgf/Ob1ObcE6p8TL7YtXZJrFawIZnDEoObtmNSyk=;
        b=PiSBPmBiZ+I+B7Y8bCZ03lCektGABZp9qf9MRVCCZG14QNT3/luANzY/ZjUr+hTTjagEv/
        baP4iTTmvXnS/IVRC2C3JxHllbbF4Pv0Oba+A2L1OYsKYm8qqQu/QNWV1VwEkqr8I2IpxD
        dDIWIx1gVlKKBl+/gfL3pSt01KLxLrK+bhreN26f745/DfXTWMBfr3l2MjmMACLmUo1CDF
        gtAgpNC7p4al/lf2znIwfv6uKO/yt+E+e/DfqSh+p4KASnU0hjsNlWXjyEz0oasuOj2JVJ
        9FCTcZQF40kNHsI1tpO22bqKTl8kJRUn5Jq1wR0H/Dn746wcfUVc6g2e7M6peQ==
Date:   Fri, 3 Feb 2023 16:19:43 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 0/2] ieee802154: Beaconing support
Message-ID: <20230203161943.076ec169@xps-13>
In-Reply-To: <CAK-6q+hAgyx3YML7Lw=MAkUX4i8PVqxSKiVzeAM-wGJOdL9aXA@mail.gmail.com>
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
        <CAK-6q+jN1bnP1FdneGrfDJuw3r3b=depEdEP49g_t3PKQ-F=Lw@mail.gmail.com>
        <CAK-6q+hoquVswZTm+juLasQzUJpGdO+aQ7Q3PCRRwYagge5dTw@mail.gmail.com>
        <20230130105508.38a25780@xps-13>
        <CAK-6q+gqQgFxqBUAhHDMaWv9VfuKa=bCVee_oSLQeVtk_G8=ow@mail.gmail.com>
        <20230131122525.7bd35c2b@xps-13>
        <CAK-6q+hAgyx3YML7Lw=MAkUX4i8PVqxSKiVzeAM-wGJOdL9aXA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Wed, 1 Feb 2023 12:15:42 -0500:

> Hi,
>=20
> On Tue, Jan 31, 2023 at 6:25 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> > =20
> > > > > > > Changes in v2:
> > > > > > > * Clearly state in the commit log llsec is not supported yet.
> > > > > > > * Do not use mlme transmission helpers because we don't reall=
y need to
> > > > > > >   stop the queue when sending a beacon, as we don't expect an=
y feedback
> > > > > > >   from the PHY nor from the peers. However, we don't want to =
go through
> > > > > > >   the whole net stack either, so we bypass it calling the sub=
if helper
> > > > > > >   directly.
> > > > > > > =20
> > > > >
> > > > > moment, we use the mlme helpers to stop tx =20
> > > >
> > > > No, we no longer use the mlme helpers to stop tx when sending beaco=
ns
> > > > (but true MLME transmissions, we ack handling and return codes will=
 be
> > > > used for other purposes).
> > > > =20
> > >
> > > then we run into an issue overwriting the framebuffer while the normal
> > > transmit path is active? =20
> >
> > Crap, yes you're right. That's not gonna work.
> >
> > The net core acquires HARD_TX_LOCK() to avoid these issues and we are
> > no bypassing the net core without taking care of the proper frame
> > transmissions either (which would have worked with mlme_tx_one()). So I
> > guess there are two options:
> >
> > * Either we deal with the extra penalty of stopping the queue and
> >   waiting for the beacon to be transmitted with an mlme_tx_one() call,
> >   as proposed initially.
> >
> > * Or we hardcode our own "net" transmit helper, something like:
> >
> > mac802154_fast_mlme_tx() {
> >         struct net_device *dev =3D skb->dev;
> >         struct netdev_queue *txq;
> >
> >         txq =3D netdev_core_pick_tx(dev, skb, NULL);
> >         cpu =3D smp_processor_id();
> >         HARD_TX_LOCK(dev, txq, cpu);
> >         if (!netif_xmit_frozen_or_drv_stopped(txq))
> >                 netdev_start_xmit(skb, dev, txq, 0);
> >         HARD_TX_UNLOCK(dev, txq);
> > }
> >
> > Note1: this is very close to generic_xdp_tx() which tries to achieve the
> > same goal: sending packets, bypassing qdisc et al. I don't know whether
> > it makes sense to define it under mac802154/tx.c or core/dev.c and give
> > it another name, like generic_tx() or whatever would be more
> > appropriate. Or even adapting generic_xdp_tx() to make it look more
> > generic and use that function instead (without the xdp struct pointer).
> > =20
>=20
> The problem here is that the transmit handling is completely
> asynchronous. Calling netdev_start_xmit() is not "transmit and wait
> until transmit is done", it is "start transmit here is the buffer" an
> interrupt is coming up to report transmit is done. Until the time the
> interrupt isn't arrived the framebuffer on the device is in use, we
> don't know when the transceiver is done reading it. Only after tx done
> isr. The time until the isr isn't arrived is for us a -EBUSY case due
> hardware resource limitation. Currently we do that with stop/wake
> queue to avoid calling of xmit_do() to not run into such -EBUSY
> cases...
>=20
> There might be clever things to do here to avoid this issue... I am
> not sure how XDP does that.
>=20
> > Note2: I am wondering if it makes sense to disable bh here as well? =20
>=20
> May HARD_TX_LOCK() already do that? If they use spin_lock_bh() they
> disable local softirqs until the lock isn't held anymore.

I saw a case where both are called so I guess the short answer is "no":
https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L4307

>=20
> >
> > Once we settle, I send a patch.
> > =20
>=20
> Not sure how to preceded here, but do see the problem? Or maybe I
> overlooked something here...

No you clearly had a sharp eye on that one, I totally see the problem.

Maybe the safest and simplest approach would be to be back using
the proper mlme transmission helpers for beacons (like in the initial
proposal). TBH I don't think there is a huge performance hit because in
both cases we wait for that ISR saying "the packet has been consumed by
the transceiver". It's just that in one case we wait for the return
code (MLME) and then return, in the other case we return but no
more packets will go through until the queue is released by the ISR (as
you said, in order to avoid the -EBUSY case). So in practice I don't
expect any performance hit. It is true however that we might want to
optimize this a little bit if we ever add something like an async
callback saying "skb consumed by the transceiver, another can be
queued" and gain a few us. Maybe a comment could be useful here (I'll
add it to my fix if we agree).

Thanks,
Miqu=C3=A8l
