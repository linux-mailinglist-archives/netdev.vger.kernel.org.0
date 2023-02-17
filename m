Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E95169A2E1
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjBQAO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBQAOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:14:55 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3B3134;
        Thu, 16 Feb 2023 16:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQUppvqNx23SiLk3B1LGZOHTZrwQJxw7KNc3nBpkEFwqqPV4+mIJd01WWEuhYRnuM/RwcYmKA316FW5ooRFDP3HMNxEtQeBkbGqi7Y51Iy6DktCtmsrmWJd0qDHJM1G7tUAE5x7RqgiZziCzv9FGGQvf4S1zcN2L6OD2HanMF3Lysju3A9BXeNSl7r1Aoo2QJPHs8WIgHth1bq3N6wq69/LoM2Kt4jVZarL/eksDTLU7FBsmZVfM2AIWZ6FgdtQUFXJSLKWurJWJp+oXCAZ7Qud2PBGZR45pBVT4+RhoeNeNG+J8wRPfl8nhHWqP5SokOe6YUdccRWmDQMPWj8urIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGqe1RO545LMTHrHit/P44jfnGECfYDYYl54NWzOmGM=;
 b=eORT1R2DDITxsKSe/u2mwsQQoz3rb8nzezStXZkklUjPpVpVGPxv6caQ856FDYVhXfH7heDiUc41js1zUeQYj+8qn/GpJc5SwuPfHnz9BulaYWX20BvRpL15TxE8Qb59q5qnx3xAFM0da9DeJ3IJ/z+ftPnqcYJ5DaRzdxAJa/8t4nwXrmpNTQNz1m6ow88u6BpfhdapKEJdbaXSOQA/h4cswKnzhcCIyfBftQ/gU9PGslMNOA6K5EUDCFoNt51KgR3bAB/TFIxYvzmjPHkkce+pDy0NHikRWH2GpNqgTluNQ/Z7Fb+s+ErAJ9IO7PGQZYJ0zYja8M+8m54KUTjGtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGqe1RO545LMTHrHit/P44jfnGECfYDYYl54NWzOmGM=;
 b=Ze/jc1LzQJ+Sx4/Lg+sAEAt8dpFiHsWSQcbqKSYC39A8GnKTwie38/gZbmz3f/reSxNoqIFLF2KnkFa6/LNU4PZ+9MJGNAqplS6E5FJnwFxOmhahNzgjjWAGPhH+15mqxsr1zZ71jhZFb3m9+1vRQtsT75QuOWzMqHtEXa9lhe/v9NgTJa73eMKWsu4YCu4C5JjrLa5AbIiwp9ONa7LlRN3YIcFomJg3WziqvjjFBg8myPhFgLWtaINETYFG7VZZz3lsw9NRONZ1EAXSgW4H864YiTozwjGbtKc1RCHbmc6sWglkcSa2ypD61wOvv0ng6JPv2ugM51vS0YW3V0hNAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6355.namprd12.prod.outlook.com (2603:10b6:208:3e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 00:14:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 00:14:52 +0000
Date:   Thu, 16 Feb 2023 20:14:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nanyong Sun <sunnanyong@huawei.com>
Cc:     joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
        mst@redhat.com, jasowang@redhat.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <Y+7G+tiBCjKYnxcZ@nvidia.com>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207120843.1580403-1-sunnanyong@huawei.com>
X-ClientProxiedBy: MN2PR19CA0037.namprd19.prod.outlook.com
 (2603:10b6:208:19b::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6355:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b23dd7f-76fa-4e79-ebd7-08db107bfd54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2kPbZg0VV/3OONYCsrCWDE05d+N2zklSRUorHq5DRhe2r6EfA8m7wH3NVpVlCL63agTP51zFIhb4d+1qRxBazYDzKb5VxcuIY8HMbYI7cSj91ufkq6xmafGSfJwTwDlUtwb+sR7BvWq9BbgtI19T59obJFOfXG3kHF9E7fxmPAaTC/ILB494m6RhbesyGbGRKTBfYwhUzv+k2BoTgUuiPe04jCn8QLBLt301p8yXYT4/7eeGs3jIf0ZxT3fsbGIrWoNIMQvabbNJ6lqY69VzmYROJGV48CrvF6IrlMhg13dCZCzeLYw0EYqfeahLpDMDFtHTUa2HXqFDNfhfid1CN8Gl87OHYx2+Kw5I7ojBYrB9n9K2wjODeN1VT3lb4YGpdSmeJbDShbwev049BzwC4ENJ6miv3JWJzTAoPM/YOkCKYh6OQb7+0E7eFthU9CJCKf5TLWL5u/KjNVeIXXRtn6UByLI0dbddN0HomTEIC0BHK/Ho3nVrJn+LzncuXTgvspd0Fn0lokbUHqoXBA8AyGt/oDA8ePD8gJKU7/rzARkZvdlkm4hY3uW0JaRyvSRHR/cTE5vwvajVSCvQ6UB1FFTeYH7pGgl9zD4zewdZ3nIYnFe/iRQc+Jjn/7DKX9orm7xbyws6uKS75iKQObEuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199018)(2616005)(86362001)(83380400001)(186003)(26005)(478600001)(6506007)(6512007)(6486002)(36756003)(38100700002)(8936002)(41300700001)(7416002)(5660300002)(66946007)(8676002)(4326008)(66556008)(316002)(6916009)(2906002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rDV5F9gTiZ7GuMjDl4x2RLlaBUXRf42YYKabzH7ydek2NHsQ+b42VN7eHRbF?=
 =?us-ascii?Q?+PsMK60HiRFxksP92mdA1aV6j4kPfAojHfpSAOlHlkqQp/lgf2d8woCc/qFR?=
 =?us-ascii?Q?1TegDu4HgRy1cFMRpabhBSb1qWrIRgnxZGI81jMi/x+r8cKuI+thQVQDlPS2?=
 =?us-ascii?Q?cvsLVvplwpxTW6XkHa2nNu1iCaZ8AMgVlIEp+pATEmUKvEaLZHFsFvrpYWZN?=
 =?us-ascii?Q?2FO8j7x4iGn/xAXwXf4xgyb4ItouTqXQDzSBoRJsR8KdSnzXyzSsKLQsZTy/?=
 =?us-ascii?Q?wH4SYyXcmDd/eU8GIwWQO7muWdMHQGT/0A3NEH9SNMWo1+oXzls7jk8qXuRT?=
 =?us-ascii?Q?LyWo8T9inbBHFCTAqNnRmhov/mO5nNqDpp/XorB/WealiLU1bBot1QypUAds?=
 =?us-ascii?Q?pYFCnWI33Si1fw2A0Sg4VKx16dLIheS+2SpRfe+fVgnrn5VoeNph8BuJ9naH?=
 =?us-ascii?Q?UdglSlxwRBWRZyQVeYfTB8aLiF+dqxKMYrKKaIAxMXtlDa5/YwEztgtqeDkQ?=
 =?us-ascii?Q?SPV/NFKS17nGoyvZTos9KqLhAbRNq8/Zv5y8wk8/usjJppS5cFiBH6Gj/Rxa?=
 =?us-ascii?Q?sc8nVHtTajc+9tOMM/l8vAIZUq4mPFHyZDHmPpb5WYgQP5YpAULIDKlh8I80?=
 =?us-ascii?Q?FZoO+S2+VGbaDdfmAfgkynW1jRManxa3VkmB+y+VUPj7TbCTkuWW4vawQP+4?=
 =?us-ascii?Q?Yg01kaFIvYqsDdJEjaH5eyp1mq+/btftmFX+glXS0/DCbFFAFmF+x9cK462H?=
 =?us-ascii?Q?vOotlwmGrDgxkVOxqUAzGjuZL0LI5Cwi2/m97IDv6PvED2/4WukjW3cy4X6S?=
 =?us-ascii?Q?Q0lba/jQvmLstpJK8xg37M7ARTefd8cLroH6Wt0r5tdGmB/ddLF3lm2cl89e?=
 =?us-ascii?Q?Hs3Cqg9lZj9DxfOsQWR28qzKVlCiDs2hrP6vxbSLb/9kLC9RZAwUq6OG37K0?=
 =?us-ascii?Q?twwYTQ8LGXhzBbus72ucQw0P66jZat+D8wvNbBXxYR6X9A0dcNiQLSOXv3o2?=
 =?us-ascii?Q?/HxCgwq2QMjyHTRAK1m5uO/xtDSjCLS+tiIVblt6VNPtNQPoP3xwZJGPJA2B?=
 =?us-ascii?Q?3Kk2Kc31i0XkZIJ8xQFx6Ae1c6K13cIMlldonNRe3U0iB2BHg6T2CkTIeFVD?=
 =?us-ascii?Q?xFIeLQyHkLpSdvh1Fa7tZ4yxX8a3y3CKNOCnBrbZ4Lac2OZLhJvzGT9CwTqV?=
 =?us-ascii?Q?5ZGSM+KUptqXs+z9uP7VTr1qtl3yrc9smxDQK3kPWEIXe31caNjMEQoWNyAt?=
 =?us-ascii?Q?CVzgHMiv55A2U8iHFAvA2kUUKhOE3E8dh6EaBySqFE9RTEXiR3j6ZzbeRQwm?=
 =?us-ascii?Q?G+04hrNjN4T9GTXdo3Euv2tQ9XfDmSmbYrK8C3dOYnnhfYn4snn+uCkXi8Hf?=
 =?us-ascii?Q?xhtElbTkM98FVGmv/Nn7A0mH126pClrpC96YQ3ZkpNPONHJxkz/LU1rQiCJ1?=
 =?us-ascii?Q?ppy6bhiSc/DyPvUVTZVJIfZcq7bJDcvsmt6DKgAUQBrsQiTBAMMj15E6PPFg?=
 =?us-ascii?Q?bQr6UQoiLp3G+54HlCMXIPgpUm9yiqwpSoakmuaCL7eGb07UN+5Y2RXWIIou?=
 =?us-ascii?Q?IsiB+UG7K8RU1VTE6+zFsDnuCS58o4SB7WUNspL+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b23dd7f-76fa-4e79-ebd7-08db107bfd54
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 00:14:52.3713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+y28M6ceGFmDTzy7b4M07sU57R1jFv5EXlTgVKzSZTANdd0oRVP/HaP9w3jkWdJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6355
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> From: Rong Wang <wangrong68@huawei.com>
> 
> Once enable iommu domain for one device, the MSI
> translation tables have to be there for software-managed MSI.
> Otherwise, platform with software-managed MSI without an
> irq bypass function, can not get a correct memory write event
> from pcie, will not get irqs.
> The solution is to obtain the MSI phy base address from
> iommu reserved region, and set it to iommu MSI cookie,
> then translation tables will be created while request irq.

Probably not what anyone wants to hear, but I would prefer we not add
more uses of this stuff. It looks like we have to get rid of
iommu_get_msi_cookie() :\

I'd like it if vdpa could move to iommufd not keep copying stuff from
it..

Also the iommu_group_has_isolated_msi() check is missing on the vdpa
path, and it is missing the iommu ownership mechanism.

Also which in-tree VDPA driver that uses the iommu runs on ARM? Please
don't propose core changes for unmerged drivers. :(

Jason
