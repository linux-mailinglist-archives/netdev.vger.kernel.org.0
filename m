Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1EA276EAD
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 12:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgIXKZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 06:25:45 -0400
Received: from inva021.nxp.com ([92.121.34.21]:38346 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbgIXKZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 06:25:45 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8308920024A;
        Thu, 24 Sep 2020 12:25:43 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C1C312002AC;
        Thu, 24 Sep 2020 12:25:38 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 43915402BE;
        Thu, 24 Sep 2020 12:25:32 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com
Subject: [PATCH v2 net] net: mscc: ocelot: fix fields offset in SG_CONFIG_REG_3
Date:   Thu, 24 Sep 2020 18:17:20 +0800
Message-Id: <20200924101720.31886-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

INIT_IPS and GATE_STATE fields have a wrong offset in SG_CONFIG_REG_3.
This register is used by stream gate control of PSFP, and it has not
been used before, because PSFP is not implemented in ocelot driver.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 include/soc/mscc/ocelot_ana.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/soc/mscc/ocelot_ana.h b/include/soc/mscc/ocelot_ana.h
index 841c6ec22b64..1669481d9779 100644
--- a/include/soc/mscc/ocelot_ana.h
+++ b/include/soc/mscc/ocelot_ana.h
@@ -252,10 +252,10 @@
 #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_M                 GENMASK(18, 16)
 #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_X(x)              (((x) & GENMASK(18, 16)) >> 16)
 #define ANA_SG_CONFIG_REG_3_GATE_ENABLE                   BIT(20)
-#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 24) & GENMASK(27, 24))
-#define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(27, 24)
-#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(27, 24)) >> 24)
-#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(28)
+#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 21) & GENMASK(24, 21))
+#define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(24, 21)
+#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(24, 21)) >> 21)
+#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(25)
 
 #define ANA_SG_GCL_GS_CONFIG_RSZ                          0x4
 
-- 
2.17.1

