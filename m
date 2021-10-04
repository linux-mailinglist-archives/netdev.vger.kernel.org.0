Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886934215CD
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 19:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhJDSBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:01:03 -0400
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:24577
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233615AbhJDSA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:00:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgiX91AmeAsMfHfaFKN9Z4eaGXMXKE7yKeoA2ATSNIC/lQagJA8pqZghooqA78oSGo3Tz8J0MJb+0MpLLpYVlb7VLtYGSK6WqffRXLk22K3+xSKS2WzAKU693Sciv04vtUfsVpibbo1CKRY0HntgHl9UxduZuw6kZysPbYaOaEyInSHekgqNAaqUfA1bNdBN3Ep+hYUUgEdP/bUIH6uDIBTbuUwC1cesZOaeuJ3e8iD/621q3nO0AmTSQl3hFPYRoH/R1n/Op8Y38nCYhKV35l/qC2+qanAiC1B4zuqBr2aA378cmO2XMjqTLfAr4L/KGP4xQnNal5N/M+rv9qj2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXxMaPLcXng/2v0fMx9WMUL8/u3atA50EQoD1vdAHzE=;
 b=R1PooONNhoKn/9In+NbdoeBzo/5H+3AsIzx7NyYcHfFeTsHWCe97ptGXH/Z0sFI3EvKLdIX0wdB6lx0CGcNUEABlkQQAG12o5jCFIdipcv3WX3+N1AzMYnoHs3WLE54q1DDjHzkCFwysdz41mwxcfwwlATgpc2cAOI8DOn4zYVv7dklcyJrciL+LmSjGQEHPjfg3YOEuWThqqih4b/713cv+TV4onFwLdkt86xsLNWCKByl65GXPAUhGRfCsECa2sSsQMBFF78+4Sld2wMwGtlsiZZMJ5kLCrXy9OcbVoH3Bq7YfBb9Kr+Gk8ybNI3smXxQmi58ly6e8d3nydDTZ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXxMaPLcXng/2v0fMx9WMUL8/u3atA50EQoD1vdAHzE=;
 b=bcxVl/WWNYH4/XCJkluwh0zPEJCQ4hYNJelc2C7BQX6wlPGLttZ1XiHS+V/iUK/4OGjoaJMM0MPsyCmLqTXcSFctu17eIuUpS8Ximeh7wr4bzxhMAEEJu8caOnDKcaDKxaYPfjiVoUaBDJmeC0IBT0waWVvpx/D9k3qNGkFeNewEL2ijQDq/LLb4ATS0Fi3gW5zg9/N/IO/3KbyJyRWNOw6EUxR6GApMbpP+oI9H3x8p1Ogb1UE5RKBhEy2VqH9M9pmpaFOpKT7VE4QmUPnOEnUZqsbOLnzqnakzGcx7My3YCl8E7yrNHfeby5LQjMwc73KwZGxG4RuoYBRLo6IUeg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Mon, 4 Oct
 2021 17:59:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 17:59:07 +0000
Date:   Mon, 4 Oct 2021 14:59:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v2 04/13] RDMA/core: Add a helper API
 rdma_free_hw_stats_struct
Message-ID: <20211004175906.GA2515663@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
 <905b8defafbd7996949f95f7232ce4bd07713d7c.1632988543.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <905b8defafbd7996949f95f7232ce4bd07713d7c.1632988543.git.leonro@nvidia.com>
X-ClientProxiedBy: BL0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:91::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR05CA0024.namprd05.prod.outlook.com (2603:10b6:208:91::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Mon, 4 Oct 2021 17:59:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXSF0-00AYVQ-S8; Mon, 04 Oct 2021 14:59:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 455ff600-f017-45bd-3a87-08d98760a941
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52080738ABF6EF7337B06601C2AE9@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pn434+IhPHtwtFQVN/tb3prII3Jf9odA39HPRKLvIk81GqzYh9ty1tHix3URHxvPagK2Mki0HibT1Xf+wqfCgOwUY/OfWJ5KA4jwe7IHvk1Api6lHDf+X9hO5lNYc5PW77G2oSAd2du5j+BLjcv1CFp00TrgHwFYrVf5S/lT1Si09rqqW9uQ8zZHWyZWr1SeKOwLd6XAu1lELfKLiUXCPkQ6iZcLGBzvVTEhlLKO973u1oHEEKIraKkwW2DaqY+TO/k7WI7MQW7l5qzgerheWe7xiCJWHv3K6vT37MgegTgLPMyVf/mlUilG3mBzT8VBcG0sTpV9MKRf4PIILIXqtvw2IvlP3uak7iDj6TPwXvRWfaPhYXfCh+AfSyVlZFdA7kdjhcGBFcfWSfe58nM02FpVUsnKSlLRoAtQ0SfmsQuWLX+v1KCUF6gGN+rcuRUrm5bzLdYurBe8+ZsZ6N0AK8urGXYPNDoXPmTHxBzA7+Vn6C/XCa5mGvG/2yJAjzuSg7Jr8N6iY6uTKPpZbeYLfzrrChihbx0wzAcf3Hm1rodMbCi4vbXFAI8LWxevWY6fmC65fpxg/8VDA0mQiEXjBMuvR75b9jm/WqRH6lyIbMwKaits9QMZYnnaXLEyAyFQ0yVX4iRv6xEbnwTWQPmhow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(86362001)(54906003)(4326008)(9746002)(9786002)(26005)(186003)(33656002)(1076003)(316002)(83380400001)(6916009)(2906002)(36756003)(8936002)(8676002)(66946007)(508600001)(426003)(7416002)(38100700002)(66556008)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8DiiljzS8qP1Eu0/CSRMQ38Rqr4Q7FEl3qHzHf5WDXhoscCZ74RxT4n5id5u?=
 =?us-ascii?Q?kNldUfReVV4a79VtjztAYSKo0dlSLJNmIz9ERjT83i0l8sUvKFJZWFGQtJ+d?=
 =?us-ascii?Q?NN+PDVhnlrgYB8bHHdRFRCLcAoQlB3JKLWzZwMCvyIHzqw9ZJYS1tbDy5+eS?=
 =?us-ascii?Q?xrC+DRPGBXKLcaemOdYJv8UjVpaTlYjZD6tK+oK7W2Yh2162vTeMbRS/fNtt?=
 =?us-ascii?Q?b7qmX3jKc5775UDIAq6hjSexI09H4YX5YFOPe6JqVKnVcpfaDjXoyUSAfRDz?=
 =?us-ascii?Q?KlkUD8tQM+B5osDP3MepVwIPQ8ZCXEGStI10K85Jo7o7Bg/6HhDd8Gucje1Y?=
 =?us-ascii?Q?Bde9nlyRlSFop/vy9PXvqql5pHZmqMKSODZHOm3EiNKqs3gOZr4/GQFsGzOH?=
 =?us-ascii?Q?Z5b4MQXHcZCETqILDF7CQ8URYN6NMA9vohTezOm+H1SDOohTEQga0vdG6z0/?=
 =?us-ascii?Q?DPLgJJ4yafEJAdzCic3Hy5akAd+dffrWZcBBIwaubbGahqP6pz60+jpqg0cA?=
 =?us-ascii?Q?hBRY3B9Fq1g1UnVozZnxDYCNIoOeirzUInWXNrsUP/+sNT9jY8avkhLa03Rs?=
 =?us-ascii?Q?E4CNKnuDKqMnKHG9DiKIb1a9Wy+XvitfjrmDGiMvUJO2RGJQf8YqVs5lG3Eo?=
 =?us-ascii?Q?W31hcGmDrirm7lcdTbuLCi87NPUN2cRv/Xw1aum9C4oE4RpBVpOa6V78Ziev?=
 =?us-ascii?Q?xzGRcmaNsvDSpFPKXx8nUmj6xTDnJTInCCsf/23gTpkSrNmkFb6EwJHSnHW6?=
 =?us-ascii?Q?wIHlWH/LrNH599AFgmgyEFI5pKGamqAA7Prns8WOebdcAAFYS9822jcs24ZB?=
 =?us-ascii?Q?5mwJai84cSkS59QjZiykjsBBQ0Oea9AKXk6V6jRQKLC6oXgCZ6TeYGdTLFdv?=
 =?us-ascii?Q?Zlq8HQPNHYsid6ESVlisxdXOo0e7B80yUEe6QlVUrqoBS/VVoXz5MFQcuRM9?=
 =?us-ascii?Q?aTlY8xd9sPpfJbsqFKcCUz5+WSI3LjoFQwn3biDtS65Gv+Adv3qB4ie6TDZs?=
 =?us-ascii?Q?u+yXqakdxZP/ktYZfgRKzFlYn8JoaC4LwbxnCcLE3sptmnUMvGNwNuY2nitC?=
 =?us-ascii?Q?oMo+eeX3L1BYs6gO5bNf7DCk/Gw+I9DKdfH4F+f4SMynN5lzHKSQMXmY0+wa?=
 =?us-ascii?Q?1PCNHi8EGYTHC0VBQnXFXMQyWdMwHL76kUwiPJ6QyHLHOjYAUhjcFPk8n/kI?=
 =?us-ascii?Q?+18x+8KVE3ms0vZuH55XnKceMZYcQxSwkqgyVxsfeP+nMls5GIR5kvcWU4/j?=
 =?us-ascii?Q?+Vse/vjJhPkFS9yLgXKusmWMcSAGaSwhQsjYZ+pAPGGO8gooyK3PY9SPVjoB?=
 =?us-ascii?Q?pHALnpKkNEaY/rwjxKTdb7CIbLeJUtInqj7+lWM67QaP4Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 455ff600-f017-45bd-3a87-08d98760a941
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 17:59:07.8468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /yLGGoRqujKdNzM6tXVD4z6K/VmwWmdBlkafriFzEQrqsl33NNRXoMGX+3i6v5sv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:02:20AM +0300, Leon Romanovsky wrote:

> +
> +struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
> +	const struct rdma_stat_desc *descs, int num_counters,
> +	unsigned long lifespan)
> +{

The kdoc should be moved here too from the header

> +	struct rdma_hw_stats *stats;
> +
> +	stats = kzalloc(struct_size(stats, value, num_counters), GFP_KERNEL);
> +	if (!stats)
> +		return NULL;
> +
> +	stats->descs = descs;
> +	stats->num_counters = num_counters;
> +	stats->lifespan = msecs_to_jiffies(lifespan);
> +
> +	return stats;
> +}
> +EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
> +
> +void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
> +{
> +	kfree(stats);
> +}
> +EXPORT_SYMBOL(rdma_free_hw_stats_struct);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index aa1e1029b736..5e8a5ed47e9a 100644
> +++ b/include/rdma/ib_verbs.h
> @@ -589,24 +589,14 @@ struct rdma_hw_stats {
>   * @num_counters - How many elements in array
>   * @lifespan - How many milliseconds between updates
>   */
> -static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
> -		const struct rdma_stat_desc *descs, int num_counters,
> -		unsigned long lifespan)
> -{
> -	struct rdma_hw_stats *stats;
> -
> -	stats = kzalloc(sizeof(*stats) + num_counters * sizeof(u64),
> -			GFP_KERNEL);
> -	if (!stats)
> -		return NULL;
> -
> -	stats->descs = descs;
> -	stats->num_counters = num_counters;
> -	stats->lifespan = msecs_to_jiffies(lifespan);
> -
> -	return stats;
> -}
> +struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
> +	const struct rdma_stat_desc *descs, int num_counters,
> +	unsigned long lifespan);
>  
> +/**
> + * rdma_free_hw_stats_struct - Helper function to release rdma_hw_stats
> + */
> +void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);

Ditto

Jason
