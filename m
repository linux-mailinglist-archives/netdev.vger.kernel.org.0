Return-Path: <netdev+bounces-8511-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFC2724624
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 973272811CE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288D537B89;
	Tue,  6 Jun 2023 14:33:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD022DBC5
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:33:09 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA964E6C;
	Tue,  6 Jun 2023 07:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+6wSVTqC9hZ5yHI/YY+rD+TrYLWp05DjiD+d7o8/gMY=; b=yc5efNVbf19ymsAUUBaBnelebW
	JyPWfx8REfOqdg5mC0LbkgJmSxIHCLoHZnt1fwAd9Fb5fhMIGrRHRZGK7fy3cJf+WE/4st62wQM5+
	MOqXIOAFOBxT38GvyJnHWLcDmysjFpSEIAyjGe6F8rMIWrlnXnjUn3lVmLnvaoJ9sISul+HRAvj5j
	/EXmlgr4td587HKgTQSC5TzgBkjUYp6hQx9Be3A/FhskmJuqzh0lH+r38Q8PX4/x+6ZhjZQuOmIix
	3Lp2CsuH/l5Plxbdh2M5eVjziM82JUbkWg/dif1UHsooLS370KkCj/ULsxrD+gEltO5MmN0TtMOXe
	KumfUCXg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53228)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6Xk2-0005rf-Rf; Tue, 06 Jun 2023 15:32:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6Xjx-0007Dl-Vz; Tue, 06 Jun 2023 15:32:54 +0100
Date: Tue, 6 Jun 2023 15:32:53 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
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
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 0/3] Followup fixes for the dwmac and altera
 lynx conversion
Message-ID: <ZH9DlUqwm3YsNPu6@shell.armlinux.org.uk>
References: <20230606142144.308675-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606142144.308675-1-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 04:21:41PM +0200, Maxime Chevallier wrote:
> Following the TSE PCS removal and port of altera_tse and dwmac_socfpga,
> this series fixes some issues that slipped through the cracks.
> 
> Patch 1 fixes an unitialized struct in altera_tse
> 
> Patch 2 uses the correct Kconfig option for altera_tse
> 
> Patch 3 makes the Lynx PCS specific to dwmac_socfpga. This patch was
> originally written by Russell, my modifications just moves the
> #include<linux/pcs-lynx.h> around, to use it only in dwmac_socfpga.

Hi Maxime,

I'm sorry, but I think you need an extra patch added to this series.
Looking at include/linux/mdio/mdio-regmap.h, that defines:

struct mdio_regmap_config {
        struct device *parent;
        struct regmap *regmap;
        char name[MII_BUS_ID_SIZE];
        u8 valid_addr;
        bool autoscan;
};

In dwmac-socfpga.c, you have:

                struct mdio_regmap_config mrc;

                mrc.regmap = pcs_regmap;
                mrc.parent = &pdev->dev;
                mrc.valid_addr = 0x0;

                snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);

So that's a tick for parent, tick for regmap, tick for name, tick
for valid_addr, but... autoscan is left uninitialised.
devm_mdio_regmap_register() reads this, and uses it to decide
how to set mii->phy_mask, which will be randomly ~0 or ~BIT(0)
depending on the value of mrc.autoscan.

Other than that, the series looks good. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

