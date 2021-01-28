Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC233068D5
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhA1AwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:52:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhA1Avz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:51:55 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4vWi-002wwd-4j; Thu, 28 Jan 2021 01:51:12 +0100
Date:   Thu, 28 Jan 2021 01:51:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 1/4] net: dsa: automatically bring up DSA master
 when opening user port
Message-ID: <YBIKgGw+GExbsAcx@lunn.ch>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127010028.1619443-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127010028.1619443-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 03:00:25AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA wants the master interface to be open before the user port is due to
> historical reasons. The promiscuity of interfaces that are down used to
> have issues, as referenced Lennert Buytenhek in commit df02c6ff2e39
> ("dsa: fix master interface allmulti/promisc handling").
> 
> The bugfix mentioned there, commit b6c40d68ff64 ("net: only invoke
> dev->change_rx_flags when device is UP"), was basically a "don't do
> that" approach to working around the promiscuity while down issue.
> 
> Further work done by Vlad Yasevich in commit d2615bf45069 ("net: core:
> Always propagate flag changes to interfaces") has resolved the
> underlying issue, and it is strictly up to the DSA and 8021q drivers
> now, it is no longer mandated by the networking core that the master
> interface must be up when changing its promiscuity.
> 
> >From DSA's point of view, deciding to error out in dsa_slave_open
> because the master isn't up is (a) a bad user experience and (b) missing
> the forest for the trees. Even if there still was an issue with
> promiscuity while down, DSA could still do this and avoid it: open the
> DSA master manually, then do whatever. Voila, the DSA master is now up,
> no need to error out.
> 
> Doing it this way has the additional benefit that user space can now
> remove DSA-specific workarounds, like systemd-networkd with BindCarrier:
> https://github.com/systemd/systemd/issues/7478
> 
> And we can finally remove one of the 2 bullets in the "Common pitfalls
> using DSA setups" chapter.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
