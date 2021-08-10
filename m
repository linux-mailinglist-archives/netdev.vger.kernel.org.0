Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8591F3E5C0E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbhHJNpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240192AbhHJNpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:45:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AEC561075;
        Tue, 10 Aug 2021 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628603124;
        bh=Glql89CKaEO2bKO5D0IqlIuTd5q4oxJ9Hn2ZSRZr+6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W3pWCgta7DCxFxMKzABYUZSAlENjwlFpfuHFoXXv2Eit9eMl2Z+UCcO5Dc43YQQMt
         WTVNyQ8MROBG3w8rJQO0Vcp2otFrz65A5789N/iQ/b/3s13ylFpmZfF1fcAyaedt3N
         ovC4qeJXiHZ331CjANyr3NzVzEvoZfFX9lJQHWfWjQT7fe/rRrKM6xabrSL4pAwcGO
         WAsrZtoEL2msoqVQ9ZFYcuNKnb/5PkDkqbuYEJEXJF/iG5535KgIcyS7mmOTgv7IMD
         CA0tzZ8OzXMMcuEEsgbziGo3jbol8i+tLifnzLmNjQRUT3CMMibJPFoNQ8K7rON1B/
         /tR/laAwFJygA==
Date:   Tue, 10 Aug 2021 16:45:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
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
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Linu Cherian <lcherian@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Shai Malin <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>, rtoshniwal@marvell.com,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: Re: [PATCH net-next] devlink: Set device as early as possible
Message-ID: <YRKC8NKClMyaQOmt@unreal>
References: <6859503f7e3e6cd706bf01ef06f1cae8c0b0970b.1628449004.git.leonro@nvidia.com>
 <CAJ2QiJLJk73RDS_XwQ0FY0ODq9qXbmiEZ2Y8Fkz9vVheK4he8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ2QiJLJk73RDS_XwQ0FY0ODq9qXbmiEZ2Y8Fkz9vVheK4he8g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 06:08:51PM +0530, Prabhakar Kushwaha wrote:
> Hi Leon,

<...>

> >  struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
> > -                                size_t priv_size, struct net *net)
> > +                                size_t priv_size, struct net *net,
> > +                                struct device *dev)
> >  {
> >         struct devlink *devlink;
> >
> > -       if (WARN_ON(!ops))
> > -               return NULL;
> > -
> > +       WARN_ON(!ops || !dev);
> >         if (!devlink_reload_actions_valid(ops))
> >                 return NULL;
> >
> >         devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
> >         if (!devlink)
> >                 return NULL;
> > +
> > +       devlink->dev = dev;
> >         devlink->ops = ops;
> >         xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
> >         write_pnet(&devlink->_net, net);
> > @@ -8810,12 +8812,9 @@ EXPORT_SYMBOL_GPL(devlink_alloc_ns);
> >   *     devlink_register - Register devlink instance
> >   *
> >   *     @devlink: devlink
> > - *     @dev: parent device
> >   */
> 
> This patch is converting devlink_alloc() to devlink_alloc_register().
> 
> There are 2 APIs: devlink_alloc() and devlink_register().
> Both APIs can be used in a scenario,
>               Where devlink_alloc() can be done by code written around
> one struct dev and used by another struct dev.
> or
> This scenario is not even a valid scenario?

devlink_alloc() is used to allocated netdev structures for newly
initialized device, it is not possible to share same devlink instance
between different devices.

> 
> > -int devlink_register(struct devlink *devlink, struct device *dev)
> > +int devlink_register(struct devlink *devlink)
> >  {
> > -       WARN_ON(devlink->dev);
> > -       devlink->dev = dev;
> >         mutex_lock(&devlink_mutex);
> >         list_add_tail(&devlink->list, &devlink_list);
> >         devlink_notify(devlink, DEVLINK_CMD_NEW);
> 
> Considering device registration has been moved to devlink_alloc().
> Can the remaining code of devlink_register() be also moved in devlink_alloc()?

The line "list_add_tail(&devlink->list, &devlink_list);" makes the
devlink instance visible to the devlink netlink users. We need to be
sure that it is happening when the device is already initialized, while
devlink_alloc() is performed usually as first line in .probe() routine.

This means that we can't combine alloc an register and
devlink_alloc_register() can't be valid scenario.

Thanks

> 
> --pk
