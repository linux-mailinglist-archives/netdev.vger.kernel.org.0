Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BD141CB5C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345500AbhI2R5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343675AbhI2R5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 13:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F91561406;
        Wed, 29 Sep 2021 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632938139;
        bh=Wdm5mZ9EIzamcCpNJ3f6wNkVlDGhsWErQpSRyqfdzvM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ScXxN8A83d1IhIwCquDkP/qeTHZqGJC3TLJ3FOxV2L1FoyPI6FHkUTH5yPMPNyPCU
         qXNzAifxJbHiPiO6nCkLMX7EPPaCyVhggywKQdGI6k8u/r+CShy6MDG1j6rLZglgcu
         igUym4bjnU1v9ZjB1vxlcRgu37WILOCSCsdSB7qn+EfYCWZE2anMLTjBSeGeEFXWkM
         3EFSdkCUq1Todb5f+rX39drvyu8P8oZbA71z5YJJrjTkSrwr8bAk+DD5P0nKyaIpe8
         CZpJTpp26nY4u4AUdYCrZiXjAbecEVDKi6gIbth+hYcnzqvJaDY5F6RZD0/6MUJuBl
         Z889Vw81JzPKg==
Date:   Wed, 29 Sep 2021 10:55:37 -0700
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
Subject: Re: [PATCH net-next v1 0/5] Devlink reload and missed notifications
 fix
Message-ID: <20210929105537.758d5d85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVSG55i75awUpAmn@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
        <20210929064004.3172946e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVR0iKIRYDXQbD+o@unreal>
        <20210929073940.5d7ed022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVSG55i75awUpAmn@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 18:31:51 +0300 Leon Romanovsky wrote:
> On Wed, Sep 29, 2021 at 07:39:40AM -0700, Jakub Kicinski wrote:
> > On Wed, 29 Sep 2021 17:13:28 +0300 Leon Romanovsky wrote:  
> > > We don't need to advertise counters for feature that is not supported.
> > > In multiport mlx5 devices, the reload functionality is not supported, so
> > > this change at least make that device to behave like all other netdev
> > > devices that don't support devlink reload.
> > > 
> > > The ops structure is set very early to make sure that internal devlink
> > > routines will be able access driver back during initialization (btw very
> > > questionable design choice)  
> > 
> > Indeed, is this fixable? Or now that devlink_register() was moved to 
> > the end of probe netdev can call ops before instance is registered?
> >   
> > > and at that stage the driver doesn't know
> > > yet which device type it is going to drive.
> > > 
> > > So the answer is:
> > > 1. Can't have two structures.  
> > 
> > I still don't understand why. To be clear - swapping full op structures
> > is probably acceptable if it's a pure upgrade (existing pointers match).
> > Poking new ops into a structure (in alphabetical order if I understand
> > your reply to Greg, not destructor-before-contructor) is what I deem
> > questionable.  
> 
> It is sorted simply for readability and not for any other technical
> reason.
> 
> Regarding new ops, this is how we are setting callbacks in RDMA based on
> actual device support. It works like a charm.
> 
> > > 2. Same behaviour across all netdev devices.  
> > 
> > Unclear what this is referring to.  
> 
> If your device doesn't support devlink reload, it won't print any
> reload counters at all. It is not the case for the multiport mlx5
> device. It doesn't support, but still present these counters.

There's myriad ways you can hide features.

Swapping ops is heavy handed and prone to data races, I don't like it.
