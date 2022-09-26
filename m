Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939CA5EAF30
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiIZSHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiIZSGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:06:50 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2081.outbound.protection.outlook.com [40.107.100.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7643F186C2;
        Mon, 26 Sep 2022 10:51:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glAQ0VWOlm5JWzWAlSDdXseaJDhRmAePmsYXfqkubsOp7E4NKra/41azq9g82qYItM4r01lY2ScO4WYZXrZ+6X01pxhbvuPMHuvSOnPubhgaTYPAq6hEyzRbtrAOFqPGUwGOjDmw8X2oqcqjxZhrrUnrnzndleadEvpHfaB/27Z66/UpJ/723iMNxDUtrgHZlqxryfhguMpvWzNxgbeP8xM9Ebo/ofBLa6+hHedKWp5WdoJ/i6//NAiPbyiIHLu/Io/eLfI4stWAb1Gw5uDZrrEKXubRrnXQC8WkhSsLEX+s1iNG8XJsrGqvEJj+28G1Es+PTFyZnCMI7yR79ADkQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mxnJ1212wl2Tw7Q6Fnb00u3yNSj5BhP3CX54OkGIgvQ=;
 b=bhZyv8+Y9FsFWHBBmoL5j2qu5gNRJSMGUe1ybThKUwTktYIdR42pJjbjmrJrXjxZWYYtwkCaHKdaov4llg8joLpMktyMwjJJbptRNIifQd4Z92OyIBAwyWdAIiWvq8IOJMDG97rtqVj3ON7PqOfaIlf8LbhPCgcyZ2Vdi7J1mP6N23R1IO86NXEsJZWzLFgkUGeNGcjiQWQ18NBHU71JuQvGE3xm17zZ3PZ/vYx5WrJvKHOVNOmFPFySVD6by1TkzaZ2Bz0vIXq5DzQAE3QcU6Hy20PBShFzPNMS9r888P3oYGOOjLfC8d3AjT4AxJQejTSBvC8GXidA3uWTAjc2yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxnJ1212wl2Tw7Q6Fnb00u3yNSj5BhP3CX54OkGIgvQ=;
 b=jpE3nBfapFGC+aX3/6j9VLCn4DguWVSGIX2k7Ak8mbKYOF/ZFDUGRrPNTXjJ+kHu88dVop8B69Nz6qEMT6YaTm5Li/nduBFuLERZPyRfjcEtbNbqHX232dfI0lGv8C0+jmYvvZ6uTk8N0/Ko2iL4bXildEHbPYcrRDlgG6mvh5ocVl8eY++ptmEpU+p5D/eTb4PbcZao4xRR/djqfNELgrZY3otgJfPIo0XR353mzCTh88k8WqfrUgE6ZkRwNaB2N696gsimMxmtWYLhNOLxcy0NExHjodYSXvco8IHxKpxKws+4t5OPCr0vEBbqzYqkFco9gdse6NFeDQm6NOXkLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA1PR12MB7149.namprd12.prod.outlook.com (2603:10b6:806:29c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 17:51:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 17:51:28 +0000
Date:   Mon, 26 Sep 2022 14:51:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, Leon Romanovsky <leon@kernel.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Mohammad Kabat <mohammadkab@nvidia.com>
Subject: Re: [PATCH 0/4] RDMA/mlx5: Support DMABUF in umems and enable ATS
Message-ID: <YzHmn/ClnFX3vRX7@nvidia.com>
References: <0-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
X-ClientProxiedBy: BL0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:208:2d::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SA1PR12MB7149:EE_
X-MS-Office365-Filtering-Correlation-Id: 88121a43-92f9-4a11-0e90-08da9fe7bd16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKk/P2mpej/ffr7WzfHnC0f0kl0+NcVjh71znXHBMlY6e5m61Y9KSPhO+LKRXjQpgwYPB00up64bVueiVfiWURIJpvlUsgDdOJ+0Wr/H1z/rDqjdGPhkeaujK0erI7gMdbdh3vldIOBVRJqEgyZAd0D9e2Z/FfhepNZzQdnV2SluHYjfXLPG/ZCTKya49EplS0TbcEIsfoecRLj1+4BNXR75fzKrHcWd1Qy/fmYhxf2FpQdru1mkmRWRpc5ErV4m41cUciRX4920TPBI7h5q4f1F615C5m5P8Pl8Lh9XNgEcilLPlr5hLC/EKmqjNYZ4VvRxCwYozIrceedHwUChmy9aFy26Ft+FZnhrgg9645wp8zJ2h7A5QWdyQsdEdnZ4DYkpK1kgWP1G/lTtP1U54oHHhm94a0xvcw4wusnDA8ZtcxTpbjjJRjWomcDwIeFz1B0J+56ZqyB12mx7DlCouWE7nW1PcYjs7Msv3Eqxi2j0zM6p09xMyPmvYw1yef33lRIrdQ4abYKmwHdorHwTw3qvDFDa5OD1SffRC3J1DMeH5hG+7zx1Mbx+z+/PZ3ly5t8yM9Nd91JsqXRPTOfk9odAs+vj64ohYjBwk8Gznb1kzO9vmSVGbGyXLCwLNqWwHqcuTIcSOg2L5U9YOqAWSX2VERrkC5gEFC6wZx1vJ9+qXvdajh0PZ/mI2/2DfJn9iaKI5iNwyL+MX0hTISPCzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(36756003)(86362001)(66556008)(66476007)(66946007)(6486002)(54906003)(478600001)(110136005)(316002)(38100700002)(4326008)(107886003)(41300700001)(8676002)(5660300002)(6512007)(2906002)(186003)(26005)(2616005)(83380400001)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iJAFOw6KF02OG9ZETDwzjUTomwUk4RnuRDrmKZqjY1psUmML5FacPJdkFrRH?=
 =?us-ascii?Q?U6Ff/LsCT8+o4qfCjBpidET/T369Fn3QJ2yIs/z8ZaVluRwAeo6M4b8DP3qu?=
 =?us-ascii?Q?dqH3tWxpcxkw7BRIu8zAbD2KqKJYMknzjMyeYQpnnyneKLxL1XP7tmAjl1we?=
 =?us-ascii?Q?mScxZUNQXneglUIcKKjr4g20DGVh8xQEisvwpH9NcVOZKJBta6lvjRjh+WEH?=
 =?us-ascii?Q?NIQaggyUO2lI0Jsw7NGS4zz1HrjlW7u2hNYOl6DbPgSi8yceYOAksHqdpycg?=
 =?us-ascii?Q?EPb9ryD6a25KCoNjX6BTUcInAeeDHsHS4ggOWJ8iqzDrhYKccqlplG2+3YjD?=
 =?us-ascii?Q?juXAl5n+G1V8+wDhFaSHTA4U20jaS9RbiGlDiEq5InK0ts+8GJLGAVGzdJlf?=
 =?us-ascii?Q?LrMj5zw3sEKRhC6nnwoy8sts6sEVhNdBp7cKHuevKnlKJi94CLVxOQcT43f/?=
 =?us-ascii?Q?scGeSJSr3fkU7WqhO3XHSS8apYRXbvROPSdGZILibUEI8GITS7k5N9lPXf4b?=
 =?us-ascii?Q?opPMt3FvkI7SwQ7/pQ/neeqe/ppFmSXMYa9jCbRi2SFHCqwCm15ehiAbU1OK?=
 =?us-ascii?Q?rxeZKdZzaR/I1JEV/sKsRCgR8IUpqcv6BELrXS+mNt2bvWrBMXX2Xe1mmqwP?=
 =?us-ascii?Q?dlVAWMFWoiKbHHWeUe+UekdVmyjZZwIt2USNB8M8ACslPsz2IyRxxr58uAz9?=
 =?us-ascii?Q?kqyK7iWzqg62EK0UkexbI/V5rgC4KdEuWjPQ0S3kMgba5O0Pokn+QKN8D+Oi?=
 =?us-ascii?Q?IN3eLv6Ktb6kTCDyuBfBL78/5U/eKjjVldGWqI8gjrP97GfOkjIAfPrBR3cL?=
 =?us-ascii?Q?vDeIU62zBdFINWFrx4A9XH/q+yYzCJS5BP3lrfoDZsySIXnIcFXDpxDyxQo/?=
 =?us-ascii?Q?31bW5m/noekxPWe+BF8SkxTi/q749MsmBi8XaTLMyYZor3v08XoKBU1GDCHB?=
 =?us-ascii?Q?4fU2uqjL7dPFVY220pfvvTK9KKTQNhaHZPdRnIUg9Lv1plk7LudPnipoMMyu?=
 =?us-ascii?Q?Dj9fhALdJbKX/5G94Bus7vYVxZz1p50bBLalhRAy/mq/NPcVSk4qpIYx2S66?=
 =?us-ascii?Q?lE/0JNnyITrD0ilLxEfKhmVxXAG7/WXx2TlLiTJB+PXLudDz5U7QK4hTSmqu?=
 =?us-ascii?Q?qwXgq2XUoYbi80+XrgKnUOqmaHDmR44V94T7D3FSFVIroorRKWh2IGYYOm3Y?=
 =?us-ascii?Q?EXtcy5rUDH+HDDMIYznPrDmalzDzSMTCnBUhN3gSJndXdIsvLDR2LYXxmEfX?=
 =?us-ascii?Q?Y1EtDoMPG/Hxt4hjdOErqg1ZWD8jU0+sc5OE78+D4QqQv9WI5na5GIgI4N7p?=
 =?us-ascii?Q?yftIr3jtZjBlPgJIxIm3lM/dBYWr/AzL5tk5267hS04zhMHloT9BDSrl+D9x?=
 =?us-ascii?Q?0kQkOW/+O5xpPrYtKQ1IR2q8mh4hdSdaEmGRWfSH/lSKJhZQVIP1Os83dX+8?=
 =?us-ascii?Q?dtQvHRKzQV7G+FoCA0vhrpDb5YdE0jwjw7+sHZzuzXOowiE7MatmeUD8ZQsG?=
 =?us-ascii?Q?lyPm13VGhr3Td+1EDHStY0P61OUcYU+cDbdaBIwfbyfIc5ixqObE6REJZiax?=
 =?us-ascii?Q?XhIo+VjkSn60Soxgxjs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88121a43-92f9-4a11-0e90-08da9fe7bd16
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 17:51:28.6490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DwYu8JRzWSio3Xb+35AtBMYEEVSja4GPqf1hFtmCDASbL+OxMEod7DOtqqadSmw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7149
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 11:20:52AM -0300, Jason Gunthorpe wrote:
> This series adds support for DMABUF when creating a devx umem. devx umems
> are quite similar to MR's execpt they cannot be revoked, so this uses the
> dmabuf pinned memory flow. Several mlx5dv flows require umem and cannot
> work with MR.
> 
> The intended use case is primarily for P2P transfers using dmabuf as a
> handle to the underlying PCI BAR memory from the exporter. When a PCI
> switch is present the P2P transfers can bypass the host bridge completely
> and go directly through the switch. ATS allows this bypass to function in
> more cases as translated TLPs issued after an ATS query allows the request
> redirect setting to be bypassed in the switch.
> 
> Have mlx5 automatically use ATS in places where it makes sense.
> 
> Jason Gunthorpe (4):
>   net/mlx5: Add IFC bits for mkey ATS
>   RDMA/core: Add UVERBS_ATTR_RAW_FD
>   RDMA/mlx5: Add support for dmabuf to devx umem
>   RDMA/mlx5: Enable ATS support for MRs and umems
> 
>  drivers/infiniband/core/uverbs_ioctl.c   |  8 ++++
>  drivers/infiniband/hw/mlx5/devx.c        | 55 +++++++++++++++++-------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h     | 36 ++++++++++++++++
>  drivers/infiniband/hw/mlx5/mr.c          |  5 ++-
>  include/linux/mlx5/mlx5_ifc.h            | 11 +++--
>  include/rdma/uverbs_ioctl.h              | 13 ++++++
>  include/uapi/rdma/mlx5_user_ioctl_cmds.h |  1 +
>  7 files changed, 109 insertions(+), 20 deletions(-)

Applied to for-next, thanks

Jason
