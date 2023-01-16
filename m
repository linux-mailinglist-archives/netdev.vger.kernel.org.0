Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD98B66CE28
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjAPR7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbjAPR6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:58:21 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2065.outbound.protection.outlook.com [40.107.101.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA172305CB;
        Mon, 16 Jan 2023 09:39:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VM4FJYNDA+/qBwofI3xjWsiq5wyBDDD+TBCWf+yccNF/ix7bwrqq6Uzex4dIQWkjv8Lf7QQ2KVZlcvDobCsT9n+szYt2tCW2SoLVx1+0r5x1kjwFhRztjXtaHDu4pOlg12g9ZH2BHpzKwimVz22DKFcqRb1tk1awbsUeOV+6kNLPjkgnMhpbO58YN2K5FLcAmxg2UivpD6038mFgsgNz/uLl9WU03ZAeouJ/ImxWbdR4svvPqZZn+muk9OJZZ3bWbkQQ/4Osi2Euhi7YZeK04txzz3zqJpB7e3rhcY5Z4olxXxpOcaQcmr3t/Ptnhvvl8BATWYg76auMumtFrCbgPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cj7he6aEHAdV7kojaxUUo6huinQ8kqwxP++8RACu1BY=;
 b=lxsBYa8LTiG+Q5B6tQziR90zV5e+BMxOXx8XYWmnAP8FA/MopeFWMXWda1hcW3zzppEUc+i3lbuRss48BSlRpS1XBkdLlCgOjaslMmvKZkJxt+iXpH8RZXTsIzW0aa9dT+dk73+ZNAStdoWd1QJCxOkKhaylBpPP+6UmasaboQvXh7J3vLt0WxgxlEKE41S7uC9vov3L+cD0upRxYkmr+pdbot5oqrZ/27POTucgHNLhdI2Kh+UtOUs1Q7djGUH+fdFxNvib7XYUswDVDxp1hyOGKI2gnb6KUuH6OQLmj0ezZItZ/xvuxXcynvIMpVCTFl8o/N3Fc45NuLLs0xCt+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cj7he6aEHAdV7kojaxUUo6huinQ8kqwxP++8RACu1BY=;
 b=uQExVIfnnlp3oCDmFRY66UEWe6MytmeG+C1g1JD+Pf6s4T3IH+Y8+FLujEmbkElB2c9eQDpyXLtM0UIMdkvUCcOvt2wCwZL1r4vdTVWVGaE9M52uRCK/W3xItHm+xue+fN8dJkMacJtEeWvmRS1uPvVP6/zS/ny9egzThJZ1u2j9CLTEmRS0ciPn1MTeVieTicrEuNcxPhef8rfWKf6TLTRm8cCOUokbOKg1KOkenCuejZx8Sph9iEP3f1I0wYII6lM4ege2DAyCYEvUvfwi3QNxQX323TS+O5wIrEHTUKUpz6w1jo21usPKHZs+4I1qjIfY7fHnt6RIOv9s0BHi/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6564.namprd12.prod.outlook.com (2603:10b6:510:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 16 Jan
 2023 17:39:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Mon, 16 Jan 2023
 17:39:40 +0000
Date:   Mon, 16 Jan 2023 13:39:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 03/13] RDMA: Split kernel-only create QP flags
 from uverbs create QP flags
Message-ID: <Y8WL2gQqqeZdMvr6@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <6e46859a58645d9f16a63ff76592487aabc9971d.1673873422.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e46859a58645d9f16a63ff76592487aabc9971d.1673873422.git.leon@kernel.org>
X-ClientProxiedBy: BL0PR01CA0026.prod.exchangelabs.com (2603:10b6:208:71::39)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 9709d8e8-c433-4848-edcf-08daf7e8a4d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhGqcm+70oF3htcQltI+yuuirQk1+SwHi870pLn25CynUL1WwSYdWiKbPk9sqOX5N4v5IRTOn2yFdBQ0pFyd4oBl87uLRltH1N8DCeIHesFUZ8qvn19CX5OkI8oKBLk48iEhrb1GJuzCxhV8oRt4xxOniAyYS+wD1q90FpHGWO0+vspthmxd4Nt8gO/upMD/MNOtoBJ8rTQh82e/e6gGkQOnsqfWhKF/5M5KNLLwzxIM9rxknStJHsxtlBUYkJQEu3byAU6+sWyScWRfmrHma8/YSt3B0K8GirH9PHRK0LBYPfmZizmckxp9LTXEzIMWtP4552TVrFXs7BQ045a8Zd/14drU2JvKvWjF9VxsXmTMOMMQS+wJFs3+P4QVlUC669sSWfpXgowLw5SEoucvmQO4R2ayv/TO+iq3d1peo4DPY8+MWM5OdhE8ITFPnjEKh2l5B70zKxsHuZ7BFuot5DF6rsXwR+KtOuuF99ARWwC7M9WsEq4ZFlOpYmCC7VsUHzhszd6GiWE6Csc58kqQP1QnUtKjmaNzKMNmC0iKkH07SfjYjN1xhvRB6FfES4u5kKVEdzDKykWpd0VUiFY/FPHwVadp1bR/5Hlx6u0WoOCdewtwwPtaLfmu8BlojxmfSuaaLbm5HO3y/Bvt1dEnHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199015)(6916009)(54906003)(41300700001)(2906002)(38100700002)(316002)(6486002)(107886003)(6506007)(478600001)(83380400001)(66476007)(4326008)(8676002)(66556008)(186003)(26005)(86362001)(6512007)(2616005)(5660300002)(36756003)(7416002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2jhN+mgCWVdPrrtULIfZoKmWJd04av+CfUuzhvhIDTyxHDy6tXNv2VyFgAYo?=
 =?us-ascii?Q?6RGri+Z181oeoFM3pZybeX9qOnhv2pyBGypHEBsP1C4rG5xO9nKB/s+2grrx?=
 =?us-ascii?Q?1vj/WQtJefMNLTFsniOig1yF8XB8dioNVr0ntwy700wslMArXfsRowNvn9BI?=
 =?us-ascii?Q?YojU4BkcYjE7QujcdG0yLIVNJEollOG1Mhhkyosw2/qWxFpmkBUWDiRweM8h?=
 =?us-ascii?Q?PmghzLU/B6+JJ+4Lgofozx1WY/h/aLcOu96yicZQyV6u+yiQpOWN7uh65THV?=
 =?us-ascii?Q?dlB3CGOLy6B1esSDaFY0ThbtnUvAS02lS9+Lv9UzOCJ9KXxuEU04S499oB9q?=
 =?us-ascii?Q?pXhhsYP/nZ3OBi1hil0kuLY8FUBdKr0tV0k5hZIE8+3sfkPtF3Kir6ImyMIG?=
 =?us-ascii?Q?OFnCBSbnAxinVmf+jzmKc6ejQMgs/2oJ6YcZ7JFsQdq+IJAHgzYz4uaPqYfZ?=
 =?us-ascii?Q?fFqrk/HcfPE9I+yKfb+m2+ZvglyKrtTOG4gzRCmj7DTaDHka7xxo/OjEasii?=
 =?us-ascii?Q?bULCaV7e2wxZinS50BPLnXclOldbUAaykhn0abH+l3V1nffSsoxLYOVoVoGq?=
 =?us-ascii?Q?X3A9p16KR2ASb+oSr1JR4Z/cMJ2CfCzfLII/TJimEcK4FabU+5WQ8VcwvEDE?=
 =?us-ascii?Q?EquRzzKWyNSrZ8R8ELP51Sqec/qTdkdwFlv9Fpf19BNIIVFJ4bxRFhrkPpT7?=
 =?us-ascii?Q?wVP5gcx09kfQjw5o8HUXZo5s/zX9eVMLoHFqpBiuuQRytPwtGJqE/rJjaea+?=
 =?us-ascii?Q?tBVYnlyKUdnuf+85/UhDgHmLb46Q761KUrpSQKhnrLzypikVipL9dt1ajzS5?=
 =?us-ascii?Q?P+J1F0u1wJeuXPFPpnub7EN6GaCTjsJiOrHOL+fiXgB+I6DWQeIbxzJlUHxQ?=
 =?us-ascii?Q?0s+et1Go1J92LwkG9h4xdC8+GMmJhxGXpNGByRvY9OU2k2nHDAJwqDXqwpMS?=
 =?us-ascii?Q?zQdnLKcH7w4523wu4nFyFCJLeJWmESRnH8l5ou/aDBVcuSEt+lyXyuEzM6+d?=
 =?us-ascii?Q?iuZIUcAfZic8yxqcxtNRSUTD7NG9URQyCa6sPtSS7/ApKnozHRR27dAjmT8d?=
 =?us-ascii?Q?+fLXROHEtGBRP8Ufg12ZNn364tMFd2d8hK/fALjdLOmXB/c3j7QBywCNBwfn?=
 =?us-ascii?Q?JcKnfN5TUIQkK2GhHUraUX9dOk06DEkzS8JNx/y8hSRMpyjYICCbzZvUMbye?=
 =?us-ascii?Q?0kmraPecHxHiDv0NUPOsIprxxe+h8LJ9BLkr0FsZsK5NyC7kkJyyGOH6Qtbr?=
 =?us-ascii?Q?TTRMPXAEq05aIYnONqeRDS/lwpDbOq2sXftwBzHEHXsW8xwX/mAEUKpn67FK?=
 =?us-ascii?Q?ZSIQ9JrPNFbHNOAGiUI7m46cbXXFuj1bIl3MW42JbuYvX7LPJHuPDSS91zyv?=
 =?us-ascii?Q?QPjwwZLqzKDc9x798ArjzEwrOYHTTD73J01/FyCWl7n4c/es2nIRSq+Qe7nF?=
 =?us-ascii?Q?mZrBALgqrknyNPuFAV7E31WXScqttJetD+poWDplG487kj3FV562J/QkiXAn?=
 =?us-ascii?Q?cwlrl5NiAwknmr82lAlyQwSttqtT1Ff0gQ/Eu6jJ3ZYIHQB5z6qu616JI3JS?=
 =?us-ascii?Q?5rZ9VoaXaJrU1Lmhif6JdRfyGtaOGZj2n10HmcjT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9709d8e8-c433-4848-edcf-08daf7e8a4d8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 17:39:39.8999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZ9fbuGKhpd9XSKckBlzMqDFIbGo7YfCP1H0f5o6hPVuaC0duDmXP4bFKtgFhZOT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 03:05:50PM +0200, Leon Romanovsky wrote:

> diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> index 17fee1e73a45..c553bf0eb257 100644
> --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> @@ -184,7 +184,7 @@ enum mlx4_ib_qp_flags {
>  	/* Mellanox specific flags start from IB_QP_CREATE_RESERVED_START */
>  	MLX4_IB_ROCE_V2_GSI_QP = MLX4_IB_QP_CREATE_ROCE_V2_GSI,
>  	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
> -	MLX4_IB_SRIOV_SQP = 1 << 31,
> +	MLX4_IB_SRIOV_SQP = 1ULL << 31,
>  };

These should be moved to a uapi if we are saying they are userspace
available

But I'm not sure they are?


> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 949cf4ffc536..cc2ddd4e6c12 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1140,16 +1140,15 @@ enum ib_qp_type {
>  	IB_QPT_RESERVED10,
>  };
>  
> +/*
> + * bits 0, 5, 6 and 7 may be set by old kernels and should not be used.
> + */

This is backwards "bits 0 5 6 7 were understood by older kernels and
should not be used"

>  enum ib_qp_create_flags {
> -	IB_QP_CREATE_IPOIB_UD_LSO		= 1 << 0,
>  	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	=
>  		IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK,
>  	IB_QP_CREATE_CROSS_CHANNEL              = 1 << 2,
>  	IB_QP_CREATE_MANAGED_SEND               = 1 << 3,
>  	IB_QP_CREATE_MANAGED_RECV               = 1 << 4,
> -	IB_QP_CREATE_NETIF_QP			= 1 << 5,
> -	IB_QP_CREATE_INTEGRITY_EN		= 1 << 6,
> -	IB_QP_CREATE_NETDEV_USE			= 1 << 7,
>  	IB_QP_CREATE_SCATTER_FCS		=
>  		IB_UVERBS_QP_CREATE_SCATTER_FCS,
>  	IB_QP_CREATE_CVLAN_STRIPPING		=
> @@ -1159,7 +1158,18 @@ enum ib_qp_create_flags {
>  		IB_UVERBS_QP_CREATE_PCI_WRITE_END_PADDING,
>  	/* reserve bits 26-31 for low level drivers' internal use */
>  	IB_QP_CREATE_RESERVED_START		= 1 << 26,
> -	IB_QP_CREATE_RESERVED_END		= 1 << 31,
> +	IB_QP_CREATE_RESERVED_END		= 1ULL << 31,

And these should be shifted to the uapi header

Jason
