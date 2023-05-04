Return-Path: <netdev+bounces-331-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD716F71DD
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B45451C21219
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1433BA5F;
	Thu,  4 May 2023 18:21:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6643C0A
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:21:25 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B041700;
	Thu,  4 May 2023 11:21:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9yz5TQhXQpGJtSSO+UDEYUtJvmEm2aWWVzHcUvr6DuM8kQ1zckBjGeoc4WDknxUc7UiipiRXrdW4Y7OzehxnCkpVW+QuYs2Xgkz3KrgqEXVk/70OXYzsNs/wv4qGZtzlXHNFKNyiCg2jfMvV2dYDOEyoHeuyGJVOvWYgZI5oyFVy4D9SEu9RHW0cns04bdA22k9pO+m8saaet0SvCVYbBsORSvzN1R10nGlusEhSHt72Y2XAZKFX2cTvRHl5jzc5y5YBoXdvkdyi70YvrM2u/g1MgiDeX/obLLWUJDR5tp8zB1awKNPR+riKtFWjoNOm1uFIIoICjsjwlOc8Vpm0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40xlEVGwDyiK1x8Po2kejK4YLjvZ70ZbmRz46lGFe8Q=;
 b=WJIR/YHTT1JCkruBnshX9cYtFhz3H6zKxl1x9Wi7jvgIW3tLvOCniehOsAalM2hNtJ4VBAxaOecULnV2Ab3dARYQUMw/e1drzpQsE9JilH7nagr7aW9W5wO6/LVKXltHagyRk0mELcm31P0lC45yfzhCObewW7pUJwssfsuorTqzrITUikJyCFgyPgs1I6fvOoGTPst94GN+0OE9po7urILCbKlQvQNNBwKkST9RPLMo2BRGHvDXKrWrYp2U2KxGDxE3e60zjWfFn2XZy0pIzOXlvFuotaNNUYpw/vENfhk2ufrg2F4P4WTnUwS7/T+q7qhvgKaJS3WrgI4lO5PtSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40xlEVGwDyiK1x8Po2kejK4YLjvZ70ZbmRz46lGFe8Q=;
 b=WC/TVdeMbXvfUwhEWFw45MVQbONZFOH6rwM8nndow48Urfu5bOMc20mcGBlUcbEtrH6yByrdc6CrdR+hVkdOPFyVvVNQqpEMErcnMDdtXH15iTwalxMN9oO3bmnTWVm+vwizoOni8RCOMg7PxZnHt8THQGQVEw3VPkTa9Dm9xeM4OOm+CT0UgvqoHxF6ibxswCkkyIzpI5eggPbKFBpgcCc9ABVY65PDk7SVMI24eemtQw0LFhLsbSOjLhZ5s1Rlp26enYicpaXGnn4nfUsVwD6fvnMdLkYHMstFd8CxrVwwTEh0wMwWKAspQfhB7IwID8jAXunBlBvGSz6UHfpC8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL0PR12MB4947.namprd12.prod.outlook.com (2603:10b6:208:17d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 18:21:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 18:21:21 +0000
Date: Thu, 4 May 2023 15:21:20 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 5/7] vfio/pds: Add support for dirty page tracking
Message-ID: <ZFP3oAFNoKNCv46R@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-6-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422010642.60720-6-brett.creeley@amd.com>
X-ClientProxiedBy: BLAP220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL0PR12MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: dffc3ee9-2ee8-4dde-5028-08db4ccc5cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BDGDbqi67ZXPa1FuZO9ZaOIfMVwFaI9I1WNJjArR8/JWxNzWGIUwJJhDewmBcTICDh1YMk1fGHwu3ApHAbQg6BnBY/JKrlvtwVajBd/degfilA0gvc+inxhiqRsDm2idtgNCSCwwJLcd+WPJsIfdTbdQBNOYieRNZjrKDxAsAAT2K91A3G6j6RN81CjwK5H6EGYTKMuR56Wp7tzKfhAitkYtp94LRETah8sYkR4Rnl9gEiZQJJP+GF7lQDPc8sdWlrzAShwNpkhaHdtEpdcmW7eoV7mLnGNWM16jiSFqPVgzckj18oLddJZrzbdANPI8pLiFoNNcraRXyDZT2aZFWaaH6eOLUCP05XZT8kSZZxwlDB3FxWqkqcUsLKuQoPBDlmQIOCxDG7wqKpdGTBI7qJOoNckX26S/dAt9/cc21La5zq+hSP/LooAHnvvJdA0o2x0d+w6i2NHbKtPTD1f1ZcrzwV0aFzTQB2RmG5YBSkefMgPk0NBy0Ab7Z3d0wi2Pi9Kn9bvK2Sk1/Ghiu1gtF0v4BhKGCnvg6TMtofn5aqa+7R8jckm4nN0xqm50ei/HzCdsaIPrm8GPa2vbgNMRn6FokEI1gGWZTc8AUUAfIe0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199021)(26005)(6506007)(6512007)(186003)(2616005)(5660300002)(2906002)(83380400001)(8936002)(8676002)(6486002)(6916009)(41300700001)(36756003)(66946007)(38100700002)(478600001)(66476007)(66556008)(4326008)(316002)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BIFCW4BT1oniTUsRWSNYWINMhgV/fhcoV9nPjLiSK2iVkTkWWkXwrjZAKv5g?=
 =?us-ascii?Q?gz8xVtbgGKREYteTMg8ntWAOZ/kzFDsMx+lM59TMSfB3QyyHsx5IpUMMEmRO?=
 =?us-ascii?Q?NyGaWsq++4SUyL59/xUU8LynLaaYl/0FZRbeW9zpXywsBOoZODaqWT7a6bjf?=
 =?us-ascii?Q?VIbX4cvgN1lelUn2wg6RicyG0xH3raiFAhMcKuj8jMS4PLiQk7Fn1nB4vYjA?=
 =?us-ascii?Q?1wlGF6/gKTU8oTH1FslepBJpDjp2QivyI9AWO3oAMPOrlpaM9encdHQlkd+6?=
 =?us-ascii?Q?WEdvcMaLpRXDULnvt7rctpQ8pO0cHqpfXH1TSsKrgx/QwDQ98HeL58TU/Nqo?=
 =?us-ascii?Q?VTY1waLgwDqQl2rWgL5m+w+MTncVdwerKfrm9o4dTF4MVXbCknq997vFVfOQ?=
 =?us-ascii?Q?KpQeWgTnRmF597wJ+D0jfmOFGJ52XpnGR/OAp6nv56J2P0bcD0mXcf4R2+ya?=
 =?us-ascii?Q?EC+/fNY8zMTBTWS2Hw5Ie+48BYjk6KzDE2/c8pg3lSJURoocB1Yjgsyqa3Og?=
 =?us-ascii?Q?AVqCeqjv98JeYdTFKQelhA1j/BQrvjKG0DbW4RIUMGnSt1YOkWbfhRB2mL1T?=
 =?us-ascii?Q?f12lDBc8t3FdiyBLPBygcgt/HkuzBT9bPYmX/nK16xz3CfTb3ZtmG0frcRe8?=
 =?us-ascii?Q?83h/aFrOsG8d4M4Bx3KbBoKYxlFBZ1td+K6617YINwQq4Tl1gaWaIzJfg1kE?=
 =?us-ascii?Q?2uik7E7OcIMkZjSE9sKXisc07sznnRV/B/VZQzQLAK9iI0rmvDyNwNdIRLzN?=
 =?us-ascii?Q?Yl3oj2LJxVYdPqCVVL5n1vsgZFeB7Wf52QiwP6eqaIFtuz/24HWWAUfIl3vB?=
 =?us-ascii?Q?itLMlSVkKQc0nX8pxfTlJJhHMcmYPd/8aosnBiBUNyBMbss4AQBO2iS8PglF?=
 =?us-ascii?Q?5xI+/udDFSRwXomYlX4Yba+XGkCe8IY1m2pIpQKFsiOivZr29K36wOBlDCtl?=
 =?us-ascii?Q?/Yl3k30azFJnf+zpYKHW1EFugzCUMhhYP9rvIORjoMzOqxhyYt7yJo8uFE2B?=
 =?us-ascii?Q?WOfdUy++pPb1yA31OegQ/A0Ctaa2A7Uhwdygg6qrbFBEJKdvmfe3FjcED7v/?=
 =?us-ascii?Q?/DgoCa4X60fWyJp+YZ4RC8Dwf9pLBEctPfdkCSl8QFpavoxKIDwQdzCtaItV?=
 =?us-ascii?Q?XeE5gnPpRb01MawTAxfbRGa8gp8KamEpFnfTrUJVmz2myaRjtKylg10l5IFE?=
 =?us-ascii?Q?jFMzc8Pxaj+XcqzZ2xhuJFOIbrw5gHi4hraHS9EeiXRhtg5kCkCtN1GlRM09?=
 =?us-ascii?Q?WJfN3zaL7GjhQb3O3wtWyMUyY09PTHccchZKoCgGgshlfXCEkPBDh03DfCIH?=
 =?us-ascii?Q?4Y/T/Mynh3cI2F+UemPCd+gpBWh0g/ffZuEaJbANtD0DGslS5L2EPMQg+2ka?=
 =?us-ascii?Q?uSh0njqCpH4S/MR9VrH/Y7Ti2eY0ZSX9p7nY1fga4XXBpcwZFCnSRYUJ0Hwn?=
 =?us-ascii?Q?2FtWUSzIg9wdqMEkAfi//D1+yVcvPLDuRxHwm14HomzESbnjiJ9/fM80OgGK?=
 =?us-ascii?Q?BbqNApRo4qYx3g24w791Q+SvLYBnOzQSGDXI94SqK0L1teRoQHp77rqudZhm?=
 =?us-ascii?Q?fuVPGvgQTWbl+S3FilMm/N/6hZNW5gmAn4p70Vfq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dffc3ee9-2ee8-4dde-5028-08db4ccc5cad
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 18:21:21.6601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxLEbCdGmnsY9h4shNXPhJC7YVUzuQgJyyQjzqd3mWQz7ma08p+Hy699y1QnKamZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4947
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 21, 2023 at 06:06:40PM -0700, Brett Creeley wrote:
> +int
> +pds_vfio_dirty_status_cmd(struct pds_vfio_pci_device *pds_vfio,
> +			  u64 regions_dma, u8 *max_regions,
> +			  u8 *num_regions)
> +{
> +	union pds_core_adminq_cmd cmd = {
> +		.lm_dirty_status.opcode = PDS_LM_CMD_DIRTY_STATUS,
> +		.lm_dirty_status.vf_id = cpu_to_le16(pds_vfio->vf_id),
> +	};

You can write these as 

.lm_dirty_status = {
 .opcode = ..,
 .vf_if = ..,
},

And save some stuttering

> +static int
> +pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
> +			     u32 nbits)
> +{
> +	unsigned long *host_seq_bmp, *host_ack_bmp;
> +
> +	host_seq_bmp = bitmap_zalloc(nbits, GFP_KERNEL);
> +	if (!host_seq_bmp)
> +		return -ENOMEM;
> +
> +	host_ack_bmp = bitmap_zalloc(nbits, GFP_KERNEL);
> +	if (!host_ack_bmp) {
> +		bitmap_free(host_seq_bmp);
> +		return -ENOMEM;
> +	}

nbits looks way too big to call bitmap_zalloc?

> +static int
> +__pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
> +			   struct pds_vfio_bmp_info *bmp_info,
> +			   u32 page_count)
> +{
> +	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
> +	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
> +	struct pds_lm_sg_elem *sgl;
> +	dma_addr_t sgl_addr;
> +	size_t sgl_size;
> +	u32 max_sge;
> +
> +	max_sge = DIV_ROUND_UP(page_count, PAGE_SIZE * 8);
> +	sgl_size = max_sge * sizeof(struct pds_lm_sg_elem);
> +
> +	sgl = kzalloc(sgl_size, GFP_KERNEL);
> +	if (!sgl)
> +		return -ENOMEM;
> +
> +	sgl_addr = dma_map_single(pdsc_dev, sgl, sgl_size, DMA_TO_DEVICE);

This needs to use the streaming API in pds_vfio_dirty_seq_ack()

Jason

