Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B68353BA8
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhDEFYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232218AbhDEFYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3E3C6139F;
        Mon,  5 Apr 2021 05:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600272;
        bh=H8VyokLLj861miN6eL/BS/iydH8X5tcb3ZsH8b+Rr3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pc2AL8IA2ENJh5d/e1ATkUHiXYZJp3c0RoiDrukP7UR18XgRnLUPOt455aETZDgD+
         9tN6dCnr71sF7xwuEtUhcHtpYZv9kBVm2hXs5G4KU8C43sJeLHi9n4p2Yca+o1XWUm
         4x87/gYWytjWu5929v6HulHxqQmQQA+kzbo5WGRzXAT/mfUU28J4IoUVN36S0olB1C
         SSiN6RrpurpK+3g49qd79KBJ73uiaGztbXchONgqfNrwuB6SP1tsCLgjB4KFzTjLHK
         0DkCmaVePHL7WmR8f37thwoi/35+N1BSlEBQDZAZbwzNsjvUBXpKze2FWem04y6aEO
         Jk8f5lhdh17MQ==
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
Subject: [PATCH rdma-next 07/10] cifs: smbd: Enable Relaxed Ordering
Date:   Mon,  5 Apr 2021 08:24:01 +0300
Message-Id: <20210405052404.213889-8-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering for smbd.

Relaxed Ordering is an optional access flag and as such, it is ignored
by vendors that don't support it.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 fs/cifs/smbdirect.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 647098a5cf3b..1e86dc8bbe85 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2178,8 +2178,10 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				continue;
 			}
 
-			smbdirect_mr->mr = ib_alloc_mr(info->pd, info->mr_type,
-						       info->max_frmr_depth, 0);
+			smbdirect_mr->mr =
+				ib_alloc_mr(info->pd, info->mr_type,
+					    info->max_frmr_depth,
+					    IB_ACCESS_RELAXED_ORDERING);
 			if (IS_ERR(smbdirect_mr->mr)) {
 				log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 					    info->mr_type,
@@ -2244,7 +2246,8 @@ static int allocate_mr_list(struct smbd_connection *info)
 		if (!smbdirect_mr)
 			goto out;
 		smbdirect_mr->mr = ib_alloc_mr(info->pd, info->mr_type,
-					       info->max_frmr_depth, 0);
+					       info->max_frmr_depth,
+					       IB_ACCESS_RELAXED_ORDERING);
 		if (IS_ERR(smbdirect_mr->mr)) {
 			log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 				    info->mr_type, info->max_frmr_depth);
@@ -2406,9 +2409,10 @@ struct smbd_mr *smbd_register_mr(
 	reg_wr->wr.send_flags = IB_SEND_SIGNALED;
 	reg_wr->mr = smbdirect_mr->mr;
 	reg_wr->key = smbdirect_mr->mr->rkey;
-	reg_wr->access = writing ?
-			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
-			IB_ACCESS_REMOTE_READ;
+	reg_wr->access =
+		(writing ? IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
+			   IB_ACCESS_REMOTE_READ) |
+		IB_ACCESS_RELAXED_ORDERING;
 
 	/*
 	 * There is no need for waiting for complemtion on ib_post_send
-- 
2.30.2

