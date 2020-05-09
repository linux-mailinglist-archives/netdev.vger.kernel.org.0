Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E3E1CBE79
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgEIHma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgEIHma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 03:42:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D706724953;
        Sat,  9 May 2020 07:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589010149;
        bh=p3lxqwc4NEYvYhnZD2I8HdvhC+aJ8MzRi8M/mDgQePo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u6PhzFRofkqlmS8ZCVI113moAm5Q6AzI6qjhs5JjjWpuH6Pj1MKhOMcXQk2UHN0i5
         mBz2A6WtGgwWYGH9EIcI4g9pGQUNRrLoiQm9NazJL8fz8xOOfzX9Wjw1z55x1akHCh
         Jg79WaCOkXVhjahesTKvgeUO7lL+Tv0TPS4YkSoE=
Date:   Sat, 9 May 2020 09:42:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Matteo Croce <mcroce@redhat.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 0/2] Fix 88x3310 leaving power save mode
Message-ID: <20200509074226.GA1831917@kroah.com>
References: <20200414194753.GB25745@shell.armlinux.org.uk>
 <20200414.164825.457585417402726076.davem@davemloft.net>
 <CAGnkfhw45WBjaYFcrO=vK0pbYvhzan970vtxVj8urexhh=WU_A@mail.gmail.com>
 <20200508213816.GY1551@shell.armlinux.org.uk>
 <20200509063631.GA1691791@kroah.com>
 <20200509073256.GZ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509073256.GZ1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 08:32:56AM +0100, Russell King - ARM Linux admin wrote:
> On Sat, May 09, 2020 at 08:36:31AM +0200, Greg Kroah-Hartman wrote:
> > On Fri, May 08, 2020 at 10:38:16PM +0100, Russell King - ARM Linux admin wrote:
> > > On Fri, May 08, 2020 at 11:32:39PM +0200, Matteo Croce wrote:
> > > > On Wed, Apr 15, 2020 at 1:48 AM David Miller <davem@davemloft.net> wrote:
> > > > >
> > > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > > Date: Tue, 14 Apr 2020 20:47:53 +0100
> > > > >
> > > > > > This series fixes a problem with the 88x3310 PHY on Macchiatobin
> > > > > > coming out of powersave mode noticed by Matteo Croce.  It seems
> > > > > > that certain PHY firmwares do not properly exit powersave mode,
> > > > > > resulting in a fibre link not coming up.
> > > > > >
> > > > > > The solution appears to be to soft-reset the PHY after clearing
> > > > > > the powersave bit.
> > > > > >
> > > > > > We add support for reporting the PHY firmware version to the kernel
> > > > > > log, and use it to trigger this new behaviour if we have v0.3.x.x
> > > > > > or more recent firmware on the PHY.  This, however, is a guess as
> > > > > > the firmware revision documentation does not mention this issue,
> > > > > > and we know that v0.2.1.0 works without this fix but v0.3.3.0 and
> > > > > > later does not.
> > > > >
> > > > > Series applied, thanks.
> > > > >
> > > > 
> > > > Hi,
> > > > 
> > > > should we queue this to -stable?
> > > > The 10 gbit ports don't work without this fix.
> > > 
> > > It has a "Fixes:" tag, so it should be backported automatically.
> > 
> > That is a wild guess that it might happen sometime in the future.
> > Please use the cc: stable@ tag as is documented for the past 15+ years
> > instead of relying on us to randomly notice a Fixes: tag.
> 
> Not for netdev material.  Netdev has its own rules:
> 
> https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

<snip>

Sorry, missed that this was netdev, my fault.

greg k-h
