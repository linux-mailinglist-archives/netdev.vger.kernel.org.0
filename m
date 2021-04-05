Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58D8353B91
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhDEFY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232098AbhDEFYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 892346139E;
        Mon,  5 Apr 2021 05:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600259;
        bh=nRfDFwKnXvGxEINJ1gcUC5CV0hDDdn2QGMGYyGbA7kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHoI+pUcHzU20igTKYZrklmw7W/BSsCop538orqhMBlWsUMJ25vZUuom6KI8GJ6xJ
         HaROOmDmBRB/yGlqL4AtjyV/K9d0f4v9hRClzfsYeretoARDsMPdSctmtreSR/Ht6H
         WsuQfYs5lXbXpYinCPOm6HuwsFhisYx9BDQrlcETN+mrI4GhkEA6+wOgjRdIQp5X8s
         MkOBzOg7YwifLq7AcIG4RMeq9ySjzFiBaMHNvR5zm5Xwhn6DtVXYST+6bXKykJbjXZ
         kH30bar0LGJwgxKwOoqtsOY+jzXkUPejDXliyyPKH5uOYsOsInJ5kpgXj2s9xBpBbs
         +swSb/FSAvQ+A==
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
Subject: [PATCH rdma-next 03/10] RDMA/iser: Enable Relaxed Ordering
Date:   Mon,  5 Apr 2021 08:23:57 +0300
Message-Id: <20210405052404.213889-4-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering for iser.

Relaxed Ordering is an optional access flag and as such, it is ignored
by vendors that don't support it.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 10 ++++------
 drivers/infiniband/ulp/iser/iser_verbs.c  |  6 ++++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index afec40da9b58..29849c9e82e8 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -271,9 +271,8 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	wr->wr.send_flags = 0;
 	wr->mr = mr;
 	wr->key = mr->rkey;
-	wr->access = IB_ACCESS_LOCAL_WRITE |
-		     IB_ACCESS_REMOTE_READ |
-		     IB_ACCESS_REMOTE_WRITE;
+	wr->access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
+		     IB_ACCESS_REMOTE_WRITE | IB_ACCESS_RELAXED_ORDERING;
 	rsc->mr_valid = 1;
 
 	sig_reg->sge.lkey = mr->lkey;
@@ -318,9 +317,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	wr->wr.num_sge = 0;
 	wr->mr = mr;
 	wr->key = mr->rkey;
-	wr->access = IB_ACCESS_LOCAL_WRITE  |
-		     IB_ACCESS_REMOTE_WRITE |
-		     IB_ACCESS_REMOTE_READ;
+	wr->access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
+		     IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING;
 
 	rsc->mr_valid = 1;
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 3c370ee25f2f..1e236b1cf29b 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -121,7 +121,8 @@ iser_create_fastreg_desc(struct iser_device *device,
 	else
 		mr_type = IB_MR_TYPE_MEM_REG;
 
-	desc->rsc.mr = ib_alloc_mr(pd, mr_type, size, 0);
+	desc->rsc.mr = ib_alloc_mr(pd, mr_type, size,
+		IB_ACCESS_RELAXED_ORDERING);
 	if (IS_ERR(desc->rsc.mr)) {
 		ret = PTR_ERR(desc->rsc.mr);
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
@@ -129,7 +130,8 @@ iser_create_fastreg_desc(struct iser_device *device,
 	}
 
 	if (pi_enable) {
-		desc->rsc.sig_mr = ib_alloc_mr_integrity(pd, size, size, 0);
+		desc->rsc.sig_mr = ib_alloc_mr_integrity(pd, size, size,
+			IB_ACCESS_RELAXED_ORDERING);
 		if (IS_ERR(desc->rsc.sig_mr)) {
 			ret = PTR_ERR(desc->rsc.sig_mr);
 			iser_err("Failed to allocate sig_mr err=%d\n", ret);
-- 
2.30.2

