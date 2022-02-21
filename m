Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFE84BE04B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378176AbiBUOpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:45:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378177AbiBUOpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:45:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F39205D0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C6SyZCOpFzeW1yxtqcEQH3lGm7Wh9TV97Luh+ZTCD60=; b=Iy7HQ5kXdFBzYweplkZF7g4d/C
        rAsf24Mo42ygwRJ0RJ69ThTT/oRxBIdWPVF3/1k54gBIS7Acu0nbKSaxQ5ZlADTh4ZLiNSv5GjPfO
        fUdOsVPt3psLMlUPa1+pXOuSUVhzIKE4Fy6rYh2Z7s9Mm2ZOLUaspJhd7qKj35ERgkDTIqqwA1NBe
        +6oEVciHiRpTcVXfoSogIUFsQgm+WqDPd2cIMjUIeffarjjJJ/MPBJ/m42zEEYDZm5RtQCaIbeF7Z
        F5j72Yxpx/9gLRjJb21pOa0PxhshpQ/trPdCOwyCu9ylb19z00dYksoTo3GUerElk2Msb6xSmhQMy
        ErNPT1Zw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57394)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nM9vX-0000Wl-Vd; Mon, 21 Feb 2022 14:44:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nM9vW-0007O6-Mv; Mon, 21 Feb 2022 14:44:34 +0000
Date:   Mon, 21 Feb 2022 14:44:34 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <YhOlUtcr7CQunM6M@shell.armlinux.org.uk>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
 <20220219211241.beyajbwmuz7fg2bt@skbuf>
 <20220219212223.efd2mfxmdokvaosq@skbuf>
 <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
 <20220221143254.3g3iqysqkqrfu5rm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221143254.3g3iqysqkqrfu5rm@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 04:32:54PM +0200, Vladimir Oltean wrote:
> Alternatively, phylink_create() gets the initial PHY interface mode
> passed to it, I wonder, couldn't we call mac_select_pcs() with that in
> order to determine whether the function is a stub or not?

That would be rather prone to odd behaviour depending on how
phylink_create() is called, depending on the initial interface mode.
If the initial interface mode causes mac_select_pcs() to return NULL
but it actually needed to return a PCS for a different interface mode,
then we fail.

> *and as I haven't considered, to be honest. When phylink_major_config()
> gets called after a SGMII to 10GBaseR switchover, and mac_select_pcs is
> called and returns NULL, the current behavior is to keep working with
> the PCS for SGMII. Is that intended?

It was not originally intended, but as a result of the discussion
around this patch which didn't go anywhere useful, I dropped it as
a means to a path of least resistance.

https://patchwork.kernel.org/project/linux-arm-kernel/patch/E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk/

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
