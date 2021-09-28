Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31A641B022
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241023AbhI1Ndb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:33:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36028 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240991AbhI1Nda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 09:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ExKEVEwA4C3XkzZ1JKRavEbS319ueT+8Ea3ibeZ7H+0=; b=p/keIdxbpVjftVt7HmTkgRhWs5
        d7YrbL9hpWDfzNjTnettIRR+qIT3gCBgXKeWoy/rnsJ5oOav2kA9qTm7QUZigj8cuoKcnmKPYDEs5
        88h8rgQtqsuifqyVEWBLb0nh37tKzW23ANZXd1cD5xJItkHCCjqViT1McSfsRxqt49ZA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVDCt-008bol-IV; Tue, 28 Sep 2021 15:31:39 +0200
Date:   Tue, 28 Sep 2021 15:31:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     horatiu.vultur@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdio-ipq4019: Fix the error for an optional regs
 resource
Message-ID: <YVMZOy6gPhZCKIvy@lunn.ch>
References: <20210928132157.2027-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928132157.2027-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 09:21:57PM +0800, Cai Huoqing wrote:
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
> Fix Commit fa14d03e014a ("net: mdio-ipq4019: Make use of
> devm_platform_ioremap_resource()")

This is not a valid Fixes: tag.

Add to your ~/.gitconfig and add:

[pretty]
        fixes = Fixes: %h (\"%s\")

You can then do

git log --pretty=fixes fa14d03e014a

and get:

Fixes: fa14d03e014a ("net: mdio-ipq4019: Make use of devm_platform_ioremap_resource()")

Which is the correct format. Don't wrap it, if it is long.

      Andrew
