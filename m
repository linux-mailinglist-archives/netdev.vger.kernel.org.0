Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7AC1A444C
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDJJLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:11:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12640 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgDJJLo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 05:11:44 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3B8F83AAE95254E9681E;
        Fri, 10 Apr 2020 17:11:29 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Fri, 10 Apr 2020
 17:11:20 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <colin.king@canonical.com>, <yanaijie@huawei.com>,
        <dan.carpenter@oracle.com>, <lkundrak@v3.sk>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] libertas: make lbs_init_mesh() void
Date:   Fri, 10 Apr 2020 17:09:42 +0800
Message-ID: <20200410090942.27239-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/marvell/libertas/mesh.c:833:5-8: Unneeded variable:
"ret". Return "0" on line 874

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 6 +-----
 drivers/net/wireless/marvell/libertas/mesh.h | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index 44c8a550da4c..f5b78257d551 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -828,10 +828,8 @@ static void lbs_persist_config_remove(struct net_device *dev)
  * Check mesh FW version and appropriately send the mesh start
  * command
  */
-int lbs_init_mesh(struct lbs_private *priv)
+void lbs_init_mesh(struct lbs_private *priv)
 {
-	int ret = 0;
-
 	/* Determine mesh_fw_ver from fwrelease and fwcapinfo */
 	/* 5.0.16p0 9.0.0.p0 is known to NOT support any mesh */
 	/* 5.110.22 have mesh command with 0xa3 command id */
@@ -870,8 +868,6 @@ int lbs_init_mesh(struct lbs_private *priv)
 
 	/* Stop meshing until interface is brought up */
 	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, 1);
-
-	return ret;
 }
 
 void lbs_start_mesh(struct lbs_private *priv)
diff --git a/drivers/net/wireless/marvell/libertas/mesh.h b/drivers/net/wireless/marvell/libertas/mesh.h
index 1561018f226f..d49717b20c09 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.h
+++ b/drivers/net/wireless/marvell/libertas/mesh.h
@@ -16,7 +16,7 @@
 
 struct net_device;
 
-int lbs_init_mesh(struct lbs_private *priv);
+void lbs_init_mesh(struct lbs_private *priv);
 void lbs_start_mesh(struct lbs_private *priv);
 int lbs_deinit_mesh(struct lbs_private *priv);
 
-- 
2.17.2

