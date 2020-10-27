Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC9A29B6A1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 16:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797450AbgJ0PXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 11:23:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797434AbgJ0PXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXQos-003pPs-Mm; Tue, 27 Oct 2020 16:23:30 +0100
Date:   Tue, 27 Oct 2020 16:23:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027152330.GF878328@lunn.ch>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027160530.11fc42db@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027160530.11fc42db@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 04:05:30PM +0100, Marek Behun wrote:
> When I first read about port trunking in the Peridot documentation, I
> immediately thought that this could be used to transparently offload
> that which is called Bonding in Linux...
> 
> Is this what you want to eventually do?
> 
> BTW, I thought about using port trunking to solve the multi-CPU DSA
> issue as well. On Turris Omnia we have 2 switch ports connected to the
> CPU. So I could trunk these 2 swtich ports, and on the other side
> create a bonding interface from eth0 and eth1.
> 
> Andrew, what do you think about this? Is this something that can be
> done? Or is it too complicated?
 
Hi Marek

trunking is something i've looked at once, but never had time to work
on. There are three different use cases i thought of:

1) trunk user ports, with team/bonding controlling it
2) trunk DSA ports, i.e. the ports between switches in a D in DSA setup
3) trunk CPU ports.

What Tobias is implementing here is 1). This seems like a good first
step.

I'm not sure 3) is even possible. Or it might depend on the switch
generation. The 6352 for example, the CPU Dest field is a port
number. It does not appear to allow for a trunk. 6390 moved this
register, but as far as i know, it did not add trunk support.  It
might be possible to have multiple SoC interfaces sending frames to
the Switch using DSA tags, but i don't see a way to have the switch
send frames to the SoC using multiple ports.

     Andrew

