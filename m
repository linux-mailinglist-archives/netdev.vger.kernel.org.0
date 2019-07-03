Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4AEF5DEF9
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGCHiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:38:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:57340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727008AbfGCHiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:38:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5C060AFD2;
        Wed,  3 Jul 2019 07:38:04 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A2C74E0159; Wed,  3 Jul 2019 09:38:02 +0200 (CEST)
Date:   Wed, 3 Jul 2019 09:38:02 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 11/15] ethtool: provide link mode names as a
 string set
Message-ID: <20190703073802.GJ20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <1e1bf53de26780ecc0e448aa07dc429ef590798a.1562067622.git.mkubecek@suse.cz>
 <20190702190419.1cb8a189@cakuba.netronome.com>
 <20190702191124.259c6628@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702191124.259c6628@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 07:11:24PM -0700, Jakub Kicinski wrote:
> On Tue, 2 Jul 2019 19:04:19 -0700, Jakub Kicinski wrote:
> > On Tue,  2 Jul 2019 13:50:34 +0200 (CEST), Michal Kubecek wrote:
> > > +const char *const link_mode_names[] = {
> > > +	__DEFINE_LINK_MODE_NAME(10, T, Half),
> > > +	__DEFINE_LINK_MODE_NAME(10, T, Full),
> > > +	__DEFINE_LINK_MODE_NAME(100, T, Half),
> > > +	__DEFINE_LINK_MODE_NAME(100, T, Full),
> > > +	__DEFINE_LINK_MODE_NAME(1000, T, Half),
> > > +	__DEFINE_LINK_MODE_NAME(1000, T, Full),
> > > +	__DEFINE_SPECIAL_MODE_NAME(Autoneg, "Autoneg"),
> > > +	__DEFINE_SPECIAL_MODE_NAME(TP, "TP"),
> > > +	__DEFINE_SPECIAL_MODE_NAME(AUI, "AUI"),
> > > +	__DEFINE_SPECIAL_MODE_NAME(MII, "MII"),
> > > +	__DEFINE_SPECIAL_MODE_NAME(FIBRE, "FIBRE"),
> > > +	__DEFINE_SPECIAL_MODE_NAME(BNC, "BNC"),  
> > 
> > > +	__DEFINE_LINK_MODE_NAME(10000, T, Full),
> > > +	__DEFINE_SPECIAL_MODE_NAME(Pause, "Pause"),
> > > +	__DEFINE_SPECIAL_MODE_NAME(Asym_Pause, "Asym_Pause"),
> > > +	__DEFINE_LINK_MODE_NAME(2500, X, Full),
> > > +	__DEFINE_SPECIAL_MODE_NAME(Backplane, "Backplane"),
> > > +	__DEFINE_LINK_MODE_NAME(1000, KX, Full),  
> > ...
> > > +	__DEFINE_LINK_MODE_NAME(5000, T, Full),
> > > +	__DEFINE_SPECIAL_MODE_NAME(FEC_NONE, "None"),
> > > +	__DEFINE_SPECIAL_MODE_NAME(FEC_RS, "RS"),
> > > +	__DEFINE_SPECIAL_MODE_NAME(FEC_BASER, "BASER"),  
> > 
> > Why are port types and FEC params among link mode strings?
> 
> Ah, FEC for autoneg, but port type?

The bits in supported bitmap are used to pass information which port
types the device supports (but the information which port is selected
is passed in a different way :-( ). It is used by ethtool to provide the
"Supported ports:" line in "ethtool <dev>" output.

I don't like this design where link modes are mixed with few different
and only loosely related bitmaps. Maybe it would be cleaner to split it
into multiple bitmaps and later change the backend (ethtool_ops) too and
only translate to/from this combined bitmap for legacy ioctl interface.

Michal

> 
> > > +	__DEFINE_LINK_MODE_NAME(50000, KR, Full),  
> > ...
> > > +	__DEFINE_LINK_MODE_NAME(1000, T1, Full),
> > > +};  
> 
