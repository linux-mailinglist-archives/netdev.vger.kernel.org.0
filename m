Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1EA230D0D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgG1PHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730574AbgG1PHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:07:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391B5C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 08:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lzn8PNdDZvf8bHQOkpcguoOxb19m7OLbWisMbbCi0WY=; b=Y8nd+JqGR4W2BHVNX8hVcSU1P
        NKTiQdi8/Et42zYxHyIv1knOyN9lq4V5JpIvAHg3Ud8BRs2fIC964r43qvV0uegNAyVKha8YzOBc1
        lPzrhgXlePtEdEGJmE3l+kXd+ClUg+U0pgsRr4Xm7D/58yCAnJaiK49WFxiIScDL6V7fBwztCKkqU
        xKXCRfa+MqvWb1xUqW2pGBnY1s9G3U42HzMdRaVbWoe/pt+xW426f87/v8h31IiipPqs5CuDAynp4
        M5PANEcfo7FR34lYQP0to72h/CvGnXQYqF3i0vBpoqd5SYay5oCHusEuFi4dlq+zZistBdjC8Z4E+
        PI/sarcYg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45280)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0RCK-0004P0-SI; Tue, 28 Jul 2020 16:07:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0RCK-0004kS-FR; Tue, 28 Jul 2020 16:07:20 +0100
Date:   Tue, 28 Jul 2020 16:07:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com
Subject: Re: [PATCH net-next v4 3/5] net: mdiobus: add clause 45 mdiobus
 write accessor
Message-ID: <20200728150720.GQ1551@shell.armlinux.org.uk>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
 <20200724080143.12909-4-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724080143.12909-4-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:01:41AM +0300, Ioana Ciornei wrote:
> Add the locked variant of the clause 45 mdiobus write accessor -
> mdiobus_c45_write().
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> Changes in v4:
>  - none
> 
>  include/linux/mdio.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index 898cbf00332a..3a88b699b758 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -358,6 +358,12 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
>  	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
>  }
>  
> +static inline int mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
> +				    u16 regnum, u16 val)
> +{
> +	return mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum), val);
> +}
> +
>  int mdiobus_register_device(struct mdio_device *mdiodev);
>  int mdiobus_unregister_device(struct mdio_device *mdiodev);
>  bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
