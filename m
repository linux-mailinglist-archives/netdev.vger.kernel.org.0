Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D627316650
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhBJMNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:13:54 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37733 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbhBJMLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:11:36 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 37BA122FB3;
        Wed, 10 Feb 2021 13:10:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612959043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WelEA5lC69vxnuHv17nGcuOxdVz9yENi8PVd8iZYJTc=;
        b=PyTRbDNEDqrWQ5aWgvybv8ofBNU9cJKAjnoKnjyHgr7YltLhIljNpQeshgEeb6r8ThHJmD
        7Zg4LkHVXGekcWCC5+9oYlhKz07fDHjsPMYutkYfqfUBPG0/8x4Fv3oUCNHnGEgaj35FZ5
        YjyEW9L9XuF2sA4aaM2NTVVwAX6s4Zo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Feb 2021 13:10:43 +0100
From:   Michael Walle <michael@walle.cc>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: introduce phydev->port
In-Reply-To: <20210210115415.GV1463@shell.armlinux.org.uk>
References: <20210209163852.17037-1-michael@walle.cc>
 <41e4f35c87607e69cb87c4ef421d4a77@walle.cc>
 <20210210115415.GV1463@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <f2791b563e18107d8b015e35832a45d5@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-10 12:54, schrieb Russell King - ARM Linux admin:
> On Wed, Feb 10, 2021 at 12:20:02PM +0100, Michael Walle wrote:
>> 
>> Am 2021-02-09 17:38, schrieb Michael Walle:
>> > --- a/drivers/net/phy/phy.c
>> > +++ b/drivers/net/phy/phy.c
>> > @@ -308,7 +308,7 @@ void phy_ethtool_ksettings_get(struct phy_device
>> > *phydev,
>> >  	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
>> >  		cmd->base.port = PORT_BNC;
>> >  	else
>> > -		cmd->base.port = PORT_MII;
>> > +		cmd->base.port = phydev->port;
>> >  	cmd->base.transceiver = phy_is_internal(phydev) ?
>> >  				XCVR_INTERNAL : XCVR_EXTERNAL;
>> >  	cmd->base.phy_address = phydev->mdio.addr;
>> 
>> Russell, the phylink has a similiar place where PORT_MII is set. I 
>> don't
>> know if we'd have to change that, too.
> 
> What would we change it to?

It was just a question whether we have to change it and I take from your
answer we do not. I was just curious because there is the same edge case
for the PORT_BNC like in the phy core.

> If there's no PHY attached and no SFP, what kind of interface do we
> have? As we've no idea what's on the media side, assuming that we are
> presenting a MII-like interface to stuff outside of what we control is
> entirely reasonable.
> 
> Claiming the world is TP would be entirely wrong, there may not be a
> RJ45 jack. Consider the case where the MAC is connected to a switch.
> It's a MII-like link. It's certianly not TP, BNC, fiber, AUI, or
> direct attach.

Yes, I get your point.

-michael
