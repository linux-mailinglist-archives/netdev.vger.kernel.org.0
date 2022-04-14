Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412785016BF
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242550AbiDNPLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 11:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354755AbiDNOmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 10:42:36 -0400
X-Greylist: delayed 7951 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 14 Apr 2022 07:37:18 PDT
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67A7BE30;
        Thu, 14 Apr 2022 07:37:16 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A9E5140005;
        Thu, 14 Apr 2022 14:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649947034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pzvpVAHFVERSCKfSjCd2O3kX3fnSWHd58BPp7m5zfsI=;
        b=iy+GT5pV6avmVLZTv4Eo9dlefVS9d+26T82VLPBBddEKpkcHIooovDTOSDNO9W9Oj7LiK/
        LZmDngFiWqZOlxybCp1RDK/L295LyaOihoCaFRx9iWvjyaPqB7uoW1zKBTmoD3IcreeBSt
        5Jd6s8T69+qcaLFERYxp7dtLdV9XTkoK/ZbAzKz6Nb1E6d+UVENiw9LlasizC4Nthd6T7O
        CDohMo3dc9bi22rg6uav/obQ/MU6Ikid9H0w0Dt0OoeypNdq9U9EsKZunlBbaRrDZrMkE/
        aaFDr6pexHjIGcvcnzgXsy3AzUEWoXDbVkX1zVI5bQzmhVIewzyv86sSHBSikg==
Date:   Thu, 14 Apr 2022 16:35:46 +0200
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
Message-ID: <20220414163546.3f6c5157@fixe.home>
In-Reply-To: <20220414142242.vsvv3vxexc7i3ukm@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-3-clement.leger@bootlin.com>
        <20220414142242.vsvv3vxexc7i3ukm@skbuf>
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

Le Thu, 14 Apr 2022 17:22:42 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> > +
> > +/* To define the outgoing port and to discover the incoming port a TAG=
 is
> > + * inserted after Src MAC :
> > + *
> > + *       Dest MAC       Src MAC           TAG         Type
> > + * ...| 1 2 3 4 5 6 | 1 2 3 4 5 6 | 1 2 3 4 5 6 7 8 | 1 2 |...
> > + *                                |<--------------->|
> > + *
> > + * See struct a5psw_tag for layout
> > + */
> > +
> > +#define A5PSW_TAG_VALUE			0xE001
> > +#define A5PSW_TAG_LEN			8
> > +#define A5PSW_CTRL_DATA_FORCE_FORWARD	BIT(0)
> > +/* This is both used for xmit tag and rcv tagging */
> > +#define A5PSW_CTRL_DATA_PORT		GENMASK(3, 0)
> > +
> > +struct a5psw_tag { =20
>=20
> This needs to be packed.
>=20
> > +	u16 ctrl_tag;
> > +	u16 ctrl_data; =20
>=20
> These need to be __be16.
>=20
> > +	u32 ctrl_data2; =20
>=20
> This needs to be __be32.

Acked.

>=20
> > +};
> > +
> > +static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct net_=
device *dev)
> > +{
> > +	struct a5psw_tag *ptag, tag =3D {0};
> > +	struct dsa_port *dp =3D dsa_slave_to_port(dev); =20
>=20
> Please keep variable declarations sorted in decreasing order of line
> length (applies throughout the patch series, I won't repeat this comment).

Acked, both PCS and DSA driver are ok with that rule. Missed that one
though.
>=20
> > +	u32 data2_val;
> > +
> > +	/* The Ethernet switch we are interfaced with needs packets to be at
> > +	 * least 64 bytes (including FCS) otherwise they will be discarded wh=
en
> > +	 * they enter the switch port logic. When tagging is enabled, we need
> > +	 * to make sure that packets are at least 68 bytes (including FCS and
> > +	 * tag).
> > +	 */
> > +	if (__skb_put_padto(skb, ETH_ZLEN + sizeof(tag), false))
> > +		return NULL;
> > +
> > +	/* provide 'A5PSW_TAG_LEN' bytes additional space */
> > +	skb_push(skb, A5PSW_TAG_LEN);
> > +
> > +	/* make room between MACs and Ether-Type to insert tag */
> > +	dsa_alloc_etype_header(skb, A5PSW_TAG_LEN);
> > +
> > +	ptag =3D dsa_etype_header_pos_tx(skb);
> > +
> > +	data2_val =3D FIELD_PREP(A5PSW_CTRL_DATA_PORT, BIT(dp->index));
> > +	tag.ctrl_tag =3D htons(A5PSW_TAG_VALUE);
> > +	tag.ctrl_data =3D htons(A5PSW_CTRL_DATA_FORCE_FORWARD);
> > +	tag.ctrl_data2 =3D htonl(data2_val);
> > +
> > +	memcpy(ptag, &tag, sizeof(struct a5psw_tag)); =20
>=20
> sizeof(tag), to be consistent with the other use of sizeof() above?
> Although, hmm, I think you could get away with editing "ptag" in place.

I was not sure of the alignment guarantee I would have here. If the
VLAN header is guaranteed to be aligned on 2 bytes, then I guess it's
ok to do that in-place.


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
