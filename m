Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E975C6D1ECD
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjCaLMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjCaLMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:12:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707992D52;
        Fri, 31 Mar 2023 04:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qLb75RwFmgNl6ZqqzFCzpYGIZT6emt47PE/6Jtu3p9w=; b=F7ksBtKCQ1QP1A/Qottd+yLJan
        YVB9I94f9E9gnJnskzXMzP0BBVReI96RgSnd/c56hrnDJV6dk1s6OGVqc2Np7AaYQs1irSmd2SShM
        dj443eUXA5BCB+WISZL6WwaSSXU4J4vcSNoGJAw+JQrzvHoZsLcDlgDiSTTF/5t+ZYe1LFbRg7WOm
        VbVsgM0Rhx0t+h/Pt9dlj7/sfbbT7y1XwbDKEkBHEgWQY5fu73Rjkq0w/mgSdWhwfmy/sK3GsJyXv
        1cn+mkyr3WaevuJnnfXoC0v2Jesgwk/+2Fj3Rlv4sdY4PA4gFeftylulnFgxUXHIjD01wlNqUS+uf
        ANUChXig==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59146)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1piCg8-0004qq-3E; Fri, 31 Mar 2023 12:12:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1piCg7-00016m-4t; Fri, 31 Mar 2023 12:12:19 +0100
Date:   Fri, 31 Mar 2023 12:12:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: Enable
 USXGMII mode for J784S4 CPSW9G
Message-ID: <ZCbAE7IIc8HcOdxl@shell.armlinux.org.uk>
References: <20230331065110.604516-1-s-vadapalli@ti.com>
 <20230331065110.604516-3-s-vadapalli@ti.com>
 <ZCaSXQFZ/e/JIDEj@shell.armlinux.org.uk>
 <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
 <ZCaYve8wYl15YRxh@shell.armlinux.org.uk>
 <7a9c96f4-6a94-4a2c-18f5-95f7246e10d5@ti.com>
 <ZCasBMNxaWk2+XVO@shell.armlinux.org.uk>
 <dea9ae26-e7f2-1052-58cd-f7975165aa96@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dea9ae26-e7f2-1052-58cd-f7975165aa96@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:23:16PM +0530, Siddharth Vadapalli wrote:
> 
> 
> On 31/03/23 15:16, Russell King (Oracle) wrote:
> > On Fri, Mar 31, 2023 at 02:55:56PM +0530, Siddharth Vadapalli wrote:
> >> Russell,
> >>
> >> On 31/03/23 13:54, Russell King (Oracle) wrote:
> >>> On Fri, Mar 31, 2023 at 01:35:10PM +0530, Siddharth Vadapalli wrote:
> >>>> Hello Russell,
> >>>>
> >>>> Thank you for reviewing the patch.
> >>>>
> >>>> On 31/03/23 13:27, Russell King (Oracle) wrote:
> >>>>> On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
> >>>>>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
> >>>>>> extra_modes member of the J784S4 SoC data. Additionally, configure the
> >>>>>> MAC Control register for supporting USXGMII mode. Also, for USXGMII
> >>>>>> mode, include MAC_5000FD in the "mac_capabilities" member of struct
> >>>>>> "phylink_config".
> >>>>>
> >>>>> I don't think TI "get" phylink at all...
> >>>>>
> >>>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>>>> index 4b4d06199b45..ab33e6fe5b1a 100644
> >>>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>>>> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
> >>>>>>  		mac_control |= CPSW_SL_CTL_GIG;
> >>>>>>  	if (interface == PHY_INTERFACE_MODE_SGMII)
> >>>>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
> >>>>>> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
> >>>>>> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
> >>>>>
> >>>>> The configuration of the interface mode should *not* happen in
> >>>>> mac_link_up(), but should happen in e.g. mac_config().
> >>>>
> >>>> I will move all the interface mode associated configurations to mac_config() in
> >>>> the v2 series.
> >>>
> >>> Looking at the whole of mac_link_up(), could you please describe what
> >>> effect these bits are having:
> >>>
> >>> 	CPSW_SL_CTL_GIG
> >>> 	CPSW_SL_CTL_EXT_EN
> >>> 	CPSW_SL_CTL_IFCTL_A
> >>
> >> CPSW_SL_CTL_GIG corresponds to enabling Gigabit mode (full duplex only).
> >> CPSW_SL_CTL_EXT_EN when set enables in-band mode of operation and when cleared
> >> enables forced mode of operation.
> >> CPSW_SL_CTL_IFCTL_A is used to set the RMII link speed (0=10 mbps, 1=100 mbps).
> > 
> > Okay, so I would do in mac_link_up():
> > 
> > 	/* RMII needs to be manually configured for 10/100Mbps */
> > 	if (interface == PHY_INTERFACE_MODE_RMII && speed == SPEED_100)
> > 		mac_control |= CPSW_SL_CTL_IFCTL_A;
> > 
> > 	if (speed == SPEED_1000)
> > 		mac_control |= CPSW_SL_CTL_GIG;
> > 	if (duplex)
> > 		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
> > 
> > I would also make mac_link_up() do a read-modify-write operation to
> > only affect the bits that it is changing.
> 
> This is the current implementation except for the SGMII mode associated
> operation that I had recently added. I will fix that. Also, the
> cpsw_sl_ctl_set() function which writes the mac_control value performs a read
> modify write operation.
> 
> > 
> > Now, for SGMII, I would move setting CPSW_SL_CTL_EXT_EN to mac_config()
> > to enable in-band mode - don't we want in-band mode enabled all the
> > time while in SGMII mode so the PHY gets the response from the MAC?
> 
> Thank you for pointing it out. I will move that to mac_config().
> 
> > 
> > Lastly, for RGMII at 10Mbps, you seem to suggest that you need RGMII
> > in-band mode enabled for that - but if you need RGMII in-band for
> > 10Mbps, wouldn't it make sense for the other speeds as well? If so,
> > wouldn't that mean that CPSW_SL_CTL_EXT_EN can always be set for
> > RGMII no matter what speed is being used?
> 
> The CPSW MAC does not support forced mode at 10 Mbps RGMII. For this reason, if
> RGMII 10 Mbps is requested, it is set to in-band mode.

What I'm saying is that if we have in-band signalling that is reliable
for a particular interface mode, why not always use it, rather than
singling out one specific speed as an exception? Does it not work in
100Mbps and 1Gbps?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
