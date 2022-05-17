Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868A252A64E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350023AbiEQPYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349978AbiEQPYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:24:15 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7931D4F9D8
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:24:11 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id n8so14768610qke.11
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4EJhDBCqGLbtRfbe/sdWJLeO5Wj89HY9Nca+UOPcC6I=;
        b=YtXPznHZR0ce08YHVBoFQkCXb4v5yYnsZ6guPZM+HWAL/bYpd1nhq66Li8Q25Npqmv
         +EeGuLarTOHGVnZLOR8Lu3Aj6I7MMGZGeHu1DbdjZ+N8Oj0utMqQfE0spZ/VdoLXalay
         1KUsWAzem5k+z5LnUSUhgtYESxbCKiUcitmf8sscAj4lIH5UpGyMBJsnyZxBU6mVS9Bq
         HjoHqJ+uvgq4x4o2dt/9UJxN24Qfqz1El+MppkyVxlsinH7HoPYvrtu5mA4vUjGAy1nJ
         G+/NgeQFxyTx7qhgkf91wCobgPbM84UpmnOqMEEPdb4pKOkXsTGnOTW5iO4vC/piqqWA
         HI8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4EJhDBCqGLbtRfbe/sdWJLeO5Wj89HY9Nca+UOPcC6I=;
        b=XsBz/YZFspE9fasmN/f/kzJFpdT+qIRdeVm+YDDyWCNmj+WUzASwC+PjHi3p5A2eBw
         qAfAslglHPlOmHNj8iAtm2cb8dnx881ze/HUtywaepeNBr20m6jhc60wLoTtu7SJuDOu
         hA3ElKfOWGcFFGGMFkgpAl0Ol9ac6HmU3+WPjYTIzyDhbwYEcJVbufC/Ir94pMwo66On
         O5SYwUuSlYZFfoXsXstvQtoMi+VQHXkq5dp5ky0gGbVXBFlvdhV77Id+rZEWoa8Ihxyg
         BllQHHaHvG2PygSeU2liRxI3+DIDa8kXp3weW3sb9LYgxNsquw37d6zhARJ6z4oG1Xxo
         LT2g==
X-Gm-Message-State: AOAM533hMcfRJWGhXumyyvonHYjil/dNxt/vvTNtRZB3piqmn98p0uN8
        /w1bC8EUCItPi1GwQ6eeMe4D6g==
X-Google-Smtp-Source: ABdhPJwbKLgJdkaXGWnSvCJaKKdV+IU+llJ5yRpqS5rF4Fx6MKngQDVZuppJH7zoE9/L/F+4f4kMBg==
X-Received: by 2002:a05:620a:2489:b0:6a0:4c78:1463 with SMTP id i9-20020a05620a248900b006a04c781463mr16605563qkn.306.1652801050497;
        Tue, 17 May 2022 08:24:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id h4-20020a37b704000000b006a2f129425asm3790870qkf.130.2022.05.17.08.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 08:24:10 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nqz3R-0084xU-1r; Tue, 17 May 2022 12:24:09 -0300
Date:   Tue, 17 May 2022 12:24:09 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <20220517152409.GJ63055@ziepe.ca>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 02:04:36AM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> Add a RDMA VF driver for Microsoft Azure Network Adapter (MANA).

To set exepecation, we are currently rc7, so this will not make this
merge window. You will need to repost on the next rc1 in three weeks.


> new file mode 100644
> index 000000000000..0eac77c97658
> --- /dev/null
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "mana_ib.h"
> +
> +int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
> +		struct ib_udata *udata)
> +{
> +	struct mana_ib_create_cq ucmd = {};
> +	struct ib_device *ibdev = ibcq->device;
> +	struct mana_ib_dev *mdev =
> +		container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
> +	int err;

We do try to follow the netdev formatting, christmas trees and all that.

> +
> +	err = ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen));

Skeptical this min is correct, many other drivers get this wrong.

> +	if (err) {
> +		pr_err("Failed to copy from udata for create cq, %d\n", err);

Do not use pr_* - you should use one of the dev specific varients
inside a device driver. In this case ibdev_dbg

Also, do not ever print to the console on a user triggerable event
such as this. _dbg would be OK.

Scrub the driver for all occurances.

> +	pr_debug("ucmd buf_addr 0x%llx\n", ucmd.buf_addr);

I'm not keen on left over debugging please, in fact there are way too
many prints..

> +	cq->umem = ib_umem_get(ibdev, ucmd.buf_addr,
> +			       cq->cqe * COMP_ENTRY_SIZE,
> +			       IB_ACCESS_LOCAL_WRITE);

Please touch the file with clang-format and take all the things that
look good to you

> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
> new file mode 100644
> index 000000000000..e288495e3ede
> --- /dev/null
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -0,0 +1,679 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "mana_ib.h"
> +
> +MODULE_DESCRIPTION("Microsoft Azure Network Adapter IB driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> +
> +static const struct auxiliary_device_id mana_id_table[] = {
> +	{ .name = "mana.rdma", },
> +	{},
> +};

stylistically this stuff is usually at the bottom of the file, right
before its first use

> +static inline enum atb_page_size mana_ib_get_atb_page_size(u64 page_sz)
> +{
> +	int pos = 0;
> +
> +	page_sz = (page_sz >> 12); //start with 4k
> +
> +	while (page_sz) {
> +		pos++;
> +		page_sz = (page_sz >> 1);
> +	}
> +	return (enum atb_page_size)(pos - 1);
> +}

Isn't this ffs, log, or something that isn't a while loop?

> +static int _mana_ib_gd_create_dma_region(struct mana_ib_dev *dev,
> +					 const dma_addr_t *page_addr_array,
> +					 size_t num_pages_total,
> +					 u64 address, u64 length,
> +					 mana_handle_t *gdma_region,
> +					 u64 page_sz)
> +{
> +	struct gdma_dev *mdev = dev->gdma_dev;
> +	struct gdma_context *gc = mdev->gdma_context;
> +	struct hw_channel_context *hwc = gc->hwc.driver_data;
> +	size_t num_pages_cur, num_pages_to_handle;
> +	unsigned int create_req_msg_size;
> +	unsigned int i;
> +	struct gdma_dma_region_add_pages_req *add_req = NULL;
> +	int err;
> +
> +	struct gdma_create_dma_region_req *create_req;
> +	struct gdma_create_dma_region_resp create_resp = {};
> +
> +	size_t max_pgs_create_cmd = (hwc->max_req_msg_size -
> +				     sizeof(*create_req)) / sizeof(u64);

These extra blank lines are not kernel style, please check everything.

> +	num_pages_to_handle = min_t(size_t, num_pages_total,
> +				    max_pgs_create_cmd);
> +	create_req_msg_size = struct_size(create_req, page_addr_list,
> +					  num_pages_to_handle);
> +
> +	create_req = kzalloc(create_req_msg_size, GFP_KERNEL);
> +	if (!create_req)
> +		return -ENOMEM;
> +
> +	mana_gd_init_req_hdr(&create_req->hdr, GDMA_CREATE_DMA_REGION,
> +			     create_req_msg_size, sizeof(create_resp));
> +
> +	create_req->length = length;
> +	create_req->offset_in_page = address & (page_sz - 1);
> +	create_req->gdma_page_type = mana_ib_get_atb_page_size(page_sz);
> +	create_req->page_count = num_pages_total;
> +	create_req->page_addr_list_len = num_pages_to_handle;
> +
> +	pr_debug("size_dma_region %llu num_pages_total %lu, "
> +		 "page_sz 0x%llx offset_in_page %u\n",
> +		length, num_pages_total, page_sz, create_req->offset_in_page);
> +
> +	pr_debug("num_pages_to_handle %lu, gdma_page_type %u",
> +		 num_pages_to_handle, create_req->gdma_page_type);
> +
> +	for (i = 0; i < num_pages_to_handle; ++i) {
> +		dma_addr_t cur_addr = page_addr_array[i];
> +
> +		create_req->page_addr_list[i] = cur_addr;
> +
> +		pr_debug("page num %u cur_addr 0x%llx\n", i, cur_addr);
> +	}

Er, so we allocated memory and wrote the DMA addresses now you copy
them to another memory?

> +
> +	err = mana_gd_send_request(gc, create_req_msg_size, create_req,
> +				   sizeof(create_resp), &create_resp);
> +	kfree(create_req);
> +
> +	if (err || create_resp.hdr.status) {
> +		dev_err(gc->dev, "Failed to create DMA region: %d, 0x%x\n",
> +			err, create_resp.hdr.status);
> +		goto error;
> +	}
> +
> +	*gdma_region = create_resp.dma_region_handle;
> +	pr_debug("Created DMA region with handle 0x%llx\n", *gdma_region);
> +
> +	num_pages_cur = num_pages_to_handle;
> +
> +	if (num_pages_cur < num_pages_total) {
> +
> +		unsigned int add_req_msg_size;
> +		size_t max_pgs_add_cmd = (hwc->max_req_msg_size -
> +					  sizeof(*add_req)) / sizeof(u64);
> +
> +		num_pages_to_handle = min_t(size_t,
> +					    num_pages_total - num_pages_cur,
> +					    max_pgs_add_cmd);
> +
> +		// Calculate the max num of pages that will be handled
> +		add_req_msg_size = struct_size(add_req, page_addr_list,
> +					       num_pages_to_handle);
> +
> +		add_req = kmalloc(add_req_msg_size, GFP_KERNEL);
> +		if (!add_req) {
> +			err = -ENOMEM;
> +			goto error;
> +		}
> +
> +		while (num_pages_cur < num_pages_total) {
> +			struct gdma_general_resp add_resp = {};
> +			u32 expected_status;
> +			int expected_ret;
> +
> +			if (num_pages_cur + num_pages_to_handle <
> +					num_pages_total) {
> +				// This value means that more pages are needed
> +				expected_status = GDMA_STATUS_MORE_ENTRIES;
> +				expected_ret = 0x0;
> +			} else {
> +				expected_status = 0x0;
> +				expected_ret = 0x0;
> +			}
> +
> +			memset(add_req, 0, add_req_msg_size);
> +
> +			mana_gd_init_req_hdr(&add_req->hdr,
> +					     GDMA_DMA_REGION_ADD_PAGES,
> +					     add_req_msg_size,
> +					     sizeof(add_resp));
> +			add_req->dma_region_handle = *gdma_region;
> +			add_req->page_addr_list_len = num_pages_to_handle;
> +
> +			for (i = 0; i < num_pages_to_handle; ++i) {
> +				dma_addr_t cur_addr =
> +					page_addr_array[num_pages_cur + i];

And then again?

That isn't how this is supposed to work, you should iterate over the
umem in one pass and split up the output as you go. Allocating
potentially giant temporary arrays should be avoided.


> +				add_req->page_addr_list[i] = cur_addr;
> +
> +				pr_debug("page_addr_list %lu addr 0x%llx\n",
> +					 num_pages_cur + i, cur_addr);
> +			}
> +
> +			err = mana_gd_send_request(gc, add_req_msg_size,
> +						   add_req, sizeof(add_resp),
> +						   &add_resp);
> +			if (err != expected_ret ||
> +			    add_resp.hdr.status != expected_status) {
> +				dev_err(gc->dev,
> +					"Failed to put DMA pages %u: %d,0x%x\n",
> +					i, err, add_resp.hdr.status);
> +				err = -EPROTO;
> +				goto free_req;
> +			}
> +
> +			num_pages_cur += num_pages_to_handle;
> +			num_pages_to_handle = min_t(size_t,
> +						    num_pages_total -
> +							num_pages_cur,
> +						    max_pgs_add_cmd);
> +			add_req_msg_size = sizeof(*add_req) +
> +				num_pages_to_handle * sizeof(u64);
> +		}
> +free_req:
> +		kfree(add_req);
> +	}
> +
> +error:
> +	return err;
> +}
> +
> +
> +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
> +				 mana_handle_t *dma_region_handle, u64 page_sz)

Since this takes in a umem it should also compute the page_sz for that
umem.

I see this driver seems to have various limitations, so the input
argument here should be the pgsz bitmask that is compatible with the
object being created.

> +{
> +	size_t num_pages = ib_umem_num_dma_blocks(umem, page_sz);
> +	struct ib_block_iter biter;
> +	dma_addr_t *page_addr_array;
> +	unsigned int i = 0;
> +	int err;
> +
> +	pr_debug("num pages %lu umem->address 0x%lx\n",
> +		 num_pages, umem->address);
> +
> +	page_addr_array = kmalloc_array(num_pages,
> +					sizeof(*page_addr_array), GFP_KERNEL);
> +	if (!page_addr_array)
> +		return -ENOMEM;

This will OOM easily, num_pages is user controlled.

> +
> +	rdma_umem_for_each_dma_block(umem, &biter, page_sz)
> +		page_addr_array[i++] = rdma_block_iter_dma_address(&biter);
> +
> +	err = _mana_ib_gd_create_dma_region(dev, page_addr_array, num_pages,
> +					    umem->address, umem->length,
> +					    dma_region_handle, page_sz);
> +
> +	kfree(page_addr_array);
> +
> +	return err;
> +}
> +int mana_ib_gd_create_pd(struct mana_ib_dev *dev, u64 *pd_handle, u32 *pd_id,
> +			 enum gdma_pd_flags flags)
> +{
> +	struct gdma_dev *mdev = dev->gdma_dev;
> +	struct gdma_context *gc = mdev->gdma_context;
> +	int err;
> +
> +	struct gdma_create_pd_req req = {};
> +	struct gdma_create_pd_resp resp = {};
> +
> +	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_PD,
> +			     sizeof(req), sizeof(resp));
> +
> +	req.flags = flags;
> +	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +
> +	if (!err && !resp.hdr.status) {
> +		*pd_handle = resp.pd_handle;
> +		*pd_id = resp.pd_id;
> +		pr_debug("pd_handle 0x%llx pd_id %d\n", *pd_handle, *pd_id);

Kernel style is 'success oriented flow':

 if (err) {
    return err;
 }
 // success
 return 0;

Audit everything

> +static int mana_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
> +{
> +	struct mana_ib_ucontext *mana_ucontext =
> +		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
> +	struct ib_device *ibdev = ibcontext->device;
> +	struct mana_ib_dev *mdev =
> +		container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	struct gdma_context *gc = mdev->gdma_dev->gdma_context;
> +	pgprot_t prot;
> +	phys_addr_t pfn;
> +	int ret;

This needs to validate vma->pgoff

> +	// map to the page indexed by ucontext->doorbell

Not kernel style, be sure to run checkpatch and fix the egregious things.

> +static void mana_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
> +{
> +}

Does this driver actually support disassociate? Don't define this
function if it doesn't.

I didn't see any mmap zapping so I guess it doesn't.

> +static const struct ib_device_ops mana_ib_dev_ops = {
> +	.owner = THIS_MODULE,
> +	.driver_id = RDMA_DRIVER_MANA,
> +	.uverbs_abi_ver = MANA_IB_UVERBS_ABI_VERSION,
> +
> +	.alloc_pd = mana_ib_alloc_pd,
> +	.dealloc_pd = mana_ib_dealloc_pd,
> +
> +	.alloc_ucontext = mana_ib_alloc_ucontext,
> +	.dealloc_ucontext = mana_ib_dealloc_ucontext,
> +
> +	.create_cq = mana_ib_create_cq,
> +	.destroy_cq = mana_ib_destroy_cq,
> +
> +	.create_qp = mana_ib_create_qp,
> +	.modify_qp = mana_ib_modify_qp,
> +	.destroy_qp = mana_ib_destroy_qp,
> +
> +	.disassociate_ucontext = mana_ib_disassociate_ucontext,
> +
> +	.mmap = mana_ib_mmap,
> +
> +	.reg_user_mr = mana_ib_reg_user_mr,
> +	.dereg_mr = mana_ib_dereg_mr,
> +
> +	.create_wq = mana_ib_create_wq,
> +	.modify_wq = mana_ib_modify_wq,
> +	.destroy_wq = mana_ib_destroy_wq,
> +
> +	.create_rwq_ind_table = mana_ib_create_rwq_ind_table,
> +	.destroy_rwq_ind_table = mana_ib_destroy_rwq_ind_table,
> +
> +	.get_port_immutable = mana_ib_get_port_immutable,
> +	.query_device = mana_ib_query_device,
> +	.query_port = mana_ib_query_port,
> +	.query_gid = mana_ib_query_gid,

Usually drivers are just sorting this list

> +#define PAGE_SZ_BM (SZ_4K | SZ_8K | SZ_16K | SZ_32K | SZ_64K | SZ_128K \
> +		    | SZ_256K | SZ_512K | SZ_1M | SZ_2M)
> +
> +// Maximum size of a memory registration is 1G bytes
> +#define MANA_IB_MAX_MR_SIZE	(1024 * 1024 * 1024)

Even with large pages? Weird limit..

You also need to open a PR to the rdma-core github with the userspace for
this and pyverbs test suite support

Thanks,
Jason
