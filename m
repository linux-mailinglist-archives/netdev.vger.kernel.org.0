Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EAA65BD7E
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbjACJy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjACJy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:54:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72615FEF;
        Tue,  3 Jan 2023 01:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5QBwvdsaQ/rMsxBVhPGmbcWGtUN1VPHgFMR/l0i34XI=; b=uDe3nczbxGdgEhh9ch2BmOX0Jc
        WLJibEAUnu06vPA8iXrhDW/Ly7EXSZfh919sG09oIlLXG8qTQOZecQz8imnws6KEPkXfeOILJLB/w
        gNjEgL5F6A7xAlIZyU+P0sDKOPv3HB2vdH+KwGucoba3k74fs1MtAZQDOxruBa7cn8yQ5Wv8rWy5y
        QytHI/2ew3vaLw+tK+eQJsNe5yG8Iq6cUgSNcC/Pzc9gMpHpbry9wRRVpjszJ+0Kl/l0WOVEaQS/X
        5xAIXYiQpg1UrHu8I/MeIdaarXbfRcLRcNyEvq+mMTQo4cpk6G3toSqijYUC1XF80EGiayRK8EeaU
        XhA6wPlw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35902)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCdzw-0005B0-CT; Tue, 03 Jan 2023 09:54:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCdzu-0001xN-MD; Tue, 03 Jan 2023 09:54:18 +0000
Date:   Tue, 3 Jan 2023 09:54:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: phylink: Set host_interfaces for a
 non-sfp PHY
Message-ID: <Y7P7Sj/ZJ8V/9Pkq@shell.armlinux.org.uk>
References: <20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com>
 <20221226071425.3895915-2-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226071425.3895915-2-yoshihiro.shimoda.uh@renesas.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 04:14:23PM +0900, Yoshihiro Shimoda wrote:
> Set phy_dev->host_interfaces by pl->link_interface in
> phylink_fwnode_phy_connect() for a non-sfp PHY.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/phy/phylink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 09cc65c0da93..1958d6cc9ef9 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1809,6 +1809,7 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
>  		pl->link_interface = phy_dev->interface;
>  		pl->link_config.interface = pl->link_interface;
>  	}
> +	__set_bit(pl->link_interface, phy_dev->host_interfaces);

This is probably going to break Macchiatobin platforms, since we
declare that the link mode there is 10GBASE-R, we'll end up with
host_interfaces containing just this mode. This will cause the
88x3310 driver to select a rate matching interface mode, which the
mvpp2 MAC can't support.

If we want to fill host_interfaces in, then it needs to be filled in
properly - and by that I mean with all the host interface modes that
can be electrically supported - otherwise platforms will break.

So, sorry, but NAK on this change.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
