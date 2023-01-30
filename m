Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03824680A32
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbjA3J4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbjA3Jzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:55:49 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82032F7AC;
        Mon, 30 Jan 2023 01:55:25 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BE88C20009;
        Mon, 30 Jan 2023 09:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675072514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1q99COeEhSgAwyVTxW/RO7yjBL/O8JQ1iE+OT9BH0A=;
        b=QIN7FUYzn0dtmRGBp0w2TVIW7uDeHwZcmXcfcPutBehGK13ZbLZKEc5pwaqrF9+AJEjB3y
        BSKTgdxIEJa4lZZXkCNxf5mhTAX6am3nW5b6dAts/HViLKiLy5j4mQbWdE+1hL3x9oXWDS
        h+1LWDaCCWZNDw/HxYIFukN2VOzn+G4MRw6JD7XPqD+dbE4u8mN/B0twRfw0sjC7S9NJd1
        dKiQW3oeKppfl+VvXprV05BUH64jZq2b2gFwOKgg74KT1A07t5dQ5jIuitIlAejnVsbeQs
        wNnLcc8+1kalJIy/UPfxEbbry1ca6EIlUSE6NfosMZkLN5gzeyCDrIO+jlcsMQ==
Date:   Mon, 30 Jan 2023 10:55:08 +0100
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
Message-ID: <20230130105508.38a25780@xps-13>
In-Reply-To: <CAK-6q+hoquVswZTm+juLasQzUJpGdO+aQ7Q3PCRRwYagge5dTw@mail.gmail.com>
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
        <CAK-6q+jN1bnP1FdneGrfDJuw3r3b=depEdEP49g_t3PKQ-F=Lw@mail.gmail.com>
        <CAK-6q+hoquVswZTm+juLasQzUJpGdO+aQ7Q3PCRRwYagge5dTw@mail.gmail.com>
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

aahringo@redhat.com wrote on Thu, 26 Jan 2023 20:48:02 -0500:

> Hi,
>=20
> On Thu, Jan 26, 2023 at 8:45 PM Alexander Aring <aahringo@redhat.com> wro=
te:
> >
> > Hi,
> >
> > On Wed, Jan 25, 2023 at 5:31 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > Scanning being now supported, we can eg. play with hwsim to verify
> > > everything works as soon as this series including beaconing support g=
ets
> > > merged.
> > >
> > > Thanks,
> > > Miqu=C3=A8l
> > >
> > > Changes in v2:
> > > * Clearly state in the commit log llsec is not supported yet.
> > > * Do not use mlme transmission helpers because we don't really need to
> > >   stop the queue when sending a beacon, as we don't expect any feedba=
ck
> > >   from the PHY nor from the peers. However, we don't want to go throu=
gh
> > >   the whole net stack either, so we bypass it calling the subif helper
> > >   directly.
> > > =20
>=20
> moment, we use the mlme helpers to stop tx=20

No, we no longer use the mlme helpers to stop tx when sending beacons
(but true MLME transmissions, we ack handling and return codes will be
used for other purposes).

> but we use the
> ieee802154_subif_start_xmit() because of the possibility to invoke
> current 802.15.4 hooks like llsec? That's how I understand it.

We go through llsec (see ieee802154_subif_start_xmit() implementation)
when we send data or beacons. When we send beacons, for now, we just
discard the llsec logic. This needs of course to be improved. We will
probably need some llsec handling in the mlme case as well in the near
future.

Thanks,
Miqu=C3=A8l
