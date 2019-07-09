Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F4662ECC
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfGIDWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:22:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34118 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfGIDWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/fS14yfBmX3BXPVHDosXDa7a3MrQZQJtDE5YE6An65I=; b=f0bP1JEW2QCTUZQXVLn8dxLGAo
        MWrOPtm99jFW//RybqaCJZLDQoFFu7S8ODULGccCuHe9MZ0p/vywScEVjuAHwdCQGBSUUnje+gzd3
        4C0E2rUwoIsst7Vbri7QWar4lGrHVE8fK7/H9e2x2iWumkDrVgK4oSa6vyIW+8PzdWew=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkgi8-00075k-Mi; Tue, 09 Jul 2019 05:22:32 +0200
Date:   Tue, 9 Jul 2019 05:22:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     kwangdo yi <kwangdo.yi@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] phy: added a PHY_BUSY state into phy_state_machine
Message-ID: <20190709032232.GF5835@lunn.ch>
References: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com>
 <539888f4-e5be-7ad5-53ce-63dd182708b1@gmail.com>
 <CAFHy5LAQyL2JW1Lox67OSz2WuRnzhVgSk6-0hfHf=gG2fXYmRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFHy5LAQyL2JW1Lox67OSz2WuRnzhVgSk6-0hfHf=gG2fXYmRQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 11:16:02PM -0400, kwangdo yi wrote:
> I simply fixed this issue by increasing the polling time from 20 msec to
> 60 msec in Xilinx EMAC driver. But the state machine would be in a
> better shape if it is capable of handling sub system driver's fake failure.
> PHY device driver could advertising the min/max timeouts for its subsystem,
> but still some vendor's EMAC driver fails to meet the deadline if this value
> is not set properly in PHY driver.

Hi Kwangdo

That is not how MDIO works. The PHY has two clock cycles to prepare
its response to any request. There is no min/max. This was always an
MDIO bus driver problem, not a PHY problem.

    Andrew
