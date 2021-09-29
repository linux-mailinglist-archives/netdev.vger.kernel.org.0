Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7CC41C69C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344396AbhI2O2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344142AbhI2O2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 10:28:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E40860ED4;
        Wed, 29 Sep 2021 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632925594;
        bh=QZUqLW+rrVYjG2fzvS4fRKLH6cZniCvIXXWbYdcka0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mb78hnsNs4SNcPw8fEhqyXKvPGc3zCK/a99lx3QDAbg5UyOq/Rlf/LLhrDXhJVFRk
         Jz2Co8cuiZ4aHX6s2P3mCTRNDgvjoDeHnnk/Jh99AlKHYkMhnzpGCJ3plvD7/cJkJx
         uN0E1hagBwcQEKjG5TeHyQHmOxOudPFOFCYPq1NXI5mit2JZXve2AWDI5JgpdvU09A
         ffGQCg1Kkp8c0txxGH2UXOHctPqSnJsAMKTvYviu1uQbU1MryEaFsLG7RPT7JL0wYg
         wE0MHR5mFXxfeeuOyN3ZxskdmVgwuVI2JE21E3NhYRnkBK3RHggdakhx8Xh+AAIBHa
         qxHr8dOPnKtAg==
Date:   Wed, 29 Sep 2021 07:26:31 -0700
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
Message-ID: <20210929072631.437ffad9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVR1PKQjsBfvUTPU@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
        <a8bf9a036fe0a590df830a77a31cc81c355f525d.1632916329.git.leonro@nvidia.com>
        <20210929065549.43b13203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVR1PKQjsBfvUTPU@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 17:16:28 +0300 Leon Romanovsky wrote:
> > > @@ -808,6 +812,9 @@ int mlx5_devlink_register(struct devlink *devlink)
> > >  	if (err)
> > >  		goto traps_reg_err;
> > > =20
> > > +	if (!mlx5_core_is_mp_slave(dev))
> > > +		devlink_set_ops(devlink, &mlx5_devlink_reload); =20
> >=20
> > Does this work? Where do you make a copy of the ops? =F0=9F=A4=94 You c=
an't modify
> > the driver-global ops, to state the obvious. =20
>=20
> devlink_ops pointer is not constant at this stage, so why can't I copy
> reload_* pointers to the "main" devlink ops?
>=20
> I wanted to avoid to copy all pointers.

Hm. I must be missing a key piece here. IIUC you want to have different
ops based on some device property. But there is only one

static struct devlink_ops mlx5_devlink_ops;

so how can two devlink instances in the system use that and have
different ops without a copy?
