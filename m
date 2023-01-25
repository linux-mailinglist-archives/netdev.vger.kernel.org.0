Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC86667AF0D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbjAYKAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjAYKAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:00:03 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6846B4997B;
        Wed, 25 Jan 2023 02:00:01 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 19623FF80E;
        Wed, 25 Jan 2023 09:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674640799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b32jowcL09Pq3mOJpkXEjTseoNMw15SMTSszTjV1ZG0=;
        b=Ve3aa/ssUj7kATRuuiCEZFjL13lKl7+3YXNoyJm+VO+bFStA4+KmggbzKIC3WqdjDfs/6q
        UujqKFUa3O7ogc/LFMUSvGa1tagPqW2CMWpUTT8bfjtWOs1bWqH4ffO8eLfGzy6wT0fejo
        R94dPGTlnE/9rqBvgnbePR2lcAKRidq/boc/gIDRgmCRua/OJ76ok2ZwycRT/yZ8qYgeMh
        Dtix3aGeQJa0oTKmspmUYGRDFmD11ZfymNGdM1IN2i1C25u/zt/col+VksRElRwN0jt9uH
        HPzpa61pVP0ds/ULaN7M7TxPO4eOpSMlhZ62+9lqhyu3kEqNTbXAzCcOBg1XIQ==
Date:   Wed, 25 Jan 2023 10:59:56 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Alexander Aring <aahringo@redhat.com>,
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
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
Message-ID: <20230125105653.44e9498f@xps-13>
In-Reply-To: <CAB_54W69KcM0UJjf8py-VyRXx2iEUvcAKspXiAkykkQoF6ccDA@mail.gmail.com>
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
        <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
        <20230118102058.3b1f275b@xps-13>
        <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
        <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com>
        <20230124110814.6096ecbe@xps-13>
        <CAB_54W69KcM0UJjf8py-VyRXx2iEUvcAKspXiAkykkQoF6ccDA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Tue, 24 Jan 2023 21:31:33 -0500:

> Hi,
>=20
> On Tue, Jan 24, 2023 at 5:08 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Mon, 23 Jan 2023 09:02:48 -0500:
> > =20
> > > Hi,
> > >
> > > On Mon, Jan 23, 2023 at 9:01 AM Alexander Aring <aahringo@redhat.com>=
 wrote: =20
> > > >
> > > > Hi,
> > > >
> > > > On Wed, Jan 18, 2023 at 4:21 AM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote: =20
> > > > >
> > > > > Hi Alexander,
> > > > >
> > > > > aahringo@redhat.com wrote on Sun, 15 Jan 2023 20:54:02 -0500:
> > > > > =20
> > > > > > Hi,
> > > > > >
> > > > > > On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@boo=
tlin.com> wrote: =20
> > > > > > >
> > > > > > > Scanning being now supported, we can eg. play with hwsim to v=
erify
> > > > > > > everything works as soon as this series including beaconing s=
upport gets
> > > > > > > merged.
> > > > > > > =20
> > > > > >
> > > > > > I am not sure if a beacon send should be handled by an mlme hel=
per
> > > > > > handling as this is a different use-case and the user does not =
trigger
> > > > > > an mac command and is waiting for some reply and a more complex
> > > > > > handling could be involved. There is also no need for hotpath x=
mit
> > > > > > handling is disabled during this time. It is just an async mess=
aging
> > > > > > in some interval and just "try" to send it and don't care if it=
 fails,
> > > > > > or? For mac802154 therefore I think we should use the dev_queue=
_xmit()
> > > > > > function to queue it up to send it through the hotpath?
> > > > > >
> > > > > > I can ack those patches, it will work as well. But I think we s=
hould
> > > > > > switch at some point to dev_queue_xmit(). It should be simple to
> > > > > > switch it. Just want to mention there is a difference which wil=
l be
> > > > > > there in mac-cmds like association. =20
> > > > >
> > > > > I see what you mean. That's indeed true, we might just switch to
> > > > > a less constrained transmit path.
> > > > > =20
> > > >
> > > > I would define the difference in bypass qdisc or not. Whereas the
> > > > qdisc can drop or delay transmitting... For me, the qdisc is curren=
tly
> > > > in a "works for now" state. =20
> > >
> > > probably also bypass other hooks like tc, etc. :-/ Not sure if we wan=
t that. =20
> >
> > Actually, IIUC, we no longer want to go through the entire net stack.
> > We still want to bypass it but without stopping/flushing the full
> > queue like with an mlme transmission, so what about using
> > ieee802154_subif_start_xmit() instead of dev_queue_xmit()? I think it
> > is more appropriate. =20
>=20
> I do not understand, what do we currently do with mlme ops via the
> ieee802154_subif_start_xmit() function, or? So we bypass everything
> from dev_queue_xmit() until do_xmit() netdev callback.

Yes, that's the plan. We don't want any of the net stack features when
sending beacons.

> I think it is fine, also I think "mostly" only dataframes should go
> through dev_queue_xmit(). With a HardMAC transceiver we would have
> control about "mostly" other frames than data either. So we should do
> everything with mlme-ops do what the spec says (to match up with
> HardMAC behaviour?) and don't allow common net hooks/etc. to change
> this behaviour?

To summarize:
- Data frames -> should go through dev_queue_xmit()
- MLME ops with feedback constraints -> should go through the slow MLME
  path, so ieee802154_mlme_tx*()
- MLME ops without feedback constraints like beacons -> should go
  through the hot path, but not through the whole net stack, so
  ieee802154_subif_start_xmit()

Right now only data frames have security support, I propose we merge
the initial support like that. Right now I am focused on UWB support
(coming next, after the whole active scan/association additions), and
in a second time we would be interested in llsec support for MLME ops.

Does that sounds like a plan? If yes, I'll send a v2 with the right
transmit helper used.

Thanks,
Miqu=C3=A8l

NB: Perhaps a prerequisites of bringing security to the MLME ops would
be to have wpan-tools updated (it looks like the support was never
merged?) as well as a simple example how to use it on linux-wpan.org.
