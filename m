Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B283C302CCF
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732379AbhAYUmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:42:46 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7073 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731973AbhAYUmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 15:42:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f2d170001>; Mon, 25 Jan 2021 12:41:59 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 20:41:58 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 20:41:47 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 20:41:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEhQ/G8Ra2+DFDwFe05JXyZO73S4rwVdrpuf3tO5ee6FEuHqZgjE1IcJ3KFlyGfdqg7u4J7ZQ3DtxvjStCsW8OrBjVvEtInbitPyVUlrh22/5olRSB5YXmJhVlhFlgKYWtP2PSUXpym63O0T2d4/7MjCF41LGumFSMl7pBCFwIt3/LW1aTo0QgMWjQzodlMuaOXk8Ui961TVxo5JLmBlZ+W0LA9JREjdNzW1hwmqOPQL293b/IXIqAy2p39q2yifzqPEfVy4QQ3giFVBc9Il/YGtGcGYHMm9G9E2zJ0n1cd+gT5rOoEqp0brt7C+iHAHX1oSMKruUf14K3wI36GE1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNJW0MLEN9Cj87/8dV/V84+bTfSqRuUh3yR6quIV38k=;
 b=hcGHQvFvctFiPo7EO8OBm3tUqPRQqIujDILbL3OVfia5dTcBMVTF9u0axu5BwDo3lUAKSyqX7NXD5wx/eZz8K6BtX8Wnus4e3/KhSoPmmix1kC4t8wpPPEdlEV3z2FJjDT55iklXKR9casIhRTHGCmk4WRYlBovX/mIp99zKNLuy9d4pRRoaF5TMIFWwKMqoaR6bJ0qED8oWnYaYZDvx6eb+Fqj7j86Hv+LJMEKQZN/kekewTLtG+2xtzFCoV6AEs5BLfg2IXmid3Hs0F0039hTNfrAXo7Cn5t7cJQ8p+sJ3Z08dPKAfyJPaWgGdUg8YhPfLqA9O0ux9T7Ev60ZONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1145.namprd12.prod.outlook.com (2603:10b6:3:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 20:41:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 20:41:44 +0000
Date:   Mon, 25 Jan 2021 16:41:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Edwin Peer <edwin.peer@broadcom.com>
CC:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Kiran Patil <kiran.patil@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next V10 00/14] Add mlx5 subfunction support
Message-ID: <20210125204143.GB4147@nvidia.com>
References: <20210122193658.282884-1-saeed@kernel.org>
 <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
 <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKOOJTw_RfYfFunhHKTD6k73FvFObVb5Xx7hK8uPUUGJpuTzuw@mail.gmail.com>
 <CAKOOJTx7ogAvUkT5y8vKYp=KB+VSbe0MgXg5PuvjEiU_dO_5YA@mail.gmail.com>
 <20210125195905.GA4147@nvidia.com>
 <CAKOOJTx_0CxQ27PmB6MfcagGYdeAqEDy4CCr0wNATZOeCBBkTg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKOOJTx_0CxQ27PmB6MfcagGYdeAqEDy4CCr0wNATZOeCBBkTg@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:208:256::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0026.namprd13.prod.outlook.com (2603:10b6:208:256::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.6 via Frontend Transport; Mon, 25 Jan 2021 20:41:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l48gB-006mQb-6X; Mon, 25 Jan 2021 16:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611607319; bh=MNJW0MLEN9Cj87/8dV/V84+bTfSqRuUh3yR6quIV38k=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=l22BwzXw5/n1PiMuHh8nAmpczCzouJiPsVrAPuFlR5M/qXnBpcD6i8EDrZWmmi2KC
         oNGqSyyvEoqcvMijVH1b3y8vXTiC96MiFiHYyf+PvMg5KCoChJ6zr3n1uEx2CCvfZz
         9yBqRM8vyGVXW00hHY9LiESuf48j0dO7hzIVft6iwAA7Ty250KmwxzotwLmzEVIqWU
         eANlLGDvWv2ZxjKRSLEm2FON2erQnmrsSVQJPpj5xR29dCIzgAHPnWGh+v4SP5q4op
         kth389+wMAEfwtyXFA+h0s6RAxp4WwvJZW38eDi9NEbBwSLGw/TCVepZHq4N28Kuqi
         bBXGrPIGvV9oA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 12:22:13PM -0800, Edwin Peer wrote:
> On Mon, Jan 25, 2021 at 11:59 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Every writable data mandated by the PCI spec requires very expensive
> > on-die SRAM to store it.
> 
> That's an implementation decision. Nothing mandates that the state has
> to physically exist in the same structure, only that reads and writes
> are appropriately responded to.

Yes, PCI does mandate this, you can't store the data on the other side
of the PCI link, and if you can't cross the PCI link that only leaves
on die/package memory resources.

> > We've seen Intel drivers that show their SIOV ADIs don't even have a
> > register file and the only PCI presence is just a write-only doorbell
> > page in the BAR.
> 
> Right, but presumably it still needs to be at least a page. And,
> nothing says your device's VF BAR protocol can't be equally simple.

Having VFs that are not self-contained would require significant
changing of current infrastructure, if we are going to change things
then let's fix everything instead of some half measure.

SRIOV really doesn't bring much benefits, it has lots of odd little
restrictions and strange lifecycle rules for what modern devices want
to do.

> > It is hard to argue a write-only register in a BAR page vs all the
> > SRIOV trappings when it comes to HW cost.
> 
> Say it's double the cost? I don't know that it is, but does that
> warrant the additional complexity of SFs? We should try to quantify.

The actual complexity inside the kernel is small and the user
experience to manage them through devlink is dramatically better than
SRIOV. I think it is a win even if there isn't any HW savings.

Jason
