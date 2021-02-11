Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26E3189BE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBKLqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhBKLnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:43:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261A3C061786;
        Thu, 11 Feb 2021 03:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=171MwOUvsWIHzLzoF2D6HOassCV+3rcVeB4dQ2ccn18=; b=k5ICOV/XdwTZJ4niWN8HTCoP/
        5ng/qZfsr3O8KnopiOljtDXzBDBRfEJ//77OY87zPaMX/gHd2Sg6DcbLbRKnsNVZ8In6UKhi604+q
        39zsZnr1+3NDkD3lgfCDVX82oPffh7MneFYKZTynSG+e6M+rjp21iNuz4Wpg+SmpWpRK+7nHq4oZB
        nkwDHzQcCKiMP9bCE1bd+TniuFWGofkQxwk3zzktsdELvBVzJ+9s9eGgHZZDK/t1jko6J2wd1RaQw
        kVqyegJH9YRiAqswESTn2woWI7EJnbbMIqiXoWcAO+Tk4Ti2B7kTq/kpsgb64r3G2b55xgqbLkcI1
        8ndn+QDSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42010)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lAAMr-00064X-RN; Thu, 11 Feb 2021 11:42:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lAAMo-00063s-64; Thu, 11 Feb 2021 11:42:38 +0000
Date:   Thu, 11 Feb 2021 11:42:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 05/15] net: mvpp2: add PPv23 version
 definition
Message-ID: <20210211114238.GD1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-6-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-6-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:48:52PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> This patch add PPv23 version definition.
> PPv23 is new packet processor in CP115.
> Everything that supported by PPv22, also supported by PPv23.
> No functional changes in this stage.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Acked-by: Marcin Wojtas <mw@semihalf.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> @@ -7049,6 +7049,11 @@ static int mvpp2_probe(struct platform_device *pdev)
>  			priv->port_map |= BIT(i);
>  	}
>  
> +	if (priv->hw_version != MVPP21) {
> +		if (mvpp2_read(priv, MVPP2_VER_ID_REG) == MVPP2_VER_PP23)
> +			priv->hw_version = MVPP23;
> +	}
> +

The only minor comment I have on this is... the formatting of the
above. Wouldn't:

	if (priv->hw_version >= MVPP22 &&
	    mvpp2_read(priv, MVPP2_VER_ID_REG) == MVPP2_VER_PP23)
		priv->hw_version = MVPP23;

read better?

Do we need to even check priv->hw_version here? Isn't this register
implemented in PPv2.1 where it contains the value zero?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
