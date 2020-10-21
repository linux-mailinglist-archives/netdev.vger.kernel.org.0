Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5692B29489F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 09:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436985AbgJUHIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 03:08:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:36924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391373AbgJUHIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 03:08:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1ADEBABDE;
        Wed, 21 Oct 2020 07:08:21 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 629B760563; Wed, 21 Oct 2020 09:08:20 +0200 (CEST)
Date:   Wed, 21 Oct 2020 09:08:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
References: <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
 <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 07:39:13AM +0000, Danielle Ratson wrote:
> > -----Original Message-----
> > From: Michal Kubecek <mkubecek@suse.cz>
> > Sent: Monday, October 19, 2020 4:25 PM
> > 
> > As I said, I meant the extension suggested in my mail as independent of what
> > this series is about. For lanes count selector, I find proposed
> > 
> >   ethtool -s <dev> ... lanes <lanes_num> ...
> > 
> > the most natural.
> > 
> > From purely syntactic/semantic point of view, there are three types of
> > requests:
> > 
> >   (1) enable specific set of modes, disable the rest
> >   (2) enable/disable specific modes, leave the rest as they are
> >   (3) enable modes matching a condition (and disable the rest)
> > 
> > What I proposed was to allow the use symbolic names instead of masks
> > (which are getting more and more awful with each new mode) also for (1),
> > like they can already be used for (2).
> > 
> > The lanes selector is an extension of (3) which I would prefer not to mix with
> > (1) or (2) within one command line, i.e. either "advertise" or "speed / duplex
> > / lanes".
> > 
> > IIUC Jakub's and Andrew's comments were not so much about the syntax
> > and semantic (which is quite clear) but rather about the question if the
> > requests like "advertise exactly the modes with (100Gb/s speed and) two
> > lanes" would really address a real life need and wouldn't be more often used
> > as shortcuts for "advertise 100000baseKR2/Full". (On the other hand, I
> > suspect existing speed and duplex selectors are often used the same way.)
> > 
> > Michal
> 
> So, do you want to change the current approach somehow or we are good
> to go with this one, keeping in mind the future extension you have
> suggested? 

As far as I'm concerned, it makes sense as it is. The only thing I'm not
happy about is ETHTOOL_A_LINKMODES_LANES being a "write only" attribute
(unlike _SPEED and _DUPLEX) but being able to query this information
would require extensive changes far beyond the scope of this series.

Michal
