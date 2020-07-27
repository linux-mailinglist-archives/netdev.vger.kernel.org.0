Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281FF22FC4E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgG0WkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:40:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:42030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgG0WkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:40:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AF9BAAEA5;
        Mon, 27 Jul 2020 22:40:12 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E2A1F6073D; Tue, 28 Jul 2020 00:40:01 +0200 (CEST)
Date:   Tue, 28 Jul 2020 00:40:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
Message-ID: <20200727224001.hevbrhillv7tdmdo@lion.mk-sys.cz>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
 <20200727221104.GD1705504@lunn.ch>
 <20200727222645.uhtve7x2wkzddnub@lion.mk-sys.cz>
 <02874ECE860811409154E81DA85FBB58C8B20741@fmsmsx101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02874ECE860811409154E81DA85FBB58C8B20741@fmsmsx101.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 10:32:03PM +0000, Keller, Jacob E wrote:
> > -----Original Message-----
> > From: Michal Kubecek <mkubecek@suse.cz>
> > Sent: Monday, July 27, 2020 3:27 PM
> > To: Andrew Lunn <andrew@lunn.ch>
> > Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org; Jamie
> > Gloudon <jamie.gloudon@gmx.fr>
> > Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
> > 
> > On Tue, Jul 28, 2020 at 12:11:04AM +0200, Andrew Lunn wrote:
> > > Hi Jacob
> > >
> > > This is close
> > >
> > > Netlink
> > > 	Link partner advertised link modes:  10baseT/Half 10baseT/Full
> > > 	                                     100baseT/Half 100baseT/Full
> > > 	                                     1000baseT/Full
> > > 	Link partner advertised pause frame use: No
> > > 	Link partner advertised auto-negotiation: Yes
> > > 	Link partner advertised FEC modes: No
> > >
> > > IOCTL
> > > 	Link partner advertised link modes:  10baseT/Half 10baseT/Full
> > > 	                                     100baseT/Half 100baseT/Full
> > > 	                                     1000baseT/Full
> > > 	Link partner advertised pause frame use: No
> > > 	Link partner advertised auto-negotiation: Yes
> > > 	Link partner advertised FEC modes: Not reported
> > >
> > > So just the FEC modes differ.
> > 
> > This is a different issue, the last call to dump_link_modes() in
> > dump_peer_modes() should be
> > 
> > 	ret = dump_link_modes(nlctx, attr, false, LM_CLASS_FEC,
> > 
> > (third parameter needs to be false, not true).
> > 
> > Michal
> > 
> 
> That's part of it, yea, but also it should use the string "Not
> Reported" instead of "No" I think?

Right, both should be fixed.

Michal

> 
> > >
> > > However, i don't think this was part of the original issue, so:
> > >
> > > Tested-by: Andrew Lunn <andrew@lunn.ch>
> > >
> > > It would be nice to get the FEC modes fixed.
> > >
> > >     Andrew
