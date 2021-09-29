Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE03341C6B5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344474AbhI2Oct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245632AbhI2Oct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 10:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 125FC610CC;
        Wed, 29 Sep 2021 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632925867;
        bh=5J9i/PjQ6jdxK2kOImSO+oQGMSYmdpfWzCpwuVBY2d0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vB3ka2ZOtDpsOdBe8FXBPJmSoNh8GSWrL0prJW6U3i/f7lX+X3AoVF5PHb8HZeOUK
         GoD/Qzf9Z3yZQKIaT6lcRYeT3sIxm/S+c9PP4S75v/Z3s55+mQGFuqTdMeKLDrmfKM
         +DRF2ViEmEPJquHp5DZYk8BhsDfoXlmMDdvOuo6KFrgnMWqq8O2LcPqpBHwf+/nzi2
         rHDahLDcWWa0Tne7Z4jjLPHNC9Ad9UeEvHrboot81a0p4i4wzJVOXuZ12uZApMX1Ua
         zh+sR1ZnumyxcwjxXLndgN5mtewH3aref/5V7dtV7d9nIJDAmMdjXp9DwGhEE0coPQ
         eTzrFGTNxPsxg==
Date:   Wed, 29 Sep 2021 17:31:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH net-next v1 4/5] net/mlx5: Register separate reload
 devlink ops for multiport device
Message-ID: <YVR4qDxiQw95jaWK@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
 <a8bf9a036fe0a590df830a77a31cc81c355f525d.1632916329.git.leonro@nvidia.com>
 <20210929065549.43b13203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVR1PKQjsBfvUTPU@unreal>
 <20210929072631.437ffad9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929072631.437ffad9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 07:26:31AM -0700, Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 17:16:28 +0300 Leon Romanovsky wrote:
> > > > @@ -808,6 +812,9 @@ int mlx5_devlink_register(struct devlink *devlink)
> > > >  	if (err)
> > > >  		goto traps_reg_err;
> > > >  
> > > > +	if (!mlx5_core_is_mp_slave(dev))
> > > > +		devlink_set_ops(devlink, &mlx5_devlink_reload);  
> > > 
> > > Does this work? Where do you make a copy of the ops? 🤔 You can't modify
> > > the driver-global ops, to state the obvious.  
> > 
> > devlink_ops pointer is not constant at this stage, so why can't I copy
> > reload_* pointers to the "main" devlink ops?
> > 
> > I wanted to avoid to copy all pointers.
> 
> Hm. I must be missing a key piece here. IIUC you want to have different
> ops based on some device property. But there is only one
> 
> static struct devlink_ops mlx5_devlink_ops;
> 
> so how can two devlink instances in the system use that and have
> different ops without a copy?

No, I have two:
* Base ops - mlx5_devlink_ops
* Extra reload commands - mlx5_devlink_reload

Thanks
