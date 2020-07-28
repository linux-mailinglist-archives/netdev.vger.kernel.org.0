Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1701230E8C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbgG1PzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730679AbgG1PzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:55:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D408C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 08:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xFwChVEz/enu9hhWEmzhbZ8s3PHLMlzW+0CY3JmoiPw=; b=YmTYv+W5WDaJjubjfYamax4zq
        QHL6rbaYy/ZroipjWIuyYYUYKBXGuuhRvKUUhMi27ghdpSntoHibX4PhsMCKdhKO4oatePXbkOypu
        Mq135MFDYkGQThSKaPJd+lOtsOHCorv+xPKIjKknQE0rDwqPnByVR14dfL40HLtHnKf184onROjxk
        90P5ZTA3hPqlJzI8G4u75X2+1ilkWEgOCBcdH0ktV4tLm2l1JRUOloDpWeeEXUpzS0GRKfb7reJ5h
        4Kybqi/UJQU/+NrZEhvwYHV9uV95mnJAvo68xY7Ey9y8oQSmYH911vNWsVVSO6ky8OVAXvrHTuHvh
        GuqgNgPYw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45292)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0Rwm-0004S3-Sd; Tue, 28 Jul 2020 16:55:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0Rwm-0004mp-9b; Tue, 28 Jul 2020 16:55:20 +0100
Date:   Tue, 28 Jul 2020 16:55:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Message-ID: <20200728155520.GS1551@shell.armlinux.org.uk>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 03:42:22PM +0000, Ioana Ciornei wrote:
> > Subject: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
> > 
> > RFC Because it needs 0-day build testing
> > 
> > The directory drivers/net/phy is getting rather cluttered with the growing
> > number of MDIO bus drivers and PHY device drivers. We also have one PCS
> > driver and more are expected soon.
> > 
> > Restructure the directory, moving MDIO bus drivers into /mdio.  PHY drivers into
> > /phy. The one current PCS driver is moved into /pcs and renamed to give it the
> > pcs- prefix which we hope will be followed by other PCS drivers.
> > 
> 
> Other than that, the new 'drivers/net/phy/phy/' path is somewhat repetitive but
> unfortunately I do not have another better suggestion.

There aren't many suitable names.  The options I can think of are:

drivers	(but is still repetitive, or drv for a shortened version)
media	(since they're driving media facing PHYs)
phy	(as already suggested by Andrew)

Nothing really stands out as a good choice.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
