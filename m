Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123E3288C85
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389228AbgJIPYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387664AbgJIPYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 11:24:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 621E322265;
        Fri,  9 Oct 2020 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602257091;
        bh=k9G17mTZz28ct9y0bY6QaOemGH2fMJDzeTDJoyojocM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DGhaX14otWzGqqk0Gwhlv/Jjz8vVT//saJ8sAicZPut8gXNAYuPL9yeNkCYb/ZhxV
         1+rMdgM2QBNVrcLx6s9AXiyxQaybkb1+ewrvicfkNjciFTnFhFR1HNBrTnqZEPRM7R
         lDQSVRHi65FLWkDaSsEX3N5UjzeKZQvD8LwGtRaU=
Date:   Fri, 9 Oct 2020 08:24:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Richard Leitner <richard.leitner@skidata.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH][RESEND] net: fec: Fix PHY init after
 phy_reset_after_clk_enable()
Message-ID: <20201009082449.47ebbe90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6b600a23-cdf9-827f-2ff8-501ed0f1bdb1@denx.de>
References: <20201006135253.97395-1-marex@denx.de>
        <20201008175124.08f3fe5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6b600a23-cdf9-827f-2ff8-501ed0f1bdb1@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 09:21:06 +0200 Marek Vasut wrote:
> On 10/9/20 2:51 AM, Jakub Kicinski wrote:
> > On Tue,  6 Oct 2020 15:52:53 +0200 Marek Vasut wrote:  
> >> The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
> >> loses its register settings. The fec_enet_mii_probe() starts the PHY
> >> and does the necessary calls to configure the PHY via PHY framework,
> >> and loads the correct register settings into the PHY. Therefore,
> >> fec_enet_mii_probe() should be called only after the PHY has been
> >> reset, not before as it is now.
> >>
> >> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
> >> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >> Tested-by: Richard Leitner <richard.leitner@skidata.com>
> >> Signed-off-by: Marek Vasut <marex@denx.de>  
> > 
> > Is moving the reset before fec_enet_mii_probe() the reason you need the
> > second patch?
> > 
> >   net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()  
> 
> No, the second patch addresses separate issue.

I see. Applied to net and queued for stable, thank you!
