Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BA52A8885
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 22:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732200AbgKEVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 16:09:56 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:23934 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgKEVJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 16:09:56 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa46a220000>; Fri, 06 Nov 2020 05:09:54 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 21:09:52 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 5 Nov 2020 21:09:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7Mm8rjmSxgUjiEKPG+2C2ztLxyMxJD8g4JqIscbI9IcVuiOymBJ9Zw2OceEa5XQcmqxs+FSZsHWqgUBBwM5NmaLj0t3siT/KUrqUrfWlj4ncLFilLUjo5ulfN3CSt/+/bcOJgIPF2PDsutbCCBDduc/WtiUCCwMx2tkYSG1QpGqFVw8NAkqZGkUMxUibgxLMJh5CwyvLZqtaRBb00fUMnOhiWCfQvwziAKDOGnhy5zGJUSQ98BWM9s8yJmuWHaD0ayVq8fc8lZa+BiR43rsjYo3jgmNoXY3hITse5wwB+nkxxIPRH6Hkoea/U5axI+YNYyxPbEHoUjwd5TsCEZVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTpSXDMNYpq/ZlPjrRPFdXrTNx19FUH06M+gwR9NKyc=;
 b=dslCMAGAOpYGxSqUDx40LVedgBfzDAWlXCqsEo4aE4mv6yMMl4yMhUaaoYI/wiuT1dCgckj6NIyVc6L/jp/GOPjrbs0fDkRx0BpT10MS9HLlDBbRHSFv8+W0F6fiDxvtxDPoN3G64CZCy9iWc/wF6USUwMazba1nc0ntippw44OPuBRkrnz2dmgbjkAoqs22UZtKIM9MEsyXNxLc+vPwu+4XDLr8VN7LFJBc4PbDX/PIIOyrtlVhUk496fg2JRWZszUrA4M7Lbog2/bbHaGxr5cK4DBkBVxULRzs+aYWOglE8xX4W5myAAipXwM6FHC22DG0vGaVz1zSWpQJRf8vnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3305.namprd12.prod.outlook.com (2603:10b6:5:189::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Thu, 5 Nov
 2020 21:09:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 21:09:50 +0000
Date:   Thu, 5 Nov 2020 17:09:48 -0400
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
Subject: Re: [PATCH mlx5-next v1 05/11] net/mlx5: Register mlx5 devices to
 auxiliary virtual bus
Message-ID: <20201105210948.GS2620339@nvidia.com>
References: <20201101201542.2027568-1-leon@kernel.org>
 <20201101201542.2027568-6-leon@kernel.org>
 <d10e7a08200458c1bddb72fc983a5917daebc8f1.camel@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d10e7a08200458c1bddb72fc983a5917daebc8f1.camel@kernel.org>
X-ClientProxiedBy: MN2PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:208:237::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR15CA0052.namprd15.prod.outlook.com (2603:10b6:208:237::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 5 Nov 2020 21:09:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kamVw-000OcU-51; Thu, 05 Nov 2020 17:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604610594; bh=UTpSXDMNYpq/ZlPjrRPFdXrTNx19FUH06M+gwR9NKyc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=SUx0ceXcIW2zyJzHeYJoQGPTM/viv1DoGfTPcR0+or2v9digYGZK78iY9mTNpmef7
         eUtw7hgBMufh50UwcciJQ8V2m7eaCVfamyaldJ8oynQvlS2KpW3k6O42mi39+Tjz28
         EgfhLlS304zbVNNTXO4RlSkKNHCUCZLAmD9Wu7k3z8sHagGO2c0AyuUxtwgMGqg+Tv
         sDF6YnUQPt9cLhjFOB4x1uUNGN2qrHxOc9wiQzSsAI3U2RrNHywHlSUvRv12EAd5Y5
         MhrzRRKuj94zXBaNHtf1YY6rZP9GT6oOgpknv5oJu5B4Oda3hgFQlqRy9g18EgdqIH
         CNI51dBK3rr0w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 12:59:20PM -0800, Saeed Mahameed wrote:

> 2. you can always load a driver without its underlying device existed.
> for example, you can load a pci device driver/module and it will load
> and wait for pci devices to pop up, the subsysetem infrastructure will
> match between drivers and devices and probe them.

Yes, this works fine with this design

> struct aux_driver mlx5_vpda_aux_driver {
> 
>       .name = "vdpa",
>        /* match this driver with mlx5_core devices */
>       .id_table = {"mlx5_core"}, 
>       .ops {
>             /* called before probe on actual aux mlx5_core device */
>            .is_supported(struct aux_device); 

This means module auto loading is impossible, we can't tell to load
the module until we load the module to call the is_supported code ..

Jason
