Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E3228C3F3
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbgJLVXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgJLVXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 17:23:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E22020797;
        Mon, 12 Oct 2020 21:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602537797;
        bh=5Q/+XSJHKidCg6mVZYK7B0wc8kOCY/ihwaZA2QUXPxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OKetiHcwoNd40QHkloC/oIkoDechN/aiDsvYykTDaeQZ+ziB2Zd6gu9pb63FlUWQm
         44VGl6WxIF9w32sxLb0Lk6WX4jvs764o4+FdrjHlQVVIbF19bMKsnKu9hjHXSTbMzt
         VX3jV1FyK4XlNZt1m5uXb24UQrS/3XY9qeHWmqxA=
Date:   Mon, 12 Oct 2020 14:23:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH V2] net: fec: Fix phy_device lookup for
 phy_reset_after_clk_enable()
Message-ID: <20201012142315.053f13f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010091000.33047-1-marex@denx.de>
References: <20201010091000.33047-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 11:10:00 +0200 Marek Vasut wrote:
> The phy_reset_after_clk_enable() is always called with ndev->phydev,
> however that pointer may be NULL even though the PHY device instance
> already exists and is sufficient to perform the PHY reset.
> 
> This condition happens in fec_open(), where the clock must be enabled
> first, then the PHY must be reset, and then the PHY IDs can be read
> out of the PHY.
> 
> If the PHY still is not bound to the MAC, but there is OF PHY node
> and a matching PHY device instance already, use the OF PHY node to
> obtain the PHY device instance, and then use that PHY device instance
> when triggering the PHY reset.
> 
> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Richard Leitner <richard.leitner@skidata.com>
> Cc: Shawn Guo <shawnguo@kernel.org>

Applied.
