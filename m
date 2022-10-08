Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0731A5F86D5
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJHSwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJHSwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773433F303;
        Sat,  8 Oct 2022 11:52:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ehff2GSoh1aXWRMV6RkMrpAWjge6wMfMp3lYrx9IjH16Dw4+Y6lPUVNzHUKAeZpHy+fR+ZCQCMgLoJoeLswToML9q8Fu1yBO+cqNdUu9KKghQD+OXK1bBl8s7N1Zgd5ZGTbiI+kAKwE7HvtVnkvOVuhUfPHHe0P2GiTC4B4eucfl4pShVeDSoxy332GWjn5fvfmns3WA7newF02eEbC4uIIJGTK32g9s5YTR0ChfgW8RuoVPeuVqC+0/bTI3PoSCWuLpq6+5ajCZ8B6/fRSemj6Wk1FQ0bUNlv5VI/YD2CJnESqYbvI0pawn2QBN/6upo/FX/SwxowMopQ2cBE6o0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSsvqZQO8172AJLA2gQWNHd+JAH1FmOhkhhr+HGlpN4=;
 b=gICywi1nWD40nZ5GjwdnXFlTPZvmoSy1TgRUujOvT4O6CK4sYshDHlIBBH1ia785D2W0i3ZxImvDykfFpfnAhUWi9TksJXnCnniBR5geAEQzLrwE1pPVw09qmv/eqly0mD67p98ZMeelRCIYPazshXZMZtjd2R0jDRd3cpAU8y7DX1VgNEd/KqKb7KNT1Xv7D0t+LWVf1+3GLiQOxFBA3pVOAXavbZRjypAe45cCbTEpVGLh9dR+zlylsomC9p760VcG+rR5pEexKsGcPtzsh1AJkRaSIJ9MNO6NfuKOwv3CfTaqRETNrWUzCFwxDUWteZUflbcOa+aDilcCi+DqxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSsvqZQO8172AJLA2gQWNHd+JAH1FmOhkhhr+HGlpN4=;
 b=F2gIpQ4kl3FzL4vs7YbJGldBrRwu//FJjfMI4f7TsJpOCoYv81W3ASG6oRT5gLZLyhKh0PRQVGnsBmHGQWw2yYyKZxhXsMcs7UAB+OpAta5UtYA0qq1rk5vRe6ORrqko4F3S/rQdIOg8rOgBo9Zhks+Xd/0Q+1jLjmYVPpgeRAU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:06 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 05/17] net: mscc: ocelot: expose ocelot_reset routine
Date:   Sat,  8 Oct 2022 11:51:40 -0700
Message-Id: <20221008185152.2411007-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 55aae863-2e74-46ad-6af2-08daa95e323e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yo9N80e/hwacVFQ82Wftd7bpyU6qzCb/+7oN+6SfGhEAVzMSCePMgPyrNr4me1sdXUWI4rYrnHSqX60Ds9lgPPAsO9vfIUJvDwl0NWD5cKqNpFBsIfuoBA+ajnFoK4gyLsvciroJ1IDpRdpLBozFzGhpCnDiQawr/DeWjcfzDia+IgK4Id0KxBRrpic01ANhLE9bOioh4LBDvMMszy4+n5C6BLz1q3W/JBqyh2aSR6oaewYz9vZnreWf7ZS4LhXfax8QR7jdenm2D8gyNVAi+cBThSm2CAeUfTM/Rt9KVl9xS5dR79YEmslDDz/59fZlF/1iim9VIF/bhhax+WEbvRrxEW18LRJQIML81dFcgO+IErFehjzYggYVw7fAEOQOdL12I1xP/6OygFQfLnZed9OfNC+td8WFDWOD97S7u+3QTuWeMksu969BxORpDTNNeFC1MRv4BZ2AxXUbd/LFscxdm22HMHdACGDYoVbIUOcnZf1+sKOrY7e2uaeDZuPVRIcGOQ/ayTvQghphrZ268+3Q77HaSWh8GbpSAOo/0/KFLjzizwxj5RAIPaUZXh6AMdNmL6hscajhVVnCD7Az+HMQOiG7awlky+AbjICDBhNkwN9VNTuiPs/XsNQATFkPXnv4ePhcCiuwo0Uyog5hHV+wrJ/2JHIe475Xikdx9yF1M0TGLrUitD8wEazjU3ZO6kgbf4WtodOTJr+SnqKxJL3LcBc9TTdy/3nLy1h3fuFChzNTgz2B1gcA8uikmv/y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h69lWA8b6IT/eHqV5vdKnWkrYHXUVF1+NjTeV5gWPc3DVZNkxTnMZkb3fiTK?=
 =?us-ascii?Q?90kZi1y2B/HqGrtG+oFCVRB4udrYlz9dqBFvPlll0DIAIUlMam++9Iq5px7v?=
 =?us-ascii?Q?a1/5TrbRNa6fnzhJ6QOYUx5i+4rUprgOn+KGQKP50ML7JWgbiP4nn1ogzPEz?=
 =?us-ascii?Q?ciuyB1Px+sz6fGwQXXLmK/AqwB6N05D5ur06E+Q6eINgNtxN366pVWBgqdkL?=
 =?us-ascii?Q?FsLmyNd/sYotXsaXBLjy3oZWGCE/VoqTXBt2bJzL+sUjCLY23fvzxztzAkyM?=
 =?us-ascii?Q?QxrvLVbOkHu4W2V++NkWHuG683Z8jHhy9soBlFSMmKSPU76AT5j9h+UlcoRB?=
 =?us-ascii?Q?5f1B201xuSS3egCJ5ePYuOoMaDc5JjQ0pGpqCisM7RHOBb0Q5fb7SD9AYONi?=
 =?us-ascii?Q?et22O5Po06r/FLiYwwGePxw5V3JWiQ48zlrUN2UFfAoyVxbnrSqci7n59UHv?=
 =?us-ascii?Q?oUpXiCio3CdY5+gbS9bWUvc/TU5Zh+IAw5i7mchNRcF3TQsI11WZh3+z4Ey4?=
 =?us-ascii?Q?WMXKREVo36OlgFsJFGPIPli7xsnwnLNbGwqIk2nsPMEk+CWCMge7j8J1YYXG?=
 =?us-ascii?Q?wchqMOSk82zYju1liGndIIV7QluiCU+vXtvYT/YwBM7Z8EyEe0cx/ZjQ1/t3?=
 =?us-ascii?Q?oKFzih2F4sslGXM+bPr/0KJ8+F/d5mLlE+K531Dbn7o7L49sIedmu9AXxJMS?=
 =?us-ascii?Q?Qp+vSUooomBzxfxKRLPByMQKTGDHHX/LSl/hXlTlBqAY/6BK0IBEjwhKjLQh?=
 =?us-ascii?Q?QXDV3z1nLMbTJ1TveoMpOiB9Wf06pU195SESt6smUTiTcvf7GUy40b3OsQyq?=
 =?us-ascii?Q?xM1jPtqMFkzs/5r2j7roQYmJgGhVqPuXA2Ay0yUxzOpfRv0UeNYM7gHXNSRZ?=
 =?us-ascii?Q?2McZ0sIKc6cNwjnK1TENDZWbgi6PI/BGk0a5m2AKoT9bgxtYd1kJO/L+gjEd?=
 =?us-ascii?Q?7j9E2ReaVrB94lQgirCmkiGj78AWhne661zqSOpUdhRWqlheViEmw4zmKrqY?=
 =?us-ascii?Q?aSYHlg9+2lvx4nJpDhGjb1cu0OTZyaMsB0QrlSQtEojN+RQp8yptFGbz9qAx?=
 =?us-ascii?Q?FH1i0JETMxwNDHgS1j29Yul08tcBelrqmf1f9MZQfKnAko7GFuzMVHFy3qeL?=
 =?us-ascii?Q?yOjP6pFiKyjG+q2QD5b1ixB2ZZsHpFs/PXLh7/bIEcG3vytYLzkgyZfwxynA?=
 =?us-ascii?Q?/63DJ6B3y5KrM+xBkBsay95K/7H3BzzL6V7yIWyL0Gr7Lf7SaPXccQlnFSIt?=
 =?us-ascii?Q?dU5O1PTUCIQaGvqBCfjG5B5Iw9sdWt40H4MmW79WrUgSVfVA091kuKGLCRo5?=
 =?us-ascii?Q?pxSbgQMuS+1JC70bumixpDP4d0kriSVwb1O/2JDp88lGI5letcI3SwoMgumK?=
 =?us-ascii?Q?2EDWbe32lPaHb0QEe4m0ZCqWDy7zZwX8RZbrFPtKqzjZ1peAkWoMEHpd/SPl?=
 =?us-ascii?Q?GDBe559vgVNyzT9x+08Os0mZm5grjnp5OzXhCvIEFo+v9uvxkSBElR3Py3I6?=
 =?us-ascii?Q?lZosBs1HnmiT+EdTNZKtxRNUZrj1LbjepKtsqf5shfTn/y4Mfo6cSZ4V+0AM?=
 =?us-ascii?Q?vRa4uS6ym/cfHyhswIAEXIyQPwYv/irJCd4Kg7B4Vu9rS1PU/qYIwWZm6+mn?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55aae863-2e74-46ad-6af2-08daa95e323e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:06.3348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mdMSilP/UbPfAaREjV+jUhZyloPdxvmYllvZlHYxAfo6xYHpfoiZ9105wfQr/SHIkm+EoX6X1LWNlmUcRcDOUXlUg61f8AB6hXk2dYSys9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
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

v3-v4
    * No changes

v2
    * New patch

---
 drivers/net/ethernet/mscc/ocelot.c         | 48 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 44 +-------------------
 include/soc/mscc/ocelot.h                  |  1 +
 3 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 13b14110a060..432eca7dcb11 100644
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
@@ -2715,6 +2719,46 @@ static void ocelot_detect_features(struct ocelot *ocelot)
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

