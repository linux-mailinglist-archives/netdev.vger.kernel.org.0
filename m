Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6781033815D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCKXVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:21:31 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:40225
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229441AbhCKXVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 18:21:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hX25lSLAr54t5CTLuevLmqrlEQ3yGQcsGtvjOZHR4l8ciNVVcMbGnf3lwoqu0pgRXWdc5/jd1n0S+kS1LbGLRx2nwRG+tkDGdQPzxXRKc8rcXrL59Kg5QOOrQZ8fJwx49pdox4B9AbI1PC/iQHSq4yfcPYq/rz8LCZPdxqlL1rs8hBXSAYdiVsPiHYO+6evSDwY/4T4vbD97Zp3sjl2s/V2J+Z5wrmv/1c9QnrZCpuPXBKyPOHmhUNxvUlkTkPT+CAPp6leQ+SkOyZbR5rWeX0WUTBnbevDshJfZQQIK2lYsSIlcQuj0wbW16qWBV1SmkTO9wgOIjWM1OztIuvinUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAecs/jSShWp3pVDVbFpfjflLAHy8jZiXlRgo5Tujbo=;
 b=VmIjugsSzQKOZJsnJrOVnGenJCBVn2IAWK0ihd0HgQbVdZcWNzgUbL5M3wAMsPHqaQKCZXIjNd/C8Z9gRgCXo85Pu3K8kK5/pTLiXqIiVVFvTmHeFm5XpdyPoAO1byUGS8+CPd6zQMNzYtQw77MBm9y1B2sAbPOOJ5TUDpBJ7EfFWe/P29DokULjc9nntVP+d8gIMGLxocKb0leMTSwQ2vyfNLBc7/ZOjRrLgYB+u9ltre2H6gGrr/7ymIKI7b5Yz0WhEFg8vQmojng1v+FBRY6zjbc41zaB4XBYjN+JgrmfXcqpBT/BLd35u38u4DiltQTAqsvjpvXNvDoZN6luQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAecs/jSShWp3pVDVbFpfjflLAHy8jZiXlRgo5Tujbo=;
 b=kjSukSRi0H1etOxPmw0dBDPtUm4/bVBBzND2YvKIBfE9duXwPWLaw/PVhlqXWPiN5iyrxOuBun7m0wN+fHbeuK+30KDBI+ziNYp+4lErhPolKADMGc3uSqYz4jxyJkELOlAZdL4BMsGkppwmPV1Tqogae1rgYQj75lbgvqXmxoy4s7UUcOGXW+aN5KDX01kxutuqzUeSrMrY7FKLLb3I3PJV08jsyACdb7EBpa0tFCE6jcS066FRaxIU043mjM+octND3x/38uaG4aoVMj9/aTIUEFVG75fDr4lBIGrH+M59GlLxEvvmric4IhGKe1/wLanfyIAi/WHz3aXhNdV7BQ==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BYAPR12MB2903.namprd12.prod.outlook.com (2603:10b6:a03:139::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Thu, 11 Mar
 2021 23:21:01 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43%6]) with mapi id 15.20.3912.028; Thu, 11 Mar 2021
 23:21:01 +0000
Date:   Thu, 11 Mar 2021 19:20:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210311232059.GR2356281@nvidia.com>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com>
 <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0119.namprd02.prod.outlook.com
 (2603:10b6:208:35::24) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0119.namprd02.prod.outlook.com (2603:10b6:208:35::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 23:21:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKUbz-00BZQq-IG; Thu, 11 Mar 2021 19:20:59 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d585829-8324-4f79-e395-08d8e4e4558e
X-MS-TrafficTypeDiagnostic: BYAPR12MB2903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB290393DE69D722A5A6E137EFC2909@BYAPR12MB2903.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqzPXN0t6Yi7phWCv1w7EpHZjaZ2JNvhocnTCNNRIU6wusGuXDCkc71RkXsrBVh5oBP/Cyobp1p94Xn7eZhVl0JQjLPjRWJ9U5zQDH+bDkrK8bjKj9ZedrgpSqEIJ/X2c7fyMZM5Y76VItd1t4lfYYxKELjbly79tp75z9s+rcmgZ2tK2jBX+E5Vt5WNRYSE8S81eakii68WMoq3ygSdN4zkqSkx+48l5RI+YsJwqifAa7wNKOFwQIQmfGtdDNJ+hWEiMIfhZyccnv/gJ353aFN9Lcnv/R+GdQzFml9wV6UolMr/hY3ZZP1jFlyCOIcS+CsniccV4ar+GWdFCGsWFqS5l6Uij4vwHj9N3Nrlx0ip2UV4AmDihEot7FNph9R67Rnv1UyCk9bJFvW3d4oHgF6Qh0UP7LGFFuMoVBxRMBcAo5o0LCNZzoxlKNXdHvjHblqyjvNhT7B/sqj5p35DrKyV14Hl3QeIAQENY+ldjDu60RGRo7hNKK/+gamiM0zXc3rl+5jfyEEE/GGt0t/elg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(26005)(426003)(6916009)(478600001)(1076003)(5660300002)(54906003)(7416002)(8936002)(8676002)(33656002)(9786002)(66476007)(2906002)(66556008)(9746002)(66946007)(4326008)(186003)(316002)(36756003)(83380400001)(86362001)(4744005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XioJrNw+ANEchsMQ/8yZNzEJQtEPUenPAVnziHvs5cGl1i0p+zb+laEeMzaK?=
 =?us-ascii?Q?eCNj87DXl+C5kKuN9vEn7QulQHt5RAYPE8g+rqxwxCJxF+NbF5yCpRn8hcSk?=
 =?us-ascii?Q?zBCrj9deih4DYP59PDT/zH9UWSyPQtZYkVuw6zkMWUphg0xtjaBkGu0uiupc?=
 =?us-ascii?Q?lzbLyWXXVPRYv1/XADyE50duWadFu2Y9eDqM0vPcd1IPFzJvMDAEESJcfE20?=
 =?us-ascii?Q?xkX1qMer1LDKbLdDJ89RMixDNo7B3nhTq5FY0YryyNYOoW7aJcpusD3u5O+R?=
 =?us-ascii?Q?LieUf37IDUwus+ayB1OA+1vA02yPSxPqNKyooeGp+ubG4vPIanrErGrtxGkh?=
 =?us-ascii?Q?1osWqB0cec338NlZXLYVFxoB3PNp/1bWJdLjUIF2zvoQWZlpYkB0oAnF0Wsn?=
 =?us-ascii?Q?iHYfZDTQ3MgArh3K8rSODONcndAiWU+wVfopITPJK/2Hi20yrYcyOZFdXaTo?=
 =?us-ascii?Q?T+t3WjoxLwAyiK6fT10eK3IQ3gd9o1HKvQ+k9BhYUNkdbkaL5xS1iKVIA5f7?=
 =?us-ascii?Q?cvOVIPbvVHqB6t/ZfRLFZO97uz4M9LbU9jQ37l+uVqIgbbO33VL7Tkiwk5mW?=
 =?us-ascii?Q?PB0vjNQTfKz216TbHDOROApzpS5gRm0xjX8uBRFA/4kXy3G214YKQTFQB5Jg?=
 =?us-ascii?Q?u6E/lPDIw+mdS1Cdj8o+CAAFeENqNKd08rD7VZcdqGiJAIwnIjlPO0JkAxGW?=
 =?us-ascii?Q?DXrbu9YbMD9GFXFuq5TJkIH/1B+3YNQClbOWbucRzEyWckIhgFdXwizlDwEx?=
 =?us-ascii?Q?dkpMEdUDafiIazZM1iyvA+r6+RmaR1Du+jzfUTha79PNlSWAJBG9V3PjWRh0?=
 =?us-ascii?Q?1PCrm015i6ZVzr2ZCEWEWL89wnMbxtYEhVeAZbWmVJq0fYV8Xw4Q7jrRfh1/?=
 =?us-ascii?Q?Aio9pRF0a/x+h0lEq9LQSsruMIUlD3gjVLdaKgjl2tV6pnn3fxxEnhWl+fV3?=
 =?us-ascii?Q?Rbm+1PX4VbsV6ytUNnPmQHE5KPLJpAm7wNMulVUF6OK31EmfmJ87NgzjI1Vl?=
 =?us-ascii?Q?oq64zS3BUfstL3rS8mk4l19zvHUZispJrIw+sO1pAi547RBvf19vmQF1x2s0?=
 =?us-ascii?Q?inpNOX14aZKcf87ymg5a0nKjgDGZBf0S52WSt1moXJEEAEaN4zNrSQlXdaW5?=
 =?us-ascii?Q?m5ZWwC55KXoxwGQeE9QP72mp0v2exLVcUNkZAuapoTPb316chkDRpaWeysDG?=
 =?us-ascii?Q?+3WGjJUD2qGHtZsbjCa8dlmjnCEUf+AQMdnYHQQtQqT1N4jXA/9xjNOOwBQY?=
 =?us-ascii?Q?sUA1wpUrJ+k0yT5+CBk5rPQFyB5psakDMaC5NFLiRoNLEx1+LkeRaVDiHTJj?=
 =?us-ascii?Q?/UCNtJbTN5S9zyGJOE0Xyxyr/AOWNM41Ufa9wrjiXYbaUg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d585829-8324-4f79-e395-08d8e4e4558e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 23:21:01.4767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXmTUhUSB3QT4b5pZLjGlua7xrA790LafiyRYom7DY6KQeDR5YRUCdTyGCTWZeEl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2903
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 01:49:24PM -0800, Alexander Duyck wrote:
> > We don't need to invent new locks and new complexity for something
> > that is trivially solved already.
> 
> I am not wanting a new lock. What I am wanting is a way to mark the VF
> as being stale/offline while we are performing the update. With that
> we would be able to apply similar logic to any changes in the future.

I think we should hold off doing this until someone comes up with HW
that needs it. The response time here is microseconds, it is not worth
any complexity

Jason
