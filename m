Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8485821C6C1
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 01:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGKXwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 19:52:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58968 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgGKXwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 19:52:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juPIJ-004g65-5r; Sun, 12 Jul 2020 01:52:35 +0200
Date:   Sun, 12 Jul 2020 01:52:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Chris Healy <cphealy@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Implement MTU change
Message-ID: <20200711235235.GB1110701@lunn.ch>
References: <20200711203206.1110108-1-andrew@lunn.ch>
 <20200711203206.1110108-2-andrew@lunn.ch>
 <20200712012944.1541b078@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200712012944.1541b078@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 01:29:44AM +0200, Marek Behun wrote:
> On Sat, 11 Jul 2020 22:32:05 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > The Marvell Switches support jumbo packages. So implement the
> > callbacks needed for changing the MTU.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Hi Andrew,
> 
> maybe this could be sent to net, not only net-next. Or maybe even
> better, with a Fixes tag to some commit - DSA now prints warnings on
> some systems when initializing switch interfaces, that MTU cannot be
> changed, so maybe we could look at this patch as a fix and get it
> backported...

Hi Marek

It does not really 'fix' anything. The warning clearly says it is nonfatal

[    2.091447] mv88e6085 0.1:00: nonfatal error -95 setting MTU on port 1
[    2.123378] mv88e6085 0.1:00: nonfatal error -95 setting MTU on port 2
[    2.144035] mv88e6085 0.1:00: nonfatal error -95 setting MTU on port 3
[    2.165546] mv88e6085 0.1:00: nonfatal error -95 setting MTU on port 4
[    2.189840] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 1
[    2.213373] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 2
[    2.232762] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 3
[    2.253840] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 4
[    2.275925] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 9

and the switch works as before. As such, i don't think this patch
meets the requirements of stable:

Documentation/process/stable-kernel-rules.rst

	Andrew
