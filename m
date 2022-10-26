Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7254E60DE4B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiJZJhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbiJZJhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:37:37 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580C5BC78C;
        Wed, 26 Oct 2022 02:37:17 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8446360010;
        Wed, 26 Oct 2022 09:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666777035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4O7WbxTl92ukABCViXrkm449xOwu9xVNaNk5r6fPFbU=;
        b=cSCo38xueLYMZhwUZWF6NRobYJjQ7N5WiuauFIULU0ldBKRvTZZQJXYhA7ADM2KcXC5VpQ
        YxsDYixZbmv9LysGSzRHsbC7Kgkzozu/bduWBtMpk+gLTIk+WK4ivFNi7kh1JisFCtGL2T
        vqX8gOOfwXT6nKwFHnw6gCiUfokfy/P/L/vZVgoptYJ8AX15MZbx4CEiqWoJx3tJoIQXMl
        iR+whqG86BTFRhZZpR5aAQo/bmmN3Ei1Zm66jTHu8fSWfubSvI1oVlqxpcdb/VM1pR3Qwi
        0j7VaEGJfy7jzL6cj73GodJS0XT2i+/KmLtybKqoqPrWR/UUfaqBnuf+YWLfwQ==
Date:   Wed, 26 Oct 2022 11:37:11 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/5] net: pcs: add new PCS driver for altera
 TSE PCS
Message-ID: <20221026113711.2b740c7a@pc-8.home>
In-Reply-To: <68b3dfbf-9bab-2554-254e-bffd280ba97e@gmail.com>
References: <20220901143543.416977-1-maxime.chevallier@bootlin.com>
        <20220901143543.416977-4-maxime.chevallier@bootlin.com>
        <68b3dfbf-9bab-2554-254e-bffd280ba97e@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sean,

On Sun, 9 Oct 2022 01:38:15 -0400
Sean Anderson <seanga2@gmail.com> wrote:


> > +#define   SGMII_PCS_LINK_TIMER_REG(x)		(0x12 + (x))  
> 
> Not used.

Right, I'll remove that in a followup patch

> > +#define SGMII_PCS_LINK_TIMER_1	0x13
> > +#define SGMII_PCS_IF_MODE	0x14
> > +#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
> > +#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
> > +#define   PCS_IF_MODE_SGMI_SPEED_MASK	GENMASK(3, 2)
> > +#define   PCS_IF_MODE_SGMI_SPEED_10	(0 << 2)
> > +#define   PCS_IF_MODE_SGMI_SPEED_100	(1 << 2)
> > +#define   PCS_IF_MODE_SGMI_SPEED_1000	(2 << 2)  
> 
> You can use FIELD_PREP if you're so inclined. I assume SGMI is from
> the datasheet.

Will do ! thanks :)

> > +#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
> > +#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)
> > +#define SGMII_PCS_DIS_READ_TO	0x15
> > +#define SGMII_PCS_READ_TO	0x16
> > +#define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
> > +
> > +struct altera_tse_pcs {
> > +	struct phylink_pcs pcs;
> > +	void __iomem *base;
> > +	int reg_width;
> > +};
> > +
> > +static struct altera_tse_pcs *phylink_pcs_to_tse_pcs(struct
> > phylink_pcs *pcs) +{
> > +	return container_of(pcs, struct altera_tse_pcs, pcs);
> > +}
> > +
> > +static u16 tse_pcs_read(struct altera_tse_pcs *tse_pcs, int regnum)
> > +{
> > +	if (tse_pcs->reg_width == 4)
> > +		return readl(tse_pcs->base + regnum * 4);
> > +	else
> > +		return readw(tse_pcs->base + regnum * 2);
> > +}
> > +
> > +static void tse_pcs_write(struct altera_tse_pcs *tse_pcs, int
> > regnum,
> > +			  u16 value)
> > +{
> > +	if (tse_pcs->reg_width == 4)
> > +		writel(value, tse_pcs->base + regnum * 4);
> > +	else
> > +		writew(value, tse_pcs->base + regnum * 2);
> > +}
> > +
> > +static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
> > +{
> > +	int i = 0;
> > +	u16 bmcr;
> > +
> > +	/* Reset PCS block */
> > +	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
> > +	bmcr |= BMCR_RESET;
> > +	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
> > +
> > +	for (i = 0; i < SGMII_PCS_SW_RESET_TIMEOUT; i++) {
> > +		if (!(tse_pcs_read(tse_pcs, MII_BMCR) &
> > BMCR_RESET))
> > +			return 0;
> > +		udelay(1);
> > +	}  
> 
> read_poll_timeout?

Oh yeah definitely, I didn't know about this helper.

> > +
> > +	return -ETIMEDOUT;
> > +}
> > +
> > +static int alt_tse_pcs_validate(struct phylink_pcs *pcs,
> > +				unsigned long *supported,
> > +				const struct phylink_link_state
> > *state) +{
> > +	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
> > +	    state->interface == PHY_INTERFACE_MODE_1000BASEX)
> > +		return 1;
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned
> > int mode,
> > +			      phy_interface_t interface,
> > +			      const unsigned long *advertising,
> > +			      bool permit_pause_to_mac)
> > +{
> > +	struct altera_tse_pcs *tse_pcs =
> > phylink_pcs_to_tse_pcs(pcs);
> > +	u32 ctrl, if_mode;
> > +
> > +	ctrl = tse_pcs_read(tse_pcs, MII_BMCR);
> > +	if_mode = tse_pcs_read(tse_pcs, SGMII_PCS_IF_MODE);
> > +
> > +	/* Set link timer to 1.6ms, as per the MegaCore Function
> > User Guide */
> > +	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, 0x0D40);
> > +	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, 0x03);  
> 
> Shouldn't this be different for SGMII vs 1000BASE-X?

I've dug a bit and indeed you're right. The value of 1.6ms works for
SGMII, but for 1000BaseX it should be set to 10ms. I'll send a fix for
this too.

> > +
> > +	if (interface == PHY_INTERFACE_MODE_SGMII) {
> > +		if_mode |= PCS_IF_MODE_USE_SGMII_AN |
> > PCS_IF_MODE_SGMII_ENA;  
> 
> I think PCS_IF_MODE_USE_SGMII_AN should be cleared if
> mode=MLO_AN_FIXED.

Correct.

> > +	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
> > +		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN |
> > PCS_IF_MODE_SGMII_ENA);
> > +		if_mode |= PCS_IF_MODE_SGMI_SPEED_1000;  
> 
> I don't think you need to set this for 1000BASE-X.

You're correct too.

> > +	}
> > +
> > +	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);  
> 
> BMCR_FULLDPLX is read-only, so you don't have to set it. Same for the
> speed.

Thanks, that's true

> > +
> > +	tse_pcs_write(tse_pcs, MII_BMCR, ctrl);
> > +	tse_pcs_write(tse_pcs, SGMII_PCS_IF_MODE, if_mode);
> > +
> > +	return tse_pcs_reset(tse_pcs);
> > +}
> > +
> > +static void alt_tse_pcs_get_state(struct phylink_pcs *pcs,
> > +				  struct phylink_link_state *state)
> > +{
> > +	struct altera_tse_pcs *tse_pcs =
> > phylink_pcs_to_tse_pcs(pcs);
> > +	u16 bmsr, lpa;
> > +
> > +	bmsr = tse_pcs_read(tse_pcs, MII_BMSR);
> > +	lpa = tse_pcs_read(tse_pcs, MII_LPA);
> > +
> > +	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
> > +}
> > +
> > +static void alt_tse_pcs_an_restart(struct phylink_pcs *pcs)
> > +{
> > +	struct altera_tse_pcs *tse_pcs =
> > phylink_pcs_to_tse_pcs(pcs);
> > +	u16 bmcr;
> > +
> > +	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
> > +	bmcr |= BMCR_ANRESTART;
> > +	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
> > +
> > +	/* This PCS seems to require a soft reset to re-sync the
> > AN logic */
> > +	tse_pcs_reset(tse_pcs);  
> 
> This is kinda strange since c22 phys are supposed to reset the other
> registers to default values when BMCR_RESET is written. Good thing
> this is a PCS...

Indeed. This soft reset will not affect the register configuration, it
will only reset all internal state machines.

The datasheet actually recommends performing a reset after any
configuration change...

That's one thing with this IP, it tries to re-use the C22 register
layout but it's not fully consistent with it...

> > +}
> > +
> > +static const struct phylink_pcs_ops alt_tse_pcs_ops = {
> > +	.pcs_validate = alt_tse_pcs_validate,
> > +	.pcs_get_state = alt_tse_pcs_get_state,
> > +	.pcs_config = alt_tse_pcs_config,
> > +	.pcs_an_restart = alt_tse_pcs_an_restart,
> > +};  
> 
> Don't you need link_up to set the speed/duplex for MLO_AN_FIXED?

I'll give it a test and confirm it

> > +
> > +struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
> > +				       void __iomem *pcs_base, int
> > reg_width) +{
> > +	struct altera_tse_pcs *tse_pcs;
> > +
> > +	if (reg_width != 4 && reg_width != 2)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	tse_pcs = devm_kzalloc(&ndev->dev, sizeof(*tse_pcs),
> > GFP_KERNEL);
> > +	if (!tse_pcs)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	tse_pcs->pcs.ops = &alt_tse_pcs_ops;
> > +	tse_pcs->base = pcs_base;
> > +	tse_pcs->reg_width = reg_width;
> > +
> > +	return &tse_pcs->pcs;
> > +}
> > +EXPORT_SYMBOL_GPL(alt_tse_pcs_create);
> > diff --git a/include/linux/pcs-altera-tse.h
> > b/include/linux/pcs-altera-tse.h new file mode 100644
> > index 000000000000..92ab9f08e835
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
> > +struct phylink_pcs;
> > +struct net_device;
> > +
> > +struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
> > +				       void __iomem *pcs_base, int
> > reg_width); +
> > +#endif /* __LINUX_PCS_ALTERA_TSE_H */  
> 
> --Sean

Thanks a lot for the review ! I'll do a round of tests with the
comments and send follow-up patches.

Best regards,

Maxime

