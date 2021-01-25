Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF3C302FED
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbhAYXQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:16:10 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1464 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732291AbhAYXPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:15:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f50d80000>; Mon, 25 Jan 2021 15:14:32 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 23:14:31 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 23:13:59 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 23:13:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVCzrT3EHUkPLDrtu5QbycgEFy/PfWCqx4oxbcY3ZIiUNjHzkvGSeZurfA3rVmJyXqWvyzwUgrhE9e69+Yv+sijUUy5C6Rj2mJGqGNhn9kzvc7PHU8s0wM48uXho3Lh87TZhaEj2AP/Gb3lwFBQZdvpnXmWsWruDkXsMYiwQZ62yXwKIyP2j3S32Q6ffDLej6MK6fyqB3IjG3xAiPvuwpDz8fB9zqa48xxrwgh5EQpjlGHWEJON/+Xc9A8p0HQG9QjnOqR1kXVpNrBMY6p/ghVpZz7dSyZBIPMs3p3EOl3KKBXzDxuSm/jn5MBmOWO1QSOfnNtdixPOPyidm6MMn1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugtF0NcHK0eH9JLck5QVusW/bK7+MYd3/Fhnw5C7/BA=;
 b=aJcbJwtY15C9WXml9qM4gejnej5erh95yq2FuaqGA2PsXePYJjFqz7X+fC8zPByFp7veJIVBtinYq8n1NI9oRmnwBovZsSSadF4sWDyaIqKoOvCTbL1wB+uminZ1cm7BnBA3GSoWBXrv7Wn+ke3EUwN00xdqHGySJYC7BM9VKdZ8G+v1i1e/CIa+t5rGCIISzJSP62z3+lUdTX3E+WQwHODE5jj6YFq8VscFcSvc7RlwcXq+CouO5DEenfFQ5YUEyltNcsB6knvW1DKbLQW2+ByPzVeHJqgOIMdJVw2tljS2Zv6opUiBfgzbt9fEHjAfdZINESimvjmqDKWZQaCOsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4497.namprd12.prod.outlook.com (2603:10b6:5:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Mon, 25 Jan
 2021 23:13:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 23:13:57 +0000
Date:   Mon, 25 Jan 2021 19:13:55 -0400
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
Message-ID: <20210125231355.GC4147@nvidia.com>
References: <20210122193658.282884-1-saeed@kernel.org>
 <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
 <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKOOJTw_RfYfFunhHKTD6k73FvFObVb5Xx7hK8uPUUGJpuTzuw@mail.gmail.com>
 <CAKOOJTx7ogAvUkT5y8vKYp=KB+VSbe0MgXg5PuvjEiU_dO_5YA@mail.gmail.com>
 <20210125195905.GA4147@nvidia.com>
 <CAKOOJTx_0CxQ27PmB6MfcagGYdeAqEDy4CCr0wNATZOeCBBkTg@mail.gmail.com>
 <20210125204143.GB4147@nvidia.com>
 <CAKOOJTwWUCe+6qkderKY7ojfHWDxkMQyQTR6uYRFNiZJ8zzYbw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKOOJTwWUCe+6qkderKY7ojfHWDxkMQyQTR6uYRFNiZJ8zzYbw@mail.gmail.com>
X-ClientProxiedBy: MN2PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:208:d4::41) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR04CA0028.namprd04.prod.outlook.com (2603:10b6:208:d4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 23:13:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4B3T-006poA-NQ; Mon, 25 Jan 2021 19:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611616472; bh=ugtF0NcHK0eH9JLck5QVusW/bK7+MYd3/Fhnw5C7/BA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=iwXg6xlk8ft7FAZHmQdvqeGejYcrWGLTqCCylf2omxFxQy/WdIYz3oqzq8SK3Os4y
         21LlrvGVYPowsHf4PAy0NwWWhVNXdk0qXgxzyxY2wK9+jVtZIfASn/0t5pFlTkxHLj
         aLcpCBKDNFDRF/f8OUCdGg1T/KFYJ1m3U1VCcUFl8F1MDj04XP71wTkKSJIkGmeWJ+
         vn19MiS3RBxJ1C1xTzyOzgbE1ovca4eNWsLtx4nx8sXoF4PxYBb+jH2tkO8pmg68hy
         5cLDna7GEV3SgU5BohIhypJvY6w6weouAfqOAgvqwU9wM4PmTrt/3tjqTLcZp5X/xM
         2K9oZphh4ovjQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 01:23:04PM -0800, Edwin Peer wrote:
> On Mon, Jan 25, 2021 at 12:41 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > > That's an implementation decision. Nothing mandates that the state has
> > > to physically exist in the same structure, only that reads and writes
> > > are appropriately responded to.
> >
> > Yes, PCI does mandate this, you can't store the data on the other side
> > of the PCI link, and if you can't cross the PCI link that only leaves
> > on die/package memory resources.
> 
> Going off device was not what I was suggesting at all. I meant the
> data doesn't necessarily need to be stored in the same physical
> layout.

It doesn't change anything, every writable bit must still be stored
on-die SRAM. You can compute the minimum by summing all writable and
read-reporting bits in the standard SRIOV config space.

Every bit used for SRIOV is a bit that couldn't be used to improve
device performance.

> > > Right, but presumably it still needs to be at least a page. And,
> > > nothing says your device's VF BAR protocol can't be equally simple.
> >
> > Having VFs that are not self-contained would require significant
> > changing of current infrastructure, if we are going to change things
> > then let's fix everything instead of some half measure.
> 
> I don't understand what you mean by self-contained. 

Self-contained means you can pass the VF to a VM with vfio and run a
driver on it. A VF that only has a write-only doorbell page probably
cannot be self contained.

> In practice, there will be some kind of configuration channel too,
> but this doesn't necessarily need a lot of room either 

I don't know of any device that can run without configuration, even in
a VF case.

So this all costs SRAM too.

> > The actual complexity inside the kernel is small and the user
> > experience to manage them through devlink is dramatically better than
> > SRIOV. I think it is a win even if there isn't any HW savings.
> 
> I'm not sure I agree with respect to user experience. Users are
> familiar with SR-IOV.

Sort of, SRIOV is a very bad fit for these sophisticated devices, and
no, users are not familiar with the weird intricate details of SR-IOV
in the context of very sophisticated reconfigurable HW like we are
seeing now.

Look at the other series about MSI-X reconfiguration for some colour
on where SRIOV runs into limits due to its specific design.

> Now you impose a complementary model for accomplishing the same goal
> (without solving all the problems, as per the previous discussion,
> so we'll need to reinvent it again later).  

I'm not sure what you are referring to.

> It's not easier for vendors either. Now we need to get users onto new
> drivers to exploit it, with all the distribution lags that entails
> (where existing drivers would work for SR-IOV). 

Compatability with existing drivers in a VM is a vendor
choice. Drivers can do a lot in a scalable way in hypervisor SW to
present whateve programming interface makes sense to the VM. Intel is
showing this approach in their IDXD SIOV ADI driver.

> Some vendors will support it, some won't, further adding to user
> confusion.

Such is the nature of all things, some vendors supported SRIOV and
other didn't too.

Jason
