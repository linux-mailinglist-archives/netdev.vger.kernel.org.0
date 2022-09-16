Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7171D5BA935
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiIPJQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiIPJPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:15:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5D1A3D1B;
        Fri, 16 Sep 2022 02:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pSIpQAr0tCD8INRC6Uo6dmdBErgTUjj7Lw5nPsYFUuk=; b=GqCqS7eMeV0yh/XxBnIQVboVXa
        pwVLOdWp4XdhD/8DVLoaL/alo8t8zbkEwAUHrmdZO4pAxj2cAHRe5Knri3mXSy2x9dGE8VgaC9y4+
        hRKswmwg8bTRbJX6/c0ECL0ID25DNvRFxwM14Eiw9yDSI3Roi6kfURtt0z8EyWBNfO6vQHGmRoBfN
        0JOFzT10PuqElQrbk7grjB3SRhAwo8XFETnLXFI99fD4+k2FpBcd7VH6mv0t7A2XfQn/yNXMnDjma
        mDngve8gKfFDwpT4qjp/HexwlP1EVWbsuAjGVN11QddLJ5Q2GIong/LWxg1TNxgYHMyUvFIZAbcHl
        Uc1JPXAA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34360)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oZ7Qx-0006U1-G0; Fri, 16 Sep 2022 10:14:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oZ7Qt-0003Ru-Kw; Fri, 16 Sep 2022 10:14:47 +0100
Date:   Fri, 16 Sep 2022 10:14:47 +0100
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
Message-ID: <YyQ+h4o9hqO+paUL@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-6-s-vadapalli@ti.com>
 <YyH8us424n3dyLYT@shell.armlinux.org.uk>
 <ab683d52-d469-35cf-b3b5-50c9edfc173b@ti.com>
 <YyL5WyA74/QRe/Y4@shell.armlinux.org.uk>
 <c76fdb7a-a95f-53c6-6e0e-d9283dd2de2d@ti.com>
 <YyQjqU7O5WRfrush@shell.armlinux.org.uk>
 <85398274-c0fb-6ef6-29b3-ad8d2465f8e4@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85398274-c0fb-6ef6-29b3-ad8d2465f8e4@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 02:33:23PM +0530, Siddharth Vadapalli wrote:
> Hello Russell,
> 
> On 16/09/22 12:50, Russell King (Oracle) wrote:
> > On Fri, Sep 16, 2022 at 10:24:48AM +0530, Siddharth Vadapalli wrote:
> >> On 15/09/22 15:37, Russell King (Oracle) wrote:
> >>> Hi,
> >>>
> >>> On Thu, Sep 15, 2022 at 02:58:52PM +0530, Siddharth Vadapalli wrote:
> >>>> Hello Russell,
> >>>>
> >>>> On 14/09/22 21:39, Russell King (Oracle) wrote:
> >>>>> On Wed, Sep 14, 2022 at 03:20:50PM +0530, Siddharth Vadapalli wrote:
> >>>>>> Check for fixed-link in am65_cpsw_nuss_mac_config() using struct
> >>>>>> am65_cpsw_slave_data's phy_node property to obtain fwnode. Since
> >>>>>> am65_cpsw_nuss_mac_link_up() is not invoked in fixed-link mode, perform
> >>>>>> the relevant operations in am65_cpsw_nuss_mac_config() itself.
> >>>>>
> >>>>> Further to my other comments, you also fail to explain that, when in
> >>>>> fixed-link SGMII mode, you _emulate_ being a PHY - which I deduce
> >>>>> since you are sending the duplex setting and speed settings via the
> >>>>> SGMII control word. Also, as SGMII was invented for a PHY to be able
> >>>>> to communicate the media negotiation resolution to the MAC, SGMII
> >>>>> defines that the PHY fills in the speed and duplex information in
> >>>>> the control word to pass it to the MAC, and the MAC acknowledges this
> >>>>> information. There is no need (and SGMII doesn't permit) the MAC to
> >>>>> advertise what it's doing.
> >>>>>
> >>>>> Maybe this needs to be explained in the commit message?
> >>>>
> >>>> I had tested SGMII fixed-link mode using a bootstrapped ethernet layer-1
> >>>> PHY. Based on your clarification in the previous mails that there is an
> >>>> issue with the fixed-link mode which I need to debug, I assume that what
> >>>> you are referring to here also happens to be a consequence of that.
> >>>> Please let me know if I have misunderstood what you meant to convey.
> >>>
> >>> I think what you're saying is that you have this setup:
> >>>
> >>>   ethernet MAC <--SGMII link--> ethernet PHY <---> media
> >>>
> >>> which you are operating in fixed link mode?
> >>
> >> Yes, and the other end is connected to my PC's ethernet port.
> >>
> >>>
> >>> From the SGMII specification: "This is achieved by using the Auto-
> >>> Negotiation functionality defined in Clause 37 of the IEEE
> >>> Specification 802.3z. Instead of the ability advertisement, the PHY
> >>> sends the control information via its tx_config_Reg[15:0] as specified
> >>> in Table 1 whenever the control information changes. Upon receiving
> >>> control information, the MAC acknowledges the update of the control
> >>> information by asserting bit 14 of its tx_config_reg{15:0] as specified
> >>> in Table 1."
> >>>
> >>> For the control word sent from the MAC to the PHY, table 1 specifies a
> >>> value of 0x4001. All the zero bits in that word which are zero are
> >>> marked as "Reserved for future use." There are no fields for speed and
> >>> duplex in this acknowledgement word to the PHY.
> >>>
> >>> I hope this clears up my point.
> >>
> >> Thank you for the detailed explanation. After reading the above, my
> >> understanding is that even in the fixed-link mode, the ethernet MAC is
> >> not supposed to advertise the speed and duplex settings. The ethernet
> >> MACs present on both ends of the connection are supposed to be set to
> >> the same speed and duplex settings via the devicetree node. Thus, only
> >> for my setup which happens to be a special case of fixed-link mode where
> >> the ethernet PHY is present, I am having to send the control word due to
> >> the presence of a PHY in between.
> > 
> > In SGMII, the control word is only passed between the ethernet MAC and
> > the ethernet PHY. It is not conveyed across the media.
> > 
> >> And, I am supposed to mention this in
> >> the commit message, which I haven't done. Please let me know if this is
> >> what I was supposed to understand.
> > 
> > If you implement this conventionally, then you don't need to mention it
> > in the commit message, because you're following the standard.
> > 
> >> I am planning to change to a proper fixed-link setup without any
> >> ethernet PHY between the MACs, for debugging the driver's fixed-link
> >> mode where the "mac_link_up()" is not invoked.
> > 
> > SGMII is designed for the setup in the diagram I provided in my previous
> > email. It is not designed for two MACs to talk direct to each other
> > without any ethernet PHY because of the asymmetric nature of the control
> > word.
> > 
> > The PHY sends e.g. a control word of 0x9801 for 1G full duplex. On
> > reception of that, the MAC responds with 0x4001. Finally, the PHY
> > responds with 0xd801 to acknowledge the receipt of the MAC response.
> > 
> > If both ends of the link are SGMII, both ends will be waiting for
> > the control word from a PHY which is not present, and the link will
> > not come up.
> > 
> > 1000base-X is a symmetric protocol where both ends of the link
> > advertise their capabilities, acknowledge each others abilities and
> > resolve the duplex and pause settings.
> > 
> > SGMII is a Cisco proprietary modification of 1000base-X designed for
> > communicating the results of media autonegotiation between an
> > ethernet PHY and ethernet MAC.
> 
> 
> I will try to implement and test SGMII mode in the conventional way with
> both the MAC and the PHY present. If I am unable to do so, I will revert
> to the current set of patches for the special case where the MAC
> emulates a PHY, and mention this setup in the commit message of the v2
> series. I hope this approach would be fine to proceed with. Please let
> me know in case of any suggestions.

What exact setups are you trying to support with this patch set?

If you're looking to only add support for SGMII, then all you need
to do is to make sure it works with a PHY. Fixed-link in SGMII only
makes sense if you're directly connected to something like a network
switch, but even then, network switches tend to use 1000base-X in a
fixed-link mode rather than SGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
