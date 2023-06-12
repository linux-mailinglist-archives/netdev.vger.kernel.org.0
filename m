Return-Path: <netdev+bounces-10092-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3073872C2D5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2AC42810C3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C943E17721;
	Mon, 12 Jun 2023 11:33:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF0EAD3C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:33:35 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC62BBD;
	Mon, 12 Jun 2023 04:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=36XT+W2jk5CIFa+WG0Q2ZcCHn/yHT0eHq3gE6BLySHQ=; b=U1lQrQVH5nBqDOyuohzmMYHg5j
	X8OJVBhjV1g+IZlMta6smtL5UyG5THn0GEpnDDC1GX5OLBe/7FyN6hw9VL1f4SNyzn7aKSq7PSp7G
	rxuRWlALT6mNIbCyeOh9uXuQMMwfduQiRgCR1tJXpcXsAfCsLDatmemMgCbEN3csev3SCSEOZbbZ4
	vfEIfita03v846CVuFGdpr4rnEADICC1l2nIC21h0sWEwRLuS/TxAB/5LDw/T/NVxbonuHCY/CP3h
	sLLXiFczoHwtDxrsIqydkENI/eQwKPRd9ZZa2MywV75dqpMCVzQQhJEYqkda1Xa/uYoKPl/Tyjaq3
	tmiMSjGQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38822)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8fnd-0005fn-Pp; Mon, 12 Jun 2023 12:33:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8fna-0004va-3b; Mon, 12 Jun 2023 12:33:26 +0100
Date: Mon, 12 Jun 2023 12:33:25 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: Re: [PATCH net-next 8/8] net: ethernet: mtk_eth_soc: add basic
 support for MT7988 SoC
Message-ID: <ZIcChW9FTHm+HbYV@shell.armlinux.org.uk>
References: <ZIUYubFtVGYHhlMt@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIUYubFtVGYHhlMt@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 01:43:37AM +0100, Daniel Golle wrote:
>  	if (updated) {
> -		val = mtk_r32(eth, MTK_MAC_MISC);
> +		val = mtk_r32(eth, reg);
>  		val = (val & mask) | set;
> -		mtk_w32(eth, val, MTK_MAC_MISC);
> +		mtk_w32(eth, val, reg);

mtk_m32() ?

> +	/* Force Port1 XGMAC Link Up */
> +	val = mtk_r32(eth, MTK_XGMAC_STS(MTK_GMAC1_ID));
> +	mtk_w32(eth, val | MTK_XGMAC_FORCE_LINK(MTK_GMAC1_ID),
> +		MTK_XGMAC_STS(MTK_GMAC1_ID));
> +
> +	/* Adjust GSW bridge IPG to 11 */
> +	val = mtk_r32(eth, MTK_GSW_CFG);
> +	val &= ~(GSWTX_IPG_MASK | GSWRX_IPG_MASK);
> +	val |= (GSW_IPG_11 << GSWTX_IPG_SHIFT) |
> +	       (GSW_IPG_11 << GSWRX_IPG_SHIFT);
> +	mtk_w32(eth, val, MTK_GSW_CFG);

mtk_m32() for both these?

> +	/* Setup gmac */
> +	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3) &&
> +	    mac->interface == PHY_INTERFACE_MODE_INTERNAL) {
> +		mtk_w32(mac->hw, MTK_GDMA_XGDM_SEL, MTK_GDMA_EG_CTRL(mac->id));
> +		mtk_w32(mac->hw, MAC_MCR_FORCE_LINK_DOWN, MTK_MAC_MCR(mac->id));
> +
> +		mtk_setup_bridge_switch(eth);


I think this should be documented somewhere - that
PHY_INTERFACE_MODE_INTERNAL means the MAC is connected to a switch.
However, I'm not sure that's the best condition to use - don't we have a
way for a MAC to test if it's connected to a DSA switch?

> +	/* Configure MDC Turbo Mode */
> +	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3)) {
> +		val = mtk_r32(eth, MTK_MAC_MISC_V3);
> +		val |= MISC_MDC_TURBO;
> +		mtk_w32(eth, val, MTK_MAC_MISC_V3);
> +	}
>  	val = mtk_r32(eth, MTK_PPSC);
> +	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1) ||
> +	    MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
> +		val |= PPSC_MDC_TURBO;
> +
> +	/* Configure MDC Divider */
>  	val &= ~PPSC_MDC_CFG;
> -	val |= FIELD_PREP(PPSC_MDC_CFG, divider) | PPSC_MDC_TURBO;
> +	val |= FIELD_PREP(PPSC_MDC_CFG, divider);
>  	mtk_w32(eth, val, MTK_PPSC);

More opportunities for mtk_m32().

> +	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_NETSYS_V3_BIT) &&
> +	    MTK_HAS_CAPS(mac->hw->soc->caps, MTK_ESW_BIT) &&
> +	    id == MTK_GMAC1_ID) {
> +		mac->phylink_config.mac_capabilities = MAC_ASYM_PAUSE |
> +						       MAC_SYM_PAUSE |
> +						       MAC_10000FD;
> +		phy_interface_zero(mac->phylink_config.supported_interfaces);

Were there bits set that you don't want?

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

