Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67A442EAE0
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 10:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhJOIF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 04:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbhJOIDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 04:03:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F9CC061570;
        Fri, 15 Oct 2021 01:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bYWqFyHq2blsyP+Zo1NBwrvvQwbci+xwOG+pn65vtYw=; b=KJu77SESNyV4pHBX9VJFT3Ox8Z
        m0J27ER/qds6Xoa6WYeVNzqIAKBjasMYPK2yWLme+gwJyb94Sli3PNzbPX+2EbLqqSESAEbsaJ5VU
        bgcpszLNvLxdB8fZHYeFMRw6lH7lXO6R9x6fCToW+lNzoc/m7bqzeIzehWD/trGLG8xK4TgYcltVp
        YVPUzlec1LrOWdscJlTYsl3l4zD7v0PRlqxu/WjRcEo5G+F0q1r2fmjpg/ydYvtt+aTvH+eGvazIz
        uCJE8w+u2JY2hpGq+8X1ytU0ZVpV1JV7SoyxkEdUY2rLT7x4S7G0Kivp4962stXMIuFr1kwpwXi1/
        nLnnNmrA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55128)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mbI9X-0002BJ-KS; Fri, 15 Oct 2021 09:01:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mbI9W-0002x4-Uq; Fri, 15 Oct 2021 09:01:18 +0100
Date:   Fri, 15 Oct 2021 09:01:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v2 12/13] net: phy: adjust qca8081 master/slave seed
 value if link down
Message-ID: <YWk1TjigOhfx36+3@shell.armlinux.org.uk>
References: <20211015073505.1893-1-luoj@codeaurora.org>
 <20211015073505.1893-13-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015073505.1893-13-luoj@codeaurora.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 03:35:04PM +0800, Luo Jie wrote:
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 4d283c0c828c..6c5dc4eed752 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -1556,6 +1556,22 @@ static int qca808x_read_status(struct phy_device *phydev)
>  	else
>  		phydev->interface = PHY_INTERFACE_MODE_SMII;
>  
> +	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
> +	 * excpet for master/slave configuration fault detected.

"except"

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
