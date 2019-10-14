Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BF3D68E6
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfJNRzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:55:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55266 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfJNRzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SDASWy6gE+FtXOyKEZYjL/u1mgOB67GFmhHwMTEMUhE=; b=f+QvfP7DeSpkBAi4we9sgfzGt
        yDnG3HOFTjtVx13lE5W6fSUqPr5u6fQ1hRqMgbEGERAYGupImDdvK/Bzm30oJ5NSsuiqTBQH520fJ
        cecOa9mFXsT091CXvBZq4tJCSxt55R8CXLqcPjz++ZNj0SABz4VHp67VoI139i1yIR6CtfGbMDMpE
        fiYUg3lI3b+ZGloew9xv6bUdQ6IamB1iby7PZ2OnOc5L0PlR05hULLpDLxO6n7VeMQoOBdwQ4jXSL
        jb11p7mfRuyduuYyMkLtA7o2gdWYD1ZfH/i9i9Wp0+SDK46+qpWRxRAMqYQRvMa2QqBvvE/ryMOIl
        EQIKzga5A==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:51238)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iK4ZA-0007dD-Pz; Mon, 14 Oct 2019 18:55:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iK4Z6-0004eU-0t; Mon, 14 Oct 2019 18:55:28 +0100
Date:   Mon, 14 Oct 2019 18:55:27 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 1/3] net: phylink: switch to using
 fwnode_gpiod_get_index()
Message-ID: <20191014175527.GQ25745@shell.armlinux.org.uk>
References: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
 <20191014174022.94605-2-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014174022.94605-2-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 10:40:20AM -0700, Dmitry Torokhov wrote:
> Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
> the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), but
> works with arbitrary firmware node.
> 
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: David S. Miller <davem@davemloft.net>

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
>  drivers/net/phy/phylink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index a5a57ca94c1a..c34ca644d47e 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -168,8 +168,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
>  			pl->link_config.pause |= MLO_PAUSE_ASYM;
>  
>  		if (ret == 0) {
> -			desc = fwnode_get_named_gpiod(fixed_node, "link-gpios",
> -						      0, GPIOD_IN, "?");
> +			desc = fwnode_gpiod_get_index(fixed_node, "link", 0,
> +						      GPIOD_IN, "?");
>  
>  			if (!IS_ERR(desc))
>  				pl->link_gpio = desc;
> -- 
> 2.23.0.700.g56cf767bdb-goog
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
