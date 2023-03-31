Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D6B6D19BB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCaIZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCaIZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:25:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3511C1F9;
        Fri, 31 Mar 2023 01:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WSWDDda2TuuKrdshOYENayNcESV0rnA62FdNuHFuLds=; b=rSt0ft84kxxHG7oCIx7ZquEpCk
        sk24e6a/mww4k20spQGqKRdesiGO4AA4Nnvkv0EqtIZ8fDVCxc7+LYR3xzy4mZiM/zzoz6aL8ro+O
        chl6gSHryzZIUqd4FpTr74LIivICRlOyCTmociIfABZPb/D74uaEbW09bvAIBtSbo9EeB3ccvQLVT
        hZjZIkSYxaOb1hzk6bCaV5BFC1kBqVcFAdLSDCoeZ+BNnAuxJz4tjECdmGRaMiNdzHm+C0gZazvNx
        labBIErkCe3exzLnjzhlRAAs+idajKeQgtlxuUJJEFrvuQWvKvhi7hyb/xZpiIoWdC8fXYr3mjJF1
        9WcY7xUA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58736)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1piA3i-0004I0-4W; Fri, 31 Mar 2023 09:24:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1piA3h-0000zs-1E; Fri, 31 Mar 2023 09:24:29 +0100
Date:   Fri, 31 Mar 2023 09:24:29 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: Enable
 USXGMII mode for J784S4 CPSW9G
Message-ID: <ZCaYve8wYl15YRxh@shell.armlinux.org.uk>
References: <20230331065110.604516-1-s-vadapalli@ti.com>
 <20230331065110.604516-3-s-vadapalli@ti.com>
 <ZCaSXQFZ/e/JIDEj@shell.armlinux.org.uk>
 <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 01:35:10PM +0530, Siddharth Vadapalli wrote:
> Hello Russell,
> 
> Thank you for reviewing the patch.
> 
> On 31/03/23 13:27, Russell King (Oracle) wrote:
> > On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
> >> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
> >> extra_modes member of the J784S4 SoC data. Additionally, configure the
> >> MAC Control register for supporting USXGMII mode. Also, for USXGMII
> >> mode, include MAC_5000FD in the "mac_capabilities" member of struct
> >> "phylink_config".
> > 
> > I don't think TI "get" phylink at all...
> > 
> >> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> index 4b4d06199b45..ab33e6fe5b1a 100644
> >> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
> >>  		mac_control |= CPSW_SL_CTL_GIG;
> >>  	if (interface == PHY_INTERFACE_MODE_SGMII)
> >>  		mac_control |= CPSW_SL_CTL_EXT_EN;
> >> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
> >> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
> > 
> > The configuration of the interface mode should *not* happen in
> > mac_link_up(), but should happen in e.g. mac_config().
> 
> I will move all the interface mode associated configurations to mac_config() in
> the v2 series.

Looking at the whole of mac_link_up(), could you please describe what
effect these bits are having:

	CPSW_SL_CTL_GIG
	CPSW_SL_CTL_EXT_EN
	CPSW_SL_CTL_IFCTL_A

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
