Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219FB41AE32
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbhI1Lx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:53:26 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:21441
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240471AbhI1LxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 07:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMPgLP9jUIuUZXrhVvGmnqJqXitmgf+24tiJLHv7GY/NLIrUb1txMmVR/mk0lSOeJmaebfWpblxUX+Z2d81lyFP48wUBrekwBVfDIiXUTeus1MFCKSmmE7aWNFqUEWmMw3sqD+L3dCIkfTbR+UhjIf3A6QWIBDejXfY6iviMUIJA+woXrSo9cnl0q3BkU9m65EXQ0m8Y2LFjSQrgIx/v1w16jNAgIx7irgtYj7yqBonbFU2HYVtTuVA75fR8xceOcWjKFxAZc1xrqGw6JqEqh3cA2pw/2ibHsAJOdifEN+zwlH/2NXT6WHvCwEixjr1zRL0DtuzEuQMAx93tGGvikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SG1LOm3NRecU5lBkI6L2QqF2bBvQQkOcaji7Y5eqQ14=;
 b=eH5zw4o7NQp7FiLbSKicELl9RK4vA7F+5969Sksx5dDZYsiRE8ymE4KyEJbqhxtF3ETyq7ODSGypOVJfGkISctL044pKOXU5H7Y5U2rCafWKzmNxrZmTFrKn//p/XTsdrbXJpRJmOvRocfQpZ+kqbFhooHa+K0tiFFNdOZQ6SwXklGNow0eYiFfQ7I9vZV5JeezdWD8WBk2GTYO8dnrYS2RtiUXmPsULdm5kfmTg4jb2emimYBhR2kdCfBufm6qWV500GHVQ6JCEk9JhPeFGxRa6YpxCSR9vzxm6ilvm9eETEPDv/CoC+QWplvwavu70oV2DwUuRV0liUO1xaein8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SG1LOm3NRecU5lBkI6L2QqF2bBvQQkOcaji7Y5eqQ14=;
 b=CFp0oU+A+iZQCrPYX+jys+DFT/K3hpC861j9VPbl090m+vYQ1E64U+bBLpuA/3A+dDZ7dZ/gWNNnSXcD+f/q2IkrnIIxl+rrl3rgKKUfJkp2J4h/W+zPUUrOJ7BjYV0ykzQNGKRLMVmRpuHX/nMv6/MpWK+9qe9u/o4A/46sumvWSvnC3wo2RYa0wyv+62+EIGFzdpwMCoU77s2m1kVBzROQTDu/4HBSFDEv+mImQjeV1JYLvzeEiCVWW/VMOSrp5umM7IyBWN7WFBJ7KRpGXQol11tmC8pHI2ZAHVhESdbNxkzU5unooUfxfJvvVb4hE+evmGoAIlrWoc0l729BpA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5507.namprd12.prod.outlook.com (2603:10b6:208:1c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 11:51:43 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 11:51:43 +0000
Date:   Tue, 28 Sep 2021 08:51:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
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
Subject: Re: [PATCH rdma-next v1 04/11] RDMA/counter: Add an is_disabled
 field in struct rdma_hw_stats
Message-ID: <20210928115142.GH964074@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <97ef07eab2b56b39f3c93e12364237d5aec2acb6.1631660727.git.leonro@nvidia.com>
 <20210927165352.GA1529966@nvidia.com>
 <6c473b40-cd38-d5d7-78e7-b3f03142eee1@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c473b40-cd38-d5d7-78e7-b3f03142eee1@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0049.namprd13.prod.outlook.com
 (2603:10b6:208:257::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0049.namprd13.prod.outlook.com (2603:10b6:208:257::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Tue, 28 Sep 2021 11:51:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVBeA-006wu8-9S; Tue, 28 Sep 2021 08:51:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 407b6b58-7cfc-4c17-c2ef-08d98276572d
X-MS-TrafficTypeDiagnostic: BL0PR12MB5507:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55073E6C9B44A0873E498B91C2A89@BL0PR12MB5507.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eNUkaOV4jGlqNKXLSUWwKkbs5Wr2D3TMayqjDhMnZUMUnB5JK6Yug2hMVS4mZ/m4Xx6pV7EKT0Pe128Y4qeX7dRhTy7KTPTLss5cUknwDuoGw3cafzfgGdXYjkxI+mnXttC7u2fnyydB7naA/kA5wys8+VS0G6WSeT69IaijB99O2gLdA/B70IYnNoYrONEUFCoR76t78qk5CCJXnUsG2AyNI62Kgl+01dfAG+BLxlYsf6CHkoDVo/8xKd5a00BNxTdSAlIObpPQrPFsedOHCZGLXPZCE0iMoPcF19ARkpaaaCAv9g+irZ77R5J1FRXsZ98i/o4mo78K8kSzWknU3MRt1dDgD0isyuvIXYJvV4F6X+DnX1AeVwGVo6/ppe2cPPbmWh6+xA504ACefTYa/RQcu9h4DBMkcRuAlWKXZgyMQc9E2yL/D1rwhGcML+2WsOcX7IdLNjAhou06b7IhPC+rS8nTzC0+4VSOiY6ASG8aJHTrCzjCIOK7tmxXu3X71shXl9+x49km/sWLYjlSxWqRgc5PYEOryFTs6tw4W2Rn5DVqNRh7PVbbBGwwWStviVMxQgZ9zC9Q1wVDT9NQ+1t0GXHRDeCNfDlVA6v/1i6UOTvIwIdMwkeoYoVk8ygNV2zTv0HH3gfAKclt2tFgwEpZyUdBDbr0bSCdAzk0BTeqpU8KAT9sUv69Okk1aReR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(4326008)(9746002)(8936002)(9786002)(38100700002)(54906003)(86362001)(83380400001)(186003)(26005)(426003)(6862004)(53546011)(8676002)(37006003)(5660300002)(2906002)(7416002)(66946007)(316002)(508600001)(2616005)(36756003)(66476007)(66556008)(6636002)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ox5mHyqpgWfSQ5pK8xoccVtyth0salaPEXZtBevns7AWKisOIvm/aBJ3SXs?=
 =?us-ascii?Q?bspPoSsfoJ6UG4BlX+78xD46pOARhU+ZfjJfPRQoMXiJqnuHOcZn7VvlNUY5?=
 =?us-ascii?Q?YwiowzzLV5YfiwMW1jY666YAwVFmyxEQwyYVL2De9k82jzkb0vzdh9ICRQvI?=
 =?us-ascii?Q?Npo2i87D0JwDiLGfYsmD+Sa9ctme1egx9GkWjPyAwkAOVcXKhVn17JYSVDsl?=
 =?us-ascii?Q?hm5Hx4Dmm8S/3XnpjpziJXicMsaSHJi+yrc9N2Grz+FquuX9ABuyWPQIObcg?=
 =?us-ascii?Q?mYaYo4PF9QWKlZ3MrVYKNty1fN+U1Didm8+lG+lQXJR6gnGY6hApQp9KX3sP?=
 =?us-ascii?Q?XgP0DCe2KRWRGOJ0Taf16vXm05rZCbJPfoF9B4EktHxXRfYUy8Od72JjMRF4?=
 =?us-ascii?Q?BTQSzxLzm1ECDZoh/ZCDIvBLq1Inh9A1UcKQkZS74+lI6eSXtNpPL/FLiPXQ?=
 =?us-ascii?Q?KNbK7fMEpDhXEgRGqj9OT5F2HyghPuFaPRlgVZH5/ruBUYpzmQ5RMO0FxOo+?=
 =?us-ascii?Q?tNlqDZ5QAq0n9WzBCUSRigl5iNfxdkUN7+GS0F7sJuy3Oiln/v0BIhUtaOuE?=
 =?us-ascii?Q?efX8/f7xJerbEEwa6z9JokHQFoEfn8oN++IKl2mNLUCdNfW59SpLNpP+SHRZ?=
 =?us-ascii?Q?13tBqhLnRfflI6SZsgmQtKDwcl3FtTXRzS5hpsVcbsDOosFd/w1RBruIQjO/?=
 =?us-ascii?Q?OPagsaAFibGwKI2Kax32z3+lxcPzd44+8lBnCiaYS6+rZn7TF3kquvLufuem?=
 =?us-ascii?Q?yWyRRxcMD+TnO+xgxWECl42JYCVYXHMkMJ/F/vpvxtcHRJKMK3Fn50EOE/X9?=
 =?us-ascii?Q?S0f9PfcVhJgRHDMLwmhRRiU5j9MvTUnyNnFT14W+lOnqthP/KZyX1VRqLCR0?=
 =?us-ascii?Q?j+OhP/1/sZgDABanQXDLst06GVeaF9UIFHKX8VP/n3+oLQaHrKxB77v+bRVu?=
 =?us-ascii?Q?hMsKq6w8OCnTfWPEvU+Acf+uOUzJwHsYmt1C0qkh9HtJz8LitWHEuaWf8ou0?=
 =?us-ascii?Q?Gmgud2mxmg6/vuKBfqQWzrGqfRWfpdXcbf8yKrCY0/E6uXnX5ohAyleF8cZ1?=
 =?us-ascii?Q?JmB7RSLp2MelquQiXpQpvt2FVyw6MvUNNwzuPhkkvdexNT7Ytt8jb04AnUtg?=
 =?us-ascii?Q?6Jsu5hnwY20jltDz+D7udN0Tq47dmqCI/7KFtfo4weVGWxUFZ6BtUe12YKoJ?=
 =?us-ascii?Q?kS+dbjoG2Qw0Gn2rwkTv/YQ7KP89C7UObq6c30dd196BCBO/oxPPTPmmaT1W?=
 =?us-ascii?Q?IxZUzKnqwYZ0GC0xN4DAM6T8fF2t7ZWRHt+Jo5dRLVVIYnmNjeNxhiRLq0fc?=
 =?us-ascii?Q?y3ksDJRHgSu1RHLrVczffNgA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407b6b58-7cfc-4c17-c2ef-08d98276572d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:51:43.2294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5JxeVNOw8O2+vIugQCxDAscRXEwtvmgjtsXGCQsdVqbmLs74iF6aRIHCG5F7zc1X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5507
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 11:28:39AM +0800, Mark Zhang wrote:
> On 9/28/2021 12:53 AM, Jason Gunthorpe wrote:
> > On Wed, Sep 15, 2021 at 02:07:23AM +0300, Leon Romanovsky wrote:
> > 
> > > diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> > > index 3f6b98a87566..67519730b1ac 100644
> > > +++ b/drivers/infiniband/core/nldev.c
> > > @@ -968,15 +968,21 @@ static int fill_stat_counter_hwcounters(struct sk_buff *msg,
> > >   	if (!table_attr)
> > >   		return -EMSGSIZE;
> > > @@ -601,11 +604,20 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
> > >   	if (!stats)
> > >   		return NULL;
> > > +	stats->is_disabled = kcalloc(BITS_TO_LONGS(num_counters),
> > > +				      sizeof(long), GFP_KERNEL);
> > > +	if (!stats->is_disabled)
> > > +		goto err;
> > > +
> > 
> > Please de-inline this function and make a rdma_free_hw_stats_struct()
> > call to pair with it. The hw_stats_data kfree should be in there. If
> > you do this as a precursor patch this patch will be much smaller.
> > 
> > Also, the
> > 
> >          stats = kzalloc(sizeof(*stats) + num_counters * sizeof(u64),
> >                          GFP_KERNEL);
> > 
> > Should be using array_size
> Maybe use struct_size:
>   stats = kzalloc(struct_size(stats, value, num_counters), GFP_KERNEL);

Right

Jason
