Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE7C63383B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiKVJVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKVJVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:21:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328F524BE2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=j6qLxK+WvmrfR68jSDCmV/4gpWa9vK+WTYyBrRfVE6M=; b=DWHFtLi8bg7QeG8NbQCf5PbTye
        H2yZWr06yRI5Sb2AfE7pfxttmEGqdAWjgsP2XDb2kz0rt20UZXCnnHqJiwamN/8rUPhMday2amJp8
        wemgCFPhPnQiUBm8lCAItEUOuMa3R215EPnN/p7BodWlj8QnZZFCUu60ojlT4FQgplS1TLWTSBkSq
        nSE8Z5Ho87/JeABgJgOGCtEOeXv9W/u7DPM/1NUz8lSyHT1Wk7rrlnl8sBCYsgapw1YmKbJThtUPQ
        aKrpJGkMliOfMNZXj0upNnE6MYymHXNoVAxDF8TXr2nYj5qZxnQbs0G6nX8LEJxTFSGZvUwU9BM+q
        wWND2p8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35374)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxPTF-0001F7-5k; Tue, 22 Nov 2022 09:21:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxPTE-0003D5-2o; Tue, 22 Nov 2022 09:21:36 +0000
Date:   Tue, 22 Nov 2022 09:21:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 2/8] net: phylink: introduce generic method
 to query PHY in-band autoneg capability
Message-ID: <Y3yUoNwyJRQViyOY@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118000124.2754581-3-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 02:01:18AM +0200, Vladimir Oltean wrote:
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 9a3752c0c444..56a431d88dd9 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -761,6 +761,12 @@ struct phy_tdr_config {
>  };
>  #define PHY_PAIR_ALL -1
>  
> +enum phy_an_inband {
> +	PHY_AN_INBAND_UNKNOWN		= BIT(0),
> +	PHY_AN_INBAND_OFF		= BIT(1),
> +	PHY_AN_INBAND_ON		= BIT(2),
> +};

There is another option here:

- unknown (basically, PHY driver doesn't implement the function or
  can't report)
- off (PHY driver knows for certain that in-band isn't used)
- on (PHY driver knows that in-band is required and must be
  acknowledged)
- on-but-not-required (PHY driver knows that in-band can be used, but
  the PHY has hardware support for timing out waiting for the in-band
  acknowledgement - Marvell PHYs support this.)

Maybe the fourth state can be indicated by setting both _OFF and _ON ?

Given that there's four states, does it make sense for this to be a
bitfield?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
