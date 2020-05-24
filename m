Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546FC1E03BE
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 00:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbgEXWnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 18:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388599AbgEXWm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 18:42:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94929C061A0E;
        Sun, 24 May 2020 15:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/LrcVT1btKqn93FHBR9FP0SUTFOHTkhJS9hiLmevHSo=; b=xecVH8CHbE83mzbEnf8mS+FMY
        U4ieHHS01dJCZ4BuTA+QeCjdyjeOIlRgKaIX1Yx7C27ddnq741lWEIcZlX1GRqdfJB0pKlOxwUrx7
        hLljnnD4Rt8oUazx0i/DcwQ6u9/+AytPla4NiDP7e2fxtlL/A3fREie/+cRtMgEO+oCG7gCnnBUfV
        J3XUsAhvc5qkX5FqeiAiiEc55DsHF5NOa3lUxNBWCL/OcLTlgLl2iz/xvfo4djgvHGcVZEr0/E0+F
        DzQsSthg8WFKYSAI5Xr4BUg0vtE1PikXo19roLmLfUe8qE23leXMDtXO4rWvb2Et4zIDHLdzC+yUb
        LfYC6+bTg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36528)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jczK4-0003I2-Cx; Sun, 24 May 2020 23:42:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jczJw-0003ha-1W; Sun, 24 May 2020 23:42:16 +0100
Date:   Sun, 24 May 2020 23:42:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pavel Machek <pavel@denx.de>
Cc:     Christian Herber <christian.herber@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: Re: signal quality and cable diagnostic
Message-ID: <20200524224215.GE1551@shell.armlinux.org.uk>
References: <AM0PR04MB7041E1F0913A90F40DFB31A386BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
 <20200524212757.GC1192@bug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524212757.GC1192@bug>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 11:27:57PM +0200, Pavel Machek wrote:
> > > The SNR seems to be most universal value, when it comes to comparing
> > > different situations (different links and different PHYs). The
> > > resolution of BER is not that detailed, for the NXP PHY is says only
> > > "BER below 1e-10" or not.
> > 
> > The point I was trying to make is that SQI is intentionally called SQI and NOT SNR, because it is not a measure for SNR. The standard only suggest a mapping of SNR to SQI, but vendors do not need to comply to that or report that. The only mandatory requirement is linking to BER. BER is also what would be required by a user, as this is the metric that determines what happens to your traffic, not the SNR.
> > 
> > So when it comes to KAPI parameters, I see the following options
> > - SQI only
> > - SQI + plus indication of SQI level at which BER<10^-10 (this is the only required and standardized information)
> > - SQI + BER range (best for users, but requires input from the silicon vendors)
> 
> Last option looks best to me... and it will mean that hopefully silicon vendors standartize
> something in future.

It already has been for > 1G PHYs, but whether they implement it is
another question altogether.  It's a 22-bit limiting counter in the
PCS.  There's also indications of "high BER".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
