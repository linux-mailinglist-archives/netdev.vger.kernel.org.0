Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70AE203881
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgFVNzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:55:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbgFVNzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:55:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnMuk-001few-R2; Mon, 22 Jun 2020 15:55:10 +0200
Date:   Mon, 22 Jun 2020 15:55:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 6/9] net: dsa: hellcreek: Add debugging mechanisms
Message-ID: <20200622135510.GN338481@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-7-kurt@linutronix.de>
 <20200618173458.GH240559@lunn.ch>
 <875zbnqwo2.fsf@kurt>
 <20200619134218.GD304147@lunn.ch>
 <87d05rth5v.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d05rth5v.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 02:32:28PM +0200, Kurt Kanzenbach wrote:
> On Fri Jun 19 2020, Andrew Lunn wrote:
> >> > Are trace registers counters?
> >> 
> >> No. The trace registers provide bits for error conditions and if packets
> >> have been dropped e.g. because of full queues or FCS errors, and so on.
> >
> > Is there some documentation somewhere? A better understanding of what
> > they can do might help figure out the correct API.
> 
> No, not that I'm aware of.
> 
> Actually there are a few more debugging mechanisms and features which
> should be exposed somehow. Here's the list:
> 
>  * Trace registers for the error conditions. This feature needs to be
>    configured for which ports should be traced
>  * Memory registers for indicating how many free page and meta pointers
>    are available (read-only)
>  * Limit registers for configuring:
>    * Maximum memory limit per port
>    * Reserved memory for critical traffic
>    * Background traffic rate
>    * Maximum queue depth
>  * Re-prioritization of packets based on the ether type (not mac address)
>  * Packet logging (-> retrieval of packet time stamps) based on port, traffic class and direction
>  * Queue tracking
> 
> What API would be useful for these mechanisms?

Hi Kurt

You should take a look at devlink. Many of these fit devlink
resources. Use that where it fits. But you might end up with an out of
tree debugfs patch for your own debugging work. We have something
similar of mv88e6xxx.

	Andrew
