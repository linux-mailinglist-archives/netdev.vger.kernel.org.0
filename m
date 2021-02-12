Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBCC31A6CF
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhBLVWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:22:50 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15699 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhBLVWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 16:22:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026f1740000>; Fri, 12 Feb 2021 13:21:56 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 21:21:56 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 21:21:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJKK1A20OvtIspvj2e0PHu7Ggo1puP66rQVsjgjUK6mTmiOtGlUwTMiTj4+Bj4Ia5fNSddqkGUSBVVHDT6NS0D7T8rjLeiSa3I7iheZQK90tWDfIBVZ6QqXUN7O1Mc1iXE9HUcILjRiN5DgI5FXJicvoe5F6a2MwrKvMdvlahnbMkz3cxDR7Ac+X1iDoTVnkYa65wwzQGQfSgH01/r+zalHR5eyPBnlPDfON+utpvTUXJIlXhCAlvBkdahmKP8LynNlsBKsjAxUjaHgxYwJN9p1gBGZPGh4wXwOPke/9NZbUo4i36zJ+AayBGP7GaTo5m5v2OCEXr5ub4DX9AlaHAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VszTAWIeCU+N7ccOI1hiLhPuJdLAetxbENJstAHF74Y=;
 b=KDoB4ghG385ANzKcT0PypfbT8h+0Qs1+Gz3F5hEuvPqJK5bJ5qEd+GrN+cXVfKdtq9zP2ON9yXOhBU4hMe22jwpZvVvPWR4T2QUdxRB+Xsf0JfRxPbywJ2RYZaX5rnExoNRMM/Y3SAATDskXH0Co0/semlB+96O7Z+iy59jM/+m0q1ZIX6+ioY+Wl5Ac005aEpIvM/RdWgmQ1hxkxhS8eIShPbmW41rBRVMrlKnOVaT8MnbDhfzr1FXIITjwhqd58a+mIQVknMPt6HeVJzRjwk471bTzILAaRnqZXQo4miA1Rc7awpL++XupV3iioA5mx4yzb5nolXYnzf9RgUogrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3514.namprd12.prod.outlook.com (2603:10b6:5:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 21:21:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 21:21:55 +0000
Date:   Fri, 12 Feb 2021 17:21:53 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@nvidia.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] Real time/free running timestamp support
Message-ID: <20210212212153.GX4247@nvidia.com>
References: <20210209131107.698833-1-leon@kernel.org>
 <20210212181056.GB1737478@nvidia.com>
 <5d4731e2394049ca66012f82e1645bdec51aca78.camel@kernel.org>
 <20210212211408.GA1860468@nvidia.com>
 <53a97eb379af167c0221408a07c9bddc6624027d.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <53a97eb379af167c0221408a07c9bddc6624027d.camel@kernel.org>
X-ClientProxiedBy: BL1PR13CA0070.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::15) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0070.namprd13.prod.outlook.com (2603:10b6:208:2b8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Fri, 12 Feb 2021 21:21:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lAfsv-007oA6-DV; Fri, 12 Feb 2021 17:21:53 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613164916; bh=waMQ+oR2qEe4LrSLjX8qppaZjsxesXUE53Ckt82bD0Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=AULvgVQw7ydhZY4WGvXxdlcIzQpVxoAS4MawKO0QNLOUH07kiz/FEoUnBHdWBIlRR
         gEunHy/OMEReG8iPOd/C7skOL8ukoNyAlm3MBZjB9luwQyFeet8kZpyPznu4kLUOVB
         VN0+hkvJ78yhQSkHoP4YG4uvi6pd0s0JO0C3SofwsD56+TKAduZ0ZrJ558EJO3/TMv
         aHTu+Rm1OE5/J/WGY/Ck3zf4zBFAs3yIQQuWuE4xITMKpttUYXPOeQnKKHzs+G2Lrb
         L9r6T6ca0VWhekd8v2g/uphGspO3/o0WcQ8jzZpawAsHHi4eKDjQ4J27PEUoYqWG/6
         IAbCREVxG+ARQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 01:19:09PM -0800, Saeed Mahameed wrote:
> On Fri, 2021-02-12 at 17:14 -0400, Jason Gunthorpe wrote:
> > On Fri, Feb 12, 2021 at 01:09:20PM -0800, Saeed Mahameed wrote:
> > > On Fri, 2021-02-12 at 14:10 -0400, Jason Gunthorpe wrote:
> > > > On Tue, Feb 09, 2021 at 03:11:05PM +0200, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > >=20
> > > > > Add an extra timestamp format for mlx5_ib device.
> > > > >=20
> > > > > Thanks
> > > > >=20
> > > > > Aharon Landau (2):
> > > > > =C2=A0 net/mlx5: Add new timestamp mode bits
> > > > > =C2=A0 RDMA/mlx5: Fail QP creation if the device can not support =
the
> > > > > CQE
> > > > > TS
> > > > >=20
> > > > > =C2=A0drivers/infiniband/hw/mlx5/qp.c | 104
> > > > > +++++++++++++++++++++++++++++---
> > > > > =C2=A0include/linux/mlx5/mlx5_ifc.h=C2=A0=C2=A0 |=C2=A0 54 ++++++=
+++++++++--
> > > > > =C2=A02 files changed, 145 insertions(+), 13 deletions(-)
> > > >=20
> > > > Since this is a rdma series, and we are at the end of the cycle,
> > > > I
> > > > took the IFC file directly to the rdma tree instead of through
> > > > the
> > > > shared branch.
> > > >=20
> > > > Applied to for-next, thanks
> > > >=20
> > >=20
> > > mmm, i was planing to resubmit this patch with the netdev real time
> > > support series, since the uplink representor is getting delayed, I
> > > thought I could submit the real time stuff today. can you wait on
> > > the
> > > ifc patch, i will re-send it today if you will, but it must go
> > > through
> > > the shared branch
> >=20
> > Friday of rc7 is a bit late to be sending new patches for the first
> > time, isn't it??
>=20
> I know, uplink representor last minute mess !
>=20
> >=20
> > But sure, if you update the shared branch right now I'll fix up
> > rdma.git
> >=20
>=20
> I can't put it in the shared brach without review, i will post it to
> the netdev/rdma lists for two days at least for review and feedback.

Well, I'm not going to take any different patches beyond right now
unless Linus does a rc8??

Just move this one IFC patch to the shared branch, it is obviously OK

Jason
