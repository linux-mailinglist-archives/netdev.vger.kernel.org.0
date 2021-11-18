Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866A5456074
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhKRQb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbhKRQb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:31:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB6EC061574;
        Thu, 18 Nov 2021 08:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iJONWK5pC/+lJWh7aMPzJ59swDI+mtk+OPmyLCba9Do=; b=znSTf81AAlmwJbkHyQTIbc9E7R
        x5BTymJCwZuYMPJTJYmaxuUKBhdxUC8a2TErT1ADWGTFsfzG7diug1fug9XIKpIwNrXmQa8Bkilvf
        F5T/RSlheOhgNUFOO2oCXG84DNn//neiTQGOL6nhIrlkSKr7//Fubm/emzrA2mYPgiHjJnRuwEEhb
        YrODUz0PCY7X7PJvL2L4OhnIHT+gkdqRhEiW2IB2FKygFBorV9DMYylW36jdenBVkz/SNI2Qn0QAY
        dpVVOI/9IioiaS7/5RYoYwmqZzBXQxDa6j3Bsr+6htiCWNY32lUbgI+ahHH07LerSjOEV4XDIxi7V
        nq/gqukQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55730)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnkHP-000399-EL; Thu, 18 Nov 2021 16:28:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnkHO-00044N-O4; Thu, 18 Nov 2021 16:28:54 +0000
Date:   Thu, 18 Nov 2021 16:28:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 5/8] net: phylink: pass supported PHY interface
 modes to phylib
Message-ID: <YZZ/RumbwsfQ1jrO@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-6-kabel@kernel.org>
 <YZZ+1LBrTxHzMJpP@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZZ+1LBrTxHzMJpP@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 05:27:00PM +0100, Andrew Lunn wrote:
> > +static int __init phylink_init(void)
> > +{
> > +	__set_bit(PHY_INTERFACE_MODE_USXGMII, phylink_sfp_interfaces);
> > +	__set_bit(PHY_INTERFACE_MODE_10GBASER, phylink_sfp_interfaces);
> > +	__set_bit(PHY_INTERFACE_MODE_10GKR, phylink_sfp_interfaces);
> > +	__set_bit(PHY_INTERFACE_MODE_5GBASER, phylink_sfp_interfaces);
> > +	__set_bit(PHY_INTERFACE_MODE_2500BASEX, phylink_sfp_interfaces);
> > +	__set_bit(PHY_INTERFACE_MODE_SGMII, phylink_sfp_interfaces);
> > +	__set_bit(PHY_INTERFACE_MODE_1000BASEX, phylink_sfp_interfaces);
> 
> Do we need to include PHY_INTERFACE_MODE_100BASEX here for 100BaseFX?
> Not sure we actually have any systems using it.

Most likely. I think we can now drop PHY_INTERFACE_MODE_10GKR from
this too.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
