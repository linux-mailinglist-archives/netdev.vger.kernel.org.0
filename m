Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D761841C87C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345326AbhI2Pdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345178AbhI2Pdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:33:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87BE661159;
        Wed, 29 Sep 2021 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632929515;
        bh=HXwoS1HjJA1S0yfWFpWczWoEmqeqJ8/hI4qGlsQfiLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a8sMw03Rp6PGGokI/cGFo4lnq8A92MECDtnNRH0qAYiC9K1Vj5DaLvJfztY1rEwx2
         J3FjihL9ii52e8Zfc1LoVAXfQPLIFtkcWyusSyw6hrLPxYhHTnB49JgfL17mN5pY50
         8YPYUUzVPu6Gkd6TA90y1EU7fcrWlEMBwJGhL7hOX7n7IYjBvJbjvmnzc7myNa6TOJ
         xOL0M+HYncEtqnaVZr7i4ot3tZbMpp7lbMxXHKZaRL6OYsWT1I2t1Q0jXuKcshj3+i
         EhRojJsY7u7SHu6Llx2j3/ql9Ac0a4DTztxk62AfY9CPj7ePahwroyGlhgI7Xfabug
         yDOSXw/s46Y1Q==
Date:   Wed, 29 Sep 2021 18:31:51 +0300
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
Message-ID: <YVSG55i75awUpAmn@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
 <20210929064004.3172946e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVR0iKIRYDXQbD+o@unreal>
 <20210929073940.5d7ed022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929073940.5d7ed022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 07:39:40AM -0700, Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 17:13:28 +0300 Leon Romanovsky wrote:
> > On Wed, Sep 29, 2021 at 06:40:04AM -0700, Jakub Kicinski wrote:
> > > On Wed, 29 Sep 2021 15:00:41 +0300 Leon Romanovsky wrote:  
> > > > This series starts from the fixing the bug introduced by implementing
> > > > devlink delayed notifications logic, where I missed some of the
> > > > notifications functions.
> > > > 
> > > > The rest series provides a way to dynamically set devlink ops that is
> > > > needed for mlx5 multiport device and starts cleanup by removing
> > > > not-needed logic.
> > > > 
> > > > In the next series, we will delete various publish API, drop general
> > > > lock, annotate the code and rework logic around devlink->lock.
> > > > 
> > > > All this is possible because driver initialization is separated from the
> > > > user input now.  
> > > 
> > > Swapping ops is a nasty hack in my book.
> > > 
> > > And all that to avoid having two op structures in one driver.
> > > Or to avoid having counters which are always 0?  
> > 
> > We don't need to advertise counters for feature that is not supported.
> > In multiport mlx5 devices, the reload functionality is not supported, so
> > this change at least make that device to behave like all other netdev
> > devices that don't support devlink reload.
> > 
> > The ops structure is set very early to make sure that internal devlink
> > routines will be able access driver back during initialization (btw very
> > questionable design choice)
> 
> Indeed, is this fixable? Or now that devlink_register() was moved to 
> the end of probe netdev can call ops before instance is registered?
> 
> > and at that stage the driver doesn't know
> > yet which device type it is going to drive.
> > 
> > So the answer is:
> > 1. Can't have two structures.
> 
> I still don't understand why. To be clear - swapping full op structures
> is probably acceptable if it's a pure upgrade (existing pointers match).
> Poking new ops into a structure (in alphabetical order if I understand
> your reply to Greg, not destructor-before-contructor) is what I deem
> questionable.

It is sorted simply for readability and not for any other technical
reason.

Regarding new ops, this is how we are setting callbacks in RDMA based on
actual device support. It works like a charm.

> 
> > 2. Same behaviour across all netdev devices.
> 
> Unclear what this is referring to.

If your device doesn't support devlink reload, it won't print any
reload counters at all. It is not the case for the multiport mlx5
device. It doesn't support, but still present these counters.

Thanks
