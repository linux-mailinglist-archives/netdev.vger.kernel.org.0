Return-Path: <netdev+bounces-320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE2F66F70F6
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9E321C211CA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF58BA41;
	Thu,  4 May 2023 17:34:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81A3C0A
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:34:36 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015CD40D5;
	Thu,  4 May 2023 10:34:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvVinT0QvqPiC5VhOfskaKNJWJPqaW0/D1mVcBBwHllZZdiWUBVv5LYfn6/72iyOSW61imnta7aIkax35it3DkR/9z1STU57G2my6p0pKTTRQigveTXLKhtjaYpCeudEcmIqZ8pre12iRghiPOKYuh1xzHyaHr3Hk8SManjxvJdzggXHCJO8wvalv3lL9bDia8uuta/cpLZZWBJ9pH6C5QuwGtAFTvKpTRyNxC8YbOJMDdIsyl8/9PuiD1IbKrFFIeoKU2cThMdNXDmbKLjFa3qW4sqACv9Oh6ozZV/G44v5YpheqZo/lNyq+5IWp1BnT1LMlL9cxB4sbZkG9fKuKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZYIpSY0fgUfQTAKPWZmMt+Gktr9I0k+dPRVwFl/m6c=;
 b=Qp5ImlQDoSs+HqyG2VDFUwmvaxXgWJusRKx5TVMmPKMO+j8dHrgom+XDA03x8dZ0E14jK05goU1yQ1tkLDzLXtsXQ5mQW+IoBXAH4Qnr4a7trlgQ0HCsONYsM/QhDyLY7Ie+3Dx3Btp1Nogyoxxnnoo1PtViU2pteOeKtcRiposlfrNe4HsuO3b+RCc2xKmd2/3ACp71619CBewDT2XXTlVqY4xXdtcycI/iwqonsv3I6DE21U8HAWx5a3m0ZAF15uKiQTI4U/40uPoE1aem3sdSKzhm0NGtaWFLJCmwk2/axSG3JoTaBaMA098tpc2RXzs9tJTWd8A47tR6Iq3GFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZYIpSY0fgUfQTAKPWZmMt+Gktr9I0k+dPRVwFl/m6c=;
 b=L5LRpee4DgLM/nMSuneADno/fPS4w6gbyCysVZY72PbLlDNSJz59/SuOKsOEiAyK/vXRLNYkDriE3UNmch7TgqPnRuewwJNomDDqTkCZZBlVV+HLycB/Q+t+fzC3SBXwy8dUL6/bff+Iwzx1Ml2bWIWRFKqH08d5XSXJyw1AmueDBDtCcXEwX1oX/j4Hk7/Z0FhIiDXcFvR9VJSjUYvEfvA/GnjP7QYMg232Jh+r8b3kgC37zZEFcqctam9JDqxzTgIyj3NG7cnL2XUWWGn8hB2U438ZBoyZEJT0X//IMwnvOO4J29yZMinCr/npEqZsk3f6z0+zQ+BrUPs3XxsKHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV3PR12MB9186.namprd12.prod.outlook.com (2603:10b6:408:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 17:34:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 17:34:30 +0000
Date: Thu, 4 May 2023 14:34:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZFPspJbvPbo1a2/D@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-5-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422010642.60720-5-brett.creeley@amd.com>
X-ClientProxiedBy: MN2PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:c0::42) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV3PR12MB9186:EE_
X-MS-Office365-Filtering-Correlation-Id: 07741608-04dc-47b7-11c2-08db4cc5d0c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hgExd5fb/vDHed+ipIeBb8gom/QmEx+Z1BbPuMBwPs0ujbsygU3ISQJ++myppm0ur5HIXQTehHi9dPfOrWqduQjCejaWBmQWciN3m4wJW4atwfdKcjZoblTSVxEW4uxN1KfmPTO17nMQA6SIa3Xg2igJzqLwL5JZDtCumbF1sz/0ElWk0R53N6fQRZXMR4vAp7psS1gNvnzv+AWxz1YVA9OGOcpHQceD9QRTXKqnds+zUbKarP6z/ze6UL7eFGIpqfvCcpvcF/KPrm7C9nxdzv+PrAKqN+KnThxgtdhGITpVVfDClGtYalqE/C4UjIWle3pMLHYqBiKrNtZmEe+a09uP97l0Ef5V+NFo8N310+sDaXGUx/pbuTQXaAS+HHU+p9ykudv/adTjGk5yAUsXSNEQGmq+Z1M6VyVWkaPYB+BEsgcyEZJyEQ05wAQwrFTf86XTakXa4IP0RLhqK776GRTdlcWLgHD2VYlNbx8opYvD5YgMV6w3dgcwxVEOE+L+tn9Qjee/5b0bB/3pQz8i/cpmOQTy8z67S/s+3ep8dMDn6Zjo0oDquU9agc8hOsRt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199021)(478600001)(2906002)(8676002)(8936002)(5660300002)(26005)(4326008)(6916009)(36756003)(316002)(66946007)(66476007)(66556008)(6506007)(6486002)(41300700001)(83380400001)(186003)(6512007)(38100700002)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2WUXshi5LG83g+h4ln0Egu/NH3jxlLsOKQkUGB580aG9DtEy2+VCiVfitn8i?=
 =?us-ascii?Q?5w9RsBKhO1iuA8R14+MkEos4NcQOXIIlXKnXZIKAnzbvWUvfvLi/gm/nQgeh?=
 =?us-ascii?Q?g2VyUmuSnF81T5oxJmKM4PT0Qn5EDyoCpHcRdk38tXTn0n5qCnvG0m73Cnvx?=
 =?us-ascii?Q?MT/MX+ZOtG098HHv5FMXfLy92bDuk1BIAY9aVnQUdfFteEKCLwGd4IfIbRf7?=
 =?us-ascii?Q?02Hsz4WGZSyvlBij/2yy/d0rWap4l/4J/M7vTrJlMQAdH1GwSXszKYcCGLYH?=
 =?us-ascii?Q?qiiainQT/ybbDPu0Voa+X7OYu7Puxb9bczh6dFSEpqWILkKc6eIwXWQQtOSS?=
 =?us-ascii?Q?PukNvECQqS0uhcqzgLI392qwG/JoLH/tNb62fp4iU+mBaKZ8UUTOxiMxJ6Ec?=
 =?us-ascii?Q?Y4ruaiRZ+4frcQEpXWWGsiPN334kwKDA3ZKuvgXcI6+MJwmCwBhE7tYcf9T2?=
 =?us-ascii?Q?Itk+/0zpqxiFa+6xA9nrywGXcQvvr6dGSIRbDJvcAZc29m7M7BRgTgqWP94i?=
 =?us-ascii?Q?HdGaRVjo1xVeKbWPdcmLAm0Z5ZjUj0DhEMaKBjDG4hJ6NrC8jl+R5RZrN463?=
 =?us-ascii?Q?1OxJ6ebFV6QaZbdZ7CFydf66CBCeiL0hyRJ3eRcTpf0Bymvwf4w5DBagFQsh?=
 =?us-ascii?Q?Ds2HKKGfhJzPgwpjig46b24GDDy2N1frGGmZm76RMoGRBpYmrlc6eDhgEDlq?=
 =?us-ascii?Q?9hDQ/N4mhRM4x0iuzth0WYLrHQQXo3hz+Lp5quKQipPjt/qostFXgC8padJk?=
 =?us-ascii?Q?/kmL/J+YifwBxhvZ4ziIe3S3sHc5A2JCQjvhnun9iEHgaDOATzD4fyH2C7ME?=
 =?us-ascii?Q?h2xZC6eqTqUNNPZ3oFLMwHIUbd41vdVGiTx/0eIB3vu6eFJF81gHWG7ardUc?=
 =?us-ascii?Q?DMnFNFE2qu1TBKQJTuNIsco0ESsz/hiElDikpxidabmocOBo4rYDLbBBqv1J?=
 =?us-ascii?Q?/Bztk/DI7EeH0vjQnl8ehxu4aBjLsaPVgIxKxPtMhslrmDYIz0SYcTNasu7v?=
 =?us-ascii?Q?TCKOv1Mcwl1WLRKdOhnVF/4qpQFiiUNaFUUN16niw9Q8hkADzhXmDx4VxipW?=
 =?us-ascii?Q?rIOGFe23xD3C1+VFjB6iuH3UDx9+HlsaqIY60O1KgKyg7gbWl3NDktQW/wVb?=
 =?us-ascii?Q?B5T5Gi07Gc5d/cW8bESvZSW7C2t4sbBeCRVBQJx4ftc/99Vie02CcCriGp8A?=
 =?us-ascii?Q?PGCk3m2iRcFqTPwDP370EHJ5fchkpjfs2Lah+VaWe9BvppsKuPG/usU0pB/J?=
 =?us-ascii?Q?/1sbuc2vaYZLz0lpjzwkM4lIJWjkJqKoCoczS3Ay6i7LJIpIIiVNkgYhupIO?=
 =?us-ascii?Q?44C/FibvRwPXZnmJqXHWbcfxkf+LplWK7L6MjCGUZWXbTsDkXHWwyVjU2Vms?=
 =?us-ascii?Q?gqd6isQ0hz5zSvOXZiR+jNdkZRJ6LjEroLX40MJiZW6yInLjB7lPY5EsQoxa?=
 =?us-ascii?Q?yWwGDAB3Og3K8iMqCapm3Vz98+lZB7F1sjwX7ZiNeg1tIzoZqqecKMByJ7E+?=
 =?us-ascii?Q?eEecWSA8jKonjIQT9A7cbeBjrKMvn5KF2kz73UWXu2PhLYXqy1PUc5ZF+tYa?=
 =?us-ascii?Q?izb9yk3ZE99J9QX2z5e5i6e/v5dIJNCFSqmhnBxf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07741608-04dc-47b7-11c2-08db4cc5d0c9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 17:34:30.1527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWW3kYS6DqVxssorexDGXm1T0Kz4MhXNt5VpYusw4rPYRk1EPMf3BhuOBzrgarKf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9186
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 21, 2023 at 06:06:39PM -0700, Brett Creeley wrote:

> +static struct pds_vfio_lm_file *
> +pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
> +{
> +	struct pds_vfio_lm_file *lm_file = NULL;
> +	unsigned long long npages;
> +	struct page **pages;
> +	int err = 0;
> +
> +	if (!size)
> +		return NULL;
> +
> +	/* Alloc file structure */
> +	lm_file = kzalloc(sizeof(*lm_file), GFP_KERNEL);
> +	if (!lm_file)
> +		return NULL;
> +
> +	/* Create file */
> +	lm_file->filep = anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
> +	if (!lm_file->filep)
> +		goto err_get_file;
> +
> +	stream_open(lm_file->filep->f_inode, lm_file->filep);
> +	mutex_init(&lm_file->lock);
> +
> +	lm_file->size = size;
> +
> +	/* Allocate memory for file pages */
> +	npages = DIV_ROUND_UP_ULL(lm_file->size, PAGE_SIZE);
> +
> +	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
> +	if (!pages)
> +		goto err_alloc_pages;
> +
> +	for (unsigned long long i = 0; i < npages; i++) {
> +		pages[i] = alloc_page(GFP_KERNEL);
> +		if (!pages[i])
> +			goto err_alloc_page;
> +	}
> +
> +	lm_file->pages = pages;
> +	lm_file->npages = npages;
> +	lm_file->alloc_size = npages * PAGE_SIZE;
> +
> +	/* Create scatterlist of file pages to use for DMA mapping later */
> +	err = sg_alloc_table_from_pages(&lm_file->sg_table, pages, npages,
> +					0, size, GFP_KERNEL);
> +	if (err)
> +		goto err_alloc_sg_table;
> +
> +	/* prevent file from being released before we are done with it */
> +	get_file(lm_file->filep);
> +
> +	return lm_file;
> +
> +err_alloc_sg_table:
> +err_alloc_page:

What is with these double error out labels? I see it in a few places,
that is not the kernel style.

In VFIO we have been trying to label the err outs based on what they
free, it is not a 'call from' scheme.

Jason

