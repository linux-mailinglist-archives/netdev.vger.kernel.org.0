Return-Path: <netdev+bounces-319-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D74B6F70E2
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 188DF280DCA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B43DBBA3A;
	Thu,  4 May 2023 17:31:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7DA7E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:31:37 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1884ED7;
	Thu,  4 May 2023 10:31:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXnzM2Hu2EZqxeWTDJeIH4CvCLJwOVMqePJ2j8IRHQybhkuuvddOzdoREbBhpY1fB9IfNIr0NaQfEf5gK0tvB2trbMCSZqcCqEeYTj3KVji/eFAp2YQIbLhQRNn8UiSxiwFG6r2yve2WRsADO3o+qkSH6/mdLZaOrTIXGSgP/DYaygSh4v8a1+axV9Cf0wraSa65Pkd3+ld4vvqcXftNDTqlnQ+ZKUKznBZK7sqNs8RFSe0kCvq2cVC8wqtActGE4xKiknrlDCmbHlRksMzVuvEja852/amPT16xD1gu0ADFAgzBEHHarafhDTO7xHCmOR3nZhFIsPkMPS+uRsZitA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99fTmXiqskCauHPG/5cu36mETq3oWOpBbca4UupRqTY=;
 b=Hac8XLq2/pDU0NDYsOH2lWVw2/yy1tJg0uXEAkkzHYhd+pmJeyM0q4L5ROLAsa1UoBHzMHoWIHW+lVOuoQQxP/jZJIgMIhcmCycqjt7sJ8p7tBMQcBGjmSR4YmPeyaT82f6YEKj9NzO70K+tzW1XBnKidwpAuzKsn2yOB8+g9xifGAxQaNVtAIT2zAGciTQtgya6weBDdlzIAQ/oGLFfV/mC3rBQwZGVtWzI73RhC7Lrgqm66bW0ZRYXusvTFBkDaET6z4GYQvV3zS05YYkGKo3/3PgImhX27AE9kkYrBHt3jz5Zbxsb1NDbFNc5rDEWplP5al/ipDkF+w86fe8L0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99fTmXiqskCauHPG/5cu36mETq3oWOpBbca4UupRqTY=;
 b=uCRlETEnAxlIUD4BQWgggwmxI55jRxrzMARF+8HxzLnpjc0idlcCUWc82daN6vQv9HWGj6Cd9TPzbf/GkJiNQvd4UA5qlAr7LvWG4KjQy4fe7hFXivqfaI+PZhBcCPhSCvI9KaYfa70cDY1OHMka6525674bIe/5mvc6kbabv4L5iDKzzjjWDg3tBbVqKpu+efwNpccYgWo7jR5U9zTacMz9Zk57IBkxdRjsKjSNvzuVlMjAWiajuCtaxUXjdYoaq1bh5nZz/Vyr8vtbgZm1hZo1jQWN021eO3tdu6FhjfquvKBGPaa0UZQXeLSoxrYo2ikXyO7bDciv96TG6gG3/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6329.namprd12.prod.outlook.com (2603:10b6:208:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 17:31:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 17:31:34 +0000
Date: Thu, 4 May 2023 14:31:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Message-ID: <ZFPr9NWf5vr1D+Uw@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-3-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422010642.60720-3-brett.creeley@amd.com>
X-ClientProxiedBy: BL0PR02CA0107.namprd02.prod.outlook.com
 (2603:10b6:208:51::48) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: f44f5bb9-9588-4a74-d249-08db4cc5680c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0UcZuJGrZ+SRhWlzOqc64HFb99qS/AWXYhRlQQqqijZd4r4hlT7MgDzrhVIC+7Zk6z1KNcHs9yC6km0wnAuGX0yBjuNinHHaPpUBhsDOSmUB0gMniA+4ff559acH21KuujnoPMMj/d4sO1+RQtH+eA3TsGj1KbutpFvYESQVUlNAoA8wccTVJQs1KFM5keN9Z9AbIjnK+S7YkUurnDY6qJ3zy4mWwa15qG1g6r5vAi/sb4aM9rHIvfGqPs8UH5WzRr7Z53urKzjAHDZu5G+i064RTqH/BLuMgKbw6vyuWRkaqPreIxcbqu/USCc1DX2Qzf4X1C+pUVH4s/UgdEfvQReUCJELAo0yein/mLwk9EF3biR7WJxCDCaU0jP62GDTFQliKnp5znw6sPu2u55Z39pgXikS5ECCLjad5Krz27KYlm6jzCkzSJAdNHEB7rqSbUQru0tQ6EfjQgz9JfjnCReB9NxXzPEkBbaul/mIqN1jwuC45ukFsM2F2GjgDeDkcTfImHN97AVFZtgsbUEp7rdfaVyUp2DirnJdWCmCFz2wgo+OmiDhEh7hPuNwWC5TGT8fv1e3l3BgG08/8YF91KXVJCUSrEeVDXuL6UdWpQs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199021)(6512007)(6506007)(2616005)(26005)(186003)(4326008)(66946007)(2906002)(4744005)(83380400001)(36756003)(86362001)(6916009)(8936002)(478600001)(6486002)(41300700001)(8676002)(316002)(5660300002)(66476007)(66556008)(38100700002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RACR4YzPf2H0chZ/KLmw93fgtDiT82xLr9ieQ7AYtoAdYm3NErRIVHcTyvkf?=
 =?us-ascii?Q?OslSKQjwpkZgfHKEAFfXqSBZhpu6ET9rlyg9E79JHrkaAMz9O/xzV3qX9HLu?=
 =?us-ascii?Q?ffG5Ur10uZyGw2/FqN7UZ9bfpjXtf9uEdQBsrgtqkxG/gNSpmpdL3n2H5T6v?=
 =?us-ascii?Q?hrxhrgaOETWdJ4qWTQ4E23atx80hOyCTSjeXAo8TUTgo8F7jxzEeEhzUYRFm?=
 =?us-ascii?Q?tnGJ0H6VOOyz197Jl8FojkhViU6n8BG/4CKixhui41XV8BFdRqlAs4gWZZiG?=
 =?us-ascii?Q?kNhS4SZe8zOJP6uorQLbwsddR6qnvVXosrB+QLaNntETmnu9bZV0uPORdnAT?=
 =?us-ascii?Q?5cYQwqkrcyCK195WYXRBcDHz8WhZi9AfLDHsbYsmdKs9f1p5p3wIYnKW6jmK?=
 =?us-ascii?Q?n0DhWjvoqRoCuAwbAsoCid9m9rk64z28u3une8mFHe/2ORS2CYgcv089ypaI?=
 =?us-ascii?Q?pF2V/+7WuMh1M3UqB2IWldbDDGMoA0bSeUsaks1Qjn3kdNr+HOJx5K+D4mRY?=
 =?us-ascii?Q?/V79EbE1b+YHYZFDxDe+aV3EXTRWoFtUEyboKO9SzQhjhvIwWaFSMNzZ4Weh?=
 =?us-ascii?Q?qHMeonmL2Qs41fPCO7OXMifb7T4ZX5raUqNu9lFhNS+XTp7XN+3JOt4u7d8m?=
 =?us-ascii?Q?unbdpZIzwsGJbrf3n3vRM75ovsIKQNqXGtcjv92sWU6UzuCgnAqnV/teK7ve?=
 =?us-ascii?Q?KckvcVEJm5VuRlOap16Qm56hpA6eSfW6ar8YieLhOMmDt73gl6v0a1EnhtAz?=
 =?us-ascii?Q?Fo2jbxR6LdS5BzUCmBHGnn8zQcoFjy+NZKT5k+tBABiOpHYS98U5VPY+XbKO?=
 =?us-ascii?Q?hZ8vzBFl0q3fNnBY3ZQNnWpGukrqSE74Cq5l1rjTLsO1mYh8OSnDoEzOlwBl?=
 =?us-ascii?Q?5NEAb3oPQXw0Q0WNx27IL5hdLLdUPG0xYzPfR7lZ1Jqxlpspibs4nqD9P/rL?=
 =?us-ascii?Q?RN1n/8+80T/AZzMR+4cuTE83vKrV20nBXjuwp56mSJxMO0gh+NRVW3u+9H4E?=
 =?us-ascii?Q?bAGLcLkLNQZxtDJiuEE+p/v9ldOlrMrksvTLhYmPt9qsklZYEaID0LHArmPT?=
 =?us-ascii?Q?hzeVzzKQ9aRCEp7MOfwxK5KNNqZn2XD9GkvW2KawumBNTSh9g1C3PmngiJQQ?=
 =?us-ascii?Q?acpYB1veeeHy7099i//Ys3xMGFTYCZ/Bd6u4Y3Mh4XjCiAF5NSFGR/bzG4Tq?=
 =?us-ascii?Q?G88biycSF8wzCfo7GMKglou+jD8HR6on9TOu8wIn84JJtTwf5YqrGqPGQ0wz?=
 =?us-ascii?Q?Fs57F2yQHFZMY5OyUbhIaDxjRU5HB87L8cIrXI+kSRBj3lij9SI9S/r7LNBj?=
 =?us-ascii?Q?IyAmR0a26d0QYe9ynGTRKQiAqNHK7pW8Wi7YQkaYijO7CQfoSKU8zK5Klb8x?=
 =?us-ascii?Q?bpUjoBMd4aj7gdwbiBMm1C1X9YQyvAH/hxbTf9n49RN37zpYXog/hlcF9Zm1?=
 =?us-ascii?Q?XAhRjcnfgWu+6z9zV8uAg4cXG9uHB8VuOcAgQQOP9tsGeHmifoDk5VfaFqHt?=
 =?us-ascii?Q?rSXTD6IfLeukZydrQcMOar6PLRNH+bPuQqwTX0V8V/sZ/9Y8Tow00Q6JgciI?=
 =?us-ascii?Q?fb2y8oy1k/hQUMIL/qRXpqoPe5G2zCS1VO64/0aS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44f5bb9-9588-4a74-d249-08db4cc5680c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 17:31:34.2300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5Jne676aNXeuqd8fUAa93GFN/cfAWXSUkWnY043d3xn8NKbKbsyNF4+hxUSaoH1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 21, 2023 at 06:06:37PM -0700, Brett Creeley wrote:

> +static const struct vfio_device_ops
> +pds_vfio_ops = {
> +	.name = "pds-vfio",
> +	.init = pds_vfio_init_device,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = pds_vfio_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +const struct vfio_device_ops *
> +pds_vfio_ops_info(void)
> +{
> +	return &pds_vfio_ops;
> +}

No reason for a function like this

It is a bit strange to split up the driver files so the registration is in a
different file than the ops implementation.

Jason

