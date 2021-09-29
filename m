Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9845341C675
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343767AbhI2OPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245475AbhI2OPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 10:15:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A87613A5;
        Wed, 29 Sep 2021 14:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632924812;
        bh=eTAv1pPSQ34h7VzKpHo4amccmSX8My0viltKfGFPAcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a0WROnPxlwaBTjZsiibH7NJovqQtTcIp/K8ms+STDcB0ptV8A0iGu7jLOLUA/zrUB
         INOdkTNqEr+HXCsQa1FZU+yqpPcoGYOARxzTUh4ePsGKUBDxazH19ImM81Ssee+Mva
         nxmG8NM2AaOVNzG/J2UsGMAVksZFTUppR7ziA8M1mXemH97Vk+d8qoG0kYGWYdGish
         B9Qy4lryafOY6AelPhxlIm1cVnoVDb/CTbTE2vOsJMA/xb1kJPJdpk1+5jbmmd2KC3
         vu3OyQvXaUDO9c51VtuIqQLJ54Y/7pkwRb/Ky5I0hyfeuWwgf9qtylbgp9JyDEXnTB
         kSVVs8i8WEI2Q==
Date:   Wed, 29 Sep 2021 17:13:28 +0300
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
Subject: Re: [PATCH net-next v1 0/5] Devlink reload and missed notifications
 fix
Message-ID: <YVR0iKIRYDXQbD+o@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
 <20210929064004.3172946e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929064004.3172946e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 06:40:04AM -0700, Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 15:00:41 +0300 Leon Romanovsky wrote:
> > This series starts from the fixing the bug introduced by implementing
> > devlink delayed notifications logic, where I missed some of the
> > notifications functions.
> > 
> > The rest series provides a way to dynamically set devlink ops that is
> > needed for mlx5 multiport device and starts cleanup by removing
> > not-needed logic.
> > 
> > In the next series, we will delete various publish API, drop general
> > lock, annotate the code and rework logic around devlink->lock.
> > 
> > All this is possible because driver initialization is separated from the
> > user input now.
> 
> Swapping ops is a nasty hack in my book.
> 
> And all that to avoid having two op structures in one driver.
> Or to avoid having counters which are always 0?

We don't need to advertise counters for feature that is not supported.
In multiport mlx5 devices, the reload functionality is not supported, so
this change at least make that device to behave like all other netdev
devices that don't support devlink reload.

The ops structure is set very early to make sure that internal devlink
routines will be able access driver back during initialization (btw very
questionable design choice), and at that stage the driver doesn't know
yet which device type it is going to drive.

So the answer is:
1. Can't have two structures.
2. Same behaviour across all netdev devices.

> 
> Sorry, at the very least you need better explanation for this.

Was it better explained now?
