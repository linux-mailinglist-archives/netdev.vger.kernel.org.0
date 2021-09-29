Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186A541C50D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbhI2NAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343889AbhI2NAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A9B661211;
        Wed, 29 Sep 2021 12:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632920312;
        bh=j2Wb33as6mzdBS3YhKeavZz4SfbOKLPsDU6YQXmeqwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SaKUa75ehCfoIF0ddeLIUF8v+AG+MGe8xIP1UF82TZq9Zhr8OiGNBT4OWN1arr0Wo
         HXdbxucj0JELyLM6WgOgi0QnGFaPrKBFAdbLTMcABabCcAmv/BbcSkOpEcZOpw5rbn
         yepoi2ngSz4JdfabJCC1QdWw7qIShD+f5xZIBNdMzO4r6y8wNW24kYxkt7m1J70MbV
         vip1XtOWNXBDrjfMr6hzHPMBExjy7c2Fo4g54lbP3ZxJfPoX0sd+9RIFKXgbKLx4wv
         VxoveKPIqj3dkPR9vyfrom4xKSP64IlJ/+Ykph9Uyd/pOaMDDog2Q0WveAlEflJZ65
         mZVaPXMg79IxA==
Date:   Wed, 29 Sep 2021 15:58:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v1 3/5] devlink: Allow set specific ops
 callbacks dynamically
Message-ID: <YVRi9B4bxR/jZrug@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
 <aac64d4861d6207a90a6d45245ee5ed59114659a.1632916329.git.leonro@nvidia.com>
 <YVRbHMODzcciHa2p@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVRbHMODzcciHa2p@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 02:25:00PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Sep 29, 2021 at 03:00:44PM +0300, Leon Romanovsky wrote:
> > +void devlink_set_ops(struct devlink *devlink, struct devlink_ops *ops)
> > +{
> > +	struct devlink_ops *dev_ops = devlink->ops;
> > +
> > +	WARN_ON(!devlink_reload_actions_valid(ops));
> > +
> > +#define SET_DEVICE_OP(ptr, op, name)                                           \
> > +	do {                                                                   \
> > +		if ((op)->name)                                                \
> > +			if (!((ptr)->name))                                    \
> > +				(ptr)->name = (op)->name;                      \
> > +	} while (0)
> > +
> > +	/* Keep sorted */
> > +	SET_DEVICE_OP(dev_ops, ops, reload_actions);
> > +	SET_DEVICE_OP(dev_ops, ops, reload_down);
> > +	SET_DEVICE_OP(dev_ops, ops, reload_limits);
> > +	SET_DEVICE_OP(dev_ops, ops, reload_up);
> 
> Keep sorted in what order?  And why?

Sorted by name.

It simplifies future addition of new commands and removes useless fraction
where place new line.

Thanks

> 
> thanks,
> 
> greg k-h
