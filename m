Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC772B6DB3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgKQSuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:50:01 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:4559 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgKQSuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:50:00 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb41b570000>; Wed, 18 Nov 2020 02:49:59 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 18:49:59 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.57) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 17 Nov 2020 18:49:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtMisV4fBZJKH08rzAKstCqWcSr/zG4f9+beX+fq7nNk3CP4Fi7S/HrHMI9nxwicK0B9NmbFsFfoimnnCdqma0nZBrRbeCqUqqlF/R2JoqsPgtoXhNmDF9Ado3CRagwZE0WAjOBubccKu2P7PrbjbdzSLk1XJg9mBJ4pDj41cGto6UHk2Sbk0hrUs8EBqrxvhcXdl6FvTCBPKptrCxxHSV2sJWDE5K5D+5lmSNib4ik4inn6fecQOBjE3zhiM8j1/cC6bQ8PkaIqiaaolLpiiueH8oTV3wo4l8ySShQEf6ucx/EHHLXtrhjsDRzo3kV0fy8KRaqqCOO3YgemSjir6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxE/dwKYOrtKL+Cn1M+FLPxUL8rolVVR71m49GzD/+0=;
 b=gKRzzdharfHwM2oceKDGb84oaYOZmdzcaGrXXDM/yWvp+UHAQI6OOY+AY45mpY8A7pWusuyrNcG67uhHpSpucgbeaFVQleLzPowJ9TQv2kZRDIHCkGqvHfahwlpNxD0ryj9H4AnzGG/M6Laj3Wq0gyrjH+JrJq4ZBjzO9PrCjCli60qtbqRtmDa5XlkDpNex516CqqvWohQjW7mjagKXGTT27saonFH3i6AL2phyb2wBBf9oxz29nTV2iqAtSGPshq2xOAs7d9pfDh7ixG3j7L9ewf0Oj1BeC8VYXKovQXNCC4h8Xn5+qdq59BMXs+7Ut5G1wa3ZUrcRpq4834xWvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2485.namprd12.prod.outlook.com (2603:10b6:4:bb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Tue, 17 Nov
 2020 18:49:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 18:49:56 +0000
Date:   Tue, 17 Nov 2020 14:49:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201117184954.GV917484@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-ClientProxiedBy: BL1PR13CA0072.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0072.namprd13.prod.outlook.com (2603:10b6:208:2b8::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.17 via Frontend Transport; Tue, 17 Nov 2020 18:49:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kf638-007Amx-Do; Tue, 17 Nov 2020 14:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605638999; bh=KxE/dwKYOrtKL+Cn1M+FLPxUL8rolVVR71m49GzD/+0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=N1C/Dhguy6gf7rDPKlz5Vb+Usp/L+y5l7RRkZSK0rgxHKvTDlZtjAKgjWr6oViwXk
         NVY1AnKfoKY5UDDf9U5JOZVPXPKhP5gs4xJO2TxXEZqr7tOJnUcbfb7EXDWx0TnPmI
         B/zQWCF9KhkpPH7siERtFNvGS1CfNxhvSvEMePGOVsDhk+ZKIYA6jssZhKXtOSiq4p
         UMIH8d/Clmdgn71JfXoF9P78xtQWZ3PLJqdNeAfyyWE8mt76JL6vdjmOyJVE7oqjkf
         kWIow18TfI6/cPHjt2sYYVqXJOLi3SSoWfRMj9+TVkAHe0zKmuHPIKX0nEAYjpWNs0
         2v0eLJsry/0xg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:

> > Just to refresh all our memory, we discussed and settled on the flow
> > in [2]; RFC [1] followed this discussion.
> > 
> > vdpa tool of [3] can add one or more vdpa device(s) on top of already
> > spawned PF, VF, SF device.
> 
> Nack for the networking part of that. It'd basically be VMDq.

What are you NAK'ing? 

It is consistent with the multi-subsystem device sharing model we've
had for ages now.

The physical ethernet port is shared between multiple accelerator
subsystems. netdev gets its slice of traffic, so does RDMA, iSCSI,
VDPA, etc.

Jason
