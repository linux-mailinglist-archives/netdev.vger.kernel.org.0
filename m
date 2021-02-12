Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA34231A69C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhBLVPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:15:20 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1224 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhBLVPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 16:15:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026efbd0000>; Fri, 12 Feb 2021 13:14:38 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 21:14:36 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 21:14:13 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 21:14:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUpnRqCAUGbXR3u1LUB33fVNNLdvo8OihZf0RrZQSOifQQmPXzIrZWLYKPE40BGPebG8ez8hxbK4+qhd0DLjLvjQh00LG23FjzIx7ue1834Y9pKKo2zcU9fkMusK4IKOHhogBQoC7ZrFu4dJMpLqpZKcHXkrNt9xgVPna6K/8HY1RjemGNa9BTYTdElcNznKouSzowBl7zhLZcoNynTVQM6RJbBAJr7ooOIPHr7vqQWR9wUFyGvK0+mtgX03DGeyHhb8fx4eINWukpSg+dODmXK6EHCQrGxNxJNBMeNsTppH13UxlJINitkIDrsZfIl9K+VJ6pQDHegBhKtcjer8xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5HxCFtODebusSQHTPX0BY4d92SivrF2Oh02NjbbP9s=;
 b=mj3yIU/ogOiLKjuZpwWSQjQ5w+ghyxP5b7MeT/wXKWioAWQHk7vlvFE+FnO8/6dET9MqAhgXIB+rnSrKH8YDzMZpkcEYQdxhBMl3qOpwZ1D2hiUHp5SRlVywpiBvFEp4Dq6ouBkHjfqFbROBZAyZqdXU9+eAh1W/gsVPWKTFP+xhZauhnA6H6PQ6+d3iaRX3/Kdkot/sAsdxXX7TP43YkDsoy/dMjAn06L3BbKZ0u0IMBMPZfha0YBXDEqDR96iBZMid5mG6YDpFirCoe9Fz8G5EZqcBMPgqjJtQ2ZJd3MXdH/Q510ISi7jj4wRbqjs/5mNMgvhZNZAZCnfHUY64bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0202.namprd12.prod.outlook.com (2603:10b6:4:4d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 12 Feb
 2021 21:14:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 21:14:10 +0000
Date:   Fri, 12 Feb 2021 17:14:08 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@nvidia.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] Real time/free running timestamp support
Message-ID: <20210212211408.GA1860468@nvidia.com>
References: <20210209131107.698833-1-leon@kernel.org>
 <20210212181056.GB1737478@nvidia.com>
 <5d4731e2394049ca66012f82e1645bdec51aca78.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5d4731e2394049ca66012f82e1645bdec51aca78.camel@kernel.org>
X-ClientProxiedBy: BL1PR13CA0108.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0108.namprd13.prod.outlook.com (2603:10b6:208:2b9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Fri, 12 Feb 2021 21:14:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lAflQ-007o2v-2B; Fri, 12 Feb 2021 17:14:08 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613164478; bh=L9sysDOk7iApUmjd+Mrhn/P9WHpEkA+YW9Cvsdw0308=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Q3BotjBeLAs7eQ3nwWgVQ2AqeHVvTfTs2L4mXXpCWb7ir+fSoEt7j/lsuDEuaq86a
         sdD7Hhama6NjjQsshzvO5FvwP0V/WmneO27WWFpg30tw4SH2A5SYRHvFoktTg9riiO
         rdD5HWkfcvjZgnlzz3A4yGKw/h+6sXQG3TeqU1FR7Shik+iPGErIlbLlW2g3McKVgs
         olbH7q8i1z0ExWV6GEHX9g9apBGliorTV7rKjpjmgVyXmM5y6H1zNh6NNttcf2B1kS
         5WQpRxlIk4qL7+bJgA3T/rJBZn9ar0Jniotmz6Uy6txuudCGwz7Tcpk2zSRVyYx7Ni
         6xWXVCKp9uxWQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 01:09:20PM -0800, Saeed Mahameed wrote:
> On Fri, 2021-02-12 at 14:10 -0400, Jason Gunthorpe wrote:
> > On Tue, Feb 09, 2021 at 03:11:05PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >=20
> > > Add an extra timestamp format for mlx5_ib device.
> > >=20
> > > Thanks
> > >=20
> > > Aharon Landau (2):
> > > =C2=A0 net/mlx5: Add new timestamp mode bits
> > > =C2=A0 RDMA/mlx5: Fail QP creation if the device can not support the =
CQE
> > > TS
> > >=20
> > > =C2=A0drivers/infiniband/hw/mlx5/qp.c | 104
> > > +++++++++++++++++++++++++++++---
> > > =C2=A0include/linux/mlx5/mlx5_ifc.h=C2=A0=C2=A0 |=C2=A0 54 ++++++++++=
+++++--
> > > =C2=A02 files changed, 145 insertions(+), 13 deletions(-)
> >=20
> > Since this is a rdma series, and we are at the end of the cycle, I
> > took the IFC file directly to the rdma tree instead of through the
> > shared branch.
> >=20
> > Applied to for-next, thanks
> >=20
>=20
> mmm, i was planing to resubmit this patch with the netdev real time
> support series, since the uplink representor is getting delayed, I
> thought I could submit the real time stuff today. can you wait on the
> ifc patch, i will re-send it today if you will, but it must go through
> the shared branch

Friday of rc7 is a bit late to be sending new patches for the first
time, isn't it??

But sure, if you update the shared branch right now I'll fix up rdma.git

Jason
