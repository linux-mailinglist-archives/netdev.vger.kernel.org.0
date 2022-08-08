Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1503D58C937
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 15:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242074AbiHHNQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 09:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiHHNQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 09:16:43 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0177326F6
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 06:16:39 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 92CA57F4E6;
        Mon,  8 Aug 2022 15:16:34 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DD2B34064;
        Mon,  8 Aug 2022 15:16:34 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65F643405A;
        Mon,  8 Aug 2022 15:16:34 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Mon,  8 Aug 2022 15:16:34 +0200 (CEST)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id 3BBAD7F4E6;
        Mon,  8 Aug 2022 15:16:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1659964594; bh=uDzO/yNrbg+G2BaP955QMhTzYyQwe92qea7bNGeRVGU=;
        h=From:To:CC:Subject:Date:From;
        b=k4xAPyrzL6+Ib6t5NMqVE0P/sREzKN8q8pgVgGNXfSr7IGCMLbNsSsKVmZKOqqQ0Q
         BRXR2yUvAiM01xbsY1Nb1owNtXhAUbw18aLnpO3BZexb4BenRcFw70kxGistudLsfV
         nG1VGY9Nq9fm5H+Fw6xQaKikab+EXu+hAuRKrtzh2ZKm1KiehE7FwZWJldrO/SGb03
         mdCLvnO76n4pPN/kJZjlBAtpxt5Tg+ef9N/wLdFu5Qoc9YViwAh6cHzI7gMoYoFyNy
         KSGXm7dlE5u8ipWyGv7xuuF4eiW0U5NtV+XCmbskrsHOzcC+Q2i18hCI7dQu9IaTIR
         cHQn3Pld0/WnQ==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.9; Mon, 8 Aug 2022 15:16:33 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Mon, 8 Aug 2022 15:16:33 +0200
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        "Richard Cochran" <richardcochran@gmail.com>
Subject: [PATCH] fec: Allow changing the PPS channel
Date:   Mon, 8 Aug 2022 15:15:57 +0200
Message-ID: <20220808131556.163207-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1659964593;VERSION=7933;MC=2386539450;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29A91EF45661776A
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Makes the PPS channel configurable via the Device Tree (on startup) and sysfs (run-time)

Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec_main.c | 37 +++++++++++++++++++++++
 drivers/net/ethernet/freescale/fec_ptp.c  |  3 --
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4112c1283c40..0c1c489c3826 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -47,6 +47,7 @@
 #include <linux/bitops.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/kobject.h>
 #include <linux/clk.h>
 #include <linux/crc32.h>
 #include <linux/platform_device.h>
@@ -3609,6 +3610,36 @@ static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
 	return ret;
 }
 
+static ssize_t pps_ch_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct net_device *ndev = to_net_dev(dev);
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	return sprintf(buf, "%d", fep->pps_channel);
+}
+
+static ssize_t pps_ch_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct net_device *ndev = to_net_dev(dev);
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	int enable = fep->pps_enable;
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
+
+	if (enable)
+		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 0);
+
+	kstrtoint(buf, 0, &fep->pps_channel);
+
+	if (enable)
+		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
+
+	return count;
+}
+
+struct kobj_attribute pps_ch_attr = __ATTR(pps_channel, 0660, pps_ch_show, pps_ch_store);
+
 static int
 fec_probe(struct platform_device *pdev)
 {
@@ -3705,6 +3736,9 @@ fec_probe(struct platform_device *pdev)
 		fep->phy_interface = interface;
 	}
 
+	if (of_property_read_u32(np, "fsl,pps-channel", &fep->pps_channel))
+		fep->pps_channel = 0;
+
 	fep->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(fep->clk_ipg)) {
 		ret = PTR_ERR(fep->clk_ipg);
@@ -3817,6 +3851,9 @@ fec_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_register;
 
+	if (sysfs_create_file(&ndev->dev.kobj, &pps_ch_attr.attr))
+		pr_err("Cannot create pps_channel sysfs file\n");
+
 	device_init_wakeup(&ndev->dev, fep->wol_flag &
 			   FEC_WOL_HAS_MAGIC_PACKET);
 
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 69dfed4de4ef..a5077eff305b 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -86,8 +86,6 @@
 #define FEC_CC_MULT	(1 << 31)
 #define FEC_COUNTER_PERIOD	(1 << 31)
 #define PPS_OUPUT_RELOAD_PERIOD	NSEC_PER_SEC
-#define FEC_CHANNLE_0		0
-#define DEFAULT_PPS_CHANNEL	FEC_CHANNLE_0
 
 /**
  * fec_ptp_enable_pps
@@ -112,7 +110,6 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 	if (fep->pps_enable == enable)
 		return 0;
 
-	fep->pps_channel = DEFAULT_PPS_CHANNEL;
 	fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
 
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
-- 
2.25.1

