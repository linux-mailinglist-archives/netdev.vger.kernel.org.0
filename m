Return-Path: <netdev+bounces-8872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA12726278
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26DAC2812E1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C85B370C7;
	Wed,  7 Jun 2023 14:13:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E7634448
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:13:16 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FA410D7;
	Wed,  7 Jun 2023 07:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3T5RexQVbfA+VHoEyrP6w2iIV68bpAHWGq8VTMkiA/w=; b=cEtw03ybHWmNv3P0cpTTju7VmY
	gnJaPq8slq6VXz6q3KOP8ClMwRV+Jck8cT33qFMl5nhUJpeQ4GyLxcVBh34sgocejE7o0HmQt3PCG
	ohussvyYen6oTNC55KnNAGfA5T43bTD1TBKWgNVNta154LVRDh3Dc3czgeFMqgHp4HBbzLIuZR+oJ
	rSdCwkQ97yRmGw49ImZma0r2MXeSAFgnquVBxFNA6CYVGwSgsO8DsgacLIlJqN1APbpURaytdUR6S
	oL/gOgZZyJdhZPyUN5YRne3TTOlFSPeKq2VgeCAYtfSd9fAmiZ/qCL86L+wjeDhLDCgsF4Iy2xv2s
	LXljzaDw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46002)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6tuP-0007bf-Ff; Wed, 07 Jun 2023 15:13:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6tuL-0008IN-3D; Wed, 07 Jun 2023 15:13:05 +0100
Date: Wed, 7 Jun 2023 15:13:05 +0100
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
	Simon Horman <simon.horman@corigine.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Feiyang Chen <chenfeiyang@loongson.cn>
Subject: Re: [PATCH net-next v4 5/5] net: dwmac_socfpga: initialize local
 data for mdio regmap configuration
Message-ID: <ZICQcWb/iR0aB36J@shell.armlinux.org.uk>
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
 <20230607135941.407054-6-maxime.chevallier@bootlin.com>
 <ZIB306nKrhiru0hJ@shell.armlinux.org.uk>
 <20230607165409.7fddd49a@pc-7.home>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607165409.7fddd49a@pc-7.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:54:09PM +0200, Maxime Chevallier wrote:
> On Wed, 7 Jun 2023 13:28:03 +0100
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Wed, Jun 07, 2023 at 03:59:41PM +0200, Maxime Chevallier wrote:
> > > @@ -447,19 +446,22 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
> > >  		struct mdio_regmap_config mrc;
> > >  		struct regmap *pcs_regmap;
> > >  		struct mii_bus *pcs_bus;
> > >    
> > ...
> > > +		memset(&mrc, 0, sizeof(mrc));  
> > ...
> > >  		mrc.parent = &pdev->dev;
> > >  		mrc.valid_addr = 0x0;
> > > +		mrc.autoscan = false;  
> > 
> > Isn't this covered by the memset() ?
> 
> I have the same answer as for the above. It's redundant, but I don't
> think there's any harm having it set explicitely ?

No harm, just redundant. I don't think this is a good enough reason not
to merge it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

