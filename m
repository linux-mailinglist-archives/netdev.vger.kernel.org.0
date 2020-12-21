Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5792DFD74
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 16:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgLUPWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 10:22:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35700 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgLUPWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 10:22:47 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krN0f-00D9iR-Mp; Mon, 21 Dec 2020 16:22:05 +0100
Date:   Mon, 21 Dec 2020 16:22:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin =?iso-8859-1?Q?Hundeb=F8ll?= <mhu@silicom.dk>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Reporting SFP presence status
Message-ID: <20201221152205.GG3026679@lunn.ch>
References: <5db3cbd8-ec1c-a156-bcb9-50fb3b8391b0@silicom.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5db3cbd8-ec1c-a156-bcb9-50fb3b8391b0@silicom.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 11:37:55AM +0100, Martin Hundebøll wrote:
> Hi Andrew,
> 
> I've browsed the code in drivers/net/phy, but haven't found a place where
> the SFP module status/change is reported to user-space. Is there a
> "standard" way to report insert/remove events for SFP modules, or should we
> just add a custom sysfs attribute to our driver?

Hi Martin

There is currently no standard way of notifying user space. But it is
something which could be added. But it should not be systfs. This
should be a netlink notification, probably as part of ethtool netlink
API. Or maybe the extended link info.

What is your intended use case? Why do you need to know when a module
has been inserted? It seems like you cannot do too much on such a
notification. It seems lots of modules don't conform to the standard,
will not immediately respond on the i2c bus. So ethtool -m is probably
not going to be useful. You probably need to poll until it does
respond, which defeats the purpose of having a notification.

	Andrew
