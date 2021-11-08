Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD2449923
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhKHQMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:12:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236099AbhKHQMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 11:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zfzU/jlcDyT5ulhdagf/cP4RIpRacn4ukb4dJ5PZH+A=; b=u/YAolBLIicOz5G8Wj6oZyfZLc
        QPhCZs+3Luq/q9rEZevR1m0QkeuCL7pTAVYs5lZknSxrvdlDzyUHyGNCTbc2abGqPNBoJ0LwvLLdd
        b8NC0fW2Z5lJ8ZwPVOnjkn4HlfbiFWiyN5ZuXY2irQHXPorpe6N6p/m7WaQCHw4c7MKU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk7DC-00CuXk-Ab; Mon, 08 Nov 2021 17:09:34 +0100
Date:   Mon, 8 Nov 2021 17:09:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        bage@linutronix.de, Heiner Kallweit <hkallweit1@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't
 discard phy_start_aneg's return
Message-ID: <YYlLvhE6/wjv8g3z@lunn.ch>
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
 <YYkzbE39ERAxzg4k@shell.armlinux.org.uk>
 <20211108160653.3d6127df@mitra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108160653.3d6127df@mitra>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 04:06:53PM +0100, Benedikt Spranger wrote:
> On Mon, 8 Nov 2021 14:25:48 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Mon, Nov 08, 2021 at 03:18:34PM +0100, bage@linutronix.de wrote:
> > > From: Bastian Germann <bage@linutronix.de>
> > > 
> > > Take the return of phy_start_aneg into account so that ethtool will
> > > handle negotiation errors and not silently accept invalid input.
> > 
> > I don't think this description is accurate. If we get to call
> > phy_start_aneg() with invalid input, then something has already
> > gone wrong.
> The MDI/MDIX/auto-MDIX settings are not checked before calling
> phy_start_aneg(). If the PHY supports forcing MDI and auto-MDIX, but
> not forcing MDIX _phy_start_aneg() returns a failure, which is silently
> ignored.

Does the broadcom driver currently do this, or is this the new
functionality you are adding?

It actually seems odd that auto and MDI is supported, but not MDIX?  I
would suggest checking with Florian about that. Which particular
broadcom PHY is it?

   Andrew
