Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7F62C313F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgKXTqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:46:46 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11520 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgKXToT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 14:44:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbd62960004>; Tue, 24 Nov 2020 11:44:22 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 19:44:16 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 24 Nov 2020 19:44:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwVS3X2UaIJpYblDfxQPIqc/tQaGdTaSvJJsVd/imn75AjiRyOkQyrbHMAVDj892Ky4dHsGi/rSh72ZtvdlWTphgYHrujW2ctpBnfdhYB1bi+KlS6Zh5c+nopJAKofsvxYqHTm9SE4YhoMCxqqED1NHdoOaihJcTeVYfLQcZwJtruTfGN82qs+HrJhP5E2RyP8tzpkSPPaJBFMgPD4D2KZUTl1CPsEtQEtALvJhBceqFbBhK+Pc0EKrd3sCdP0hOzhYl400Bo4gRZhjMxfHV7aJjGZrbcYTatKPQOYSyWOt4uqjO/R2GHnqpHzTGj5EXsi8wnyKwufzG8x6uyOYkRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdUkppd5o8S9TP9RMwZEGKCoIhFSHDuwGg+bFwprZ/w=;
 b=D6gLIhyCBSxNJ+eEOLLaGYxk/YXAG5jqFoj29ZhDS7cmA4K5roJ+oOusKEQs+pcrLA4doBUkweMgASvZexzheFuiHhs49lj6aZAHACMxjscKJsdfXUoBzLZkuD+A6lCPFtunS3UDZtysh4Uv4I8OSQJyY53IfuZJ5d+KOuP27KcJ19AkOw9Ok4CpbtjouZCfolbgxCK9zp4ewxW/d34iYCoIOEJ658YxGjq4YAL+ijkaTSpkEVD+zfLlSD4ys2zr4XjTcucUygZx5wqSX4/rilmQzjDdFy6mH1sIj7SsbimdOkRvea53Zsm9EsKf4IUvFxWXufOEAcTWcI28EYNa6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2489.namprd12.prod.outlook.com (2603:10b6:3:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Tue, 24 Nov
 2020 19:44:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3589.022; Tue, 24 Nov 2020
 19:44:14 +0000
Date:   Tue, 24 Nov 2020 15:44:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201124194413.GF4800@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
 <20201120230339.651609-12-saeedm@nvidia.com>
 <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
 <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124180210.GJ5487@ziepe.ca>
 <20201124104106.0b1201b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201124104106.0b1201b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MN2PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:208:234::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR16CA0044.namprd16.prod.outlook.com (2603:10b6:208:234::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 24 Nov 2020 19:44:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kheEX-000utR-5n; Tue, 24 Nov 2020 15:44:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606247062; bh=EhSGM/Cq+5T6xoxe0HDrr1Oje1f5aQx0c8IgLrPl/rA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=WWzYEZwBprybK23VILDs4YL+gyJ+LqsPWowIjPfBYVpTnpGMPsMIPvRxhd1hiGUs0
         6t8bEehafExmvZVkhnPjJxUhPp1lqa+vVhzd/rRqoGhY6lNcdT7AQqyfmX8jBxfdEt
         5dtibU/JpVs7oRVlMEVrH5Ur7L7XH0rNteDBwn93pvVSoabG1sbrxjS0Wlh4tlu12w
         G1PSVk03LBnUpmS+EYfdfOFoEl6q0ksNcv6LS8xs4Rf5akSSBBu1r2Lc6TEIDHSSxr
         R2zzXCJqvl0hkJD5LxynnBR0wnlWbyWCQyRRuYdrnWBe/cdEZcBekWQCg19kEQSpZd
         cyLHcVB96d7zA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 10:41:06AM -0800, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 14:02:10 -0400 Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2020 at 09:12:19AM -0800, Jakub Kicinski wrote:
> > > On Sun, 22 Nov 2020 08:41:58 +0200 Eli Cohen wrote: =20
> > > > On Sat, Nov 21, 2020 at 04:01:55PM -0800, Jakub Kicinski wrote: =20
> > > > > On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed wrote:   =20
> > > > > > From: Eli Cohen <eli@mellanox.com>
> > > > > >=20
> > > > > > Add a new namespace type to the NIC RX root namespace to allow =
for
> > > > > > inserting VDPA rules before regular NIC but after bypass, thus =
allowing
> > > > > > DPDK to have precedence in packet processing.   =20
> > > > >=20
> > > > > How does DPDK and VDPA relate in this context?   =20
> > > >=20
> > > > mlx5 steering is hierarchical and defines precedence amongst namesp=
aces.
> > > > Up till now, the VDPA implementation would insert a rule into the
> > > > MLX5_FLOW_NAMESPACE_BYPASS hierarchy which is used by DPDK thus tak=
ing
> > > > all the incoming traffic.
> > > >=20
> > > > The MLX5_FLOW_NAMESPACE_VDPA hirerachy comes after
> > > > MLX5_FLOW_NAMESPACE_BYPASS. =20
> > >=20
> > > Our policy was no DPDK driver bifurcation. There's no asterisk saying
> > > "unless you pretend you need flow filters for RDMA, get them upstream
> > > and then drop the act". =20
> >=20
> > Huh?
> >=20
> > mlx5 DPDK is an *RDMA* userspace application.=20
>=20
> Forgive me for my naivet=C3=A9.=20
>=20
> Here I thought the RDMA subsystem is for doing RDMA.

RDMA covers a wide range of accelerated networking these days.. Where
else are you going to put this stuff in the kernel?

> I'm sure if you start doing crypto over ibverbs crypto people will want
> to have a look.

Well, RDMA has crypto transforms for a few years now too. Why would
crypto subsystem people be involved? It isn't using or duplicating
their APIs.

> > libibverbs. It runs on the RDMA stack. It uses RDMA flow filtering and
> > RDMA raw ethernet QPs.=20
>=20
> I'm not saying that's not the case. I'm saying I don't think this was
> something that netdev developers signed-off on.

Part of the point of the subsystem split was to end the fighting that
started all of it. It was very clear during the whole iWarp and TCP
Offload Engine buisness in the mid 2000's that netdev wanted nothing
to do with the accelerator world.

So why would netdev need sign off on any accelerator stuff?  Do you
want to start co-operating now? I'm willing to talk about how to do
that.

> And our policy on DPDK is pretty widely known.

I honestly have no idea on the netdev DPDK policy, I'm maintaining the
RDMA subsystem not DPDK :)

> Would you mind pointing us to the introduction of raw Ethernet QPs?
>=20
> Is there any production use for that without DPDK?

Hmm.. It is very old. RAW (InfiniBand) QPs were part of the original
IBA specification cira 2000. When RoCE was defined (around 2010) they
were naturally carried forward to Ethernet. The "flow steering"
concept to make raw ethernet QP useful was added to verbs around 2012
- 2013. It officially made it upstream in commit 436f2ad05a0b
("IB/core: Export ib_create/destroy_flow through uverbs")

If I recall properly the first real application was ultra low latency
ethernet processing for financial applications.

dpdk later adopted the first mlx4 PMD using this libibverbs API around
2015. Interestingly the mlx4 PMD was made through an open source
process with minimal involvment from Mellanox, based on the
pre-existing RDMA work.

Currently there are many projects, and many open source, built on top
of the RDMA raw ethernet QP and RDMA flow steering model. It is now
long established kernel ABI.

> > It has been like this for years, it is not some "act".
> >=20
> > It is long standing uABI that accelerators like RDMA/etc get to take
> > the traffic before netdev. This cannot be reverted. I don't really
> > understand what you are expecting here?
>=20
> Same. I don't really know what you expect me to do either. I don't
> think I can sign-off on kernel changes needed for DPDK.

This patch is fine tuning the shared logic that splits the traffic to
accelerator subsystems, I don't think netdev should have a veto
here. This needs to be consensus among the various communities and
subsystems that rely on this.

Eli did not explain this well in his commit message. When he said DPDK
he means RDMA which is the owner of the FLOW_NAMESPACE. Each
accelerator subsystem gets hooked into this, so here VPDA is getting
its own hook because re-using the the same hook between two kernel
subsystems is buggy.

Jason
