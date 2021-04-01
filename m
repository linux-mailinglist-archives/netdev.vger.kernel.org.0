Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DA035194D
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbhDARwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:52:50 -0400
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:36491
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236706AbhDARrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 13:47:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4WTbZxsFvenC7rP50HPonfSIioLFBbUGKx/BbrlVh3CCuThvgq5Hn80z4OjN0proO5i8WP00GroopsZVXjXnfZhwmwYOEHKQXYHzjrw5sqy2ddtMV/tgBgxui0rO7d7HJ1GszB4T5R2HCxSXhLlIPIayM5elzzoKNDSZrAHSjYWbZhJZDu8Gv69MHHqv/vPhruCXDnw6GPtmQT2h7C75MqzronWURtwh1sm7kXyAO10qdlJwO21DX3HZcJ+ZqGlq8BxLww7owvvI5wuo0JghcoFkDV1++bOMF1W32HGccxIaFJW7vle8aNU2sa26T+63iApqp0Jhhbi2z8fzDJauQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBDkSkz5E5Ef4h7HklcHhdVzjUjm1kxyeWawPcIUvYY=;
 b=eKppv4s4+VwSoD0DpD6mt4BwJkL9qiqKF+V4TUAfdNt1OYr+0puHgIzSYjYh8E9yb+Il0uadIva58dJ3PFQP0zti+1R7lbkMm74n3yTvowL+GIBSZktU8d2W726j/0rm0TeNUIoPJlLxdB3nEKgncDg+xl36iuqeeg7SKfUNNv4NmeLGDZhUsPmjI5bsCjCWRB4uo49BkFN4Mk9txYrskuiXkn5Ij8xLBvWpEPM+L3nKPVbbsLfrkuBbQ4t3RocoCuK1El6fOXHM1ocNtHqXm9opz/GZHrAZ2KW65wCe2mB+3BpFv5LXkoLwb8wTsUe8bLMWzWEpxIbowmmC7M/HvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBDkSkz5E5Ef4h7HklcHhdVzjUjm1kxyeWawPcIUvYY=;
 b=DAQngtE3OH+WT/4U6kQKVJny9/nTEJ01+In0syTmGXkZCEK+4x9V+tb2dRj2dWSlT21kF3EOVNMU6FdqDhb7xUAZkUOoIA+eQhoXufTXXZAX08b8bosiXkyfPVahDrpr4kiViNW4bUUUmgYV7kv3D8l8EjT6afTbqgDWDor+EO3Ewps31c+jd5vrObC8JAE39Lm4bmXQpQ2RgKleIvm9FQ9MgzRQXtf7uRWu4RD5iiqAH3ftmjhHigo5+0OA8VOVQtwxHs7d8wx3Y4ugsfWqQB8yOo4D9LR0bxKXIs3xuV+ws9WQzU1pobUVGCLvhI9MHURLwmz3cQLAd3QbyAjgeg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1547.namprd12.prod.outlook.com (2603:10b6:4:c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.26; Thu, 1 Apr 2021 17:47:06 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 17:47:06 +0000
Date:   Thu, 1 Apr 2021 14:47:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 6/7] RDMA/mlx5: Add support in MEMIC operations
Message-ID: <20210401174704.GA1626672@nvidia.com>
References: <20210318111548.674749-1-leon@kernel.org>
 <20210318111548.674749-7-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318111548.674749-7-leon@kernel.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR01CA0029.prod.exchangelabs.com (2603:10b6:208:71::42)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR01CA0029.prod.exchangelabs.com (2603:10b6:208:71::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 17:47:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lS1PM-006pGf-KP; Thu, 01 Apr 2021 14:47:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41607e96-8082-40f6-5aa0-08d8f5362a67
X-MS-TrafficTypeDiagnostic: DM5PR12MB1547:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB15476744D3DAA254AB504287C27B9@DM5PR12MB1547.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kW+Yn2S96sL95J1b/uopsBIeXrmHZIww6MaYSUzoEQ4nskXlIvNBK/sI8uO4+maVaOnKRpAcMCKFpkAVW4DKoJUVI0ptgJ6AQRv4EdH3FVVHBfQT3BE9BGgmkQvCOKmIvVUCOwL4GUWl3PoLXmZF0p2fZFp58A1bbGmlEdgBHQTc6qyiVKXX8Ei54RiE2yLYV4X/F3mswO8Y96+Rib37TDj9N5f9WwVvyR6fuSNtoXiECl88kqQAgHiArGnAVsXMJ/5t7w4DLhKfe11D/0/tbsDI3H+S8LP8cuO7mz9rFwIs8Q7JBEbs2ZVOAFZKBAY3rfrxKp2jmxob4otFGSW4AwWFFtSIja+IOkQn+lCcKicjd2/wQazqZxaBHiM104ZsDDQAcA0GF/PsW9pMQ9m+oaB4WiIvEjZZKD4a32SODYme1PvFFtflAohFGbM0YgMOJY9/CD45GIJaQ4ieewbvYkBRm6Kc8BGtne5mkVMLnb/Hn20uIK5STqyHxYRvuHBTvecGbna8T+vRzVAWhdR/3bfFkn8k8i793nhh4umB01lJToR5fRhkYdLpaQW83MBHD9dSdmEACxQfCxbSwgGAWpczsJlF6n4W1URIPsONzk33gxr9YnCzUZC2DsxxoSb77FWiQkXA5xL9JlzICrxMUWP9EFDgnr0pmK2k0xa60A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(36756003)(9786002)(54906003)(9746002)(38100700001)(186003)(66946007)(5660300002)(316002)(8676002)(8936002)(426003)(86362001)(26005)(107886003)(33656002)(66476007)(30864003)(2616005)(478600001)(66556008)(1076003)(6916009)(83380400001)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eZGy1iCHRuQ5U2G86vKWnNemMPLw3EYaLgCzY/BMEM+sErLWjUnbHNkFzGxy?=
 =?us-ascii?Q?dYnJIBmOMRGZU00VJKON5Sf/nP4xlupfR7bJkb1NK6Dyipv+6Gnm7/smagWh?=
 =?us-ascii?Q?bmLn+o5kf9bArdzBaedfenz59Gmxm8+AMUn3Jpli+sGLrMXEwGeD/tB/8es0?=
 =?us-ascii?Q?ev4WOryRu5XuDcpNGRSeSz0HYIyZSq6InO7b5Vv14/Owhx5QF6QwvGrv9cc2?=
 =?us-ascii?Q?YaefXLag1+hP7zi0+jkz6rg/81Z4/bNq2R0S8SEJJEGGLeRzfKk4j4L2cxwd?=
 =?us-ascii?Q?w1+pLbpGPA1MBar5KOG1Z7SsVXf++SKbL8k6hloN/NNpSq+3Olp8VXnbya2k?=
 =?us-ascii?Q?KAtJtaNiV9etGfw5g/7a7BaeNYeweBVPcdfKvXipbzViUu23nFykmPDvfcqA?=
 =?us-ascii?Q?R9eHwH/+CC0uTjsuVwSvW7Ujd2OAtAveJ0A+rgnzNOrDTBWcIRm5PpmWeB4H?=
 =?us-ascii?Q?/DwjSAdLAbKiY+g9BbVMXyXAtl6FMMsmooVyfP8HoBKGvGlYZl7NzPpzZWT2?=
 =?us-ascii?Q?3cDlvRYV+6PS7RT4S3lETghzprqrrk7MUAP/3XRWUtCehaEzazRN+7PlMPRK?=
 =?us-ascii?Q?RESDpOLW7NQSw48hGabfkL4VpmLQXuNB/80WAU1gjIinXNsozWnfXI19Z+WP?=
 =?us-ascii?Q?H/pPaA5FGIgRrVFsYyKx9DXVU0zj26FB9aaCZv54pkQW/g60tZ4Hnvu8lZYK?=
 =?us-ascii?Q?NsgXtx57IV4TQuY5K/uJlAqGLzAdAKWHDBwrvK+iU3YN1F3A0fhCg243MVtV?=
 =?us-ascii?Q?mjaXvVV/pUpLd1Yf76FZHXkQ8GRcM3JkWBSqM/OTkOeg1DeyEfbJbj416JIK?=
 =?us-ascii?Q?o4zHOx+2lLiG6ZUBLocsy6kiBEw8cNbNfBAHdD5xZd6bYXp9xnsmyRWvbkPs?=
 =?us-ascii?Q?FqFe2smXtK7Ul4kZDVLCljK6TtYlL9ZK6DUZIEOvbSgsIvl11FdCIXl4gGx6?=
 =?us-ascii?Q?YYG4Ss272IKFRTMU+2ng6tFpGAraI5gaUpdZQS5Wj0B7MxiU7ZvqipwKw6dL?=
 =?us-ascii?Q?5T73rEILrfrPNsotOs+i1z4pBABb9kP9XkrWpg5N/Z5y7HkXmykAVyP3w6+b?=
 =?us-ascii?Q?/FFqJBKPHLmjKnfbAfsrCXmxeHlwygTYhF/ikcDJx/FL1kHzgAOT5bIa1xUF?=
 =?us-ascii?Q?+i3mcG9MEJvLah4PgSJWKVRUo84wd/4Tn0uTKE8PpT0WM8wdlE5lrdZRchvY?=
 =?us-ascii?Q?yrl599JDH9rU4LNFMwC/KBW8FjoDOZZQ+epL9qGNJ2O4h1mwDVAQ1NEgFO91?=
 =?us-ascii?Q?EGiXBhsGfjGvESt5d8W2HITbo6+Rh2/koMxBu5EtMd7HCJhqLhBmrSRhP5dv?=
 =?us-ascii?Q?acty0RLzo7x9KGYPxswzj5VouT2hHgmD4Jz4Ji2pVkG+uA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41607e96-8082-40f6-5aa0-08d8f5362a67
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 17:47:06.6128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1VRdDcHpL2tSyj4RFLj2MLAklc0PHbbzVM0TLtnyEUTm7IcVq05bf4KOGa466Xh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1547
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 01:15:47PM +0200, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> MEMIC buffer, in addition to regular read and write operations, can
> support atomic operations from the host.
> 
> Introduce and implement new UAPI to allocate address space for MEMIC
> operations such as atomic. This includes:
> 
> 1. Expose new IOCTL for request mapping of MEMIC operation.
> 2. Hold the operations address in a list, so same operation to same DM
>    will be allocated only once.
> 3. Manage refcount on the mlx5_ib_dm object, so it would be keep valid
>    until all addresses were unmapped.
> 
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/dm.c          | 196 +++++++++++++++++++++--
>  drivers/infiniband/hw/mlx5/dm.h          |   2 +
>  drivers/infiniband/hw/mlx5/main.c        |   7 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h     |  16 +-
>  include/uapi/rdma/mlx5_user_ioctl_cmds.h |  11 ++
>  5 files changed, 214 insertions(+), 18 deletions(-)
> 
> --
> 2.30.2
> 
> diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
> index 97a925d43312..ee4ee197a626 100644
> --- a/drivers/infiniband/hw/mlx5/dm.c
> +++ b/drivers/infiniband/hw/mlx5/dm.c
> @@ -150,12 +150,14 @@ static int mlx5_cmd_alloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
>  }
> 
>  static int add_dm_mmap_entry(struct ib_ucontext *context,
> -			     struct mlx5_ib_dm *mdm, u64 address)
> +			     struct mlx5_user_mmap_entry *mentry, u8 mmap_flag,
> +			     size_t size, u64 address)
>  {
> -	mdm->mentry.mmap_flag = MLX5_IB_MMAP_TYPE_MEMIC;
> -	mdm->mentry.address = address;
> +	mentry->mmap_flag = mmap_flag;
> +	mentry->address = address;
> +
>  	return rdma_user_mmap_entry_insert_range(
> -		context, &mdm->mentry.rdma_entry, mdm->size,
> +		context, &mentry->rdma_entry, size,
>  		MLX5_IB_MMAP_DEVICE_MEM << 16,
>  		(MLX5_IB_MMAP_DEVICE_MEM << 16) + (1UL << 16) - 1);
>  }
> @@ -183,6 +185,114 @@ static inline int check_dm_type_support(struct mlx5_ib_dev *dev, u32 type)
>  	return 0;
>  }
> 
> +void mlx5_ib_dm_memic_free(struct kref *kref)
> +{
> +	struct mlx5_ib_dm *dm =
> +		container_of(kref, struct mlx5_ib_dm, memic.ref);
> +	struct mlx5_ib_dev *dev = to_mdev(dm->ibdm.device);
> +
> +	mlx5_cmd_dealloc_memic(&dev->dm, dm->dev_addr, dm->size);
> +	kfree(dm);
> +}
> +
> +static int copy_op_to_user(struct mlx5_ib_dm_op_entry *op_entry,
> +			   struct uverbs_attr_bundle *attrs)
> +{
> +	u64 start_offset;
> +	u16 page_idx;
> +	int err;
> +
> +	page_idx = op_entry->mentry.rdma_entry.start_pgoff & 0xFFFF;
> +	start_offset = op_entry->op_addr & ~PAGE_MASK;
> +	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_PAGE_INDEX,
> +			     &page_idx, sizeof(page_idx));
> +	if (err)
> +		return err;
> +
> +	return uverbs_copy_to(attrs,
> +			      MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_START_OFFSET,
> +			      &start_offset, sizeof(start_offset));
> +}
> +
> +static int map_existing_op(struct mlx5_ib_dm *dm, u8 op,
> +			   struct uverbs_attr_bundle *attrs)
> +{
> +	struct mlx5_ib_dm_op_entry *op_entry;
> +
> +	op_entry = xa_load(&dm->memic.ops, op);
> +	if (!op_entry)
> +		return -ENOENT;
> +
> +	return copy_op_to_user(op_entry, attrs);
> +}
> +
> +static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_uobject *uobj = uverbs_attr_get_uobject(
> +		attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
> +	struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
> +	struct ib_dm *ibdm = uobj->object;
> +	struct mlx5_ib_dm *dm = to_mdm(ibdm);
> +	struct mlx5_ib_dm_op_entry *op_entry;
> +	int err;
> +	u8 op;
> +
> +	err = uverbs_copy_from(&op, attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP);
> +	if (err)
> +		return err;
> +
> +	if (!(MLX5_CAP_DEV_MEM(dev->mdev, memic_operations) & BIT(op)))
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&dm->memic.ops_xa_lock);
> +	err = map_existing_op(dm, op, attrs);
> +	if (!err || err != -ENOENT)
> +		goto err_unlock;
> +
> +	op_entry = kzalloc(sizeof(*op_entry), GFP_KERNEL);
> +	if (!op_entry)
> +		goto err_unlock;
> +
> +	err = mlx5_cmd_alloc_memic_op(&dev->dm, dm->dev_addr, op,
> +				      &op_entry->op_addr);
> +	if (err) {
> +		kfree(op_entry);
> +		goto err_unlock;
> +	}
> +	op_entry->op = op;
> +	op_entry->dm = dm;
> +
> +	err = add_dm_mmap_entry(uobj->context, &op_entry->mentry,
> +				MLX5_IB_MMAP_TYPE_MEMIC_OP, dm->size,
> +				op_entry->op_addr & PAGE_MASK);
> +	if (err) {
> +		mlx5_cmd_dealloc_memic_op(&dev->dm, dm->dev_addr, op);
> +		kfree(op_entry);
> +		goto err_unlock;
> +	}
> +	/* From this point, entry will be freed by mmap_free */
> +	kref_get(&dm->memic.ref);
> +
> +	err = copy_op_to_user(op_entry, attrs);
> +	if (err)
> +		goto err_remove;
> +
> +	err = xa_insert(&dm->memic.ops, op, op_entry, GFP_KERNEL);
> +	if (err)
> +		goto err_remove;
> +	mutex_unlock(&dm->memic.ops_xa_lock);
> +
> +	return 0;
> +
> +err_remove:
> +	rdma_user_mmap_entry_remove(&op_entry->mentry.rdma_entry);
> +err_unlock:
> +	mutex_unlock(&dm->memic.ops_xa_lock);
> +
> +	return err;
> +}
> +
>  static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
>  				 struct ib_dm_alloc_attr *attr,
>  				 struct uverbs_attr_bundle *attrs)
> @@ -193,6 +303,9 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
>  	int err;
>  	u64 address;
> 
> +	kref_init(&dm->memic.ref);
> +	xa_init(&dm->memic.ops);
> +	mutex_init(&dm->memic.ops_xa_lock);
>  	dm->size = roundup(attr->length, MLX5_MEMIC_BASE_SIZE);
> 
>  	err = mlx5_cmd_alloc_memic(dm_db, &dm->dev_addr,
> @@ -203,18 +316,17 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
>  	}
> 
>  	address = dm->dev_addr & PAGE_MASK;
> -	err = add_dm_mmap_entry(ctx, dm, address);
> +	err = add_dm_mmap_entry(ctx, &dm->memic.mentry, MLX5_IB_MMAP_TYPE_MEMIC,
> +				dm->size, address);
>  	if (err) {
>  		mlx5_cmd_dealloc_memic(dm_db, dm->dev_addr, dm->size);
>  		kfree(dm);
>  		return err;
>  	}
> 
> -	page_idx = dm->mentry.rdma_entry.start_pgoff & 0xFFFF;
> -	err = uverbs_copy_to(attrs,
> -			     MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
> -			     &page_idx,
> -			     sizeof(page_idx));
> +	page_idx = dm->memic.mentry.rdma_entry.start_pgoff & 0xFFFF;
> +	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
> +			     &page_idx, sizeof(page_idx));
>  	if (err)
>  		goto err_copy;
> 
> @@ -228,7 +340,7 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
>  	return 0;
> 
>  err_copy:
> -	rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
> +	rdma_user_mmap_entry_remove(&dm->memic.mentry.rdma_entry);
> 
>  	return err;
>  }
> @@ -292,6 +404,7 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
>  		return ERR_PTR(-ENOMEM);
> 
>  	dm->type = type;
> +	dm->ibdm.device = ibdev;
> 
>  	switch (type) {
>  	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
> @@ -323,6 +436,19 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
>  	return ERR_PTR(err);
>  }
> 
> +static void dm_memic_remove_ops(struct mlx5_ib_dm *dm)
> +{
> +	struct mlx5_ib_dm_op_entry *entry;
> +	unsigned long idx;
> +
> +	mutex_lock(&dm->memic.ops_xa_lock);
> +	xa_for_each(&dm->memic.ops, idx, entry) {
> +		xa_erase(&dm->memic.ops, idx);
> +		rdma_user_mmap_entry_remove(&entry->mentry.rdma_entry);
> +	}
> +	mutex_unlock(&dm->memic.ops_xa_lock);
> +}
> +
>  int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)
>  {
>  	struct mlx5_ib_ucontext *ctx = rdma_udata_to_drv_context(
> @@ -333,7 +459,8 @@ int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)
> 
>  	switch (dm->type) {
>  	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
> -		rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
> +		dm_memic_remove_ops(dm);
> +		rdma_user_mmap_entry_remove(&dm->memic.mentry.rdma_entry);
>  		return 0;
>  	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
>  		ret = mlx5_dm_sw_icm_dealloc(dev, MLX5_SW_ICM_TYPE_STEERING,
> @@ -359,6 +486,31 @@ int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)
>  	return 0;
>  }
> 
> +void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
> +			  struct mlx5_user_mmap_entry *mentry)
> +{
> +	struct mlx5_ib_dm_op_entry *op_entry;
> +	struct mlx5_ib_dm *mdm;
> +
> +	switch (mentry->mmap_flag) {
> +	case MLX5_IB_MMAP_TYPE_MEMIC:
> +		mdm = container_of(mentry, struct mlx5_ib_dm, memic.mentry);
> +		kref_put(&mdm->memic.ref, mlx5_ib_dm_memic_free);
> +		break;
> +	case MLX5_IB_MMAP_TYPE_MEMIC_OP:
> +		op_entry = container_of(mentry, struct mlx5_ib_dm_op_entry,
> +					mentry);
> +		mdm = op_entry->dm;
> +		mlx5_cmd_dealloc_memic_op(&dev->dm, mdm->dev_addr,
> +					  op_entry->op);
> +		kfree(op_entry);
> +		kref_put(&mdm->memic.ref, mlx5_ib_dm_memic_free);
> +		break;
> +	default:
> +		WARN_ON(true);
> +	}
> +}
> +
>  ADD_UVERBS_ATTRIBUTES_SIMPLE(
>  	mlx5_ib_dm, UVERBS_OBJECT_DM, UVERBS_METHOD_DM_ALLOC,
>  	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET,
> @@ -368,8 +520,28 @@ ADD_UVERBS_ATTRIBUTES_SIMPLE(
>  	UVERBS_ATTR_CONST_IN(MLX5_IB_ATTR_ALLOC_DM_REQ_TYPE,
>  			     enum mlx5_ib_uapi_dm_type, UA_OPTIONAL));
> 
> +DECLARE_UVERBS_NAMED_METHOD(
> +	MLX5_IB_METHOD_DM_MAP_OP_ADDR,
> +	UVERBS_ATTR_IDR(MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE,
> +			UVERBS_OBJECT_DM,
> +			UVERBS_ACCESS_READ,
> +			UA_MANDATORY),
> +	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP,
> +			   UVERBS_ATTR_TYPE(u8),
> +			   UA_MANDATORY),
> +	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_START_OFFSET,
> +			    UVERBS_ATTR_TYPE(u64),
> +			    UA_MANDATORY),
> +	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_PAGE_INDEX,
> +			    UVERBS_ATTR_TYPE(u16),
> +			    UA_OPTIONAL));
> +
> +DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DM,
> +			      &UVERBS_METHOD(MLX5_IB_METHOD_DM_MAP_OP_ADDR));
> +
>  const struct uapi_definition mlx5_ib_dm_defs[] = {
>  	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_DM, &mlx5_ib_dm),
> +	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_DM),
>  	{},
>  };
> 
> diff --git a/drivers/infiniband/hw/mlx5/dm.h b/drivers/infiniband/hw/mlx5/dm.h
> index adb39d3d8131..56cf1ba9c985 100644
> --- a/drivers/infiniband/hw/mlx5/dm.h
> +++ b/drivers/infiniband/hw/mlx5/dm.h
> @@ -8,6 +8,8 @@
> 
>  #include "mlx5_ib.h"
> 
> +void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
> +			  struct mlx5_user_mmap_entry *mentry);
>  void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
>  			    u64 length);
>  void mlx5_cmd_dealloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 49c8c60d9520..6908db28b796 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -2090,14 +2090,11 @@ static void mlx5_ib_mmap_free(struct rdma_user_mmap_entry *entry)
>  	struct mlx5_user_mmap_entry *mentry = to_mmmap(entry);
>  	struct mlx5_ib_dev *dev = to_mdev(entry->ucontext->device);
>  	struct mlx5_var_table *var_table = &dev->var_table;
> -	struct mlx5_ib_dm *mdm;
> 
>  	switch (mentry->mmap_flag) {
>  	case MLX5_IB_MMAP_TYPE_MEMIC:
> -		mdm = container_of(mentry, struct mlx5_ib_dm, mentry);
> -		mlx5_cmd_dealloc_memic(&dev->dm, mdm->dev_addr,
> -				       mdm->size);
> -		kfree(mdm);
> +	case MLX5_IB_MMAP_TYPE_MEMIC_OP:
> +		mlx5_ib_dm_mmap_free(dev, mentry);
>  		break;
>  	case MLX5_IB_MMAP_TYPE_VAR:
>  		mutex_lock(&var_table->bitmap_lock);
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index ae971de6e934..b714131f87b7 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -166,6 +166,7 @@ enum mlx5_ib_mmap_type {
>  	MLX5_IB_MMAP_TYPE_VAR = 2,
>  	MLX5_IB_MMAP_TYPE_UAR_WC = 3,
>  	MLX5_IB_MMAP_TYPE_UAR_NC = 4,
> +	MLX5_IB_MMAP_TYPE_MEMIC_OP = 5,
>  };
> 
>  struct mlx5_bfreg_info {
> @@ -618,18 +619,30 @@ struct mlx5_user_mmap_entry {
>  	u32 page_idx;
>  };
> 
> +struct mlx5_ib_dm_op_entry {
> +	struct mlx5_user_mmap_entry	mentry;
> +	phys_addr_t			op_addr;
> +	struct mlx5_ib_dm		*dm;
> +	u8				op;
> +};
> +
>  struct mlx5_ib_dm {
>  	struct ib_dm		ibdm;
>  	phys_addr_t		dev_addr;
>  	u32			type;
>  	size_t			size;
>  	union {
> +		struct {
> +				struct mlx5_user_mmap_entry mentry;
> +				struct xarray		ops;
> +				struct mutex		ops_xa_lock;
> +				struct kref		ref;
> +		} memic;
>  		struct {
>  			u32	obj_id;
>  		} icm_dm;

This union is making it much too difficult to read and understand now.
An optional kref inside a structure is too far

Please split it to more types and have proper typesafety throughout

It looks mostly fine otherwise, the error flows are a bit hard to read
though, when a new type is added this should also get re-organized so
we don't do stuff like:

err_free:
	/* In MEMIC error flow, dm will be freed internally */
	if (type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
		kfree(dm);

I'd inline the checks from check_dm_type_support() into their
respective allocation functions too

Jason
