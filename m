Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121E05E9743
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiIZAbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbiIZAat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:30:49 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2111.outbound.protection.outlook.com [40.107.96.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADDC240A8;
        Sun, 25 Sep 2022 17:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaJ7EYveHIay/z9VUlON9QecPFj/tGbw291heuiZnJG8Lh8NlYyh/bTy9ARzqvzWl8RYY6sDUoOp7S7qqzOFBFo1l9ZqKDu6TabIznVT9ADUT7p4L/6qlnjizDV3m0p73Fiq7/kwx7mpklL+PmDsUBaz5F1jrgA/J9IPYQx6h2Mpb2dgUW8y636mGicSwDb8aeEZbOIjJmuv9ZHMG91TU/omDJBIOCaLItuErBo4muIEv0Bs2tVihyegjCWTMTxfxzJjrQaNP2TrxA3uQl6qLGHHbu1ub+3l0j4qr8NqH2fEODYe7neW0kKizLvUOLEYUVvJo9tbfhEiKHgD2RdmZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vn81VQPcg7fyfI7Pi5zpXYQOYF1SQdh51qg80ett7Kc=;
 b=m9BfOcgSP8zL0/Pa65L1HNzitDaRtHEPl4YubP4auoBWyKhqnEc1Xkh+qWV0N5OY+o+ie4gNAnSX2OsLXi1TFD3bw7fINFr7SxenlU7PdXf7HYub7Q6W+0NJ9xIbQhGobu8gZw7m5q+Jlr9eQiESchYwl3qwQ39osMPSGv9zx0Na/qxbGP3nnpU+2NsVga2IgjEQlFQQ4lCrAjb5GYNrwqvbNJTyaBneVafaIzhhfs8PTeJa5ZXI6EYZWLUxAAqZJ9Ngn/UOR0571mO6HLsupWXOXQNZQ3H3pVoVK7tZG227jzdigfnshCU1CLRszrg0ZhG7NyBdjJ1o/5MrLypfqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vn81VQPcg7fyfI7Pi5zpXYQOYF1SQdh51qg80ett7Kc=;
 b=HPB5Er9eEF2hOtJprxKiNZn9wPmiCB8tjquyJLHC4XL7/NtrvmwIxeIPMNW4M19xwYRRdvVw54yI1FTyCcWHnMLkR+kvEilhDf1NsbxbB6gIdNJsUI5AjzNJhkUvWcoRXmkqHxY6qZeKA+2gTtkAxMCC2w6okH6+lZ6jxBulUn4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:22 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 05/14] net: mscc: ocelot: expose ocelot_reset routine
Date:   Sun, 25 Sep 2022 17:29:19 -0700
Message-Id: <20220926002928.2744638-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c256a0-6a9b-4b07-0a27-08da9f564b8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h/MSRemMLfgzKQE5xtELx+8oiZXxr2LnvJCIjfRkMBVu1clzJo4XaLPdcVfQ2+Mh58lAElMJxv8Xo90v/K2MB5AT29XmP5IXVvKDPzlaHYue+7mfOhVrkpGJrYq3PsD3QDDV8rgOgb9lvjzq0gblj2VEmI4t1Jb0PcrJZdNDNZzh1ih5s6q9ETqPZrfnJhBSfakwPIKdatnjlvHUaY+fDqkBMrGUAQRzNL7TA1o0Hq30gQJ37zHXFWXgxvlqunRtRvs2yWwCmhPcVUQIN/BFuApFIgSswDSNXQv/6Qwsm6GwMRwNI1IFSWZfhMOVxfvfO9qVrNs+jgZbFG4kVfju3uv8N86cJTTw+EO/DJe/jzVx2QdM52pwHuQMJEkqcluKou1xUMWVnJI/OWQWtfZkQAvsLTYiLrGAqbsW+uvAO1WYzn0Ha/oCrg14eGOLzdpGaXEnRvetkJI97P+VWSv4keGyo3RiAkG+Wn8tQ6iurxj7tM4e7nxKQVJGvPCLx3UyBYAaresMYgUMbG6+6lu3uyOzFZXfvAwS/m/pCHqGYUBSK5W5Luotoy5Tw2v+cwW8D1KfhcycZ9jiu0uCRjr8dZALYtG7aJDnb1muCj1pMiRp/IzYWTtunob/hVNgtSjlSHkDpv41yjPzcai0lXySiIJFvNYGBfPn0fPVAPNHfL1/eMeSkawnulwDKsprasw7kCr2zsjhHXfj/CaTXwEYiTFpjyJrJOzjVoa4+uBruBiTY5TuytuyqVNjYSSwB8u7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(6666004)(38350700002)(36756003)(44832011)(41300700001)(83380400001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wTAa2CbnP8ySGQd9OlDZApFwgvoDfLhzcgLraPc5Ks94tEYYefy6+g1NVFrf?=
 =?us-ascii?Q?DpAYHibzin8sxkLbdcV9jmUvnYn4Jj9BMNV9Ib0s8kR6+VFcfY19CeuLwqZr?=
 =?us-ascii?Q?jBrHaQpFUsj9kcjFVWeKs6lVQ17nhehUTs/LJPd9WcRDx3p8gHZW0OAyxpxP?=
 =?us-ascii?Q?FbxOCVnDtVPkS8rsOCOVgkcXnNtcAHzRnbep414zgrYkUBJdTSjofpHNlKm2?=
 =?us-ascii?Q?f/I9W1j9YBLvbjSye7IqD1Tz17lA6RayOJOh2YoHsjLXL9HUo6nWfq8DZmql?=
 =?us-ascii?Q?fj4kimpNxlk0z8qHICBU7Xs6n8ma9LalOZLmtHYfQRemzymD0T2eso8ndQAu?=
 =?us-ascii?Q?EFM8Lx0adiO5xTcdRk3tMdC1/RpNMyHWbGG3PAremFkvIgak1EuzArbBurWm?=
 =?us-ascii?Q?wAimXxxBsvcw1vfJu3VxoyE7Ol4oYXrpFt6pnZ5/oeH/ZgEffg4wCPXdjdJ8?=
 =?us-ascii?Q?GgDKP4z1pQdrpuUsZcSM0/slC6aDCRWfqJCT6SlOYEBWJOGI/CIuurgUhglG?=
 =?us-ascii?Q?5U7FiGA9ZG2vwtLvGgUGMNgTL4TfUYbyiZ47h0/KHiApG5xAW03Fdd0d0dkx?=
 =?us-ascii?Q?dVXI3VF/gvKXKtIefk43EjK4Ofl0jjv9fbZIDHmYSIpvvQkNYodb+Yjwgxje?=
 =?us-ascii?Q?yVFwCJpTIPpIiKugMVsSQ1tZasXp087TU4GyBPVxTGyO9XLtbXkonesJ+0ys?=
 =?us-ascii?Q?D9wmTrhNrnYg12pFuCE0wwiGWYZW108p0Z+pxSIKkMzAXp7/5dyjgsqhkF9Z?=
 =?us-ascii?Q?SpqvW1fan9kd858BZZbl43ZkEMGyP09LTYKTAvx7gWca/W9CvbZKTVSZutU+?=
 =?us-ascii?Q?kP3iVfJMScw5GUhrJzAOwC0BCEbuXM4HWHBofj8+bDHViJ/LAQ57+oG36sWJ?=
 =?us-ascii?Q?dubXJOu2FW3YxNfD2WrrMpFfAuVO3by/rgLXVXQubUGd9FhGXHqDMSCSkgTn?=
 =?us-ascii?Q?i9lYZUEtoTuUeMC+a8gf/GIKzPsF7H27NWm33s3sVvPx4G/Lml03zS7pMAZz?=
 =?us-ascii?Q?MCI2vXJvvzEVnE7wv69ltIgCl3LCDu8RZwXnfQGRVfHQ8/ORCWUMM8CY+FwJ?=
 =?us-ascii?Q?3TMFXvZ6j9YzrK+Z6xixBEZC7gswH22UD7lKyfXjcNp5aHedQTwwAookWTU1?=
 =?us-ascii?Q?bWfUAH3FoVZDgodB9IvlkK8huwKZIdaF8tCUCTkEG31vAYhV47Qh+DfvUDf6?=
 =?us-ascii?Q?92j611tnN0yfkCLJHHYe4fEy/nhSie4H4gCa/BWkRfNlBa9ll7hqSCbWTOUK?=
 =?us-ascii?Q?/t0s0lAWbdbf8T7mGzTDxsw8B1VcpOGmQLuq6TLcvIdNlfmKF8elJ4FGQteM?=
 =?us-ascii?Q?tJpT0cJhTR4ekWKyZn3JnI+n3uybewebHFQ8hauOZAuT06aXWRgEfWRdQVr3?=
 =?us-ascii?Q?+AfqBMXeLF3OgjVL/KuHsyu3Mr/39gjskWwFcVCMJVWiB98dEK0yhcgPr6W6?=
 =?us-ascii?Q?Nfh+DmjmtqgvxaVXoLeUQhbtycv+xhvJL/tPTvFq3GWeyqWXj2RPG4PRZvTb?=
 =?us-ascii?Q?7qIlD6wZLjMs9fG7+SCWbYvEgZwbxP14kNC3phzLfRUztqtkSQ0cEolWekTG?=
 =?us-ascii?Q?0CVdaDjN27BpPzmBZoyQsKqOB9Tac5a3i7qdsiRVIzaEC18ic7o6cpRBAC9A?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c256a0-6a9b-4b07-0a27-08da9f564b8e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:21.3075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDgkrygQsNEKVDVSMG0wEepYp/9l1GI/rmLI7lOi3hWmMhkyysvK2U4TI30zKx3jOxHpZpj7l3EAcM/Z17Jf3ZnKduCpJQqbHrIQBuKyLoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resetting the switch core is the same whether it is done internally or
externally. Move this routine to the ocelot library so it can be used by
other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3
    * No changes

v2
    * New patch

---
 drivers/net/ethernet/mscc/ocelot.c         | 48 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 44 +-------------------
 include/soc/mscc/ocelot.h                  |  1 +
 3 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7a613b52787d..d43106e386e6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -6,12 +6,16 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
+#include <linux/iopoll.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
-#define TABLE_UPDATE_SLEEP_US 10
-#define TABLE_UPDATE_TIMEOUT_US 100000
+#define TABLE_UPDATE_SLEEP_US	10
+#define TABLE_UPDATE_TIMEOUT_US	100000
+#define MEM_INIT_SLEEP_US	1000
+#define MEM_INIT_TIMEOUT_US	100000
+
 #define OCELOT_RSV_VLAN_RANGE_START 4000
 
 struct ocelot_mact_entry {
@@ -2708,6 +2712,46 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 	ocelot->num_frame_refs = QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(eq_ctrl);
 }
 
+static int ocelot_mem_init_status(struct ocelot *ocelot)
+{
+	unsigned int val;
+	int err;
+
+	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+				&val);
+
+	return err ?: val;
+}
+
+int ocelot_reset(struct ocelot *ocelot)
+{
+	int err;
+	u32 val;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
+	 * 100us) before enabling the switch core.
+	 */
+	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
+				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+}
+EXPORT_SYMBOL(ocelot_reset);
+
 int ocelot_init(struct ocelot *ocelot)
 {
 	int i, ret;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 19e5486d1dbd..822b11d33288 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -6,7 +6,6 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/interrupt.h>
-#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/netdevice.h>
@@ -17,6 +16,7 @@
 #include <linux/skbuff.h>
 #include <net/switchdev.h>
 
+#include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_hsio.h>
 #include <soc/mscc/vsc7514_regs.h>
@@ -26,9 +26,6 @@
 #define VSC7514_VCAP_POLICER_BASE			128
 #define VSC7514_VCAP_POLICER_MAX			191
 
-#define MEM_INIT_SLEEP_US				1000
-#define MEM_INIT_TIMEOUT_US				100000
-
 static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[ANA] = vsc7514_ana_regmap,
 	[QS] = vsc7514_qs_regmap,
@@ -133,45 +130,6 @@ static const struct of_device_id mscc_ocelot_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
-static int ocelot_mem_init_status(struct ocelot *ocelot)
-{
-	unsigned int val;
-	int err;
-
-	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
-				&val);
-
-	return err ?: val;
-}
-
-static int ocelot_reset(struct ocelot *ocelot)
-{
-	int err;
-	u32 val;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
-	if (err)
-		return err;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	if (err)
-		return err;
-
-	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
-	 * 100us) before enabling the switch core.
-	 */
-	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
-				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
-	if (err)
-		return err;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	if (err)
-		return err;
-
-	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 55bbd5319128..9c1c9b8c43f5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1134,6 +1134,7 @@ void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
 struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
+int ocelot_reset(struct ocelot *ocelot);
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
-- 
2.25.1

