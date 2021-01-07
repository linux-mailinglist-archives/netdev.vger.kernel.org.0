Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED42EC90A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 04:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAGDUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 22:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAGDUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 22:20:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 480D822BEA;
        Thu,  7 Jan 2021 03:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609989575;
        bh=l6Wn9Rs2IWSTtUm8c7IW6SPvlrUk79/vwe/pvPbmstU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rmd5/I8pwnF4RnmyAmTzpQ21qzL1fXSeebeU3vM3mhyn8Jq0tvzLN1yUm0BDCKO4Y
         kYTFkxKlgPFCIsMsdTFnIHrIN/QQcaXyNvqQX7uafXBOXE6NTWP0bPXWvs3jog0FR9
         Hg4F8qQNnzICa6RoM6y1vk1AlJpmwUOPqrU4fmuYFzKUzSH3sg4ArBMbELmpdj+K51
         It6afItoG9BLz7SLz7JydxsevcxDbioUWXxWAE9ZaP5rtSqvqmhsH/CZ+43yX42WCN
         07FtVPAYaR+uKCnjMow11EzVRC7Yw3UUqHsudpAdTCv0euLhjqJLu7qWEHBmsBkmIo
         UJ93kl4YVyZfg==
Date:   Thu, 7 Jan 2021 11:19:29 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v1] ARM: imx: mach-imx6ul: remove 14x14 EVK specific PHY
 fixup
Message-ID: <20210107031928.GS4142@dragon>
References: <20201209122051.26151-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209122051.26151-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 01:20:51PM +0100, Oleksij Rempel wrote:
> Remove board specific PHY fixup introduced by commit:
> 
> | 709bc0657fe6f9f5 ("ARM: imx6ul: add fec MAC refrence clock and phy fixup init")
> 
> This fixup addresses boards with a specific configuration: a KSZ8081RNA
> PHY with attached clock source to XI (Pin 8) of the PHY equal to 50MHz.
> 
> For the KSZ8081RND PHY, the meaning of the reg 0x1F bit 7 is different
> (compared to the KSZ8081RNA). A set bit means:
> 
> - KSZ8081RNA: clock input to XI (Pin 8) is 50MHz for RMII
> - KSZ8081RND: clock input to XI (Pin 8) is 25MHz for RMII
> 
> In other configurations, for example a KSZ8081RND PHY or a KSZ8081RNA
> with 25Mhz clock source, the PHY will glitch and stay in not recoverable
> state.
> 
> It is not possible to detect the clock source frequency of the PHY. And
> it is not possible to automatically detect KSZ8081 PHY variant - both
> have same PHY ID. It is not possible to overwrite the fixup
> configuration by providing proper device tree description. The only way
> is to remove this fixup.
> 
> If this patch breaks network functionality on your board, fix it by
> adding PHY node with following properties:
> 
> 	ethernet-phy@x {
> 		...
> 		micrel,led-mode = <1>;
> 		clocks = <&clks IMX6UL_CLK_ENET_REF>;
> 		clock-names = "rmii-ref";
> 		...
> 	};
> 
> The board which was referred in the initial patch is already fixed.
> See: arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied, thanks.
