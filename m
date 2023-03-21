Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF626C3069
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCUL3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjCUL3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:29:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2BC30DD;
        Tue, 21 Mar 2023 04:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oap6q/AKU/Nc85sAkWOr7bFdsfJR4UbCwf+1zdilgRk=; b=cOHlEbBF3+ess4lXDJfK8ftydZ
        39HCBk3XatFET00yeA/AMIUDN+J3uZQz7afNKQW6y2RzZ66ZNDId/EqIDNvbewVbUotTn6U/DANPU
        H+8hH8qwwTlquFkTp2qHLbb5VNAf5i3jV4v+Hj7iLAnJCf/atvpFKlSJCW1RztmM3wrwNtPYD3mof
        82nevGjvgJIrm7W5UBpmxfIsNxsYHbTg/TQYFpak+D84wGReSoLG0gRO59Q+eADhTzh36AxXL+sUX
        bHeQxYgNn3DQ0W94LpIB/HznYy7KDkV5mDDZEe3PMzGW7QH5qvTN8NmcfasEmp3dGZOc/U20Az+mg
        VsItqCyA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55716)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peaBH-0000zs-K9; Tue, 21 Mar 2023 11:29:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peaBG-0007gs-A6; Tue, 21 Mar 2023 11:29:30 +0000
Date:   Tue, 21 Mar 2023 11:29:30 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next 2/4] net: ethernet: ti: am65-cpsw: Add support
 for SGMII mode
Message-ID: <ZBmVGu2vf1ADmEuN@shell.armlinux.org.uk>
References: <20230321111958.2800005-1-s-vadapalli@ti.com>
 <20230321111958.2800005-3-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321111958.2800005-3-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:49:56PM +0530, Siddharth Vadapalli wrote:
> Add support for configuring the CPSW Ethernet Switch in SGMII mode.
> 
> Depending on the SoC, allow selecting SGMII mode as a supported interface,
> based on the compatible used.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index cba8db14e160..d2ca1f2035f4 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -76,6 +76,7 @@
>  #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
>  
>  #define AM65_CPSW_SGMII_CONTROL_REG		0x010
> +#define AM65_CPSW_SGMII_MR_ADV_ABILITY_REG	0x018
>  #define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)

Isn't this misplaced? Shouldn't AM65_CPSW_SGMII_MR_ADV_ABILITY_REG come
after AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE, rather than splitting that
from its register offset definition?

If the advertisement register is at 0x18, and the lower 16 bits is the
advertisement, are the link partner advertisement found in the upper
16 bits?

>  #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
> @@ -1496,9 +1497,14 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>  	struct am65_cpsw_common *common = port->common;
>  
> -	if (common->pdata.extra_modes & BIT(state->interface))
> +	if (common->pdata.extra_modes & BIT(state->interface)) {
> +		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> +			writel(ADVERTISE_SGMII,
> +			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
> +

I think we can do better with this, by implementing proper PCS support.

It seems manufacturers tend to use bought-in IP for this, so have a
look at drivers/net/pcs/ to see whether any of those (or the one in
the Mediatek patch set on netdev that has recently been applied) will
idrive your hardware.

However, given the definition of AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
I suspect you won't find a compatible implementation.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
