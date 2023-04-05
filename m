Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7585A6D797A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbjDEKSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbjDEKSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:18:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF7C4C27;
        Wed,  5 Apr 2023 03:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yJ16+cUT0D7ZVTErfZwxzpUUZnFQ1yqnqpQx3pT2yuE=; b=xNXdVbtPEQ7P54mUHFZ1T4HKNB
        ukQx0seAcml+qIAsJ2sLzXRsiPchyuM64rLCzMlXxHsQDJRIubi+34vv2ToTtIK3iZ/ATyjSda7nf
        Oi2DuJUcczk+WMWnVT2qwWkyJD3QAXEK2xlyRuNt22/NHyFnwsMVRkYyGSyMIgd9gNQ3W/xQFbSBS
        04x9A54r2+piVmdAQxWvxOwSDHWjBFCypmkT7M8k2rGFTEQ/rckQKkDwrzYNKZxeF8zX3o/ab0/Lg
        g2z8YmB1ZKNG43Y+0bFl7O0drdS8B3229jr1dcUD+kvN3Fd9mJ+V2VRBvVKwteoplvcd9FyB1jD+u
        UQlBk+rA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56198)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pk0Db-0005KI-EB; Wed, 05 Apr 2023 11:18:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pk0DW-0006DJ-CA; Wed, 05 Apr 2023 11:18:14 +0100
Date:   Wed, 5 Apr 2023 11:18:14 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
Subject: Re: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
Message-ID: <ZC1K5mLAkkO7bjA4@shell.armlinux.org.uk>
References: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 05:39:45PM +0800, Michael Sit Wei Hong wrote:
> Some DT devices already have phy device configured in the DT/ACPI.
> Current implementation scans for a phy unconditionally even though
> there is a phy listed in the DT/ACPI and already attached.
> 
> We should check the fwnode if there is any phy device listed in
> fwnode and decide whether to scan for a phy to attach to.y
> 
> Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index d41a5f92aee7..7ca9be7bec06 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1134,22 +1134,26 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
>  static int stmmac_init_phy(struct net_device *dev)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
> +	struct fwnode_handle *phy_fwnode;
>  	struct fwnode_handle *fwnode;
> -	bool phy_needed;
>  	int ret;
>  
> +	if (!phylink_expects_phy(priv->phylink))
> +		return 0;
> +
>  	fwnode = of_fwnode_handle(priv->plat->phylink_node);
>  	if (!fwnode)
>  		fwnode = dev_fwnode(priv->device);
>  
>  	if (fwnode)
> -		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
> +		phy_fwnode = fwnode_get_phy_node(fwnode);
> +	else
> +		phy_fwnode = NULL;
>  
> -	phy_needed = phylink_expects_phy(priv->phylink);
>  	/* Some DT bindings do not set-up the PHY handle. Let's try to
>  	 * manually parse it
>  	 */
> -	if (!fwnode || phy_needed || ret) {
> +	if (!phy_fwnode || IS_ERR(phy_fwnode)) {
>  		int addr = priv->plat->phy_addr;
>  		struct phy_device *phydev;
>  
> @@ -1165,6 +1169,9 @@ static int stmmac_init_phy(struct net_device *dev)
>  		}
>  
>  		ret = phylink_connect_phy(priv->phylink, phydev);
> +	} else {
> +		fwnode_handle_put(phy_fwnode);
> +		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
>  	}
>  
>  	if (!priv->plat->pmt) {

LGTM, thanks for taking on board my suggestion.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
