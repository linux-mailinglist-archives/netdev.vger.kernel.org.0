Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62CA2DDC4C
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 01:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732226AbgLRAIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 19:08:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8726 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbgLRAIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 19:08:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdbf2ea0002>; Thu, 17 Dec 2020 16:08:10 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 00:08:07 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 00:08:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kv0E/Q/bhUndrKtH2JpQS04ShTLLqlYvPCN0EoaSDMqqZwpZu1AazlPtRMyHIvM6RMmFylqW6B0HxSu75tQFAKMQoZys6AXxnItHd3/zWEasrWXrj7tKKj4vCq/uKNWTVXS572yMgJ1wb1bAI9amWaUXucNejd7FLkHbhfI7AuVSUOC+XFBi2L6dIQNpsMkeMT7lG6kH7YtCC+Om7tAWqZlI++Ou504IJJmXJyxkvqtsJHkVeOLZCpKP/gYqedOQWA8DOySqyNt0aZjww0yNe8q7MfIJiQ9Y8Tc2JpfEKBFGjMTf1gh42oQlMJQKDKWXrsegHopOgUgX4QTHwXbjLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zdYqW5xRnD6xXAD4tYf3uQxeKd3HbbwLC6f4b3gye8=;
 b=D6gKaPsPxt2Frl0HOkmEGDMG+Sn3h2Z4Gz2msqi6n2Te9zLKi0EINEpAjmIcRHKOVhtDm77wnUzZBlStjIE5Blutq7PCnmXqi+GWZX/65r/rzSSXCcn+ObuTiPUp/468eKvauQam5h1jtFoUzEaiIZjj7o0xlgixjuG3lMUo/Tqt9SwJjZWLn0xgxAuXKQ462uxbnLbg0jNgpfk4nN7lx+7UUbadrYh/FaRwMO9G/PNMYioy1EModh5+tFJczV6KLhg/SswNm2CQvKVVsCR50juV4BMAlywirsPxf5a/i1nA0kfSZ9YmlCJdzkr6NX3CHKMMNMhLTO8k40vxPdgp/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB3831.namprd12.prod.outlook.com (2603:10b6:610:29::13)
 by CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 00:08:06 +0000
Received: from CH2PR12MB3831.namprd12.prod.outlook.com
 ([fe80::9935:c6d7:b453:861f]) by CH2PR12MB3831.namprd12.prod.outlook.com
 ([fe80::9935:c6d7:b453:861f%5]) with mapi id 15.20.3654.024; Fri, 18 Dec 2020
 00:08:06 +0000
Date:   Thu, 17 Dec 2020 20:08:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
Message-ID: <20201218000802.GV552508@nvidia.com>
References: <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
 <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <20201217003829.GN552508@nvidia.com>
 <CAKgT0UcEjekh0Z+A+aZKWJmeudr5CZTXPwPtYb52pokDi1TF_w@mail.gmail.com>
 <20201217194035.GT552508@nvidia.com>
 <CAKgT0Ue9+cd-Mp4qgusorDX1mnjfzMXrQvB2FqLaH+ouzVTMRQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0Ue9+cd-Mp4qgusorDX1mnjfzMXrQvB2FqLaH+ouzVTMRQ@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0330.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::35) To CH2PR12MB3831.namprd12.prod.outlook.com
 (2603:10b6:610:29::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0330.namprd13.prod.outlook.com (2603:10b6:208:2c1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.13 via Frontend Transport; Fri, 18 Dec 2020 00:08:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kq3JS-00CSTV-BI; Thu, 17 Dec 2020 20:08:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608250090; bh=0zdYqW5xRnD6xXAD4tYf3uQxeKd3HbbwLC6f4b3gye8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=HkLBJG6odtJ5r6ri2P/F+9QS2LRBIT55VzGRQbwsSozRk4VNN8LDu5V7ZmpPww7Ft
         YiLhzxJOLzAQqk1saAvZmyh9JItgTuy6xRniNWDzPywqSGh25BrgBpKYvuRmvGVryA
         jxiyCYMFm0odx+a5nDAKcY+jB+Coqpt0S1BKByX5qAHorT0o3pUbsaeqjR0JpFfMu4
         v7++dGVnYIdwGGTvbhfI13+tkyz7GzKQeVN/Ucx5FBqkbMchgogdaPakpyWosCQ7m6
         SCGCllzF4M5tZxNnJEZRsG+f8HAPYgp6b/Xv/69SPrxJa46hNYZhFtnwr48ijiNJeT
         MFe9+Kjk7MlbQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 01:05:03PM -0800, Alexander Duyck wrote:

> > I view the SW bypass path you are talking about similarly to
> > GSO/etc. It should be accessed by the HW driver as an optional service
> > provided by the core netdev, not implemented as some wrapper netdev
> > around a HW implementation.
> 
> I view it as being something that would be a part of the switchdev API
> itself. Basically the switchev and endpoint would need to be able to
> control something like this because if XDP were enabled on one end or
> the other you would need to be able to switch it off so that all of
> the packets followed the same flow and could be scanned by the XDP
> program.

To me that still all comes down to being something like an optional
offload that the HW driver can trigger if the conditions are met.

> > It is simple enough, the HW driver's tx path would somehow detect
> > east/west and queue it differently, and the rx path would somehow be
> > able to mux in skbs from a SW queue. Not seeing any blockers here.
> 
> In my mind the simple proof of concept for this would be to check for
> the multicast bit being set in the destination MAC address for packets
> coming from the subfunction. If it is then shunt to this bypass route,
> and if not then you transmit to the hardware queues. 

Sure, not sure multicast optimization like this isn't incredibly niche
too, but it would be an interesting path to explore.

But again, there is nothing fundamental about the model here that
precludes this optional optimization.

> > Even if that is true, I don't belive for a second that adding a
> > different HW abstraction layer is going to somehow undo the mistakes
> > of the last 20 years.
> 
> It depends on how it is done. The general idea is to address the
> biggest limitation that has occured, which is the fact that in many
> cases we don't have software offloads to take care of things when the
> hardware offloads provided by a certain piece of hardware are not
> present. 

This is really disappointing to hear. Admittedly I don't follow all
the twists and turns on the mailing list, but I thought having a SW
version of everything was one of the fundamental tenants of netdev
that truly distinguished it from something like RDMA.

> It would basically allow us to reset the feature set. If something
> cannot be offloaded in software in a reasonable way, it is not
> allowed to be present in the interface provided to a container.
> That way instead of having to do all the custom configuration in the
> container recipe it can be centralized to one container handling all
> of the switching and hardware configuration.

Well, you could start by blocking stuff without a SW fallback..

> There I disagree. Now I can agree that most of the series is about
> presenting the aux device and that part I am fine with. However when
> the aux device is a netdev and that netdev is being loaded into the
> same kernel as the switchdev port is where the red flags start flying,
> especially when we start talking about how it is the same as a VF.

Well, it happens for the same reason a VF can create a netdev,
stopping it would actually be more patches. As I said before, people
are already doing this model with VFs.

I can agree with some of our points, but this is not the series to
argue them. What you want is to start some new thread on optimizing
switchdev for the container user case.

> In my mind we are talking about how the switchdev will behave and it
> makes sense to see about defining if a east-west bypass makes sense
> and how it could be implemented, rather than saying we won't bother
> for now and potentially locking in the subfunction to virtual function
> equality.

At least for mlx5 SF == VF, that is a consequence of the HW. Any SW
bypass would need to be specially built in the mlx5 netdev running on
a VF/SF attached to a switchdev port.

I don't see anything about this part of the model that precludes ever
doing that, and I also don't see this optimization as being valuable
enough to block things "just to be sure"

> In my mind we need more than just the increased count to justify
> going to subfunctions, and I think being able to solve the east-west
> problem at least in terms of containers would be such a thing.

Increased count is pretty important for users with SRIOV.

Jason
