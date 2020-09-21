Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE2271953
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 04:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIUCcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 22:32:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgIUCcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 22:32:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKBcW-00FX60-HI; Mon, 21 Sep 2020 04:32:00 +0200
Date:   Mon, 21 Sep 2020 04:32:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 2/4] net: dsa: Add devlink port regions
 support to DSA
Message-ID: <20200921023200.GA3702050@lunn.ch>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-3-andrew@lunn.ch>
 <20200920232328.o4gcq23olg75ia6n@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920232328.o4gcq23olg75ia6n@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 11:23:29PM +0000, Vladimir Oltean wrote:
> On Sat, Sep 19, 2020 at 04:43:30PM +0200, Andrew Lunn wrote:
> > Allow DSA drivers to make use of devlink port regions, via simple
> > wrappers.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  include/net/dsa.h  |  5 +++++
> >  net/core/devlink.c |  3 +--
> >  net/dsa/dsa.c      | 14 ++++++++++++++
> >  3 files changed, 20 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index d16057c5987a..01da896b2998 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -665,6 +665,11 @@ struct devlink_region *
> >  dsa_devlink_region_create(struct dsa_switch *ds,
> >  			  const struct devlink_region_ops *ops,
> >  			  u32 region_max_snapshots, u64 region_size);
> > +struct devlink_region *
> > +dsa_devlink_port_region_create(struct dsa_switch *ds,
> > +			       int port,
> > +			       const struct devlink_port_region_ops *ops,
> > +			       u32 region_max_snapshots, u64 region_size);
> >  void dsa_devlink_region_destroy(struct devlink_region *region);
> >  
> >  struct dsa_port *dsa_port_from_netdev(struct net_device *netdev);
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 66469cdcdc1e..4701ec17f3da 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -4292,7 +4292,6 @@ static int devlink_nl_cmd_region_get_port_dumpit(struct sk_buff *msg,
> >  	}
> >  
> >  out:
> > -	mutex_unlock(&devlink_mutex);
> 
> This diff is probably not intended?

Correct. Looks like i squashed a mutex fix into the wrong patch :-(

	 Andrew
