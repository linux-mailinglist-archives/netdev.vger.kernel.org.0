Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB3369A76D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjBQIuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 03:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjBQIuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:50:11 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B1360A44;
        Fri, 17 Feb 2023 00:49:51 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B43D860005;
        Fri, 17 Feb 2023 08:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676623790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OqSTNY12eMQk9ivoe5sTff2Ona6DuGlG6HMjgvpXEdM=;
        b=DErwtZk8edoOppBPru4Bj9O3EUQFpdSrCpWVws1UASR2g2QcueLasNKlHF5sbDWvzpNhE0
        +jaOeWmn81F+Ma/+gCTbuIhlCemjx25JhTT7CDmBGv9MJp/buIuvWPRTh99vYUUVOs+25F
        eFgs02uo128LpFTwwrP8XaqGazomZon3MDawcPnvEz+i+vtubDBUZtdlbv/z/rPEFKN2Mb
        ZFuB6H24mo1qh6yDnRHGj1ZkDYM4oXvyksjUYsAbk2cOnsOTZc+NkMxuY+i2Y/HNKeXCSO
        71m/8Sofwzt3KT/RLu1DpIM0DDwZLxmVWuIN4Hdf80u6d3uPkUXSWKyigOBMaQ==
Date:   Fri, 17 Feb 2023 09:49:45 +0100
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
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230217094945.0f0cdd81@xps-13>
In-Reply-To: <CAK-6q+h2TzWYHJVmPekgze6uqkSkA5G7Mu-FHSzSXUfD8ATb9g@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
        <20230206101235.0371da87@xps-13>
        <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
        <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com>
        <20230213183535.05e62c1c@xps-13>
        <CAK-6q+hkJpqNG9nO_ugngjGQ_q9VdLu+xDjmD09MT+5=tvd0QA@mail.gmail.com>
        <CAK-6q+jU7-ETKeoM=MLmfyMUqywteBC8sUAndRF1vx0PgA+WAA@mail.gmail.com>
        <20230214150600.1c21066b@xps-13>
        <20230214154632.69e8e339@xps-13>
        <CAK-6q+h2TzWYHJVmPekgze6uqkSkA5G7Mu-FHSzSXUfD8ATb9g@mail.gmail.com>
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

aahringo@redhat.com wrote on Thu, 16 Feb 2023 23:37:01 -0500:

> Hi,
>=20
> On Tue, Feb 14, 2023 at 9:46 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> >
> > miquel.raynal@bootlin.com wrote on Tue, 14 Feb 2023 15:06:00 +0100:
> > =20
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Tue, 14 Feb 2023 08:53:57 -0500:
> > > =20
> > > > Hi,
> > > >
> > > > On Tue, Feb 14, 2023 at 8:34 AM Alexander Aring <aahringo@redhat.co=
m> wrote: =20
> > > > >
> > > > > Hi,
> > > > >
> > > > > On Mon, Feb 13, 2023 at 12:35 PM Miquel Raynal
> > > > > <miquel.raynal@bootlin.com> wrote: =20
> > > > > >
> > > > > > Hi Alexander,
> > > > > > =20
> > > > > > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb=
, struct genl_info *info)
> > > > > > > > > > > +{
> > > > > > > > > > > +       struct cfg802154_registered_device *rdev =3D =
info->user_ptr[0];
> > > > > > > > > > > +       struct net_device *dev =3D info->user_ptr[1];
> > > > > > > > > > > +       struct wpan_dev *wpan_dev =3D dev->ieee802154=
_ptr;
> > > > > > > > > > > +       struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > > > > > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > > > > > +       u8 type;
> > > > > > > > > > > +       int err;
> > > > > > > > > > > +
> > > > > > > > > > > +       /* Monitors are not allowed to perform scans =
*/
> > > > > > > > > > > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_M=
ONITOR)
> > > > > > > > > > > +               return -EPERM; =20
> > > > > > > > > >
> > > > > > > > > > btw: why are monitors not allowed? =20
> > > > > > > > >
> > > > > > > > > I guess I had the "active scan" use case in mind which of=
 course does
> > > > > > > > > not work with monitors. Maybe I can relax this a little b=
it indeed,
> > > > > > > > > right now I don't remember why I strongly refused scans o=
n monitors. =20
> > > > > > > >
> > > > > > > > Isn't it that scans really work close to phy level? Means i=
n this case
> > > > > > > > we disable mostly everything of MAC filtering on the transc=
eiver side.
> > > > > > > > Then I don't see any reasons why even monitors can't do any=
thing, they
> > > > > > > > also can send something. But they really don't have any spe=
cific
> > > > > > > > source address set, so long addresses are none for source a=
ddresses, I
> > > > > > > > don't see any problem here. They also don't have AACK handl=
ing, but
> > > > > > > > it's not required for scan anyway...
> > > > > > > >
> > > > > > > > If this gets too complicated right now, then I am also fine=
 with
> > > > > > > > returning an error here, we can enable it later but would i=
t be better
> > > > > > > > to use ENOTSUPP or something like that in this case? EPERM =
sounds like
> > > > > > > > you can do that, but you don't have the permissions.
> > > > > > > > =20
> > > > > > >
> > > > > > > For me a scan should also be possible from iwpan phy $PHY sca=
n (or
> > > > > > > whatever the scan command is, or just enable beacon)... to go=
 over the
> > > > > > > dev is just a shortcut for "I mean whatever the phy is under =
this dev"
> > > > > > > ? =20
> > > > > >
> > > > > > Actually only coordinators (in a specific state) should be able=
 to send
> > > > > > beacons, so I am kind of against allowing that shortcut, becaus=
e there
> > > > > > are usually two dev interfaces on top of the phy's, a regular "=
NODE"
> > > > > > and a "COORD", so I don't think we should go that way.
> > > > > >
> > > > > > For scans however it makes sense, I've added the necessary chan=
ges in
> > > > > > wpan-tools. The TOP_LEVEL(scan) macro however does not support =
using
> > > > > > the same command name twice because it creates a macro, so this=
 one
> > > > > > only supports a device name (the interface command has kind of =
the same
> > > > > > situation and uses a HIDDEN() macro which cannot be used here).
> > > > > > =20
> > > > >
> > > > > Yes, I was thinking about scanning only.
> > > > > =20
> > > > > > So in summary here is what is supported:
> > > > > > - dev <dev> beacon
> > > > > > - dev <dev> scan trigger|abort
> > > > > > - phy <phy> scan trigger|abort
> > > > > > - dev <dev> scan (the blocking one, which triggers, listens and=
 returns)
> > > > > >
> > > > > > Do you agree?
> > > > > > =20
> > > > >
> > > > > Okay, yes. I trust you. =20
> > > >
> > > > btw: at the point when a scan requires a source address... it cannot
> > > > be done because then a scan is related to a MAC instance -> an wpan
> > > > interface and we need to bind to it. But I think it doesn't? =20
> > >
> > > I'm not sure I follow you here. You mean in case of active scan? =20
> >
> > Actually a beacon requests do not require any kind of source identifier,
> > so what do you mean by source address?
> > =20
>=20
> Is this more clear now?

Yes, thanks!

> > A regular beacon, however, does. Which means sending beacons would
> > include being able to set an address into a monitor interface. So if we
> > want to play with beacons on monitor interfaces, we should also relax
> > the pan_id/addressing rules. =20
>=20
> mhhh, this is required for active scans? Then a scan operation cannot
> be run on giving a phy only as a parameter...

No, this is not required for active scans. Scans do not require
anything else than phy parameters, AFAICS.

This is required for sending beacons though. So we cannot send beacons
from monitors if we don't relax the pan_id/addressing rules on these
interfaces. Do you think we should?

Thanks,
Miqu=C3=A8l
