Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F4C264F3B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgIJTif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:38:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731340AbgIJPnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:43:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGOCs-00E5K3-Uw; Thu, 10 Sep 2020 17:09:50 +0200
Date:   Thu, 10 Sep 2020 17:09:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net-next 2/9] net: devlink: region: Pass the region
 ops to the snapshot function
Message-ID: <20200910150950.GC3354160@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-3-andrew@lunn.ch>
 <20200910073816.5b089bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910073816.5b089bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 07:38:16AM -0700, Jakub Kicinski wrote:
> On Thu, 10 Sep 2020 01:58:20 +0200 Andrew Lunn wrote:
> > diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> > index 111d6bfe4222..eb189d2070ae 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> > @@ -413,6 +413,7 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
> >   * error code on failure.
> >   */
> >  static int ice_devlink_nvm_snapshot(struct devlink *devlink,
> > +				    const struct devlink_region_ops *ops,
> >  				    struct netlink_ext_ack *extack, u8 **data)
> >  {
> >  	struct ice_pf *pf = devlink_priv(devlink);
> > @@ -468,6 +469,7 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
> >   */
> >  static int
> >  ice_devlink_devcaps_snapshot(struct devlink *devlink,
> > +			     const struct devlink_region_ops *ops,
> >  			     struct netlink_ext_ack *extack, u8 **data)
> >  {
> >  	struct ice_pf *pf = devlink_priv(devlink);
> 
> 
> drivers/net/ethernet/intel/ice/ice_devlink.c:418: warning: Function parameter or member 'ops' not described in 'ice_devlink_nvm_snapshot'
> drivers/net/ethernet/intel/ice/ice_devlink.c:474: warning: Function parameter or member 'ops' not described in 'ice_devlink_devcaps_snapshot'

Thanks Jakub

I did try a W=1 build, but there are so many warnings it is hard to
pick out the new ones. I assume you have some sort of automation for
this? Could you share it?

How far are we from just enabling W=1 by default under drivers/net ?
What is the best way to do this in the Makefiles? I think
drivers/net/phy is now W=1 clean, or very close. So it would be nice
to enable that checking by default.

Thanks
	Andrew
