Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C62F12FE08
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgACUlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:41:14 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46200 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgACUlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gZbVNET/OsPO6V0htj252KliMtNNo0ubo1kZRWnZxlw=; b=K5PeTgGwEi2PwE6XaJjHqxB1d
        rOOlymHIeg1XA3BkfViXNpTtv8phIzqcuQ4xfWfQayxySmy9Z0ulHZ5le+WnEaCeoBCokHLTqPK09
        +TOavuxY10OI1xLOA2la3pyMOnuOCfYgvEcwOC5qciCPcBqSOGDf9fwoZ4A9lu1YzNQMyBfoygpPj
        li0daymWz3GH7t94guvImkLuGTtsZbt3By1DIjzBkOhXQOXhRPvWte4PhORWA+1XneVlqMIuYtA46
        hoTRQh6aMrc+svRU5tAt8M2VqiXaWHX12fJysJ6P1zkddPfoxhT9mlpdiD757I6NUce5Wy+0ht/3W
        GCMW2p6oA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33588)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1inTkn-0004B1-04; Fri, 03 Jan 2020 20:41:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1inTkk-0003RO-A6; Fri, 03 Jan 2020 20:41:02 +0000
Date:   Fri, 3 Jan 2020 20:41:02 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: switch to using
 PHY_INTERFACE_MODE_10GBASER rather than 10GKR
Message-ID: <20200103204102.GI25745@shell.armlinux.org.uk>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
 <E1inLVE-0006gO-0S@rmk-PC.armlinux.org.uk>
 <20200103202504.GQ1397@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103202504.GQ1397@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 09:25:04PM +0100, Andrew Lunn wrote:
> > For Marvell mvpp2, we detect 10GBASE-KR, and rewrite it to 10GBASE-R
> > for compatibility with existing DT - this is the only network driver
> > at present that makes use of PHY_INTERFACE_MODE_10GKR.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > @@ -5247,6 +5247,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
> >  		goto err_free_netdev;
> >  	}
> >  
> > +	if (phy_mode == PHY_INTERFACE_MODE_10GKR)
> > +		phy_mode = PHY_INTERFACE_MODE_10GBASER;
> 
> Hi Russell
> 
> Maybe consider adding a comment here, or suggest readers to read the
> commit message of the patch that added these two lines to get the full
> story.

It's a bit difficult to refer to the commit SHA in the commit itself,
but yes, that's a good idea. I'll send v2 shortly.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
