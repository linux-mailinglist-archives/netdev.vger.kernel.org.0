Return-Path: <netdev+bounces-11136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E009731AB0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A687928178F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00847171A0;
	Thu, 15 Jun 2023 14:00:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E354E168A2
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:00:18 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F4F1BE8;
	Thu, 15 Jun 2023 07:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mH2ojXX+xWVUk0HERsQxEV/K6DFjFe7tmZ/4FsozdUe9+INeVCI31ul8qmi1TN/3RvsK3vcURCZp4ZLBZEfEOqDSv5qU6PebWN1RWTr+EyDHgus9gTt5sX6Lbx8P47/9bPqb5QcrtE2w4DJ5lrpHmJl2R+BN+oFq1Mn9CXa8cnScX3arDET7xu9xZbq/dQ6TglIYe7Bc5G1mg4Tcah8N5q7T7ekLF4HbM2LZ7g9Nwq6Ah/0TvMUOqfR9jS7Gw9G3oayoPX00KTRVf7LfnlTnigARCytt3b1fok5FGgZN8L+LETZbOSUh2gIGjOhl2xY2N2yB83ZVq1bt+dfOv3Nv7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Caw+jZ46Azh4znPDgfo+Jkpf7wViEbnQnzPz4wVyi3Y=;
 b=IUY2w8hYeX1a/s+z5gRMxdnOJBn4YGDnSddyFL4OzfmQA5zvYtnPI9q5IB0C9wn6FK90C72kCKKEyZxT+OyexU2ZbVfosFARVKkM8ZAqnOPuHYL796AN6Y+M6Slf5w1mrOPPAPMiG4Cg88yRiWcnu7HUaheZ2KZXupkc9f4mZxx7BAdLsQVmmbgpEdSYAiHmSMLR0iSvhBuer8WR02QHyYQCnWtkw39G1dbytM6t+iEEdgYyvT4uhMAMRLalNLq4UgJnJdZ1nPAFKHTX15/k59p6uKrYorkhUshvejFTmZ7eopyeqEWcvd6Ft9TS2xJ5quHdjjqhiMAaRfiZBxiNZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Caw+jZ46Azh4znPDgfo+Jkpf7wViEbnQnzPz4wVyi3Y=;
 b=lMoChESfT2y/CTfjW3nif0L4wTFPhwZMFCSOJXCTVeFOEX29eVohNxKB2kfKMmpanaoGCQjxM79epX5jUvAT6ZToNlLH7HTGLHUi3aIENkXeA3BBZD4qTQBbgViQA6lCy3GWf+sEMiA7mi9KJeKB0b+wsPA7HlcSI1trFnrNCpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3898.namprd13.prod.outlook.com (2603:10b6:5:248::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 14:00:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 14:00:13 +0000
Date: Thu, 15 Jun 2023 16:00:05 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wei Hu <weh@microsoft.com>
Cc: netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org, longli@microsoft.com,
	sharmaajay@microsoft.com, jgg@ziepe.ca, leon@kernel.org,
	kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, vkuznets@redhat.com,
	ssengar@linux.microsoft.com, shradhagupta@linux.microsoft.com
Subject: Re: [PATCH v3 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Message-ID: <ZIsZZYiYdIM1MxSj@corigine.com>
References: <20230615111412.1687573-1-weh@microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615111412.1687573-1-weh@microsoft.com>
X-ClientProxiedBy: AS4P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3898:EE_
X-MS-Office365-Filtering-Correlation-Id: f4f48194-6393-4db1-a8ed-08db6da8d6e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nELXHDGPf6svElFYHw88oqXdjh0li0rk9IqKj3wbfNwZKb+JctuaskEKnEVrdsTGySkfO6RXkoiqN3TvxjGmkxokps7djHOwVCz1LtWZ0wV5lLEK6vKl4xQ/zUlV+OQA6Ymdr/vRuzbtm8RQQNf2IulD9i6C+p12oDSXRWrsr/B7ddh1OkxsqTkY1+ZP+bZTE7F2WsM0SnZ9g/6ZBL7eJNoiDjbScMLhLKbObB1UnbcHS7cFXBHc1eKtUAH9dzGtat7MF52JmN3Z7M8k3Z9C2Nvy968AKxWLXqZB+QxIfGGlkf0kRzXgXJkyuQjwov0tRAzk9zxiJKLPx3FTBUh78BQFkojgP7wSx/CHU+DckR3CNBgHunSUKxbbD9Zy5YFjbnfxzqZ3apRHmNLmewzu9wtkfhz99grwzNQjOYhg7jc2EuensQcea02ACUNl9UWh3OmPOwp4usX6dcUlVUpvVKJBxRP/CCUVnK/f6Hpl2gk2z0ouNPKdeiyoxZI+xBazTSDmc4bqoaK8JjHOrQ6uCnfLNxDsSzKDlM+CVfRipaXX2O/mFyZhTvppdTIXTA/UdgGhndYOa90XRerHlcLkd6R10i/f4ejXzFeTjTjr/aw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(136003)(376002)(39840400004)(451199021)(8676002)(41300700001)(86362001)(8936002)(6486002)(66556008)(6916009)(66946007)(66476007)(316002)(6666004)(36756003)(4326008)(66899021)(478600001)(6512007)(44832011)(7416002)(5660300002)(83380400001)(6506007)(186003)(2906002)(38100700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1PXZ5jCmR3lJdmVebMUgEbpBHOSUnYaFsczfxzFNApmoS6aJTXRQNaVb16XZ?=
 =?us-ascii?Q?uDujPMhA2Gi6SfFuZMUoAMFYOfpKAN48BsDDG/lUhDjAqpbROKQN5UI6pjm+?=
 =?us-ascii?Q?Kcny1VqQzCpUZ0aQpi9aNxVk1Nclo3vg3TPTiWBRVL7g93e4cDGvmQ2swfSr?=
 =?us-ascii?Q?ma46GVSSUlkhgbludqvOl1R6kshuUyYjUkhC7bZ/pyibUJ6m23U4kI4wMrzN?=
 =?us-ascii?Q?ygzR9kJeHS4+tUS0Yyi+jYHAo+DC4/bPdVhjckwGMpxWkDqpit5WIZvi9sRZ?=
 =?us-ascii?Q?j/u25AIoZ5ZPIBRqyXOqUPbBZdHSqYx3CRvg2qmU0MNHdHi/VYTyHuJpqilt?=
 =?us-ascii?Q?lo1azrhiG1ZkUt0iPFKNP9i5pyvVpc6vtPB7Xfq2j4gRoOjD7w4ZBULKLVmU?=
 =?us-ascii?Q?0S4Ql4QJSugyUrFg6a11dPQY9HijtWr8y3VCupw8NkWtYUDXbLV4OARxeW0x?=
 =?us-ascii?Q?j5jHPl44k1eEt6ejun2MMRu4T+SHD3HoqH+2d/8sA7cnPnddtXdiv2pgSjUA?=
 =?us-ascii?Q?HBqpKhQdrXrG+GDLkaPpDORF9zTSCN9yrbStHY4BLqlJeSYujsdNeVLPSLOC?=
 =?us-ascii?Q?RWFRjO90KkOBacsdBZUwid8H4nFr8VgoAUee8r8PcuQ5G9E4y4KsHvWaK0WP?=
 =?us-ascii?Q?G6xI4Id4GVJyhGsYpUF0wMg3FRu8TCG9aS/8jYkK3312N25t8FBegZrW6hw6?=
 =?us-ascii?Q?GyH0hSzJh3BlVn6qJRcP9ntPNq89m09oPGritbwJ992rSRPvhzhMLWgvcrME?=
 =?us-ascii?Q?pmtWdiP1LmMdpE3zjHg5yw6gTyXMl8yZw0zeROFLURQwZSzMa8SP4OIkbfxh?=
 =?us-ascii?Q?asD9oxGiGYWP2RfjAdneUvmNjI1D4OPDK7K7KowQbOFHAN/5GUm50u95Y2IY?=
 =?us-ascii?Q?0L2souJOme0S79m/K0Ko5MMu6EukTFcb1ov/tccXXD6R7EuDmokZUG7DM1+y?=
 =?us-ascii?Q?SH1pNTarKkWdh2ev0ZVSMsaYMukjlZstWDBE3+sW6Aysc8lMRJs0Y0U8OrEg?=
 =?us-ascii?Q?24zEUUwwc4bseke3vVekjL/xUyS79T6M96vaF73cy++P53eLOHEqjUAqpwsg?=
 =?us-ascii?Q?58z3v3YCXwKAwzNG+oC7fFkzw++eVfqBOHgUDSoAAoN2tx1uFwCMklp3q/0c?=
 =?us-ascii?Q?yZt0y2z9K+7cJpdOxW3v/e8KA0B/eaCb7dxz9AQURmIhHVXFgStRQOIgM5mA?=
 =?us-ascii?Q?8IL6HFZ0c91VOzwQacZn4AeMFGu4P9jJ6mqcx6BQ3vQBHn56qciDVNwxvwbe?=
 =?us-ascii?Q?nYTGKZwGnHeVDW5tBfnjyXuoVK7hfvKGRnzLs4bnOJWCQ4ZgDRJc38aCkdy9?=
 =?us-ascii?Q?qRC8D2RWH3iYRE7O9tvLyI28u3gdIlZE7pU4OzAYidjJPbpGI3Ye9VPMVAae?=
 =?us-ascii?Q?nr3Mf0pdUruRwlf/zL20nELX1G/AC1iz7i5gCCBVC7Ss5EHCp6NjTjLC91g6?=
 =?us-ascii?Q?zR4aQ6IrY73wlzu5d/goPurVANL8F26T2dtiXs1BPu2yqvcDsJEKi7f6b/ko?=
 =?us-ascii?Q?tvm9vZ7+kGkpqL7ZuzuAfIY76pAfZrw1hxLNLujbXKSvCXDwsrxhSLgML4J1?=
 =?us-ascii?Q?x1w2/HRZLKoQAB8UaQdiACfmNtcdKXy575q/azU9DJGiHbSwha9m80y0KeO9?=
 =?us-ascii?Q?adUbE9G7Nh3C71H+FkqX2Bziuw0ghHn3TvDTan86xQSgpf6Diam8apQiiTv6?=
 =?us-ascii?Q?ejmLMQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f48194-6393-4db1-a8ed-08db6da8d6e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 14:00:13.4620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YEBa7mxLt2RcLNwbnQhJ1xcICF3HwLgDUCyHFZNDl8dVSJa4AHpqCXbqeE8A4GAiQ8WwxK4oFVpE3XcGy1OK/iv1rwRkvYUJ4SYW8WQ3VUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3898
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 11:14:12AM +0000, Wei Hu wrote:

Hi Wei Hu,

some minor nits from my side.

...

> @@ -69,11 +76,35 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
>  	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
>  	struct ib_device *ibdev = ibcq->device;
>  	struct mana_ib_dev *mdev;
> +	struct gdma_context *gc;
> +	struct gdma_dev *gd;
> +	int err;
> +
>  
>  	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	gd = mdev->gdma_dev;
> +	gc = gd->gdma_context;
> +
>  
> -	mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
> -	ib_umem_release(cq->umem);
> +
> +	if (atomic_read(&ibcq->usecnt) == 0) {
> +		err = mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
> +		if (err) {
> +			ibdev_dbg(ibdev,
> +				  "Faile to destroy dma region, %d\n", err);

nit: Faile -> Failed

> +			return err;
> +		}
> +		kfree(gc->cq_table[cq->id]);
> +		gc->cq_table[cq->id] = NULL;
> +		ib_umem_release(cq->umem);
> +	}
>  
>  	return 0;
>  }

...

> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
> index 7be4c3adb4e2..e2affb6ae5ad 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -143,6 +143,79 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
>  	return err;
>  }
>  
> +static void mana_ib_destroy_eq(struct mana_ib_ucontext *ucontext,
> +			       struct mana_ib_dev *mdev)
> +{
> +	struct gdma_context *gc = mdev->gdma_dev->gdma_context;
> +	struct ib_device *ibdev = ucontext->ibucontext.device;

nit: ibdev is set but unused.

GCC 12.3.0 with W=1 says:

 drivers/infiniband/hw/mana/main.c: In function 'mana_ib_destroy_eq':
 drivers/infiniband/hw/mana/main.c:150:27: warning: unused variable 'ibdev' [-Wunused-variable]
   150 |         struct ib_device *ibdev = ucontext->ibucontext.device;

> +	struct gdma_queue *eq;
> +	int i;
> +
> +	if (!ucontext->eqs)
> +		return;
> +
> +	for (i = 0; i < gc->max_num_queues; i++) {
> +		eq = ucontext->eqs[i].eq;
> +		if (!eq)
> +			continue;
> +
> +		mana_gd_destroy_queue(gc, eq);
> +	}
> +
> +	kfree(ucontext->eqs);
> +	ucontext->eqs = NULL;
> +}

...

