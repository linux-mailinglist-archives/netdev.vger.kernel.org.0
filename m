Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A954501911
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240628AbiDNQvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiDNQvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:51:16 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15F9286D5;
        Thu, 14 Apr 2022 09:19:44 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 23A6140011;
        Thu, 14 Apr 2022 16:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649953183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2J9dJbB1wD0QBDzU2kIu9rGdefw3vt+7Yy1VMMdSVd4=;
        b=i3Kk7S1W9/QOKtOOXJKFSOZpbTI53V6e7lU8R+xc8GOnt49tt18cfYIxt3dsN4/O/KT7lI
        ShJcuZRRvR617x2N8reYCw/3xleZso3O3hTU3IljwhcZ3JrainAQyiC0l8FKDCJP9+u17+
        AgSedK4iFaEtN/hvhq9GrtSPMNLsKPCaUiNu7wUMb/5CPrPm8oBVbuETJGjsP4XTBn2jTV
        1CXx5XYdLtAlN/d8po8wSPJIcPLrFiy4+Oeqpv4gYGm5eb3fgwhYMekefpAXI4/qjlidyv
        SZTfPJbCXHh7Qhkr5wNodBV3cCEDjVH6JTTnW+33skPbUCYBh9DvLQOkW8kiEA==
Date:   Thu, 14 Apr 2022 18:18:15 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <20220414181815.5037651e@fixe.home>
In-Reply-To: <20220414151146.a2fncklswo6utiyd@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-3-clement.leger@bootlin.com>
        <20220414142242.vsvv3vxexc7i3ukm@skbuf>
        <20220414163546.3f6c5157@fixe.home>
        <20220414151146.a2fncklswo6utiyd@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 14 Apr 2022 18:11:46 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Thu, Apr 14, 2022 at 04:35:46PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > > Please keep variable declarations sorted in decreasing order of line
> > > length (applies throughout the patch series, I won't repeat this comm=
ent). =20
> >=20
> > Acked, both PCS and DSA driver are ok with that rule. Missed that one
> > though. =20
>=20
> Are you sure? Because a5psw_port_stp_state_set() says otherwise.

Weeeeell, ok let's say I missed these two. Would be useful to have such
checks in checkpatch.pl.

>=20
> > > sizeof(tag), to be consistent with the other use of sizeof() above?
> > > Although, hmm, I think you could get away with editing "ptag" in plac=
e. =20
> >=20
> > I was not sure of the alignment guarantee I would have here. If the
> > VLAN header is guaranteed to be aligned on 2 bytes, then I guess it's
> > ok to do that in-place. =20
>=20
> If I look at Documentation/core-api/unaligned-memory-access.rst
>=20
> | Alignment vs. Networking
> | =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> |=20
> | On architectures that require aligned loads, networking requires that t=
he IP
> | header is aligned on a four-byte boundary to optimise the IP stack. For
> | regular ethernet hardware, the constant NET_IP_ALIGN is used. On most
> | architectures this constant has the value 2 because the normal ethernet
> | header is 14 bytes long, so in order to get proper alignment one needs =
to
> | DMA to an address which can be expressed as 4*n + 2. One notable except=
ion
> | here is powerpc which defines NET_IP_ALIGN to 0 because DMA to unaligned
> | addresses can be very expensive and dwarf the cost of unaligned loads.
>=20
> Your struct a5psw_tag *ptag starts at 10 bytes (8 for tag, 2 for Ethertyp=
e)
> before the IP header, so I'm thinking it is aligned at a 2 byte boundary
> as well. A VLAN header between the DSA header and the IP header should
> also not affect that alignment, since its length is 4 bytes.
>=20
> If "ctrl_tag" is aligned at a 4 byte boundary - 10, it means "ctrl_data"
> is aligned at a 4 byte boundary - 8, so also a 4 byte boundary.
>=20
> But "ctrl_data2" is aligned at a 4 byte boundary + 2, so you might want
> to break up the u32 access into 2 u16 accesses, just to be on the safe
> side?

Thanks for finding these, looks like a good compromise, let's go that
way then.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
