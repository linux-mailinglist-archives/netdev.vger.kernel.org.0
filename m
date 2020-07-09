Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB8821A233
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 16:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgGIOff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 10:35:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgGIOff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 10:35:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtXe9-004LHE-5f; Thu, 09 Jul 2020 16:35:33 +0200
Date:   Thu, 9 Jul 2020 16:35:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [DSA] L2 Forwarding Offload not working
Message-ID: <20200709143533.GN928075@lunn.ch>
References: <29a9c85b-8f5a-2b85-2c7d-9b7ca0a6cb41@gmx.net>
 <20200709135335.GL928075@lunn.ch>
 <50c35a41-45c2-1f2b-7189-96fe7c0a1740@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50c35a41-45c2-1f2b-7189-96fe7c0a1740@gmx.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Two questions if you do not mind:
> 
> 1) does the above apply to all stable kernel releases or only => 5.4?
> Because with 4.14 there are reports that dynamic addresses of clients
> roaming from a switch port to an bridge port (upstream of the switch,
> e.g. WLan AP provided by the router) facing time outs until the switch
> retires (ages) the client's MAC.

DSA has always worked like this.

It does however very from switch to switch. When adding a new switch,
the first version of the driver sometimes does not support offloading.
All frames are forwarded to the software bridge, and the software
bridge does all the work. Then the driver gets extended, to support
the hardware doing the work. And the driver gets extended again to
allow static FDB entries to be passed to the hardware. DSA drivers are
not 'big bang'. It is not all or nothing. They gain features with
time. So you need to look at the driver in your specific version of
the kernel to see what it supports. And you might need to be careful
with the OpenWRT kernel, see if they have backported features.

> 
> 2) The document
> https://www.kernel.org/doc/Documentation/networking/switchdev.txt cites
> (for static entries)
> 
> bridge command will label these entries "offload"
> 
> Is that still up-to-date or rather outdated from the earlier days of DSA?

It should be true. But you need a reasonably recent iproute2 for this
to be shown.

   Andrew
