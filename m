Return-Path: <netdev+bounces-8835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F14725F50
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89736281350
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE62834457;
	Wed,  7 Jun 2023 12:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42FC13AD6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:27:15 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222F91BFE;
	Wed,  7 Jun 2023 05:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sfgh0wXDuBsxdZzmvslnek33IenAM+jhwyPgNrDd72w=; b=OwBJgsqiqluv2F3opSH5pTIy3B
	2sn+QRCTBolIVAf7YtViwNt7IQhUAs8aXPLS/Xnct3/2QSsZc2v8E3HawXNcRZZxRh5qrPUgw2g1N
	TWpVSbI/9qVELIqYG31vgATU2iOEhOertibK+2pSOZGxLaRL2nlXAcGjOe7D3/gmzniVW/SIbbU6H
	U/zDgFJ+7WW+5OENkucUzFbTVfMHTRc9ez410dr6CgrzOxVNIaT+9ZkWbeIAu4vjjOGc7pWOg9oSc
	+ZFHPaJiL+DsS8jpmOM6vW4cAlbvw5A7HpRVlwuWBfZ7xq7+ywyGUmQQ61Bv7qIKTmhU32+AbNxZb
	aK8K7uLg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45564)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6sFU-0007Qp-LE; Wed, 07 Jun 2023 13:26:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6sFN-0008DF-MJ; Wed, 07 Jun 2023 13:26:41 +0100
Date: Wed, 7 Jun 2023 13:26:41 +0100
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
Subject: Re: [PATCH net-next v4 4/5] net: altera_tse: explicitly disable
 autoscan on the regmap-mdio bus
Message-ID: <ZIB3gQ7Ul5gi5/RC@shell.armlinux.org.uk>
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
 <20230607135941.407054-5-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607135941.407054-5-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 03:59:40PM +0200, Maxime Chevallier wrote:
> Set the .autoscan flag to false on the regmap-mdio bus, to avoid using a
> random uninitialized value. We don't want autoscan in this case as the
> mdio device is a PCS and not a PHY.

Isn't this now covered by patch 1's memset of mrc?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

