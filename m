Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1024F4127BB
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbhITVHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232859AbhITVFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB76B61159;
        Mon, 20 Sep 2021 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632171850;
        bh=PqdFM5XpCW4SO8VwVFeVL8/W3ovMxPa8/cSLHK/1cCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l4hTPB4s2MuadFq2p5e6Xplm6rWChHn0TAe148keYBM4PyhsT4Z0dnrIVf4x/yUrW
         TvJNAHPIAWaiTrxwhZP6PjK5F01TpWMMxEJxSL5YmcFiv4SSbVUbrrQeuDWiUNgj6w
         dOitjMtSyPq5FUu0W9nnZU/e1BI2V6ZFfsIn0zAowC7cN5qZaRb9YgUmUZHBtokOKA
         Sg0JzWzyV4CyUUiAVLRJR5PotXNmfupXMRQum0qomXQ8OQvbh/E3LGEGB3qd6Zqwbt
         sXDu5phtaLCaLXsfYXXjpW92B+QfVofmgWfVAGj9rugEoExMyHyr4E3uskHK2JwC8c
         VEhwLWOugkKRQ==
Date:   Mon, 20 Sep 2021 14:04:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
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
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
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
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next] devlink: Make devlink_register to be void
Message-ID: <20210920140407.0732b3d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210920133915.59ddfeef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <2e089a45e03db31bf451d768fc588c02a2f781e8.1632148852.git.leonro@nvidia.com>
        <20210920133915.59ddfeef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 13:39:15 -0700 Jakub Kicinski wrote:
> On Mon, 20 Sep 2021 17:41:44 +0300 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > devlink_register() can't fail and always returns success, but all drivers
> > are obligated to check returned status anyway. This adds a lot of boilerplate
> > code to handle impossible flow.
> > 
> > Make devlink_register() void and simplify the drivers that use that
> > API call.  
> 
> Unlike unused functions bringing back error handling may be
> non-trivial. I'd rather you deferred such cleanups until you're 
> ready to post your full rework and therefore give us some confidence 
> the revert will not be needed.

If you disagree you gotta repost, new devlink_register call got added
in the meantime.
