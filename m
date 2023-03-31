Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A546D1CE8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjCaJsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjCaJsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:48:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4638E2030B;
        Fri, 31 Mar 2023 02:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5e/G3DBJUFF9eH6sBuJe4mAk9YdK5SadNxqGTedPXHQ=; b=FN6Oh7cZQY+9EseAXTsV44umkg
        jU9EIxm+DjuEVOEi6zB+R+n+JJf0xqoaC56aU4BPisyKMxiBITRp//hDa6xdNUPJDm2D41Ieh01oc
        9BUmnexAlHjDQaAlq75+OKTIdqaOApMYI5rI2MOP3dgYBEbh/HLlgk5LP/jxKLEGP2DMu9+GjoMBr
        zwSoe6l9V9YF+vzxoGXA7PIyB0Ay4okN7tKP4LAi6RM+rrZGNOdKRrRYoCJEBJInNQlB0I1MehpsU
        3Q8iJZKib3ibmLWiOVdgS2aLsbQB1xwShTJOUXC8f8wsE6dmEk0GXtnE4v5r7Ldjk78G2CIF4SLyW
        k5322s1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51256)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1piBLK-0004Z8-5t; Fri, 31 Mar 2023 10:46:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1piBLJ-00013Q-0x; Fri, 31 Mar 2023 10:46:45 +0100
Date:   Fri, 31 Mar 2023 10:46:44 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: Enable
 USXGMII mode for J784S4 CPSW9G
Message-ID: <ZCasBMNxaWk2+XVO@shell.armlinux.org.uk>
References: <20230331065110.604516-1-s-vadapalli@ti.com>
 <20230331065110.604516-3-s-vadapalli@ti.com>
 <ZCaSXQFZ/e/JIDEj@shell.armlinux.org.uk>
 <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
 <ZCaYve8wYl15YRxh@shell.armlinux.org.uk>
 <7a9c96f4-6a94-4a2c-18f5-95f7246e10d5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a9c96f4-6a94-4a2c-18f5-95f7246e10d5@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 02:55:56PM +0530, Siddharth Vadapalli wrote:
> Russell,
> 
> On 31/03/23 13:54, Russell King (Oracle) wrote:
> > On Fri, Mar 31, 2023 at 01:35:10PM +0530, Siddharth Vadapalli wrote:
> >> Hello Russell,
> >>
> >> Thank you for reviewing the patch.
> >>
> >> On 31/03/23 13:27, Russell King (Oracle) wrote:
> >>> On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
> >>>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
> >>>> extra_modes member of the J784S4 SoC data. Additionally, configure the
> >>>> MAC Control register for supporting USXGMII mode. Also, for USXGMII
> >>>> mode, include MAC_5000FD in the "mac_capabilities" member of struct
> >>>> "phylink_config".
> >>>
> >>> I don't think TI "get" phylink at all...
> >>>
> >>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> index 4b4d06199b45..ab33e6fe5b1a 100644
> >>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
> >>>>  		mac_control |= CPSW_SL_CTL_GIG;
> >>>>  	if (interface == PHY_INTERFACE_MODE_SGMII)
> >>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
> >>>> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
> >>>> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
> >>>
> >>> The configuration of the interface mode should *not* happen in
> >>> mac_link_up(), but should happen in e.g. mac_config().
> >>
> >> I will move all the interface mode associated configurations to mac_config() in
> >> the v2 series.
> > 
> > Looking at the whole of mac_link_up(), could you please describe what
> > effect these bits are having:
> > 
> > 	CPSW_SL_CTL_GIG
> > 	CPSW_SL_CTL_EXT_EN
> > 	CPSW_SL_CTL_IFCTL_A
> 
> CPSW_SL_CTL_GIG corresponds to enabling Gigabit mode (full duplex only).
> CPSW_SL_CTL_EXT_EN when set enables in-band mode of operation and when cleared
> enables forced mode of operation.
> CPSW_SL_CTL_IFCTL_A is used to set the RMII link speed (0=10 mbps, 1=100 mbps).

Okay, so I would do in mac_link_up():

	/* RMII needs to be manually configured for 10/100Mbps */
	if (interface == PHY_INTERFACE_MODE_RMII && speed == SPEED_100)
		mac_control |= CPSW_SL_CTL_IFCTL_A;

	if (speed == SPEED_1000)
		mac_control |= CPSW_SL_CTL_GIG;
	if (duplex)
		mac_control |= CPSW_SL_CTL_FULLDUPLEX;

I would also make mac_link_up() do a read-modify-write operation to
only affect the bits that it is changing.

Now, for SGMII, I would move setting CPSW_SL_CTL_EXT_EN to mac_config()
to enable in-band mode - don't we want in-band mode enabled all the
time while in SGMII mode so the PHY gets the response from the MAC?

Lastly, for RGMII at 10Mbps, you seem to suggest that you need RGMII
in-band mode enabled for that - but if you need RGMII in-band for
10Mbps, wouldn't it make sense for the other speeds as well? If so,
wouldn't that mean that CPSW_SL_CTL_EXT_EN can always be set for
RGMII no matter what speed is being used?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
