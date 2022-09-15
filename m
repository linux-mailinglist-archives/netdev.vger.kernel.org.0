Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C035B987D
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiIOKHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIOKHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:07:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0C967457;
        Thu, 15 Sep 2022 03:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lEcKAUl8uQYq+qOdV2UzEHdm6WUdIBi8uUUItFAWIow=; b=T6UvT04L11Ek3OkV3KRUdqTMBf
        yjoZrmtDvQ/81H8keWnDPKiXL76sDSLOBJ/WfNnjyQb7NlTMTbs14Ev/debcGweG8qatDja/Z9NAg
        DfVhm4dbsGOXdw4xMZEOk3xrZIHo8u3uvFTrZs5N5RRvxVwSQTQK5yqXcgTnr73EPBQZ9AYBeP3cD
        TLrF5WrwMvGqMC8wXFMc1kSduuCXbFybJzrtAxyvyVLA+dx0Ij1nCtWyzYOPrAcMvjg/n0/53f1O1
        UY156jdceqeLqbhOCyCRWuj4xrkSh/UhFqjcn+sf42oWgwlZYrdrbzGPSVQ47uRBidfylhiOiixiI
        CB0/Y0bw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34344)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYlmJ-0005RV-Vj; Thu, 15 Sep 2022 11:07:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYlmG-0002Wd-0t; Thu, 15 Sep 2022 11:07:24 +0100
Date:   Thu, 15 Sep 2022 11:07:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 5/8] net: ethernet: ti: am65-cpsw: Add support for
 fixed-link configuration
Message-ID: <YyL5WyA74/QRe/Y4@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-6-s-vadapalli@ti.com>
 <YyH8us424n3dyLYT@shell.armlinux.org.uk>
 <ab683d52-d469-35cf-b3b5-50c9edfc173b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab683d52-d469-35cf-b3b5-50c9edfc173b@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Sep 15, 2022 at 02:58:52PM +0530, Siddharth Vadapalli wrote:
> Hello Russell,
> 
> On 14/09/22 21:39, Russell King (Oracle) wrote:
> > On Wed, Sep 14, 2022 at 03:20:50PM +0530, Siddharth Vadapalli wrote:
> >> Check for fixed-link in am65_cpsw_nuss_mac_config() using struct
> >> am65_cpsw_slave_data's phy_node property to obtain fwnode. Since
> >> am65_cpsw_nuss_mac_link_up() is not invoked in fixed-link mode, perform
> >> the relevant operations in am65_cpsw_nuss_mac_config() itself.
> > 
> > Further to my other comments, you also fail to explain that, when in
> > fixed-link SGMII mode, you _emulate_ being a PHY - which I deduce
> > since you are sending the duplex setting and speed settings via the
> > SGMII control word. Also, as SGMII was invented for a PHY to be able
> > to communicate the media negotiation resolution to the MAC, SGMII
> > defines that the PHY fills in the speed and duplex information in
> > the control word to pass it to the MAC, and the MAC acknowledges this
> > information. There is no need (and SGMII doesn't permit) the MAC to
> > advertise what it's doing.
> > 
> > Maybe this needs to be explained in the commit message?
> 
> I had tested SGMII fixed-link mode using a bootstrapped ethernet layer-1
> PHY. Based on your clarification in the previous mails that there is an
> issue with the fixed-link mode which I need to debug, I assume that what
> you are referring to here also happens to be a consequence of that.
> Please let me know if I have misunderstood what you meant to convey.

I think what you're saying is that you have this setup:

  ethernet MAC <--SGMII link--> ethernet PHY <---> media

which you are operating in fixed link mode?

From the SGMII specification: "This is achieved by using the Auto-
Negotiation functionality defined in Clause 37 of the IEEE
Specification 802.3z. Instead of the ability advertisement, the PHY
sends the control information via its tx_config_Reg[15:0] as specified
in Table 1 whenever the control information changes. Upon receiving
control information, the MAC acknowledges the update of the control
information by asserting bit 14 of its tx_config_reg{15:0] as specified
in Table 1."

For the control word sent from the MAC to the PHY, table 1 specifies a
value of 0x4001. All the zero bits in that word which are zero are
marked as "Reserved for future use." There are no fields for speed and
duplex in this acknowledgement word to the PHY.

I hope this clears up my point.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
