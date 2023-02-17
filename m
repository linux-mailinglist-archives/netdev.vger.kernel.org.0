Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F23E69A7BC
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjBQJCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBQJCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:02:38 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E022C604FD;
        Fri, 17 Feb 2023 01:02:36 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A01E124001A;
        Fri, 17 Feb 2023 09:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676624555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nTHN2+OQzWXKWQyv9c23hrPlgCgxWlIlXhwJ7VfPJxw=;
        b=Ek7wpyxVqGf7TUA5FpsIVQ17xtCBV1IlZHBxvMikkuTF1qwmpfE5Xbe3+vyvuiTe05C/Oo
        LATKAFaahRdvWZ+YKeMOQLAh7YX2IvnfDh9g0hjbsFqFljLL1Jflf1mrFbmNSFlYXDBF9x
        0vNegf7AegNOqh4nHPi40BgVhF52USH7TdBjzQwR/isaIwomPtyIDl5jOcI1m0o/TS8xa6
        KLKESws+PBe+2wdS7RlYoHkaPzDLbdGNGxEr2yNNFsYdWvxL68+y5Li3AtXuOgp9Nl6H4w
        /P+pu8j6z8FT5oisQLXcgpJL46WN8gIPg35n24pf8g3YIrjtNNkYwp3XcA+4Uw==
Date:   Fri, 17 Feb 2023 10:02:20 +0100
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
Message-ID: <20230217100220.79a835e4@xps-13>
In-Reply-To: <CAK-6q+g233giuLd56p0G5TqGF+S-NWSkD2MF5nhP+0HLxwnkCA@mail.gmail.com>
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
        <CAK-6q+g233giuLd56p0G5TqGF+S-NWSkD2MF5nhP+0HLxwnkCA@mail.gmail.com>
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

aahringo@redhat.com wrote on Thu, 16 Feb 2023 23:34:30 -0500:

> Hi,
>=20
> On Tue, Feb 14, 2023 at 9:07 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Tue, 14 Feb 2023 08:53:57 -0500:
> > =20
> > > Hi,
> > >
> > > On Tue, Feb 14, 2023 at 8:34 AM Alexander Aring <aahringo@redhat.com>=
 wrote: =20
> > > >
> > > > Hi,
> > > >
> > > > On Mon, Feb 13, 2023 at 12:35 PM Miquel Raynal
> > > > <miquel.raynal@bootlin.com> wrote: =20
> > > > >
> > > > > Hi Alexander,
> > > > > =20
> > > > > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, =
struct genl_info *info)
> > > > > > > > > > +{
> > > > > > > > > > +       struct cfg802154_registered_device *rdev =3D in=
fo->user_ptr[0];
> > > > > > > > > > +       struct net_device *dev =3D info->user_ptr[1];
> > > > > > > > > > +       struct wpan_dev *wpan_dev =3D dev->ieee802154_p=
tr;
> > > > > > > > > > +       struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > > > > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > > > > +       u8 type;
> > > > > > > > > > +       int err;
> > > > > > > > > > +
> > > > > > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > > > > > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MON=
ITOR)
> > > > > > > > > > +               return -EPERM; =20
> > > > > > > > >
> > > > > > > > > btw: why are monitors not allowed? =20
> > > > > > > >
> > > > > > > > I guess I had the "active scan" use case in mind which of c=
ourse does
> > > > > > > > not work with monitors. Maybe I can relax this a little bit=
 indeed,
> > > > > > > > right now I don't remember why I strongly refused scans on =
monitors. =20
> > > > > > >
> > > > > > > Isn't it that scans really work close to phy level? Means in =
this case
> > > > > > > we disable mostly everything of MAC filtering on the transcei=
ver side.
> > > > > > > Then I don't see any reasons why even monitors can't do anyth=
ing, they
> > > > > > > also can send something. But they really don't have any speci=
fic
> > > > > > > source address set, so long addresses are none for source add=
resses, I
> > > > > > > don't see any problem here. They also don't have AACK handlin=
g, but
> > > > > > > it's not required for scan anyway...
> > > > > > >
> > > > > > > If this gets too complicated right now, then I am also fine w=
ith
> > > > > > > returning an error here, we can enable it later but would it =
be better
> > > > > > > to use ENOTSUPP or something like that in this case? EPERM so=
unds like
> > > > > > > you can do that, but you don't have the permissions.
> > > > > > > =20
> > > > > >
> > > > > > For me a scan should also be possible from iwpan phy $PHY scan =
(or
> > > > > > whatever the scan command is, or just enable beacon)... to go o=
ver the
> > > > > > dev is just a shortcut for "I mean whatever the phy is under th=
is dev"
> > > > > > ? =20
> > > > >
> > > > > Actually only coordinators (in a specific state) should be able t=
o send
> > > > > beacons, so I am kind of against allowing that shortcut, because =
there
> > > > > are usually two dev interfaces on top of the phy's, a regular "NO=
DE"
> > > > > and a "COORD", so I don't think we should go that way.
> > > > >
> > > > > For scans however it makes sense, I've added the necessary change=
s in
> > > > > wpan-tools. The TOP_LEVEL(scan) macro however does not support us=
ing
> > > > > the same command name twice because it creates a macro, so this o=
ne
> > > > > only supports a device name (the interface command has kind of th=
e same
> > > > > situation and uses a HIDDEN() macro which cannot be used here).
> > > > > =20
> > > >
> > > > Yes, I was thinking about scanning only.
> > > > =20
> > > > > So in summary here is what is supported:
> > > > > - dev <dev> beacon
> > > > > - dev <dev> scan trigger|abort
> > > > > - phy <phy> scan trigger|abort
> > > > > - dev <dev> scan (the blocking one, which triggers, listens and r=
eturns)
> > > > >
> > > > > Do you agree?
> > > > > =20
> > > >
> > > > Okay, yes. I trust you. =20
> > >
> > > btw: at the point when a scan requires a source address... it cannot
> > > be done because then a scan is related to a MAC instance -> an wpan
> > > interface and we need to bind to it. But I think it doesn't? =20
> >
> > I'm not sure I follow you here. You mean in case of active scan? The
> > operation is always tight to a device in the end, even if you provide a
> > phy in userspace. So I guess it's not a problem. Or maybe I didn't get
> > the question right? =20
>=20
> As soon scan requires to put somewhere mib values inside e.g. address
> information (which need to compared to source address settings (mib)?)
> then it's no longer a phy operation -> wpan_phy, it is binded to a
> wpan_dev (mac instance on a phy). But the addresses are set to NONE
> address type?
> I am not sure where all that data is stored right now for a scan
> operation, if it's operating on a phy it should be stored on wpan_phy.
>=20
> Note: there are also differences between wpan_phy and
> ieee802154_local, also wpan_dev and ieee802154_sub_if_data structures.
> It has something to do with visibility and SoftMAC vs HardMAC, however
> the last one we don't really have an infrastructure for and we
> probably need to move something around there. In short
> wpan_phy/wpan_dev should be only visible by HardMAC (I think) and the
> others are only additional data for the same instances used by
> mac802154...

Ok, I got what you meant.

So to be clear, I assume active and passive scans are phy activities,
they only involve phy parameters. Beaconing however need access to mac
parameters.

For now the structure defining user requests in terms of scanning and
beaconing is stored into ieee802154_local, but we can move it
away if needed at some point? For now I have no real example of
hardMAC device so it's a bit hard to anticipate all their
needs, but do you want me to move it to wpan_dev? (I would like to keep
both request descriptors aside from each other).

Thanks,
Miqu=C3=A8l
