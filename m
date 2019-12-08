Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F275116324
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 18:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLHROc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 12:14:32 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:29258 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfLHROc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Dec 2019 12:14:32 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id xB8HEJB0027960;
        Sun, 8 Dec 2019 18:14:19 +0100
Date:   Sun, 8 Dec 2019 18:14:19 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        maxime.chevallier@bootlin.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: fix condition for setting up link
 interrupt
Message-ID: <20191208171419.GB27949@1wt.eu>
References: <20190124131803.14038-1-tbogendoerfer@suse.de>
 <20190124155137.GD482@lunn.ch>
 <20190124160741.jady3r2e4dme7c4m@e5254000004ec.dyn.armlinux.org.uk>
 <20190125083720.GK3662@kwain>
 <20191208164235.GT1344@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191208164235.GT1344@shell.armlinux.org.uk>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 08, 2019 at 04:42:36PM +0000, Russell King - ARM Linux admin wrote:
> Today, I received an email from Willy Tarreau about this issue which
> persists to this day with mainline kernels.
> 
> Willy reminded me that I've been carrying a fix for this, but because
> of your concerns as stated above, I haven't bothered submitting it
> through fear of causing regressions (which you seem to know about):
> 
>    http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=mvpp2&id=67ef3bff255b26cc0d6def8ca99c4e8ae9937727
> 
> Just like Thomas' case, the current code is broken for phylink when
> in-band negotiation is being used - such as with the 1G/2.5G SFP
> slot on the Macchiatobin.

Just to provide some context, I upgraded my mcbin-single-shot from 5.1.5
to 5.4.2 with everything working except that the SFP links would never get
up anymore (either in ethtool or ip link). I've been digging quite a bit,
looking at any DT change or out-of-tree patches and found the one above
with the exact description of my issue, which appeared to totally make
sense. Applying it alone fixed the issue, so unless there are more
serious downsides than unusable ethernet ports, it would be nice to have
it merged.

Thanks!
Willy
