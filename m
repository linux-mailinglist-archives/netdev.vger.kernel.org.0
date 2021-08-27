Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A1F3F9217
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243951AbhH0Bmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:42:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243941AbhH0Bmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 21:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9q+sLZrqwk5VEpIY0OtTTb+IUluDq/w3h+qkLGYqn1E=; b=DeX7k1vphIz7pxVZ7wN1X5tcrV
        c/O1VycN86MuqigeEI5TZYW6WMS00Try4duGtpvbFAwbHIXyPlUfKX9jHXSfulHCNg7b8vF8Bo/SA
        wqbD9QatAlWoioMo9CdKbRH6OzBzWbAAGMn0Oge+AMFuo+SqaPSO/4O21DBA4bQgR1Yo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJQsa-0042V5-Os; Fri, 27 Aug 2021 03:42:00 +0200
Date:   Fri, 27 Aug 2021 03:42:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: marvell10g: fix broken PHY interrupts for
 anyone after us in the driver probe list
Message-ID: <YShC6Fm3JcK6j7lt@lunn.ch>
References: <20210827001513.1756306-1-vladimir.oltean@nxp.com>
 <20210827033229.1bfcc08b@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827033229.1bfcc08b@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I fear these checks won't work, since this is a C45 PHY.
> 
> You need to check phydev->c45_ids.device_ids[1], instead of
> phydev->phy_id.
 
I think you are correct.

static int mv211x_match_phy_device(struct phy_device *phydev, bool has_5g)
{
        int val;

        if ((phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] &
             MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88E2110)
                return 0;

This seems like a good pattern to follow.

     Andrew
