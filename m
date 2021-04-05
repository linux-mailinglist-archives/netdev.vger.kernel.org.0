Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFC2353BBF
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhDEFYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232296AbhDEFYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D37613A5;
        Mon,  5 Apr 2021 05:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600283;
        bh=dMWjVf2aUxdb7ZrnGVveey6nby3LeCk61fbfNTM9fl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTxgWIVArORnsJVcmrlN8d/R5yi5c6bOrNBzElohC5vaA3tthZxAmBXekzQxLPZt1
         znzexk81BrDTA5rsNCCVYOvwwlFDnzS86wc5yRwGWJWRt2aJNEqlhMh8X3Yin5MnUg
         egYUxDlxiP5r1F4WaDRJYqPSPkYbHdcFvkPU39s/4JSgSFdlIFeQGgL/MD/zmAqfpV
         quoKIMb/Ra/cj5B4Sy7YeCi7JhHJGHVrBLPV05lfGEptIVl6j3TYWFL1RzMBwdrQlr
         KEGiPPxsxY/9/6wsL1nkOvjaFxpOYMEgu7CPBdfRPgPfo6Fuhy9FxKi4vnWqOGX83B
         98mrg+Kp01FKw==
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
Subject: [PATCH rdma-next 10/10] xprtrdma: Enable Relaxed Ordering
Date:   Mon,  5 Apr 2021 08:24:04 +0300
Message-Id: <20210405052404.213889-11-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering for xprtrdma.

Relaxed Ordering is an optional access flag and as such, it is ignored
by vendors that don't support it.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/sunrpc/xprtrdma/frwr_ops.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index cfbdd197cdfe..f9334c0a1a13 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -135,7 +135,8 @@ int frwr_mr_init(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr *mr)
 	struct ib_mr *frmr;
 	int rc;
 
-	frmr = ib_alloc_mr(ep->re_pd, ep->re_mrtype, depth, 0);
+	frmr = ib_alloc_mr(ep->re_pd, ep->re_mrtype, depth,
+			   IB_ACCESS_RELAXED_ORDERING);
 	if (IS_ERR(frmr))
 		goto out_mr_err;
 
@@ -339,9 +340,10 @@ struct rpcrdma_mr_seg *frwr_map(struct rpcrdma_xprt *r_xprt,
 	reg_wr = &mr->frwr.fr_regwr;
 	reg_wr->mr = ibmr;
 	reg_wr->key = ibmr->rkey;
-	reg_wr->access = writing ?
-			 IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
-			 IB_ACCESS_REMOTE_READ;
+	reg_wr->access =
+		(writing ? IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
+			   IB_ACCESS_REMOTE_READ) |
+		IB_ACCESS_RELAXED_ORDERING;
 
 	mr->mr_handle = ibmr->rkey;
 	mr->mr_length = ibmr->length;
-- 
2.30.2

