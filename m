Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39ECA2C2F7A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404098AbgKXSCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:02:16 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4634 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403986AbgKXSCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 13:02:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbd4aa70007>; Tue, 24 Nov 2020 10:02:15 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 18:02:15 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 24 Nov 2020 18:02:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsco2a4ybgn4RID7o0dSryUcRprRSlAapBGZbNUN0f4/RatPKO6K9W/KqrjXwkcGgynUo4r9uPw797ziq4hq0Ehddszt+0cvRuBismlkJrwwPapLlrd01cIT11WmDjWSqQGVl3UN7uKysUovx0GK7WpiZy0azyq1fGv8iu3vsZAAvsJnNnNmyBsaVa7s7PrMqExOarg1wPdxNxrxSSyfYJ+WiA3/lPKRS7p+pC/q4GghcBvBNzqlx/rCuyeGhojNI2aTwQG6KadAKJTozCBW3dj4meYF/g3F++13ZSkwplL8JD7ugizPuicFMsyHitdUZt2jpF1i7X1CZnlB6uWbZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=435ogFDV+MDYgFDgvf9KV37fb5NYsuyuzUu8OSBCooA=;
 b=VyV4M4HPrhSFbAWlLtQYegI0wsvIKMr/bPazwFJH3F6DkGkvsBbqBfPzqRQdbm13T85frayacym5yNBOD30A5rFyfBD6WKUJZrHOtTuRb7hrwhXzg8e5SU4Qi1t0Jz0P+NgleIMB4DdtbC3rtTj8/T7e1osgFZhMbpItyfTriQG2j1uUu5harwpoZWooLPyHcgdLK4DttJcgign1qSF6mAN84xJbJVfWx5vLsfzHeJ1F+s/T/0UVNupjPE5ZWYj01al/c2TQTG1ao81H7s09sYHuf8/KSxZMc8Shr2oSnl4k7AKWaM2eOxsPh/rRLiCO9tjgz8dfGFKrk7ob7yqviw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.21; Tue, 24 Nov
 2020 18:02:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3589.022; Tue, 24 Nov 2020
 18:02:13 +0000
Date:   Tue, 24 Nov 2020 14:02:10 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201124180210.GJ5487@ziepe.ca>
References: <20201120230339.651609-1-saeedm@nvidia.com>
 <20201120230339.651609-12-saeedm@nvidia.com>
 <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
 <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MN2PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:208:d4::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR04CA0020.namprd04.prod.outlook.com (2603:10b6:208:d4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 24 Nov 2020 18:02:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1khcdm-000tGu-SC; Tue, 24 Nov 2020 14:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606240935; bh=435ogFDV+MDYgFDgvf9KV37fb5NYsuyuzUu8OSBCooA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=nGd3SJhYI3KpPGx/tigd5dog+XXH0uX80gZKM2fbw54ONWWiKx1Lea8igZK4nz/Ks
         d3XoHdz0u8x1uqIuoGI1G/wLbX5j8O6EIskll3bK37mykgAASM5EFuadouiBchD1qp
         AxsPIgWwqK4FFKhnJ7ZBnLBHoS/3dX3Oc6Dpz9jW0jQOCFxI8s+odJQKG8WVRRmQnZ
         6g4ODoU/TiNoSKMma3d0UL54YIWJ/JpNeNc1/iPaQkKoTxLMzpcPWIVz9c1v/fIcxT
         vcv4E2zOh3b+hXK67Gmb71ZM3X3knieMCuzMWK7/rDjDumee3SGhneBMV90SLqquC8
         397Y1IFIs2RyQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 09:12:19AM -0800, Jakub Kicinski wrote:
> On Sun, 22 Nov 2020 08:41:58 +0200 Eli Cohen wrote:
> > On Sat, Nov 21, 2020 at 04:01:55PM -0800, Jakub Kicinski wrote:
> > > On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed wrote:  
> > > > From: Eli Cohen <eli@mellanox.com>
> > > > 
> > > > Add a new namespace type to the NIC RX root namespace to allow for
> > > > inserting VDPA rules before regular NIC but after bypass, thus allowing
> > > > DPDK to have precedence in packet processing.  
> > > 
> > > How does DPDK and VDPA relate in this context?  
> > 
> > mlx5 steering is hierarchical and defines precedence amongst namespaces.
> > Up till now, the VDPA implementation would insert a rule into the
> > MLX5_FLOW_NAMESPACE_BYPASS hierarchy which is used by DPDK thus taking
> > all the incoming traffic.
> > 
> > The MLX5_FLOW_NAMESPACE_VDPA hirerachy comes after
> > MLX5_FLOW_NAMESPACE_BYPASS.
> 
> Our policy was no DPDK driver bifurcation. There's no asterisk saying
> "unless you pretend you need flow filters for RDMA, get them upstream
> and then drop the act".

Huh?

mlx5 DPDK is an *RDMA* userspace application. It links to
libibverbs. It runs on the RDMA stack. It uses RDMA flow filtering and
RDMA raw ethernet QPs. It has been like this for years, it is not some
"act".

It is long standing uABI that accelerators like RDMA/etc get to take
the traffic before netdev. This cannot be reverted. I don't really
understand what you are expecting here?

Jason
