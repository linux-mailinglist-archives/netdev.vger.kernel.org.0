Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3606831D5E6
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 08:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhBQHxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 02:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhBQHxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 02:53:00 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE04C06174A;
        Tue, 16 Feb 2021 23:52:20 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C78E822248;
        Wed, 17 Feb 2021 08:52:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613548337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKh+gfEqqlFc94dAOj7OS27dRVkaacBwIQCXacI70Vw=;
        b=fsH7FhMQAGvI6p8jhDwUoOKkHgtUHcUgx8MPadVfacxJ7lh0syvRzpy3oGTw0xVU+GqsxO
        HSQgV9UP+zLsRiN2ltg/3ToTAJG0qMG2vTACRtRakmWrg9vwhtoe2v7cvBF3d+28x/qEIV
        MJnpGhg26L40VYkdSpAkShibyr8Dkpc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 17 Feb 2021 08:52:08 +0100
From:   Michael Walle <michael@walle.cc>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
In-Reply-To: <YCy1F5xKFJAaLBFw@mwanda>
References: <YCy1F5xKFJAaLBFw@mwanda>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <5b9d452ecbbce752c0eb85ad8a0ccce4@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-17 07:17, schrieb Dan Carpenter:
> Smatch warns that there is a locking issue in this function:
> 
> drivers/net/phy/icplus.c:273 ip101a_g_config_intr_pin()
> warn: inconsistent returns '&phydev->mdio.bus->mdio_lock'.
>   Locked on  : 242
>   Unlocked on: 273
> 
> It turns out that the comments in phy_select_page() say we have to call
> phy_restore_page() even if the call to phy_select_page() fails.
> 
> Fixes: f9bc51e6cce2 ("net: phy: icplus: fix paged register access")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Michael Walle <michael@walle.cc>

-michael
