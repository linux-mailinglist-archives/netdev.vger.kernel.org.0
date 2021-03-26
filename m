Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B7E34B03D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 21:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCZUhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 16:37:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhCZUhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 16:37:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPtCt-00DCeR-2R; Fri, 26 Mar 2021 21:37:23 +0100
Date:   Fri, 26 Mar 2021 21:37:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Jakub Kicinski' <kuba@kernel.org>, arndb@arndb.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brandon_chuang@edge-core.com, wally_wang@accton.com,
        aken_liu@edge-core.com, gulv@microsoft.com, jolevequ@microsoft.com,
        xinxliu@microsoft.com, 'netdev' <netdev@vger.kernel.org>,
        'Moshe Shemesh' <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <YF5GA1RbaM1Ht3nl@lunn.ch>
References: <YEvILa9FK8qQs5QK@lunn.ch>
 <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org>
 <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <001201d719c6$6ac826c0$40587440$@thebollingers.org>
 <YFJHN+raumcJ5/7M@lunn.ch>
 <009601d72023$b73dbde0$25b939a0$@thebollingers.org>
 <YFpr2RyiwX10SNbD@lunn.ch>
 <011301d7226f$dc2426f0$946c74d0$@thebollingers.org>
 <YF46FI4epRGwlyP8@lunn.ch>
 <011901d7227c$e00015b0$a0004110$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011901d7227c$e00015b0$a0004110$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 01:16:14PM -0700, Don Bollinger wrote:
> > > In my community, the SFP/QSFP/CMIS devices (32 to 128 of them per
> > > switch) often cost more than the switch itself.  Consumers (both
> > > vendors and
> > > customers) extensively test these devices to ensure correct and
> > > reliable operation.  Then they buy them literally by the millions.
> > > Quirks lead to quick rejection in favor of reliable parts from
> > > reliable vendors.  In this environment, for completely different
> > > reasons, optoe does not need to handle quirks.
> > 
> > Well, if optoe were to be merged, it would not be just for your community.
> It
> > has to work for everybody who wants to use the Linux kernel with an SFP.
> > You cannot decide to add a KAPI which just supports a subset of SFPs. It
> > needs to support as many as possible, warts and all.
> > 
> > So how would you handle these SFPs with the optoe KAPI?
> 
> Just like they are handled now.  Folks who use your stack would filter
> through sfp.c, with all the quirk handling, and eventually call optoe for
> the actual device access.  Folks who don't use kernel networking would call
> optoe directly and limit themselves to well behaved SFPs, or would handle
> quirks in user space.  You think that's dumb, but there is clearly a market
> for that approach.  It is working, at scale, today.
> 
> BTW, why can't we have a driver

You keep missing the point. I always refer to the KAPI. The driver we
can rework and rework, throw away and reimplement, as much as we want.
The KAPI cannot be changed, it is ABI. It is pretty much frozen the
day the code is first committed.

The optoe KAPI needs to handle these 'interesting' SFP modules. The
KAPI design needs to be flexible enough that the driver underneath it
can be extended to support these SFPs. The code does not need to be
there, but the KAPI design needs to allow it. And i personally cannot
see how the optoe KAPI can efficiently support these SFPs.

    Andrew
