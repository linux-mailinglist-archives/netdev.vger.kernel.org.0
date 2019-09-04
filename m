Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B3CA7974
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 05:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfIDDte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 23:49:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55846 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727065AbfIDDtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 23:49:31 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 41C8D45A5D8D834E0208;
        Wed,  4 Sep 2019 11:49:30 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 11:49:20 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <kvalo@codeaurora.org>, <pkshih@realtek.com>
CC:     <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] nfp: Drop unnecessary continue in nfp_net_pf_alloc_vnics
Date:   Wed, 4 Sep 2019 11:46:23 +0800
Message-ID: <1567568784-9669-3-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
References: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continue is not needed at the bottom of a loop.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 986464d..68db47d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -205,10 +205,8 @@ static void nfp_net_pf_free_vnics(struct nfp_pf *pf)
 		ctrl_bar += NFP_PF_CSR_SLICE_SIZE;
 
 		/* Kill the vNIC if app init marked it as invalid */
-		if (nn->port && nn->port->type == NFP_PORT_INVALID) {
+		if (nn->port && nn->port->type == NFP_PORT_INVALID)
 			nfp_net_pf_free_vnic(pf, nn);
-			continue;
-		}
 	}
 
 	if (list_empty(&pf->vnics))
-- 
1.7.12.4

