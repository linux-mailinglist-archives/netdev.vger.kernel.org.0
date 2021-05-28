Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1A6394617
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbhE1Qy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:54:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236624AbhE1QyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 12:54:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6cDg1RXPGmWw0L+86ZDaBALRGmDDzfxkeGMCVHlpckk=; b=xME48x3w0xYzMJ8PrIo2DbtAJ4
        VE1m0PblhrI2CSrNE292WnptRwo6PNK5CWK4gbEXv58ytB3RoPXXPsV//bmWE8vMDc4cSGMwwReaH
        0qW0sI86P/1gLiMFoM7oXLVpioMKsDQjYCK0gphnoyyhwSzPM2AlrqGl1kr5dpRuzMhI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmfix-006m6h-IV; Fri, 28 May 2021 18:52:39 +0200
Date:   Fri, 28 May 2021 18:52:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Bajjuri, Praneeth" <praneeth@ti.com>
Cc:     "Modi, Geet" <geet.modi@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform soft reset and
 retain established link
Message-ID: <YLEf128OEADi0Kb1@lunn.ch>
References: <20210324010006.32576-1-praneeth@ti.com>
 <YFsxaBj/AvPpo13W@lunn.ch>
 <404285EC-BBF0-4482-8454-3289C7AF3084@ti.com>
 <YGSk4W4mW8JQPyPl@lunn.ch>
 <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 11:32:15AM -0500, Bajjuri, Praneeth wrote:
> Hi Andrew,
> 
> On 3/31/2021 11:35 AM, Andrew Lunn wrote:
> > >      > as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
> > > 
> > >      > 8.6.26 Control Register (CTRL)
> > >      > do SW_RESTART to perform a reset not including the registers and is
> > >      > acceptable to do this if a link is already present.
> > > 
> > > 
> > >      I don't see any code here to determine if the like is present. What if
> > >      the cable is not plugged in?
> > > 
> > >      This API is primarily used for reset. Link Status is checked thru different
> > > register. This shall not impact the cable plug in/out. With this change, it
> > > will align with DP83822 driver API.
> > 
> > So why is there the comment:
> > 
> > >      >                                            and is
> > >      > acceptable to do this if a link is already present.
> > 
> > That kind of says, it is not acceptable to do this if the link is not
> > present. Which is why i'm asking.
> 
> Does the feedback from Geet help in clarity you requested.
> Ref:
> https://lore.kernel.org/netdev/4838EA12-7BF4-4FF2-8305-7446C3498DDF@ti.com/

Not really.

>                                                        and is
> > >      > acceptable to do this if a link is already present.

There needs to be something to either:

1) Ensure there is link, so we known we are within acceptable
behaviour.

2) Document what happens when there is no link, meaning we do
something which is not acceptable. Is the magic smoke going to be
released? Does the link die until the next reboot? Or despite it being
unacceptable, nothing really happens, and it is not a problem?

	      Andrew
