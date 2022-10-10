Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21365FA704
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 23:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJJVeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 17:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJJVeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 17:34:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56097CB64
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 14:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mwO0bJmAaQk/DANgr9A8j0/ID1fHfW9f4WP9nuQZ9jY=; b=LesC8pHXVZMWlapjacuh5TAmXr
        jXlujNyTEbtosJfO/rkUwNRjRfEAhoSXGsGGWuKE+FbQ9DwNb59U93Oeo69hPQL9xhEfNuqKF7eSc
        pSZ7abH5vw+4u/4KeWvyDKVjXmbQHIvcZKEerrgXPIXXgLDLDMMMiKkACRLbO+PFkC6aLE442yrCl
        LllwE9xetwgob8VsuNt1IsgOyB9c5ComCdFKh5ymnxF3IBh+MBqHgguPXTzpa/fM4Y5jgm7ybn6G+
        2ktdZFES/iXYvS+JsBEqZmhXF95UHcrlcpq5oavjUosBmWy3z/1RsBXKVSYrrXm7MBVYcA0YrhjC3
        2SYi0Pzg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34678)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oi0PI-0005ED-6F; Mon, 10 Oct 2022 22:33:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oi0PC-0002BR-Rk; Mon, 10 Oct 2022 22:33:46 +0100
Date:   Mon, 10 Oct 2022 22:33:46 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Subject: Re: [PATCH 1/2] net: phylink: add mac_managed_pm in phylink_config
 structure
Message-ID: <Y0SPupsMC3roy4J6@shell.armlinux.org.uk>
References: <20221010203301.132622-1-shenwei.wang@nxp.com>
 <20221010203301.132622-2-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010203301.132622-2-shenwei.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 03:33:00PM -0500, Shenwei Wang wrote:
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index e9d62f9598f9..6d64d4b6d606 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -74,6 +74,7 @@ struct phylink {
>  
>  	bool mac_link_dropped;
>  	bool using_mac_select_pcs;
> +	bool mac_managed_pm;

I don't think you need this?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
