Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D7257C118
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiGTXt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGTXt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:49:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740081276B;
        Wed, 20 Jul 2022 16:49:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/INCeSEoGG6rvLUuT6hFi1pcQ6JHLQYapjaPsNefJpIzR3V2auKxO/JocDZO6K6/QHrgVjPv/w5Fd8qli5D/CIApzF4wAaJaS4wpc55dYx1e6HwnwsTJEAwdYEGQprUVj8NE0cEJguS4I3sAW1ZaATI0ev2TvLuv2a88sRv2GAWUE55W11RcDabyN2lmGTrhLEwUC5cIJFKzRjPFoz+BGAhh/a/NDjBNhd4SfDmZg7VmI2pAzEJQoDMzwq1tSxj3VfKdMP7dxp1DN+R2RNDvYGvFry5uMaPC4h1ySnEUapC7thhFBM8Ww7b1cgQE3tAxzbldPClCm55X4s5Wi7n9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fd4N65qlJcUWKxEsF32eTl7TqIfznD6n/YhR6lwsQSE=;
 b=ZEjXpnsvyiKnHUyLzXB8I1gljgWM1cWMepwokACEqxaAW8656SjV8dPU13hTS45mKqA4YBOnRXsYCkQAmvmTFopaOqtiGekBRqS/fqjkF43w8hv2geNeUqckiDL/F7p4klyDKis+WXHhpKZ1IDfUj1cTu+uo7Z6+Mv9Ksjicb75Rg7yuadB0JxpV2M9mnnpRLyx+Q3XvTW+s4BibGck6noztetB8w8Hzb41e3j7JFY8LwHyQJSs+afmlboRBvzIex0LBKSalhnObGoYJX2LxAASRH4SKV05IzoBblCGwwj0qmuDjBSHRzAkVgVfb/jq48bmz1XF/PPPfUIPoqSi/0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fd4N65qlJcUWKxEsF32eTl7TqIfznD6n/YhR6lwsQSE=;
 b=bsvgB7e3c5glMosh0SbJbZxAHQRHKwimACri9XGCySrLvYO7B331dZ4rDmPWtYUK6+EwfFsuHpZOxH+KqfQ75J8oCPwh3eRG2bvvyTEuvIfAftRGINgjaqE582WIATG0TKIc7m2bEXnPpdLhT0rbEO6Wz8ilxG4YDdJLCsRiL95PbpmszZL+7B6wIqvpdK/no626MeKyqJZpuLymoQQ7FqdcNOi4QK4fVR0LPz3SQX2FPYfObpB1UmR6EY46qJSXfrBW6rrhCVbAVFxZPKKzLPFuMNgg2WKivgbAd/zc1hQrWeYFsfv1bz7u9gEaBP/+BOmDsfnE5++IBMCfcC9anA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 23:49:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.018; Wed, 20 Jul 2022
 23:49:25 +0000
Date:   Wed, 20 Jul 2022 20:49:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <20220720234924.GA406750@nvidia.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
X-ClientProxiedBy: MN2PR19CA0028.namprd19.prod.outlook.com
 (2603:10b6:208:178::41) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aad1de6b-973a-408c-a890-08da6aaa7a22
X-MS-TrafficTypeDiagnostic: LV2PR12MB5797:EE_
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jYsgd89odiyme117xEdTrCjgpAsVCju3DAwIeSMaxHJzbR9ujNvyBscsVyagDOQOzLQqa5oqxcxwUvf5bclWQqIqMAcQ3FVALzLGyn+TCS77ZvO7dRWWTzjfIpvW+kKrVTbPqKcOztIysAQ/JblItsj3k0WHqDjd1stf4X5X54eDnkHjxh3+H3VzJvkWKZerQZG8LXWS4E1lJY7jMZBpbjE1e3ZERCfF+QV0GWzSxTZv0xIyVS6XutiTbVZ9tqgP5Zu6PASB55QMg0AEHE09U5xiJMv2UrB1p3ckz62JnrGn79jO2cb/Y3hKmwY6/3FDfd7mZ6+zaule2MyxMj8FErzras3+9DvH8L7wNOKMqKyhLbgsDCDJG6PITvdEB95h9TadxtAi7zapxjN1x08IwQD1buME/eeKU0agyzicRAgbp76oTc3zenTcSkDlTQ55SQWJMr14fuoGbW59sWQ3hwwmZnbBFIrp1ihABbTF39rj5wMnjn6C1MjBnQXK0F939+XsceOQAuLOrGb6/PQZIJ2M6PiPEamD9mwu9rVcl63UbYnQeLUAUHdfOOJY7H1tShrhl+4TcvrUegHFnGPBtFnieMBrSSwi4ECld9ysBG4Ggzl8UO0ClCzZLuSy5Q+XXPBk3f8GaCUK46XWbqlQ/Wp5FMOWwsuC4pIBxALdHZaH0PfC19gCL/NmCJFj9Xmedr3hZzgxaiBbRYkVJ/KjVexKB+l8KFmPkFjLs6gIchLKwxddahczh/Dj8POBc2Dw+96PiMODswpTjeMuJSW1NjOyRKtnx8VZIZoBtNpytrg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(47530400004)(316002)(45080400002)(54906003)(52230400001)(6486002)(33656002)(83380400001)(478600001)(41300700001)(2616005)(36756003)(6512007)(186003)(1076003)(8676002)(6916009)(7416002)(66476007)(6506007)(66556008)(5660300002)(2906002)(4326008)(8936002)(66946007)(26005)(86362001)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ZF9O2VHCeJ1bIcBFimF0nm4oA3+OjEl8u8SGHEKiWAl4rFzvYf4uYpLUFxZ?=
 =?us-ascii?Q?l9TGkmnqwHkmJL2RmfNGpN9hG3ft7Uh6G+hXnHshFmHgyQuUPf7ApDEFhHkT?=
 =?us-ascii?Q?OQ50UGN4Ezzoi+1vN+gdFKmbnipx1Iclrl8szjosrmMC1kknVz4BrAgQ1l0T?=
 =?us-ascii?Q?ktTtQjQWXXfUk3rN+Uzx+cJ5baoFUfhdmwY1KmUHTYx/gyqm9r8+iPo+Z8vW?=
 =?us-ascii?Q?07siDN8d3IJOjcT+jlCx069bN+A1mHrYSEvSWyYQUX7LBHPAyjKWafFrrHUG?=
 =?us-ascii?Q?i45TTaHG5XmAbx+l5bkwmrEVIDFhwd0U4J3Wi08sM3rOiThE933uz4H20HUq?=
 =?us-ascii?Q?MHHS5QPX6pkbYplp9aihxN4qkZgV7pnrsqOJyfSLqfF0yXaTQ0Bp5U5DUd9n?=
 =?us-ascii?Q?gB+27J4uEBnlti5zVHOOR0cjg3SA4dD2KqCHH5i+9hLJpgw6kXAFMFdoWGmu?=
 =?us-ascii?Q?O9nz0HSLhyvxYETxGuwvB+Z+OvXze+M8GpVsm7548yvHLeMevlsV4dxUS7dO?=
 =?us-ascii?Q?+x7nJ8SlfH7m0QEFZAB337g/wBksDuVVfMQFawSYdLpYOQVnJ81c1BB5T/uZ?=
 =?us-ascii?Q?pwemZNguQ4KWiNeVxBTT/rclYNtOZ38N2JdrrTT/vzQF2BxseiDpwvERAWq3?=
 =?us-ascii?Q?zNf0MTWHejeaUjY87+tCmAbBD2WbVBkv4RKi/UFa0MGQ/gBY7mIuehAHgXUN?=
 =?us-ascii?Q?QnHH2b0jUc+w7OaUK2i18qmhTuJ3wfA1bYT1OPrq3i4nEPtUm6szdB2FOssc?=
 =?us-ascii?Q?hllbv2gK5S5Ndwiie6Tpo5mw3isjrot/kY3KcBHrshat2wcdmWB6dxjZ0VZp?=
 =?us-ascii?Q?LIQ/WpyxrgosVTGuWVviShA7UeFsLFnVwFuvSoJzNavAAViAfiCmTlSNJ4SJ?=
 =?us-ascii?Q?rnRWQpMtqgEsVGsD9m8nKY59nQC37tNwECme19RRhzzCiDvYzXXGUKtzdVof?=
 =?us-ascii?Q?P1zW9aVDXKJHDmcLxiVllWZxd6ITUC9+e/FPg/Z7VkvIcfuXkaFjBPPLL7su?=
 =?us-ascii?Q?Msls0/9OnFcvbW2wvOxb+wQ6pOU+BVTARyNovSMGDdgHrA/HG5ccDSNXAPY6?=
 =?us-ascii?Q?5XQI9MXW/rvsQNmSMJ1T+RjcYl8paZzupacoJ8e7WSf2bE7SXp0Hy4u5zrLh?=
 =?us-ascii?Q?U7tg6z5e/+fAeDX18pK9zqlHZnIb+HLDha6pHLaF2aEcFivCKz763Ovbg62O?=
 =?us-ascii?Q?Bzs7ZQ2R1zUm0/CHF3pqafPTlAUJ2jnpmxlAn/tF2otYRV+I6O3YkEF1xEvi?=
 =?us-ascii?Q?nWfb4WSyBeQqpskwXmVLZhyCdLTw3+q6IVrLuqmAgFjdkIl3GLS/GKsI8sBz?=
 =?us-ascii?Q?T315JuJKwIygy3sChc+j7aJVoJNCo5OWEap5KUGzuCsjHApels9IWeGVlRBZ?=
 =?us-ascii?Q?Fbv/8u83KguF2ImjiYTi72spZ3y+CEZv4SJX7AcJvgAYXGpa19ErdOrWUHwR?=
 =?us-ascii?Q?3EpkCSWN925gfHDfGnFTZXjYwEzUKhvzQLcRxzw5874p8/oxYqi+xQ/bU2x6?=
 =?us-ascii?Q?sAmHV+to86OkckX6Gl5Z5Rrjlh4UVgjFgv0IV0VOPUmY4YLQsWZ+AesTOrgf?=
 =?us-ascii?Q?nTSKsjcACiU+n5FU7O0Ea/jj3oBvTFF/S91BcjHf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad1de6b-973a-408c-a890-08da6aaa7a22
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 23:49:25.7266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMJCAvJtqDJRw15bmwdtvSTw/nC5dEc2ls75c4ClaS2WHyNatiaCfCE/vfqHVwto
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 07:07:20PM -0700, longli@linuxonhyperv.com wrote:

> +static int mana_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
> +{
> +	struct mana_ib_pd *pd = container_of(ibpd, struct mana_ib_pd, ibpd);
> +	struct ib_device *ibdev = ibpd->device;
> +	enum gdma_pd_flags flags = 0;
> +	struct mana_ib_dev *dev;
> +	int ret;
> +
> +	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
> +
> +	/* Set flags if this is a kernel request */
> +	if (!ibpd->uobject)
> +		flags = GDMA_PD_FLAG_ALLOW_GPA_MR | GDMA_PD_FLAG_ALLOW_FMR_MR;

I'm confused, this driver doesn't seem to support kverbs:

> +static const struct ib_device_ops mana_ib_dev_ops = {
> +	.owner = THIS_MODULE,
> +	.driver_id = RDMA_DRIVER_MANA,
> +	.uverbs_abi_ver = MANA_IB_UVERBS_ABI_VERSION,
> +
> +	.alloc_pd = mana_ib_alloc_pd,
> +	.alloc_ucontext = mana_ib_alloc_ucontext,
> +	.create_cq = mana_ib_create_cq,
> +	.create_qp = mana_ib_create_qp,
> +	.create_rwq_ind_table = mana_ib_create_rwq_ind_table,
> +	.create_wq = mana_ib_create_wq,
> +	.dealloc_pd = mana_ib_dealloc_pd,
> +	.dealloc_ucontext = mana_ib_dealloc_ucontext,
> +	.dereg_mr = mana_ib_dereg_mr,
> +	.destroy_cq = mana_ib_destroy_cq,
> +	.destroy_qp = mana_ib_destroy_qp,
> +	.destroy_rwq_ind_table = mana_ib_destroy_rwq_ind_table,
> +	.destroy_wq = mana_ib_destroy_wq,
> +	.disassociate_ucontext = mana_ib_disassociate_ucontext,
> +	.get_port_immutable = mana_ib_get_port_immutable,
> +	.mmap = mana_ib_mmap,
> +	.modify_qp = mana_ib_modify_qp,
> +	.modify_wq = mana_ib_modify_wq,
> +	.query_device = mana_ib_query_device,
> +	.query_gid = mana_ib_query_gid,
> +	.query_port = mana_ib_query_port,
> +	.reg_user_mr = mana_ib_reg_user_mr,

eg there is no way to create a kernel MR..

So, why do I see so many kverbs like things - and why are things like
FMR in this driver that can never be used?

Jason
