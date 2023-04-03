Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994A46D430E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjDCLLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjDCLLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:11:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD136180;
        Mon,  3 Apr 2023 04:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rXQeD9DE8SW6NUiRvC2SZiQEB1BfSfE20N8Yw08zzNE=; b=mKGzrYJ8ClNs0Mxtbe8OL1/BnC
        86NuyV9KtcyKmNL9o1UMQ+oIcQSSxG5V+I/gJgBCtRE6KYCCJ7YzbZh2E0eq9zXLIdXdty41Hq68G
        SC6M4fxXMLaVbqe+ku9YA43eBFgLlKmuWB1lql4eBbf+VUvoEFW4EfyVD1iUv5Dpw4GRB9+fwIsv/
        E6GsyuKsGxpmSGtQ8MK3M8YrLvvXI5k5hkuThmDxDTtafGTo8eiKmQ6vSYVgixZvgzELwmr32nw1h
        IVhq1ByAVZ5KrEufVLf33U6WF+Ptwjtgj2XSX8xdGaYQf6KmfFufO8ZaXEuV11gFVlt4jVQR0+n5Z
        MdlIedKA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45700)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjI5C-0002fG-D9; Mon, 03 Apr 2023 12:10:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjI5B-0004B6-P4; Mon, 03 Apr 2023 12:10:41 +0100
Date:   Mon, 3 Apr 2023 12:10:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next v2 3/3] net: ethernet: ti: am65-cpsw: Enable
 USXGMII mode for J784S4 CPSW9G
Message-ID: <ZCq0McVarf5D3kB7@shell.armlinux.org.uk>
References: <20230403110106.983994-1-s-vadapalli@ti.com>
 <20230403110106.983994-4-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403110106.983994-4-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 04:31:06PM +0530, Siddharth Vadapalli wrote:
> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
> extra_modes member of the J784S4 SoC data.
> 
> Additionally, convert the IF statement in am65_cpsw_nuss_mac_config() to
> SWITCH statement to scale for new modes. Configure MAC control register
> for supporting USXGMII mode and add MAC_5000FD in the "mac_capabilities"
> member of struct "phylink_config".
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 6c118a9abb2f..f4d4f987563c 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -1507,10 +1507,20 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>  	u32 mac_control = 0;
>  
>  	if (common->pdata.extra_modes & BIT(state->interface)) {
> -		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> +		switch (state->interface) {
> +		case PHY_INTERFACE_MODE_SGMII:
>  			mac_control |= CPSW_SL_CTL_EXT_EN;
>  			writel(ADVERTISE_SGMII,
>  			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
> +			break;
> +
> +		case PHY_INTERFACE_MODE_USXGMII:
> +			mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;

Following on to my comments on patch 1, with the addition of these
control bits, you now will want am65_cpsw_nuss_mac_link_down() to
avoid clearing these bits as well.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
