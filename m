Return-Path: <netdev+bounces-323-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2DDE6F7187
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 075E0280DD8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A9FBA51;
	Thu,  4 May 2023 17:50:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E279E4C69
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:50:44 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517B1C2;
	Thu,  4 May 2023 10:50:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGeal8/jtudq4Btq5fJideGgPGFNHXyREjrbqWwhDQRF0/PiwgPkTb8TletGWBDt5E6yl9vvrKWT7qpyju01GSvK45QnoLIOBmRNbR/mvCqtODJolNaGsFLf1awgsFISBO/WhNjWxQf8RWtHUmsqEyTcRAoZahxvfgjRepJgbfkFfzwt9hV2Lh5oNEaqa/cX/M+rVEl6hhkzbocwTRmF+SHBuZoNiIuX9+O3bKqv3RYwSf/HdEzStzDOa/iGiJgmxuR61d3LNaPriJV3SXiswU0VA9dWaC94m429o6sKDZUGjdwp/PVh1z0RaOfEJ9ZUDcilCztjS+xYa0ucebPujA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XY+KPKAGfu8yhiX5AKDkdiIz15RlFt78X2Y3mTst6I4=;
 b=gWcr0yFLlSpGpGcM5QRqxiwPvQMvRK+P7/z4LjSvW0tVNc6oKzb73brDW4fh3vElu7PkJwdf+4xcAxIKFUtvE8q/SsJ1XUty8S01ev5gZco2B73ova9hkyVuSS8TOu6qRIksWBQBMr95QvD6I0/pEu0bDv9m9TTnNjJ7bD2SpjqaoysnBsRUJPxmy8qWv/vgfeQ3o3vSYccOsKFo2M0drzFw6FBd6gn2puvmZKkosad2TkUsjrQbPNGvVTelbnAdOFU8GFWHQhsgZ4n1YdSQdc0LipUQt4ignsI8jrqWnmDq6E9tfou1YamaulJp8RQwNESwN8Rm3NvPkqVI1qbU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XY+KPKAGfu8yhiX5AKDkdiIz15RlFt78X2Y3mTst6I4=;
 b=jv6sxCMXmBlDImHvKYVyPHMnRjys6sIpPP2yNuy3HhNZPsGMyO3XK7fciv+eT9qfdFfZa38siM4LSkO9l5pLjIuKpppWNmlU+gispXzeE1QZTjboLxSy8WeBLpRh2Z3ZB3BE+2beR7Kb9wDRT9edrHJUmRNnsL45+jWQWJKF9tLdYn9Co6MD7Dc8NZSxzzkiH2j1HFUmn1pm7WNKpW+n8uUTZ2NeV80H3xFycVa6G4maQ+EjkJNEnD/5C01n9JyNV5tr0C1Mahgq8ivGTFNGR95t16fIXTGv70YhntOb7VIYryayCHujW/4kBs2SkcXTTFHGjGGLFOt/eQvNcW0V3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5471.namprd12.prod.outlook.com (2603:10b6:a03:300::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Thu, 4 May
 2023 17:50:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 17:50:34 +0000
Date: Thu, 4 May 2023 14:50:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZFPwaa40glVrms02@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-5-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422010642.60720-5-brett.creeley@amd.com>
X-ClientProxiedBy: BLAPR03CA0158.namprd03.prod.outlook.com
 (2603:10b6:208:32f::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: 83f7ad7d-dcbc-4a81-899f-08db4cc80fac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N+PnwPUq1jaEsmN/ZDsyIIbRxGsRki81TP5wjWdPpgF3O3unAdonyiCxpZI5ycZesA6yuPnBuX+RyfdI/KrnhYW+lSlxrjsAlBKLDwQwMLKPtkCLe0ZcVDeSczt8m4hgrhIJwIjoZ9mD8gvCjQ2O1Tn1XXeGDope8p+D9eVmGbYorYryuiKvfoRy7F3VzC4tGbSDxBRvyZXioIPsb2nHa6oBKDskS6n11TIKOlmqWHnpSyrgj/CnzLWW5yvkInFOOKxBc44qcqR9RLcD59VTCbwHDULGxn4o8yBDKpxZ4wt/KRx/7SIFZSCrjUAJzCoTflZMESt/CP2rwFqRNJMQkdzYLBlmg35sIBBiiNPsCPbMeJzkKRhn5G/e2dz+Vw8cMXY3WPMT/VMcNtEHHGud++5pD8dTlNoFFtHhRiiTNysmd4XNltsNEGapEh/4kV3SB+mE3rL3fWwtqJ1Cd82hNNi0eE4pblDZDF1VifJnAs5ez8JKxMdRd2Zh+yjj9V8dQtkkAOJyDiWOTzJxfr0DvycY+EF4g6F0A2noMzFv9jpnqQCG7dFgJelDMgioLohR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199021)(478600001)(2906002)(5660300002)(316002)(4326008)(66556008)(6916009)(41300700001)(66946007)(8676002)(66476007)(86362001)(8936002)(83380400001)(36756003)(38100700002)(2616005)(6486002)(26005)(186003)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f7wu8BoWap4LO8a9Xhu0nYNT5xAy3Sybg7ahpTKFWnmrgKuNU/7NlcbN12Ge?=
 =?us-ascii?Q?Q/DqGYqWOtR7f4stuQhfmuk81t9sm6CzqQ9vhgUc2yWCRIpNjzv0OL9oj5+l?=
 =?us-ascii?Q?hfE7MY8WYfGYT2RM64NJ2yqpjH/qvjqbUKPMwUxkboa+FQ27LqrYj9uFQqdw?=
 =?us-ascii?Q?Ya/mAm21lNQYJ8Cqp7FMsl0CWzua5XnoJJ3nPM0amVk1rhiDXKG3m+VoOvBO?=
 =?us-ascii?Q?i0YotdOpjnt9wjFdRUbAs7hIQBUJW6oNlGzy6ZAa4I2q28P8ucxERSrycdsq?=
 =?us-ascii?Q?zheMZa1JAYVu5GMoM9tN0k2xAVVlYfe0NsyftqjJRYm9HMMx9C4BTrvQw5kp?=
 =?us-ascii?Q?EI50bqb2vmOtPo5beVdRlR978QS8NgZKQ6WHvoj9mLbRFBJSzd0qk1geW6G+?=
 =?us-ascii?Q?D7D70FPf/QBUk46Yuqj/qYWkUcXn8zXhCL2w4AOA5HV7KRxlce3FfiH52LvV?=
 =?us-ascii?Q?bTeruOTTdRXqJteragI8o2o5croFLYudj03C9Svq9IvUnAW5nfEnbNMrPxBJ?=
 =?us-ascii?Q?iaGArWLJkXbqjXXSdakFTcIx8L9jxnxUwdE3mjEuuiignPVo571zY9+tIg6C?=
 =?us-ascii?Q?i7HLloyDzqp+U+RChVXqvRe5PzVNJGJnMHYGIEoBP/xdR/YFYdh82Oe9jgo6?=
 =?us-ascii?Q?/MG21bFJcJNPnAuk5rBUUesagU/AnW6X11r5AH8poV6LjSQPeJm7K1rEjQn0?=
 =?us-ascii?Q?eImMQWspJyqgBkImOCaXa9xGZS9WB/6pMbcyw1jK1hiHVaiRlD70Tj0D1iLX?=
 =?us-ascii?Q?JAekpLQBYlCl7ZOswGfEjGjS2876AdY6/53Q043air79FVX19zZkt888is0J?=
 =?us-ascii?Q?LKfl/xf7mNHiNLmmbNp1pXcH81iS4zBuJ+jPZUtPkT+jvevUmQ0FAe2wfpjA?=
 =?us-ascii?Q?ZdnKEWtnB96yXIt7R/ZhHBnDf495Cp2JD9FHb4kZ1T5j1YdbwRRjNcNtDFBi?=
 =?us-ascii?Q?AYOt8SrM7163+/J8+vKRw9LnNRetw4gemhylMbeZ2oWQSyTw5IB0GxLEb9mQ?=
 =?us-ascii?Q?KpAcfD+ROaEr/GKS1Lm3E4Gp7R5fwceiZlhjBQPauDJeDy4noh7uHCktYgti?=
 =?us-ascii?Q?4oLBlLkfIw+O1npmE2n45n3rCBTu359Wsmo49ol8h7c/Rf50ZDlt3D+WUd2n?=
 =?us-ascii?Q?0M5ONlCOfJjX8j/s6Xpvx97xE4FcwMWdMUg1tSstE71F8N1Qu0uwS7kAHPYk?=
 =?us-ascii?Q?2YCxUH/erIhToSx3skx77qp11z5FLgU6cymvgZHODW7XN73DfOFnZrH08ru8?=
 =?us-ascii?Q?PENNSyR1DQO0mYOQzQjVHtNtPyOivCK5qciy0I2yWt63W4/n61AmfS6/EqA+?=
 =?us-ascii?Q?MHErJizzaMPFvvU9VZcUHWYTLtNSTj/UuMPEFNZKnpOd07ycn+6Nk9Ur4hgN?=
 =?us-ascii?Q?Qs4SKQ0bmdYA6RJg7oBcsJS+hLjWu76KF9P+Qsl8hmdTPgeQrjIPNNYrcvDj?=
 =?us-ascii?Q?FlY6AsfLS+ORiLCkj+OKSXaUFXq5Z27odWaS7B/PB8mVRofHdc+zB07K2Y5C?=
 =?us-ascii?Q?AOrIlC9oKiBJ4PZE3dz9MRdETM4pkNn65HRGabM8qHY9asFVLGrHl3ijt0pO?=
 =?us-ascii?Q?SqI9baKn0adPZuzd3zOERJgFpAtHlbZG2JTB5uld?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f7ad7d-dcbc-4a81-899f-08db4cc80fac
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 17:50:34.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1G1tT1dys0yVtYKg22NHRnINi0yB3r8+A0Yn370lw4LNBNsuWclsTI99KEyNdsAO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5471
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 21, 2023 at 06:06:39PM -0700, Brett Creeley wrote:

> +static int
> +pds_vfio_dma_map_lm_file(struct device *dev, enum dma_data_direction dir,
> +			 struct pds_vfio_lm_file *lm_file)
> +{
> +	struct pds_lm_sg_elem *sgl, *sge;
> +	struct scatterlist *sg;
> +	dma_addr_t sgl_addr;
> +	size_t sgl_size;
> +	int err;
> +	int i;
> +
> +	if (!lm_file)
> +		return -EINVAL;
> +
> +	/* dma map file pages */
> +	err = dma_map_sgtable(dev, &lm_file->sg_table, dir, 0);
> +	if (err)
> +		return err;
> +
> +	lm_file->num_sge = lm_file->sg_table.nents;
> +
> +	/* alloc sgl */
> +	sgl_size = lm_file->num_sge * sizeof(struct pds_lm_sg_elem);
> +	sgl = kzalloc(sgl_size, GFP_KERNEL);
> +	if (!sgl) {
> +		err = -ENOMEM;
> +		goto err_alloc_sgl;
> +	}
> +
> +	sgl_addr = dma_map_single(dev, sgl, sgl_size, DMA_TO_DEVICE);
> +	if (dma_mapping_error(dev, sgl_addr)) {
> +		err = -EIO;
> +		goto err_map_sgl;
> +	}
> +
> +	lm_file->sgl = sgl;
> +	lm_file->sgl_addr = sgl_addr;
> +
> +	/* fill sgl */
> +	sge = sgl;
> +	for_each_sgtable_dma_sg(&lm_file->sg_table, sg, i) {
> +		sge->addr = cpu_to_le64(sg_dma_address(sg));
> +		sge->len  = cpu_to_le32(sg_dma_len(sg));
> +		dev_dbg(dev, "addr = %llx, len = %u\n", sge->addr, sge->len);
> +		sge++;
> +	}

This sequence is in the wrong order, the dma_map_single() has to be
after the data is written to the memory as it synchronizes the caches
on some arches

> +
> +	return 0;
> +
> +err_map_sgl:
> +	kfree(sgl);
> +err_alloc_sgl:
> +	dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
> +	return err;

And why is the goto error unwind in a messed up order? Error unwinds
should always be strictly in the opposite order of the success
path. Check them all when you are fixing the "come from" notation

Jason

