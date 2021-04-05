Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE315353B9B
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhDEFYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232148AbhDEFYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30A2E613A4;
        Mon,  5 Apr 2021 05:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600266;
        bh=imvbyn97thI9yWumE7pEl40IQe358kCagE2ZGNMZU9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZEzb+U8Ry5BOtN1qNr3CelJoI40xG7feEOzNwXvuXUEOQO3t+IeULIAKlg0xq4Ps
         J5AcD6+++TL27oFLWK80YU2XPT8zCB6J+XRulPpz9MTDdcSIGNm6PGnK3hChgNsqVr
         8CDSLtsMRaDgk291G4zGT7zeU9k3R5bQ4k/K1kx+Z1h6TXYqxyqz4+DzkAdIiK+l+r
         SMXkJnWjg3vbf+UY4oiB57JeZa/Xg2MeojDuvo1VBrKI3DFPfAKqJBIeAyiLOZFCDP
         dCJYSeTmHUXmoR1Ihh5FvuyelpHmTPzXJhngHA6OGcoDWelbwKJWvTYXfx6QoH0SMl
         AxUWR/QpJ9f5Q==
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
Subject: [PATCH rdma-next 05/10] RDMA/srp: Enable Relaxed Ordering
Date:   Mon,  5 Apr 2021 08:23:59 +0300
Message-Id: <20210405052404.213889-6-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering for srp.

Relaxed Ordering is an optional access flag and as such, it is ignored
by vendors that don't support it.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8481ad769ba4..0026660c3ead 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -436,7 +436,8 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
 		mr_type = IB_MR_TYPE_MEM_REG;
 
 	for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
-		mr = ib_alloc_mr(pd, mr_type, max_page_list_len, 0);
+		mr = ib_alloc_mr(pd, mr_type, max_page_list_len,
+				 IB_ACCESS_RELAXED_ORDERING);
 		if (IS_ERR(mr)) {
 			ret = PTR_ERR(mr);
 			if (ret == -ENOMEM)
@@ -1487,9 +1488,8 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	wr.wr.send_flags = 0;
 	wr.mr = desc->mr;
 	wr.key = desc->mr->rkey;
-	wr.access = (IB_ACCESS_LOCAL_WRITE |
-		     IB_ACCESS_REMOTE_READ |
-		     IB_ACCESS_REMOTE_WRITE);
+	wr.access = (IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
+		     IB_ACCESS_REMOTE_WRITE | IB_ACCESS_RELAXED_ORDERING);
 
 	*state->fr.next++ = desc;
 	state->nmdesc++;
-- 
2.30.2

