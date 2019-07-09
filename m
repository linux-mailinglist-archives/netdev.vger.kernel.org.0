Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2212C63892
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfGIPYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:24:01 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:58101 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfGIPYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:24:01 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 7F9761BF20E;
        Tue,  9 Jul 2019 15:23:57 +0000 (UTC)
Date:   Tue, 9 Jul 2019 17:23:56 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v2 8/8] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190709152356.GG2932@kwain>
References: <20190705195213.22041-1-antoine.tenart@bootlin.com>
 <20190705195213.22041-9-antoine.tenart@bootlin.com>
 <20190705151038.0581a052@cakuba.netronome.com>
 <20190708084809.GB2932@kwain>
 <20190708120626.2cecc86b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190708120626.2cecc86b@cakuba.netronome.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On Mon, Jul 08, 2019 at 12:06:26PM -0700, Jakub Kicinski wrote:
> On Mon, 8 Jul 2019 10:48:09 +0200, Antoine Tenart wrote:
> > > > +	/* Commit back the result & save it */
> > > > +	memcpy(&ocelot->hwtstamp_config, &cfg, sizeof(cfg));
> > > > +	mutex_unlock(&ocelot->ptp_lock);
> > > > +
> > > > +	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> > > > +}
> > > >  
> > > > +static int ocelot_get_ts_info(struct net_device *dev,
> > > > +			      struct ethtool_ts_info *info)
> > > > +{
> > > > +	struct ocelot_port *ocelot_port = netdev_priv(dev);
> > > > +	struct ocelot *ocelot = ocelot_port->ocelot;
> > > > +	int ret;
> > > > +
> > > > +	if (!ocelot->ptp)
> > > > +		return -EOPNOTSUPP;  
> > > 
> > > Hmm.. why does software timestamping depend on PTP?  
> > 
> > Because it depends on the "PTP" register bank (and the "PTP" interrupt)
> > being described and available. This is why I named the flag 'ptp', but
> > it could be named 'timestamp' or 'ts' as well.
> 
> Right, but software timestamps are done by calling skb_tx_timestamp(skb)
> in the driver, no need for HW support there (software RX timestamp is
> handled by the stack).

I see, I should instead filter the flags based on this so that the s/w
ones still get set.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
