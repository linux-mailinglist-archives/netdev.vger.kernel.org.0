Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD0D3067B8
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhA0XUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:20:20 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5636 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbhA0XR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 18:17:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6011f45d0000>; Wed, 27 Jan 2021 15:16:45 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 23:16:44 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Jan 2021 23:16:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tp/wZ5KQdwRVvZ/dYJdejNfwXhUroWD6Qu8nopp+aCfIT13ZL4UOm/2fZGd22cVeN9NTzD52nVskNtO8P2TJ20Un86nZl5e2mLH8B4F4OwIhM7D4K2roME8LJV/1Nt7b27p33+o+FOIXkzcQhi8siMaxm9BipDlYtHSRE78deGCGaZ12nU4bde1Cdlr7yosiy/SshOfbQy90mSM9E9+oeVsLTishAXE8abk34QzJl7cIcDr0/E1hXCfpOiPh3Z19mSG3JVON9LLaHQ8TCDmCE/J1iaxvkU0g4Vr7koZJkHzasYbkttucUnztqMF6/QodEYm1PZxl9eSReWPQ0RB1rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhT9AuE+3d3BiQZPxdM6+fgbIjMT5lgYfPlP7dTCPnc=;
 b=GsnzV7wlx4gRPqfy3wLeTo9+IisWs1ra8wSbp5ET6KfD+jNYv9YjTvOE+w6h3myzDJpb2yJ3OFhM4UGCjbd/V9R8//NO78Tq1hA0yNTca93ALPS75A7Gi3VMc3R9qbj9no4E47I+5W/T8wJ+7M+53xoXplK39yFDq7cMbQ2GFLxHXYiMyXiyMmJo0rLk1RWqdvO3oBTjs3+E257bN6XBjj+cMhaUuQb7hXzvoRYDH+r0ZcRkemobZTkmi8NWHDhp8coKW36ELHjyJt7oX7tNYmCuwrxqeOHMQJdvy0eaQvmXsSl+38mWIZNmmAlCY6pYmYoFkL/aFxRRZgOPkH16UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0105.namprd12.prod.outlook.com (2603:10b6:4:54::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Wed, 27 Jan
 2021 23:16:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 23:16:43 +0000
Date:   Wed, 27 Jan 2021 19:16:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210127231641.GS4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
X-ClientProxiedBy: BL0PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:207:3c::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0006.namprd02.prod.outlook.com (2603:10b6:207:3c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 23:16:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4u3F-007qeL-Sg; Wed, 27 Jan 2021 19:16:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611789405; bh=qhT9AuE+3d3BiQZPxdM6+fgbIjMT5lgYfPlP7dTCPnc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=mJ/LXBnngIhhxVogNXBVre+e16yp38FdkAnnASK6LZN4im4vYz+7XtAU4X/jXcGGp
         JKF1vk8VBJk2Bq4yD2E5zgQDDCLtRDEoQBtfclK4A42+cHnnBB1LICsaC7m6EAha3R
         M3Yga6HGdA38q4IfUUSWZk2PkKyccqOxJ99hVTWikJsW1bF691GEYh8vaVmRJxXPWq
         CMBu1QkINOB6opPDH6t+pcltYJh1I9w0Y5BcM0smK272IlPt8CQ88lri+MEkE+jcPF
         JSvjDEeYZk3RXLDhXzfsjibm1jBPzN2apXJ5qVP5SZ8tyfz7BRsgHkWxFzIgroU1hb
         bcAj7YWvmvRAQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:

> Even with another core PCI driver, there still needs to be private
> communication channel between the aux rdma driver and this PCI
> driver to pass things like QoS updates.

Data pushed from the core driver to its aux drivers should either be
done through new callbacks in a struct device_driver or by having a
notifier chain scheme from the core driver.

Jason
