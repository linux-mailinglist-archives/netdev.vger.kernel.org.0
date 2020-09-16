Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5717026C13A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgIPJ4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:56:49 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:41627 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgIPJ4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 05:56:37 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 19608C000A;
        Wed, 16 Sep 2020 09:56:32 +0000 (UTC)
Date:   Wed, 16 Sep 2020 11:56:32 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net 0/7] Bugfixes in Microsemi Ocelot switch driver
Message-ID: <20200916095632.GI9675@piout.net>
References: <20200915182229.69529-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915182229.69529-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 15/09/2020 21:22:22+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is a series of 7 assorted patches for "net", on the drivers for the
> VSC7514 MIPS switch (Ocelot-1), the VSC9953 PowerPC (Seville), and a few
> more that are common to all supported devices since they are in the
> common library portion.
> 
> Vladimir Oltean (7):
>   net: mscc: ocelot: fix race condition with TX timestamping
>   net: mscc: ocelot: add locking for the port TX timestamp ID
>   net: dsa: seville: fix buffer size of the queue system
>   net: mscc: ocelot: check for errors on memory allocation of ports
>   net: mscc: ocelot: error checking when calling ocelot_init()
>   net: mscc: ocelot: refactor ports parsing code into a dedicated
>     function
>   net: mscc: ocelot: unregister net devices on unbind
> 
>  drivers/net/dsa/ocelot/felix.c             |   5 +-
>  drivers/net/dsa/ocelot/seville_vsc9953.c   |   2 +-
>  drivers/net/ethernet/mscc/ocelot.c         |  13 +-
>  drivers/net/ethernet/mscc/ocelot_net.c     |  12 +-
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 234 ++++++++++++---------
>  include/soc/mscc/ocelot.h                  |   1 +
>  net/dsa/tag_ocelot.c                       |  11 +-
>  7 files changed, 168 insertions(+), 110 deletions(-)
> 

This series is leading to multiple crashes on my vc7524 board. I'm
trying to pinpoint the problematic commits


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
