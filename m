Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131AB30D6D6
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhBCJ5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbhBCJ52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:57:28 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103BAC061573;
        Wed,  3 Feb 2021 01:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LiJKg6LMkdW0YhKsRsXBXwuS2q8By1oCeCz1N8/lnaA=; b=R0/SuHHhLG5oYgPYldlEYNUWy
        W3qWm0WhZDI3lIDjoPBtmhnLG6cH+hmYy59XqzyJ4yeYQ1f/bOgb+b41I0ihBqxuWyN0sR4pqhGt8
        WmlreWXRyNq2kkcEO1qTG11SOUPS6Wd9FBHzI4LMHbTwwjds504rrKQNKrpK/2MT6TlTMgDAkQVew
        J9vIZr6qIkV2KhUcGQU9FsalD1UpI4ICvi+/Gz1MJ6jc1j7DeIX3ahiJF9oh4ZIQ94iCdxwajMjHp
        VJ9dWbs4fmxgPBHfhMVxnTqss+XUeD9kp8gs8JNnPIa20aoyoL/VZUY/RvVjfBg9ukuWbnc+aaYFJ
        yXphXqEgA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38584)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l7Eth-0005RK-8V; Wed, 03 Feb 2021 09:56:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l7Etg-0003wo-Eo; Wed, 03 Feb 2021 09:56:28 +0000
Date:   Wed, 3 Feb 2021 09:56:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v1 5/7] ARM i.MX6q: remove Atheros AR8035 SmartEEE fixup
Message-ID: <20210203095628.GP1463@shell.armlinux.org.uk>
References: <20210203091857.16936-1-o.rempel@pengutronix.de>
 <20210203091857.16936-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203091857.16936-6-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 10:18:55AM +0100, Oleksij Rempel wrote:
> This fixup removes the Lpi_en bit.
> 
> If this patch breaks functionality of your board, use following device
> tree properties:
> 
> 	ethernet-phy@X {
> 		reg = <0xX>;
> 		eee-broken-1000t;
> 		eee-broken-100tx;
> 		....
> 	};

That is the historical fix for this problem, but there is a better
solution now in net-next - configuring the Tw parameter for gigabit
connections. That solves the random link drop issue when EEE is
enabled.

Support for this configuration has only recently been merged into
net-next and other trees for this merge window, so I ask that you
hold off at least this patch until the next cycle.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
