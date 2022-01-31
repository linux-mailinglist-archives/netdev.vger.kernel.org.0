Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1504A406C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbiAaKqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 05:46:51 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:60689 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiAaKqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 05:46:50 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 31D38100016;
        Mon, 31 Jan 2022 10:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643626009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7yR6WmGap0lvu91eeamRonhOD4y4CMa0n9iP2VxD4Y=;
        b=TQwhYAClJoUR9pHIFrfnTGm8O9/RnOI4uK3QJo8Viayc7c81J1PVCSdsr/lGi+GF+mB+t4
        1bAk2kjOk+IuW3iUc0peWiqNCj0bj8AkR6DXYF/jZEHa6w7h+tf/cRIH3zlV6o8Uo37Dwc
        zgryPSP3bz0LLp2Ots3o6oq8yzOw5U2ovHSzb11Z+mpF+e11loC1nX1duI0Bxr0syMfjN8
        aF0iVolRcKwzyhdV/oL+GOPuPWhqzc2Juf6vv/7CjJbGN51grVrXkSilYJe8BXsAW5W9zO
        s39F3PPTEWI3BizPZPYx35E9HkXyPke8L9Lp3aK8f8i457W+UlEuwMNGjsF0YQ==
Date:   Mon, 31 Jan 2022 11:46:45 +0100
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
Message-ID: <20220131114645.341d61e9@xps13>
In-Reply-To: <CAB_54W7KOjBys4aY5Ky3N3zmSGHnW2cvfag2cubD4cMvrkHY3A@mail.gmail.com>
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com>
        <20220128112002.1121320-3-miquel.raynal@bootlin.com>
        <CAB_54W7KOjBys4aY5Ky3N3zmSGHnW2cvfag2cubD4cMvrkHY3A@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 30 Jan 2022 16:09:00 -0500:

> Hi,
>=20
> On Fri, Jan 28, 2022 at 6:20 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > From: David Girault <david.girault@qorvo.com>
> >
> > Move the address structure earlier in the cfg802154.h header in order to
> > use it in subsequent additions. Give this structure a header to better
> > explain its content.
> >
> > Signed-off-by: David Girault <david.girault@qorvo.com>
> > [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
> >                             reword the comment]
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/cfg802154.h | 28 +++++++++++++++++++---------
> >  1 file changed, 19 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index 4491e2724ff2..0b8b1812cea1 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -29,6 +29,25 @@ struct ieee802154_llsec_key_id;
> >  struct ieee802154_llsec_key;
> >  #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
> >
> > +/**
> > + * struct ieee802154_addr - IEEE802.15.4 device address
> > + * @mode: Address mode from frame header. Can be one of:
> > + *        - @IEEE802154_ADDR_NONE
> > + *        - @IEEE802154_ADDR_SHORT
> > + *        - @IEEE802154_ADDR_LONG
> > + * @pan_id: The PAN ID this address belongs to
> > + * @short_addr: address if @mode is @IEEE802154_ADDR_SHORT
> > + * @extended_addr: address if @mode is @IEEE802154_ADDR_LONG
> > + */
> > +struct ieee802154_addr {
> > +       u8 mode;
> > +       __le16 pan_id;
> > +       union {
> > +               __le16 short_addr;
> > +               __le64 extended_addr;
> > +       };
> > +};
> > +
> >  struct cfg802154_ops {
> >         struct net_device * (*add_virtual_intf_deprecated)(struct wpan_=
phy *wpan_phy,
> >                                                            const char *=
name,
> > @@ -277,15 +296,6 @@ static inline void wpan_phy_net_set(struct wpan_ph=
y *wpan_phy, struct net *net)
> >         write_pnet(&wpan_phy->_net, net);
> >  }
> >
> > -struct ieee802154_addr {
> > -       u8 mode;
> > -       __le16 pan_id;
> > -       union {
> > -               __le16 short_addr;
> > -               __le64 extended_addr;
> > -       };
> > -};
> > - =20
>=20
> I don't see the sense of moving this around? Is there a compilation
> warning/error?

Not yet but we will need to move this structure around soon. This
commit is like a 'preparation' step for the changes coming later.

I can move this later if you prefer.

Thanks,
Miqu=C3=A8l
