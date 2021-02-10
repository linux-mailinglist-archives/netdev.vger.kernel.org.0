Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4606831651A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhBJLWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhBJLUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:20:45 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778CBC06174A;
        Wed, 10 Feb 2021 03:20:05 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0C0D622EE4;
        Wed, 10 Feb 2021 12:20:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612956003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6CwUcBwGPFlThpPsNrtEei8sIEYx8VuG2BgHpu4Rnw=;
        b=psbwXUooa5w+6JKzyPYod12/c6exLd/Znu+gWFgD1opMBrPFYxYCh/TPkbyVKkOJ0mzXDl
        uP9jgdvbbs8CSjovScHpWKxMCZcnvtTg3AstyUNV+bIuMl32MEp29QPzZyXl1SaWzyoSAZ
        GbLqJtGEGAxIG0S1hXbBwxlxUQ+xhtI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Feb 2021 12:20:02 +0100
From:   Michael Walle <michael@walle.cc>
To:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: introduce phydev->port
In-Reply-To: <20210209163852.17037-1-michael@walle.cc>
References: <20210209163852.17037-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <41e4f35c87607e69cb87c4ef421d4a77@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 2021-02-09 17:38, schrieb Michael Walle:
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -308,7 +308,7 @@ void phy_ethtool_ksettings_get(struct phy_device 
> *phydev,
>  	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
>  		cmd->base.port = PORT_BNC;
>  	else
> -		cmd->base.port = PORT_MII;
> +		cmd->base.port = phydev->port;
>  	cmd->base.transceiver = phy_is_internal(phydev) ?
>  				XCVR_INTERNAL : XCVR_EXTERNAL;
>  	cmd->base.phy_address = phydev->mdio.addr;

Russell, the phylink has a similiar place where PORT_MII is set. I don't 
know
if we'd have to change that, too.

Also, I wanted to look into the PHY_INTERFACE_MODE_MOCA thing and if we 
can
get rid of the special case here and just set phydev->port to PORT_BNC 
in the
driver. Florian, maybe you have a comment on this?

-michael
