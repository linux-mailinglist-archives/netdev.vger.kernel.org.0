Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B760206
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfGEIUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:20:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49734 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGEIUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:20:20 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D7E22A72484253B44902;
        Fri,  5 Jul 2019 16:20:10 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 5 Jul 2019 16:19:59 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <oss-drivers@netronome.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] nfp: tls: fix error return code in nfp_net_tls_add()
Date:   Fri, 5 Jul 2019 08:26:25 +0000
Message-ID: <20190705082625.168515-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code -EINVAL from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 1f35a56cf586 ("nfp: tls: add/delete TLS TX connections")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/netronome/nfp/crypto/tls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 3ee829d69c04..9f7ccb7da417 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -344,6 +344,7 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 
 	if (!reply->handle[0] && !reply->handle[1]) {
 		nn_dp_warn(&nn->dp, "FW returned NULL handle\n");
+		err = -EINVAL;
 		goto err_fw_remove;
 	}



