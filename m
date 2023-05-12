Return-Path: <netdev+bounces-2063-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59E0B700218
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 149BF281A8B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A07163D8;
	Fri, 12 May 2023 08:01:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F529442
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:01:45 +0000 (UTC)
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC5FE709;
	Fri, 12 May 2023 01:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1683878504; x=1715414504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ajWaCQwEk/326TqmtMr3s5MnclnzjZmm203gVg+Ed5k=;
  b=VQDVUyUvxraaP0s1iV7aPF0hRT9Tgx8Zs1mokMtEpnrzbDnAOXfWGHUq
   bg4EE2a5hBU6Q9G8FPeCqSvV/xKD74qkfaAOQtIteXtjW06rczMIrzMVz
   j/1cjWR4PRXvTaUsXTzaMzXZfxKmln8sY2ExFSthakiSz9dyV9HDCwVSt
   fW9+nP+9Y5H+sT92akwlapq8gdYg57WCefU7q24TQ+G87YYKx0q7xRIAE
   QcyNGiRZFG8Zl5CWbVZeDT7x05R20QqMFKrmO/ByrkO0YplbAKFvmeZXL
   ore74vLgQ1pOO9IW3HUgDD97pbe4lY6yqQhbauja45KlOV6Xg6mcMxJaO
   w==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677538800"; 
   d="scan'208";a="30870499"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 12 May 2023 10:01:42 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 12 May 2023 10:01:42 +0200
X-PGP-Universal: processed;
	by tq-pgp-pr1.tq-net.de on Fri, 12 May 2023 10:01:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1683878502; x=1715414502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ajWaCQwEk/326TqmtMr3s5MnclnzjZmm203gVg+Ed5k=;
  b=JEsWPmY78EGOncUCqWxqN/9nJW3qYYNo3tyhETttj3/PRjc3RWL5/8vc
   m7t1/QwftVV+Vr/jARIkjxm7ICuGXDTmU8rDS/2u89KHJVawPx6hOtPFA
   MjepEEl9wQ7OJyBZVgZO52MCIniKsM6+HigESecdhuPNlwgLTbaJ8tb6G
   YcgYdSQi5hnQ3a1ce2zTdYq6nXH7sHY0jZ3nStm4uf7ytdRjacbeyQlcN
   O9VK+q20VfskWbyTvst5V0HC4j4h475tcQnheT5ybi02PcuQHlftDO78I
   3fa/lHSBbmjltbhjxhasjae7UuczfBvJ56qQxXfyC3waLM6hxZLc5UgBD
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677538800"; 
   d="scan'208";a="30870498"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 12 May 2023 10:01:41 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 8434D280056;
	Fri, 12 May 2023 10:01:41 +0200 (CEST)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: andrew@lunn.ch, Yan Wang <rk.code@outlook.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: mdiobus: Add a function to deassert reset
Date: Fri, 12 May 2023 10:01:41 +0200
Message-ID: <2561676.Lt9SDvczpP@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <KL1PR01MB54486E8738DC81E062BA2D0EE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
References: <96a1b95e-d05e-40f0-ada9-1956f43010e0@lunn.ch> <9107661.CDJkKcVGEf@steina-w> <KL1PR01MB54486E8738DC81E062BA2D0EE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Am Donnerstag, 11. Mai 2023, 05:16:52 CEST schrieb Yan Wang:
> On 5/10/2023 7:55 PM, Alexander Stein wrote:
> > Am Mittwoch, 10. Mai 2023, 10:02:52 CEST schrieb Yan Wang:
> >> It is possible to mount multiple sub-devices on the mido bus.
> >=20
> > mdio bus
>=20
> Yes, misspelled.
>=20
> >> The hardware power-on does not necessarily reset these devices.
> >> The device may be in an uncertain state, causing the device's ID
> >> to be scanned.
> >>=20
> >> So, before adding a reset to the scan, make sure the device is in
> >> normal working mode.
> >>=20
> >> I found that the subsequent drive registers the reset pin into the
> >> structure of the sub-device to prevent conflicts, so release the
> >> reset pin.
> >>=20
> >> Signed-off-by: Yan Wang <rk.code@outlook.com>
> >=20
> > We had similar cases where the (single) PHY was in reset during Linux
> > boot.
> > Should you be able to make this work by using a "ethernet-phy-id%4x.%4x"
> > compatible? See also [1]
> >=20
> > [1] https://lkml.org/lkml/2020/10/28/1139
>=20
> Well, I've seen the [1] before, this method may mask some issues. For
> example ,if I use
> another type of phy ,I have to modify the DT, Is it very cumbersome?

You have to change the reset timings and possibly other properties as well =
if=20
you change the PHY, so a DT change is necessary anyway.

Regards,
Alexander

>=20
> >> ---
> >>=20
> >> v2:
> >>    - fixed commit message
> >>    - Using gpiod_ replace gpio_
> >>=20
> >> v1:
> >> https://lore.kernel.org/all/KL1PR01MB5448631F2D6F71021602117FE6769@KL1=
PR0
> >> 1M
> >> B5448.apcprd01.prod.exchangelabs.com/ - Incorrect description of commit
> >> message.
> >>=20
> >>    - The gpio-api too old
> >>=20
> >> ---
> >>=20
> >>   drivers/net/mdio/fwnode_mdio.c | 16 ++++++++++++++++
> >>   1 file changed, 16 insertions(+)
> >>=20
> >> diff --git a/drivers/net/mdio/fwnode_mdio.c
> >> b/drivers/net/mdio/fwnode_mdio.c index 1183ef5e203e..6695848b8ef2 1006=
44
> >> --- a/drivers/net/mdio/fwnode_mdio.c
> >> +++ b/drivers/net/mdio/fwnode_mdio.c
> >> @@ -57,6 +57,20 @@ fwnode_find_mii_timestamper(struct fwnode_handle
> >> *fwnode) return register_mii_timestamper(arg.np, arg.args[0]);
> >>=20
> >>   }
> >>=20
> >> +static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnod=
e)
> >> +{
> >> +	struct gpio_desc *reset;
> >> +
> >> +	reset =3D fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH,
> >=20
> > NULL);
> >=20
> >> +	if (IS_ERR(reset) && PTR_ERR(reset) !=3D -EPROBE_DEFER)
> >=20
> > How are you dealing with EPROBE_DEFER if the reset line is e.g. attached
> > to an i2c expander, which is to be probed later on?
>=20
> Thank you ,The logic is wrong,trying to fix it.
>=20
> >> +		return;
> >> +
> >> +	usleep_range(100, 200);
> >=20
> > How do you know a PHY's reset pulse width?
> >=20
> >> +	gpiod_set_value_cansleep(reset, 0);
> >=20
> > What about post-reset stabilization times before MDIO access is allowed?
>=20
> yes,I need to get reset pulse width and post-reset stabilization times
> from reset-assert-us and  reset-deassert-us. right?
>=20
> >> +	/*Release the reset pin,it needs to be registered with the PHY.*/
> >=20
> > /* Release [...] PHY. */
> >=20
> > Best regards,
> > Alexander
>=20
> Thank you for your support.
>=20
> >> +	gpiod_put(reset);
> >> +}
> >> +
> >>=20
> >>   int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
> >>  =20
> >>   				       struct phy_device *phy,
> >>   				       struct fwnode_handle *child,
> >=20
> > u32 addr)
> >=20
> >> @@ -119,6 +133,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bu=
s,
> >>=20
> >>   	u32 phy_id;
> >>   	int rc;
> >>=20
> >> +	fwnode_mdiobus_pre_enable_phy(child);
> >> +
> >>=20
> >>   	psec =3D fwnode_find_pse_control(child);
> >>   	if (IS_ERR(psec))
> >>   =09
> >>   		return PTR_ERR(psec);


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/



