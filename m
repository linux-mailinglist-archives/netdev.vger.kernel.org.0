Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9297D1C9DFB
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 23:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgEGV4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 17:56:37 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40540 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgEGV4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 17:56:37 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 047LuXPq128510;
        Thu, 7 May 2020 16:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588888593;
        bh=CiepMYUrdU135wGqDDohzrYL5klayaRYK1fM6UEdabY=;
        h=From:To:CC:Subject:Date;
        b=QQ30FGN+86wlgo3hAxA42imaQxX3nvLS9K4Acs6RwxcFsIPP1gjifF2Am7I8igzjh
         EYQzkUKJq2/ktgetS9rqK/NBNTg7rmBXvpJH5RTd8OqteoXy4lBlLOFoX/jCXuphyK
         K28GDlRM25/Q6A87fyg8FDXnHdaJ6GBpnM9NfKWc=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 047LuX9A027239
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 7 May 2020 16:56:33 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 7 May
 2020 16:56:32 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 7 May 2020 16:56:32 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 047LuWu3010621;
        Thu, 7 May 2020 16:56:32 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <richardcochran@gmail.com>,
        <ivan.khoronzhuk@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net/master] net: ethernet: ti: cpts: Fix linker issue when TI_CPTS is defined
Date:   Thu, 7 May 2020 16:47:40 -0500
Message-ID: <20200507214740.14693-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build issue when CONFIG_TI_CPTS is defined in the defconfig but
CONFIG_TI_CPTS_MOD is not set.

arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
drivers/net/ethernet/ti/cpsw.c:886: undefined reference to `cpts_unregister'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_remove':
drivers/net/ethernet/ti/cpsw.c:1742: undefined reference to `cpts_release'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_rx_handler':
drivers/net/ethernet/ti/cpsw.c:437: undefined reference to `cpts_rx_timestamp'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_open':
drivers/net/ethernet/ti/cpsw.c:840: undefined reference to `cpts_register'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_probe':
drivers/net/ethernet/ti/cpsw.c:1717: undefined reference to `cpts_release'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_priv.o: in function `cpsw_tx_handler':
drivers/net/ethernet/ti/cpsw_priv.c:68: undefined reference to `cpts_tx_timestamp'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_priv.o: in function `cpsw_init_common':
drivers/net/ethernet/ti/cpsw_priv.c:525: undefined reference to `cpts_create'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_ndo_stop':
drivers/net/ethernet/ti/cpsw_new.c:814: undefined reference to `cpts_unregister'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_remove':
drivers/net/ethernet/ti/cpsw_new.c:2029: undefined reference to `cpts_release'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_rx_handler':
drivers/net/ethernet/ti/cpsw_new.c:379: undefined reference to `cpts_rx_timestamp'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_probe':
drivers/net/ethernet/ti/cpsw_new.c:2005: undefined reference to `cpts_release'
arm-none-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_ndo_open':
drivers/net/ethernet/ti/cpsw_new.c:874: undefined reference to `cpts_register'

The header file needs to check if the CONFIG_TI_CPTS_MOD is set in order
to build the prototypes.  If not then the inline functions should be
used.

Once this change was made then a follow up error occured due to the same
flag error in the code.

drivers/net/ethernet/ti/cpsw_ethtool.c:724:30: error: dereferencing pointer to incomplete type ‘struct cpts’
 info->phc_index = cpsw->cpts->phc_index;

CC: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c | 2 +-
 drivers/net/ethernet/ti/cpts.h         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index fa54efe3be63..31e8a76d4407 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -709,7 +709,7 @@ int cpsw_set_ringparam(struct net_device *ndev,
 	return ret;
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_ENABLED(CONFIG_TI_CPTS_MOD)
 int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index bb997c11ee15..548af47fa938 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -8,7 +8,7 @@
 #ifndef _TI_CPTS_H_
 #define _TI_CPTS_H_
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_ENABLED(CONFIG_TI_CPTS_MOD)
 
 #include <linux/clk.h>
 #include <linux/clkdev.h>
-- 
2.25.1

