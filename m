Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7A630CFD2
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 00:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbhBBXTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 18:19:20 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9465 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbhBBXTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 18:19:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019ddce0000>; Tue, 02 Feb 2021 15:18:38 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 23:18:37 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 23:17:41 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 2 Feb 2021 23:17:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MK5n9Kc/MNx61brV6OiIR94ecRQlna5T7Df8Z8D2bOuYuRbO4OkIMNy6cbqfT3PVw7Hw5zcTBnN3wZXdzzV7pn9zfUlHnFWS/oHvJk7xpcOpt71a3IXh3NECUMdRzRnXwJCS5PhOOCuNRjrnq3qFcNtIoqfDZhycciMtsrQ+1TbGOa9hgieY9nsi58kMLnmSkgFoQNhHTy9rM33CCAv+fYhBrdmPMDwOlIL+6cuMHRlBVXncodkHWR+t2fT2juaW8OnA2pgKfu1lLNxV7Og3gjuawkRQsx3goFniyrvdRy+B+Tf0F63q0sWgUTLD6CeYQpI/zjhQxr0IF+/ZK6yptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNSD2yBNPfQJBoJyfwPF/8qqTnBVn2S/RZmD/ff2/zs=;
 b=ndinTjvb5h6J256ys1pFHJ/8jqd+pYEYML6uoB4jRr2GiWe42xT3Xpn94iMy2GDcwta18NRTVsHmISfdx0kGqAO/NObnJkWOs/i4R/makKNNhYImYpLnqLXtPIGHAsybmT2omxJGTP4whN2Ub/o0QUlNBrPtZLZG1+41bpBESCzNLyxpAs51nE2ToPR/BAQJtQBey8k2vP225BJxRxO9gZt3SRVW9K6ZBz9vesM+h2FuSC/ZrLT5lVv/epb8SFg5CWktlJJi3Ct44F2kBEqe1Nmyj3GSDJ6mYam9d0SgiQW0Ou4Gm5luBgr3aTNb5ZWHusf/+RnGpO3xqIavOffVOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3594.namprd12.prod.outlook.com (2603:10b6:5:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.27; Tue, 2 Feb
 2021 23:17:39 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Tue, 2 Feb 2021
 23:17:39 +0000
Date:   Tue, 2 Feb 2021 19:17:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210202231737.GE4247@nvidia.com>
References: <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com> <20210128054133.GA1877006@unreal>
 <d58f341898834170af1bfb6719e17956@intel.com>
 <20210201191805.GO4247@nvidia.com>
 <925c33a0b174464898c9fc5651b981ee@intel.com>
 <CAPcyv4gbW-27ySTmxf97zzcoVA_myM8uLV=ziscMuSKGBz7dqg@mail.gmail.com>
 <20210202171454.GX4247@nvidia.com>
 <4720390ef608423dac481d813e8b8a62@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4720390ef608423dac481d813e8b8a62@intel.com>
X-ClientProxiedBy: BL1PR13CA0463.namprd13.prod.outlook.com
 (2603:10b6:208:2c4::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0463.namprd13.prod.outlook.com (2603:10b6:208:2c4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 2 Feb 2021 23:17:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l74vR-002mQG-BW; Tue, 02 Feb 2021 19:17:37 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612307918; bh=nNSD2yBNPfQJBoJyfwPF/8qqTnBVn2S/RZmD/ff2/zs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=nT8BVt2bDy8FWO1PsesEUf03m+KfB9Cm7ARLw1Ts2WNSFH3qYLMIXRujoJtYQorOn
         b3tCnHugOlplh074Ldy8ts31EtSNIME3oV2Wd8OfxnmFvcwLH6sAHaTmVbBfWyQ8ur
         9PiYcY4gOmbb4IpRsV6TtMasBhNdb2F4B+MfiZ3wn4a7f/KS+nCnGpTISr0qJxzjSg
         H/ckSkKkJ/CwOfQcj5ZT/lPmKyzi1VP/C4wPV63QPDsKt8Ky+wsNeaUpLUKlhRsVCM
         dZG/Y8zdm4XAIuzRea7qjNp/RGnt6r8hivTAHhUeGWmaIEaY2GqsM9I8ccmMgig+68
         okR1fW1QF8emA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 07:42:11PM +0000, Saleem, Shiraz wrote:

> > > Only loosely following the arguments here, but one of the requirements
> > > of the driver-op scheme is that the notifying agent needs to know the
> > > target device. With the notifier-chain approach the target device
> > > becomes anonymous to the notifier agent.
> > 
> > Yes, and you need to have an aux device in the first place. The netdev side has
> > neither of this things. 
> 
> But we do. The ice PCI driver is thing spawning the aux device. And
> we are trying to do something directed here specifically between the
> ice PCI driver and the irdma aux driver.  Seems the notifier chain
> approach, from the comment above, is less directed and when you want
> to broadcast events from core driver to multiple registered
> subscribers.

Yes, generally for good design the net and rdma drivers should be
peers, using similar interfaces, otherwise there will be trouble
answering the question what each peice of code is for, and if a net
change breaks rdma land.

> > I think it would be a bit odd to have extensive callbacks that
> > are for RDMA only, that suggests something in the core API is not general enough.
> 
> Yes there are some domain specific ops. But it is within the
> boundary of how the aux bus should be used no?

Sure is, but I'm not sure it is a great design of a driver.

In the end I don't care alot about which thing you pick, so long as
the peer layer is fused with aux bus and there isn't a 2nd
registration layer for devices.

Jason
