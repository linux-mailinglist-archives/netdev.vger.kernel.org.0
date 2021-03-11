Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E4C337A44
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCKRAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:00:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhCKQ7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:59:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKOf2-00ANxe-NU; Thu, 11 Mar 2021 17:59:44 +0100
Date:   Thu, 11 Mar 2021 17:59:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org, rabeeh@solid-run.com
Subject: Re: [V2 net-next] net: mvpp2: Add reserved port private flag
 configuration
Message-ID: <YEpMgK1MF6jFn2ZW@lunn.ch>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 06:43:27PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>

Hi Stefan

Thanks for the strings change. Looks a lot better.

Now i took a look at the bigger picture.

> According to Armada SoC architecture and design, all the PPv2 ports
> which are populated on the same communication processor silicon die
> (CP11x) share the same Classifier and Parser engines.
> 
> Armada is an embedded platform and therefore there is a need to reserve
> some of the PPv2 ports for different use cases.
> 
> For example, a port can be reserved for a CM3 CPU running FreeRTOS
> for management purposes

So the CM3 CPU has its own driver for this hardware? It seems like we
should not even instantiate the Linux driver for this port. Does the
CM3 have its own DT blob? I think the better solution is that the
Armada DT for the board does not list the port, and the DT for the CM3
does. Linux never sees the port, since Linux should not be using it.

> or by user-space data plane application.

You mean XDP/AF_XDP? I don't see any other XDP capable drivers having
a flag like this. If this was required, i would expect it to be a
common properly, not driver private.

	  Andrew
