Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1652E0B9E
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgLVOXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:23:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbgLVOXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 09:23:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kriYt-00DOMa-HG; Tue, 22 Dec 2020 15:22:51 +0100
Date:   Tue, 22 Dec 2020 15:22:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin =?iso-8859-1?Q?Hundeb=F8ll?= <mhu@silicom.dk>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Reporting SFP presence status
Message-ID: <20201222142251.GJ3107610@lunn.ch>
References: <5db3cbd8-ec1c-a156-bcb9-50fb3b8391b0@silicom.dk>
 <20201221152205.GG3026679@lunn.ch>
 <24cb0fa7-13fc-4463-bb3e-fcd1d13b3fcc@silicom.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24cb0fa7-13fc-4463-bb3e-fcd1d13b3fcc@silicom.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 07:28:10AM +0100, Martin Hundebøll wrote:
> Hi Andrew,
> 
> On 21/12/2020 16.22, Andrew Lunn wrote:
> > On Mon, Dec 21, 2020 at 11:37:55AM +0100, Martin Hundebøll wrote:
> > > Hi Andrew,
> > > 
> > > I've browsed the code in drivers/net/phy, but haven't found a place where
> > > the SFP module status/change is reported to user-space. Is there a
> > > "standard" way to report insert/remove events for SFP modules, or should we
> > > just add a custom sysfs attribute to our driver?
> > 
> > Hi Martin
> > 
> > There is currently no standard way of notifying user space. But it is
> > something which could be added. But it should not be systfs. This
> > should be a netlink notification, probably as part of ethtool netlink
> > API. Or maybe the extended link info.
> > 
> > What is your intended use case? Why do you need to know when a module
> > has been inserted? It seems like you cannot do too much on such a
> > notification. It seems lots of modules don't conform to the standard,
> > will not immediately respond on the i2c bus. So ethtool -m is probably
> > not going to be useful. You probably need to poll until it does
> > respond, which defeats the purpose of having a notification.
> 
> You're right; a notification isn't what I need. But a way to query the
> current state of the module would be nice, i.e. using ethtool.

What do you mean by state? ethtool -m gives you some state
information. ENODEV gives you an idea that there is no module
inserted. Lots of data suggests there is a module. You can decode the
data to get a lot of information. 

There was also a patchset from Russell King a few weeks ago exposing
some information in debugfs. But since it is debugfs, you cannot rely
on it.

Back to, what is you real use cases here?

     Andrew
