Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3A1353BB3
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhDEFYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhDEFYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DCD613AE;
        Mon,  5 Apr 2021 05:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600279;
        bh=kgFeNEGqbN9WM+uS4TOUKfA2KjjvWH4Sn9QKyrs2Esc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/LrR2eygKEWxFLckWrWCNTnD6kKtvMcLmftsZoTnWCqk/rgGjPILP1O9Sb/m2viK
         unVBfkwguZGE9J6jSmdfrppM0HIlMce2I1CMFt3b8rq3SQaGOSdUrmAdgRZOndp/VF
         zIYWDg6Ge7lvfxKr803oVG0AT8FhZZ2x5c5l0N3hBRcjqBiaRPlr+4xs3g3l3XdBJF
         XvOyzE85/pRqLznPmdWpEyLjjT8s0HbLGGqxpaxyrGJxkVqP+3zTrUzHF9bbDXflGB
         pGiGbDaDmxBdvgIZL3qNem0va+qf59TNStPrQAG9mmWUREFLPlkFkrT/UVlRflsgKH
         ir0e3t698GSvQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next 06/10] nvme-rdma: Enable Relaxed Ordering
Date:   Mon,  5 Apr 2021 08:24:00 +0300
Message-Id: <20210405052404.213889-7-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering for nvme.

Relaxed Ordering is an optional access flag and as such, it is ignored
by vendors that don't support it.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/rdma.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 4dbc17311e0b..8f106b20b39c 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -532,9 +532,8 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	 */
 	pages_per_mr = nvme_rdma_get_max_fr_pages(ibdev, queue->pi_support) + 1;
 	ret = ib_mr_pool_init(queue->qp, &queue->qp->rdma_mrs,
-			      queue->queue_size,
-			      IB_MR_TYPE_MEM_REG,
-			      pages_per_mr, 0, 0);
+			      queue->queue_size, IB_MR_TYPE_MEM_REG,
+			      pages_per_mr, 0, IB_ACCESS_RELAXED_ORDERING);
 	if (ret) {
 		dev_err(queue->ctrl->ctrl.device,
 			"failed to initialize MR pool sized %d for QID %d\n",
@@ -545,7 +544,8 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	if (queue->pi_support) {
 		ret = ib_mr_pool_init(queue->qp, &queue->qp->sig_mrs,
 				      queue->queue_size, IB_MR_TYPE_INTEGRITY,
-				      pages_per_mr, pages_per_mr, 0);
+				      pages_per_mr, pages_per_mr,
+				      IB_ACCESS_RELAXED_ORDERING);
 		if (ret) {
 			dev_err(queue->ctrl->ctrl.device,
 				"failed to initialize PI MR pool sized %d for QID %d\n",
@@ -1382,9 +1382,9 @@ static int nvme_rdma_map_sg_fr(struct nvme_rdma_queue *queue,
 	req->reg_wr.wr.num_sge = 0;
 	req->reg_wr.mr = req->mr;
 	req->reg_wr.key = req->mr->rkey;
-	req->reg_wr.access = IB_ACCESS_LOCAL_WRITE |
-			     IB_ACCESS_REMOTE_READ |
-			     IB_ACCESS_REMOTE_WRITE;
+	req->reg_wr.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
+			     IB_ACCESS_REMOTE_WRITE |
+			     IB_ACCESS_RELAXED_ORDERING;
 
 	sg->addr = cpu_to_le64(req->mr->iova);
 	put_unaligned_le24(req->mr->length, sg->length);
@@ -1488,9 +1488,8 @@ static int nvme_rdma_map_sg_pi(struct nvme_rdma_queue *queue,
 	wr->wr.send_flags = 0;
 	wr->mr = req->mr;
 	wr->key = req->mr->rkey;
-	wr->access = IB_ACCESS_LOCAL_WRITE |
-		     IB_ACCESS_REMOTE_READ |
-		     IB_ACCESS_REMOTE_WRITE;
+	wr->access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
+		     IB_ACCESS_REMOTE_WRITE | IB_ACCESS_RELAXED_ORDERING;
 
 	sg->addr = cpu_to_le64(req->mr->iova);
 	put_unaligned_le24(req->mr->length, sg->length);
-- 
2.30.2

