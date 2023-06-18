Return-Path: <netdev+bounces-11808-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 174CB7347F8
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 21:20:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48F401C208D8
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DA98F6F;
	Sun, 18 Jun 2023 19:20:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1B93D74
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 19:20:55 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF234FE
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 12:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=iOkQl6LkHCgpNVmBsaucGMXt3xEkgXlKq2/3zYQzGiE=; b=ebzYBgZJIqW3jcYhOzy6pHp0jM
	b/9zp5/M0vy7zwzDHwmeWIbaRbiSlOUvbz9xlvi8+jBeR1oFTxXHYpukO6zb4TOLTYx34dvDP1Kph
	IZIwV8GeoMwoqJTxCQyjgHIJjUj63kECA1I3xYhWGzTlOnzKpiQwpgJ6lUxpz9MXVodzBPDMZN6Qj
	KqVz3tuyrQ9kaL2pIdi5kTre7Sw/AvxBLkE5orpypKR/+DZRUps5wP8lMUMK3bYSoKOaF9+VhrmaY
	e3pjfTbnHjYfp9knqSgo+iANYIBtaBKEEYNH3E8fi/3rEJckwsITNQxd3PHfSH21x4fhvwKAK0hbs
	W2g1Eogg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55726)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qAxxE-0007XT-Nk; Sun, 18 Jun 2023 20:20:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qAxxD-0004r8-Q8; Sun, 18 Jun 2023 20:20:51 +0100
Date: Sun, 18 Jun 2023 20:20:51 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>, Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v4 net-next 5/9] net: phy: Keep track of EEE configuration
Message-ID: <ZI9ZEy82KX0orkTi@shell.armlinux.org.uk>
References: <20230618184119.4017149-1-andrew@lunn.ch>
 <20230618184119.4017149-6-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618184119.4017149-6-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 08:41:15PM +0200, Andrew Lunn wrote:
> Have phylib keep track of the EEE configuration. This simplifies the
> MAC drivers, in that they don't need to store it.
> 
> Future patches to phylib will also make use of this information to
> further simplify the MAC drivers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/phy.c | 5 ++++-
>  include/linux/phy.h   | 3 +++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 629499e5aff0..48150d5626d8 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -1588,7 +1588,7 @@ EXPORT_SYMBOL(phy_get_eee_err);
>   * @data: ethtool_eee data
>   *
>   * Description: it reportes the Supported/Advertisement/LP Advertisement
> - * capabilities.
> + * capabilities, etc.

Any scope to drop the "it" and fix "reports" ?

Apart from that, looks good.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

