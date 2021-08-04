Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16A03DFE95
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbhHDKAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbhHDKAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:00:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E6EC0613D5;
        Wed,  4 Aug 2021 03:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j5lO2ik8aZX/fBXDsdtP7IYjyG4MLMJq4fdi0iAKsuo=; b=Aj4eluIGVLB9jKyh24iJWoyXz
        YXiBikLBqGdAAkMixWx/xCisaJmbh9HKgZ+IQun0ny+a46TXZi9JsShDJtyjnGV1MkFMSk4qBA4DF
        o6R8NAuZbfQZn5qcBvqsdC95U57CbU3p4DaVTH+BnSs3ExZcMg2HvGvewCEpSww13U0xVofQ6y170
        l5wPbzoYimbefulsHOryCDjA8RY+dGv9fP+fASp8uWOtbsQ5C9THbqhKMUvssXrTkWin3Y+164DnQ
        CnWO37Cs8MsdiKqH9z8C41QLE+8BGnGPskRnO9R6lsjHVCU/ZgoJTNarFkeibDkikbvQtOkcPOlxE
        Tku7uYJOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46928)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mBDgp-0008Ux-La; Wed, 04 Aug 2021 10:59:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mBDgo-0004h9-4Q; Wed, 04 Aug 2021 10:59:54 +0100
Date:   Wed, 4 Aug 2021 10:59:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210804095954.GN22278@shell.armlinux.org.uk>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803235401.rctfylazg47cjah5@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 02:54:01AM +0300, Vladimir Oltean wrote:
> On Tue, Aug 03, 2021 at 10:24:27PM +0530, Prasanna Vengateshan wrote:
> > Thanks Vladimir & Andrew for the right pointers and info. The thread talks about
> > "rgmii-*" are going to be applied by the PHY only as per the doc. For fixed-
> > link, MAC needs to add the delay. This fixed-link can be No-PHY or MAC-MAC or
> > MAC to in-accessible PHY. In such case, i am not convinced in using rgmii-tx-
> > delay-ps & rgmii-rx-delay-ps on the MAC side and apply delay. I still think
> > proposed code in earlier mail thread should still be okay.
> 
> Why? I genuinely do not understand your reasoning
> 
>   - I read a thread that brings some arguments for which MACs should not
>     add delays based on the delay type in the "rgmii-*" phy-mode string
>     [ but based on explicit rgmii-tx-delay-ps and rgmii-rx-delay-ps
>     properties under the MAC OF node; this is written in the same
>     message as the quote that you chose ]
> 
>   - I acknowledge that in certain configurations I need the MAC to apply
>     internal delays.
> 
>   => I disagree that I should parse the rgmii-tx-delay-ps and
>      rgmii-rx-delay-ps OF properties of the MAC, just apply RGMII delays
>      based on the "rgmii-*" phy-mode string value, when I am a DSA CPU
>      port and in no other circumstance
> 
> ?!
> 
> I mean, feel free to feel convinced or not, but you have not actually
> brought any argument to the table here, or I'm not seeing it.
> 
> Anyway, I don't believe that whatever you decide to do with the RGMII
> delays is likely to be a decisive factor in whether the patches are
> accepted or not, considering the fact that traditionally, everyone did
> what suited their board best and that's about it; I will stop pushing back.
> 
> I have a theory that all the RGMII setups driven by the Linux PHY
> library cannot all work at the same time, with the same code base.
> Someone will sooner or later come and change a driver to make it do what
> they need, which will break what the original author intended, which
> will then be again patched, which will again break ..., which ....

This is why we need to have a clear definition of what the various
RGMII interface types are, how and where they are applied, and make
sure everyone sticks to that. We have this documented in
Documentation/networking/phy.rst.

The RGMII interface modes _only_ determine how the PHY should be
configured - they do not determine how the MAC should be configured
(with /maybe/ the exception of PHY_INTERFACE_MODE_RGMII allowing the
MAC to insert "default delays".)

In the case of a fixed link, there is no "PHY" as such, but the PHY
interface mode describes the properties of the link from the MAC
perspective, since it is specified in the MAC node. So, if we have
e.g. PHY_INTERFACE_MODE_RGMII_TXID, then from the MAC perspective,
we expect the device on the other end of the fixed link to be adding
the transmit data line delay. Since we have a fixed link though, we
have no way to communicate that to the other side - but the delays do
need to be configured to conform with RGMII.


An interesting point here, however, is the mv88e6xxx DSA driver - it
appears to set the RGMII delays for _all_ ports based on what is in
the DT node for the port. So, even if you have a port operating in
RGMII with an external PHY, specifying a phy-mode of rgmii-txid results
in that being configured at the DSA end of the RGMII link. Andrew - we
may need to look at that since it doesn't conform to what we have in
the documentation...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
