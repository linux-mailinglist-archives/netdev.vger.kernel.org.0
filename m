Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B1D6C4F16
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjCVPLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjCVPLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:11:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87E25AB7D;
        Wed, 22 Mar 2023 08:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Vfvi+ibcFfyRTZet079sDBBX25A/mF74/mjZ8afd+aM=; b=hA4kdUoClzu50rLwJutFUQR1Y2
        0uPRlhvYvh+KMN7O9SRcAdp/YYkAbdZc1Z9c9XFWnVxhqtwWoplYMJyrRoDnzUqB63+9SWqzTyqqQ
        C3+Vr1EBvJN48FDL/jzTWJ/BSAP8TCmGhwcFBchWVt6Ty4x4yt7lSv18e9aSBVo+T4XDPH5j71hBo
        9rV9ZjTWpumnWSrUdRNGUUADpT0Oz04bIeApA67PaYsRopQqmyGQ86j6qrpF/yWi0OIK59sZoRd/S
        VBz5lE/khwsKWx3IOnejCiYCLbXjJqgo3OUlOAoKJ+nNf0L5LxN5yVdw4hjs6Jq5qzIv5Ng4bCnIQ
        fI6esjgw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58984)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pf076-0003QQ-40; Wed, 22 Mar 2023 15:10:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pf074-0000SG-G5; Wed, 22 Mar 2023 15:10:54 +0000
Date:   Wed, 22 Mar 2023 15:10:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, rogerq@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [PATCH net-next 2/4] net: ethernet: ti: am65-cpsw: Add support
 for SGMII mode
Message-ID: <ZBsafikKXRonAcp+@shell.armlinux.org.uk>
References: <20230321111958.2800005-1-s-vadapalli@ti.com>
 <20230321111958.2800005-3-s-vadapalli@ti.com>
 <ZBmVGu2vf1ADmEuN@shell.armlinux.org.uk>
 <9b9ba199-8379-0840-b99a-d729f8ad33e1@ti.com>
 <ZBnPdlFS2P3Iie5k@shell.armlinux.org.uk>
 <3b9793e1b2d16c49eb4af40c2c48609a09e2bc5a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b9793e1b2d16c49eb4af40c2c48609a09e2bc5a.camel@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 03:49:41PM +0100, Paolo Abeni wrote:
> Hi Russell,
> 
> On Tue, 2023-03-21 at 15:38 +0000, Russell King (Oracle) wrote:
> > On Tue, Mar 21, 2023 at 07:04:50PM +0530, Siddharth Vadapalli wrote:
> > > Hello Russell,
> > > 
> > > On 21-03-2023 16:59, Russell King (Oracle) wrote:
> > > > On Tue, Mar 21, 2023 at 04:49:56PM +0530, Siddharth Vadapalli wrote:
> > > > > Add support for configuring the CPSW Ethernet Switch in SGMII mode.
> > > > > 
> > > > > Depending on the SoC, allow selecting SGMII mode as a supported interface,
> > > > > based on the compatible used.
> > > > > 
> > > > > Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> > > > > ---
> > > > >  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 11 ++++++++++-
> > > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > > > > index cba8db14e160..d2ca1f2035f4 100644
> > > > > --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > > > > +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > > > > @@ -76,6 +76,7 @@
> > > > >  #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
> > > > >  
> > > > >  #define AM65_CPSW_SGMII_CONTROL_REG		0x010
> > > > > +#define AM65_CPSW_SGMII_MR_ADV_ABILITY_REG	0x018
> > > > >  #define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
> > > > 
> > > > Isn't this misplaced? Shouldn't AM65_CPSW_SGMII_MR_ADV_ABILITY_REG come
> > > > after AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE, rather than splitting that
> > > > from its register offset definition?
> > > 
> > > Thank you for reviewing the patch. The registers are as follows:
> > > CONTROL_REG offset 0x10
> > > STATUS_REG offset  0x14
> > > MR_ADV_REG offset  0x18
> > > 
> > > Since the STATUS_REG is not used in the driver, its offset is omitted.
> > > The next register is the MR_ADV_REG, which I placed after the
> > > CONTROL_REG. I grouped the register offsets together, to represent the
> > > order in which the registers are placed. Due to this, the
> > > MR_ADV_ABILITY_REG offset is placed after the CONTROL_REG offset define.
> > > 
> > > Please let me know if I should move it after the CONTROL_MR_AN_ENABLE
> > > define instead.
> > 
> > Well, it's up to you - whether you wish to group the register offsets
> > separately from the bit definitions for those registers, or whether
> > you wish to describe the register offset and its associated bit
> > definitions in one group before moving on to the next register.
> > 
> > > > If the advertisement register is at 0x18, and the lower 16 bits is the
> > > > advertisement, are the link partner advertisement found in the upper
> > > > 16 bits?
> > > 
> > > The MR_LP_ADV_ABILITY_REG is at offset 0x020, which is the the register
> > > corresponding to the Link Partner advertised value. Also, the
> > > AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE Bit is in the CONTROL_REG. The CPSW
> > > Hardware specification describes the process of configuring the CPSW MAC
> > > for SGMII mode as follows:
> > > 1. Write 0x1 (ADVERTISE_SGMII) to the MR_ADV_ABILITY_REG register.
> > > 2. Enable auto-negotiation in the CONTROL_REG by setting the
> > > AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE bit.
> > 
> > Good to hear that there is a link partner register.
> > 
> > > > >  #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
> > > > > @@ -1496,9 +1497,14 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
> > > > >  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
> > > > >  	struct am65_cpsw_common *common = port->common;
> > > > >  
> > > > > -	if (common->pdata.extra_modes & BIT(state->interface))
> > > > > +	if (common->pdata.extra_modes & BIT(state->interface)) {
> > > > > +		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> > > > > +			writel(ADVERTISE_SGMII,
> > > > > +			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
> > > > > +
> > > > 
> > > > I think we can do better with this, by implementing proper PCS support.
> > > > 
> > > > It seems manufacturers tend to use bought-in IP for this, so have a
> > > > look at drivers/net/pcs/ to see whether any of those (or the one in
> > > > the Mediatek patch set on netdev that has recently been applied) will
> > > > idrive your hardware.
> > > > 
> > > > However, given the definition of AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
> > > > I suspect you won't find a compatible implementation.
> > > 
> > > I have tested with an SGMII Ethernet PHY in the standard SGMII MAC2PHY
> > > configuration. I am not sure if PCS support will be required or not. I
> > > hope that the information shared above by me regarding the CPSW
> > > Hardware's specification for configuring it in SGMII mode will help
> > > determine what the right approach might be. Please let me know whether
> > > the current implementation is acceptable or PCS support is necessary.
> > 
> > Nevertheless, this SGMII block is a PCS, and if you're going to want to
> > support inband mode (e.g. to read the SGMII word from the PHY), or if
> > someone ever wants to use 1000base-X, you're going to need to implement
> > this properly as a PCS.
> > 
> > That said, it can be converted later, so isn't a blocking sisue.
> 
> Just to be on the same page, I read all the above as you do accept/do
> not oppose to this series in the current form, am I correct?

I don't oppose this series.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
