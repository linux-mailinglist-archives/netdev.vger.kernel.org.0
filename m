Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60E6353B97
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhDEFYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232141AbhDEFY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F258160724;
        Mon,  5 Apr 2021 05:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600262;
        bh=TEonNohSk3EOSuNC7NQhTyXQR/le1bI4Rm+lbGRMhFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYZI5B7xWpbmozNboLJR3DNhlI8gl+yFyBzL8s8rkQ9v3cxdRSR4Pcl95wBnkwIGw
         7WpqToEYZZxUC46b/gQsHXzarF7l05/xnPGzOa0KcFQnnWj79dVfrWZUT5eLVKXgqv
         pz4DQa+RVAw7nQAqAHF2civ70nLPbDRMkJj5iColoB4/u3rLW1mugaxyWVa1KIw4Z3
         p1l89kLcOsl2MGAbplU8xnOMrt9uTcsZf1+hOJgSaNp2kSu5AIzZgbgMKnUwEg5CBs
         MbKq8oGOxt9TmW0UuTH05peUnwILEeGNCr+CJWKKIMLZ+pqVrW1f6rox4r6cw0impJ
         CHjWu7sq0Q2yw==
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
Subject: [PATCH rdma-next 04/10] RDMA/rtrs: Enable Relaxed Ordering
Date:   Mon,  5 Apr 2021 08:23:58 +0300
Message-Id: <20210405052404.213889-5-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering fro rtrs client and server.

Relaxed Ordering is an optional access flag and as such, it is ignored
by vendors that don't support it.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c |  6 ++++--
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 15 ++++++++-------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 0d3960ed5b2b..a3fbb47a3574 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1099,7 +1099,8 @@ static int rtrs_clt_read_req(struct rtrs_clt_io_req *req)
 			.mr = req->mr,
 			.key = req->mr->rkey,
 			.access = (IB_ACCESS_LOCAL_WRITE |
-				   IB_ACCESS_REMOTE_WRITE),
+				   IB_ACCESS_REMOTE_WRITE |
+				   IB_ACCESS_RELAXED_ORDERING),
 		};
 		wr = &rwr.wr;
 
@@ -1260,7 +1261,8 @@ static int alloc_sess_reqs(struct rtrs_clt_sess *sess)
 			goto out;
 
 		req->mr = ib_alloc_mr(sess->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
-				      sess->max_pages_per_mr, 0);
+				      sess->max_pages_per_mr,
+				      IB_ACCESS_RELAXED_ORDERING);
 		if (IS_ERR(req->mr)) {
 			err = PTR_ERR(req->mr);
 			req->mr = NULL;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 575f31ff20fd..c28ed5e2245d 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -312,8 +312,8 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		rwr.mr = srv_mr->mr;
 		rwr.wr.send_flags = 0;
 		rwr.key = srv_mr->mr->rkey;
-		rwr.access = (IB_ACCESS_LOCAL_WRITE |
-			      IB_ACCESS_REMOTE_WRITE);
+		rwr.access = (IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
+			      IB_ACCESS_RELAXED_ORDERING);
 		msg = srv_mr->iu->buf;
 		msg->buf_id = cpu_to_le16(id->msg_id);
 		msg->type = cpu_to_le16(RTRS_MSG_RKEY_RSP);
@@ -432,8 +432,8 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 		rwr.wr.send_flags = 0;
 		rwr.mr = srv_mr->mr;
 		rwr.key = srv_mr->mr->rkey;
-		rwr.access = (IB_ACCESS_LOCAL_WRITE |
-			      IB_ACCESS_REMOTE_WRITE);
+		rwr.access = (IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
+			      IB_ACCESS_RELAXED_ORDERING);
 		msg = srv_mr->iu->buf;
 		msg->buf_id = cpu_to_le16(id->msg_id);
 		msg->type = cpu_to_le16(RTRS_MSG_RKEY_RSP);
@@ -638,7 +638,7 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 			goto free_sg;
 		}
 		mr = ib_alloc_mr(sess->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
-				 sgt->nents, 0);
+				 sgt->nents, IB_ACCESS_RELAXED_ORDERING);
 		if (IS_ERR(mr)) {
 			err = PTR_ERR(mr);
 			goto unmap_sg;
@@ -823,8 +823,9 @@ static int process_info_req(struct rtrs_srv_con *con,
 		rwr[mri].wr.send_flags = 0;
 		rwr[mri].mr = mr;
 		rwr[mri].key = mr->rkey;
-		rwr[mri].access = (IB_ACCESS_LOCAL_WRITE |
-				   IB_ACCESS_REMOTE_WRITE);
+		rwr[mri].access =
+			(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
+			 IB_ACCESS_RELAXED_ORDERING);
 		reg_wr = &rwr[mri].wr;
 	}
 
-- 
2.30.2

