Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4455B8C10
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiINPkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiINPkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:40:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8066AA3E;
        Wed, 14 Sep 2022 08:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gOLBlb9Twt2TVyi5QU0OEVORWi4d1OG8YQSlE6qjmQI=; b=CNSOrwQV8vwpuT7NrFT64kb16a
        84RpgkIOOH6vzLgiPVCttzaggrt7uDhdBHsZsSAIxqXyr8ONlD+ppRrBRZM9/t6owAuczFx017TbW
        JwlHTWJOU8dtSaTvBVQ8XI+43bvv+EP4qocVXdfkuKGmgY353v1GK68IOfy1mdJ93dxLeuGBIt5Ed
        6OO/MhlV8oVx7QeipfGSkMGVoRSuP2ApbHHcYD0Vg2N37+G9euMcfNPBDdNKcawcxYVkxPgIY8OmT
        UiRm1QmfVzwlXgEQZeVokbab1Ss8GPe7gCNgwNC4pUIcxU5reS1sjRjL+F8LHA1T2HW9qNnIVdblj
        D6o8Gy8Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34320)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYUSW-0004Y6-Ol; Wed, 14 Sep 2022 16:37:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYUSS-0001kz-Vo; Wed, 14 Sep 2022 16:37:48 +0100
Date:   Wed, 14 Sep 2022 16:37:48 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 2/8] net: ethernet: ti: am65-cpsw: Add support for SERDES
 configuration
Message-ID: <YyH1TH0UqCzN37J2@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-3-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-3-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 03:20:47PM +0530, Siddharth Vadapalli wrote:
> @@ -1427,6 +1471,9 @@ static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned
>  	struct net_device *ndev = port->ndev;
>  	int tmo;
>  
> +	/* disable phy */
> +	am65_cpsw_disable_phy(port->slave.ifphy);
> +

This seems really strange. If you have a serdes interface which
presumably supports SGMII, 1000base-X etc, then link status is sent
across the serdes interface. If you power down the serdes, then you
can't receive the link status, and so mac_link_up() won't be called.

Are you really sure you want to be enabling and disabling the PHY
in mac_link_down()/mac_link_up() ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
