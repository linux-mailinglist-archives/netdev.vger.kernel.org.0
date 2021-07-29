Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335CA3DAAC8
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 20:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhG2SJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 14:09:03 -0400
Received: from mail-mw2nam12on2082.outbound.protection.outlook.com ([40.107.244.82]:32544
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229614AbhG2SJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 14:09:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjbAbN9ER60J3q3N03ZVQonGd1E1zablkwB5m/z0KOsT7i66a5kpq7ujql2NbLtwefrWcTeqFB+dsBz4eFAF23ArUeKVm506qgijgcD5Y96FJLP+OTHH+dpzixOQQ+CMjpFi95vv3kLfa7iPBTPciQiMQowBarDZos5lycEGcKo2qyVYeI16j3sovpw9jekZr6zbR/ljwHZe37Ko7ZuE0WsHXa5mfyTzqIRQxVi5d+RLF6GPC9g/yhFl/8GRFbefkZG0y+v3A4f6K+IK7cMKupVh+oVwGwpjv4BEtBDFgYYCM+vcP64SMKsSGvIIgEwnQ3Yn3m7x2gDlPLcS4S4Grg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jia6VYwix3lZTljkvgB6XLFJyZBWPqZm+GG/smpyN1U=;
 b=lXYEfz9b3wOqPq/tgThf2yu+Az/7Z6Z7xbeuDBUAettZdil5+R8wkHfDNzRjTAKAo5KwUeokn47MdMQGNQnvFVmjodNCap+SEOzgwwSwKgOBZ7itQ8ss2Yy2IKSHvmymWR9DmogZEPqyFjlztyP/ZYH/FKM0VBFqQFI4jkyvLPJfH7Jhn9Kc1yFcFVGwP7CIcpDNg31kq0oRZlDzCdu9JUvzpn8/L2V7ux8NUh89Pz+HYfSJ8fFtqQNUj5WlJ9qNQIN4jl/HCa/G3Rz/YI8fYD13KoUNAIaFhh2HtVo63F3E0Bmmqtvvljp6L2hxmTEl21HHuZcpMrhU641O85Xw0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jia6VYwix3lZTljkvgB6XLFJyZBWPqZm+GG/smpyN1U=;
 b=gnCez4ADyBTcjM7NbcuJtTHwlk9zU9SVC8qkmaQirhrUnfHyBU51aRInx/3B6eBy+rv12gfVldaC19X6jM/lf8yMmJH1G45r5wVpMbQX4qpMipoK0FDLF9lV8sfzfRVEEzHcadgXnwd2APuO9pxJ1BzTfRZR8086Q+5jJuJKYxaSkCmVvphD/cD1QsXZay5Mo/yIIGeJKGCnQwhq++b67KWkm5V1OF1+Vvj7ZH204ZTvzQUN/WQLK8mX9nj1kFB48F3QzCc2lwWBMK/BZRQdHng224wYdYhKG9b0id5I6j3sv11mWmYpzOI2VZXQ78Tp8myHlJHNxEXkdjFMEjmutQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5224.namprd12.prod.outlook.com (2603:10b6:208:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 29 Jul
 2021 18:08:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.022; Thu, 29 Jul 2021
 18:08:57 +0000
Date:   Thu, 29 Jul 2021 15:08:55 -0300
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
Message-ID: <20210729180855.GA2401905@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
 <2e0feba18d8fe310b2ed38fbfbdd4af7a9b84bf1.1624362290.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e0feba18d8fe310b2ed38fbfbdd4af7a9b84bf1.1624362290.git.leonro@nvidia.com>
X-ClientProxiedBy: CH0PR03CA0102.namprd03.prod.outlook.com
 (2603:10b6:610:cd::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0102.namprd03.prod.outlook.com (2603:10b6:610:cd::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Thu, 29 Jul 2021 18:08:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m9ASl-00A6Wy-LS; Thu, 29 Jul 2021 15:08:55 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2cf68ce-a87f-4f1b-8727-08d952bbeec8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52245C6F86E684444D131656C2EB9@BL1PR12MB5224.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Hpy4ppUEvzLKBpnJctuKQmPUrCCmOfnBCE2mgcYLzP/LkFXW4Or48JInx2ueZls5rNhpHe0rK54z1Kq6bUNmC0SfnedG2thCJk88jntm2zzEjOF9ekqhf0fwrB51j943pBvhJTomydZo/hsV8CGKHGVxBuK4hS6VLaUKTx0S8t+kNygnDOala75DRIYOt/kOweo0PJKxg32MHZPwnfW+I3YrH5vZSuxVISh6k6BuLATDl7DBjYym3Hpf2I46ZCFHj1Znh8NyRMEowgBV6ckhU8vwuYPN0kddU+WAxiT8WZJjGXO7cCtCqv2DSXcrGC8tOViCCWdJ690QsfYPt4NW17HDyz7YulgkZPu88pCI0Z6ZGpOXNvfLqnEyMwEmw7Ti9W3KQHeWYXMSEO+25NJDYt+X0rxva//sqdWbBwEVZbdBzVgLcGeNYzBiGqwf2r76fSHRyDlaCSgPBPHUdL34RpeWwChJIEcDbIGGpPzns4NaFlphpfTso7BMddCuMq1U+CeS+J7OkdJ/Ru/U13b/MGtG44fSXrERXDjD+Q+84+MAyQLShPYzhsLoM69tEdSG/nyRQ8YVWSm+F+w92dv5PceiCxh80ny0HFwDb5q5P74iwASbYfjqjmnmpxuQEWIisrWGQWMsdCHS3KSn5+4bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(6916009)(9746002)(1076003)(316002)(186003)(5660300002)(9786002)(2616005)(426003)(38100700002)(36756003)(8676002)(4326008)(478600001)(66556008)(33656002)(66946007)(66476007)(8936002)(2906002)(83380400001)(26005)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eqe8CVUduB4VZ1+i8pZO5cBMd/l5VoJTGCLTJJSknCSh6lIyKjrx+PZyHk6q?=
 =?us-ascii?Q?PktZUn+F8zzSXrMqjlSYQEfFYurP4OjuZco/VG0KNKYPSKdCKKJRf5A7uPeW?=
 =?us-ascii?Q?Tx9T04c9UKrRWOGxYK9A4YscUHW12Lt8G8/I7e9W7MJJ2FTNXw/Kuwk9VZPb?=
 =?us-ascii?Q?J1yhM+WBXPxmreGxYKbwdW7T/XmdtVscF5hvrO7lYdRCA0A504AMSWEV4ZQn?=
 =?us-ascii?Q?lpOeock3ohmIT0qVHQ9Pdw8PzxNam8NfDjo1dBll5s6lkQGYu+rwbbvIdqTL?=
 =?us-ascii?Q?4FXyoBdK0iE7EmCJuLDPqkO/xraYPerhckXveRQLUC9hQgghoLUEMHMdmzd/?=
 =?us-ascii?Q?ogfkW11Pbgom9ndWrhw17y0TvH83MwlZu+GHHFGYSVZMO6a5xcvGtIsXCcNu?=
 =?us-ascii?Q?pz6S+zxVk9u306nrSV7kACmMtQ+pRwvOtuDRUtNqA//T1NSYeCdUYrneLinA?=
 =?us-ascii?Q?Us7PY5MN7Tk6NcTnc68t/DK1TK/XlC6jNoLF6N2yydAmF3sxKLi6eIfRYrLB?=
 =?us-ascii?Q?P0dEZv/JdeDehUF3cpB8ZzMzsGd/XbrzKlhJWwuI4Zvs2S7anC/KockWyUoo?=
 =?us-ascii?Q?MsVlkMIpM2AJ3U638uGUUDxHLxbb8TqmwH0oi/eh/mlB689JNQJe3YrnFXX+?=
 =?us-ascii?Q?9oOWdTn2PaFLhjEtOIAGGRWjTdRvnFVVtfT0PYd0nLpjzM2woCV1zTOnypLS?=
 =?us-ascii?Q?xdvGpoQyJb7ybzGaBeCbj71xBgwNEq0Mp+53cKm/rbsy6jEq6Wre8iIUa05I?=
 =?us-ascii?Q?MpQ4mgKCUfaLPuew+6mc+zZ+H3Hu79X3bZIsl8Lkx24iy9UJKBWbftnqfAZ0?=
 =?us-ascii?Q?8UUstYYcdkgo342Ue71BjIN5DzjpHBqFKC1wB1yp6reYzFR+bwkUY2wQEhNv?=
 =?us-ascii?Q?QfVvDRCDONtgD0UbwGG/ojNkSwlf/i9KmmUAUSd0z5J01hGvpxnEbxlblyVm?=
 =?us-ascii?Q?SPfR+QygPzpZVD/FvS6bezsLuDf3f3NAqa/jh8qkrb5hBaDV7Sl58xgfu+sN?=
 =?us-ascii?Q?LDsAcUC2Bhg77+WZd06vjMnCjUYO/e83S2be6aNdZo7lnOJcdZ6GwMN7+9WA?=
 =?us-ascii?Q?j0zbLWQLHGbjW87ymigNJKNRSCFSAt+AYUtpD3VOm0L8gnFn8tUJBoVoxVLU?=
 =?us-ascii?Q?6vb5ij85noLandSvtIy3HzAP9B7NL4Let++dZzvnfRjEh0A17nhfEZB+gfdz?=
 =?us-ascii?Q?hv2FubiAghYxXHc738A4kac3cIe8Rv7LHbbEUdhtpRoilrABN4X8uHJRsgeG?=
 =?us-ascii?Q?/rUPGImZW8FEfwjUNA/EhIrvU+6+hE4EWJl0+o18me8LJut74vOW0HCfd3vz?=
 =?us-ascii?Q?fYiDE1ERkb+8MSBWM+ua4mKo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2cf68ce-a87f-4f1b-8727-08d952bbeec8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 18:08:56.9869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MEFJWs1Td8EHQ0czIOMF5V6wtbbei5raz05rI15rig1QFKoEq9qgomGuLO2R5F3W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 03:08:19PM +0300, Leon Romanovsky wrote:

> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index 03dc6c22843f..ae0472d92801 100644
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -89,24 +89,39 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
>  	MLX5_SET64(mkc, mkc, start_addr, start_addr);
>  }
>  
> -static void
> -assign_mkey_variant(struct mlx5_ib_dev *dev, struct mlx5_core_mkey *mkey,
> -		    u32 *in)
> +static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
>  {
>  	u8 key = atomic_inc_return(&dev->mkey_var);
>  	void *mkc;
>  
>  	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
>  	MLX5_SET(mkc, mkc, mkey_7_0, key);
> -	mkey->key = key;
> +	*mkey = key;
> +}

Can this be tidied please? We set both mkey_7_0 and mkey then pass
them into mlx5_core_create_mkey which then does

	*mkey = (u32)mlx5_mkey_variant(*mkey) | mlx5_idx_to_mkey(mkey_index);

But isn't mlx5_mkey_variant(*mkey) just MLX5_GET(mkc, in, mkey_7_0)
and we can get rid of this confusing sequence?

> +
> +static void set_mkey_fields(void *mkc, struct mlx5_core_mkey *mkey)
> +{
> +	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
> +	mkey->size = MLX5_GET64(mkc, mkc, len);
> +	mkey->pd = MLX5_GET(mkc, mkc, pd);
> +	init_waitqueue_head(&mkey->wait);
>  }

Why isn't this called through the create_mkey_callback() path? I think
evey mkey should always have a valid waitqueue

Jason
