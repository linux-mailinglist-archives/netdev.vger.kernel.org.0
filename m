Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03DC2FF943
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 01:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbhAVAM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 19:12:57 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2307 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAVAMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 19:12:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600a185e0000>; Thu, 21 Jan 2021 16:12:14 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Jan
 2021 00:12:13 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Jan
 2021 00:12:02 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 22 Jan 2021 00:12:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzBSJ9VecpdGZOYH4i/t6nPK9OxjntWXyqs7SaCogcbY3w8mjUQPZiWXaiQQmE991mSBb0ToItB5BGyNQZ+XXxkjXcrOW+awE/9mKrlaXPBnbpq0kifYdIazC/TI5juxW0Wxt1EBsyNRPowbsmvLMoe2JqxhtBh06Zd1/AC6oKjvFExQz0swEDxW+/UajZ8ZyK0knwmXwLjrZ1F38EpGS34rsV/BNoGUEaTrdMmOsE+tuk71CiEOeIw1L/pWeKlZ6mui81jwyrg0otZ2ovnrR/5F4ofVa3nRG47/01YyLHQWs0RSJhqCsHHUMWRcM7TZN564R2sOow7bc59MauaqQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tg49lyOe4ndxOafM38vTTLJE13SGiijd8pIleDt2BEY=;
 b=KXxMcA3Q4vFc9Fz9sjIaRgkkHdkK2WLWzBpTeaYJhZg5NJMu7QyV8YmjoT2T0G86h4rIY2Z8rW3sbDh+ChGibI6oTvknGqj7CPeQXQPR45RrwZPvidaLb8iRAEQzWEwrZvUrODULX2X6P7koCHxn0M3xW91KGVWPP4Q8tT8fUiFKWwVNuI9SqLyv7fBbMCDUc6o1cMk2n/sDe6LCFJivr5ggNCjn27fxWZvY7jPLq2LACNAEvgrcRasv+Fv0GnMqieQp1a9opNj2A4zWdME3/hVF4giwDiSikldxRKS1OMSPCC8tvEHajeHTYQITPTuyi6mm3RjveFjhg1MhnGmJmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2437.namprd12.prod.outlook.com (2603:10b6:4:ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Fri, 22 Jan
 2021 00:11:59 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.011; Fri, 22 Jan 2021
 00:11:59 +0000
Date:   Thu, 21 Jan 2021 20:11:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <alexander.duyck@gmail.com>,
        <edwin.peer@broadcom.com>, <dsahern@kernel.org>,
        <kiran.patil@intel.com>, <jacob.e.keller@intel.com>,
        <david.m.ertman@intel.com>, <dan.j.williams@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V9 14/14] net/mlx5: Add devlink subfunction port
 documentation
Message-ID: <20210122001157.GE4147@nvidia.com>
References: <20210121085237.137919-1-saeed@kernel.org>
 <20210121085237.137919-15-saeed@kernel.org>
 <d5ef3359-ff3c-0e71-8312-0f24c3af4bce@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d5ef3359-ff3c-0e71-8312-0f24c3af4bce@intel.com>
X-ClientProxiedBy: BL0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:2d::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:208:2d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 00:11:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l2k3R-005EeE-SM; Thu, 21 Jan 2021 20:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611274334; bh=tg49lyOe4ndxOafM38vTTLJE13SGiijd8pIleDt2BEY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=K9P2KHk4yxn82P82PC9L6d2500CeYextiz/7teDdiW9XwR7k91AKIdsVuuy5SRLlS
         hC6X2IE/lp+wRCWeZG8L5wzrk4WuXCU0LNPWgyW2ryoQZR/tKeEs6M3pQECguufqLh
         fbPCMsPjxcETprvZ09ooUmmsh8NOrUohd8Vs/mHLULCKEVBtoUgmJh9+iZBITcXUfT
         eOj9Jq1Hab9TVqfqLuV6fcj6uB/NQrrjkS/E1kUSuanPrbtzF/s10NC1ybP3QsTOWa
         X/kIWTIThTyT2D2VsG3w78f2JTXGIBMAvKb03hTKgS/XYJhKibXVF5ubkYOvEuBZPu
         wpzSRGcKIejHg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 12:59:55PM -0800, Samudrala, Sridhar wrote:

> > +                 mlx5_core.sf.4
> > +          (subfunction auxiliary device)
> > +                       /\
> > +                      /  \
> > +                     /    \
> > +                    /      \
> > +                   /        \
> > +      mlx5_core.eth.4     mlx5_core.rdma.4
> > +     (sf eth aux dev)     (sf rdma aux dev)
> > +         |                      |
> > +         |                      |
> > +      p0sf88                  mlx5_0
> > +     (sf netdev)          (sf rdma device)
> 
> This picture seems to indicate that when SF is activated, a sub
> function auxiliary device is created 

Yes

> and when a driver is bound to that sub function aux device and
> probed, 2 additional auxiliary devices are created.  

More than two, but yes

> Is this correct? Are all these auxiliary devices seen on the same
> aux bus?  

Yes

> Why do we need another sf eth aux device?

The first aux device represents the physical HW and mlx5_core binds to it,
the analog is like a pci_device.

The other aux devices represent the subsystem split of the mlx5 driver
- mlx5_core creates them and each subsystem in turn binds to the
mlx5_core driver. This already exists, and Intel will be doing this as
well whenever the RDMA driver is posted again..

Jason
