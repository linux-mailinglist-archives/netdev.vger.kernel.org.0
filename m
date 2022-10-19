Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A0D603772
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 03:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJSBRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 21:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJSBRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 21:17:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3DBDFC12;
        Tue, 18 Oct 2022 18:17:10 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MsXrY47kCzHv60;
        Wed, 19 Oct 2022 09:17:01 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 09:17:08 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 09:17:07 +0800
Subject: Re: [Patch v7 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
To:     <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, <edumazet@google.com>,
        <shiraz.saleem@intel.com>, "Ajay Sharma" <sharmaajay@microsoft.com>
CC:     <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
 <1666034441-15424-13-git-send-email-longli@linuxonhyperv.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <8fccf9fc-d0e6-2321-e49c-d9fa028a2bdd@huawei.com>
Date:   Wed, 19 Oct 2022 09:17:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1666034441-15424-13-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/18 3:20, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> Add a RDMA VF driver for Microsoft Azure Network Adapter (MANA).
> 
> Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
> Change log:
> v2:
> Changed coding sytles/formats
> Checked undersize for udata length
> Changed all logging to use ibdev_xxx()
> Avoided page array copy when doing MR
> Sorted driver ops
> Fixed warnings reported by kernel test robot <lkp@intel.com>
> 
> v3:
> More coding sytle/format changes
> 
> v4:
> Process error on hardware vport configuration
> 
> v5:
> Change licenses to GPL-2.0-only
> Fix error handling in mana_ib_gd_create_dma_region()
> 
> v6:
> rebased to rdma-next
> removed redundant initialization to return value in mana_ib_probe()
> added missing tabs at the end of mana_ib_gd_create_dma_region()
> 
> v7:
> move mana_gd_destroy_doorbell_page() and mana_gd_allocate_doorbell_page() from GDMA to this driver
> use ib_umem_find_best_pgsz() for finding page size for registering dma regions with hardware
> fix a bug that may double free mana_ind_table in mana_ib_create_qp_rss()
> add Ajay Sharma <sharmaajay@microsoft.com> to maintainer list
> add details to description in drivers/infiniband/hw/mana/Kconfig
> change multiple lines comments to use RDMA style from NETDEV style
> change mana_ib_dev_ops to static
> use module_auxiliary_driver() in place of module_init and module_exit
> move all user-triggerable error messages to debug messages
> check for ind_tbl_size overflow in mana_ib_create_qp_rss()
> 
>  MAINTAINERS                             |   9 +
>  drivers/infiniband/Kconfig              |   1 +
>  drivers/infiniband/hw/Makefile          |   1 +
>  drivers/infiniband/hw/mana/Kconfig      |  10 +
>  drivers/infiniband/hw/mana/Makefile     |   4 +
>  drivers/infiniband/hw/mana/cq.c         |  79 ++++
>  drivers/infiniband/hw/mana/device.c     | 117 ++++++
>  drivers/infiniband/hw/mana/main.c       | 508 ++++++++++++++++++++++++
>  drivers/infiniband/hw/mana/mana_ib.h    | 156 ++++++++
>  drivers/infiniband/hw/mana/mr.c         | 200 ++++++++++
>  drivers/infiniband/hw/mana/qp.c         | 505 +++++++++++++++++++++++
>  drivers/infiniband/hw/mana/wq.c         | 115 ++++++
>  include/net/mana/mana.h                 |   3 +
>  include/uapi/rdma/ib_user_ioctl_verbs.h |   1 +
>  include/uapi/rdma/mana-abi.h            |  66 +++
>  15 files changed, 1775 insertions(+)
>  create mode 100644 drivers/infiniband/hw/mana/Kconfig
>  create mode 100644 drivers/infiniband/hw/mana/Makefile
>  create mode 100644 drivers/infiniband/hw/mana/cq.c
>  create mode 100644 drivers/infiniband/hw/mana/device.c
>  create mode 100644 drivers/infiniband/hw/mana/main.c
>  create mode 100644 drivers/infiniband/hw/mana/mana_ib.h
>  create mode 100644 drivers/infiniband/hw/mana/mr.c
>  create mode 100644 drivers/infiniband/hw/mana/qp.c
>  create mode 100644 drivers/infiniband/hw/mana/wq.c
>  create mode 100644 include/uapi/rdma/mana-abi.h
> 

[...]

> +
> +int mana_ib_cfg_vport(struct mana_ib_dev *dev, u32 port, struct mana_ib_pd *pd,
> +		      u32 doorbell_id)
> +{
> +	struct gdma_dev *mdev = dev->gdma_dev;
> +	struct mana_port_context *mpc;
> +	struct mana_context *mc;
> +	struct net_device *ndev;
> +	int err;
> +
> +	mc = mdev->driver_data;
> +	ndev = mc->ports[port];
> +	mpc = netdev_priv(ndev);
> +
> +	mutex_lock(&pd->vport_mutex);
> +
> +	pd->vport_use_count++;
> +	if (pd->vport_use_count > 1) {
> +		ibdev_dbg(&dev->ib_dev,
> +			  "Skip as this PD is already configured vport\n");
> +		mutex_unlock(&pd->vport_mutex);
> +		return 0;
> +	}
> +	mutex_unlock(&pd->vport_mutex);
> +
> +	err = mana_cfg_vport(mpc, pd->pdn, doorbell_id);
> +	if (err) {
> +		mutex_lock(&pd->vport_mutex);
> +		pd->vport_use_count--;
> +		mutex_unlock(&pd->vport_mutex);

It seems there might be a race between the "pd->vport_use_count > 1"
checking above and the error handling here, it may cause other user using a
unconfigured vport if other user is checking the "pd->vport_use_count > 1)"
while mana_cfg_vport() fails before doing "pd->vport_use_count--".

> +
> +		ibdev_dbg(&dev->ib_dev, "Failed to configure vPort %d\n", err);
> +		return err;
> +	}
> +
> +	pd->tx_shortform_allowed = mpc->tx_shortform_allowed;
> +	pd->tx_vp_offset = mpc->tx_vp_offset;
> +
> +	ibdev_dbg(&dev->ib_dev, "vport handle %llx pdid %x doorbell_id %x\n",
> +		  mpc->port_handle, pd->pdn, doorbell_id);
> +
> +	return 0;
> +}
> +

[...]

> +
> +static int mana_gd_allocate_doorbell_page(struct gdma_context *gc,
> +					  int *doorbell_page)
> +{
> +	struct gdma_allocate_resource_range_req req = {};
> +	struct gdma_allocate_resource_range_resp resp = {};
> +	int err;
> +
> +	mana_gd_init_req_hdr(&req.hdr, GDMA_ALLOCATE_RESOURCE_RANGE,
> +			     sizeof(req), sizeof(resp));
> +
> +	req.resource_type = GDMA_RESOURCE_DOORBELL_PAGE;
> +	req.num_resources = 1;
> +	req.alignment = 1;
> +
> +	/* Have GDMA start searching from 0 */
> +	req.allocated_resources = 0;
> +
> +	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	if (err || resp.hdr.status) {
> +		dev_err(gc->dev,
> +			"Failed to allocate doorbell page: ret %d, 0x%x\n",
> +			err, resp.hdr.status);
> +		return err ? err : -EPROTO;
> +	}
> +
> +	*doorbell_page = resp.allocated_resources;
> +
> +	return 0;
> +}
> +
> +int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
> +			   struct ib_udata *udata)
> +{
> +	struct mana_ib_ucontext *ucontext =
> +		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
> +	struct ib_device *ibdev = ibcontext->device;
> +	struct mana_ib_dev *mdev;
> +	struct gdma_context *gc;
> +	struct gdma_dev *dev;
> +	int doorbell_page;
> +	int ret;
> +
> +	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	dev = mdev->gdma_dev;
> +	gc = dev->gdma_context;
> +
> +	/* Allocate a doorbell page index */
> +	ret = mana_gd_allocate_doorbell_page(gc, &doorbell_page);
> +	if (ret) {
> +		ibdev_dbg(ibdev, "Failed to allocate doorbell page %d\n", ret);
> +		return -ENOMEM;

It does not make much sense to do "err ? err : -EPROTO" in
mana_gd_allocate_doorbell_page() if -ENOMEM is returned unconditionally
here.

> +	}
> +
> +	ibdev_dbg(ibdev, "Doorbell page allocated %d\n", doorbell_page);
> +
> +	ucontext->doorbell = doorbell_page;
> +
> +	return 0;
> +}
> +

[...]

> diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
> new file mode 100644
> index 000000000000..2225a6d6f8e1
> --- /dev/null
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
> @@ -0,0 +1,156 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2022 Microsoft Corporation. All rights reserved.
> + */
> +
> +#ifndef _MANA_IB_H_
> +#define _MANA_IB_H_
> +
> +#include <rdma/ib_verbs.h>
> +#include <rdma/ib_mad.h>
> +#include <rdma/ib_umem.h>
> +#include <rdma/mana-abi.h>
> +#include <rdma/uverbs_ioctl.h>
> +
> +#include <net/mana/mana.h>
> +
> +#define PAGE_SZ_BM                                                             \
> +	(SZ_4K | SZ_8K | SZ_16K | SZ_32K | SZ_64K | SZ_128K | SZ_256K |        \
> +	 SZ_512K | SZ_1M | SZ_2M)
> +
> +/* MANA doesn't have any limit for MR size */
> +#define MANA_IB_MAX_MR_SIZE ((u64)(~(0ULL)))

Use U64_MAX?

> +
> +struct mana_ib_dev {
> +	struct ib_device ib_dev;
> +	struct gdma_dev *gdma_dev;
> +};
> +

[...]

> diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana/mr.c
> new file mode 100644
> index 000000000000..09124dd1792d
> --- /dev/null
> +++ b/drivers/infiniband/hw/mana/mr.c
> @@ -0,0 +1,200 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "mana_ib.h"
> +
> +#define VALID_MR_FLAGS                                                         \
> +	(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_READ)
> +
> +static enum gdma_mr_access_flags
> +mana_ib_verbs_to_gdma_access_flags(int access_flags)
> +{
> +	enum gdma_mr_access_flags flags = GDMA_ACCESS_FLAG_LOCAL_READ;
> +
> +	if (access_flags & IB_ACCESS_LOCAL_WRITE)
> +		flags |= GDMA_ACCESS_FLAG_LOCAL_WRITE;
> +
> +	if (access_flags & IB_ACCESS_REMOTE_WRITE)
> +		flags |= GDMA_ACCESS_FLAG_REMOTE_WRITE;
> +
> +	if (access_flags & IB_ACCESS_REMOTE_READ)
> +		flags |= GDMA_ACCESS_FLAG_REMOTE_READ;
> +
> +	return flags;
> +}
> +
> +static int mana_ib_gd_create_mr(struct mana_ib_dev *dev, struct mana_ib_mr *mr,
> +				struct gdma_create_mr_params *mr_params)
> +{
> +	struct gdma_create_mr_response resp = {};
> +	struct gdma_create_mr_request req = {};
> +	struct gdma_dev *mdev = dev->gdma_dev;
> +	struct gdma_context *gc;
> +	int err;
> +
> +	gc = mdev->gdma_context;
> +
> +	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_MR, sizeof(req),
> +			     sizeof(resp));
> +	req.pd_handle = mr_params->pd_handle;
> +	req.mr_type = mr_params->mr_type;
> +
> +	switch (mr_params->mr_type) {
> +	case GDMA_MR_TYPE_GVA:
> +		req.gva.dma_region_handle = mr_params->gva.dma_region_handle;
> +		req.gva.virtual_address = mr_params->gva.virtual_address;
> +		req.gva.access_flags = mr_params->gva.access_flags;
> +		break;
> +
> +	default:
> +		ibdev_dbg(&dev->ib_dev,
> +			  "invalid param (GDMA_MR_TYPE) passed, type %d\n",
> +			  req.mr_type);
> +		err = -EINVAL;
> +		goto error;
> +	}
> +
> +	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +
> +	if (err || resp.hdr.status) {
> +		ibdev_dbg(&dev->ib_dev, "Failed to create mr %d, %u", err,
> +			  resp.hdr.status);
> +		if (!err)
> +			err = -EPROTO;
> +
> +		goto error;
> +	}
> +
> +	mr->ibmr.lkey = resp.lkey;
> +	mr->ibmr.rkey = resp.rkey;
> +	mr->mr_handle = resp.mr_handle;
> +
> +	return 0;
> +error:
> +	return err;

There is no error handling here, maybe just return error directly instead of
a goto.

> +}
> +
> +static int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev, gdma_obj_handle_t mr_handle)
> +{
> +	struct gdma_destroy_mr_response resp = {};
> +	struct gdma_destroy_mr_request req = {};
> +	struct gdma_dev *mdev = dev->gdma_dev;
> +	struct gdma_context *gc;
> +	int err;
> +
> +	gc = mdev->gdma_context;
> +
> +	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_MR, sizeof(req),
> +			     sizeof(resp));
> +
> +	req.mr_handle = mr_handle;
> +
> +	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	if (err || resp.hdr.status) {
> +		dev_err(gc->dev, "Failed to destroy MR: %d, 0x%x\n", err,
> +			resp.hdr.status);
> +		if (!err)
> +			err = -EPROTO;
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +

[...]

> +
> +static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
> +				 struct ib_qp_init_attr *attr,
> +				 struct ib_udata *udata)
> +{
> +	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
> +	struct mana_ib_dev *mdev =
> +		container_of(pd->device, struct mana_ib_dev, ib_dev);
> +	struct ib_rwq_ind_table *ind_tbl = attr->rwq_ind_tbl;
> +	struct mana_ib_create_qp_rss_resp resp = {};
> +	struct mana_ib_create_qp_rss ucmd = {};
> +	struct gdma_dev *gd = mdev->gdma_dev;
> +	mana_handle_t *mana_ind_table;
> +	struct mana_port_context *mpc;
> +	struct mana_context *mc;
> +	struct net_device *ndev;
> +	struct mana_ib_cq *cq;
> +	struct mana_ib_wq *wq;
> +	unsigned int ind_tbl_size;
> +	struct ib_cq *ibcq;
> +	struct ib_wq *ibwq;
> +	u32 port;
> +	int ret;
> +	int i;
> +
> +	mc = gd->driver_data;
> +
> +	if (!udata || udata->inlen < sizeof(ucmd))
> +		return -EINVAL;
> +
> +	ret = ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen));
> +	if (ret) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Failed copy from udata for create rss-qp, err %d\n",
> +			  ret);
> +		return -EFAULT;

Why not just return 'ret' directly?
