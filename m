Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13B96D6A59
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbjDDRWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbjDDRWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:22:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABDA1BEA;
        Tue,  4 Apr 2023 10:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5X775OsZchfjU9qrIg8JXv+X+xJPkkCLECP3XjqF/K4=; b=y+RYifJv18Z6dqfMnt2H3SLxne
        Smlv0kvIMQ5yZdqKwL5HSuKLHaUwxu1mVhgJnB2dyOvs0AG9W1dFZUWrhSPwluZwRHbpJm42Q+SGe
        ch3LS4iN7XRXZlH0DkQSlOjIcrFlNNgKTBoxYZtwrYKrls+pXMRrda5BzsFLCysMe4EQEBphVdCdB
        II+oS+WjTxF+NhsUd0V5T9av7POIBE2P3cQ21qh3JgChhNZVNljPe+OvwXY2Th3kEt3pUxP7YtnbP
        jO2N+oGGgbLJH7iKJydOsjn3IQWbFBzXyLzKqZ0ALSjazyCOPPO0ky5ae2UvM0lSM3zmBkdOd45tB
        CkOpf3Yg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50358)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjkLm-0004WQ-Qf; Tue, 04 Apr 2023 18:21:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjkLh-0005SD-7b; Tue, 04 Apr 2023 18:21:37 +0100
Date:   Tue, 4 Apr 2023 18:21:37 +0100
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
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
Subject: Re: [RFC net 1/1] net: stmmac: skip PHY scanning when PHY already
 attached in DT mode
Message-ID: <ZCxcoSRSVInwC0k1@shell.armlinux.org.uk>
References: <20230404091442.3540092-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404091442.3540092-1-michael.wei.hong.sit@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:14:42PM +0800, Michael Sit Wei Hong wrote:
> If PHY is successfully attached during phylink_fwnode_phy_connect()
> in DT mode. MAC should not need to scan for PHY again.
> 
> Adding a logic to check if ovr_an_inband is set before scanning for
> a PHY, since phylink_fwnode_phy_connect() returns 0 when
> 
> 	phy_fwnode = fwnode_get_phy_node(fwnode);
> 	if (IS_ERR(phy_fwnode)) {
> 		if (pl->cfg_link_an_mode == MLO_AN_PHY)
> 			return -ENODEV;
> 		return 0;
> 	}
> 
> Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index d41a5f92aee7..4b8d3d975678 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1149,7 +1149,7 @@ static int stmmac_init_phy(struct net_device *dev)
>  	/* Some DT bindings do not set-up the PHY handle. Let's try to
>  	 * manually parse it
>  	 */
> -	if (!fwnode || phy_needed || ret) {
> +	if (!fwnode || (phy_needed && priv->phylink_config.ovr_an_inband) || ret) {
>  		int addr = priv->plat->phy_addr;
>  		struct phy_device *phydev;
>  

Sorry, but this just doesn't look right to me. And Gnrrrrr, I wish I'd
spotted this stupidity during the review of phylink_expects_phy().

phy_needed will be true if phylink thinks there should be a PHY on the
link, that being:

	MLO_AN_PHY mode
	MLO_AN_INBAND mode and non-802.3z interface mode

If !phy_needed, then the code should not be attempting to attach a PHY,
but calling phylink_fwnode_phy_connect() is fine as it will just return
zero.

If phy_needed is true, then phylink_fwnode_phy_connect() will check to
see whether a PHY is in the fwnode. If we fail to find a PHY, then if
we're in MLO_AN_PHY mode, that's an error, and we return -ENODEV. If
there is no PHY device associated with the handle, we also return
-ENODEV.

If phy_needed is true, and phylink_fwnode_phy_connect() doesn't find
a PHY in the fwnode, and we're in MLO_AN_INBAND mode (e.g. for SGMII)
then we'll return zero, because we can cope without a PHY in this
instance - it's a success. If we do find a PHY, then we will make use
of it, and also return zero.

The problem is this hacky code wants to know the difference between
those two situations, but phylink doesn't allow you to, and I don't
think now that phylink_expects_phy() solves that problem.

I think you're better off doing this:

	struct fwnode_handle *phy_fwnode;

	if (!phylink_expects_phy(priv->phylink))
		return 0;

	fwnode = of_fwnode_handle(priv->plat->phylink_node);
	if (!fwnode)
		fwnode = dev_fwnode(priv->device);

	if (fwnode)
		phy_fwnode = fwnode_get_phy_node(fwnode);
	else
		phy_fwnode = NULL;

	if (!phy_fwnode) {
		... do non-DT PHY stuff ...
		ret = phylink_connect_phy(priv->phylink, phydev);
	} else {
		fwnode_handle_put(phy_fwnode);

		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
	}

	... ethtool wol stuff ...

Doesn't that more closely reflect what you actually want this code
to be doing, rather than messing about trying to guess it from
phylink's return code etc?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
