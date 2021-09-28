Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF9C41B2EA
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241632AbhI1P21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 11:28:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241568AbhI1P20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 11:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Jm1S0uhg0JneRq7/45+JGruC/MxWeyoip6qNo5vwF0Q=; b=Jqb95eFAVIwPUyHL3+xKIs/O/T
        rPHoZU391BvYjoE0bZGt+tjpBeXVEePVU8cNFDyMCchckmN/gyQ/BZv8lCHxBaYIYe4d4UCN2a17k
        CDTuaNoYSiKPRxezJqb6Ofqkz5AW8ZNGFOVgGVI5SxNLj0zzn5FZdFxUQeVyRscIqsJo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVF05-008ccv-Vn; Tue, 28 Sep 2021 17:26:33 +0200
Date:   Tue, 28 Sep 2021 17:26:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     horatiu.vultur@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mdio-ipq4019: Fix the error for an optional regs
 resource
Message-ID: <YVM0KSp82olO07eK@lunn.ch>
References: <20210928134849.2092-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928134849.2092-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 09:48:49PM +0800, Cai Huoqing wrote:
> The second resource is optional which is only provided on the chipset
> IPQ5018. But the blamed commit ignores that and if the resource is
> not there it just fails.
> 
> the resource is used like this,
> 	if (priv->eth_ldo_rdy) {
> 		val = readl(priv->eth_ldo_rdy);
> 		val |= BIT(0);
> 		writel(val, priv->eth_ldo_rdy);
> 		fsleep(IPQ_PHY_SET_DELAY_US);
> 	}
> 
> This patch reverts that to still allow the second resource to be optional
> because other SoC have the some MDIO controller and doesn't need to
> second resource.
> 
> Fixes: fa14d03e014a ("net: mdio-ipq4019: Make use of devm_platform_ioremap_resource()")
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
