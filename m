Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC15E356B3C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 13:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343669AbhDGLcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 07:32:14 -0400
Received: from mail-co1nam11on2063.outbound.protection.outlook.com ([40.107.220.63]:16608
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233309AbhDGLcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 07:32:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4Kdgcs3RkvZxKhUpvsUUgsCVMy7R2HNruWyCDHeX07KlbuQc9n7OA0ugqknk0xvMAAyDwhphG37Xzzhlyelh22ks3/9lQxEJhaghiW1IXCeI7TPHRcqmzWb+FkhMo+oel5pybmOIbL4NfsCLu+VZ2BXeGJf2yXD2C+c7+UZRrMnKn/HvkNSjELtRU2To1uOkKZGR4u/tpxI4aGKwmEgEGi53ScMmLugnfHIxA8l2+QAH4lI3p88uDc/AVWM+emu0u3yb4KdIpcYTR/MqDSAcwPxDSPtKaz0tiCyeK8KMTYaYo+ghu2QCHANCqf2N0ud29Gttr5MbbyavVp3E9zVyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAyVrG08zZeQWgnUDqtGWU0Gve9ZxcX8+umaWZqc8Cg=;
 b=npzvWkc1M5PFGqKGEozn5sfRHPrWjAwtQUf4+bzJ2bLdCSevSNuSzwn0HtdJMIKEIKW/ftdTBNIce9RLiq33XSsNrJ/R4SsIH1rlpY43hzO5cMGLR4/nw49T6qfucsmcjaNIpouBDsCvbpcvqS1Z+EDoPXg2gSbXOjkb7MTQv449KcNMz1N3ciiLwVPQwhXW84NCkyZ/N6Nh0MdjfUnlAj4uRqX6lNBaoKtdoMTpyJceWhnZGB0I5TzH7C0DUGQsskJjWhSnt4KACu/87GOio4unL5e445u2uqtbooRY4Nl01V7Qo5hfalaD9ZTsHwaP4rlzXBBEfyZ0rVGLaYeCVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAyVrG08zZeQWgnUDqtGWU0Gve9ZxcX8+umaWZqc8Cg=;
 b=hp0MafnvTIFAE6WIhJfLhf66iyd5LOSGnZukUvlSY/nquLqNc0gfAD+JPU/Kmzvlul88PACzqhiHYHQmQCk3kXyp1ZUqRmqGKRbleb7qQBxA8fhRVcXdDyuZLhVPqAoiNO+PO3xdQ9QZ+4lt+ZSUsTrh+E0paSGwEHTGyCzvgys6Hz/WjfU468XW2p/59XkL7TDqAEpRMEx3DB2uONTiHL+vqMc2fRDTIsiOurKB9OlkBS5a0XtxHQYEV6NkdQ0TKFP1vpqJc84Br22QAl3qBUXqwIcCec53qCN9ZrsGh5uerSc92sg21lWJorPsFcVGwXTscNVwO0zm/4pKPra73g==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4250.namprd12.prod.outlook.com (2603:10b6:5:21a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 11:31:59 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 11:31:59 +0000
Date:   Wed, 7 Apr 2021 08:31:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Message-ID: <20210407113157.GC7405@nvidia.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406231550.GB7405@nvidia.com>
 <be8b420a3fa844ed94d80f5a6c65acaf@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be8b420a3fa844ed94d80f5a6c65acaf@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:208:234::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR16CA0039.namprd16.prod.outlook.com (2603:10b6:208:234::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 11:31:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lU6Pd-001zfo-Uk; Wed, 07 Apr 2021 08:31:57 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a078c97-42dd-499c-e405-08d8f9b8c1b0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4250:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4250F63851E6C7CB910B337AC2759@DM6PR12MB4250.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W1Qqzzvs6CwwMyk5ppcVCINwpdEekyJnEhAcFBvt0nnpd9JJTjL4uuOMJSJnE8k1W12874poSSTpYP9obO6px4Hl1FXO24aFxisecthWiHyBWwf3/VrTNDLLOWIsWSz35n5Voh7exoMjUK6ZkoCySiPh4xEvM8fUdCd+kLDEfXgziti8QJUMV34AXjc5H9+sUs14zUMr1ctnKbp4ApXZM7cCNsmYvhsJlu4c0Pd8t3RjF58iP1WiVltb8LQYDCL13tAQGuWlG0O8v4Q3HgtKEmN+wTLDC/Ezo1VA86P9lR4Y7WvMGuPf6NpIEo6ogQkEN/1Mp0ZrPmUUaVH3VR9OLg39WxXbOCHs7yVWJaADrjpobGgpZ9oHjaZ2KgRSoBQhVR7P/k4irlayes4roilUh4ERXOnWFJyz24xc4uUdf7pzQgeotRsytfbFsMrwQ9DcjbqoHa7xUSGIE9Bz2j06OB7sn1muIW7Ee/FbEoHfo/fCikMnUErCtNHS1gX5z7t8B3monTK3w8siQFf2x/fE/yeOFANSweml48s0TpyzgkJCgbko5sKRsdhldj55pLBR9cz95Lj3U8hkrDJBdtqBUHCzeo7KLX7hcEixupNuPoy26yc8ATRBInJtDP8obay4MfObS/EmTasOTChHppjbs+fVdR4G26133zIQ6Dbp0VA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(186003)(4326008)(36756003)(26005)(33656002)(9786002)(9746002)(478600001)(2616005)(5660300002)(1076003)(426003)(4744005)(86362001)(83380400001)(2906002)(54906003)(316002)(66556008)(66476007)(66946007)(8676002)(6916009)(38100700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zBsvzkTLgXW3t/TCF7AX9wnPVpgxFsAVGNvF3INXLqALU+bKBxEVW3+sxmIt?=
 =?us-ascii?Q?mD5QGTdn80QZ2Fet38ksZ+Ys6weEiLsMj7zQhi8MR96K6YhZHf4vklvPKrJh?=
 =?us-ascii?Q?UIO8y03L0N3eiC3RvvE/5X0v6HyHMq12YYwn/DxTHpNq9/Owf9sFX+gJzjKd?=
 =?us-ascii?Q?ITejfdz3F2jr94P4nMcVThHejYpOQLCpD4NIWHUjiBcNHV36pIum8AgnSxf1?=
 =?us-ascii?Q?fcicr4SqKSRoW0sfYba3Vh3MhBB8KqUAs0g/pQfCqLcBe7ywQLjBYFJ0J5oS?=
 =?us-ascii?Q?bI+1R9FBLd5lzQm52mS7PC4peCpiAlJQXuZcvXBnN2vG7Vto2ltC/KNtaoMw?=
 =?us-ascii?Q?ZCQ4/Mc2yB73IZZNWGyH59HyRIM+4q/Xfd/21taxdiFa2sUxT76HkRThTy+o?=
 =?us-ascii?Q?cNrWPgKw3F89RI99vefRb4z4CWHWJy0YkEm7DQwhAPH4VMuSlgZeSMFda08T?=
 =?us-ascii?Q?PbzxtUaSsGa4HiMyVszqIVyblWZ4AmJJZBJucPVgAHThq0zQYXNTD4qZKZbF?=
 =?us-ascii?Q?dbUNnoq/ab84ZxAlKOOLRVMB8uvdTRqPq5otYT+AbYyGOsk/QNFEZFqgsCaT?=
 =?us-ascii?Q?k2wVLSBq4lVYMemDP8QUT+CNzBls1rn8nCORyRWk3sDEf8rg+ufQkIrewUPx?=
 =?us-ascii?Q?eHeIAyXEf56nmmgKQJgbE+e1XJiDEAPgqm1QE2jq4Hvc6POpwPiNcM7M70JK?=
 =?us-ascii?Q?lQdE91WEspbbfLjNkUtADQfZ4Mw/I7pm9P/7apEuxZ3ahKInhCLCmMDBw67v?=
 =?us-ascii?Q?FsSm8YSdhm4l/jbtZ1iDsqCh2AMVIkPut34KxNwBotDNqZ+a1lmWj3Jd8oc2?=
 =?us-ascii?Q?HARdSGi/vJSfXHIqQCN5bK4RTMBTtSuVtbKovUKclcP7x916fVgA9756esJE?=
 =?us-ascii?Q?/I5AdXYccLhY8pnl+AWUamkLFNcat9ZxH94sicLJzSA1UMgT8SdkddfsI04M?=
 =?us-ascii?Q?qj6Ge5qhJcnjor3PvX2sZx77FlDsAcEcWSWHouKYgwqnNctF6oKALxWAXurU?=
 =?us-ascii?Q?AQynhbWj1eNCWGc2elUzS6anSWBZ2SmXw8d3yVGr1Yq4nplv6qW1qpGlsfgz?=
 =?us-ascii?Q?xzbKnvARLgI6donyTMmz4CPoY3zqSzS+ZZ/6VdiukIA5gp31diYEIf7B226U?=
 =?us-ascii?Q?VOjvhtmmna2N9Dc/Mo6smUg7T+taESB+cHebj6aRfZIECryEDA7HSUq0VLHv?=
 =?us-ascii?Q?XTn77jO1hh8h8y9djf4mcm/UHl6EKFk4juf9+zt0Q6gyOp03Zr0qT70TDU+D?=
 =?us-ascii?Q?DFaoXGdu2EXx/xB5FeMZvCiM3+jC2iLVSFb2vq1ySwAaTNUm7a6et38Xudnw?=
 =?us-ascii?Q?lI56b9pwV7M2WtalNjMZa1BGfx8wLRAxYvYoT1HTMHGLow=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a078c97-42dd-499c-e405-08d8f9b8c1b0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 11:31:59.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Co9RU0UWWZ3b6y9FDy6SaH5tRiZKnqrKb3wfdhg+n9HxojJGMH7FGZHwqxrHi+hw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4250
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 11:30:23PM +0000, Saleem, Shiraz wrote:

> Hi Jason - I think its because I used --irreversible-delete flag in git format-patch for review that this one doesn't apply.

I doubt it

> I can resend without it if your trying to apply.

Now it is too big to go to the mailing lists

Jason
