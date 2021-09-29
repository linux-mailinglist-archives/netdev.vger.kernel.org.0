Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511B441C5DA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344251AbhI2Nlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344186AbhI2Nls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 632EC6137A;
        Wed, 29 Sep 2021 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632922807;
        bh=HRxvn3IUjfecEGEfskFUy3y0BDqwSgrQjWLQzEOJJgw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RTPVEKKDWu8xLuOVgrWyDppGS6t0eE5njBJgD1i3idYi2+uHPuZa5cxEcjeFQ3cZe
         6NABzyvWfwl476XJU0PdI98Izs20RoC9vvAoAveJEZuCn+cAfihiwiMabw0KRLU2e+
         TjWVzaCDWGdqoHQJP8rzeE3N3fWPyiTmO527AagTY9mO2loOHnXdQV7WiMI4gLE6vU
         ul6sdJZ8l6+2P15LTHORFb07eoWaQztgWFnh43dsVGZ4Hd/JzdNsuR4airw1rBFwB3
         v8FM8IQp926Dnl24p7J95hZj1aT8hWczKBdj0YqITOJZkMf+W5a/5yeHOFVImIQmNU
         0lw8wtPminwVw==
Date:   Wed, 29 Sep 2021 06:40:04 -0700
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
Message-ID: <20210929064004.3172946e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1632916329.git.leonro@nvidia.com>
References: <cover.1632916329.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 15:00:41 +0300 Leon Romanovsky wrote:
> This series starts from the fixing the bug introduced by implementing
> devlink delayed notifications logic, where I missed some of the
> notifications functions.
> 
> The rest series provides a way to dynamically set devlink ops that is
> needed for mlx5 multiport device and starts cleanup by removing
> not-needed logic.
> 
> In the next series, we will delete various publish API, drop general
> lock, annotate the code and rework logic around devlink->lock.
> 
> All this is possible because driver initialization is separated from the
> user input now.

Swapping ops is a nasty hack in my book.

And all that to avoid having two op structures in one driver.
Or to avoid having counters which are always 0?

Sorry, at the very least you need better explanation for this.
