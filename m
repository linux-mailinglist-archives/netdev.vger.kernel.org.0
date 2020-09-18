Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA626FEE9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgIRNmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:42:38 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:34541 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRNmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:42:38 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64b94a0000>; Fri, 18 Sep 2020 21:42:34 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 13:42:34 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 13:42:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gq2wGUnCkz+v+FSDXDc1jc9uoenXed9Q61jgYvDE1gYFBzOOIMWTiP+0VZN5IBi8P1WuL4fPLQixQST08OYpaMg7pUeJS8ZtL6ifR5KJ1eIT5+I5CwQoHlfK5ZvysPuFVUlCzgLreWmO7+/U8tsdm5X+ZEya31YRSf0Uuf/MzPebykgGbyhMZOTW2WBTo1vPja2mpDFgRhjrcBwrR7nj19tI4pMVzU2rVlRX1hUUNTuL+S4N5eJjykUhrb9TF4uE/kHQ2JIw+4kZAq+dOH/m4F/YMasgPqjl75o9ltVq8vvwQ4bN+1XT3E855e9cjNOf3NXll0sNNE4+3Ftc4HrqUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wB0icqcIAEy2UTyZ+wOdMjLZSCgmwSY4PxWZi/oAA9k=;
 b=VefIyAZrYw/660HCebXjFJGxXlnEwn48r7TT8k7iwAiVTy3NHgCujDbvHpwM2OUJcSjKPZSrpaSrD1CkohhKWb0AK2dFUL12ybPr9yjYsWfqPvrQoM1PjBbYRp8+HCyJoo7wt6iZ05WXz3SPFU4GSWCZGZbCSUYGIK+uWoLwrX2xAKvV1Uzu+7ifhs2ccXL9W+tR2yKE4yYW4A2iuTbbDUoIpS5pPGPhvR2TJRjhi9MjXRbMDv5+lhI2HW1VF9WUjwlPHrhuWS7aOjL67pzfNoQoQx8f4+PhmwJf6axYql2t8wr8NtyF050DMa2fuLseF+91HijZCKW9wposNxcR/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3932.namprd12.prod.outlook.com (2603:10b6:5:1c1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 13:42:32 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Fri, 18 Sep 2020
 13:42:31 +0000
Date:   Fri, 18 Sep 2020 10:42:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>, Alex Vesker <valex@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/3] Extend mlx5_ib software steering interface
Message-ID: <20200918134229.GC3699@nvidia.com>
References: <20200903073857.1129166-1-leon@kernel.org>
 <20200917181026.GA144224@nvidia.com> <20200917181321.GO869610@unreal>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200917181321.GO869610@unreal>
X-ClientProxiedBy: BL0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:208:91::37) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR05CA0027.namprd05.prod.outlook.com (2603:10b6:208:91::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.6 via Frontend Transport; Fri, 18 Sep 2020 13:42:30 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kJGej-001H16-MD; Fri, 18 Sep 2020 10:42:29 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd2eadbd-23cf-4e22-84b2-08d85bd8b0c1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3932:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB393245E755640CF61D1520C1C23F0@DM6PR12MB3932.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b6Zme5cJpo/66736RD4pptGEQVfC0ZTG3OxmaPws1cIziHtCJGCu0r+IXR1wJh5iqQt3hB46W4H0/czz0HdV4rd3J0zHrgkhfddyNBKWrQI0YVVxwM4G1UAW0CR+tq6TFKs4A9/x0eqsZSwFGbtbC6gjq3oBxnw39YlGVO9FWVRecdRa13Am27uBMdWN9ra6qus/j5VrecrDyu/D1hdRVnH8SSsXE4jaTGqST4docRA/z7DsT10hMhYVbENYKCwxrRVukqvn9s64PVV0ars1YAhmUiYVBIGfS1LTBxiBccv7U8hBYCG3JriyOOcLxw3eT2mMSTrDUtF8z9/u9MBBNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(9786002)(478600001)(426003)(66556008)(33656002)(36756003)(66946007)(8936002)(316002)(66476007)(2616005)(2906002)(4326008)(8676002)(6916009)(9746002)(5660300002)(107886003)(83380400001)(54906003)(1076003)(26005)(186003)(86362001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6Lsld8W5R4hRdHzwuYalMUZ1jMv66r8893gRYlsNanIR8QnzVnBIZO+HsK4961CwnY0M9D+Xshnpam0s0e6aZpX46mKLmRvT3qmg/wDIcH5NeCIziRMEV/xdwtmmhxOaBPc3l6Y+1+suyHkmDFhJvPeJK5AVvtLjyuiRMn2aDnG28rFwW8KaRYs/Ojmii9EJjpGAOWWL4GWxaqPcOM6YPzehRlR/ZOuZhVF+HjI/Ll6nRDsYhLrCH8PUyZK+pJYOS6Zep1PBAaCtJAep7jNzBJMQZob7U6BLkJsXZIhTbyuSntTjlggwLJbD3P4IeAlI1MqnnuN6bfGkRiUlMfR8PFdW9iztu3WxoBEb5xidhl1zFGotECXr3E55z9HTUq9P9q47H3q0wp0DGxgp3CNRXfMCAXqCDIa3UQaU0yeYJviXWQm9YsYU5hCBGqa/RP2g1O9TjPJU/B3rugYZSuAhlOnFfbRbh2+/gidtFVACxHjX1ILvHHfFyS4jy//nfyuO7twpG/Nq3i8CTDxKCT+yoA1gf0PhJSrUkWsZL+OAmDHfz31nDMXhQlVxX8ia3PH9qMDjkYDKT3/OQ9rKHPv2smFkIsefaUpwjifRDs5TrXE17fgMJvMvctPyibg7u55tzqavTky9Byqs5c+A1AvQaw==
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2eadbd-23cf-4e22-84b2-08d85bd8b0c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 13:42:31.4108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oK5t2VeQ7EtiIQmNccGNqn16DAyZwjNM3J96+kQVkU3UMG+up0ecOuyTc5PlvH3u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3932
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600436554; bh=wB0icqcIAEy2UTyZ+wOdMjLZSCgmwSY4PxWZi/oAA9k=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Date:From:To:CC:Subject:Message-ID:
         References:Content-Type:Content-Disposition:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=YG2hFf3orUC8SxVsPP9VNsBSVrU6k2uArIG60VbEPly21aRTyyxePyWiK+7tue1sP
         m21cBDdMH/yOmNJFfrQv4CDIO3nOUrTJ1+gKmsMMN566sSHqxh2sxvqrYteuYXhVpL
         GgxhvgHKfwgL51oP1Vb1fC+gMAFy2XVtUDOCddiA9CfZqvpZWw1+84pApcmvHAQ6jl
         f2c2zUTA8yPtmMXd/SoCBM5hVM/h+gbcnrq3KgLANS7AXHHOK+KpjTWL0WAnLJOy+R
         g3IJ8zs+dW4W39g1srJSrngJQTIf+JzoDP4ra8dJXCELF8y8C5n4W/gSRumsZyY/ku
         xQ0GxaQuMgpjg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 09:13:21PM +0300, Leon Romanovsky wrote:
> On Thu, Sep 17, 2020 at 03:10:26PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 03, 2020 at 10:38:54AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > This series from Alex extends software steering interface to support
> > > devices with extra capability "sw_owner_2" which will replace existing
> > > "sw_owner".
> > >
> > > Thanks
> > >
> > > Alex Vesker (3):
> > >   RDMA/mlx5: Add sw_owner_v2 bit capability
> > >   RDMA/mlx5: Allow DM allocation for sw_owner_v2 enabled devices
> > >   RDMA/mlx5: Expose TIR and QP ICM address for sw_owner_v2 devices
> >
> > Ok, can you update the shared branch with the first patch? Thanks
> 
> Done, thanks
> 9d8feb460adb RDMA/mlx5: Add sw_owner_v2 bit capability

Applied to for-next, thanks

Jason
