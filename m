Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1182C5D6D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403778AbgKZVHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:07:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:41346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732947AbgKZVHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 16:07:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3858FACA8;
        Thu, 26 Nov 2020 21:07:49 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 914A560786; Thu, 26 Nov 2020 22:07:48 +0100 (CET)
Date:   Thu, 26 Nov 2020 22:07:48 +0100
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
Message-ID: <20201126210748.mzbe7ei3wjhvryym@lion.mk-sys.cz>
References: <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
 <DM6PR12MB38651062E363459E66140B23D81C0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021084733.sb4rpzwyzxgczvrg@lion.mk-sys.cz>
 <DM6PR12MB3865D0B8F8F1BD32532D1DDFD81D0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201022162740.nisrhdzc4keuosgw@lion.mk-sys.cz>
 <DM6PR12MB45163DF0113510194127C0ABD8FC0@DM6PR12MB4516.namprd12.prod.outlook.com>
 <20201124221225.6ae444gcl7npoazh@lion.mk-sys.cz>
 <DM6PR12MB4516B65021D4107188447282D8FA0@DM6PR12MB4516.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB4516B65021D4107188447282D8FA0@DM6PR12MB4516.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 10:35:35AM +0000, Danielle Ratson wrote:
> > > What do you think of passing the link modes you have suggested as a
> > > bitmask, similar to "supported", that contains only one positive bit?
> > > Something like that:
> 
> Hi Michal,
> 
> Thanks for your response.
> 
> Actually what I said is not very accurate. 
> In ethtool, for speed 100G and 4 lanes for example, there are few link modes that fits:
> ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT
> ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT
> ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT
> ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT
> 
> The difference is the media. And in the driver we shrink into one bit.
> But maybe that makes passing a bitmask more sense, or am I missing something?

But as far as I understand, at any moment, only one of these will be
actually in use so that's what the driver should report. Or is the
problem that the driver cannot identify the media in use? (To be
precise: by "cannot identify" I mean "it's not possible for the driver
to find out", not "current code does not distinguish".)

Michal
