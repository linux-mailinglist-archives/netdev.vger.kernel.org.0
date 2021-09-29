Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2440D41C849
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345181AbhI2P0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344945AbhI2P03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:26:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 604FF61440;
        Wed, 29 Sep 2021 15:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632929088;
        bh=xBRRX1rYjiTzPEoPMHw1rL24TvrnK+689UnwZagbnsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aP/SzhecYqJ59hW7NpP/05VpI6etnlUtWV51qr4Sjrsj7iIglusLMXx2XNaO0fT0M
         RyFp76HRYmy1cib0bH0hsp/eVZnogcmCelT/ZwaymqsJegIyZJRgdg5tNKJsghh0RX
         h735xxlR9XptIYNPpeHPeVEIWeiC9Q4ek0t3XMoih4QzIJ1mz04rG59BZZLxMrAzht
         MHpF9eFzGaB22t5a325IB+YbBszRNGWukMKfRmsCWK+zMzKR3DD/rQmxK4ETBnoB+G
         hvBLRT6RtSXZYMSVRvFbB12XrLiTkxZUMC0ZQ7vldriFuDLP8cPBDmDxWn6bw8TPTP
         TWgYqiOk6HtYQ==
Date:   Wed, 29 Sep 2021 18:24:44 +0300
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
Message-ID: <YVSFPNq+IDUlZAeI@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
 <a8bf9a036fe0a590df830a77a31cc81c355f525d.1632916329.git.leonro@nvidia.com>
 <20210929065549.43b13203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVR1PKQjsBfvUTPU@unreal>
 <20210929072631.437ffad9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVR4qDxiQw95jaWK@unreal>
 <20210929073551.16dd2267@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929073551.16dd2267@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 07:35:51AM -0700, Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 17:31:04 +0300 Leon Romanovsky wrote:
> > On Wed, Sep 29, 2021 at 07:26:31AM -0700, Jakub Kicinski wrote:
> > > On Wed, 29 Sep 2021 17:16:28 +0300 Leon Romanovsky wrote:  
> > > > devlink_ops pointer is not constant at this stage, so why can't I copy
> > > > reload_* pointers to the "main" devlink ops?
> > > > 
> > > > I wanted to avoid to copy all pointers.  
> > > 
> > > Hm. I must be missing a key piece here. IIUC you want to have different
> > > ops based on some device property. But there is only one
> > > 
> > > static struct devlink_ops mlx5_devlink_ops;
> > > 
> > > so how can two devlink instances in the system use that and have
> > > different ops without a copy?  
> > 
> > No, I have two:
> > * Base ops - mlx5_devlink_ops
> > * Extra reload commands - mlx5_devlink_reload
> 
> Still those are global for the driver, no?

Ugh, yes

> 
> What if you have multiple NICs or whatever.

I missed it and always tested with one device L(.

I'll add copy-all-ops code.

Thanks
