Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC15C6E23A6
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjDNMwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjDNMwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:52:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063DA59FF;
        Fri, 14 Apr 2023 05:52:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pdq4wYvi8p2Hjn01hwBw5yI6HnT6VkdeDVlvrQK9TTX90scvXL3Z/BCa/3ZJfqGFrgHV8cZA0p+Ws2TrHl/egJcEArvrXIkQNhKpR4SfzTAjauzo2HiWkC1aWI6dIe4JVBAXUJad328AJtqqoAQ4LbechBSHxsrTapROufTnxZ9yqfpnl/TrPnGmE06IJWUwAFb2keZlIGnk4FZd0TKy85MT5BjP38YJVj8ZxYtya99Bqid6loWZenSHlQv4XpAf6jD0yqDCyp+SLCAaPTjpTNpbmqBfJOejxGimgK9YVp10cdNeJuxGOsqsb3t2zvE1S4Qic21fPLzw8MxI2xHDgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzhW6GUTPZnEJ2JZ79IWVuyMocLnmIhd2HLn2wifdSY=;
 b=Kb1/xdaRO0Bz/kfRnGy2NwTDHwCCGT4ykam1EDsPxYw1Y3G7mFiw43hOoMWqtNw5iqrPjS+MzcuE3xe2z7xn0Mt8dK8wXNa1YCK1OaBMDSzeFbjOqZRg8a0ar3R/Uios2rWHbXtC9PMkUrK5s3uT9uxLqQTOkPRvHMe/39C2YaWtgi8jF4SWjkQoFQF3S9D7lKyxevZ/xBVeeqTUhhgJIhWB4A4lEmE4mNwKpEl2Z3lgyDNQdJrl4dYDOIex7YFiX4A+4sgxlx4wea3bFSWFPItGa4bbZqkZDboq7w830+X5WSxOhxqa+zYm4/+ouQuxI9459rx8T3jrzZWLYHbstw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzhW6GUTPZnEJ2JZ79IWVuyMocLnmIhd2HLn2wifdSY=;
 b=Qol3fKqzVLbKzR5+VNTKrgRDAdkSzCUQC+N9nR58yeeu5J82gcImlD6ardR0zB96/8Y3sML3XaU72YqGUWgiBvSyFH9LLL8lMYmOIpKNzPVl/H6otR32JQ7Tk10ois85rjeWNBAa8ZTXam28v7luqj8Ezu9/hXOxvNMegvhd4tGaMaL4iPucWU2Q8mUL6ZOrVkL5DJU5b9OsJSpEGFyrTzcJkOdciAhp8dObAMN/h/h5/6qMT43Ef+QDmxgHtiRtq+RAB+YfxYoVhxxzhuzLWQjdYLuCgZZPKsxsjhpLG463daeJbTHA2o0DJxWkBSxQ4x/aAK4uWLFy5sN09j4cZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5184.namprd12.prod.outlook.com (2603:10b6:5:397::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 12:52:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 12:52:34 +0000
Date:   Fri, 14 Apr 2023 09:52:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
Subject: Re: [PATCH v8 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZDlMj2FoZrmrboaC@nvidia.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-5-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404190141.57762-5-brett.creeley@amd.com>
X-ClientProxiedBy: BYAPR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:a03:40::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 7576a1d9-e9cf-49f4-ef84-08db3ce71dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RR2/ybM7ZcXHlbDyRv0Wy8h8xkhr2cagjdIyC22g52Van/qNjo0FY6Fv+CkZNbuk3+WWWpI+E+e4NAX77BrKyCB8apOgqMqhH3ji2nBczeCFQ0a0PFPvXcHnWJcGbmVgNxYYLqNbYrh7B9/XEQ8EZir7Mg4Ol7a9Jyq+EUvNqSob5pPQDAGtbN0zGVszQv50RNRcsqf7FjhUTEr+Yvhau42LbAYX8e4cco/5HnTkyDwEQ08wLKdDmLgR1TEYmqop4Bbn6/tgzlG0ZqNmOwn7WQ+BXIUIMh7LWF3UmHw0EFynuP6syHXRqDVmu9hCIEKglspZV+fbHi7j5g6NdsnFq67HA7+bt1QAF0ysamfLbLcqUJkToDjPUfnzIgEk1cq64ERFzaetXY0XolJD86ZkjpP96D25EhOLkprAyvHGvqvbE+20xV61gUMAONMSI79kFNt4sDL5P7Iys1t/uRVWlwoeO2h1wLSnNe+P982BjdXHDGXWU2ZWBIFNOzIRjbpX94HCCtNFj8hwwjwZdWSWIv02e2Y+TFy5Gi7ZUVSQchLNFz2PNr0icvZJlv+MHi2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199021)(478600001)(36756003)(5660300002)(8676002)(8936002)(38100700002)(66476007)(66946007)(66556008)(2906002)(41300700001)(4326008)(6916009)(26005)(6512007)(316002)(6506007)(86362001)(186003)(2616005)(83380400001)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zplhVol8kUVGgjeOlhH2tzLZomDaPNeN0GK41eF/4r1fkHlPUFvzGOEjN+Lh?=
 =?us-ascii?Q?eS56LrKn8LYBXBSAohNjKaA4FoQncfv+iguLHmo+Z3kz5RxsQGK6bdWyRsT7?=
 =?us-ascii?Q?UJHulVGCMdsZJostI7r7YKNDONgojjXWm4pJTvkzPYPuBI0AQMTdMWQvQStv?=
 =?us-ascii?Q?AZWSDI9Ojqu1j16ZSPzzAkO17oHyhlSg/6xEFk3kUwWlS/vvCZWSHiSbbPE9?=
 =?us-ascii?Q?IOUEVgBnlUTthJOaK7dQokFkiOGlckL8KRlk4XRbu2NUuaKJ5z3pnXprPMl2?=
 =?us-ascii?Q?rIDgmqf/BqYnwr+ibntFh5Ut+9ME8ipOZVdTZ+Oct3rzHeA0Faq6SwZIpd5K?=
 =?us-ascii?Q?0IOeIrnFZmhkJkQ4vPGxw2AhSgGL81Z/IlwhiNt4rqZ041byEyL41/Fr507z?=
 =?us-ascii?Q?HxLMLOytaOn8Qxo0BAjvFRa7xojZ1c6SbH05AslwPsHzT0zZRDUEK+Rvu03c?=
 =?us-ascii?Q?JqLeegCZCtXL2tqXbAInIk+Mv/82UUqakOv+030k6rrAz6GCIAhfU8uA0FRF?=
 =?us-ascii?Q?++6Z57ZhE6g2BvxszB18od5LVxSRehf/YPwg+UBg+J9BJoGs8aa9ub0EbgJs?=
 =?us-ascii?Q?w6fKXdHxAGtdAo2UKYQlcP0B1CmMPRZYxoOVSl33W2HOywPuXzta8IaSY+Kk?=
 =?us-ascii?Q?2Rjq1F7g+yuY+QIgpLPp69ESr1LbihUr5dAGrQ1ic1Wh5X2zzJevWYsgbQkZ?=
 =?us-ascii?Q?g6nZZdB/1X5CRDlRyr7dOIAVN5owxHxG2XNCc3ZBldL9CRhoQnn9DT4GfUKM?=
 =?us-ascii?Q?S/TlftoOj/Y2s7Sr5LIBG6UXg6aPYsKEgrOVps7ScJw9Z7Yrk6EZavvZAWGz?=
 =?us-ascii?Q?M+b7Soq4VGgFD3gjr4yBq8MJgZbh98mRra0pGHCwEsyHL5Iqgr/FkzRoh4VD?=
 =?us-ascii?Q?KUkigWJDSdpm/zJlH5RrO0dFgXfU+M08mnPv9IuURKIPFpsYCBao+Dms64bJ?=
 =?us-ascii?Q?ZmDaDb3WcJMxQyg3uhgk5JOehq+lE+2RKQLZ6x7ueMb4JZoJVHCKoicW9VT4?=
 =?us-ascii?Q?Ari/lZagiZESUUjCVeEu/z8FLw5ys3VRlmCC3MAkh8VkxBHKyhT8zRuqRNmg?=
 =?us-ascii?Q?n+VgcGeaEn5AkGavJySAzjeoc7vZZSHVZwiBhBuGtZXUw+Jou6y3SN5Vr/NB?=
 =?us-ascii?Q?MC3NmZ7g84qjbFHKMs1SwR3VdSfJMsxf6147OGRwwpNtqhq6ZjAkOJzyq3bQ?=
 =?us-ascii?Q?wMOurs1MS5B/rMrIC9syMy8i1bvwnW76OYtI0uipU4E8gOJc3w1fpY8DFfQC?=
 =?us-ascii?Q?yOLhmR86kQHffLhU66n2yNeU9rIenYlxHworY/c83b1KOdJ+ISAYlyj6AsVW?=
 =?us-ascii?Q?iAwvLc8xCtaMkKP5rsZsVeP2IKA4Rlx1YhQXV40sPEp/5/jz9HdlbZPUSw0c?=
 =?us-ascii?Q?EAieNkrIozjq6ZAlBooP6+8qoRk5thx3Nf/EQvFgI6UlFw7boOWZTyFYj3eb?=
 =?us-ascii?Q?IURuC+gJm5GijXSdGMYJ7RPhZlE+hTtSvC+J8pO7zCkm/P8nYi7tmUjo8gc2?=
 =?us-ascii?Q?+CyD9QJlUugXiaywMYy3yBRON6FNMxi1XC4Ys1xk+rfCKfqeoU103dG1PCgb?=
 =?us-ascii?Q?sQUmn5T0NuLWqJKp0gfGMn7IHH1aOnZbkweOBRv2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7576a1d9-e9cf-49f4-ef84-08db3ce71dc8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 12:52:33.9529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Aa/tAUlQtmcgVwwywDLIV+zZ7j70OEnZU08HU+8qL9YRDj9VKV6KzQQ/BVX+hMz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5184
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:01:38PM -0700, Brett Creeley wrote:
> +	union pds_core_adminq_cmd cmd = { 0 };

These should all be = {}, adding the 0 is a subtly different thing in

> +int
> +pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct pds_lm_suspend_cmd cmd = {
> +		.opcode = PDS_LM_CMD_SUSPEND,
> +		.vf_id = cpu_to_le16(pds_vfio->vf_id),
> +	};
> +	struct pds_lm_suspend_comp comp = {0};
> +	struct pci_dev *pdev = pds_vfio->pdev;
> +	int err;
> +
> +	dev_dbg(&pdev->dev, "vf%u: Suspend device\n", pds_vfio->vf_id);
> +
> +	err = pds_client_adminq_cmd(pds_vfio,
> +				    (union pds_core_adminq_cmd *)&cmd,
> +				    sizeof(cmd),
> +				    (union pds_core_adminq_comp *)&comp,
> +				    PDS_AQ_FLAG_FASTPOLL);

These casts to a union are really weird, why isn't the union the type
on the stack?

Jason

> +static int
> +pds_vfio_dma_map_lm_file(struct device *dev, enum dma_data_direction dir,
> +			 struct pds_vfio_lm_file *lm_file)
> +{
> +	struct pds_lm_sg_elem *sgl, *sge;
> +	struct scatterlist *sg;
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
> +	sgl = dma_alloc_coherent(dev, lm_file->num_sge *
> +				 sizeof(struct pds_lm_sg_elem),
> +				 &lm_file->sgl_addr, GFP_KERNEL);

Do you really need a coherent allocation for this?

> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> new file mode 100644
> index 000000000000..855f5da9b99a
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -0,0 +1,479 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/highmem.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#include "vfio_dev.h"
> +#include "cmds.h"
> +
> +#define PDS_VFIO_LM_FILENAME	"pds_vfio_lm"

This doesn't need a define, it is typical to write the pseudo filename
in the only anon_inode_getfile()

> +static struct pds_vfio_lm_file *
> +pds_vfio_get_lm_file(const char *name, const struct file_operations *fops,
> +		     int flags, u64 size)
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
> +	lm_file->filep = anon_inode_getfile(name, fops, lm_file, flags);
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

This is the same basic thing the mlx5 driver does, you should move the
mlx5 code into some common place and just re-use it here.

> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
> index 10557e8dc829..3f55861ffc7c 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.h
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -7,10 +7,20 @@
>  #include <linux/pci.h>
>  #include <linux/vfio_pci_core.h>
>  
> +#include "lm.h"
> +
>  struct pds_vfio_pci_device {
>  	struct vfio_pci_core_device vfio_coredev;
>  	struct pci_dev *pdev;
>  	void *pdsc;
> +	struct device *coredev;

Why? If this is just &pdev->dev it it doesn't need to be in the struct

And pdev is just vfio_coredev->pdev, don't need to duplicate it either

Jason
