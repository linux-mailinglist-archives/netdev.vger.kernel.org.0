Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A945838D8
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiG1GhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiG1Gg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:36:59 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2044.outbound.protection.outlook.com [40.107.96.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BBB4D143;
        Wed, 27 Jul 2022 23:36:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9rMsnD2QtmH2lttWS3sXUds8bN0CTeHMD9zFkXuTmAU4RDLWSmTLQGmJso1nlJOblj929SZiuU/SnXyX1V4Y3K84JqjDsum41Kjy9/cw3Skp/OPqyQZN26QAUN0t6tpOhT90ghLX6Tno5z/XQrO5oKo+nSTc8nNWcC2Sy/PEwMVng2yI0VYVEPG+OCA5wxU5Hq+Hi3e0xZODnTsB4AsmUCHfLsSd3CAwaRiFbBxuZJONF0GD9M6PNaesd2GrIiGHQiGLw5i8vfO9loUzyqMkFBgk+9MWDMyaLVLhFAbo0oSGrpxTfruGkrcZLm7vajVIw5EfxpYw4nZ39c+8qBPAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQlo73x8gVYUlxkI5upNzuQWREeqbWiTVB5sL1QZs2g=;
 b=Wqv9tp6W8tcjs30TinCHw65RO/8N3XJlrCoPqurW/g3N3y76Rq4Av5/GGlbdnaI/aHcdKamEJMaVg1oWRBe7/8BPjxv8Tfi3ILOErQVWNOmYl2wTKCVAO02xvgjks17e82Mb3Np6KZtjvX3OER/VLrbF7wbsVxnhjznd5vq4cfAkfwFA82ysTibBlwkCd3v+kIxoo/3H+r7TTjm4vvYSJQV6KzSI9ARwW3CSC2wyNZ+e5DbC0R7UE8O9P4beVqdMNVPYJzCnQyDUAR71Z38dn5QYKlrBfW6nz6ZZkTJuviiF5cT0h21CGD9923ndA966gz5GtHf20q6U6DSPnrbuJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQlo73x8gVYUlxkI5upNzuQWREeqbWiTVB5sL1QZs2g=;
 b=OOCvMMs/Kwvx2jnI9aKuhPQNvqKqhF7XX7hZiBFA4iDBQXK333PuqRdGJtg5UcuHMZds6UQGDH7ATIez3Hmg1XPqXV3b2Mr6bt7l0XWIuLtuzW0xymR9hPS+tGTO5moBfJVRhKtvVOP9QrhN2/AmyWpFckYoMAHq8D4ZxSzh6ykDARICj44gimkeWkFdhQtg3JQfdF9vu2fUtVAjrRmYQN/UVhCJvgHID6kGZCvjka8fB3kFDDs8+dzTLoppcImgafj1gzaBczcV648vuXOnKFN6+KZ7Qjz/59hEDrSaX20HujSwUapkc08JabDSOfXWI4dj6DMwVyjoKKTF5vZx6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MWHPR1201MB0222.namprd12.prod.outlook.com (2603:10b6:301:54::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 06:36:55 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62%4]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 06:36:55 +0000
Date:   Thu, 28 Jul 2022 09:36:49 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     petrm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] mlxsw: core_linecards: Remove duplicated include
 in core_linecard_dev.c
Message-ID: <YuIugZUYq1VL1Rud@shredder>
References: <20220727233801.23781-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727233801.23781-1-yang.lee@linux.alibaba.com>
X-ClientProxiedBy: VI1PR09CA0177.eurprd09.prod.outlook.com
 (2603:10a6:800:120::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73725d85-ae03-4924-1f6c-08da70639056
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0222:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WAFTsWX4UKgfuQU57T1cA20ut7vD+oLdPElKbDmh4PX8zcJQ5wc+T0b7EGmY5Oqwif4F81ul+tLo7RNDgzrOxM8dJwCrMGy0/jXxuRZwNKSgZ2eMBl1SH9Tc8i5xIrXBCCbBxMwF1YEEWbVzAz17riq0w0Mp9US5lxH2m3WTq8x0hRy3L1lR31BvsrJHJMN1MXmLW7Q0W5dV9272FIYf/Z3Q0drd6pqh1GzsWhj0v6k1JDVm+8G/62hGDKoFQMNNeBMTSKy1bViQbL2EdNqMEtKj6+wVFWE4OLVZbV4pSUPD4L6Eb/CU8dd79HoICZ/hGUpqRnybKGZu+69iog7LFz1sY86ytKWBEBTU7KWb7eJr3ykdgiA5e0FYb6AG6q/TCm8S0Ng/Xmdne/FvvcFc5u4uUYSjMaPfOyDfbA8gRsIdoZyQO9lfdUakXQH69IxeO9k8H13EGwojatxNUyz84BfKYB4RfXBy3U3IJDWwqAOlGkRVYVfHWrzi2fWWPoMiLPCA3RzwgLHLVLhf5alg7jy85m0QS8YQsveNivyNbB4xC78JZNX6UGvseOZMaEzIc0UM/PybOB/V9o8uRzuFfCyxdiq9LU8L6amGHUib0vo9oi5knkjgUKd7Drantqgz8ge3jGWerlIJkL7EQVNCxNzHYYRP8G6WkIy+FvZ2vI9MjvrZeqAcksVxvWkBrs0TVFhnJFaVlDfqYqwrx6BZZHWQkAMPeeXLpxmoOltpDSZvhquzFSESdnbinhFegE/T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(396003)(376002)(39860400002)(346002)(366004)(4744005)(186003)(2906002)(5660300002)(316002)(86362001)(6916009)(33716001)(9686003)(6666004)(6506007)(6512007)(26005)(41300700001)(38100700002)(6486002)(83380400001)(8936002)(4326008)(8676002)(66476007)(66556008)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+csSAF4otDEMCGPG3mxCrn61ABJ9fTZ4SpY9QRgwSUU6lhNjmH+Eic2lzWlu?=
 =?us-ascii?Q?WqxgiPuD9E1M2BVZ/tKnVYUe3SoiJJk9r2fOIqMyLQe9HVoXpoc/OxKcm1rt?=
 =?us-ascii?Q?O0v8yOgqXJQeTtv6zDRhprfGnMrOwCBpPWGJZSHHTZDX6taYz7zUlXJp9BVS?=
 =?us-ascii?Q?SiA0AU0g4bjtGgg3ABUiiIxdc9Gc1qr5VmUyYKHkDlidnMI4yWEGlr2T9J8k?=
 =?us-ascii?Q?3IS1bdrpGt4HXC4UJBibffgiGEiQ1T2iMD4bS+AnEsh6g6Uid364aR8BCAKi?=
 =?us-ascii?Q?mPYdkblQRlvGeGuYE+WsmuJJnqOPTqpHEiuKmYs8IoyYmWo0ci0qCJwuymhR?=
 =?us-ascii?Q?RyQtepDkOgSRkClwEKIJ//pKdDhMwUPr7Xw8YZ0GOKGuL0+GyXe3KJO3R89N?=
 =?us-ascii?Q?rw9r0FKkNfdkYS/CZoJg8NDMrEvqmab5TS5ttfCbn1wwDTY/8uuaD9LucYky?=
 =?us-ascii?Q?BycVgC2HKraafKfq3mFYT+D8K0mwnAmx1wajg4OiNJ0kAXt5Ec4CWAaG+/et?=
 =?us-ascii?Q?I8PqmxEvPWJcVus3ui93Fr/qB577LoBhNBwpK8hqZjqdbqQ5WAv/wGhx8K5R?=
 =?us-ascii?Q?kyzx+ZnvdC0nFaUsn+wy+0T+bz1NF+itGEu4uiZRIZHnX2V2cL/PrclwHqoE?=
 =?us-ascii?Q?NSzP+651WY6nvT82K0qhf8wqYkWKCLsL6TsHw5jlwJ1hBwm/uEdTmC7SRf+N?=
 =?us-ascii?Q?cwNfUBs+1T4WtqeB8NzGFskM9QqqN2NXSygn971mc8GQf6Xu4LtZ7uhQt/tR?=
 =?us-ascii?Q?11NES4k1oZweKbcgzxJn5NA+uQqlkYBNBbtkdTmznSsw3xpDCyZQF7jXy/PA?=
 =?us-ascii?Q?RWBWsjMGz2DXYcV6Gd+hnl6M/tlhdH2HGQV/VUrhXCJ1RDo4iPRMW6ypC8hS?=
 =?us-ascii?Q?4/H21xeGr9+WinDb258HZmh3Kt66MOZNjrlNmbqhNdzMzv4N+sCl3O39oeLE?=
 =?us-ascii?Q?40w05NMvKULYR2TkTsci89cPjMrRfWjb+/2NWcowX6Fvox/6YGUQacXD/6ow?=
 =?us-ascii?Q?CGIN4y8fNArqmMT9VWtdVQ862Z04O3e+JYsiNgevTgCS4ixTMXWOQGVIUUbk?=
 =?us-ascii?Q?MzxGapbtasrOy/0JmCZcSF70HibpEql4JzwAlSn+IzhHEVgub2nPaUxoNLhe?=
 =?us-ascii?Q?U7D+EgNTF3uo5Rwejh7lqP3shEATzblkktm4LppbrBIkqpBEicIekhx7nyV3?=
 =?us-ascii?Q?BNRR9Uq8OAafdvSGiTQJJ7BUFbireBsRyGEBnd3lRsktjaccumgAKBTflKsG?=
 =?us-ascii?Q?KWBi4bFMET+DhALP9vqv7MohHnGWcTEn8rGCm78UMPUmE4qMUCrMIiLoGsjs?=
 =?us-ascii?Q?THkcEnPAO+thnFk87n0OhMa/RBoUXo4B8fbRcdjxElGgUcN9Xsy3DjFpKu4h?=
 =?us-ascii?Q?z02ZKp6nDdftpuKTFEVpYJPRB6UKQW210cQVSCq63Rs33LBAqpnJj7SgoIsc?=
 =?us-ascii?Q?NyPIXaUsYXcx9P5+CCM+2nvcxtr2pw8lNIhSEWSnyTMagrkOToK13zVuquke?=
 =?us-ascii?Q?SqhezXbvas0H3ZnPmFnw/eNpJwZc+SdrWZ5udvDwU762odQDNWyk5Kc2w8Dr?=
 =?us-ascii?Q?1ESz1XG46xy7D/akVXE2jsQlumWBBklS6Ap+P0A8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73725d85-ae03-4924-1f6c-08da70639056
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 06:36:55.3544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imnexYHkBLzwvVLjiGS9XzAHCRq/7o0ulxVYomd3fq0z717cA7CTBJ6vHdFT3dv42BBuVIIp76isSx70sSEp2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0222
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 07:38:01AM +0800, Yang Li wrote:
> Fix following includecheck warning:
> ./drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c: linux/err.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

BTW, next time, please use "net-next" instead of "-next".

Thanks
