Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F76C545D82
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346762AbiFJHbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244746AbiFJHba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:31:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860B0193FD;
        Fri, 10 Jun 2022 00:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7ehVVnHGNeCX8STqn/z69kwtCQzGXB+Z+xZvMBLoGV0=; b=nL86lEnP25nxC0q/9AYMxQQufI
        6E/ykfudlRfKm08L712JdI5gUFi5e8MhHsIYXZTXLuCgSHiLOIVnU2UMZ3GmVzqrp+b6iYWNZSITi
        VIIAnTTc76krunIBP+857GXkdhzrTYli8RWzCawcAq03kmqK9/+ufu0rtGUHgiRUd08/FFhzHKFhB
        3wLcLvXPQBgnvpqBNmL0ES6RyzDY0likckmumfQkFQfvtfoc7raVC+LEiptPxKpWX+dvcVsOh8WCK
        k4JqWmVK85+TjN+2h5MXVNQ9fCcY1p8oegaj5QNE70O9O5EWpektE2M4RoydHDf3IRSEtTLHT+whk
        MtY2Hlkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32814)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nzZ6x-0007EW-1V; Fri, 10 Jun 2022 08:31:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nzZ6s-0003V8-W6; Fri, 10 Jun 2022 08:31:11 +0100
Date:   Fri, 10 Jun 2022 08:31:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>
Subject: Re: [PATCH net-next v2 4/6] net: phylink: unset ovr_an_inband if
 fixed-link is selected
Message-ID: <YqLzPrEfcwqeKNX0@shell.armlinux.org.uk>
References: <20220610032941.113690-1-boon.leong.ong@intel.com>
 <20220610032941.113690-5-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610032941.113690-5-boon.leong.ong@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 11:29:39AM +0800, Ong Boon Leong wrote:
> If "fixed-link" DT or ACPI _DSD subnode is selected, it should take
> precedence over the value of ovr_an_inband passed by MAC driver.
> 
> Fixes: ab39385021d1 ("net: phylink: make phylink_parse_mode() support non-DT platform")
> Tested-by: Emilio Riva <emilio.riva@ericsson.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/net/phy/phylink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 066684b8091..566852815e0 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -609,8 +609,10 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
>  	const char *managed;
>  
>  	dn = fwnode_get_named_child_node(fwnode, "fixed-link");
> -	if (dn || fwnode_property_present(fwnode, "fixed-link"))
> +	if (dn || fwnode_property_present(fwnode, "fixed-link")) {
>  		pl->cfg_link_an_mode = MLO_AN_FIXED;
> +		pl->config->ovr_an_inband = false;
> +	}

ovr_an_inband was added to support "non-DT" platforms, and the only
place it's set is stmmac. I don't see why you'd want a driver to always
set this member, and then have phylink clear it - the driver should be
setting it correctly itself, otherwise it becomes a "maybe override AN
inband if certain conditions are met" flag inside phylink.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
