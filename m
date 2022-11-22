Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B46D6343C1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbiKVSkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbiKVSks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:40:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB5D7FF39;
        Tue, 22 Nov 2022 10:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8fcpg5DnZdCFHGZ1fkTjCjZIX2J0omCQ8g6dw5X6py0=; b=vCIkijpRcSDaxYKRDYdsqz+JNT
        j7BPwPUT+gd6SRstLMRSTsz9rYh7nTS1fL/l/YnVrKKFV3c48PIKX8dRQyeC8VNpBUEp/liaYrd/f
        4LAhQnrKYJPrON/m1KerF3J8TxKJI2T+Ya4560/keXH/FqPXlZazgN7wQVMTpQiy4A6/8d+dItyXC
        On7dI76prGr8n0QMAUIHZJlYtSL+YyuozULnz8dGr/IdgXF7DKj7UT1EgcvF0HtYMSUsIlUe7caN9
        yvjIjuaFBOPkt/h73KzK6KEUXVy17NVP3P1+U3e0cRWLcahQwPEk65IXfUK0LFT4O+glsYycYUscF
        tVlySE6w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35390)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxYCC-0001u5-Bq; Tue, 22 Nov 2022 18:40:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxYC9-0003Wr-CJ; Tue, 22 Nov 2022 18:40:33 +0000
Date:   Tue, 22 Nov 2022 18:40:33 +0000
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
Subject: Re: [PATCH net v2] net: stmmac: Set MAC's flow control register to
 reflect current settings
Message-ID: <Y30XoUHXscGSMHaL@shell.armlinux.org.uk>
References: <20221122063935.6741-1-wei.sheng.goh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122063935.6741-1-wei.sheng.goh@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:39:35PM +0800, Goh, Wei Sheng wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> index c25bfecb4a2d..369db308b1dd 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> @@ -748,6 +748,9 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
>  	if (fc & FLOW_RX) {
>  		pr_debug("\tReceive Flow-Control ON\n");
>  		flow |= GMAC_RX_FLOW_CTRL_RFE;
> +	} else {
> +		pr_debug("\tReceive Flow-Control OFF\n");
> +		flow &= ~GMAC_RX_FLOW_CTRL_RFE;
>  	}
>  	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);

This doesn't look correct to me. The function starts off:

        unsigned int flow = 0;

flow is not written to before the context above. So, the code you've
added effectively does:

	flow = 0 & ~GMAC_RX_FLOW_CTRL_RFE;

which is still zero. So, I don't think this hunk is meaningful apart
from adding the pr_debug().

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
> +	else
> +		priv->flow_ctrl = FLOW_OFF;
> +
> +	stmmac_mac_flow_ctrl(priv, duplex);
>  
>  	if (ctrl != old_ctrl)
>  		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);

This looks like the true fix for correctly setting the flow control
depending on the phylink link_up() (which will contain the resuts of
pause negotiation, rate adaption or overriden by ethtool - but only
when operating in full duplex mode.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
