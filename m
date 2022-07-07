Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7AE5696E6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbiGGAas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiGGAar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:30:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257981F625;
        Wed,  6 Jul 2022 17:30:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aekw9f+esVo/a+tUXwpGNCY1g3eGI5Oa2yFNQstuT0s871Ai+T1zs6+VvS1355it18Lm06ZynHkmegd2HzeXw02H9QoD/7Z91mPejThwPeGboKA/8pLwnAX7GXeahP+/mNu7Q19+g/tWggzPhlT+clOrN4F1KDWuA6y0t+IgktVw4C2S+Q8J9R0WcLtzzzn1I0+Vq2dYwqS5Yobfrr9qxvDkuQQg0I1k8x8IXzfTxlj+KDxiygE0O7kwysaFLwqFkeVKKq6TcLXRd8vLBxuzAt8lMy3p0BLLYr+n4cMFvjooaSd/LIWN8iKn6MavsZHBvpvFplZ5Z/Jk5gRLBxcXCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCC8fv74HtwHd+cxKqdnuywGCYBXDr85ieWQkC9l7Z8=;
 b=DB7glDNIa81pchXzRuakOkbr+7Zc1hkU0ck5HszePXcFegBNx0MLs+GdpjX0mEKBdmD2pQ562OxuVzhUytPTmstSy3OJbVYFGo9NidP0m6XNzJKYHXkN4O4Kdzi45qlzP4AUViGfF5ioCKpHSOlZfUuaF7C1lZDjGBtrbgXKXoAuX3dnf8fcHW4C/QxNsbKI5o46gLdyKNWL4WguCRr5Ox30h9umr4P4wWym8eyrDtIRNH6kdCdcGsj3jHvrjbwawS+MC/dfJtcFLn4s4mBNhu8w3g4+35GPhm37Ku+YYPi6A732L1V15rr+873YQ8vJ8MFN+of54X4D5zGQiYbZDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCC8fv74HtwHd+cxKqdnuywGCYBXDr85ieWQkC9l7Z8=;
 b=N2SR0Fi9EfMxy4uhm5AaxOZpxmSTEOjm7/eKXXP58R2QydNVBUReG9NJN7hq0AdtHkOASRbtv5pzczV24EzRtqkU0IYxsYC7Uv+LXYsfnYPTlsR72tkmdn+9139AcVDhfppQFasrVUr+KTsjlrNg45Cj9sB6zi/lvXwkvPFwWQREcwWOKwvGm8k1/KXshF9Nv2VEuQebChXTb7TFKQnLUEimY4aD8KUr7W3bVGngtDucaLRPqBtB8eq3JLc09tpyTc+puArlynRpdDNj5qS1/Y1IO/OfMDbgw70ExS5wBACxpoI7uP0nV0BLHxDHzsXH6UYaPn/i0W9PsnwmJk/1nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4580.namprd12.prod.outlook.com (2603:10b6:5:2a8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 7 Jul
 2022 00:30:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 00:30:44 +0000
Date:   Wed, 6 Jul 2022 21:30:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V1 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220707003043.GA1705032@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
 <20220705102740.29337-4-yishaih@nvidia.com>
 <20220706171137.47e4aa10.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706171137.47e4aa10.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7537fd2e-261d-4d75-d14d-08da5fafee00
X-MS-TrafficTypeDiagnostic: DM6PR12MB4580:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tEOUmJ/g0upHBNLx7HD+XK3f8IHVmUWxdXAac3vLg2mupdMPVF/2bWuW8SPkCGHw3ERrojf10THq9OEEAPFEOimCFqmOmPzJ7ZpVqABFboov954oXZkPFAg14i/g9XO7v0YeU9TSD3C96XlPbm+eoX33OfbY20tMTnCYJkTYQz+cGVqRU6HXzNHCEL1qS5jwDO6U2U2R53l2cJh2e2pa7fC2QE5RWjLhTNpqutE2/WsjW61avRCs9zsGXH4GXqxzctWGrfSJYjY/l8aieGd3m4Q0sPacB9ntrsMWB0xkfB3zH46jEu/F6NudT1qjNyLzBKHIulKnXPFthrvHvNDjwCJdyNA4gzMb4exOuseYX7KKIPRHFNayZNvMAygnxTeLGdztTSKYDg2LBYpnFtkv7PR+dNKUXU/QQ2SOszkpV27faPELOi+LPGeACSUosG6UOmuQZCMojsoe3nb6QslvH78pC6t+U9iQMWtTp375CW1f2aHQ/4/g34wYkO4FnWxfiXQkSSKMMKiG5vHwlOTB5Unf0bbtMlELcYHQgILOpX1VDWMb6g6GQ9P04cNJNuy3/l7k47AbRrA4+4OIrwYQTNemLdU8USG8Yy+OSf0a96p9jV5v2+E5FB527twHorXuqqSBwlXiZ8YnYZMEqCPnZNxTsROr/yNnRt1Z3Nz0uVJNxFi/pVjeNGjVWHnD+vaT6hTj+pldfMnRWzMnJ6ylmI5J5WBCWFvdyDA3b5druD5mAeqo7S/GbOadW/jAr4no
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(66476007)(6512007)(66556008)(83380400001)(26005)(4326008)(66946007)(5660300002)(8676002)(2906002)(6486002)(478600001)(41300700001)(33656002)(8936002)(2616005)(186003)(1076003)(316002)(6506007)(36756003)(6916009)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bC69KeKd8dKnfJdF08naAer0Dv1AIWsAMfVJiSeW72bTuvwYITSZL5R82rQS?=
 =?us-ascii?Q?VLu+NLaWoS99moXG0bDTyv9SRHBN+ba8sLLedfRKgJyTPZD/WYD02B0l/boS?=
 =?us-ascii?Q?BYY26uGFHZSodF1lMcJ6cd9AbAVZKuogEnjCATHJoxDAbfB/5+IwvCMlL4us?=
 =?us-ascii?Q?LCjiUfOsE5EnNP76ILUAiq+yg/wEdFQR9+aoOrOlzvmUd2KAc1t6+y5ckCm6?=
 =?us-ascii?Q?2G/oBXypHvfRNK5lJW0zS1n09YE30ovwGuiThW8nTgu92jx3Vx6QaSRo6pLP?=
 =?us-ascii?Q?KJFa6edKaZ+wepFQ6nQ0ldMhi5sZioO3evBqN67jEy1c2fa5/e56FW2c0xl5?=
 =?us-ascii?Q?w1m3c4xJJV7UAmtcJbaiQiTagPG+T9G6twKAzthWOfntBsqGVByg8R37KPQY?=
 =?us-ascii?Q?e343kfnYkFoUjEuBbn8cV3busbdZhf54JdEz+DO+C5tl/N6eBKQL57KRgY0M?=
 =?us-ascii?Q?uqcKUmv/x1+Qk5Y/1Vs/3UqUC18zCpmxwhaCrtMqmgw0A37VYb7vna+HtAWn?=
 =?us-ascii?Q?r87rfYnqfWPqeBJ8Y25IhggbvagJdFgWoocaq+FEEjDSQFfMaVGkg1bu+g/W?=
 =?us-ascii?Q?kfNtpwrjLQpyN3LicFxhhtzLt+pwttl7s/50+4a2VfjZgO19lKP3y2nw0ilx?=
 =?us-ascii?Q?CYl+qrgcWN8HnZm+iKoB5rdeR+sUx/h2iI5tuKKCsqHI994wnwVC0OpeUJKM?=
 =?us-ascii?Q?qrwHkDcxfV5TSPaghYCR00zbI5kNoM4U69lpRojOX1GeInQysNuDm1sIm1tj?=
 =?us-ascii?Q?/O7IMG24HLm7Uj96OuyrnE5z+5EXt0TE46V/vtUGqB8sGge3rcWdM1WgLt5n?=
 =?us-ascii?Q?r/pfu41DUmhvdbdjwRj41QhDIz4hjNoVDiENEuJ1Omlhko/z2nxtkpG4tOFy?=
 =?us-ascii?Q?PUEAPdliK8fbvAQ/5wOJT8/612iTyWdcqPCPkqjTScrvaGhOnA1+Fec3Rk5J?=
 =?us-ascii?Q?asto9jp2X2FUv60VEPfk7uE15vQaEHgT/JrOLqN84asS1X5Mpm6CQKBq8hkT?=
 =?us-ascii?Q?HLtJYXaQjHHjhGULHSv7WpJxCu4gueczRIxf3uZYe/BSb1tf3SDMHx7I31Td?=
 =?us-ascii?Q?EXWg0qSF6T9iHi/lYzYtFN59HK53T6jP6+WhsH0DW60L1NugmvKxO78k1d+W?=
 =?us-ascii?Q?oHSTaBfYmefN3gwmwtkgv/B5I93sS64LwZ5MJkpU5pcVNctkO7pW69CZeO+N?=
 =?us-ascii?Q?19zakr++v5wobRaC2wyv9Fsxdb2zIy3O9MU0tBSrHiHrIJDVxXUz3WSPRhZW?=
 =?us-ascii?Q?uCJBfML7+CIwocGnBbKkx/WU+3hdIJmhgKfL1RRefxnRr9lXfA5bXEtz/WGu?=
 =?us-ascii?Q?myk5BSwvdeI/4eO1CB6Vhnf4dwKXoK8uqf9j6AkqRyBDWJ9iUX/TyOajyt3I?=
 =?us-ascii?Q?LLdpc03n9SNUzWH6KrSyIe6MXj5AoTPglPD2qgKEE+hb+Eu1KgKBcMnyfYV6?=
 =?us-ascii?Q?VL9Gfu2+NczRyR5OZFKDcuieiJB16nmwld66Ywb5BqpN9GKtl4Teg1GREq7a?=
 =?us-ascii?Q?+QOmqkl0ek9sGqLz6P39Jl+EZyXfrYtCTYQJBXBnhx2f4SuVPyOqLPiD9Ese?=
 =?us-ascii?Q?NrngzAkpWdRKgmdZwt2x8On9tKSuL1qG/NFP4+jN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7537fd2e-261d-4d75-d14d-08da5fafee00
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 00:30:44.5010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXyHU8vBfAvR7R2BCFVuQZjtIZx/x4I1JZYcni8HJ5fbl9gNBaAfy/aolqEnAWOA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4580
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 05:11:37PM -0600, Alex Williamson wrote:
> > +struct vfio_device_feature_dma_logging_control {
> > +	__aligned_u64 page_size;
> > +	__u32 num_ranges;
> > +	__u32 __reserved;
> > +	__aligned_u64 ranges;
> > +};
> 
> num_ranges probably has a limit below 2^32-1, is it device specific?
> How does the user learn the limit?

The driver is expected to groom the provided ranges to meet whatever
limitations the device happens to have. eg expand to fix misalignment,
cluster to fit in the available tracking, increase page size, etc.

The next patch has a small algorithm that works with mlx5's limits.

This way we avoid trying to explain to userspace every possible device
quirk.

eg if the device support one range it should take the lowest and
highest address, fix the alignment, and use that. If that doesn't work
then tracking isn't supported in the configuration.

> Presumably new ranges cannot be added while logging is already enabled,
> should we build this limitation into the uAPI or might some devices
> have the ability to dynamically add and remove logging ranges?  Thanks,

If we see a device that can do dynamic then we'd add a new ioctl for
'add/remove' ranges along with a feature bit for the capability. mlx5
doesn't support that so we aren't adding uapi that isn't implemented..

Jason
