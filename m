Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D555F83FE
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 09:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJHH17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 03:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJHH15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 03:27:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36B38050B
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 00:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5LuQRAEYNuy2Djje4dgYioJM3Hrq3L41SvaEqPX8DcU=; b=mhftvTLVD38Y4Hl4RJZN3XupCJ
        qXWYfU4Ilg1OWtHdbMKEhH/lAXXpr2Rcv+HZb1hH8x/xbyQ5wAYhKPGrpKwnsbBF5mCtNZ8V3M05m
        j8uoFUUq1MkcsoC+TSPUz4AWkBVTVAQA9BXxlWCGACcfE7k+YjaGjCUsz2T0yki8YtHA9a83/UGWb
        6LYFdd9Y59LhiQztaJ0n8jUdexq3SIziG40CYemM78GLC91qDC9EfBxFppaS2NZVGLQ2t/NH5sGtz
        zNWLIklxi9KvqpnDb4CaQzWdkqVWXDmX2dnqe1xjuxX7baz5yKYlWm8JrGK5yJs7UJEGe+kQ+XwFP
        Ecv63J1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34632)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oh4FM-000367-BD; Sat, 08 Oct 2022 08:27:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oh4FI-0008DZ-UQ; Sat, 08 Oct 2022 08:27:40 +0100
Date:   Sat, 8 Oct 2022 08:27:40 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        imx@lists.linux.dev
Subject: Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm() helper
Message-ID: <Y0EmbNyFhT/HsBMh@shell.armlinux.org.uk>
References: <20221007154246.838404-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007154246.838404-1-shenwei.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 10:42:46AM -0500, Shenwei Wang wrote:
> +/**
> + * phylink_set_mac_pm() - set phydev->mac_managed_pm to true
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * Set the phydev->mac_managed_pm, which is under the phylink instance
> + * specified by @pl, to true. This is to indicate that the MAC driver is
> + * responsible for PHY PM.
> + *
> + * The function can be called in the end of net_device_ops ndo_open() method
> + * or any place after phy is connected.

May I suggest a different wording:

"If the driver wishes to use this feature, this function should be
called each time after the driver connects a PHY with phylink."

This makes it clear that after one of:

phylink_connect_phy()
phylink_of_phy_connect()
phylink_fwnode_phy_connect()

has been called, and the driver wants to call this function, the driver
needs to call this every time just after the driver connects a PHY.

The alternative is that we store this information away when this
function is called, and always update the phydev when one is
connected.

There is also the question whether this should also be applied to PHYs
on SFP modules or not. Should a network driver using mac managed PM, but
also supports SFPs, and a copper SFP is plugged in with an accessible
PHY, what should happen if the system goes into a low power state?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
