Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE12545D63
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346714AbiFJH1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343879AbiFJH1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:27:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01C5766E;
        Fri, 10 Jun 2022 00:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H0Po1e85toAXw3RbuejcHeMli/OCRToQR1vDolHiUUU=; b=rx0Zw5yu5PhdYdeuwAbaJfgswf
        tPS/HuOnRprB6tVdAKCZlnv8lAxe10w7a8wsYkCaPSwJwNoQ+XQDHIXYz6/f7vpbf+YqOxdzmQmva
        f91uWsQpJWTIlwP3zmz0kkAWH9pZnKcDAyKv45sjjmepDFUUVpvVZesCONMTg+RQVLmAyqVkbf9I4
        nxMbpa/DWNFebz5u/sM5zjEdC4WdyU2isa5dNlDh78sOAyqwSgvQ2TZ8Bpf9vo5Ad+0/1XGvkIbVR
        JN+HhO8r6b2S+x1oEd5wSyOfJtPeypbRo1jdfmSKlUmU0ULO1MUhWTWKQi4njI/gMNuKxNIMEsguQ
        9PjnC1eA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32812)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nzZ2z-0007Dy-Ap; Fri, 10 Jun 2022 08:27:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nzZ2l-0003Ut-L7; Fri, 10 Jun 2022 08:26:55 +0100
Date:   Fri, 10 Jun 2022 08:26:55 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>
Subject: Re: [PATCH net-next v2 3/6] net: pcs: xpcs: add CL37 1000BASE-X AN
 support
Message-ID: <YqLyP6ezO3C9Fe4t@shell.armlinux.org.uk>
References: <20220610032941.113690-1-boon.leong.ong@intel.com>
 <20220610032941.113690-4-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610032941.113690-4-boon.leong.ong@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 11:29:38AM +0800, Ong Boon Leong wrote:
> +static int xpcs_get_state_c37_1000basex(struct dw_xpcs *xpcs,
> +					struct phylink_link_state *state)
> +{
> +	int lpa, adv;
> +	int ret;
> +
> +	if (state->an_enabled) {
> +		/* Reset link state */
> +		state->link = false;
> +
> +		lpa = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_LPA);
> +		if (lpa < 0 || lpa & LPA_RFAULT)
> +			return lpa;
> +
> +		adv = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_ADVERTISE);
> +		if (adv < 0)
> +			return adv;
> +
> +		if (lpa & ADVERTISE_1000XFULL &&
> +		    adv & ADVERTISE_1000XFULL) {
> +			state->link = true;
> +			state->speed = SPEED_1000;
> +			state->duplex = DUPLEX_FULL;
> +		}

phylink_mii_c22_pcs_decode_state() is your friend here, will implement
this correctly, and will set lp_advertising correctly as well.

> +
> +		/* Clear CL37 AN complete status */
> +		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS, 0);
> +		if (ret < 0)
> +			return ret;

Why do you need to clear the interrupt status here? This function will
be called from a work queue sometime later after an interrupt has fired.
It will also be called at random times when userspace enquires what the
link parameters are, so clearing the interrupt here can result in lost
link changes.

> +static void xpcs_link_up_1000basex(struct dw_xpcs *xpcs, int speed,
> +				   int duplex)
> +{
> +	int val, ret;
> +
> +	switch (speed) {
> +	case SPEED_1000:
> +		val = BMCR_SPEED1000;
> +		break;
> +	case SPEED_100:
> +	case SPEED_10:
> +	default:
> +		pr_err("%s: speed = %d\n", __func__, speed);
> +		return;
> +	}
> +
> +	if (duplex == DUPLEX_FULL)
> +		val |= BMCR_FULLDPLX;
> +	else
> +		pr_err("%s: half duplex not supported\n", __func__);
> +
> +	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, val);
> +	if (ret)
> +		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));

Does this need to be done even when AN is enabled?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
