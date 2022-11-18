Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6879762F36E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbiKRLQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbiKRLQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:16:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBD064555;
        Fri, 18 Nov 2022 03:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jCwiJcjbg7ZTiA+/f8xyS0h637tVnp9E3xI0ct+Ox54=; b=rdf+XtnYZnsMspk9kS+ZyEh0AS
        RGUkEV072p31F9GFMBGTOEe6ALTWGCIK0JuPu8PhAeIZYMrFcpz3qqdzROztEjXfNAYJRkb8eRWYT
        e22+XnXqBxBLbZoRze7we+h03xg21hlr+/NqlLOxV+Pa9c7DvOfTekCmZGtv7bWPCyrjT29aJmVg0
        QDnmZIG0yUbnvkZiHay1w8+4kEQWnpircZoR9Z6WUXU6VMSmBMRWGOAF9ySxbZo/6YdSYAAQxY1P1
        HCMUwICYV899eA97K58YX8q/NqeWF63YQcgk19VPhMWWxqjeGV+6tGOlZwwYTHahBOG/W+0sWxnvO
        OxOBw7Sg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35326)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ovzMG-0005cX-UB; Fri, 18 Nov 2022 11:16:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ovzMA-0007iy-Ra; Fri, 18 Nov 2022 11:16:26 +0000
Date:   Fri, 18 Nov 2022 11:16:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Ahmad Tarmizi Noor Azura <noor.azura.ahmad.tarmizi@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>
Subject: Re: [PATCH net] net: stmmac: Set MAC's flow control register to
 reflect current settings
Message-ID: <Y3dpikbzUJAazMTD@shell.armlinux.org.uk>
References: <20221118072051.31313-1-wei.sheng.goh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118072051.31313-1-wei.sheng.goh@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 03:20:51PM +0800, Goh, Wei Sheng wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 8273e6a175c8..ab7f48f32f5b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1061,8 +1061,16 @@ static void stmmac_mac_link_up(struct phylink_config *config,
>  		ctrl |= priv->hw->link.duplex;
>  
>  	/* Flow Control operation */
> -	if (tx_pause && rx_pause)
> -		stmmac_mac_flow_ctrl(priv, duplex);
> +	if (rx_pause && tx_pause)
> +		priv->flow_ctrl = FLOW_AUTO;
> +	else if (rx_pause && !tx_pause)
> +		priv->flow_ctrl = FLOW_RX;
> +	else if (!rx_pause && tx_pause)
> +		priv->flow_ctrl = FLOW_TX;
> +	else if (!rx_pause && !tx_pause)
> +		priv->flow_ctrl = FLOW_OFF;

Since "if (!rx_pause && !tx_pause)" will always be true at this point,
you can eliminate this needless last condition, which will make the code
a little more readable.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
