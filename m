Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4094D3DA795
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbhG2P2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:28:19 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:9120
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229657AbhG2P2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 11:28:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPxT0CxTWtzXJVKZS/ccj7QN94CDTHVlLDphtiEqOUqDTvRsDw2aK5gzraV6l+/WzBNTPi+t0YpyT+7YpcJp65oMzLJ1VMb4+1VLAT/LgmekC1n1STF4uyWUzTBCw1brwXOPG+8kFGVhNTmZmvK9NF0ygU6+l5ii9n7zrRCaEGH2K+DCuAO13583/bvNmuvvcfUxssgR+RnM/b4CCS8cpJOWoBW8/OGWHaWTw3a0T+wnsj+ByVPHlc4gBfB+q5Tu3+6F/3FWmVY036ArmnDk050WDWqWkgz16bSsmZvQjMs4beOdAH9Obxoj/J6fcpefaIbuK909klVQapUGFaxGUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6iyvUrHrRI9ykVoBhql87NkFXL2lbrZp1QXUdonfvM=;
 b=KQ1b0MeQPW84ios6e2jvCNJCj5FzXXcrfWaTqK5eWqiF06ukAq4KXNl/PwSFr259ikxCvkbFanY77yOrSQjx/BVfX1lC+VZ956WQEIvG1nOaWLCQwaX1u/2b1OfvgAOz/yqmkhu5/Gow8rCpFck8ZgkJiCPb3PJfyx5VeL3Dw36QqqI/g+rzmpesJahFpKyE3TnHHdQ0sYFHHZXClKkWGJKENuS3RL7NA7UDrFE/S4wZTQsk/rN56YwGHkZ/07ZxsPsR9n3PPWtJrbbfBzdf5pIpt+DDYZmeXc3fhSqKmBS1k6FzhSitFkg3OXwpIdxsvkrG4gGB/Tre6iwKRYsKBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6iyvUrHrRI9ykVoBhql87NkFXL2lbrZp1QXUdonfvM=;
 b=FO3YZJvddpRY4wK1fuf0JE9za+FzxDG2awn+YIBEpGXaaXqD/oIjNJ8/16/Kaq9L2cep0RUgHrOJyG51aXNKF5vpyEkyPwNAefhnLRWCEI6KSTy1ircxmE0LUhsVjcIPszqzmau6oppcCFL0Uej7RDu2oHfrR3FDQ/npZERTte2Opg9KWyYqz3PeyB2HB5m41l9owWhb4usyk6hQ0XJ1wqbbIZPofN0qrFPYqAu8GzVSYMeyn/0GGuZ1aKhkbK3AEhbIxxRz37Sw5AkkwfviKj12nHK5fSX+x0Quli+L3TBDNIFhmCbSCGCcKhuwZNnCJ/ofRaW3XyHOb5Ko9YwR8w==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 15:28:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.022; Thu, 29 Jul 2021
 15:28:08 +0000
Date:   Thu, 29 Jul 2021 12:28:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 1/5] RDMA/mlx5: Replace struct mlx5_core_mkey
 by u32 key
Message-ID: <20210729152803.GA2394514@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
 <2e0feba18d8fe310b2ed38fbfbdd4af7a9b84bf1.1624362290.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e0feba18d8fe310b2ed38fbfbdd4af7a9b84bf1.1624362290.git.leonro@nvidia.com>
X-ClientProxiedBy: YTXPR0101CA0063.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::40) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0063.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 15:28:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m97x5-00A30q-Eu; Thu, 29 Jul 2021 12:28:03 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f238014-6750-4004-0056-08d952a5770e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5175:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51750627461AA481A1F5D1B6C2EB9@BL1PR12MB5175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMD7Gl7HbmuUubKnzm/+yEYh+TRkUfRNqMM9h2WsgAndcKsn9RAeCjacT2drezZyEzL331gDjBfh0nRNArDklEqLl+q3TlJJmeSv5nph71HidhTXXsWtr1Nt5RI51EoJn+lUWxlBwOS9A7ejgXHBOWPz5Wns1rHG3BVN4Ld8hFhqS6yf9SyOmUPrLqZRPtAqWRQ5rx6u6Dj91lu6pNjoGKpKeOh9/p7iAPhPmR+FVUqmEOawe8XwgkBETyV/pzJ6Lbrt/d68fpmktZn2ZnNZ99gheLeY7IfyUbAkfwuExhTYNkYWtGuMVAHIOt3awEWO+SU/B4Z3chzDkrtetIOjvbnk4ynOtQIYSVNveQYKfgMPqPjJXSQwKJTPzItVt/9s8V9OmeUa1hAMV7E0k3QuUiAXTAUtrilfvAkzVHBS5P9ia5UvTtLhLMsvPWR1NYbnpCALppKJXfaD9uLl+xQwcut+SlPazmcKLCeUMFn1frDogJybDMo2cXUuqgEF8Gz79oeNH2kgeT12D+e58Kn+1pKVY9Mk/llTtTWmJxIR3ILhKTiaUawKGYozXwvyLTz8DpE/uh214RW69m5MUxp7lk+CmErsKdCrpT30QBmYYnrcp7RmPvhBTCvVpqUNS175Tr8H9deC/ujFIOsVYqN+hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(9786002)(54906003)(66556008)(186003)(26005)(4326008)(36756003)(316002)(86362001)(9746002)(426003)(8936002)(508600001)(1076003)(8676002)(5660300002)(2906002)(2616005)(6916009)(33656002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6guw6Rw4UjDRc9ojeylFLNtXn8EUfPD2/uQjAIWXjnTBzynjJ1wan4ypCrMV?=
 =?us-ascii?Q?yl2AErhz0LviGTjx8kthC86mEQeHS7BZEM7FuJNFTvVGDTp0ugJilJtO86XK?=
 =?us-ascii?Q?cgUiEdjBiIiPla5PrOYpzwwxwSWQo6VLVm2MUnAtAF7dT9CMP0haiItqsEui?=
 =?us-ascii?Q?Et+N4sgbmki368zl5aGqeH9kXCCrC85tYnf+FseqaBT/EtLxcKXKXyHbpojv?=
 =?us-ascii?Q?aKyuDpiFMaQQpdPizy1g9/W1XCxNlvuhUY+ZubX8Q4ML9Z7B/xAT8Kb64ikm?=
 =?us-ascii?Q?lGpT+9AV439k+oiXjmH/cKHi74a31dzgDygdbjjRaP6ZLGCmIuMTXrWeM/oF?=
 =?us-ascii?Q?q4C8KlWz0p/+4LVDfT4XmI228fqm25Ht008IQNCO5qv31AgKWhjfpaaIBgmu?=
 =?us-ascii?Q?iobDnVCt0b/q6idH+Ja6Hk/jtm/s5w8xK9mT/BeiU9DvKG6yVsCBTkfuNKsi?=
 =?us-ascii?Q?v9E7ixXgNlXOsWHjEK8h8A+9ymu+OC3XqisSrHjxZBtful5BFu1Pisyj8nCV?=
 =?us-ascii?Q?0uQmixonXZWwToCmtVWL+g3EGSU6WKjpVs0ANa5UyrHo5zanXhif37HX+o79?=
 =?us-ascii?Q?8c+i5JKCQ3lyxrWveRbF8IBhEn6ZE8XsuPE+D4GfN2EZbDrJdhBzvWLucYbn?=
 =?us-ascii?Q?VbIjUXJcgeJoAfDIzwn7iuGyIdmfP+Vb4MY6v+DQfxHOdQj5Hc3dGlNZQLdl?=
 =?us-ascii?Q?tvc8d+OsadR+SJ4yI/fesmXu6b/jbtdrbnqpVPzN1HO2jti2EeMOxKz/SadZ?=
 =?us-ascii?Q?lALO52sOEPazzKMj0JofC6dnUismLeVclo9h9vLg6jUL7j2bJw+Bt+RzaBSv?=
 =?us-ascii?Q?u2N2Mk3Ug4wOY5CDI7PEokAvG95na+59jTcepkLuHZEQ+L/AUpfvYJfTzhV+?=
 =?us-ascii?Q?sLNMaQzvwAcRbYwyq880bbbFDrPuGLzOQ/F4qISNUUDwwHYnOItBzM36qaYm?=
 =?us-ascii?Q?B9kSkuyhEbBgIcCDGTHn+8AwUN+faawAzoqj7Lp/GmHdTxcd3tVjwkLSu2sD?=
 =?us-ascii?Q?mgqbxy7Qh6+yjyu3N9Lw7vIb2zTdSSEovzBQmFnByslVk+6duJz7Kc3jP7zl?=
 =?us-ascii?Q?OLTfVB7XaGFk6OFn7Zp5FlkkD0SAcL092hF/+y2z4vVx4E7LnYK8VWTtR4/X?=
 =?us-ascii?Q?SKtlrqzDNdnCLcE4H17+f/83e1p7DiFKryWlv/7HBfrDIVqtU9fDj2MGMtmJ?=
 =?us-ascii?Q?tW33e0t2Si/CEcpycU8tHccFWB21BbIxrms14dkCsWpiOO79VjLSmbnz+R+b?=
 =?us-ascii?Q?MC2p8T3X8EsUodmkCpao7cumAcT1oAWrCYvjMmL/1oRWiMNbor6D5SjvkOgZ?=
 =?us-ascii?Q?v1KXc5AsE/+fZTUQCjY/MYO7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f238014-6750-4004-0056-08d952a5770e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 15:28:08.5814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5nzalmCxfPquprOpAmA46gjWaUM+VKs/1Q27Pmypj4Wtpsst5BL9m/nhf3M+XX9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 03:08:19PM +0300, Leon Romanovsky wrote:

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> index 50af84e76fb6..7a76b5eb1c1a 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> @@ -35,13 +35,11 @@
>  #include <linux/mlx5/driver.h>
>  #include "mlx5_core.h"
>  
> -int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
> -			  struct mlx5_core_mkey *mkey,
> -			  u32 *in, int inlen)
> +int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
> +			  int inlen)
>  {
>  	u32 lout[MLX5_ST_SZ_DW(create_mkey_out)] = {};
>  	u32 mkey_index;
> -	void *mkc;
>  	int err;
>  
>  	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
> @@ -50,38 +48,32 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
>  	if (err)
>  		return err;
>  
> -	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
>  	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
> -	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
> -	mkey->size = MLX5_GET64(mkc, mkc, len);
> -	mkey->key |= mlx5_idx_to_mkey(mkey_index);
> -	mkey->pd = MLX5_GET(mkc, mkc, pd);
> -	init_waitqueue_head(&mkey->wait);
> +	*mkey |= mlx5_idx_to_mkey(mkey_index);


This conflicts with 0232fc2ddcf4 ("net/mlx5: Reset mkey index on creation")

Please resend/rebase. I think it should be fixed like

	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
	*mkey = (u32)mlx5_mkey_variant(mkey->key) | mlx5_idx_to_mkey(mkey_index);

	mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n", mkey_index,	*mkey);
?

(though I will look at the rest of the series today, so don't rush on
this)

Jason
