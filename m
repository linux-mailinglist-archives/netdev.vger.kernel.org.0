Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC068279B5E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgIZR23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:28:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIZR23 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:28:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMDzm-00GIHi-Mh; Sat, 26 Sep 2020 19:28:26 +0200
Date:   Sat, 26 Sep 2020 19:28:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 3/4] net: dsa: Add helper for converting
 devlink port to ds and port
Message-ID: <20200926172826.GA3883417@lunn.ch>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-4-andrew@lunn.ch>
 <20200920235203.5r4srjqyjl5lutan@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920235203.5r4srjqyjl5lutan@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 11:52:03PM +0000, Vladimir Oltean wrote:
> On Sat, Sep 19, 2020 at 04:43:31PM +0200, Andrew Lunn wrote:
> > Hide away from DSA drivers how devlink works.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  include/net/dsa.h | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 01da896b2998..a24d5158ee0c 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -685,6 +685,20 @@ static inline struct dsa_switch *dsa_devlink_to_ds(struct devlink *dl)
> >  	return dl_priv->ds;
> >  }
> >  
> > +static inline
> > +struct dsa_switch *dsa_devlink_port_to_ds(struct devlink_port *port)
> > +{
> > +	struct devlink *dl = port->devlink;
> > +	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
> > +
> > +	return dl_priv->ds;
> > +}
> > +
> > +static inline int dsa_devlink_port_to_port(struct devlink_port *port)
> 
> How about dsa_devlink_port_to_index?
> It avoids the repetition and it also indicates more clearly that it
> returns an index rather than a struct dsa_port, without needing to fire
> up ctags.

Hi Vladimir

Just finishing off the next version of these patches, and i looped
back to check i addressed all the comments.

This one i tend to disagree with. If you look at DSA drivers, a port
variable is always an integer index. dp is used to refer to a
dsa_port.

If anything, i would suggest we rename dsa_to_port() to dsa_to_dp(),
and dsa_port_from_netdev to dsa_dp_from_netdev() or maybe
dsa_netdev_to_dp().

    Andrew
