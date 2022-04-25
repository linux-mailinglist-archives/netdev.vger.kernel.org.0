Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E9E50EB8F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiDYWYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343573AbiDYVgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:36:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F0F388E;
        Mon, 25 Apr 2022 14:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hYFXEchTbGOdJ3MTA3MM0r318Y2HGalUUBOLK/nlz3g=; b=eq+eJVNfAchZOCMK2PfLw/ViC4
        FqqEtR0ntH8u4sABg3uXKzvzSDpJbJFYSRaUZ7vXwf0Wt4nKHa16GUlxeisFwlC14+0wbl2rRDEGI
        c7pyUs0WMY/H3gTsBOaedbgbcWBU4XJYbe086I1KlLTecMOWJSRaGNjBcmjp9h4A9s5dZsbTJ5GPX
        JSxoI6/Utt7I1IYXjf5VL/lCU2QChzUsSG1XKGufSOwDDEENPxk9prQnZw0qtAezg+I3yzk0KlT7R
        tO1rXcxkOBAFOCC4hNvypTpH+HmUaBu//ebVJQyuwaKEyHaWdYhSikRhmVc4qPZ1bwRaU0+v69YOk
        2eFnJhqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58404)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nj6KT-0007oZ-Te; Mon, 25 Apr 2022 22:33:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nj6KQ-0006rn-LS; Mon, 25 Apr 2022 22:33:06 +0100
Date:   Mon, 25 Apr 2022 22:33:06 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, system@metrotek.ru
Subject: Re: [PATCH net-next RESEND] net: phy: marvell-88x2222: set proper
 phydev->port
Message-ID: <YmcTkkNcDrtdcGTM@shell.armlinux.org.uk>
References: <20220405150305.151573-1-i.bornyakov@metrotek.ru>
 <20220425041637.5946-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425041637.5946-1-i.bornyakov@metrotek.ru>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 07:16:37AM +0300, Ivan Bornyakov wrote:
> phydev->port was not set and always reported as PORT_TP.
> Set phydev->port according to inserted SFP module.
> 
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> ---
>  drivers/net/phy/marvell-88x2222.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
> index ec4f1407a78c..9f971b37ec35 100644
> --- a/drivers/net/phy/marvell-88x2222.c
> +++ b/drivers/net/phy/marvell-88x2222.c
> @@ -603,6 +603,7 @@ static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
>  	dev = &phydev->mdio.dev;
>  
>  	sfp_parse_support(phydev->sfp_bus, id, sfp_supported);
> +	phydev->port = sfp_parse_port(phydev->sfp_bus, id, sfp_supported);
>  	sfp_interface = sfp_select_interface(phydev->sfp_bus, sfp_supported);
>  
>  	dev_info(dev, "%s SFP module inserted\n", phy_modes(sfp_interface));
> @@ -639,6 +640,7 @@ static void mv2222_sfp_remove(void *upstream)
>  
>  	priv->line_interface = PHY_INTERFACE_MODE_NA;
>  	linkmode_zero(priv->supported);
> +	phydev->port = PORT_OTHER;

Can this PHY be used in dual-media mode, auto-switching between copper
and fibre? If so, is PORT_OTHER actually appropriate here, or should
the old value be saved when the module is inserted and restored when
it's removed?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
