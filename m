Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5463526936B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgINRcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:32:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgINR2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 13:28:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHsHF-00Edsl-SB; Mon, 14 Sep 2020 19:28:29 +0200
Date:   Mon, 14 Sep 2020 19:28:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914172829.GC3485708@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911234932.ncrmapwpqjnphdv5@skbuf>
 <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200912001542.fqn2hcp35xkwqoun@skbuf>
 <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200912071612.cq7adzzxxgpcauux@skbuf>
 <20200914091518.0bcf0d58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914091518.0bcf0d58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 09:15:18AM -0700, Jakub Kicinski wrote:
> On Sat, 12 Sep 2020 10:16:12 +0300 Vladimir Oltean wrote:
> I never used a DSA device. But I was under the impression they were
> supposed to be modeled like separate NICs..

The front panel ports are. However there are other types of ports as
well. You have at least one port of the switch connected to the SoC,
so the SoC can send/receive frames. This is the so called CPU port of
the switch. And Marvell switches support connecting switch ports
together to form a cluster of switches. These are the so called DSA
ports of the switch. Neither CPU nor DSA ports have a netdev, since
they are internal plumbing.

> Stats on the "CPU port" should be symmetrical with the CPU MAC.

If things are working as expected. But pause is configurable per
MAC. It could be one end has been configured to asym pause, and the
other to pause. It could be one end is configured to asym pause, and
the other end is failing to autoneg, etc. Just seeing that the stats
are significantly different is a good clue something is up.

    Andrew
