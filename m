Return-Path: <netdev+bounces-8871-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B96B726274
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B91381C20C07
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7907B370C6;
	Wed,  7 Jun 2023 14:12:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC3834448
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:12:29 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D25137;
	Wed,  7 Jun 2023 07:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uVhqIsWCbd8+nVpNyrP6aNc++SDBcJaAni/4NynllGk=; b=1SWC25IVs5qo9VOmQ1jVb+C602
	76A2R/8zSYH4u5oyF4RF9lv+X5M2bsBGYDANb6ElGArEkxhKvlxM+tosByB71IqW6se1Ur7uuIcS1
	CcWRbft8cI/KfQ4jIoEd4LA+y8X9NadGyPTsfNxsdh7aJz0zR5oS+lBfPth32k9j9yiU+NMcvVLhM
	QhDd/AZzUAQGKf7QYj1IGga3RS/EbWB5kzYT5CUUI4lt/2qnBa6ExNJ84fIdFgLd3DuQw+/xHtfKR
	DQdM+/QCAlW2u8/QL+LQc0osP9aKyRS2oifIkV47H+Nmpv5RGCXaFds0Z0thDPWvDcnl5S/4O7zFF
	IyZVjQeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48662)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6ttO-0007b8-SK; Wed, 07 Jun 2023 15:12:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6ttI-0008IG-UQ; Wed, 07 Jun 2023 15:12:00 +0100
Date: Wed, 7 Jun 2023 15:12:00 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Bhadram Varka <vbhadram@nvidia.com>,
	Samin Guo <samin.guo@starfivetech.com>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] stmmac: fix pcs_lynx link failure
Message-ID: <ZICQMHTowGQTzbxm@shell.armlinux.org.uk>
References: <20230607135638.1341101-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607135638.1341101-1-arnd@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 03:56:32PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The mdio code in stmmac now directly links into both the lynx_pcs and
> the xpcs device drivers, but the lynx_pcs dependency is only enforced
> for the altera variant of stmmac, which is the one that actually uses it.
> 
> Building stmmac for a non-altera platform therefore causes a link
> failure:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
> stmmac_mdio.c:(.text+0x1418): undefined reference to `lynx_pcs_destroy'
> 
> I've tried to come up with a patch that moves this dependency back into
> the dwmac-socfpga.c file, but there was no easy and obvious way to
> do this. It also seems that this would not be a proper solution, but
> instead there should be a real abstraction for pcs drivers that lets
> device drivers handle this transparently.

There is already a patch set on netdev fixing this properly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

