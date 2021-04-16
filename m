Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6A3361A2B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbhDPG6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 02:58:22 -0400
Received: from elvis.franken.de ([193.175.24.41]:53206 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234691AbhDPG6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 02:58:22 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lXIQM-0007bP-00; Fri, 16 Apr 2021 08:57:54 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 36909C0489; Fri, 16 Apr 2021 08:54:42 +0200 (CEST)
Date:   Fri, 16 Apr 2021 08:54:42 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 06/10] net: korina: Only pass mac address via
 platform data
Message-ID: <20210416065442.GA5082@alpha.franken.de>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
 <20210414230648.76129-7-tsbogend@alpha.franken.de>
 <YHjMfOKyovyzTHOE@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHjMfOKyovyzTHOE@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 01:30:04AM +0200, Andrew Lunn wrote:
> On Thu, Apr 15, 2021 at 01:06:43AM +0200, Thomas Bogendoerfer wrote:
> > Get rid of access to struct korina_device by just passing the mac
> > address via platform data and use drvdata for passing netdev to remove
> > function.
> > 
> > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > ---
> >  arch/mips/rb532/devices.c     |  5 +++--
> >  drivers/net/ethernet/korina.c | 11 ++++++-----
> >  2 files changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
> > index dd34f1b32b79..5fc3c8ee4f31 100644
> > --- a/arch/mips/rb532/devices.c
> > +++ b/arch/mips/rb532/devices.c
> > @@ -105,6 +105,9 @@ static struct platform_device korina_dev0 = {
> >  	.name = "korina",
> >  	.resource = korina_dev0_res,
> >  	.num_resources = ARRAY_SIZE(korina_dev0_res),
> > +	.dev = {
> > +		.platform_data = &korina_dev0_data.mac,
> > +	}
> 
> This is a bit unusual. Normally you define a structure in
> include/linux/platform/data/koriana.h, and use that.
> 
> What about the name? "korina0" How is that passed?

this is just for transition purpose. My DT patches remove this struct
completly.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
