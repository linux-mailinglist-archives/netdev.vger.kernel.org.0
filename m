Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F0A3A66EB
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhFNMtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbhFNMts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:49:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB07AC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UjlDAk0BT/vYypA3Vq6M6dSZoWkc6vAwBgPwgko2yxI=; b=OwNEkXYRsukABJFgElUHF04ZW
        5h50B9R+65gCktPoPc8JZAq/JxCumWBjEHlGgwk+aximy18VqiBYnduOAvV35Ctus9juWuNwme5oP
        14eF+Jw6nah+ARCPO+vl6OgjSLzE4jwsR5IG8Cl28crEphDRJjmBz5S7wEAg+ylMdeLcEXqkwfVOH
        HYa1bkZazIZO50OFZakq5nTEsoU1DrCox6pQJOqk5LVwVo2I+xmn9Ajm2s3wHuQsvkVDZkG4F4uQ2
        i6oAKd16XNSkdkvOorsvG9inj3EU9Rpy+WXbq+fl8+OPg4LuGaJoqfP8//jTkPoqxz9gTKZL/3POM
        IJj4Zu0CQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45002)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lsm0C-0004Gd-TD; Mon, 14 Jun 2021 13:47:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lsm0C-000487-30; Mon, 14 Jun 2021 13:47:40 +0100
Date:   Mon, 14 Jun 2021 13:47:40 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 1/3] net: phy: nxp-c45-tja11xx: demote the
 "no PTP support" message to debug
Message-ID: <20210614124739.GS22278@shell.armlinux.org.uk>
References: <20210614123815.443467-1-olteanv@gmail.com>
 <20210614123815.443467-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614123815.443467-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 03:38:13PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1110 switch integrates these PHYs, and they do not have support
> for timestamping. This message becomes quite overwhelming:
> 
> [   10.056596] NXP C45 TJA1103 spi1.0-base-t1:01: the phy does not support PTP
> [   10.112625] NXP C45 TJA1103 spi1.0-base-t1:02: the phy does not support PTP
> [   10.167461] NXP C45 TJA1103 spi1.0-base-t1:03: the phy does not support PTP
> [   10.223510] NXP C45 TJA1103 spi1.0-base-t1:04: the phy does not support PTP
> [   10.278239] NXP C45 TJA1103 spi1.0-base-t1:05: the phy does not support PTP
> [   10.332663] NXP C45 TJA1103 spi1.0-base-t1:06: the phy does not support PTP
> [   15.390828] NXP C45 TJA1103 spi1.2-base-t1:01: the phy does not support PTP
> [   15.445224] NXP C45 TJA1103 spi1.2-base-t1:02: the phy does not support PTP
> [   15.499673] NXP C45 TJA1103 spi1.2-base-t1:03: the phy does not support PTP
> [   15.554074] NXP C45 TJA1103 spi1.2-base-t1:04: the phy does not support PTP
> [   15.608516] NXP C45 TJA1103 spi1.2-base-t1:05: the phy does not support PTP
> [   15.662996] NXP C45 TJA1103 spi1.2-base-t1:06: the phy does not support PTP
> 
> So reduce its log level to debug.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
