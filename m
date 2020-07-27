Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA1922FB56
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgG0VZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:25:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgG0VZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:25:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0Ad4-0079yF-OO; Mon, 27 Jul 2020 23:25:50 +0200
Date:   Mon, 27 Jul 2020 23:25:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jamie Gloudon <jamie.gloudon@gmx.fr>,
        Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: Broken link partner advertised reporting in ethtool
Message-ID: <20200727212550.GC1705504@lunn.ch>
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
 <20200727200912.GA1884@gmx.fr>
 <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
 <20200727210141.GA1705504@lunn.ch>
 <20200727210843.kgcwrd6bpg65lyvj@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727210843.kgcwrd6bpg65lyvj@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:08:43PM +0200, Michal Kubecek wrote:
> On Mon, Jul 27, 2020 at 11:01:41PM +0200, Andrew Lunn wrote:
> > >   - the exact command you ran (including arguments)
> > >   - expected output (or at least the relevant part)
> > >   - actual output (or at least the relevant part)
> > >   - output with dump of netlink messages, you can get it by enabling
> > >     debugging flags, e.g. "ethtool --debug 0x12 eth0"
> >  
> > Hi Michal
> > 
> > See if this helps.
> > 
> > This is a Marvel Ethernet switch port using an Marvell PHY.
> 
> Thank you. I think I can see the problem. Can you try the patch below?

Hi Michal

This is better.

	Link partner advertised link modes:  10baseT/Half 10baseT/Full
	                                     100baseT/Half 100baseT/Full
	                                     1000baseT/Full
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: No

However, the Debian version gives:

	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	                                     1000baseT/Full 
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported

For the USB-Ethernet dongle:

netlink:
	Link partner advertised link modes:  10baseT/Half 10baseT/Full
	                                     100baseT/Half 100baseT/Full
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: No
IOCTL
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	Link partner advertised pause frame use: Symmetric
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported

	Andrew
