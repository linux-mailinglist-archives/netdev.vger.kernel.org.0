Return-Path: <netdev+bounces-5305-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F14B3710A9C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B139E1C20ECD
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF331FBFD;
	Thu, 25 May 2023 11:11:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D68D512
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:52 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBB1191;
	Thu, 25 May 2023 04:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7pnqEDqTdXXIQOBLwb2FYHGZeiwAvkXUoR0xGIGm1tA=; b=Y5fWM8svQePSKhhdt6bnlWPjdN
	pZ6uBLzdn+6ZLX66yd6iAQSOPELpAsm2thocsaCrSBICaQtZpH+w3bUnUeot4cjW6uoEiJiKCNeEo
	Hn0UM8Oruh62o+WHwv+tl/PZnTilFT6xDZElEoyuozcUNcdyGxv0ln3N6Tg1Z5bTdz4KuHbdZTdI0
	v2NBZQ7iyQDxoBpGtCoF5ZRHR0YuQHEmi39yJynaQ4m0hD2JXpm1ux/qofPOcxXtoejMnAD2T2VSz
	UjuSYtERGhniQnzXMm9lrmwgxVsD3ZwcekQwK/a061aLpV7X72NKqDLos/hahiKnIEIhHTZCBX9nb
	JX3EUG6Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49710)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q28sj-0003y0-FZ; Thu, 25 May 2023 12:11:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q28sc-0002ct-V3; Thu, 25 May 2023 12:11:38 +0100
Date: Thu, 25 May 2023 12:11:38 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Mark Brown <broonie@kernel.org>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v2 1/4] net: mdio: Introduce a regmap-based mdio
 driver
Message-ID: <ZG9CajddFYKAFlO/@shell.armlinux.org.uk>
References: <20230525101126.370108-1-maxime.chevallier@bootlin.com>
 <20230525101126.370108-2-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525101126.370108-2-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 12:11:23PM +0200, Maxime Chevallier wrote:
> +struct mii_bus *devm_mdio_regmap_register(struct device *dev,
> +					  const struct mdio_regmap_config *config)
> +{
> +	struct mdio_regmap_config *mrc;
> +	struct mii_bus *mii;
> +	int rc;
> +
> +	if (!config->parent)
> +		return ERR_PTR(-EINVAL);
> +
> +	mii = devm_mdiobus_alloc_size(config->parent, sizeof(*mrc));
> +	if (!mii)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mrc = mii->priv;
> +	memcpy(mrc, config, sizeof(*mrc));
> +
> +	mrc->regmap = config->regmap;
> +	mrc->valid_addr = config->valid_addr;

You have just memcpy'd everything from config into mrc. Doesn't this
already include "regmap" and "valid_addr" ?

However, these are the only two things used, so does it really make
sense to allocate the full mdio_regmap_config structure, or would a
smaller data structure (of one pointer and one u8) be more appropriate?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

