Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A72F1934B8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgCYXmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:42:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:38222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbgCYXmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 19:42:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A3B39AD72;
        Wed, 25 Mar 2020 23:42:31 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 99506E0FD3; Thu, 26 Mar 2020 00:42:30 +0100 (CET)
Date:   Thu, 26 Mar 2020 00:42:30 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Marek Vasut <marex@denx.de>,
        o.rempel@pengutronix.de, Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: RFC: future of ethtool tunables (Re: [RFC][PATCH 1/2] ethtool:
 Add BroadRReach Master/Slave PHY tunable)
Message-ID: <20200325234230.GD31519@unicorn.suse.cz>
References: <20200325101736.2100-1-marex@denx.de>
 <20200325164958.GZ31519@unicorn.suse.cz>
 <20200325215538.GB27427@lunn.ch>
 <2b3973d0-0c41-c986-5f72-e03a5fddce55@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b3973d0-0c41-c986-5f72-e03a5fddce55@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 03:04:07PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/25/2020 2:55 PM, Andrew Lunn wrote:
> >> What might be useful, on the other hand, would be device specific
> >> tunables: an interface allowing device drivers to define a list of
> >> tunables and their types for each device. It would be a generalization
> >> of private flags. There is, of course, the risk that we could end up
> >> with multiple NIC vendors defining the same parameters, each under
> >> a different name and with slightly different semantics.
> >  
> > Hi Michal
> > 
> > I'm not too happy to let PHY drivers do whatever they want. So far,
> > all PHY tunables have been generic. Any T1 PHY can implement control
> > of master/slave, and there is no reason for each PHY to do it
> > different to any other PHY. Downshift is a generic concept, multiple
> > PHYs have implemented it, and they all implement it the same. Only
> > Marvell currently supports fast link down, but the API is generic
> > enough that other PHYs could implement it, if the hardware supports
> > it.
> > 
> > I don't however mind if it gets a different name, or a different tool,
> > etc.
> 
> BroadRReach is a standard feature that is available on other PHYs for
> instance (Broadcom at least has it too) so defining a common name for
> this particular tunable knob here would make sense.
> 
> If we are to create vendor/device specific tunables, can we agree on a
> namespace to use, something like:
> 
> <vendor>:<device>:<parameter name>

That's not exactly what wanted to know. From my point of view, the most
important question is if we want to preserve the concept of tunables as
assorted parameters of various types, add netlink requests for querying
and setting them (plus notifications) and keep adding new tunables. Or
if we rather see them as a temporary workaround for the lack of
extensibility and handle all future parameters through regular command
line arguments and netlink attributes.

For the record, I can imagine that the answer might be different for
(netdev) tunables and for PHY tunables.

Michal
