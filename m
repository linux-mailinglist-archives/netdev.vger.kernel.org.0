Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B3F57BC9D
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiGTR1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiGTR1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:27:23 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6082DF4;
        Wed, 20 Jul 2022 10:27:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUZ6lfOtJKS+yR21Z87jpilGCzB9mGRvWmN89FyZdKyNAigUV7HuM/pywG8xqRyWoEJ4sGqiaDKyvj2FLOYwDLf6LMSMe6en1jYAxZUHDrn4RoYNzhRLeBq9abdNz5um6xomHVKNXDNX47p2V8l3SybBbbJ0ljfRkrRJ3mswj+snQvF4BZ9DISAhDEpUQriytfO+a6sxXz/Xz15wtosLSrYwxMYanY2szJ71+LIJGOMwrQb2WgtwsRsPq7wi1Soy2B8/Ua0pTPmbwvRgcN38UpODexhYAOF1Gfti2ZDZbAQwtSUO0qbI+jRcyuBh6qEZu9mxMcp+x8Tpbkc5OSuJiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bzAgrgkznJt1kJ8Sz1TgUxul5AfZdqsxUollvAGga0c=;
 b=VbRKB4W3xjCVqKZy/PvpL+kCi63yYkcqW5GECmSXXW4+427+p++8o0yCrYI36//DBOozKx4WX95jIT+CHu/noQsiGj556+ee6qxQ3UAtc2u3RQdtHP2fjPydpBe29AzYqCeukA6Zq2Pzz4zGrLyMxBqnJOnWXVXQnApPGEbxjzngidsd3XWlLkfOzj/fpHPuaQtN8Xm2TCpvLS1abytrjW2+y4z9u5uIMEQvQ+/aCGAIV1JhdwZ+B45K+IDU5OAYtdGf67pbs8hjPNO8lrL0Ifvn8QAaHILGCd7lq6qoKipYj+FUpH+4B9HXW6d5tCD6VyoIRbEL7Uinh+uITfLeTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzAgrgkznJt1kJ8Sz1TgUxul5AfZdqsxUollvAGga0c=;
 b=Mzk76ed4pVF0YX0CoSZ8J963nRqLrsa2oq2sq/2v23cOCgPe1pv8CDAwPQ3agGhBBaz8tGhIgD3w9Q3seXm+OkWdTQrOUmK9eqhmEdFnnYrltXpJ1D4D1ET6/fdHvuKeC3wUif2EVEHLSogvp0zXIP5yeNeOMKu7FhnkYrq8xQNTSK1XToJj5aftU4V2JsS9ILJ14QOAyaQkY5ZEvle1I74zWQqtZzeAAG3Q2rDvytcDJTyrD2Zm26ZYZNTOlbkTjEEnxQtPHz0qJPThlxeVyievrKRzksFnAF00wIZauDgT41O3A/OSdm5WAUmRkZbSPCcKincP/DZxldwvYB7KcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3257.namprd12.prod.outlook.com (2603:10b6:5:184::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Wed, 20 Jul
 2022 17:27:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.018; Wed, 20 Jul 2022
 17:27:20 +0000
Date:   Wed, 20 Jul 2022 14:27:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, leonro@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH V2 vfio 05/11] vfio: Add an IOVA bitmap support
Message-ID: <20220720172719.GV4609@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-6-yishaih@nvidia.com>
 <20220719130114.2eecbba1.alex.williamson@redhat.com>
 <11865968-4a13-11b0-abfb-267f9adf3a95@oracle.com>
 <20220720104725.19aadc5d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720104725.19aadc5d.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:208:fc::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edb2bafb-bb1b-4cc7-8715-08da6a7519e3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3257:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qo8OwwrwflLFwFtGZ1gGk2lU+DFdaNkudFvuDNw9kDnzcGJZVddO8CABvo/uEgKxX/ewEBjTBaUqtgPQGWJeca5h5gFSNwUNZ39cYo0voLfGUuD9GtcXzQ6RrtC2/r+/G77vyJRF7MW//iYmr3WeT5OE9Uastnq4auUaVwf1MY95/tAA1W/Nuh+RqcyiIZTmojUkLI5xPn6X0EUqK2WZU2rV0p+Zo2jL5fHDHcx05yuqrumrMZPW4SpHwQP3M2/43emi6x9ocLoZ4Fi0S1HVqdJSpaUfJCsf9zOahO7/zaBauj0HVh55Zy9nE5v+cqCs1VQdYUC3UEUXaefb8Ltgdc15GCmPz7icXiq+VnagnvHObZQrqNmTfmNzJXTElKmRNFuahtNEz9CnT67irR/vS+VAl3LQtqKXF9ppmQ2NzG+ERy39ns4iCQzhybLIh9tZdgluA98C00tlbnpC0iCSX4M0I5bJ6PJ2HRaVh5aRxsOZV8qgQb59dBlcYdmx2EpGWP5FQKMntMKITSL+D1lwAEeRh/eYPMKSirS+FAvVGo2iIIrqWVWKu8m1lk4l7y3SWlVhF6K+vD6NAA/ZR15V8u1vQCnAWnIcHEBc1y6k0HnXprHPRgM4D9/RiQXMsDDFoF6AN+DTtdis2YPNSznfVUjrHOIKee+LiEaw2+F/MabROwkjZrnlHDX460zQyf2PsavGrlvTsqt4vK2fmpp2xxu5lStJN0zaaQKDpDTTQtxNVCfxsctXNV5P0L6tnoyW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(38100700002)(186003)(4326008)(2906002)(8936002)(2616005)(66476007)(33656002)(1076003)(66946007)(36756003)(54906003)(6512007)(41300700001)(86362001)(6486002)(6506007)(5660300002)(478600001)(6916009)(316002)(66556008)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3yYI+Xi7qZzVCkwF7Ti5P9rELmGBWvF6MTCn45Ylb0p7OX1sjXjVGETqjyqB?=
 =?us-ascii?Q?KTBewjITJ15naLvy58kWI97a2YGo2pgo1SqVKBFlSgymwhcvpYLzMXWJZCu6?=
 =?us-ascii?Q?sybfJjGNqgW0ayuU1h4yp9djfyV5jOYuSzvyktCziKlTYLQ7StkXy7cM0sDF?=
 =?us-ascii?Q?h3N77L6SJZ3kWjP438OH5H8AOBA3wPvc5pRPjSlL17urmVF/CM8FUW65okLp?=
 =?us-ascii?Q?z8QUKlsdUz1ZFGD4lAW5JIjpZupG+e3La4omnxiIUPDJ5HO4DPDVSDlktcod?=
 =?us-ascii?Q?9lXtep9BnSFIF3WR8a6emIiqnutSdSCzrbbGh4Nb0OSSN1c7rdg8QPtZI/My?=
 =?us-ascii?Q?noqYeCCbbiX1mZHWcK1ltd8PBnfpTef27bTer5vum8tT0HMe9zo4b2vvFkNF?=
 =?us-ascii?Q?cYsaU+KXyWtY3E2jYfC7FmF12GF3vbl2xPgfpGbZX5H6R96fLN6Ukr7LQHWi?=
 =?us-ascii?Q?NLXJzH2TggTtfMlEAJ86VHdnoJ9GLCvrd1SQTnUsWTG/vkGtVTxxirbekOf+?=
 =?us-ascii?Q?X+NVBk2GspanHa4Ree/livDXKHiDBAGbGmhM7SkpKeAPApzAn+XL9i4DLKHs?=
 =?us-ascii?Q?Y6WvYg82+A6prhorP1rIYyYPfpGFyfjdRTzQqcZ+vTDkdEcKKkKDtfFqm6wP?=
 =?us-ascii?Q?E+fwk5i7of9TR1mUdw1WOFoFtf7myb1Xuuf/TVMqpyTxg/7zXNg9VOxhcqtS?=
 =?us-ascii?Q?QHlM4CxPdZr+YELanPloDQP9UlP2zeR3IiZBmeS0N79bQrtSWPSPXAFnQPGi?=
 =?us-ascii?Q?SsrWm/mIzBtoVo8bZlx84WNcDkyVVWlMxA88jm4J/0w2YiTO4cf7ULynpgC2?=
 =?us-ascii?Q?Ep+DYZp5JqL9BccO/+ojqOs+XZ/4salNgdlZkKwLgNAkljDTKLA/9yPlShpG?=
 =?us-ascii?Q?ycsFiIRsnD3okfMJ6SRW5PtKoxWebbKKv5fMRJ5YJ3dDL35M6grekvdipvRa?=
 =?us-ascii?Q?3WQ7PLBw6J6nuNqz0TLLc+G2+2wqPcy0RysojFDacw8HdHbx73UUU0sKcCXn?=
 =?us-ascii?Q?2Z59FXUohwRz8gd7WI96VxCCz1bJUfHI7e1YPWfd2VkouySMo96DJyRwqIu4?=
 =?us-ascii?Q?YMAGQb0ZIwc3ul0CeiEMAqSQziFTJwZymQKRUPNxYsayKy8UI8ehfsvX8hXM?=
 =?us-ascii?Q?EShrGba0FAEPjtEWeQ2sdJi58IURHGojGSEOtv8vI0OFVSEoCyDwEChesY91?=
 =?us-ascii?Q?IWhyHQBZkQ9wcMGZLFKyOj5khn8veIxFmT1ZhXyYW3TeQQoMNU5TRO0jVs7d?=
 =?us-ascii?Q?COWVH6BUROpEv3iAvp6jLVdKvoTE/XbCjuzd7lWqztPaNMN+MvXIxRRWS49n?=
 =?us-ascii?Q?zkmc/P5khdfdExnD/7U8UklwSXkIJmp69Muu0oZT2Ur8Lh3crG4mta+K1Reb?=
 =?us-ascii?Q?fARmXkMY3onOBMBfmGZcDdIf/ZyPVay7YbZq8+BcUlYKxrtx4hzMzCFDvf+6?=
 =?us-ascii?Q?D4GJ+TsXAuar56ZaLxXllzJhtuJeUGbNnVMVPoKnh4QzQB+qxl0H/BYxiPYB?=
 =?us-ascii?Q?ZUkVMEGHaxloynPiQrluFZWAwtKcwT9T4L6dw6UgrzV50La108D7Crtxwu7R?=
 =?us-ascii?Q?gQ03M2yLBjCDjzLMZgZnZySxcmAiz3cR2Xefwl/9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb2bafb-bb1b-4cc7-8715-08da6a7519e3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 17:27:20.5812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIBf4gl5VIhvmjEJ3vYzTVWrMWAg9x6ayr4pLdBZCB9aMDzwEoLcKsK9Zz3O7zTa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3257
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 10:47:25AM -0600, Alex Williamson wrote:

> As I understand it more though, does the API really fit the expected use
> cases?  As presented here and used in the following patch, we map every
> section of the user bitmap, present that section to the device driver
> and ask them to mark dirty bits and atomically clear their internal
> tracker for that sub-range.  This seems really inefficient.

I think until someone sits down and benchmarks it, it will be hard to
really tell what is the rigtht trade offs are.

pin_user_pages_fast() is fairly slow, so calling it once per 4k of
user VA is definately worse than trying to call it once for 2M of user
VA.

On the other hand very very big guests are possibly likely to have
64GB regions where there are no dirties.

But, sweeping the 64GB in the first place is possibly going to be
slow, so saving a little bit of pin_user_pages time may not matter
much.

On the other hand, cases like vIOMMU will have huge swaths of IOVA
where there just nothing mapped so perhaps sweeping for the system
IOMMU will be fast and pin_user_pages overhead will be troublesome.

Still, another view point is that returning a bitmap at all is really,
ineffecient if we expect high sparsity and we should return dirty pfns
and a simple put_user may be sufficient. It may make sense to have a
2nd API that works like this, userspace could call it during stop_copy
on the assumption of high sparsity.

We just don't have enough ecosystem going right now to sit down and do
all this benchmarking works, so I was happy with the simplistic
implementation here, it is only 160 lines, if we toss it later based
on benchmarks no biggie. The important thing was that that this
abstraction exist at all and that drivers don't do their own thing.

Jason
