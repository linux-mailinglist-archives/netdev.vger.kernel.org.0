Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AC04A4903
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 15:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350706AbiAaOJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 09:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348422AbiAaOJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 09:09:35 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E73C061714;
        Mon, 31 Jan 2022 06:09:33 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 507AD10001A;
        Mon, 31 Jan 2022 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643638171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N6b07edBDKz//XmenpbLYMVpG1e9dkJDAxGMYF7b8SI=;
        b=do0KKIFAy85pV2DUSSzkH2WgEC3UVd8+VV8MmQQSGyf/xQNaVTqRD4MOvdZKx2lpKsFLPW
        lNNY7BTIJ/5Al0oGbJCq5kzcd7zF9F9ZyyUKNPgDoWwMQarHYA00T1HawWLs+SKiw2SrJ+
        KyXsGAAzezkvTFYqte24gq7wJaRLFm8dZMdWjokHLCOjlIvI3mHDRPdmVpr+uYIRXmYtZG
        usr+GJE0GjdZ3SfrsJLfmNziIQ3XFFVK95lJbREwPRBXDpXnGO100XhAvp8SwTeqomDq6/
        s79KXr59dCSCbC3KOX0bt+uSOog8oAC46LX5+7cJlWaWZnUIK3OsQ9jd2HTU5w==
Date:   Mon, 31 Jan 2022 15:09:27 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>
Subject: Re: [PATCH wpan-next v2 2/2] net: ieee802154: Move the address
 structure earlier and provide a kdoc
Message-ID: <20220131150927.5264399c@xps13>
In-Reply-To: <20220131114645.341d61e9@xps13>
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com>
        <20220128112002.1121320-3-miquel.raynal@bootlin.com>
        <CAB_54W7KOjBys4aY5Ky3N3zmSGHnW2cvfag2cubD4cMvrkHY3A@mail.gmail.com>
        <20220131114645.341d61e9@xps13>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miquel,

miquel.raynal@bootlin.com wrote on Mon, 31 Jan 2022 11:46:45 +0100:

> Hi Alexander,
>=20
> alex.aring@gmail.com wrote on Sun, 30 Jan 2022 16:09:00 -0500:
>=20
> > Hi,
> >=20
> > On Fri, Jan 28, 2022 at 6:20 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > From: David Girault <david.girault@qorvo.com>
> > >
> > > Move the address structure earlier in the cfg802154.h header in order=
 to
> > > use it in subsequent additions. Give this structure a header to better
> > > explain its content.
> > >
> > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > [miquel.raynal@bootlin.com: Isolate this change from a bigger commit =
and
> > >                             reword the comment]
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/net/cfg802154.h | 28 +++++++++++++++++++---------
> > >  1 file changed, 19 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > index 4491e2724ff2..0b8b1812cea1 100644
> > > --- a/include/net/cfg802154.h
> > > +++ b/include/net/cfg802154.h
> > > @@ -29,6 +29,25 @@ struct ieee802154_llsec_key_id;
> > >  struct ieee802154_llsec_key;
> > >  #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
> > >
> > > +/**
> > > + * struct ieee802154_addr - IEEE802.15.4 device address
> > > + * @mode: Address mode from frame header. Can be one of:
> > > + *        - @IEEE802154_ADDR_NONE
> > > + *        - @IEEE802154_ADDR_SHORT
> > > + *        - @IEEE802154_ADDR_LONG
> > > + * @pan_id: The PAN ID this address belongs to
> > > + * @short_addr: address if @mode is @IEEE802154_ADDR_SHORT
> > > + * @extended_addr: address if @mode is @IEEE802154_ADDR_LONG
> > > + */
> > > +struct ieee802154_addr {
> > > +       u8 mode;
> > > +       __le16 pan_id;
> > > +       union {
> > > +               __le16 short_addr;
> > > +               __le64 extended_addr;
> > > +       };
> > > +};
> > > +
> > >  struct cfg802154_ops {
> > >         struct net_device * (*add_virtual_intf_deprecated)(struct wpa=
n_phy *wpan_phy,
> > >                                                            const char=
 *name,
> > > @@ -277,15 +296,6 @@ static inline void wpan_phy_net_set(struct wpan_=
phy *wpan_phy, struct net *net)
> > >         write_pnet(&wpan_phy->_net, net);
> > >  }
> > >
> > > -struct ieee802154_addr {
> > > -       u8 mode;
> > > -       __le16 pan_id;
> > > -       union {
> > > -               __le16 short_addr;
> > > -               __le64 extended_addr;
> > > -       };
> > > -};
> > > -   =20
> >=20
> > I don't see the sense of moving this around? Is there a compilation
> > warning/error? =20
>=20
> Not yet but we will need to move this structure around soon. This
> commit is like a 'preparation' step for the changes coming later.
>=20
> I can move this later if you prefer.

Actually there is not actual need for moving this structure anymore.
The number of changes applied on top of the original series have turned
that move unnecessary. I still believe however that structures should,
as far as possible, be defined at the top of headers files, instead of
be defined right before where they will be immediately used when
introduced. I'll cancel the move but I'll keep the addition of the kdoc
which I think is useful.

Thanks,
Miqu=C3=A8l
