Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A932F901A
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbhAQB66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 20:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbhAQB65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 20:58:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5596822BF3;
        Sun, 17 Jan 2021 01:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610848696;
        bh=TyaQ8gu7lp9elwnubxf5LIqJyMXZOjsnG6jmG3+pkbQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ETQeaXNS6iPTrjJN0gYAQImrPTn1MOSZ9xyLXspiiAdcCAssRveziwD7ZhYb3rB7i
         5A0AFifAKgSt8/jgeTfLT4HGMgsPJDS/TRNegM0SWCC57smF87eEkO+xS5wqWsvAfq
         3ZTZY936xhUZUnbcgqv0MOQN8HVaixnZtMaJK280Yr11FhCFgVrelPNXvRTHyzuXtK
         4P1rvulaXu+1vWqnvuqrYdZnK+SaZcTY2NElCa/sinlh825zS2qhQ3ee2saaQBia6F
         xG0YRE/NgSRd3xs3fVMQC8dfyc3ZfEbw4n2UuciuufCdX66CCRiKAoth+xH4nCuCc9
         NI5n/0XuJIsqg==
Date:   Sat, 16 Jan 2021 17:58:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH v2 net-next 00/14] LAG offload for Ocelot DSA switches
Message-ID: <20210116175815.6e4d3fa4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210116172510.27a9431b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
        <20210116155103.eftu5m5ot7ntjqj5@skbuf>
        <20210116172510.27a9431b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jan 2021 17:25:10 -0800 Jakub Kicinski wrote:
> On Sat, 16 Jan 2021 17:51:03 +0200 Vladimir Oltean wrote:
> > On Sat, Jan 16, 2021 at 02:59:29AM +0200, Vladimir Oltean wrote:  
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > 
> > > This patch series reworks the ocelot switchdev driver such that it could
> > > share the same implementation for LAG offload as the felix DSA driver.    
> > 
> > Jakub, I sent these patches a few hours early because I didn't want to
> > wait for the devlink-sb series to get accepted. Now that it did, can you
> > move the patches back from the RFC state into review, or do I need to
> > resend them?  
> 
> I tried to convince the build bot to take a look at this series again,
> but failed :( Let me look at the patches now, but you'll have to repost
> to get them merged.

The code LGTM, FWIW. I'm a little surprised you opted in for allocation
in ocelot_set_aggr_pgids() but admittedly that makes the code much
simpler than trying to for instance use lower bits of pointers as
markers, or even a bitmask on the stack..
