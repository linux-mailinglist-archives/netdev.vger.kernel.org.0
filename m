Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DC12F9009
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 02:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbhAQB1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 20:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbhAQB1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 20:27:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C72FE223C8;
        Sun, 17 Jan 2021 01:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610846784;
        bh=XoPy3xRT1Lac0gRXGLPmurjG9cPfI56hkTmapT5BXzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kvVhFyo7SKrgTt5g2Gch10MT4V6u5GFnn5oz8mZSILmB0ktT5GpN3xQD96JnQVmzL
         r9B4YZHOgOyr2H+8NG+wpNZMUMt/wZGxeXE7kG1rrGgq0G9pldvc1W+Uem/NCJXzZN
         Ug6PJc/TRCN6Y5yFUGNJF/dXjyJLSLfAVE6ErxkgLFWX37UWfRBN5l4HAtKLL0kVWL
         JwXfK6oR2me5REAFJ6Q2UipFc6e92X4f/mI3yYeNXhZjikcIvnM08Q3uRg/f2//6Su
         HyKmqwWJ6U4eWpCDs3WZg+KvoATj3eQSOsUwDjheIyJ3cjVVUZ1tx+y92+glyNlYFS
         7LuBI1i0Ynb+Q==
Date:   Sat, 16 Jan 2021 17:26:23 -0800
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
Subject: Re: [PATCH v2 net-next 01/14] net: mscc: ocelot: allow offloading
 of bridge on top of LAG
Message-ID: <20210116172623.2277b86a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210116005943.219479-2-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
        <20210116005943.219479-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jan 2021 02:59:30 +0200 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Commit 7afb3e575e5a ("net: mscc: ocelot: don't handle netdev events for
> other netdevs") was too aggressive, and it made ocelot_netdevice_event
> react only to network interface events emitted for the ocelot switch
> ports.
> 
> In fact, only the PRECHANGEUPPER should have had that check.
> 
> When we ignore all events that are not for us, we miss the fact that the
> upper of the LAG changes, and the bonding interface gets enslaved to a
> bridge. This is an operation we could offload under certain conditions.

I see the commit in question is in net, perhaps worth spelling out why
this is not a fix? Perhaps add some "in the future" to the last
sentence if it's the case that this will only matter with the following
patches applied?
