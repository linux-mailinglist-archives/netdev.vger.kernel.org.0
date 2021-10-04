Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E54420759
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 10:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhJDIcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 04:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230469AbhJDIcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 04:32:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 639EC6124D;
        Mon,  4 Oct 2021 08:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633336228;
        bh=AGIgwoQNBBt0ACT2Oa703+VXilss9u/HArqWzTXe+jM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xu8068laLv4h09QdbkgWqg1+Hsrt2pB2Y69WPnlP903fWNJN40bLPIgUB8fTcTLUC
         x4BGct5hBdnnFcBypf8x7utNBSs6iaKRodKX5yHA39OhoKUatmYRx9HNOrxSXBJi2M
         GnVRK9NTnZXWHkEyIDE4zSMdlENcN2Uc92Wr0amA=
Date:   Mon, 4 Oct 2021 10:30:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: are device names part of sysfs ABI? (was Re: devicename part of
 LEDs under ethernet MAC / PHY)
Message-ID: <YVq7oTTv5URYKVJb@kroah.com>
References: <20211001133057.5287f150@thinkpad>
 <YVb/HSLqcOM6drr1@lunn.ch>
 <20211001144053.3952474a@thinkpad>
 <20211003225338.76092ec3@thinkpad>
 <YVqhMeuDI0IZL/zY@kroah.com>
 <20211004090438.588a8a89@thinkpad>
 <YVqo64vS4ox9P9hk@kroah.com>
 <20211004073841.GA20163@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004073841.GA20163@amd>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 09:38:41AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > Are device names (as returned by dev_name() function) also part of
> > > > > sysfs ABI? Should these names be stable across reboots / kernel
> > > > > upgrades?  
> > > > 
> > > > Stable in what exact way?
> > > 
> > > Example:
> > > - Board has an ethernet PHYs that is described in DT, and therefore
> > >   has stable sysfs path (derived from DT path), something like
> > >     /sys/devices/.../mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:01
> > 
> > None of the numbers there are "stable", right?
> 
> At least f1072004 part is stable (and probably whole path). DT has
> advantages here, and we should provide stable paths when we can.

The kernel should enumerate the devices as best that it can, but it
never has the requirement of always enumerating them in the same way
each time as many busses are not deterministic.
