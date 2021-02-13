Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013A031ADEA
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBMURf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMURe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:17:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F64C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tSOsn/yP5MHPA3+qvEGGdcH69VJh3PzhebW1NKVmZvo=; b=1K+XVC75cIu1d7XeQL5I4tVc3
        Rx0W4tNeDH1TIs4BDVRAq5ADvCxXtGJLlQ6Kd4YKRPKM1tXw4V45vs7ZwFqVzdSMLEOm+ZOwOFJ/I
        y2iUWUT0T1UaWbwlmhWUaP85MklISsCFz28wh7HYuV/HU7Ta+Asef9E7wEHurLUQGgwvBUPohSXbP
        udVd6RBnfERD2YYMC7qOlhg/UiYHWx3qDUCcjX40ywGcdKNCDySm06wu43qaHgn4zvjY2NhiLXFc+
        Wu9Xaec6UJurxGQHCFKFf1F5YSv5oCR/+75m/iF+kxmTagijfRnDM5Vzr8QpU45Ov1b/Tjf6qFyYa
        H9n31080g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43008)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lB1LR-0008RY-OM; Sat, 13 Feb 2021 20:16:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lB1LP-0008Nm-4r; Sat, 13 Feb 2021 20:16:43 +0000
Date:   Sat, 13 Feb 2021 20:16:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210213201642.GS1463@shell.armlinux.org.uk>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213003641.gybb6gstjpkcwr6z@skbuf>
 <46c9b91b8f99605a26fbd7f26d5947b6@walle.cc>
 <1d90da5ef82f27942c7f5a5d844fc29a@walle.cc>
 <20210213185620.3lij467kne6cm4gk@skbuf>
 <4b3f06686cb58dcdda582bfdbd0abb85@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b3f06686cb58dcdda582bfdbd0abb85@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 08:57:46PM +0100, Michael Walle wrote:
> But then why bother with config_inband_aneg() at all and just enable
> it unconditionally in config_init(). [and maybe keep the return -EINVAL].
> Which then begs the question, does it makes sense on (Q)SGMII links at
> all?

There are three cases. There are PHYs which operate in SGMII mode:
1) with in-band signalling enabled or disabled.
2) only with in-band signalling enabled.
3) with no in-band signalling capability.

Most Marvell PHYs can be configured and fall into class (1), although
changing that configuration is disruptive to the entire PHY. There is
at least one Broadcom PHY we support that falls into class (3) and it
appears on SFP modules. It sounds like AR803x fall into class (2).

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
