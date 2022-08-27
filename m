Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385E25A3632
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 11:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiH0JNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 05:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiH0JNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 05:13:36 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7271429C96;
        Sat, 27 Aug 2022 02:13:33 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F33621C0005;
        Sat, 27 Aug 2022 09:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661591612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1dAY+AukKBJIpei8cIsymPyHtjVXgTIXkchiPNKKTzw=;
        b=Fx7F2j70GrGP0Zw/hPGpCVtl1XhsshuVPgM1qUyVXUWqSqzqXq0pUPsgmlgvBvqSh1lcJH
        iAEC8KeR1ou7PJn4F3duz/3g9W1zTcGeS3HqHFb23n0FtgyXggkK4goYvvHEZv+yOXT5Y6
        4U9YFq9vncY/62QNrjXLG5QamTVWNpyRqOANWPopt3cu1KEOmCbcobJFNvvgJf5/+4Fmvu
        kOT5e2ja4z52iC3SxJcke94o7sYRsAEfxyCeQ9sf7rVGoTR+n8MPf6/eiJGKpTBLoTIwTq
        s+8U2Sxp85kz/0yd+1TqzmM/ENES5g3u9RT1NcW+52RAAg50o/Fs0EbyKqgKgg==
Date:   Sat, 27 Aug 2022 11:13:20 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: pcs: add new PCS driver for altera
 TSE PCS
Message-ID: <20220827111320.3741bffb@pc-11.home>
In-Reply-To: <Ywj4mQDyLzwbvxt8@shell.armlinux.org.uk>
References: <20220826135451.526756-1-maxime.chevallier@bootlin.com>
        <20220826135451.526756-4-maxime.chevallier@bootlin.com>
        <Ywj4mQDyLzwbvxt8@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

Hello Russell,

On Fri, 26 Aug 2022 17:45:13 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Fri, Aug 26, 2022 at 03:54:49PM +0200, Maxime Chevallier wrote:
> > +
> > +/* SGMII PCS register addresses
> > + */
> > +#define SGMII_PCS_SCRATCH	0x10
> > +#define SGMII_PCS_REV		0x11
> > +#define SGMII_PCS_LINK_TIMER_0	0x12
> > +#define   SGMII_PCS_LINK_TIMER_REG(x)		(0x12 + (x))
> > +#define SGMII_PCS_LINK_TIMER_1	0x13
> > +#define SGMII_PCS_IF_MODE	0x14
> > +#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
> > +#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
> > +#define   PCS_IF_MODE_SGMI_SPEED_MASK	GENMASK(3, 2)
> > +#define   PCS_IF_MODE_SGMI_SPEED_10	(0 << 2)
> > +#define   PCS_IF_MODE_SGMI_SPEED_100	(1 << 2)
> > +#define   PCS_IF_MODE_SGMI_SPEED_1000	(2 << 2)
> > +#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
> > +#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5) =20
>=20
> This looks very similar to pcs-lynx's register layout. I wonder if
> it's the same underlying hardware.

I've also looked, and indeed the layout is very smiliar. The key
differences would be that the TSE PCS is limited to 1G max and 8/10bit
encoding, whereas the lynx seems to support BaseR and higher speeds.

> > +static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned
> > int mode,
> > +			      phy_interface_t interface,
> > +			      const unsigned long *advertising,
> > +			      bool permit_pause_to_mac)
> > +{
> > +	struct altera_tse_pcs *tse_pcs =3D
> > phylink_pcs_to_tse_pcs(pcs);
> > +	u32 ctrl, if_mode;
> > +
> > +	if (interface !=3D PHY_INTERFACE_MODE_SGMII &&
> > +	    interface !=3D PHY_INTERFACE_MODE_1000BASEX)
> > +		return 0; =20
>=20
> I would suggest doing this check in .pcs_validate() to catch anyone
> attaching the PCS with an unsupported interface mode.

I'll add it, thanks.

> > +static void alt_tse_pcs_an_restart(struct phylink_pcs *pcs)
> > +{
> > +	struct altera_tse_pcs *tse_pcs =3D
> > phylink_pcs_to_tse_pcs(pcs);
> > +	u16 bmcr;
> > +
> > +	bmcr =3D tse_pcs_read(tse_pcs, MII_BMCR);
> > +	bmcr |=3D BMCR_ANRESTART;
> > +	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
> > +
> > +	tse_pcs_reset(tse_pcs); =20
>=20
> Any ideas why a reset is necessary after setting BMCR_ANRESTART?
> Normally, this is not required.

=46rom my tests, this is something this block needs :/ A soft reset on
this PCS will reset the comma detection and encoding logic, and the
testing I've done needs that for proper autoneg, especially when we
switch back and forth between SGMII/1000BaseX.

The TSE PCS support in dwmac-socfpga also does it, and this was
developped independently to this driver, so it looks like folks who
worked on that also found the same behaviour...

This might be worth adding a comment then :)

> > diff --git a/include/linux/pcs-altera-tse.h
> > b/include/linux/pcs-altera-tse.h new file mode 100644
> > index 000000000000..9c85e7c8ef70
> > --- /dev/null
> > +++ b/include/linux/pcs-altera-tse.h
> > @@ -0,0 +1,17 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2022 Bootlin
> > + *
> > + * Maxime Chevallier <maxime.chevallier@bootlin.com>
> > + */
> > +
> > +#ifndef __LINUX_PCS_ALTERA_TSE_H
> > +#define __LINUX_PCS_ALTERA_TSE_H
> > +
> > +struct phylink; =20
>=20
> Don't you want "struct phylink_pcs;" here?

Oh yes indeed, I this this whole line isn't necessary at all as a
matter of fact :/

Thanks for the review,

Maxime=20

