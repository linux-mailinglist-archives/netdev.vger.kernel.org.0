Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56127353BAF
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhDEFYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhDEFYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F92E613A7;
        Mon,  5 Apr 2021 05:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600276;
        bh=PAgj56Yc//zBEZolPkWhsSnGjEMS6kZSDqBlkURbZas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYxv5/O9LXkexYx1MQDU6ox6EdhzHB4uGJEl6xIqmgN3v+/+IXqbR/96mtUTQxa7L
         jSdhIGDVjcJBsXfrWfnoQ9hoWgB51uBDgqGKwBVjvHr7sKGRXuHD4KE5U5+mvekNf2
         jgaH/6UhjlCgxX93pKq/a/2N39eIzYUIbsccbxUAttXvyG30WG82NYcoyLgMJp/QLy
         GIhiZMCeqTaqK2op2Fnk/dZyJf+fOiHxDpGjeTQwZtW7yad/MlAgSOwdOLXw6TYcP6
         A0EKyLcC6rRPmGH9WfOryJ9ALoePf3A/Oe68jTK5RXqYw+Xr+hzYsSTH7CPeDp+ZOr
         uoDtLhQl6cu1Q==
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
Subject: [PATCH rdma-next 08/10] net/rds: Enable Relaxed Ordering
Date:   Mon,  5 Apr 2021 08:24:02 +0300
Message-Id: <20210405052404.213889-9-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering for rds.

Relaxed Ordering is an optional access flag and as such, it is ignored
by vendors that don't support it.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/rds/ib_frmr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 694eb916319e..1a60c2c90c78 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -76,7 +76,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
 
 	frmr = &ibmr->u.frmr;
 	frmr->mr = ib_alloc_mr(rds_ibdev->pd, IB_MR_TYPE_MEM_REG,
-			       pool->max_pages, 0);
+			       pool->max_pages, IB_ACCESS_RELAXED_ORDERING);
 	if (IS_ERR(frmr->mr)) {
 		pr_warn("RDS/IB: %s failed to allocate MR", __func__);
 		err = PTR_ERR(frmr->mr);
@@ -156,9 +156,8 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 	reg_wr.wr.num_sge = 0;
 	reg_wr.mr = frmr->mr;
 	reg_wr.key = frmr->mr->rkey;
-	reg_wr.access = IB_ACCESS_LOCAL_WRITE |
-			IB_ACCESS_REMOTE_READ |
-			IB_ACCESS_REMOTE_WRITE;
+	reg_wr.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
+			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_RELAXED_ORDERING;
 	reg_wr.wr.send_flags = IB_SEND_SIGNALED;
 
 	ret = ib_post_send(ibmr->ic->i_cm_id->qp, &reg_wr.wr, NULL);
-- 
2.30.2

