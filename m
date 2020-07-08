Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C368F219442
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGHX0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:26:17 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13363 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHX0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:26:16 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0655ac0000>; Wed, 08 Jul 2020 16:24:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 08 Jul 2020 16:26:15 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 08 Jul 2020 16:26:15 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jul
 2020 23:26:05 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 8 Jul 2020 23:26:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzTi0I5pmlMPuDqxhTpLAVbmgiBFlMapgPY7MuijmYwQbshcKa7B2JQHABNnuLAwsRYJ9kNNd0BMIhUN3LuEeuS8dLRUpvMBQkPUIY4K9Q0dq9MqSqmD6BtFU9xC6rQ3vsK3fG0ndcuMXHXbkKw+8KoliJQNffUN+re75NXfYCMisI1fDNNSxnhyGSKZg/tSFwO3uvn1wlNJM8Kzj/3iM4XSS7kGvCGvw4rxHXDDqrc1ShZDqyDfEz8AwsMX8OGWYSAZF+BnzghAQ5QsrdqTcipMp+0ebFZgOJcmJnu56/8CMahUVejOCjPCEYUiwDpyE4PrhWBMHr7uhuckAHZ3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wk4JZYMtC4cLUrF2la0XEwWSP85bdzx445RLu0DN4Vs=;
 b=YAMTNaQhINAJ4Mj84oTHyfk3GgW3uDcYmpEDB9SfrHdgz+8nou+X2S0e4pKVqeO4tE4fvQ5lwhDUv/8erpRBcUv0KHkXgYCxBIN3NxXbD8+sHD86bzgZ4zbxAItx5gpbxuzJwlP67RpSVlx7B/1JX8XCxuIYPvPKzRi9gHtK55vjK1haighzIEJ84uJ545g8Pv3kDCBxVBe0X1WFr7w5jriB6OF1dlAcuHOwMDu9xrY6bEzFzv6+j2ym/tbP16wcelYWERMBLwfifktaXe77BuTbBvbXfcqtPyVUv9w2pxr1ky+eivEq/lwTSqMmpiwJb09CJgWEfXBGnsugthv3CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2486.namprd12.prod.outlook.com (2603:10b6:4:b2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Wed, 8 Jul
 2020 23:26:04 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3153.030; Wed, 8 Jul 2020
 23:26:04 +0000
Date:   Wed, 8 Jul 2020 20:26:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Aya Levin <ayal@mellanox.com>, David Miller <davem@davemloft.net>,
        <kuba@kernel.org>, <saeedm@mellanox.com>, <mkubecek@suse.cz>,
        <linux-pci@vger.kernel.org>, <netdev@vger.kernel.org>,
        <tariqt@mellanox.com>, <alexander.h.duyck@linux.intel.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Message-ID: <20200708232602.GO23676@nvidia.com>
References: <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
 <20200708231630.GA472767@bjorn-Precision-5520>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200708231630.GA472767@bjorn-Precision-5520>
X-ClientProxiedBy: YTOPR0101CA0006.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0006.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 23:26:03 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jtJRy-007MPa-E5; Wed, 08 Jul 2020 20:26:02 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b53b2ce-9af7-4fe5-0fd1-08d823964843
X-MS-TrafficTypeDiagnostic: DM5PR12MB2486:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2486E1D2EF2C6DE8897508E9C2670@DM5PR12MB2486.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mU9N1xBCbVh2V1tv1P/2RYtomtwVAlqymE2fOJajNocsWicGjvqgb293x6iinCOGLk64mreJh9jdKS2924wTSQWLdBZWOEQHdrJXvitSsh0iBiwhpcpclvhW+p38g/gLGFsj8cLFefk6mhsdmpqvq2znv8KFrVe8yKi+TQA5fRq+DoM81NXw4W+Tk3XhC4i5Wx9LzoMlcnFARpXvnL22cqrc9jPgFeLJIkFH+WN9aq4OkrignxeI8qqW0tHxUaqoOCSuit3mimnenFiuIqzxTw3eJNXO3eKuHzW2ZhsgqndQuBb5whCQ12U50c6SxOVNcZM9xbKjkwD+nms3RZMzag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(2616005)(8936002)(316002)(1076003)(33656002)(66556008)(66476007)(9786002)(9746002)(66946007)(4326008)(186003)(36756003)(2906002)(26005)(478600001)(54906003)(7416002)(86362001)(6916009)(83380400001)(5660300002)(426003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5UMwuWUZs83T6DDjPJl02827K2KNjE/PvWe/AO790OGKOMK/knzTayZ3yWJl/ZqfbtnHrbQHCuIj5GJn86v8vhJIN4eQEfHGLD83n5fC1OmOT+KLQ2z5m1JbcO62btmslUvq+iBOj1PxmuqRVUH7SIPo8vei1cjRPyucb4iu9vM26nJXr0Xzq29NJKrjpIeoyGHGLBdz1URjiggQYf321qB5TTiuEa0E09CiN9M2Inj7XMK5EG5tD+ZyhsC5jALM6jPwbxuAV155OWdFdIKjZYqKa+iVYMmSBa9p0iHyoN18yv6tKTFH5ixjs+Lq606vpvR1Xs9zH4ydJwSIgdFViMgjdzWfK/TfpbMUtGbmbT+hX7puJOnBlDsUmx3Yx6dFGqHsAE4inZeD8McAXApij8iBvAJwqV4ddgOj5w+mqw0NUWswL0ScEDQraFyWOXi3m9vohjNTa+2oUq9/mhpGwDRa2TsMS+0Fua3IIJtNP/h8I/e2ECOTZESPwp9E/h9Y
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b53b2ce-9af7-4fe5-0fd1-08d823964843
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 23:26:03.8975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: reR0tNbvvchH1ScM0gh3w7A4Pw6wmFZf+S9zmjyOsMoUGxnlWH/V4rJrJ1rKm2cX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2486
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594250668; bh=Wk4JZYMtC4cLUrF2la0XEwWSP85bdzx445RLu0DN4Vs=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=BHgPPiglu2uZ5WS2zGqro6ZpszuEA51NUJJm+fhp/3oSGjKmSad1npb08bnrPquef
         T6GFg1w8yjD/JqjtQBGEaauV9oYlrjZ54xNyQFPxB6d1WXYFBCBYqmp5SuTHpl2YIa
         lAmrYcclwATumfKHcIWLPCSCleQKgKrpKFhyzrECppbMDuz4V9+Khb+AzhPX3OdMko
         0ScXCbylN6j83DyqtDh/kp5vZB0pbmfuxbj226ms/7i/dr+PPAzxxi6vMABvbjx22s
         yR/o6gFsyiLGIQYCFyGCuOsLoZZ1nnICHVIyCcT9W9vkXioWgUCLtNij+QuNeiwUzI
         GqIgx+m5jwPfw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 06:16:30PM -0500, Bjorn Helgaas wrote:
>     I suspect there may be device-specific controls, too, because [1]
>     claims to enable/disable Relaxed Ordering but doesn't touch the
>     PCIe Device Control register.  Device-specific controls are
>     certainly allowed, but of course it would be up to the driver, and
>     the device cannot generate TLPs with Relaxed Ordering unless the
>     architected PCIe Enable Relaxed Ordering bit is *also* set.

Yes, at least on RDMA relaxed ordering can be set on a per transaction
basis and is something userspace can choose to use or not at a fine
granularity. This is because we have to support historical
applications that make assumptions that data arrives in certain
orders.

I've been thinking of doing the same as this patch but for RDMA kernel
ULPs and just globally turn it on if the PCI CAP is enabled as none of
our in-kernel uses have the legacy data ordering problem.

There are reports that using relaxed ordering is a *huge* speed up in
certain platforms/configurations/etc.

>     issues, it might be enough to disable Relaxed Ordering using
>     setpci, e.g., "setpci -s02:00.0 CAP_EXP+8.w=0"

For the purposes of occasional performance testing I think this should
be good enough?

Aya?

Jason
