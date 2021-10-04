Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A914215E4
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhJDSD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:03:27 -0400
Received: from mail-mw2nam10on2076.outbound.protection.outlook.com ([40.107.94.76]:33528
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236245AbhJDSDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:03:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOJldX/Ueu3VrsK/mejUqDVVgYf136VI77rkiFhslKXXqrS17aZDfAmD7IWhhxYFS4I0BqaYt5PMvRaRmsj47VL1jW90mW8kKZqxL+jlE6qEhaBYpifUPz7K+OULqGYFyBvzoCttwypLpLdGNYBuUbvfExb5wcIusN95yBUpMsuCzy1YyBR/1AbkMinri5Tu3qv6ytOigKnftwMu9cXOINuAaFKbMRJ0Sa+Q5fYlHVWweDon+BMdwL3GbcBQhikOO5prEblSY7vaaMvL1p768zjf3Z3YP6KcQLtw/8UYiKEkFxfmFc2Um1MKZ5/wK1CxFxpJB3oOFKAX6vgw0OI/sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrVIgMeRqo8Xz7TZ1dnpmR+oO/83yqtRgyIaLlC75w0=;
 b=ZCIYogMRs93tLUr3JFxf4+KAZ0VK47pRNC2YqC8gCIUbw87V+06UKIc3ZkoMpQeiiKUPjdPqLZs0ULcujdvpTnbKfycJjgkm4rwLDjV+1p3JSFhKjgUbpSa+THY8dlUFcnAftuvZFX47S2mDfAkmLF3vutp2HMNU6TJoCX+k2G+yzI9gizbGQnaXzJWkre45Zg0ePhcO3Vmv9qXKg/pUeL9O789gzIQTKPmHWtZR5udqZ524J76PUAf8aGV/7RuqBuh4wWjYyqUv7Ku/PAVAMiGjCaVxb1II+AQ5gsH8lhvm3mbnR++IHM/A2AYS4CZshxSLDsuWHv70LQmsV7JMqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrVIgMeRqo8Xz7TZ1dnpmR+oO/83yqtRgyIaLlC75w0=;
 b=gi1RcuL8Hk7gzUvI2wyHpBxAVfdtGk9W6EnaoQ3Kcou2VCDWwNTWwmCp+G0lsT7yKGaELLw7USkLDRs3UCRLe/ycOHSzSc6NtlHC4LdsjRDsODBxiC3nN1ld5LmZNH6fGoRqfJbuAHY4V4aUcLV/N42qEOUzm2zI/Y3Ryq+J76KAECfNUwVmUh1R69+2WXULaYdk3LG9hRCPQV+k0eXNAZNTzoqaMMPMkaXPFe4EWD3ZALZVBbPbH5IfuCz46daJX65FK1uuE3MHWFEcN2e7xHBZFrkyr4/uDcOojEFaciWFMh2QztANfFdYqV3i7/2tPTlD4YygcrDaVH2njuyd+Q==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5507.namprd12.prod.outlook.com (2603:10b6:208:1c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Mon, 4 Oct
 2021 18:01:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 18:01:25 +0000
Date:   Mon, 4 Oct 2021 15:01:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v2 06/13] RDMA/counter: Add optional counter
 support
Message-ID: <20211004180124.GC2515663@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
 <f473f52f9ba462112df91866aa5cf08687008c58.1632988543.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f473f52f9ba462112df91866aa5cf08687008c58.1632988543.git.leonro@nvidia.com>
X-ClientProxiedBy: MN2PR15CA0007.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR15CA0007.namprd15.prod.outlook.com (2603:10b6:208:1b4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Mon, 4 Oct 2021 18:01:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXSHE-00AYYv-7U; Mon, 04 Oct 2021 15:01:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 797bc5db-f827-4ee9-8ee3-08d98760fb2d
X-MS-TrafficTypeDiagnostic: BL0PR12MB5507:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5507D43FC5BF3E3E47B5FA6DC2AE9@BL0PR12MB5507.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZpI3l1yXN9/McQqHbONTH+RIg05ZhYZAYf7+UK7EVlp5QjJbrcfpMK3P8XNGwnOJIRHLCGkY5ojaj8EGSoXaLz4ySSLbPXjeesCcZUB24pO6j2I9AtEm35bZy6bRdRfDEoXcF9LiEdFV1lbPhVKWiEHHcfxmr5zt7t3YcF87ijD2drC22ze6HI5AT/HZFj/jrluI8fTblfz05j1v0o/2c2DK+NxPnMTohQ+oJ3N91vBBhCvrV47ekBbmxx8/Q5ZTHZtdcx6Mzimv0UjsnZmgVYtMd/ioPIJpMRUvXz2DA73+I1dkeO/Y9IxxFESvFUYX4dwGUruA1vuYd1itRpM7Ic+YRbHPgySPmAsdzVcbQHiGF2nJQhm6tC/SfrASlugtp97oHtGsUgvINyI95QFNByrBfaVTXKrmCqaDb9blEDheXrTPl0QUA5PfpbuEsf29Z5Q6rJ6AVwDpCYAddVDIjLM2JzFGJ6kiTxbuvTlr/dlBZOPe1yBPB6odRuA0Tn2l1vja7CD2kb4TpT5sYmFs4/JSG8lG7zG9+n07lsJBThvC+td7rzV893rNxTFGESZWuQ8ZW7QcPn54VQZ4Kco7eOaEW4sTUfvGN2R7JxiZReZY26Ogk7MIhvOqH5IcoLZzRnh1Wxsna3QYUm4uegqjxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(186003)(2906002)(8936002)(26005)(6916009)(9786002)(9746002)(5660300002)(508600001)(66946007)(66556008)(1076003)(66476007)(4326008)(36756003)(86362001)(8676002)(83380400001)(54906003)(316002)(2616005)(7416002)(38100700002)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nb8B9Mgwddt+6NCK1fvOBvFh7Y1rYkUMLMOudioStp1mCZv0nO/CaoseEeY9?=
 =?us-ascii?Q?Fr/z5YSnVKU1VMFOS2FoGu/vpOmPH6ChKOk9zkrywhQE//dzFls9i/SKdn+X?=
 =?us-ascii?Q?MWYMs1a0zVIMhalRWz1zdqdUwWOeq3/21ZSCu1w9B62iHrglqxmArfr22jwG?=
 =?us-ascii?Q?+RZ6JglAnMHGh+5yV00g5jvq09UAM+NcbkGCO0OAhtN/CMsvZvlowwi7hNwh?=
 =?us-ascii?Q?HXKPqjtRcBFiI6eiBl8A4+ER/kZhK4heCqLwEfNIK7z6Xa8g9PtTjY4z4s5o?=
 =?us-ascii?Q?QK1wKK3OCgXNrICJb/752QpA0lWcOIZbiiIZfFpu3ZkVehUimbebEaTzeTXM?=
 =?us-ascii?Q?WrZapfeojIH2f01khVyeoAArLuqud0ca+PsoGAgn0RorHyNoEHQnB9HLBuv8?=
 =?us-ascii?Q?VkpKSfPD65YzeRi+xPL4QL0iNnVgYFjs2c4gnglw9T7DWOEaYyahy4xEppG0?=
 =?us-ascii?Q?HJw1gZU498U8T4o9FA6+mQr03sfVZ7DDBqorito7uCBI+jJqjh1UPhshlr3v?=
 =?us-ascii?Q?MOxALaLkccZ0/PpOw+7saNDgLb596DurlDfP5WEdrHiVLF/KOeGB6D0oabRh?=
 =?us-ascii?Q?qRCW0b7fyD/VLgZYaJNL9uFiQ4wqIel7p+7ZWekpDjGr9ZKPc0TsVBQ0qB4/?=
 =?us-ascii?Q?m1kvGcEBeu+H7EHiYITZJFphFe8t3wxGA/DNOQF9lH4H0mTzZjY9VpVFKREV?=
 =?us-ascii?Q?MYRAb2jyByipuWiUjZzOvgmhaYx7M0aHKMalg0VFfPkz12v729IH3o9+NFID?=
 =?us-ascii?Q?lq/JIsv/bpPKSb7swc+DdsHnfsrroqQYA3A7xMuk7JSEkPJtwhoXElt6g7Zw?=
 =?us-ascii?Q?5UxkPf3jk462MBZP+n0PiTcz2KQ19Zlp/OlRa0ubfeyCkGE0rmHBRdL2aNVi?=
 =?us-ascii?Q?Z1hNV5XBoh0rxGN9L+pZL/PMUWsOGrSqtPTaj4/7wi2QVETC0UUfoK1eOMb2?=
 =?us-ascii?Q?Xes4yuCUi6nWrCA9zjkPI7tXwUKPJjjydJmVe1Bpw//hT6BUS3fkVf+mpWIa?=
 =?us-ascii?Q?bF7y2siT9EjxCgIyu1Md/uEsJmf/tstc1bPQy9AOv/WWPjpYYYY/9H9jVxo1?=
 =?us-ascii?Q?gBBAfWTeHqgbImMF63MOBVTuMe4zeGFreCc9T+rUQjDhzqsMP1imxj7ufhrU?=
 =?us-ascii?Q?pS6Xjf7hhmKc1l56algmvslPNJFPgqW3AfFcxMR892wKtCPLjWwDBiISqRF1?=
 =?us-ascii?Q?R1zPqdil1hE3xkizHiR51tjFq+DKgdt4ljmfk9vo6ppkW21lSE4zvQFS1p8c?=
 =?us-ascii?Q?cOE9t5iAsKzg2jwqG13knbFvtwrt4dwajHhhmZkK1QdJdYZLI9+t2JXL6C9l?=
 =?us-ascii?Q?ISFFziWgkKpPJGk909xysh9ibYyITRkaPPH0mNg4E7fEKw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 797bc5db-f827-4ee9-8ee3-08d98760fb2d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 18:01:25.2533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ASMPCBCbXCcrfbutomHIubZcURSBfQWL0F8QPOqrT8LzKC9yZuEk8GKuNZ5jMShD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5507
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:02:22AM +0300, Leon Romanovsky wrote:
> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> index 331cd29f0d61..dac8f370ae3c 100644
> +++ b/drivers/infiniband/core/counters.c
> @@ -106,6 +106,36 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
>  	return ret;
>  }
>  
> +int rdma_counter_modify(struct ib_device *dev, u32 port,
> +			unsigned int index, bool enable)
> +{
> +	struct rdma_hw_stats *stats;
> +	int ret = 0;
> +
> +	if (!dev->ops.modify_hw_stat)
> +		return -EOPNOTSUPP;
> +
> +	stats = ib_get_hw_stats_port(dev, port);
> +	if (!stats || (index >= stats->num_counters) ||
> +	    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL))
> +		return -EINVAL;
> +
> +	mutex_lock(&stats->lock);
> +
> +	if (enable != test_bit(index, stats->is_disabled))
> +		goto out;
> +
> +	ret = dev->ops.modify_hw_stat(dev, port, index, enable);
> +	if (ret)
> +		goto out;
> +
> +	enable ? clear_bit(index, stats->is_disabled) :
> +		set_bit(index, stats->is_disabled);

This still needs to follow the kernel standard..

Jason
