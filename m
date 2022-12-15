Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8626B64DFC6
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiLORgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiLORgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:36:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEBB42F70;
        Thu, 15 Dec 2022 09:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CMaJeIYxKfKQa/W4oahDYNSzMyfQ+P5TlnnLtKDatEU=; b=MUnutXCeNvUNp+L8MEUyCmdYER
        S4KDjotzr8/cKA2yEq5vfttfJwYJXHj2oslKk/2PFrQhg+vMcStZigBNLfckV0cpdlazKrWr8+Kp5
        8mX96GH8saEg9hh4QPv1D7Bm3dPdG4+g47NsSNaY4rc+U/q4AsbU3UHaCg0gfzWEB5paoERld5Luo
        M4rNBH46CgrKP4Ga12Kly3OcPkc3W2NMfmxJ+s/tSRrOBBPC0uWaBJr+zKUposreEwxhVYsjwjJbr
        DGsY3uPF28iHRjVAjAj0Q1R4eGLtwg8gq+NSarBrGkfnG15qpUYaYCyJ8D2cMgwYpNNwq0TjK9lkz
        1LADGiIQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35728)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p5s98-0003W7-IM; Thu, 15 Dec 2022 17:35:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p5s95-000053-FC; Thu, 15 Dec 2022 17:35:47 +0000
Date:   Thu, 15 Dec 2022 17:35:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 09/11] leds: trigger: netdev: add additional hardware
 only triggers
Message-ID: <Y5ta87eCAQ8XsY8L@shell.armlinux.org.uk>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214235438.30271-10-ansuelsmth@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 12:54:36AM +0100, Christian Marangi wrote:
> Add additional hardware only triggers commonly supported by switch LEDs.
> 
> Additional modes:
> link_10: LED on with link up AND speed 10mbps
> link_100: LED on with link up AND speed 100mbps
> link_1000: LED on with link up AND speed 1000mbps
> half_duplex: LED on with link up AND half_duplex mode
> full_duplex: LED on with link up AND full duplex mode

Looking at Marvell 88e151x, I don't think this is usable there.
We have the option of supporting link_1000 on one of the LEDs,
link_100 on another, and link_10 on the other. It's rather rare
for all three leds to be wired though.

This is also a PHY where "activity" mode is supported (illuminated
or blinking if any traffic is transmitted or received) but may not
support individual directional traffic in hardware. However, it
does support forcing the LED on or off, so software mode can handle
those until the user selects a combination of modes that are
supported in the hardware.

> Additional blink interval modes:
> blink_2hz: LED blink on any even at 2Hz (250ms)
> blink_4hz: LED blink on any even at 4Hz (125ms)
> blink_8hz: LED blink on any even at 8Hz (62ms)

This seems too restrictive. For example, Marvell 88e151x supports
none of these, but does support 42, 84, 170, 340, 670ms.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
