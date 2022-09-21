Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BE45D022A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiIUR7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIUR7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:59:47 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905451EC40
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 10:59:45 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id ml1so5055956qvb.1
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 10:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ojFVpzQQBU65/cGnBwiD8XrHjwc6yoknKk2FoCB1U+E=;
        b=O/yO+1pTVH+zv9lgZ6ajaiHQaZ3PYprJYilZ8UutSTafDsVkKMpXizw9/imuY0AtOC
         NYW8Mswf9f4b0Lsrpbgl9u1P+xgRrxnbfGvYOjv1/vgDuYXpDHMJwNLgi684KgMrw7yo
         fiUPjMEnVf5rG46oAG+S4HyC9ur8chpqMlDO+5sfilqDTNVhMKXKLEnnVcYxULKTK5VA
         AQBdCNF62VZ9b3HfZxMhuaoRec6029+5PYkmBxHsn+yuxUyzLF4gqEZwlo/RtBNMiUve
         K3NzQAETMcW9rwyNJQ2V3fj7XLUNgd3jy5oraffH3ZVwzYeSacO+Cpg+jgSb3HQUCa/I
         poIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ojFVpzQQBU65/cGnBwiD8XrHjwc6yoknKk2FoCB1U+E=;
        b=ZRbxvKwhOMLOKKb8Psim5qO5jCNBYeqqX6CTxYBJTpTgpTvwX52IJWoQA15Ou3CGgd
         VB48qSa1K1kbDx6QASvybS5d4cQRN4baitYGVI+nk269WNO3w/PSnq0v3V3KkC7XO7st
         jN7UYVbfMgkwNMsXPpbxb0H1yQcl//aPDK0EP9+N9w8+kh/CMSeAs6DmedZSiPYXJHGt
         Fv6dyVf2lxvo3XwENgNFZYRmeuelzxfLi+xqw9ffFhUprtT533MpTY3MWOUU2WmGf3YU
         twCsInVOSJpOYb75iLHr93gtFCztRdo+SDg61ZosVe2Nno/PpT7Cy1J73kd00gNPWRdK
         3hTQ==
X-Gm-Message-State: ACrzQf1e5dusIlzPvyZWDD577sa3WgLpGW+E8ptAzY2MUp999H3QDXwj
        0qZOCO//7Da8URbkThMuSHJRBw==
X-Google-Smtp-Source: AMsMyM5fRcrw2C3mhiySyFtDFy2sCBzxuDmRwENMhWkDVUkzIilCF7ArZc23WJWPhbBRVXc2yPQX5g==
X-Received: by 2002:a0c:b3c1:0:b0:4ac:bfe7:af9d with SMTP id b1-20020a0cb3c1000000b004acbfe7af9dmr24500399qvf.38.1663783184673;
        Wed, 21 Sep 2022 10:59:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id ga8-20020a05622a590800b00304fe5247bfsm2053130qtb.36.2022.09.21.10.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:59:43 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ob40c-0015tZ-Fk;
        Wed, 21 Sep 2022 14:59:42 -0300
Date:   Wed, 21 Sep 2022 14:59:42 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v6 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <YytRDgWDsFYY6rV/@ziepe.ca>
References: <1663723352-598-1-git-send-email-longli@linuxonhyperv.com>
 <1663723352-598-13-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1663723352-598-13-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 06:22:32PM -0700, longli@linuxonhyperv.com wrote:
> +int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
> +		      struct ib_udata *udata)
> +{
> +	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
> +	struct ib_device *ibdev = ibcq->device;
> +	struct mana_ib_create_cq ucmd = {};
> +	struct mana_ib_dev *mdev;
> +	int err;
> +
> +	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);

Stylistically these container_of's are usually in the definitions
section, at least pick a form and stick to it consistently.

> +	if (udata->inlen < sizeof(ucmd))
> +		return -EINVAL;
> +
> +	err = ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen));
> +	if (err) {
> +		ibdev_dbg(ibdev,
> +			  "Failed to copy from udata for create cq, %d\n", err);

> +		return -EFAULT;
> +	}
> +
> +	if (attr->cqe > MAX_SEND_BUFFERS_PER_QUEUE) {
> +		ibdev_dbg(ibdev, "CQE %d exceeding limit\n", attr->cqe);
> +		return -EINVAL;
> +	}
> +
> +	cq->cqe = attr->cqe;
> +	cq->umem = ib_umem_get(ibdev, ucmd.buf_addr, cq->cqe * COMP_ENTRY_SIZE,
> +			       IB_ACCESS_LOCAL_WRITE);
> +	if (IS_ERR(cq->umem)) {
> +		err = PTR_ERR(cq->umem);
> +		ibdev_dbg(ibdev, "Failed to get umem for create cq, err %d\n",
> +			  err);
> +		return err;
> +	}
> +
> +	err = mana_ib_gd_create_dma_region(mdev, cq->umem, &cq->gdma_region,
> +					   PAGE_SIZE);
> +	if (err) {
> +		ibdev_err(ibdev,
> +			  "Failed to create dma region for create cq, %d\n",
> +			  err);

Prints on userspace paths are not allowed, this should be dbg. There
are many other cases like this, please fix them all. This driver may
have too many dbg prints too, not every failure if should have a print
:(

> +	ibdev_dbg(ibdev,
> +		  "mana_ib_gd_create_dma_region ret %d gdma_region 0x%llx\n",
> +		  err, cq->gdma_region);
> +
> +	/* The CQ ID is not known at this time
> +	 * The ID is generated at create_qp
> +	 */

Wrong comment style, rdma uses the leading empty blank line for some
reason

 /*
  * The CQ ID is not known at this time. The ID is generated at create_qp.
  */

> +static void mana_ib_remove(struct auxiliary_device *adev)
> +{
> +	struct mana_ib_dev *dev = dev_get_drvdata(&adev->dev);
> +
> +	ib_unregister_device(&dev->ib_dev);
> +	ib_dealloc_device(&dev->ib_dev);
> +}
> +
> +static const struct auxiliary_device_id mana_id_table[] = {
> +	{
> +		.name = "mana.rdma",
> +	},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(auxiliary, mana_id_table);
> +
> +static struct auxiliary_driver mana_driver = {
> +	.name = "rdma",
> +	.probe = mana_ib_probe,
> +	.remove = mana_ib_remove,
> +	.id_table = mana_id_table,
> +};
> +
> +static int __init mana_ib_init(void)
> +{
> +	auxiliary_driver_register(&mana_driver);
> +
> +	return 0;
> +}
> +
> +static void __exit mana_ib_cleanup(void)
> +{
> +	auxiliary_driver_unregister(&mana_driver);
> +}
> +

All this is just module_auxiliary_driver()

> +	mutex_lock(&pd->vport_mutex);
> +
> +	pd->vport_use_count++;
> +	if (pd->vport_use_count > 1) {
> +		ibdev_dbg(&dev->ib_dev,
> +			  "Skip as this PD is already configured vport\n");
> +		mutex_unlock(&pd->vport_mutex);

This leaves vport_use_count elevated.

> +		return 0;
> +int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
> +{
> +	struct mana_ib_pd *pd = container_of(ibpd, struct mana_ib_pd, ibpd);
> +	struct ib_device *ibdev = ibpd->device;
> +	struct mana_ib_dev *dev;
> +
> +	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	return mana_ib_gd_destroy_pd(dev, pd->pd_handle);

This is the only place that calls mana_ib_gd_destroy_pd(), don't have
a spaghetti of functions calling single other functions like this,
just inline it.

Also it shouldn't have been non-static, please check everything that
everything non-static actually has an out-of-file user.

> +void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
> +{
> +	struct mana_ib_ucontext *mana_ucontext =
> +		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
> +	struct ib_device *ibdev = ibcontext->device;
> +	struct mana_ib_dev *mdev;
> +	struct gdma_context *gc;
> +	int ret;
> +
> +	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	gc = mdev->gdma_dev->gdma_context;
> +
> +	ret = mana_gd_destroy_doorbell_page(gc, mana_ucontext->doorbell);
> +	if (ret)
> +		ibdev_err(ibdev, "Failed to destroy doorbell page %d\n", ret);

This already printing on error

And again, why is this driver split up so strangely?
mana_gd_destroy_doorbell_page() is an RDMA function, it is only called
by the RDMA code, why is it located under drivers/net/ethernet?

I do not want an RDMA driver in drivers/net/ethernet.


> +}
> +
> +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
> +				 mana_handle_t *gdma_region, u64 page_sz)
> +{
> +	size_t num_pages_total = ib_umem_num_dma_blocks(umem, page_sz);
> +	struct gdma_dma_region_add_pages_req *add_req = NULL;
> +	struct gdma_create_dma_region_resp create_resp = {};
> +	struct gdma_create_dma_region_req *create_req;
> +	size_t num_pages_cur, num_pages_to_handle;
> +	unsigned int create_req_msg_size;
> +	struct hw_channel_context *hwc;
> +	struct ib_block_iter biter;
> +	size_t max_pgs_create_cmd;
> +	struct gdma_context *gc;
> +	struct gdma_dev *mdev;
> +	unsigned int i;
> +	int err;
> +
> +	mdev = dev->gdma_dev;
> +	gc = mdev->gdma_context;
> +	hwc = gc->hwc.driver_data;
> +	max_pgs_create_cmd =
> +		(hwc->max_req_msg_size - sizeof(*create_req)) / sizeof(u64);
> +
> +	num_pages_to_handle =
> +		min_t(size_t, num_pages_total, max_pgs_create_cmd);
> +	create_req_msg_size =
> +		struct_size(create_req, page_addr_list, num_pages_to_handle);
> +
> +	create_req = kzalloc(create_req_msg_size, GFP_KERNEL);
> +	if (!create_req)

Is this a multi-order allocation, I can't tell how big
max_req_msg_size is? 

This design seems to repeat the mistakes we made in mlx5, the low
levels of the driver already has memory allocated - why not get a
pointer to that memory here and directly fill the message buffer
instead of all this allocation and memory copying?
> +	ibdev_dbg(&dev->ib_dev,
> +		  "size_dma_region %lu num_pages_total %lu, "
> +		  "page_sz 0x%llx offset_in_page %u\n",
> +		  umem->length, num_pages_total, page_sz,
> +		  create_req->offset_in_page);
> +
> +	ibdev_dbg(&dev->ib_dev, "num_pages_to_handle %lu, gdma_page_type %u",
> +		  num_pages_to_handle, create_req->gdma_page_type);
> +
> +	__rdma_umem_block_iter_start(&biter, umem, page_sz);

> +	for (i = 0; i < num_pages_to_handle; ++i) {
> +		dma_addr_t cur_addr;
> +
> +		__rdma_block_iter_next(&biter);
> +		cur_addr = rdma_block_iter_dma_address(&biter);
> +
> +		create_req->page_addr_list[i] = cur_addr;
> +
> +		ibdev_dbg(&dev->ib_dev, "page num %u cur_addr 0x%llx\n", i,
> +			  cur_addr);

Please get rid of the worthless debugging code, actually test your
driver with EBUG enabled and ensure it is usuable. Printing thousands
of lines of garbage is not OK. Especially when what should have been a
1 line loop body is expended into a big block just to have a worthless
debug statement.


> +	if (num_pages_cur < num_pages_total) {
> +		unsigned int add_req_msg_size;
> +		size_t max_pgs_add_cmd =
> +			(hwc->max_req_msg_size - sizeof(*add_req)) /
> +			sizeof(u64);
> +
> +		num_pages_to_handle =
> +			min_t(size_t, num_pages_total - num_pages_cur,
> +			      max_pgs_add_cmd);
> +
> +		/* Calculate the max num of pages that will be handled */
> +		add_req_msg_size = struct_size(add_req, page_addr_list,
> +					       num_pages_to_handle);
> +
> +		add_req = kmalloc(add_req_msg_size, GFP_KERNEL);

And allocating every loop iteration seems like overkill, why not just
reuse the large buffer that create_req allocated?

Usually the way these loops are structured is to fill the array and
then check for fullness, trigger an action to drain the array, and
reset the indexes back to the start.

> +int mana_ib_gd_create_pd(struct mana_ib_dev *dev, u64 *pd_handle, u32 *pd_id,
> +			 enum gdma_pd_flags flags)
> +{
> +	struct gdma_dev *mdev = dev->gdma_dev;
> +	struct gdma_create_pd_resp resp = {};
> +	struct gdma_create_pd_req req = {};
> +	struct gdma_context *gc;
> +	int err;
> +
> +	gc = mdev->gdma_context;
> +
> +	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_PD, sizeof(req),
> +			     sizeof(resp));
> +
> +	req.flags = flags;
> +	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +
> +	if (err || resp.hdr.status) {
> +		ibdev_err(&dev->ib_dev,
> +			  "Failed to get pd_id err %d status %u\n", err,
> +			  resp.hdr.status);
> +		if (!err)
> +			err = -EPROTO;

This pattern is repeated everywhere, you should fix
mana_gd_send_request() to return EPROTO.

> +		return err;
> +	}
> +
> +	*pd_handle = resp.pd_handle;
> +	*pd_id = resp.pd_id;
> +	ibdev_dbg(&dev->ib_dev, "pd_handle 0x%llx pd_id %d\n", *pd_handle,
> +		  *pd_id);
> +
> +	return 0;
> +}
> +
> +int mana_ib_gd_destroy_pd(struct mana_ib_dev *dev, u64 pd_handle)
> +{
> +	struct gdma_dev *mdev = dev->gdma_dev;
> +	struct gdma_destory_pd_resp resp = {};
> +	struct gdma_destroy_pd_req req = {};
> +	struct gdma_context *gc;
> +	int err;
> +
> +	gc = mdev->gdma_context;

Why the local for a variable that is used once?

> +int mana_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
> +{
> +	struct mana_ib_ucontext *mana_ucontext =
> +		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
> +	struct ib_device *ibdev = ibcontext->device;
> +	struct mana_ib_dev *mdev;
> +	struct gdma_context *gc;
> +	phys_addr_t pfn;
> +	pgprot_t prot;
> +	int ret;
> +
> +	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
> +	gc = mdev->gdma_dev->gdma_context;
> +
> +	if (vma->vm_pgoff != 0) {
> +		ibdev_err(ibdev, "Unexpected vm_pgoff %lu\n", vma->vm_pgoff);
> +		return -EINVAL;

More user triggerable printing

> +int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
> +{
> +	struct mana_ib_mr *mr = container_of(ibmr, struct mana_ib_mr, ibmr);
> +	struct ib_device *ibdev = ibmr->device;
> +	struct mana_ib_dev *dev;
> +	int err;
> +
> +	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
> +
> +	err = mana_ib_gd_destroy_mr(dev, mr->mr_handle);
> +	if (err)
> +		return err;

mana_ib_gd_destroy_mr() is only ever called here, why is it in main.c?

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
> +	struct ib_cq *ibcq;
> +	struct ib_wq *ibwq;
> +	int i = 0, ret;
> +	u32 port;
> +
> +	mc = gd->driver_data;
> +
> +	if (udata->inlen < sizeof(ucmd))
> +		return -EINVAL;
> +
> +	ret = ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen));
> +	if (ret) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Failed copy from udata for create rss-qp, err %d\n",
> +			  ret);
> +		return -EFAULT;
> +	}
> +
> +	if (attr->cap.max_recv_wr > MAX_SEND_BUFFERS_PER_QUEUE) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Requested max_recv_wr %d exceeding limit.\n",
> +			  attr->cap.max_recv_wr);
> +		return -EINVAL;
> +	}
> +
> +	if (attr->cap.max_recv_sge > MAX_RX_WQE_SGL_ENTRIES) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Requested max_recv_sge %d exceeding limit.\n",
> +			  attr->cap.max_recv_sge);
> +		return -EINVAL;
> +	}
> +
> +	if (ucmd.rx_hash_function != MANA_IB_RX_HASH_FUNC_TOEPLITZ) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "RX Hash function is not supported, %d\n",
> +			  ucmd.rx_hash_function);
> +		return -EINVAL;
> +	}
> +
> +	/* IB ports start with 1, MANA start with 0 */
> +	port = ucmd.port;
> +	if (port < 1 || port > mc->num_ports) {
> +		ibdev_dbg(&mdev->ib_dev, "Invalid port %u in creating qp\n",
> +			  port);
> +		return -EINVAL;
> +	}
> +	ndev = mc->ports[port - 1];
> +	mpc = netdev_priv(ndev);
> +
> +	ibdev_dbg(&mdev->ib_dev, "rx_hash_function %d port %d\n",
> +		  ucmd.rx_hash_function, port);
> +
> +	mana_ind_table = kzalloc(sizeof(mana_handle_t) *
> +					 (1 << ind_tbl->log_ind_tbl_size),
> +				 GFP_KERNEL);

Should be careful about maths overflow on this calculation.

> +	ibdev_dbg(&mdev->ib_dev, "ucmd sq_buf_addr 0x%llx port %u\n",
> +		  ucmd.sq_buf_addr, ucmd.port);
> +
> +	umem = ib_umem_get(ibpd->device, ucmd.sq_buf_addr, ucmd.sq_buf_size,
> +			   IB_ACCESS_LOCAL_WRITE);
> +	if (IS_ERR(umem)) {
> +		err = PTR_ERR(umem);
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Failed to get umem for create qp-raw, err %d\n",
> +			  err);
> +		goto err_free_vport;
> +	}
> +	qp->sq_umem = umem;
> +
> +	err = mana_ib_gd_create_dma_region(mdev, qp->sq_umem,
> +					   &qp->sq_gdma_region, PAGE_SIZE);
> +	if (err) {

All these cases that process a page list have to call
ib_umem_find_best_XXX()!

It does important validation against hostile user input, including
checking the critical iova.

You have missed that the user can request that an unaligned umem be
created and this creates a starting offset from the first page that
must be honored in HW, or there will be weird memory corruption. Since
it looks like this HW doesn't support a starting page offset this
should call ib_umem_find_best_pgsz() with a SZ_4K and a 0 iova. Also
never use PAGE_SIZE to describe a HW limitation.

There is alot of repeated code here, it would do well to have a
wrapper function consolidating this pattern.

Jason
