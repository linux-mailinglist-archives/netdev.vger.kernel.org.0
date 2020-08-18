Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9802B248334
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgHRKia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgHRKi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:38:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743AEC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=d3/YpbfHe47Dw7rokLAwJ4efmpKWs0Cup8iHReB40Jk=; b=kUdsrOEVKOrLvQ6LI8AKm3FwV
        KggAyBSZL6nNJFdz3GxDdYjpA+6HfcUvnPBst58vvKVbTnzEUYl1/ZuYLK146dRrf713ShBiq/X95
        FWQVK8Z0BJhWEFsFvMqPMtsUi8gWtUq5auLBN6dfSdZ3B7kCYdzdDOQ7X4JmfX9Mzxa2ATY/1ZG2b
        jgT/nv8i2FNrQ0OsFy8/RgJTmwo8yvLDNivR/qJz7OvJaCjWzWnryvm4CE9QKri5iAstdWjZ1SuU9
        1Jwdgu5W4d7EdIQTQEfVdk8jbWxfD1QTeIB9RlPC0Wc4ZSKawJFNeKdMl6mACBnvp7HtoiDroDN3Z
        wyxVYPWvA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54018)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k7z0G-0000Ii-8D; Tue, 18 Aug 2020 11:38:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k7z0A-0001KX-G1; Tue, 18 Aug 2020 11:37:58 +0100
Date:   Tue, 18 Aug 2020 11:37:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v4 1/9] ptp: Add generic ptp v2 header parsing function
Message-ID: <20200818103758.GZ1551@shell.armlinux.org.uk>
References: <20200818103251.20421-1-kurt@linutronix.de>
 <20200818103251.20421-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818103251.20421-2-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 12:32:43PM +0200, Kurt Kanzenbach wrote:
> Reason: A lot of the ptp drivers - which implement hardware time stamping - need
> specific fields such as the sequence id from the ptp v2 header. Currently all
> drivers implement that themselves.
> 
> Introduce a generic function to retrieve a pointer to the start of the ptp v2
> header.
> 
> Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Reviewed-by: Richard Cochran <richardcochran@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Just one small nit, see below.  Otherwise,

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> +/**
> + * ptp_parse_header - Get pointer to the PTP v2 header
> + * @skb: packet buffer
> + * @type: type of the packet (see ptp_classify_raw())
> + *
> + * This function takes care of the VLAN, UDP, IPv4 and IPv6 headers. The length
> + * is checked.
> + *
> + * Note, internally skb_mac_header() is used. Make sure, that the @skb is
> + * initialized accordingly.

No need for the "," there - these aren't separate clauses.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
