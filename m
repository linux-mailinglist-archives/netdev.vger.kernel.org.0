Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866424193A8
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhI0LzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234015AbhI0LzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 07:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA30360F6C;
        Mon, 27 Sep 2021 11:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632743608;
        bh=Q2dHeySo3zRsXGknIbLs6i+yTpWx2dDgGoEFYPDr5/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YaUXTiQmxWntMdcP1V6UabAj5J8Y25L1/E0AYpGsph11k51k6VvuI8uPokBfxbcAk
         m2uUNUxT0DP/R0xJf6IGUC8maz/OqFGDLCwx0qK2IoUljTtiFro1XMJp+GmLED5ssx
         T1ku5NlihRu34GIj81fPeIw7ebnIWBENHWl+gsXCpbVoVK2JoPlPV9W9/7Ky2991FF
         arzkdMMFq4EaH/2DLzzcuKPhUe4TrV024+K0jMiavouR22LFvA7VwYQ1mEsRJO8slE
         0+cd42Ha63JskwWD96PNT2Osmj6PMhlOW5OdUO22AYB3Y6mybJGQC1TChNKODmw7Ew
         1Cj5jreVMvoQQ==
Date:   Mon, 27 Sep 2021 14:53:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
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
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v1 13/21] nfp: Move delink_register to be last
 command
Message-ID: <YVGwtNEcWSgYvyyV@unreal>
References: <cover.1632565508.git.leonro@nvidia.com>
 <f393212ad3906808ee7eb5cff06ef2e053eb9d2b.1632565508.git.leonro@nvidia.com>
 <20210927083923.GC17484@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927083923.GC17484@corigine.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 10:39:24AM +0200, Simon Horman wrote:
> On Sat, Sep 25, 2021 at 02:22:53PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Open user space access to the devlink after driver is probed.
> 
> Hi Leon,
> 
> I think a description of why is warranted here.

After devlink_register(), users can send GET and SET netlink commands to
the uninitialized driver. In some cases, nothing will happen, but not in
all and hard to prove that ALL drivers are safe with such early access.

It means that local users can (in theory for some and in practice for
others) crash the system (or leverage permissions) with early devlink_register()
by accessing internal to driver pointers that are not set yet.

Like I said in the commit message, I'm not fixing all drivers.
https://lore.kernel.org/netdev/cover.1632565508.git.leonro@nvidia.com/T/#m063eb4e67389bafcc3b3ddc07197bf43181b7209

Because some of the driver authors made a wonderful job to obfuscate their
driver and write completely unmanageable code.

I do move devlink_register() to be last devlink command for all drivers,
to allow me to clean devlink core locking and API in next series.

This series should raise your eyebrow and trigger a question: "is my
driver vulnerable too?". And the answer will depend on devlink_register()
position in the .probe() call.

Thanks

> 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
