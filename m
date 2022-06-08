Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769ED5432B3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 16:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241477AbiFHOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 10:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241557AbiFHOhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:37:23 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21546103F;
        Wed,  8 Jun 2022 07:37:14 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 27866FF822;
        Wed,  8 Jun 2022 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654699033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7XNfcTlaGXRqxJ/j5QVaKpW/rJmUAr9cYMyfUGYvIHs=;
        b=mRXM8TZkWXehbSEURjvEoLwLOo2h3X7fUitr2UCmzPbGu+Tv8nMJYi6vxfh6M78dRIZ+KA
        FE28E2vhH4WJtYIqEVIj8JU78+0niyeBrgUgofmgpT+I+MVNc1ZMOk0++1eX+CQu0QNcWT
        AeTgmWSVsSSl+268F+G44JsMw8KmUWYHIL9TKx0t8uBrzqfmwT+JRF9UpiGRh0l/JY65WR
        bmeL4lPWTZ1JQe7+ipyYYbLkvF+AggoZiraYT8I1tPNMzBzMCLEoDn6+K1oJOyAYirwSBH
        ZEDKW9xVlqxUk6dRxUnwhtGE1QamtHVN5Ck/MMoSdqDFtGrWmC+u06JbuFGgTg==
Date:   Wed, 8 Jun 2022 16:37:08 +0200
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
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator
 interface type
Message-ID: <20220608163708.26ccd4cc@xps-13>
In-Reply-To: <20220608154749.06b62d59@xps-13>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
        <20220606174319.0924f80d@xps-13>
        <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
        <20220607181608.609429cb@xps-13>
        <20220608154749.06b62d59@xps-13>
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


miquel.raynal@bootlin.com wrote on Wed, 8 Jun 2022 15:47:49 +0200:

> Hi Alex,
>=20
> > > 3. coordinator (any $TYPE specific) userspace software
> > >=20
> > > May the main argument. Some coordinator specific user space daemon
> > > does specific type handling (e.g. hostapd) maybe because some library
> > > is required. It is a pain to deal with changing roles during the
> > > lifetime of an interface and synchronize user space software with it.
> > > We should keep in mind that some of those handlings will maybe be
> > > moved to user space instead of doing it in the kernel. I am fine with
> > > the solution now, but keep in mind to offer such a possibility.
> > >=20
> > > I think the above arguments are probably the same why wireless is
> > > doing something similar and I would avoid running into issues or it's
> > > really difficult to handle because you need to solve other Linux net
> > > architecture handling at first.   =20
> >=20
> > Yep. =20
>=20
> The spec makes a difference between "coordinator" and "PAN
> coordinator", which one is the "coordinator" interface type supposed to
> picture? I believe we are talking about being a "PAN coordinator", but
> I want to be sure that we are aligned on the terms.
>=20
> > > > > You are mixing things here with "role in the network" and what
> > > > > the transceiver capability (RFD, FFD) is, which are two
> > > > > different things.     =20
> > > >
> > > > I don't think I am, however maybe our vision differ on what an
> > > > interface should be.
> > > >     =20
> > > > > You should use those defines and the user needs to create a new
> > > > > interface type and probably have a different extended address
> > > > > to act as a coordinator.     =20
> > > >
> > > > Can't we just simply switch from coordinator to !coordinator
> > > > (that's what I currently implemented)? Why would we need the user
> > > > to create a new interface type *and* to provide a new address?
> > > >
> > > > Note that these are real questions that I am asking myself. I'm
> > > > fine adapting my implementation, as long as I get the main idea.
> > > >     =20
> > >=20
> > > See above.   =20
> >=20
> > That's okay for me. I will adapt my implementation to use the
> > interface thing. In the mean time additional details about what a
> > coordinator interface should do differently (above question) is
> > welcome because this is not something I am really comfortable with. =20
>=20
> I've updated the implementation to use the IFACE_COORD interface and it
> works fine, besides one question below.
>=20
> Also, I read the spec once again (soon I'll sleep with it) and
> actually what I extracted is that:
>=20
> * A FFD, when turned on, will perform a scan, then associate to any PAN
>   it found (algorithm is beyond the spec) or otherwise create a PAN ID
>   and start its own PAN. In both cases, it finishes its setup by
>   starting to send beacons.
>=20
> * A RFD will behave more or less the same, without the PAN creation
>   possibility of course. RFD-RX and RFD-TX are not required to support
>   any of that, I'll assume none of the scanning features is suitable
>   for them.

Acutally, RFDs do not send beacons, AFAIU.

> I have a couple of questions however:
>=20
> - Creating an interface (let's call it wpancoord) out of wpan0 means
>   that two interfaces can be used in different ways and one can use
>   wpan0 as a node while using wpancoord as a PAN coordinator. Is that
>   really allowed? How should we prevent this from happening?
>=20
> - Should the device always wait for the user(space) to provide the PAN
>   to associate to after the scan procedure right after the
>   add_interface()? (like an information that must be provided prior to
>   set the interface up?)
>=20
> - How does an orphan FFD should pick the PAN ID for a PAN creation?
>   Should we use a random number? Start from 0 upwards? Start from
>   0xfffd downwards? Should the user always provide it?
>=20
> - Should an FFD be able to create its own PAN on demand? Shall we
>   allow to do that at the creation of the new interface?

Additional questions:

  - How is chosen the beacon order? Should we have a default value?
    Should we default to 15 (not on a beacon enabled PAN)? Should we be
    able to update this value during the lifetime of the PAN?

  - The spec talks about the cluster topology, where a coordinator that
    just associated to a PAN starts emitting beacons, which may enable
    other devices in its range to ask to join the PAN (increased area
    coverage). But then, there is no information about how the newly
    added device should do to join the PAN coordinator which is anyway
    out of range to require the association, transmit data, etc. Any
    idea how this is supposed to work?

Thanks,
Miqu=C3=A8l
