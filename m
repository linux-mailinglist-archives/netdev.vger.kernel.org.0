Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F154137316C
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 22:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhEDUe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 16:34:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232560AbhEDUe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 16:34:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le1jM-002XKq-IS; Tue, 04 May 2021 22:33:20 +0200
Date:   Tue, 4 May 2021 22:33:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
Message-ID: <YJGvkJBKPj2WloXf@lunn.ch>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-7-tobias@waldekranz.com>
 <20210427101747.n3y6w6o7thl5cz3r@skbuf>
 <878s4uo8xc.fsf@waldekranz.com>
 <20210504152106.oppawchuruapg4sb@skbuf>
 <874kfintzh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kfintzh.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There is really no need to recompute the static parts of the tags on
> each skb. It would mean moving some knowledge of the tagging format to
> the driver. But that boundary is pretty artificial for
> mv88e6xxx. tag_dsa has no use outside of mv88e6xxx, and mv88e6xxx does
> not work with any other tagger. I suppose you could even move the whole
> tagger to drivers/net/dsa/mv88e6xxx/?
> 
> What do you think?
> 
> Andrew?

We have resisted this before.

What information do you actually need to share between the tagger and
the driver? Both tag_lan9303.c and tag_ocelot_8021q.c do reference
their switch driver data structures, so some sharing is allowed. But
please try to keep the surface areas down.

       Andrew
