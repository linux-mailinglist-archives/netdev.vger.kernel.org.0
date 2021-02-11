Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C053318D3F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhBKOWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:22:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232218AbhBKOUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 09:20:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lACoV-005aey-Jy; Thu, 11 Feb 2021 15:19:23 +0100
Date:   Thu, 11 Feb 2021 15:19:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v12 net-next 12/15] net: mvpp2: add BM
 protection underrun feature support
Message-ID: <YCU864+AH6UioNwQ@lunn.ch>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
 <1612950500-9682-13-git-send-email-stefanc@marvell.com>
 <20210210.152924.767175240247395907.davem@davemloft.net>
 <CO6PR18MB3873D8B7BE3AE28A1407C05BB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873D8B7BE3AE28A1407C05BB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 08:22:19AM +0000, Stefan Chulski wrote:
> 
> > 
> > ----------------------------------------------------------------------
> > From: <stefanc@marvell.com>
> > Date: Wed, 10 Feb 2021 11:48:17 +0200
> > 
> > >
> > > +static int bm_underrun_protect = 1;
> > > +
> > > +module_param(bm_underrun_protect, int, 0444);
> > > +MODULE_PARM_DESC(bm_underrun_protect, "Set BM underrun protect
> > > +feature (0-1), def=1");
> > 
> > No new module parameters, please.
> 
> Ok, I would remove new module parameters.
> By the way why new module parameters forbitten?

Historically, module parameters are a bad interface for
configuration. Vendors have stuffed all sorts of random junk into
module parameters. There is little documentation. Different drivers
can have similar looking module parameters which do different
things. Or different module parameters, which actually do the same
thing. But maybe with slightly different parameters.

We get a much better overall result if you stop and think for a
while. How can this be made a generic configuration knob which
multiple vendors could use? And then add it to ethtool. Extend the
ethtool -h text and the man page. Maybe even hack some other vendors
driver to make use of it.

Or we have also found out, that pushing back on parameters like this,
the developers goes back and looks at the code, and sometimes figures
out a way to automatically do the right thing, removing the
configuration knob, and just making it all simpler for the user to
use.

       Andrew
