Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614323AE1C6
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 05:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhFUDCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 23:02:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhFUDCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 23:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XABV+fu7WuBVU7Zls9QFXa3bbNJ3I+XWXwAfc4iCagM=; b=XbDrYm+k9lPNM9DBO1jazoZUY3
        25ONFFIOVQqOCIShwwvslQogAmAk1mE6v5ZEDGV/m9HIYVHkVKZGWKopFLCycJAQeESERZrghSBF8
        YLT0rayJyNbComtrUjsR+wl10Kxt5Z8YTyBNOAUXDw7RTaxOKdJHCCSveMZYVrkGZyVA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvAA7-00ARav-E5; Mon, 21 Jun 2021 04:59:47 +0200
Date:   Mon, 21 Jun 2021 04:59:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Qing Zhang <zhangqing@loongson.cn>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rob Herring <robh+dt@kernel.org>,
        Huacai Chen <chenhc@lemote.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] MIPS: Loongson64: Add GMAC support for
 Loongson-2K1000
Message-ID: <YNAAo+ABaMVmArcM@lunn.ch>
References: <20210618025337.5705-1-zhangqing@loongson.cn>
 <20210618025337.5705-2-zhangqing@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618025337.5705-2-zhangqing@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +			gmac@3,1 {
> +				compatible = "pci0014,7a03.0",
> +						   "pci0014,7a03",
> +						   "pciclass0c0320",
> +						   "pciclass0c03",
> +						   "loongson, pci-gmac";
> +
> +				reg = <0x1900 0x0 0x0 0x0 0x0>;
> +				interrupts = <14 IRQ_TYPE_LEVEL_LOW>,
> +					     <15 IRQ_TYPE_LEVEL_LOW>;
> +				interrupt-names = "macirq", "eth_lpi";
> +				interrupt-parent = <&liointc0>;
> +				phy-mode = "rgmii";

rgmii? But you set PHY_INTERFACE_MODE_GMII?

> +				mdio {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					compatible = "snps,dwmac-mdio";
> +					phy1: ethernet-phy@1 {
> +						reg = <0>;

The value after the @ should match the reg value.

    Andrew
