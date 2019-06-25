Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC62D5276F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbfFYJDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:03:38 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48862 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730986AbfFYJDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:03:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ePK/es7C9pQl0On21DFk5DyYv3Tc0aYNKzqwAwwTRqY=; b=OXSNzGJlNZz7zi2MsqJzCp2AX
        +FjJH97SPooV/2cSGIjFIjfWtMQRJW1wdhfIheOEnl9jc4RHPnxtbcwpLPLlWtNnuv8AuCkJFAO0E
        OItcc6VyP/ew6/OTLQXic3iP+50calRXZcLZ5LZA1G+VFKDWt9AtnrPwKsZD/9dise9lPFkbfwnWu
        qclJm5T7ScGnAd0BnmZqMrys4Ko73zY/yYIJxlrEstE0DMS0zxdBIDT7sF7DsKlBxBYOfocDsDjnl
        qookUjFBmnWf2OD7HJ32Cwivso7Y/Up5KvB0day0ukhjEuV6ke+uC2vdRgLrrXkYvifK+GprA/3Pr
        4lr72uJ6Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58974)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfhMP-0005Ke-Om; Tue, 25 Jun 2019 10:03:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfhMK-00075B-AS; Tue, 25 Jun 2019 10:03:24 +0100
Date:   Tue, 25 Jun 2019 10:03:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v5 4/5] net: macb: add support for high speed interface
Message-ID: <20190625090324.c6tq2neksatfwljw@shell.armlinux.org.uk>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378355-14048-1-git-send-email-pthombar@cadence.com>
 <20190624134755.u3oq3xr6uergnfs5@shell.armlinux.org.uk>
 <SN2PR07MB2480CF15E11D54DA8C3B7319C1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN2PR07MB2480CF15E11D54DA8C3B7319C1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 08:49:33AM +0000, Parshuram Raju Thombare wrote:
> >>  	switch (state->interface) {
> >>  	case PHY_INTERFACE_MODE_NA:
> >> +	case PHY_INTERFACE_MODE_USXGMII:
> >> +	case PHY_INTERFACE_MODE_10GKR:
> >> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> >> +			phylink_set(mask, 10000baseCR_Full);
> >> +			phylink_set(mask, 10000baseER_Full);
> >> +			phylink_set(mask, 10000baseKR_Full);
> >> +			phylink_set(mask, 10000baseLR_Full);
> >> +			phylink_set(mask, 10000baseLRM_Full);
> >> +			phylink_set(mask, 10000baseSR_Full);
> >> +			phylink_set(mask, 10000baseT_Full);
> >> +			phylink_set(mask, 5000baseT_Full);
> >> +			phylink_set(mask, 2500baseX_Full);
> >> +			phylink_set(mask, 1000baseX_Full);
> >> +		}
> >If MACB_CAPS_GIGABIT_MODE_AVAILABLE is not set, are these interface
> >modes supported by the hardware?  If the PHY interface mode is not
> >supported, then the returned support mask must be cleared.[] 
> There are some configs which uses this macro to limit data rate to 100M 
> even if hardware support higher rates.

I'm sorry, this response does not address my statement, maybe I wasn't
clear enough.  I am asking about the *PHY* interface modes, in
other words (e.g.) PHY_INTERFACE_MODE_USXGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
