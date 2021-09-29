Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8FC41C6C9
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344505AbhI2Ohf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344420AbhI2Ohe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 10:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB27613CE;
        Wed, 29 Sep 2021 14:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632926153;
        bh=c2z5RikRkWc79lNu5V12ksP4gbK0MSOCGyzavGzUgOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CB+pgkC8GS0awLozfiCqGuWzrfQ4/5Ly6BzLnykAmBTxGsFusXpzzR20GjxhGi7sx
         X0mEfe/YNQpUwtPq4/WeSaWZIJr1mtxs5C8HSHbMmtH6D6rL5R+24DLfFCZxR9+kiV
         5kL/80cyjQeN1U+2tNrgb12+CkD9O2ZKaMtEw90mN6eXroR3Aj99dQwPqhO7KjHKKm
         m8jOeYzlX63uBTd1Gh1M7SYpbqrdBt1FTMOZmBPlP1qFR38NOqg/xOIiJ9jOFHOvSt
         JV6WkTMUJFlHPg8pz0c2Ih12wfe0VHYO/sNp/q70yp/ySorb0gGC8cPU869lXmoDu6
         OFRv+Ndrj3Z/Q==
Date:   Wed, 29 Sep 2021 07:35:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20210929073551.16dd2267@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVR4qDxiQw95jaWK@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
        <a8bf9a036fe0a590df830a77a31cc81c355f525d.1632916329.git.leonro@nvidia.com>
        <20210929065549.43b13203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVR1PKQjsBfvUTPU@unreal>
        <20210929072631.437ffad9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVR4qDxiQw95jaWK@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 17:31:04 +0300 Leon Romanovsky wrote:
> On Wed, Sep 29, 2021 at 07:26:31AM -0700, Jakub Kicinski wrote:
> > On Wed, 29 Sep 2021 17:16:28 +0300 Leon Romanovsky wrote:  
> > > devlink_ops pointer is not constant at this stage, so why can't I copy
> > > reload_* pointers to the "main" devlink ops?
> > > 
> > > I wanted to avoid to copy all pointers.  
> > 
> > Hm. I must be missing a key piece here. IIUC you want to have different
> > ops based on some device property. But there is only one
> > 
> > static struct devlink_ops mlx5_devlink_ops;
> > 
> > so how can two devlink instances in the system use that and have
> > different ops without a copy?  
> 
> No, I have two:
> * Base ops - mlx5_devlink_ops
> * Extra reload commands - mlx5_devlink_reload

Still those are global for the driver, no?

What if you have multiple NICs or whatever.
