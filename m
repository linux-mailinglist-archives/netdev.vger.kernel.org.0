Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C9D639C0A
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 18:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiK0RfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 12:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiK0RfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 12:35:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1557EEE05;
        Sun, 27 Nov 2022 09:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eqT2kAhinln8E6GGqjl83+AKChAnCoAHHKPrPcifCO8=; b=lrT0GNBFW6HAx8NPAg7kTmCxdT
        ari6Z+jCx1jYLUwZVMRSWwHlFZIR2d3YT9NNb20/JFa2t+Pm5wdKkDs+wWb/JGscYM4uquMItKrrd
        1MXxN8v4ZjMQGbt1nWFQbtBBLTLmt/hQKuH+V5ePpj0b0+81LdAzu9vfKHtEU4T5TfOZtwoHAOwIT
        d8iVveh/YbO5hz7p6C9h+17gMY+0hAtIY1/nzO23pAmMVdwpFC0/onzWR19TuAYBuWcolcr1ufI1O
        ryOvlyEeSSACateLnFuAPuYET8wB3xzR5IMDOI2U7+iLx4qIp76BuDxiI4NTl/7eDzjRFP8ePK4Tf
        7O63cHAg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35446)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ozLYR-0007BT-NI; Sun, 27 Nov 2022 17:34:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ozLYL-0008Be-MG; Sun, 27 Nov 2022 17:34:53 +0000
Date:   Sun, 27 Nov 2022 17:34:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: pcs: altera-tse: simplify and clean-up
 the driver
Message-ID: <Y4Ofvemx5AnWJHrp@shell.armlinux.org.uk>
References: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 02:17:58PM +0100, Maxime Chevallier wrote:
> Hello everyone,
> 
> This small series does a bit of code cleanup in the altera TSE pcs
> driver, removong unused register definitions, handling 1000BaseX speed
> configuration correctly according to the datasheet, and making use of
> proper poll_timeout helpers.
> 
> No functional change is introduced.
> 
> Best regards,
> 
> Maxime
> 
> Maxime Chevallier (3):
>   net: pcs: altera-tse: use read_poll_timeout to wait for reset
>   net: pcs: altera-tse: don't set the speed for 1000BaseX
>   net: pcs: altera-tse: remove unnecessary register definitions

Hi Maxime,

Please can you check the link timer settings:

        /* Set link timer to 1.6ms, as per the MegaCore Function User Guide */
        tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, 0x0D40);
        tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, 0x03);

This is true for Cisco SGMII mode - which is specified to use a 1.6ms
link timer, but 1000baseX is specified by 802.3 to use a 10ms link
timer interval, so this is technically incorrect for 1000base-X. So,
if the MegaCore Function User Guide specifies 1.6ms for everything, it
would appear to contradict 802.3.

From what I gather from the above, the link timer uses a value of
200000 for 1.6ms, which means it is using a 8ns clock period or 125MHz.

If you wish to correct the link timer, you can use this:

	int link_timer;

	link_timer = phylink_get_link_timer_ns(interface) / 8;
	if (link_timer > 0) {
		tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, link_timer);
		tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, link_timer >> 16);
	}

so that it gets set correctly depending on 'interface'.
phylink_get_link_timer_ns() is an inline static function, so you
should end up with the above fairly optimised, not that it really
matters. Also worth documenting that the "8" there is 125MHz in
nanoseconds - maybe in a similar way to pcs-lynx does.

It does look like this Altera TSE PCS is very similar to pcs-lynx,
maybe there's a possibility of refactoring both drivers to share
code?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
