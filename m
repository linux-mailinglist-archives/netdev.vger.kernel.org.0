Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385A82A882A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgKEUhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:37:05 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:25904 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbgKEUhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 15:37:05 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa4626f0000>; Fri, 06 Nov 2020 04:37:03 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:37:02 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 5 Nov 2020 20:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnqyUcLVRG18d1SrEC03wZRSObl5U0qtwLE5f90SGbYE0lUVhfhi+Oj+0YYWXJbjNvmkDnbmYRuSbHsdHODpzbZQhKMtoOeM27oB+FZQ1Omuh9TG07A4lBDzsduzII8lUeYuhMoS4EJQRES3e5G44PmkywOtwsOq6CBWlvwH+QT5dkIhvXRfbdDrNgvfxoGiH6fVsUdEm/XNowxetbjOI4W2RY7CZysvvI3PnC8R+cFJkboesaAXYJy+YDAmF7UmeO84XbskCvajT7hup7HGjEMwfzFcxWvtzcgfKk6jDTVu8SlG8zRZzo5a8lFrUhPmmM6rSJgJIbK4VUHkIH1/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xt+/BqP4eHKcUexk6gBfLRzpYUcgSiitWE/Ifm9Rjm4=;
 b=P8utTsyq1vbu3UfLkJFRFZcdPxu6fmmfxZUWqE/r9+PX4qh30pvApVySWFX63Rg+poOr4QkKsgLCvkl8ZKXqHjQH2l+i/7Sch/aB2UsgAMj/85b7c8owicTfuKRxPf7IsTj+lsLtpYTvEVE6S0/pnyhPg258INFcSPEg6njHj2Q0PEjANBbY5eEo4v3bEXPrk1/YGsg/TR0Z4ji8jOmHumsefZMlyinpsmJyzF8bVR4WTYm6OlUUC65jJUFTNWOcsZDmQmdq0OPWHVovCymUfFG4KLXnxGFQlHf/DC3T3Rl7qnVimD0hraYJmrJoQ6acyOyzcb5TrOj1diM9zgPBEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3114.namprd12.prod.outlook.com (2603:10b6:5:11e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 5 Nov
 2020 20:36:59 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 20:36:59 +0000
Date:   Thu, 5 Nov 2020 16:36:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        gregkh <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, <linux-rdma@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, <netdev@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <alsa-devel@alsa-project.org>, <tiwai@suse.de>,
        <broonie@kernel.org>, "David S . Miller" <davem@davemloft.net>,
        <ranjani.sridharan@linux.intel.com>,
        <pierre-louis.bossart@linux.intel.com>, <fred.oh@linux.intel.com>,
        <shiraz.saleem@intel.com>, <dan.j.williams@intel.com>,
        <kiran.patil@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v1 04/11] vdpa/mlx5: Make hardware definitions
 visible to all mlx5 devices
Message-ID: <20201105203657.GR2620339@nvidia.com>
References: <20201101201542.2027568-1-leon@kernel.org>
 <20201101201542.2027568-5-leon@kernel.org>
 <8a8e75215a5d3d8cfa9c3c6747325dbbf965811f.camel@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8a8e75215a5d3d8cfa9c3c6747325dbbf965811f.camel@kernel.org>
X-ClientProxiedBy: MN2PR16CA0040.namprd16.prod.outlook.com
 (2603:10b6:208:234::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR16CA0040.namprd16.prod.outlook.com (2603:10b6:208:234::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 5 Nov 2020 20:36:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kam09-000No4-H7; Thu, 05 Nov 2020 16:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604608623; bh=xt+/BqP4eHKcUexk6gBfLRzpYUcgSiitWE/Ifm9Rjm4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=NbrdKnIiqHTseiJQZ37HyN2tWIkD7tGkU6xCXTYCn0jRen1Jr5FQtZmt+2jxpEmAs
         zIcGrefQ1O6YEKDlEG9l8G7vaxjwwV6qyU8UXTIA3IRpJ2t0SRb+ffNpiDXMyZVxPd
         mJ9hyCkU81XLBqAdea3DJyp2VuIl+NAp7nhJsRzWMPA0MIG6VTys6VcbudQBZSF4dr
         73l6O5iGNuM1RVFZ0KNX9nmyeP6SqIu8PQV5tvRSvd9FUr4yLSgnliRs1CvNHjjw6J
         7ATmIiD6Pqwetg0mBdTvBaCi0+vpKgga3i3K4tRRFa/cOsnZgDzaKMYkv8zLNSqsQO
         /waoQ9cwS4+1Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 12:31:52PM -0800, Saeed Mahameed wrote:
> On Sun, 2020-11-01 at 22:15 +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Move mlx5_vdpa IFC header file to the general include folder, so
> > mlx5_core will be able to reuse it to check if VDPA is supported
> > prior to creating an auxiliary device.
> > 
> 
> I don't really like this, the whole idea of aux devices is that they
> get to do own logic and hide details, now we are exposing aux
> specific stuff to the bus ..  let's figure a way to avoid such
> exposure as we discussed yesterday.

Not quite, the idea is we get to have a cleaner split between the two
sides.

The device side is responsible for things centric to the device, like
"does this device actually exists" which is what is_supported is
doing.

The driver side holds the driver specific logic.

> is_supported check shouldn't belong to mlx5_core and each aux device
> (en/ib/vdpa) should implement own is_supported op and keep the details
> hidden in the aux driver like it was before this patch.

No, it really should be in the device side.

Part of the point here is to properly fix module loading. That means
the core driver must only create devices that can actually have a
driver bound to them because creating a device triggers module
loading.

For instance we do not want to auto load vdpa modules on every mlx5
system for no reason, that is not clean at all.

Jason
