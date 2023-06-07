Return-Path: <netdev+bounces-8873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B311272627B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A961281300
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B471D370C8;
	Wed,  7 Jun 2023 14:13:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2B834448
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:13:56 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E77137;
	Wed,  7 Jun 2023 07:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KleB+ugHaYugKJ9gSA4qsXI2OvMw4kTkMupOcPrFgkc=; b=KgsJPTlcL74jg3sbLH88TCp8zP
	H5aobn2X5sq+oDbRQfNmgF+1obpLKR9WADsbLjRtZU+oZu+gZq/cE6/TkVpn4XKSn5WQScCRzGFl4
	BrHYrT+OAs9SodL2QDNP8bQmoOePwjkfxc6qyXUG6y+1uRLG/9W2TbKmmV4wuXE2M8bZRpsevnh3+
	QoZu2hlL+7wXlgNZ+Z6SYtbl5PflXJnKWisugDC3KQEuGeDupn2nThBo9fwD0W3jXL1+T1rIZhSJe
	92nED/hawtNl3qbrp2qdGknIUZjyYjM8y39rtcY92CS3wv3b6RKQj+E5CZx/60D0wQmtUbL4Zc3Ff
	Nf+YS5TA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49616)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6tv6-0007cF-Fo; Wed, 07 Jun 2023 15:13:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6tv4-0008IV-4b; Wed, 07 Jun 2023 15:13:50 +0100
Date: Wed, 7 Jun 2023 15:13:50 +0100
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
Subject: Re: [PATCH net-next v4 0/5] Followup fixes for the dwmac and altera
 lynx conversion
Message-ID: <ZICQngRXett8g+gj@shell.armlinux.org.uk>
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 03:59:36PM +0200, Maxime Chevallier wrote:
> Hello everyone,
> 
> Here's yet another version of the cleanup series for the TSE PCS replacement
> by PCS Lynx. It includes Kconfig fixups, some missing initialisations
> and a slight rework suggested by Russell for the dwmac cleanup sequence,
> along with more explicit zeroing of local structures as per MAciej's
> review.

For the series, which brings an immediate fix to the problems people
are noticing:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

