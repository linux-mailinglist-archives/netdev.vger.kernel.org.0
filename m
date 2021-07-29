Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694E03DAC01
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 21:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhG2Tpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 15:45:54 -0400
Received: from mail-dm6nam11on2056.outbound.protection.outlook.com ([40.107.223.56]:36416
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231984AbhG2Tpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 15:45:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaLT3BFH2CsVUHtjeJ+rUjPCGCvCdXSRZ8id28Yg5qmkwUlq/OZVyeBbZtG/OU8aXHUweUlfJhPqkvX6jaXEO1o7M5N7xlHo696eDZjSfgXRulWrtgFmuAotD0Z4Vqu9OQIx/+faKAk+wystk37UttqCavFpEeyXmdYBje8OcyE48ZEhBDBtITbFsVMh8pkZGbwVFf0YhVnigEHL7MB3WxDgk/sS30BhP/3i1liESDBtws2vWTOIrcndoIZtwjAvUKLsM0W9BV3PO0hRw2B5EUgM6lpUccm5Hh29JgNwhMNXjmI531TWlVNfKg1iDphBvUuZSy+6IMg+1YXPcII1cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEtscC5ydmWmb2o3kuaFhKelNkTtnUh/nxUUIokPvrg=;
 b=Bbf+4jqD2xGZ2Hwe7SeQ/jxst05GoJomqZP6ZbPFL8NgPEh+5CLmsqITlL2EzTvjB4Cgeg0Oh8QaDseYY5cS0tve5DsaAtBiO2XEaAMWmk0AZAdrNlTQnhbb3Yor1Zxen4y8j9GaKC1785RQz9inIL2542D+PdxpD2111w+fZ8NS5qlpiyBMpoDGURT+a8/Kcpc4YxudlEXeihNWrjQIcs8lVWBmoRHwCynILNmBvrha3GYqPoLATLjFw+XNZ31lE+ouYQNp8UG9MV4VMEBIHlJK+3OXBmjybgYeYOECDnoO11yY9eTyC29K1zrvndrj4J9DgVtAkIcjzOB9sySU8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEtscC5ydmWmb2o3kuaFhKelNkTtnUh/nxUUIokPvrg=;
 b=R45vSKvOLJ7XUe6GW1Ii78JG6fNdNYI2U3O4XwPMqwD4ulcLhzQlYs+O/rvL1BkF2Y19PPOm+x7G1YIHTUhorACFsKwKQ1DFAj45uNbqFk01DcQ2AqWIqmIb3yPWrKSehSywCmg2FHcacHtQ5JraRanmWa2+hwym4CGRqdC8PxvnS189Eqc95/fyMXm52dsQJX+DzBLL+3SgkwMnFVMrTgeRHMqAbJYao9ybf9mdY14E7Ei46t28ZRZjs54mN2al0o+0/IUCJyMyJd4qp1uqG6TlkkrNkRp3myUoFh3ljnXqDbtHjOn9kfZ811B/+YVPpHkocgAHJ5Pv3YF9qFyhEQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5555.namprd12.prod.outlook.com (2603:10b6:208:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Thu, 29 Jul
 2021 19:45:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.022; Thu, 29 Jul 2021
 19:45:47 +0000
Date:   Thu, 29 Jul 2021 16:45:43 -0300
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
Subject: Re: [PATCH mlx5-next 4/5] RDMA/mlx5: Change the cache structure to
 an rbtree
Message-ID: <20210729194543.GA2484190@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
 <f4dbb2d090b2d97ac6ba3d88605069fa2e83fff8.1624362290.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4dbb2d090b2d97ac6ba3d88605069fa2e83fff8.1624362290.git.leonro@nvidia.com>
X-ClientProxiedBy: BYAPR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BYAPR02CA0003.namprd02.prod.outlook.com (2603:10b6:a02:ee::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 19:45:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m9ByR-00AQjo-UG; Thu, 29 Jul 2021 16:45:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8544f805-f85a-45c3-2944-08d952c975bd
X-MS-TrafficTypeDiagnostic: BL0PR12MB5555:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55556BAE8ABD9662B1819442C2EB9@BL0PR12MB5555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P8ZSgm2TR6pmF+qLI5oTUDNzB4SmFNMpdiqJDaecMz0bfljWFqiBvEnY5og/7WzEQKxMr25Hj/uHSsqrCcLZeEZtW3Ob1wWxftf/wbrpYlUjR5vxtTzDfiOoz5ajxoTzInh7haS2PS8HdC59FTGEAfWt+/9qmVoMVvBwrcTGcOD5mCWekinh5VhOuBpgjRVWNAX+zedcNNnDwFdhRb5h2xnRkV4YibJf/h2w2zTcPa9qxv/BGVcFnxiXuxAJ6lszmzY7b6NGqQ105Gwrc4OPVMtqg3XblwT8f0V8qBqhou2a01s8eHl5ank0Zl14R3CVoR8ijU3Kk9p52FelFu7UvH7VPslVZk1qbN2gRSlPZE6lBlt9GQp0vAg90ROZNxLBkaaBKBKnCsOlUUGll5A9tIYb7vBzfVOFanBkEbQ0k4ceMxEPiolVCbCL/0w596jsG/4Fg/Rczy13HT928foJVPbkzeFH5yVL7vsbWQiMUIpAXoLfbqsokBCDvfHlYkVATkSHzW9+cNh7/DNu4cWaBhIsX+Tc8UcxIrTjNBHhJDlg0Jm8Beh4mGm3h/eRhai/p1buoje7rPwErfShwvlQ8ipNybH6yY8kIezBoxG0IkTCG+H2n0Xdp0oxEcm1m1755xO6whJeaof8wa7T6BqJ7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(5660300002)(6916009)(33656002)(2616005)(186003)(9786002)(38100700002)(9746002)(8676002)(83380400001)(316002)(8936002)(1076003)(478600001)(4326008)(26005)(66476007)(2906002)(426003)(66556008)(36756003)(54906003)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Dv/wA4iduZUVhRu1ugCx34PqfAVkT9rjGlALqO+SAzC9/3aStUpEb6yE9HB?=
 =?us-ascii?Q?3rQl1vr04hKSv4XnE5PXaOcJ+HkosdiSUCt6E0JeVS5Y7vtxoK0X0l5Wu9iQ?=
 =?us-ascii?Q?Q3O+T/ONvb2/x5WQ1ThA3+4N4e0eBSJJwivy5s2d8Rog02ihtuY/WapJs+Fr?=
 =?us-ascii?Q?dsl3Gfan3zCUDy8aDN764S8vCsrcjnquLVRTkpCJRCW3giPh0ZhPvJyGYO7q?=
 =?us-ascii?Q?j5qQhVl3ym7/GGkd8UQPTQ1e7IuPC3hl0gue7GuPRgjgHkpVnSkHp4fk91Bh?=
 =?us-ascii?Q?+RyZ+VfEPKki8fDl7nSZZ9o0uRJNQIpj5Ydvr+XE1ReOo5zIcH6vyXt+OGBq?=
 =?us-ascii?Q?SsiKz1wCbXN7N7BZydHeL2FWDCS2U8enYQqNaAQQeMwwgpCJVXknamVxI5Wp?=
 =?us-ascii?Q?MBmMlbeVVvlwa2oixKxqruRUGSqcXw/sJxvlL+Y+6071ogRZYd2RhuE2l3sS?=
 =?us-ascii?Q?JyptDzLSOC8KrP3QR2lHiG5PrIBqDwUNm8PrVQN9I68CNgKwYwkathenkLTT?=
 =?us-ascii?Q?iuR0gqRf0eWQI5CzWrmstBqpS8mbM2bpwsI4UJPGCnIlvYleUW3V7GmcoCv6?=
 =?us-ascii?Q?zgH4Q8slxui2CUZk7WeZpNvs7qGTg3hov3O5Z6SdvlmrOksLSYhbx9UR1nM6?=
 =?us-ascii?Q?CQJjxLNGxRQJ/gdEnuG7JzShYZ8RZUPM6SCybGjMBTYrvoCxpATdhE6iCEoM?=
 =?us-ascii?Q?dMnqEmW9AoMjJSKGarxZpUfN6F6cmwVml4vjREVhZE1FAKTdZRKU/YQwxS3t?=
 =?us-ascii?Q?G5ik2ai8I0F6LAyblDZbKpcvEocue93E9oKYmzL6mdFgFl2w06pB5VRukePE?=
 =?us-ascii?Q?S7h5xBQwtzEhEspopBqGaaXhwxV/G1Ws7v7lFp/bCZB9JUZAIXJ8QRrwX0B8?=
 =?us-ascii?Q?uRcwgwUAEBWl7Dt4seSuLRE4eZG1FpYLlidZhBNwE2B3LIZzUupxo4LUHHkq?=
 =?us-ascii?Q?OFcLgSLypiD6YS4P9cXT5nKmvYQzSKzgKV1bP5wvyD5w0N+bQDifCRIZlSZ+?=
 =?us-ascii?Q?JRvy17+IkOObIB4IhSmJ5WVcatjC1AdWYWnFp+cIALYfcepd+KcsUhvlJ1u6?=
 =?us-ascii?Q?XhC/OEuQ9pfeYOWyCKtyKy8VdMJXx/jTlW4OqkpyQXx/hQ0oEf7l/85ZvAvC?=
 =?us-ascii?Q?3B/fgsXwz7jQ1aYM0jBxUyx8Fz6zts5v3Pc97su3UfVOJhLOyzMCGDXzy0I7?=
 =?us-ascii?Q?eT+97CPSUqF/qRyemNrWpGil0Vf1J/vOmK2i4OOiiwTlKjbQ4pY7woTTsVIn?=
 =?us-ascii?Q?eyl8RaIUsmJu0cDok1thEitTl4EtjS9psruCpN0TovgFQMN4caIaNvyjmLI1?=
 =?us-ascii?Q?3MNblGtUD3Zy07WbthUJ7VcN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8544f805-f85a-45c3-2944-08d952c975bd
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 19:45:46.9031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEkLCVvM2Uw8D0P2kZ/sD4syc9f8hdlwCgxuIFo/PZo9n7KTYhH0PrQ//Bpgve6e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5555
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index ffb6f1d41f3d..e22eeceae9eb 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -749,7 +749,7 @@ struct mlx5_cache_ent {
>  
>  
>  	char                    name[4];
> -	u32                     order;
> +	u32			order;
>  	u32			xlt;
>  	u32			access_mode;
>  	u32			page;

Looking at this, it looks like it will be a lot simpler to just store
the reference mkc here and use that whole blob as the rb key and write
a slightly special compare function.. Maybe only the ndescs needs to
be stored loose.

Then all the weirdness about special ents disappears, they are
naturally handled by having the required bits in their mkc.

And all the random encode/decode/recode scattered all over the place
goes away. Anyone working with mkeys needs to build a mkc on their
stack, then check if allocation of that mkc can be satisfied with the
cache, otherwise pass that same mkc to the alloc cmd. The one case
that uses the PAS will have to alloc a new mkc and memcpy, but that is
OK.

> +static struct mlx5_cache_ent *mkey_cache_ent_from_size(struct mlx5_ib_dev *dev,
> +						       int ent_flags, int size)
> +{
> +	struct rb_node *node = dev->cache.cache_root.rb_node;
> +	struct mlx5_cache_ent *cur, *prev = NULL;
> +
> +	WARN_ON(!mutex_is_locked(&dev->cache.cache_lock));

Yikes, no, use lockdep.

> @@ -616,13 +739,18 @@ struct mlx5_ib_mr *mlx5_alloc_special_mkey(struct mlx5_ib_dev *dev,
>  static struct mlx5r_cache_mkey *get_cache_mkey(struct mlx5_cache_ent *req_ent)
>  {
>  	struct mlx5_ib_dev *dev = req_ent->dev;
> -	struct mlx5_cache_ent *ent = req_ent;
>  	struct mlx5r_cache_mkey *cmkey;
> +	struct mlx5_cache_ent *ent;
> +	struct rb_node *node;
>  
>  	/* Try larger Mkey pools from the cache to satisfy the allocation */
> -	for (; ent != &dev->cache.ent[MKEY_CACHE_LAST_STD_ENTRY + 1]; ent++) {
> -		mlx5_ib_dbg(dev, "order %u, cache index %zu\n", ent->order,
> -			    ent - dev->cache.ent);
> +	mutex_lock(&dev->cache.cache_lock);
> +	for (node = &req_ent->node; node; node = rb_next(node)) {
> +		ent = container_of(node, struct mlx5_cache_ent, node);

See, this should be 'search for the mkc I have for the lowest entry with size+1'

> -int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
> +int mlx5_mkey_cache_tree_init(struct mlx5_ib_dev *dev)
>  {
> -	struct mlx5_mkey_cache *cache = &dev->cache;
> +	struct mlx5_mkey_cache_tree *cache = &dev->cache;
>  	struct mlx5_cache_ent *ent;
> +	int err;
>  	int i;
>  
>  	mutex_init(&dev->slow_path_mutex);
> +	mutex_init(&cache->cache_lock);
> +	cache->cache_root = RB_ROOT;
>  	cache->wq = alloc_ordered_workqueue("mkey_cache", WQ_MEM_RECLAIM);
>  	if (!cache->wq) {
>  		mlx5_ib_warn(dev, "failed to create work queue\n");
> @@ -745,28 +882,25 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
>  
>  	mlx5_cmd_init_async_ctx(dev->mdev, &dev->async_ctx);
>  	timer_setup(&dev->delay_timer, delay_time_func, 0);
> -	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
> -		ent = &cache->ent[i];
> -		INIT_LIST_HEAD(&ent->head);
> -		spin_lock_init(&ent->lock);
> -		ent->order = i + 2;
> -		ent->dev = dev;
> -		ent->limit = 0;
> -
> -		INIT_WORK(&ent->work, cache_work_func);
> -		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
> +	for (i = 0; i < MAX_MKEY_CACHE_DEFAULT_ENTRIES; i++) {
> +		u8 order = i + 2;
> +		u32 xlt_size = (1 << order) * sizeof(struct mlx5_mtt) /
> +			       MLX5_IB_UMR_OCTOWORD;

This should be written saner

for (xlt_size = MKEY_CACHE_DEFAULT_MIN_DESCS * sizeof(struct mlx5_mtt) / MLX5_IB_UMR_OCTOWORD; 
     xlt_size <= MKEY_CACHE_DEFAULT_MAX_DESCS *  sizeof(struct mlx5_mtt) / MLX5_IB_UMR_OCTOWORD; 
     xlt_size *= 2)

>  
>  		if (i > MKEY_CACHE_LAST_STD_ENTRY) {

The index in the cache should be meaningless now, so don't put this
code here.

> -			mlx5_odp_init_mkey_cache_entry(ent);
> +			err = mlx5_odp_init_mkey_cache_entry(dev, i);
> +			if (err)
> +				return err;
>  			continue;
>  		}

> -		if (ent->order > mkey_cache_max_order(dev))
> +		ent = mlx5_ib_create_cache_ent(dev, 0, xlt_size, order);

And why do we need to pass in order, why is it stored in the
cache_ent? Looks like it should be removed

The debugfs looks like it might need some rethink as is it can only
control the original buckets, the new buckets don't get exposed. Seems
like trouble.

If just exposing the legacy things is the idea then it should have the
same sweep over the parameter space as above, not just assume that the
rb tree is in order and only contains debugfs entries.

Probably change it to create the debugfs nodes at the same time the
cache entry itself is created.

> @@ -973,14 +1100,16 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
>  						     0, iova);
>  	if (WARN_ON(!page_size))
>  		return ERR_PTR(-EINVAL);
> -	ent = mkey_cache_ent_from_order(
> -		dev, order_base_2(ib_umem_num_dma_blocks(umem, page_size)));
> +	ent_flags = mlx5_ent_access_flags(dev, access_flags);
> +	xlt_size = get_octo_len(iova, umem->length, order_base_2(page_size));
> +	mutex_lock(&dev->cache.cache_lock);
> +	ent = mkey_cache_ent_from_size(dev, ent_flags, xlt_size);

See here is where I wonder if it is just better to build the mkc on
the stack in one place instead of having all this stuff open coded all
over..

> -void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
> +int mlx5_odp_init_mkey_cache_entry(struct mlx5_ib_dev *dev, int ent_num)
>  {
> -	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
> -		return;
> +	struct mlx5_cache_ent *ent;
> +	int ent_flags;
> +	u32 xlt_size;
> +
> +	if (!(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
> +		return 0;
>  
> -	switch (ent->order - 2) {
> +	switch (ent_num) {
>  	case MLX5_IMR_MTT_CACHE_ENTRY:

Don't do stuff like this either. The mkc scheme will fix this too as
this will just create two mkcs for these unique usages and store them
normally.

Jason
