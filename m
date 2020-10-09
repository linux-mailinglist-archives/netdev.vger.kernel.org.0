Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775FE287F99
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgJIAv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbgJIAv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 20:51:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61AFD22254;
        Fri,  9 Oct 2020 00:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602204686;
        bh=190OkmOlV4NKcZKO680wP/wd4PHuciGQoJFi1Ef5OMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=szMeBv0QHMNBQhfY2erGzJ9KOS1fpV/MevFqqnFDGgKg9omeI21rzTEO1M2AAsrXz
         v1II0e+03aP7UyApQTznqoKbG4TFlg0rAbPnoM8OtIo30ewPbQ20UyuUO/EZOcPTEz
         LcxgyBGR5BP9/Favfzo7c7ywztsckBgDDq9qm/YE=
Date:   Thu, 8 Oct 2020 17:51:24 -0700
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
Message-ID: <20201008175124.08f3fe5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006135253.97395-1-marex@denx.de>
References: <20201006135253.97395-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 15:52:53 +0200 Marek Vasut wrote:
> The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
> loses its register settings. The fec_enet_mii_probe() starts the PHY
> and does the necessary calls to configure the PHY via PHY framework,
> and loads the correct register settings into the PHY. Therefore,
> fec_enet_mii_probe() should be called only after the PHY has been
> reset, not before as it is now.
> 
> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Richard Leitner <richard.leitner@skidata.com>
> Signed-off-by: Marek Vasut <marex@denx.de>

Is moving the reset before fec_enet_mii_probe() the reason you need the
second patch?

  net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()
