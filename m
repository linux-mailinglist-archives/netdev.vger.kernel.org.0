Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1B32D3E7A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgLIJVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:21:07 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8734 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgLIJU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:20:57 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CrWhd65M2zkn9v;
        Wed,  9 Dec 2020 17:19:29 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:20:04 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: cisco: enic: simplify the return vnic_cq_alloc()
Date:   Wed, 9 Dec 2020 17:20:31 +0800
Message-ID: <20201209092031.20255-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/cisco/enic/vnic_cq.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/vnic_cq.c b/drivers/net/ethernet/cisco/enic/vnic_cq.c
index 9c682aff3834..519323460f26 100644
--- a/drivers/net/ethernet/cisco/enic/vnic_cq.c
+++ b/drivers/net/ethernet/cisco/enic/vnic_cq.c
@@ -36,8 +36,6 @@ void vnic_cq_free(struct vnic_cq *cq)
 int vnic_cq_alloc(struct vnic_dev *vdev, struct vnic_cq *cq, unsigned int index,
 	unsigned int desc_count, unsigned int desc_size)
 {
-	int err;
-
 	cq->index = index;
 	cq->vdev = vdev;
 
@@ -47,11 +45,7 @@ int vnic_cq_alloc(struct vnic_dev *vdev, struct vnic_cq *cq, unsigned int index,
 		return -EINVAL;
 	}
 
-	err = vnic_dev_alloc_desc_ring(vdev, &cq->ring, desc_count, desc_size);
-	if (err)
-		return err;
-
-	return 0;
+	return vnic_dev_alloc_desc_ring(vdev, &cq->ring, desc_count, desc_size);
 }
 
 void vnic_cq_init(struct vnic_cq *cq, unsigned int flow_control_enable,
-- 
2.22.0

