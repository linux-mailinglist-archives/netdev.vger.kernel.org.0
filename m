Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B761031D0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKTC4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:56:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48986 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfKTC4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 21:56:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98276146CF6FF;
        Tue, 19 Nov 2019 18:56:15 -0800 (PST)
Date:   Tue, 19 Nov 2019 18:56:15 -0800 (PST)
Message-Id: <20191119.185615.1082982024930046589.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: fix link mode modification in PHY
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iX7IU-0000qH-T4@rmk-PC.armlinux.org.uk>
References: <E1iX7IU-0000qH-T4@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 18:56:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 19 Nov 2019 17:28:14 +0000

> Modifying the link settings via phylink_ethtool_ksettings_set() and
> phylink_ethtool_set_pauseparam() didn't always work as intended for
> PHY based setups, as calling phylink_mac_config() would result in the
> unresolved configuration being committed to the MAC, rather than the
> configuration with the speed and duplex setting.
> 
> This would work fine if the update caused the link to renegotiate,
> but if no settings have changed, phylib won't trigger a renegotiation
> cycle, and the MAC will be left incorrectly configured.
> 
> Avoid calling phylink_mac_config() unless we are using an inband mode
> in phylink_ethtool_ksettings_set(), and use phy_set_asym_pause() as
> introduced in 4.20 to set the PHY settings in
> phylink_ethtool_set_pauseparam().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
