Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAB3640241
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbiLBIfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiLBIeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:34:06 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DEDC2A;
        Fri,  2 Dec 2022 00:32:33 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NNmQk5jq3z5BNRf;
        Fri,  2 Dec 2022 16:32:30 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl1.zte.com.cn with SMTP id 2B28WIvG038639;
        Fri, 2 Dec 2022 16:32:18 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Fri, 2 Dec 2022 16:32:20 +0800 (CST)
Date:   Fri, 2 Dec 2022 16:32:20 +0800 (CST)
X-Zmail-TransId: 2af96389b814fffffffffe9e185a
X-Mailer: Zmail v1.0
Message-ID: <202212021632208664419@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <davem@davemloft.net>
Cc:     <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <petrm@nvidia.com>, <khalasa@piap.pl>, <shayagr@amazon.com>,
        <wsa+renesas@sang-engineering.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzZmM6IHVzZSBzeXNmc19lbWl0KCkgdG8gaW5zdGVhZCBvZiBzY25wcmludGYoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B28WIvG038639
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 6389B81E.001 by FangMail milter!
X-FangMail-Envelope: 1669969950/4NNmQk5jq3z5BNRf/6389B81E.001/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<ye.xingchen@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6389B81E.001/4NNmQk5jq3z5BNRf
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/net/ethernet/sfc/efx_common.c       | 2 +-
 drivers/net/ethernet/sfc/siena/efx_common.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index c2224e41a694..cc30524c2fe4 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1164,7 +1164,7 @@ static ssize_t mcdi_logging_show(struct device *dev,
 	struct efx_nic *efx = dev_get_drvdata(dev);
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);

-	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
+	return sysfs_emit(buf, "%d\n", mcdi->logging_enabled);
 }

 static ssize_t mcdi_logging_store(struct device *dev,
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 1fd396b00bfb..e4b294b8e9ac 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -1178,7 +1178,7 @@ static ssize_t mcdi_logging_show(struct device *dev,
 	struct efx_nic *efx = dev_get_drvdata(dev);
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);

-	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
+	return sysfs_emit(buf, "%d\n", mcdi->logging_enabled);
 }

 static ssize_t mcdi_logging_store(struct device *dev,
-- 
2.25.1
