Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898F442198E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 00:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhJDWDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 18:03:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48470 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233487AbhJDWDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 18:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fYPXulzv7ga+wDX0AJs+dfD7EVy3GhoMVPr0FyDWXag=; b=Y6R/ODLBIr3hAQNIvwmZ35HU7e
        OROrBLiHkVpnQfAwubq5F5KC8nOJCAzlTOc2JgxhWqJOwy8jDxFPyF8jOs604QoVXtmkfpiAAIcuy
        U/FD2eZaehURkNja7xEVKRcpn2PNW/jbWj7hH9oSsHEbplTbxG4e0oykvgjEIuOauR60=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXW1O-009bkw-46; Tue, 05 Oct 2021 00:01:18 +0200
Date:   Tue, 5 Oct 2021 00:01:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC net-next PATCH 16/16] net: sfp: Add quirk to ignore PHYs
Message-ID: <YVt5rpEl3HkIkAfB@lunn.ch>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-17-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-17-sean.anderson@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:27PM -0400, Sean Anderson wrote:
> Some modules have something at SFP_PHY_ADDR which isn't a PHY. If we try to
> probe it, we might attach genphy anyway if addresses 2 and 3 return
> something other than all 1s. To avoid this, add a quirk for these modules
> so that we do not probe their PHY.
> 
> The particular module in this case is a Finisar SFP-GB-GE-T. This module is
> also worked around in xgbe_phy_finisar_phy_quirks() by setting the support
> manually. However, I do not believe that it has a PHY in the first place:
> 
> $ i2cdump -y -r 0-31 $BUS 0x56 w
>      0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
> 00: ff01 ff01 ff01 c20c 010c 01c0 0f00 0120
> 08: fc48 000e ff78 0000 0000 0000 0000 00f0
> 10: 7800 00bc 0000 401c 680c 0300 0000 0000
> 18: ff41 0000 0a00 8890 0000 0000 0000 0000
> 
> The first several addresses contain the same value, which should almost
> never be the case for a proper phy. In addition, the "OUI" 00-7F-C3 does
> not match Finisar's OUI of 00-90-65 (or any other OUI for that matter).
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Hi Sean

This does not really have anything to do with PCS. I would send it on
its own.

    Andrew
