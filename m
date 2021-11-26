Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8BF45EB51
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 11:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376923AbhKZK1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 05:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236925AbhKZKZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 05:25:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE2AC0617A0;
        Fri, 26 Nov 2021 02:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h9UPv+50JCaEFOcwRwsn9FMVjmHhh3/liD/qtV8KSCA=; b=sejiql9+IejN+6ZkDDn8Fcjy5z
        i4tz8aWQXrmeYnaqLtSrTrh785s98pGwWXO8zAmXCy2DfXUQy+5OepEWBMeMWtaaIevVI2R9nhnJY
        4y5puldJ3F2wi6lx+0oy/6HHWelHjWExl7FOF0KiN86ZRN2crRvI01A33mIYdFzOt+lyXTLHiuCdJ
        5lRokC8DAdmFxHNscOAqFUs0L4DT3+cPWguqU/g3NZnruguZgHJF8pggzuykcSGoInHmaFJ+OlwnW
        kmIkiDMV03hm61LVpB3Qp2NuPgnVmhsbhREn26OvgZOte2iHW0lYIgoZanQjtXMFByCkRDZr1XxEE
        a8OY70Lw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55908)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mqYEV-0002um-8x; Fri, 26 Nov 2021 10:13:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mqYER-0003CE-Jx; Fri, 26 Nov 2021 10:13:27 +0000
Date:   Fri, 26 Nov 2021 10:13:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: mdio: fixup ethernet phy module auto-load
 function
Message-ID: <YaCzR5457hi4YI5G@shell.armlinux.org.uk>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <1637919957-21635-2-git-send-email-zhuyinbo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1637919957-21635-2-git-send-email-zhuyinbo@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 05:45:57PM +0800, Yinbo Zhu wrote:
> the phy_id is only phy identifier, that phy module auto-load function
> should according the phy_id event rather than other information, this
> patch is remove other unnecessary information and add phy_id event in
> mdio_uevent function and ethernet phy module auto-load function will
> work well.
> 
> Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
> ---
>  drivers/net/phy/mdio_bus.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 6865d93..999f0d4 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -962,12 +962,12 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
>  
>  static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
> -	int rc;
> +	struct phy_device *pdev;
>  
> -	/* Some devices have extra OF data and an OF-style MODALIAS */
> -	rc = of_device_uevent_modalias(dev, env);
> -	if (rc != -ENODEV)
> -		return rc;
> +	pdev = to_phy_device(dev);
> +
> +	if (add_uevent_var(env, "MODALIAS=mdio:p%08X", pdev->phy_id))
> +		return -ENOMEM;
>  
>  	return 0;
>  }

No. I think we've been over the reasons already. It _will_ break
existing module loading.

If I look at the PHY IDs on my Clearfog board:

/sys/bus/mdio_bus/devices/f1072004.mdio-mii:00/phy_id:0x01410dd1
/sys/bus/mdio_bus/devices/mv88e6xxx-0:00/phy_id:0x01410eb1
/sys/bus/mdio_bus/devices/mv88e6xxx-0:01/phy_id:0x01410eb1
/sys/bus/mdio_bus/devices/mv88e6xxx-0:02/phy_id:0x01410eb1
/sys/bus/mdio_bus/devices/mv88e6xxx-0:03/phy_id:0x01410eb1
/sys/bus/mdio_bus/devices/mv88e6xxx-0:04/phy_id:0x01410eb1
/sys/bus/mdio_bus/devices/mv88e6xxx-0:0f/phy_id:0x01410ea1

and then look at the PHY IDs that the kernel uses in the drivers, and
thus will be used in the module's alias tables.

#define MARVELL_PHY_ID_88E1510          0x01410dd0
#define MARVELL_PHY_ID_88E1540          0x01410eb0
#define MARVELL_PHY_ID_88E1545          0x01410ea0

These numbers are different. This is not just one board. The last nibble
of the PHY ID is generally the PHY revision, but that is not universal.
See Atheros PHYs, where we match the entire ID except bit 4.

You can not "simplify" the "ugly" matching like this. It's the way it is
for good reason. Using the whole ID will _not_ cause a match, and your
change will cause a regression.

> @@ -991,7 +991,7 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
>  };
>  
>  struct bus_type mdio_bus_type = {
> -	.name		= "mdio_bus",
> +	.name		= "mdio",
>  	.dev_groups	= mdio_bus_dev_groups,
>  	.match		= mdio_bus_match,
>  	.uevent		= mdio_uevent,

Definitely no, this won't be accepted, and is in any case a separate
change that is unrelated to the first hunk of the patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
