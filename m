Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9FC6D3F9A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjDCJAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjDCJAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:00:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58C86593;
        Mon,  3 Apr 2023 02:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4pzq/ulbMDg5zWJmPmU3OPDihRyIVMOepSvLXY15ZsE=; b=yBAq5fyS9ZtlI5VHH868tmM1lr
        aKYXFAGDplreid0RQ0fesF7qKjixM+rWrw7rYdaCvw8cm1IOL1NBaAM6FYnuUbyp9vXKBbWpIettv
        2s2dYPWeWOKXBFQs7RFkSfU1ze9HcTXuyfiNZvlOlDafvYwUC0sNdcKIw9NYlAuJ+mP88UjoKr0J3
        CigRKiq3MQ8dKBYiZJ8d7HqXmpbPyxYt38YmxTMI63DISq/8qdwT2s435FSIqpsn3hwi5iPzDEbTk
        gbMKCpMuHpnlvnRLVLOQoPi7x7SjkFW1hwUzFh+WkibiuU/gYJi/5txD1pqzMtsoyRUSRbzWD4p+d
        WjGJwIIg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50214)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjG2i-0002RL-K4; Mon, 03 Apr 2023 10:00:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjG2f-00045L-Mu; Mon, 03 Apr 2023 09:59:57 +0100
Date:   Mon, 3 Apr 2023 09:59:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: Enable
 USXGMII mode for J784S4 CPSW9G
Message-ID: <ZCqVjS7M2F49yS/6@shell.armlinux.org.uk>
References: <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
 <ZCaYve8wYl15YRxh@shell.armlinux.org.uk>
 <7a9c96f4-6a94-4a2c-18f5-95f7246e10d5@ti.com>
 <ZCasBMNxaWk2+XVO@shell.armlinux.org.uk>
 <dea9ae26-e7f2-1052-58cd-f7975165aa96@ti.com>
 <ZCbAE7IIc8HcOdxl@shell.armlinux.org.uk>
 <1477e0c3-bb92-72b0-9804-0393c34571d3@ti.com>
 <be166ab3-29f9-a18d-bbbd-34e7828453e4@ti.com>
 <ZCqPHM2/qismCaaN@shell.armlinux.org.uk>
 <5114b342-6727-b27c-bc8c-c770ed4baa31@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5114b342-6727-b27c-bc8c-c770ed4baa31@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 02:11:08PM +0530, Siddharth Vadapalli wrote:
> 
> 
> On 03/04/23 14:02, Russell King (Oracle) wrote:
> > On Mon, Apr 03, 2023 at 11:57:21AM +0530, Siddharth Vadapalli wrote:
> >> Hello Russell,
> >>
> >> On 31/03/23 19:16, Siddharth Vadapalli wrote:
> >>>
> >>>
> >>> On 31-03-2023 16:42, Russell King (Oracle) wrote:
> >>>> On Fri, Mar 31, 2023 at 04:23:16PM +0530, Siddharth Vadapalli wrote:
> >>>>>
> >>>>>
> >>>>> On 31/03/23 15:16, Russell King (Oracle) wrote:
> >>>>>> On Fri, Mar 31, 2023 at 02:55:56PM +0530, Siddharth Vadapalli wrote:
> >>>>>>> Russell,
> >>>>>>>
> >>>>>>> On 31/03/23 13:54, Russell King (Oracle) wrote:
> >>>>>>>> On Fri, Mar 31, 2023 at 01:35:10PM +0530, Siddharth Vadapalli wrote:
> >>>>>>>>> Hello Russell,
> >>>>>>>>>
> >>>>>>>>> Thank you for reviewing the patch.
> >>>>>>>>>
> >>>>>>>>> On 31/03/23 13:27, Russell King (Oracle) wrote:
> >>>>>>>>>> On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
> >>>>>>>>>>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
> >>>>>>>>>>> extra_modes member of the J784S4 SoC data. Additionally, configure the
> >>>>>>>>>>> MAC Control register for supporting USXGMII mode. Also, for USXGMII
> >>>>>>>>>>> mode, include MAC_5000FD in the "mac_capabilities" member of struct
> >>>>>>>>>>> "phylink_config".
> >>>>>>>>>>
> >>>>>>>>>> I don't think TI "get" phylink at all...
> >>>>>>>>>>
> >>>>>>>>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>>>>>>>>> index 4b4d06199b45..ab33e6fe5b1a 100644
> >>>>>>>>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>>>>>>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>>>>>>>>> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
> >>>>>>>>>>>  		mac_control |= CPSW_SL_CTL_GIG;
> >>>>>>>>>>>  	if (interface == PHY_INTERFACE_MODE_SGMII)
> >>>>>>>>>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
> >>>>>>>>>>> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
> >>>>>>>>>>> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
> >>>>>>>>>>
> >>>>>>>>>> The configuration of the interface mode should *not* happen in
> >>>>>>>>>> mac_link_up(), but should happen in e.g. mac_config().
> >>>>>>>>>
> >>>>>>>>> I will move all the interface mode associated configurations to mac_config() in
> >>>>>>>>> the v2 series.
> >>>>>>>>
> >>>>>>>> Looking at the whole of mac_link_up(), could you please describe what
> >>>>>>>> effect these bits are having:
> >>>>>>>>
> >>>>>>>> 	CPSW_SL_CTL_GIG
> >>>>>>>> 	CPSW_SL_CTL_EXT_EN
> >>>>>>>> 	CPSW_SL_CTL_IFCTL_A
> >>>>>>>
> >>>>>>> CPSW_SL_CTL_GIG corresponds to enabling Gigabit mode (full duplex only).
> >>>>>>> CPSW_SL_CTL_EXT_EN when set enables in-band mode of operation and when cleared
> >>>>>>> enables forced mode of operation.
> >>>>>>> CPSW_SL_CTL_IFCTL_A is used to set the RMII link speed (0=10 mbps, 1=100 mbps).
> >>>>>>
> >>>>>> Okay, so I would do in mac_link_up():
> >>>>>>
> >>>>>> 	/* RMII needs to be manually configured for 10/100Mbps */
> >>>>>> 	if (interface == PHY_INTERFACE_MODE_RMII && speed == SPEED_100)
> >>>>>> 		mac_control |= CPSW_SL_CTL_IFCTL_A;
> >>>>>>
> >>>>>> 	if (speed == SPEED_1000)
> >>>>>> 		mac_control |= CPSW_SL_CTL_GIG;
> >>>>>> 	if (duplex)
> >>>>>> 		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
> >>>>>>
> >>>>>> I would also make mac_link_up() do a read-modify-write operation to
> >>>>>> only affect the bits that it is changing.
> >>>>>
> >>>>> This is the current implementation except for the SGMII mode associated
> >>>>> operation that I had recently added. I will fix that. Also, the
> >>>>> cpsw_sl_ctl_set() function which writes the mac_control value performs a read
> >>>>> modify write operation.
> >>>>>
> >>>>>>
> >>>>>> Now, for SGMII, I would move setting CPSW_SL_CTL_EXT_EN to mac_config()
> >>>>>> to enable in-band mode - don't we want in-band mode enabled all the
> >>>>>> time while in SGMII mode so the PHY gets the response from the MAC?
> >>>>>
> >>>>> Thank you for pointing it out. I will move that to mac_config().
> >>>>>
> >>>>>>
> >>>>>> Lastly, for RGMII at 10Mbps, you seem to suggest that you need RGMII
> >>>>>> in-band mode enabled for that - but if you need RGMII in-band for
> >>>>>> 10Mbps, wouldn't it make sense for the other speeds as well? If so,
> >>>>>> wouldn't that mean that CPSW_SL_CTL_EXT_EN can always be set for
> >>>>>> RGMII no matter what speed is being used?
> >>>>>
> >>>>> The CPSW MAC does not support forced mode at 10 Mbps RGMII. For this reason, if
> >>>>> RGMII 10 Mbps is requested, it is set to in-band mode.
> >>>>
> >>>> What I'm saying is that if we have in-band signalling that is reliable
> >>>> for a particular interface mode, why not always use it, rather than
> >>>> singling out one specific speed as an exception? Does it not work in
> >>>> 100Mbps and 1Gbps?
> >>
> >> While the CPSW MAC supports RGMII in-band status operation, the link partner
> >> might not support it. I have also observed that forced mode is preferred to
> >> in-band mode as implemented for another driver:
> >> commit ade64eb5be9768e40c90ecb01295416abb2ddbac
> >> net: dsa: microchip: Disable RGMII in-band status on KSZ9893
> >>
> >> and in the mail thread at:
> >> https://lore.kernel.org/netdev/20200905160647.GJ3164319@lunn.ch/
> >> based on Andrew's suggestion, using forced mode appears to be better.
> >>
> >> Additionally, I have verified that switching to in-band status causes a
> >> regression. Thus, I will prefer keeping it in forced mode for 100 and 1000 Mbps
> >> RGMII mode which is the existing implementation in the driver. Please let me know.
> > 
> > Okay, so what this seems to mean is if you have a PHY that does not
> > support in-band status in RGMII mode, then 10Mbps isn't possible -
> > because the MAC requires in-band status mode to select 10Mbps.
> > To put it another way, in such a combination, 10Mbps link modes
> > should not be advertised, nor should they be reported to userspace
> > as being supported.
> > 
> > Is that correct?
> 
> Yes, if the PHY does not support in-band status, 10 Mbps RGMII will not work,
> despite the MAC supporting 10 Mbps in-band RGMII. However, I notice the following:
> If the RGMII interface speed is set to 10 Mbps via ethtool, but the:
> managed = "in-band-status";
> property is not mentioned in the device-tree, the interface is able to work with
> 10 Mbps mode with the PHY. This is with the CPSW MAC configured for in-band mode
> of operation at 10 Mbps RGMII mode. Please let me know what this indicates,
> since it appears to me that 10 Mbps is functional in this special case (It might
> be an erroneous configuration).

I think you need to check carefully what is going on.

Firstly, if you as the MAC is choosing to enable in-band status mode,
but phylink isn't using in-band status mode, that is entirely a matter
for your MAC driver.

Secondly, you need to research what the PHY does during the inter-frame
time (when in-band status would be transferred). This is when RX_CTL
is 0,0, RX_DV is 0, RX_ER is 0.

For in-band 10Mbps mode to work, RXD nibbles would need to be x001
(middle two bits indicate RX clock = 2.5MHz clock for 10Mbps, lsb
indicates link up). MSB determines duplex. Remember that 10Mbps can
appear to work with mismatched duplex settings but can cause chaos on
networks when it disagrees with what the rest of the network is doing.

So, I think before one says "setting in-band mode for 10Mbps with a
PHY that doesn't support in-band" really needs caution and research
to check what _actually_ ends up happening, and whether it is really
correct to do this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
