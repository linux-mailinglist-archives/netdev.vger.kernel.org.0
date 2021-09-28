Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E45641A9D3
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbhI1HgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239446AbhI1HgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 03:36:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55B3260F46;
        Tue, 28 Sep 2021 07:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632814477;
        bh=FXJERLSoyhfMGBS0Hs/ca2OK7+EwhV8+7CAGiyuQIzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZSwnW/QW1ziVb2vzzIm0dinkQLg5zL3yk9PfEAZFaIEmOg226d2BPPpWXSaqORNNS
         5iMkLIFVYp91weFGz7NIiFMOmKgcnFxffLtJl11liVApDjMrdqMRVvT9QqoFkU3lTp
         d2wQVS/d/smxOIfP91V8Cn+NbJqxwFcY5x0irbvzigSS00/fCBmml+RjRVo7wS6c82
         5PBebINtZ63yzWPnrGihAiLXryw97K9WlZ4sBH+zxu0QHwXFC7OyOyvdYwYHPfwKuO
         vnJ2hsRiQIyufQ9c3HgNrKhM1G3rz8XHjfusYz69BxP/1Cr+muDTkBkK3yofoFZZu/
         zmgkPZnJOrU7A==
Date:   Tue, 28 Sep 2021 10:34:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v1 01/21] devlink: Notify users when objects are
 accessible
Message-ID: <YVLFiUQp03qzBMO5@unreal>
References: <cover.1632565508.git.leonro@nvidia.com>
 <0f7f201a059b24c96eac837e1f424e2483254e1c.1632565508.git.leonro@nvidia.com>
 <97c1ba9d-52b9-5689-19ab-ad4a82e55ae2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97c1ba9d-52b9-5689-19ab-ad4a82e55ae2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 07:49:18PM -0700, Eric Dumazet wrote:
> 
> 
> On 9/25/21 4:22 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The devlink core code notified users about add/remove objects without
> > relation if this object can be accessible or not. In this patch we unify
> > such user visible notifications in one place.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  net/core/devlink.c | 107 +++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 93 insertions(+), 14 deletions(-)

<...>

> >  static void devlink_rate_notify(struct devlink_rate *devlink_rate,
> >  				enum devlink_command cmd)
> >  {
> > +	struct devlink *devlink = devlink_rate->devlink;
> >  	struct sk_buff *msg;
> >  	int err;
> >  
> >  	WARN_ON(cmd != DEVLINK_CMD_RATE_NEW && cmd != DEVLINK_CMD_RATE_DEL);
> > +	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
> 
> 
> FYI, this new warning was triggered by syzbot :

Thanks for the report, it is combination of my rebase error and missing
loop of devlink_rate_notify in the devlink_notify_register() function.

I'll fix and resubmit.

Thanks
