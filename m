Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81262302B32
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 20:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbhAYTKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 14:10:54 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16688 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbhAYTKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:10:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f17700000>; Mon, 25 Jan 2021 11:09:36 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:09:35 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:09:28 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 19:09:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/4wBZxEjB4zGcP741SuUOuoo6eayOi/RYxrd2DdSUSRI6Knbjsj9V8GRoBaMATCr0x0i+lJSXfaEvwx1rgyWwFtaiKkwHfyuZ9vi9pNcoEBIJyxvyBynf18I94P0V/PE87W6A+as9y10v5LUD5Wig3C6FnStI4ghCM4uWp//wroEiYWjvbbmBWpHBxWIHeATGwt4Wzh/rfnowMIgQcSUHisw9UWYhXx0wiNB4w23M5tgKwCmnLBcXwFfpsDS3u9M7aH+zHtbRHk+CtOp91v7wn7r+y7bEWfpe4NxN81rUR3W/vgup02CVP/DfCuX1e+lmHAt3Av5z+lwle9erEZ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pABo+Vp1poNCDyyXRHs/mEbDRfxMu5RVsZ3daU61PRk=;
 b=RFWmVmfLat3fLqGHTneLazroGEnId+33jZsCqcLa++A4ItGGlNrn5whjHfRLyH6LbJdEFulckgft/PYzGn6/ldngRoNaZ3iEupCCEwNrL4PPKhi18JywCE7dwGFFA9u+lzslOZj0ugW1+5ToGoGWLr8J5bdME3Izs+a07dpCCCa0ZTeNpm9/wV8DbEMxQAv3kFiUOkRQk64hM/KH53o6M+ijDhWJVdXWEkqrQSCNa7vwrYhXN7UHdwxO5yPGqv7qcRw9HEtK4khQKcafNApU1rXwOEqUt1zm5SvYnzNejSDkr8pM/quR2b/zGItCy6R76LRMd4SLDGyl7pnTrUwEpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2437.namprd12.prod.outlook.com (2603:10b6:4:ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 19:09:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:09:25 +0000
Date:   Mon, 25 Jan 2021 15:09:23 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 04/22] ice: Register auxiliary device to provide RDMA
Message-ID: <20210125190923.GV4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-5-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-5-shiraz.saleem@intel.com>
X-ClientProxiedBy: MN2PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:208:120::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR10CA0019.namprd10.prod.outlook.com (2603:10b6:208:120::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 19:09:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l47Ep-006i3K-HU; Mon, 25 Jan 2021 15:09:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611601776; bh=pABo+Vp1poNCDyyXRHs/mEbDRfxMu5RVsZ3daU61PRk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=SqPZezi8ofhtC6cdfI2/rPBJkO2GeIf0fsEYsI5ORMbvuk+G23T6zj/oglQ9Rz5Px
         UizeUBjHYj7hugLpec5saq82lEdKgzv25gXKPm0y3bn3ICi/PqMlbdfoWW6e5l+jUu
         S9IJ23qC/X9BpsQDqOIYZ5GZ8aAUQSWbA9PArxQgAX9wUzbY9Cqcy++M9gg/hE+t4R
         tqxDZSfHn9QkX3kGzRfthWsVvfY3GU4L9s+0slY/iPx2ew9Xs+teWAgDQ8r/yAyFV2
         MbQMBmSQUS4WcHJwRZtJ0qcq+Q/zLiWPtoPLLfy++Edi8iTWfP7dVHTjGycRR1MYD6
         wbTaAoDtDLR8g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:09PM -0600, Shiraz Saleem wrote:
> +static void ice_peer_adev_release(struct device *dev)
> +{
> +	struct iidc_auxiliary_object *abo;
> +	struct auxiliary_device *adev;
> +
> +	adev = container_of(dev, struct auxiliary_device, dev);
> +	abo = container_of(adev, struct iidc_auxiliary_object, adev);

This is just

 container_of(dev, struct iidc_auxiliary_object, adev.dev);

> @@ -1254,20 +1282,37 @@ int ice_init_peer_devices(struct ice_pf *pf)
>  		 * |--> iidc_peer_obj
>  		 * |--> *ice_peer_drv_int
>  		 *
> +		 * iidc_auxiliary_object (container_of parent for adev)
> +		 * |--> auxiliary_device
> +		 * |--> *iidc_peer_obj (pointer from internal struct)
> +		 *
>  		 * ice_peer_drv_int (internal only peer_drv struct)
>  		 */
>  		peer_obj_int = kzalloc(sizeof(*peer_obj_int), GFP_KERNEL);
> -		if (!peer_obj_int)
> +		if (!peer_obj_int) {
> +			ida_simple_remove(&ice_peer_ida, id);
>  			return -ENOMEM;
> +		}

Why is this allocated memory with a lifetime different from the aux
device?

This whole peer_dev/aux_dev split needs to go, why on earth does
peer_obj need an entire state machine for driver binding? This is what
the aux device and driver core or supposed to provide.

> +		abo = kzalloc(sizeof(*abo), GFP_KERNEL);
> +		if (!abo) {
> +			ida_simple_remove(&ice_peer_ida, id);
> +			kfree(peer_obj_int);
> +			return -ENOMEM;
> +		}

Put the auxiliary_device_init() directly after kzalloc.

Even better is to put everything up to the
kzalloc/auxiliary_device_init() into a function called
'alloc_aux_device'

Then all the error unwind here doesn't look so bad

Jason
