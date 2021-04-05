Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92B2353BC4
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhDEFY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhDEFYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27751613A0;
        Mon,  5 Apr 2021 05:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600286;
        bh=qC4efJ6nsgEYXrpmkxKWy75LAL147M2IGYN5TPsAdII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWplzcsL9Z5M80eaItlaxJPIR8oDNUKVel7eVHXrIxgYhy15rmgiaRan2ANUF/xfS
         apgjMlinRcwdZm0uRUeyF/w4IyRoC8LiJdvurqBkHVTLLZHkorC1ppo+CRAOPQhuco
         hko2LOHnT6P1Cu75LPSLN6AjVOzu0jA/c2M6h8tw4toBn+o4y/+WJoCy91HO2D7mvd
         NAzKe3/TxiRAXu7DgOhWFA9vuqbpH3rhesPmiSiqOcI7iH/mrdhmzUMyzAgWVBGM3/
         VuCoVYPSlpRIc2bqYFPLZamRFc55xmRnknWVB8LUXs8Muk5YNrVOlYzmxGXd+Mjwyu
         zd12jPeU6mFnw==
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
Subject: [PATCH rdma-next 09/10] net/smc: Enable Relaxed Ordering
Date:   Mon,  5 Apr 2021 08:24:03 +0300
Message-Id: <20210405052404.213889-10-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering for smc.

Relaxed Ordering is an optional access flag and as such, it is ignored
by vendors that don't support it.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/smc/smc_ib.c | 3 ++-
 net/smc/smc_wr.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 4e91ed3dc265..6b65c5d1f957 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -579,7 +579,8 @@ int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
 		return 0; /* already done */
 
 	buf_slot->mr_rx[link_idx] =
-		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, 1 << buf_slot->order, 0);
+		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, 1 << buf_slot->order,
+			    IB_ACCESS_RELAXED_ORDERING);
 	if (IS_ERR(buf_slot->mr_rx[link_idx])) {
 		int rc;
 
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index cbc73a7e4d59..78e9650621f1 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -555,7 +555,8 @@ static void smc_wr_init_sge(struct smc_link *lnk)
 	lnk->wr_reg.wr.num_sge = 0;
 	lnk->wr_reg.wr.send_flags = IB_SEND_SIGNALED;
 	lnk->wr_reg.wr.opcode = IB_WR_REG_MR;
-	lnk->wr_reg.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
+	lnk->wr_reg.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
+			     IB_ACCESS_RELAXED_ORDERING;
 }
 
 void smc_wr_free_link(struct smc_link *lnk)
-- 
2.30.2

