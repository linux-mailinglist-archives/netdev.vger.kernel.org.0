Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F9B641E01
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 17:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLDQpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 11:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLDQph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 11:45:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E5515707;
        Sun,  4 Dec 2022 08:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=txqQGHsKS2HB16R/t0tEkpRAAD52axCMAMnN4lRU2XM=; b=zdJkAsr1FUT1Df7AaadDT0P66W
        UmUNA0WXxlFaBQSONCam0m4UQn5Lh4X18dxPSCdECyoOeC0RZoK9Zv7zQGtWlgEWqvlptVtsS9ZFH
        4xUmyhrZKPZPQNrOjqHNQQKQTAm9OprMOJBi9NwIY74f1oZbFW/6IOEx9Yj2DAJbFGEju277jBvfv
        dUiMZoeOlwB1PFHDyBnTM69fIDuVNkjedqS/6HjTVYCmtgVdfpsaphF206pmPACO/Z8HlFUqncvK2
        6xgQ06eD7PlJ69y6JGT8Y7dqEogbia1lals+zXgxqQmpPd6ipeJPDgzauKnDffViyF+H79BX46F5+
        k2o3d0QQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35560)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1s7K-0005v7-Rv; Sun, 04 Dec 2022 16:45:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1s7G-0006QV-9m; Sun, 04 Dec 2022 16:45:22 +0000
Date:   Sun, 4 Dec 2022 16:45:22 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 2/4] phylib: Add support for 10BASE-T1S link
 modes and PLCA config
Message-ID: <Y4zOok/KQPATE8+/@shell.armlinux.org.uk>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <b2fffe32ffb0f6a6b4547e2e115bfad6c1139f70.1670119328.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2fffe32ffb0f6a6b4547e2e115bfad6c1139f70.1670119328.git.piergiorgio.beruto@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Dec 04, 2022 at 03:30:52AM +0100, Piergiorgio Beruto wrote:
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 5d08c627a516..5d8085fffffc 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -13,7 +13,7 @@
>   */
>  const char *phy_speed_to_str(int speed)
>  {
> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 99,
> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 102,
>  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>  		"If a speed or mode has been added please update phy_speed_to_str "
>  		"and the PHY settings array.\n");

I think you need to update settings[] in this file as well.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
