Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE005ABA72
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiIBV6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiIBV6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:19 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCD3F5CE5;
        Fri,  2 Sep 2022 14:58:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FG1YEhbqDjjEotQXGPFXYyhW1WbXO2L4sDcag4nUW/qjwVjtAocEF8y0XHKW1pngBMQ/aAwJWE6R0WM1YSGHhd+y+n+fbnOycZH6sAO4uKmz8dFUAOTWsft36V8+xAqHAsVgig1M3OEd0hAs32+l//9N/C3WI43Lh21NlVv0GJIvMHAsni3BtW31CO50cDz43D7LSjmCZHlTrNszY6leu0uPxeRzHBjJQdxegCPhbJVdn4YfyKfbxO2mo1jndd6S2FvQmY3ON2QxeyT3ZruXWwdltYAzPjz/luHSecxQ+Z6hcROIL2fpfXV57OdxE32AxXGLTDvFm7GznEXkBvMwlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9E0GJt9fU5phIpRkKfisX6q0VW/4r7DNqN8cQ7wYNw=;
 b=faWDpi+5mrGJ/2pZIB40xkHIV3bV/UAENx1upYznJDpetLq4CoHGIchD+DbBx04vVO7ud4WO/juXSe9ILn34MJJhUC8H0ZqCRuw8KsipVqvv47TsqBESGEhv9Lkx4Q86NIxwMvhHGX/3RL0ttTG12Gr75CdhK1j/oFVAilNOmH+QW4/2uw/MYyjWWjXPOQzqLE25CgmTyTQl5wlBDmwFVSHmQzAKbDVxTMmF27qWD39RIACQFhm9T95iK6HY24O8AC8Gu1wJJPulZSKZDwUrtXLGI1zTNCvAmT8cF3DW9De5YHa+iCz4ENwxntZTPRyCUVEqQs30U9HylAJk201sQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9E0GJt9fU5phIpRkKfisX6q0VW/4r7DNqN8cQ7wYNw=;
 b=DdlAt5haWh9LSb6MFNlT8JLXuLhxlG8FPQvzZiJ6tGeuYunnhM9a0yQwyyXB3hEcHMTG7TScyJ+exESeYZI/MXlWku4IzUmW0vukChTb6VahKDL0/S9od8F2MnGCdUnjD0rLWvXhXXBvF1VaQWB6UWbOvt7HEGYEiaQrhpuquAHAnM4JN8JWGtj02YLlZ3PUqcJh5kOQRfLALgQKDOGfZwzV5F2lcfutRc8XTGN2JdkSQRM78juoOvzH54uk3vO7nT8Jny7P2aAfmqMWZCYI6O9OAtHzR1o7QuLwAdn4DKs5+r2YVdPFR8Ffi92HbXsSP1QLx774KG7SmTBNClfqIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:57:50 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:57:49 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 01/14] net: fman: Move initialization to mac-specific files
Date:   Fri,  2 Sep 2022 17:57:23 -0400
Message-Id: <20220902215737.981341-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 596ccf31-2bf7-4f82-04a2-08da8d2e2d65
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hyWfpymuZGSJAzNl/lpWJmNeKt8f7rX2ZvB7ORJ/WhHwMGuymCslDM5D+5KeVtAtyIRtmnqJu21W+tBXJa9vErUwMOXoe59lsz+0xn3uV+JHthezXnd7C8nfIbjfuKMc5CeC2KyypL8bs1HifXm4g+WQOLOZ6WsBbgvq0SqUZgvU5tmb8wFoJUduBkWyBtCZAo4+AzIsAKgMzDzQntUPQ86d8Q6BmfuDcmRCBTCkRSZMneqwFwYZzts475OzxCnx22wVQF2FLJk0YDEIUo/vmhS8C8jVsxIODPGno/nnz5TvyG13Bqb9EZq7zsUmd08pOfZFEZLOTJPFfwZFWKIk7TfJ9Sb9PqTHBKSbkCroNv/fkux24WZbY6H/mN0oZJrImOIsYp7UxyibZhmdcbawMe42TnVbUoewDSqwz54NM9rNIBe4a89ekB2QwVLTLbL968HCRTRqxw04hu6ktSxdYb6vyZs4IZC3iaTXu7wwY7eIawgYp2yDzLZrLFBVUf8gqnEAGF0/t/EKSdhQ0e8gppKtjGb5ZGUrR1vKyB5Uaohm8ZIul2WJHZVPw8NIEyyxIqky+lIrL++caab0sAn9URjTzGVg+rfjik74Af8dBFSDWrQMPLHmcGoPZt8xuGnMHJsF6BU++DZ4EdNMoBt0B8TxGTV8dpJW8HFU4vnsDOwPobfaipMlA9F83GURiQKPse52PjsvMmKgV1FvC89XuFOC45jGTL/4qRXnmYi0LEvDGce/nNA31eYkJnWnJpBULfiG7VFj26TV7a3V3qpCaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(30864003)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kKdayp1ZM7yymxvglW1R7Is1/nvXkd4+t++lKa8cfdtcxigoP0xzQZajTdPv?=
 =?us-ascii?Q?UCW0n2iC3XRQszDTqSCoVVnjSVDXOO1x95weMNKfqJanENbMSsKO59vOoCDV?=
 =?us-ascii?Q?xXzyFKo4bYHfjhxYvP0241lMeJBON1Lk8oO3ccovPeFRvadn3NBZspIdYq7P?=
 =?us-ascii?Q?jxz2wN1WwJiU/uEbIN91o5NIQLFss9I3YWAbZ+IzaIa5vQ5LF11usYjpYPCz?=
 =?us-ascii?Q?PMoooAoRURf67NNuCqaxQZKmYd9/5GuhRH68r1IFJYtYmR6VxQ6ad6y9qJZF?=
 =?us-ascii?Q?JxN/sNAhFpy67RfCBI3gK5roSryHiv9ZIm2rPqsMxZdVTWKJogi2kqAvnE/l?=
 =?us-ascii?Q?qXyZAP1ODIRXEFm7RWY4x2CfFWWFIAiETWyfOQ4AeaBujk4tBvC6S/vEmnQm?=
 =?us-ascii?Q?YOglnyryFzdR1QmO8EFQ5tA4tL0PYaZMJkVI7bOiYfbwMmaSwOIYXDLz2YpG?=
 =?us-ascii?Q?YLq0nSJdBvRhf8xrqjfkIDTBPbBxy/mrrucV1LJfF3OTyCHuh3huRjw7YdbG?=
 =?us-ascii?Q?/G8fIcyXtU+LgfllrRRx2drLTcP+qSUf1hYV426haVW6Yzh3nDs7o3jyWP6c?=
 =?us-ascii?Q?/PMwhd/p5f79G5lBoBbKRt6sjuhsNcPfz7fjs0clFQdrQJrwV/XWJ2yISI68?=
 =?us-ascii?Q?ohLW+EL7Zd4qzxbVHlYt38YnKAaGRAO3Ri5omoFlk4jWi6toYmRKrQ/wm+TG?=
 =?us-ascii?Q?J22ZqiOv9HbsDgLDKP9qYi0+iXHrOIo+At5TI/8GfInZwSB2gN3lsQOw788g?=
 =?us-ascii?Q?GZSWUJBLjVEi6vEA6yiS9IUzRFvoyVZ5EtaXAK9nqh70WU4iy1/H1flLqH/4?=
 =?us-ascii?Q?u9FqixrgXh6C7Wl2FNUfOxwZrlRS50vjbnp5MusgiJYA1IJbIGfj9zTC4nhk?=
 =?us-ascii?Q?288YjofIm9SFsLjeTSaaKyEn1+qq4UDAnbPcbJsEIYv59tPQArBbvSTsU6o1?=
 =?us-ascii?Q?uzcDwpxFoGAbCn/6XGUwlDOdrVnXEyoqpmFgsCMfcdrq5o9ZFVBo+jbsFJwf?=
 =?us-ascii?Q?/jJ7IXrPEHEf5xB694OiycdSUaYRtlrzCVTFjkvGoFKhodGerzAQhdL+Ndzy?=
 =?us-ascii?Q?92wl5bcNGZfihntdIfoZf5LF6VjhlN5GTE7ptjoY6CUA3OPw8w0j2yO8GdJc?=
 =?us-ascii?Q?ODbKQWmbeu/DeoBq9UU+7YE9+7+4ZJ4AFMeXrWyTl7J9n/HvEW3kd280K4QF?=
 =?us-ascii?Q?rxfQNej4VXoGz2OFCNfFQmVB1+QGjXhmrukq+HFffWwB82o5k9A57NKjSPxq?=
 =?us-ascii?Q?SzGu0bUHWwN8avLkYwXXXmcdj3qt1EnqHihQVG2F1jcQ6mQMtHBSp/+lapzg?=
 =?us-ascii?Q?qvRH8bl+qXqM9Rr5ArT3v0QTFrE47Pn/lOPrWFI8Glv+XwOSNa64pOqE7KM+?=
 =?us-ascii?Q?OCVHaGnjIgdS0Gk/2JePyC52LLLdoljIyT5WExUxYDL7n60roBVQTG9CI0y1?=
 =?us-ascii?Q?Cj3zv70F1HE6ku41hRXWAlVFqB1s/4IJW23Au20DhzxWVvFhYWylLblufioz?=
 =?us-ascii?Q?0wr7AU94qPEcJEhwifML3bve+n10N0qRZ5XWM9tcGF1wI9/4GZtmDOtzE9aA?=
 =?us-ascii?Q?hOL7UvT5KiHaUhV0jyJ6rAVnyNx1w1ra6xOq5PWn9hYkjob85dUmIf1ZKhaM?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 596ccf31-2bf7-4f82-04a2-08da8d2e2d65
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:49.8765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0owOVscGIkE9E3ezskAxtNfj2jOAMuiRmyBlEPUCg4tABrN4VlfKkbXBkgvMOXbN15SeUYWloOSLcZ5LU/O+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves mac-specific initialization to mac-specific files. This will
make it easier to work with individual macs. It will also make it easier
to refactor the initialization to simplify the control flow. No
functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v2)

Changes in v2:
- Fix prototype for dtsec_initialization

 .../net/ethernet/freescale/fman/fman_dtsec.c  |  88 ++++++
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  26 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 113 +++++++-
 .../net/ethernet/freescale/fman/fman_memac.h  |  25 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  65 +++++
 .../net/ethernet/freescale/fman/fman_tgec.h   |  22 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 261 ------------------
 7 files changed, 277 insertions(+), 323 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 7f4f3d797a8d..92c2e35d3b4f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -7,6 +7,7 @@
 
 #include "fman_dtsec.h"
 #include "fman.h"
+#include "mac.h"
 
 #include <linux/slab.h>
 #include <linux/bitrev.h>
@@ -1247,6 +1248,28 @@ int dtsec_restart_autoneg(struct fman_mac *dtsec)
 	return 0;
 }
 
+static void adjust_link_dtsec(struct mac_device *mac_dev)
+{
+	struct phy_device *phy_dev = mac_dev->phy_dev;
+	struct fman_mac *fman_mac;
+	bool rx_pause, tx_pause;
+	int err;
+
+	fman_mac = mac_dev->fman_mac;
+	if (!phy_dev->link) {
+		dtsec_restart_autoneg(fman_mac);
+
+		return;
+	}
+
+	dtsec_adjust_link(fman_mac, phy_dev->speed);
+	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
+	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
+	if (err < 0)
+		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
+			err);
+}
+
 int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -1492,3 +1515,68 @@ struct fman_mac *dtsec_config(struct fman_mac_params *params)
 	kfree(dtsec);
 	return NULL;
 }
+
+int dtsec_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node)
+{
+	int			err;
+	struct fman_mac_params	params;
+	u32			version;
+
+	mac_dev->set_promisc		= dtsec_set_promiscuous;
+	mac_dev->change_addr		= dtsec_modify_mac_address;
+	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
+	mac_dev->remove_hash_mac_addr	= dtsec_del_hash_mac_address;
+	mac_dev->set_tx_pause		= dtsec_set_tx_pause_frames;
+	mac_dev->set_rx_pause		= dtsec_accept_rx_pause_frames;
+	mac_dev->set_exception		= dtsec_set_exception;
+	mac_dev->set_allmulti		= dtsec_set_allmulti;
+	mac_dev->set_tstamp		= dtsec_set_tstamp;
+	mac_dev->set_multi		= fman_set_multi;
+	mac_dev->adjust_link            = adjust_link_dtsec;
+	mac_dev->enable			= dtsec_enable;
+	mac_dev->disable		= dtsec_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
+
+	mac_dev->fman_mac = dtsec_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
+	err = mac_dev->set_exception(mac_dev->fman_mac,
+				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_get_version(mac_dev->fman_mac, &version);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
+
+	goto _return;
+
+_return_fm_mac_free:
+	dtsec_free(mac_dev->fman_mac);
+
+_return:
+	return err;
+}
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.h b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
index f072cdc560ba..cf3e683c089c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -8,27 +8,9 @@
 
 #include "fman_mac.h"
 
-struct fman_mac *dtsec_config(struct fman_mac_params *params);
-int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val);
-int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr);
-int dtsec_adjust_link(struct fman_mac *dtsec,
-		      u16 speed);
-int dtsec_restart_autoneg(struct fman_mac *dtsec);
-int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val);
-int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val);
-int dtsec_enable(struct fman_mac *dtsec);
-int dtsec_disable(struct fman_mac *dtsec);
-int dtsec_init(struct fman_mac *dtsec);
-int dtsec_free(struct fman_mac *dtsec);
-int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en);
-int dtsec_set_tx_pause_frames(struct fman_mac *dtsec, u8 priority,
-			      u16 pause_time, u16 thresh_time);
-int dtsec_set_exception(struct fman_mac *dtsec,
-			enum fman_mac_exceptions exception, bool enable);
-int dtsec_add_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr);
-int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr);
-int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version);
-int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable);
-int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable);
+struct mac_device;
+
+int dtsec_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node);
 
 #endif /* __DTSEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index c34da49aed31..fc5abd65f620 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -7,6 +7,7 @@
 
 #include "fman_memac.h"
 #include "fman.h"
+#include "mac.h"
 
 #include <linux/slab.h>
 #include <linux/io.h>
@@ -774,6 +775,23 @@ int memac_adjust_link(struct fman_mac *memac, u16 speed)
 	return 0;
 }
 
+static void adjust_link_memac(struct mac_device *mac_dev)
+{
+	struct phy_device *phy_dev = mac_dev->phy_dev;
+	struct fman_mac *fman_mac;
+	bool rx_pause, tx_pause;
+	int err;
+
+	fman_mac = mac_dev->fman_mac;
+	memac_adjust_link(fman_mac, phy_dev->speed);
+
+	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
+	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
+	if (err < 0)
+		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
+			err);
+}
+
 int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
 {
 	if (is_init_done(memac->memac_drv_param))
@@ -995,7 +1013,7 @@ int memac_init(struct fman_mac *memac)
 	u8 i;
 	enet_addr_t eth_addr;
 	bool slow_10g_if = false;
-	struct fixed_phy_status *fixed_link;
+	struct fixed_phy_status *fixed_link = NULL;
 	int err;
 	u32 reg32 = 0;
 
@@ -1178,3 +1196,96 @@ struct fman_mac *memac_config(struct fman_mac_params *params)
 
 	return memac;
 }
+
+int memac_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node)
+{
+	int			 err;
+	struct fman_mac_params	 params;
+	struct fixed_phy_status *fixed_link;
+
+	mac_dev->set_promisc		= memac_set_promiscuous;
+	mac_dev->change_addr		= memac_modify_mac_address;
+	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
+	mac_dev->remove_hash_mac_addr	= memac_del_hash_mac_address;
+	mac_dev->set_tx_pause		= memac_set_tx_pause_frames;
+	mac_dev->set_rx_pause		= memac_accept_rx_pause_frames;
+	mac_dev->set_exception		= memac_set_exception;
+	mac_dev->set_allmulti		= memac_set_allmulti;
+	mac_dev->set_tstamp		= memac_set_tstamp;
+	mac_dev->set_multi		= fman_set_multi;
+	mac_dev->adjust_link            = adjust_link_memac;
+	mac_dev->enable			= memac_enable;
+	mac_dev->disable		= memac_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
+
+	if (params.max_speed == SPEED_10000)
+		params.phy_if = PHY_INTERFACE_MODE_XGMII;
+
+	mac_dev->fman_mac = memac_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
+		struct phy_device *phy;
+
+		err = of_phy_register_fixed_link(mac_node);
+		if (err)
+			goto _return_fm_mac_free;
+
+		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
+		if (!fixed_link) {
+			err = -ENOMEM;
+			goto _return_fm_mac_free;
+		}
+
+		mac_dev->phy_node = of_node_get(mac_node);
+		phy = of_phy_find_device(mac_dev->phy_node);
+		if (!phy) {
+			err = -EINVAL;
+			of_node_put(mac_dev->phy_node);
+			goto _return_fixed_link_free;
+		}
+
+		fixed_link->link = phy->link;
+		fixed_link->speed = phy->speed;
+		fixed_link->duplex = phy->duplex;
+		fixed_link->pause = phy->pause;
+		fixed_link->asym_pause = phy->asym_pause;
+
+		put_device(&phy->mdio.dev);
+
+		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
+		if (err < 0)
+			goto _return_fixed_link_free;
+	}
+
+	err = memac_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fixed_link_free;
+
+	dev_info(mac_dev->dev, "FMan MEMAC\n");
+
+	goto _return;
+
+_return_fixed_link_free:
+	kfree(fixed_link);
+_return_fm_mac_free:
+	memac_free(mac_dev->fman_mac);
+_return:
+	return err;
+}
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.h b/drivers/net/ethernet/freescale/fman/fman_memac.h
index 535ecd2b2ab4..a58215a3b1d9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.h
@@ -11,26 +11,9 @@
 #include <linux/netdevice.h>
 #include <linux/phy_fixed.h>
 
-struct fman_mac *memac_config(struct fman_mac_params *params);
-int memac_set_promiscuous(struct fman_mac *memac, bool new_val);
-int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_addr);
-int memac_adjust_link(struct fman_mac *memac, u16 speed);
-int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val);
-int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable);
-int memac_cfg_fixed_link(struct fman_mac *memac,
-			 struct fixed_phy_status *fixed_link);
-int memac_enable(struct fman_mac *memac);
-int memac_disable(struct fman_mac *memac);
-int memac_init(struct fman_mac *memac);
-int memac_free(struct fman_mac *memac);
-int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en);
-int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
-			      u16 pause_time, u16 thresh_time);
-int memac_set_exception(struct fman_mac *memac,
-			enum fman_mac_exceptions exception, bool enable);
-int memac_add_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr);
-int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr);
-int memac_set_allmulti(struct fman_mac *memac, bool enable);
-int memac_set_tstamp(struct fman_mac *memac, bool enable);
+struct mac_device;
+
+int memac_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node);
 
 #endif /* __MEMAC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2b38d22c863d..2f2c4ef45f6f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -7,6 +7,7 @@
 
 #include "fman_tgec.h"
 #include "fman.h"
+#include "mac.h"
 
 #include <linux/slab.h>
 #include <linux/bitrev.h>
@@ -609,6 +610,10 @@ int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 	return 0;
 }
 
+static void adjust_link_void(struct mac_device *mac_dev)
+{
+}
+
 int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
@@ -794,3 +799,63 @@ struct fman_mac *tgec_config(struct fman_mac_params *params)
 
 	return tgec;
 }
+
+int tgec_initialization(struct mac_device *mac_dev,
+			struct device_node *mac_node)
+{
+	int err;
+	struct fman_mac_params	params;
+	u32			version;
+
+	mac_dev->set_promisc		= tgec_set_promiscuous;
+	mac_dev->change_addr		= tgec_modify_mac_address;
+	mac_dev->add_hash_mac_addr	= tgec_add_hash_mac_address;
+	mac_dev->remove_hash_mac_addr	= tgec_del_hash_mac_address;
+	mac_dev->set_tx_pause		= tgec_set_tx_pause_frames;
+	mac_dev->set_rx_pause		= tgec_accept_rx_pause_frames;
+	mac_dev->set_exception		= tgec_set_exception;
+	mac_dev->set_allmulti		= tgec_set_allmulti;
+	mac_dev->set_tstamp		= tgec_set_tstamp;
+	mac_dev->set_multi		= fman_set_multi;
+	mac_dev->adjust_link            = adjust_link_void;
+	mac_dev->enable			= tgec_enable;
+	mac_dev->disable		= tgec_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+
+	mac_dev->fman_mac = tgec_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = tgec_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	/* For 10G MAC, disable Tx ECC exception */
+	err = mac_dev->set_exception(mac_dev->fman_mac,
+				     FM_MAC_EX_10G_TX_ECC_ER, false);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = tgec_get_version(mac_dev->fman_mac, &version);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	pr_info("FMan XGEC version: 0x%08x\n", version);
+
+	goto _return;
+
+_return_fm_mac_free:
+	tgec_free(mac_dev->fman_mac);
+
+_return:
+	return err;
+}
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.h b/drivers/net/ethernet/freescale/fman/fman_tgec.h
index 5b256758cbec..2e45b9fea352 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -8,23 +8,9 @@
 
 #include "fman_mac.h"
 
-struct fman_mac *tgec_config(struct fman_mac_params *params);
-int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val);
-int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *enet_addr);
-int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val);
-int tgec_enable(struct fman_mac *tgec);
-int tgec_disable(struct fman_mac *tgec);
-int tgec_init(struct fman_mac *tgec);
-int tgec_free(struct fman_mac *tgec);
-int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en);
-int tgec_set_tx_pause_frames(struct fman_mac *tgec, u8 priority,
-			     u16 pause_time, u16 thresh_time);
-int tgec_set_exception(struct fman_mac *tgec,
-		       enum fman_mac_exceptions exception, bool enable);
-int tgec_add_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr);
-int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr);
-int tgec_get_version(struct fman_mac *tgec, u32 *mac_version);
-int tgec_set_allmulti(struct fman_mac *tgec, bool enable);
-int tgec_set_tstamp(struct fman_mac *tgec, bool enable);
+struct mac_device;
+
+int tgec_initialization(struct mac_device *mac_dev,
+			struct device_node *mac_node);
 
 #endif /* __TGEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index f9a3f85760fb..7afedd4995c9 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -216,267 +216,6 @@ void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
 }
 EXPORT_SYMBOL(fman_get_pause_cfg);
 
-static void adjust_link_void(struct mac_device *mac_dev)
-{
-}
-
-static void adjust_link_dtsec(struct mac_device *mac_dev)
-{
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct fman_mac *fman_mac;
-	bool rx_pause, tx_pause;
-	int err;
-
-	fman_mac = mac_dev->fman_mac;
-	if (!phy_dev->link) {
-		dtsec_restart_autoneg(fman_mac);
-
-		return;
-	}
-
-	dtsec_adjust_link(fman_mac, phy_dev->speed);
-	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
-	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
-	if (err < 0)
-		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
-			err);
-}
-
-static void adjust_link_memac(struct mac_device *mac_dev)
-{
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct fman_mac *fman_mac;
-	bool rx_pause, tx_pause;
-	int err;
-
-	fman_mac = mac_dev->fman_mac;
-	memac_adjust_link(fman_mac, phy_dev->speed);
-
-	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
-	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
-	if (err < 0)
-		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
-			err);
-}
-
-static int tgec_initialization(struct mac_device *mac_dev,
-			       struct device_node *mac_node)
-{
-	int err;
-	struct fman_mac_params	params;
-	u32			version;
-
-	mac_dev->set_promisc		= tgec_set_promiscuous;
-	mac_dev->change_addr		= tgec_modify_mac_address;
-	mac_dev->add_hash_mac_addr	= tgec_add_hash_mac_address;
-	mac_dev->remove_hash_mac_addr	= tgec_del_hash_mac_address;
-	mac_dev->set_tx_pause		= tgec_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= tgec_accept_rx_pause_frames;
-	mac_dev->set_exception		= tgec_set_exception;
-	mac_dev->set_allmulti		= tgec_set_allmulti;
-	mac_dev->set_tstamp		= tgec_set_tstamp;
-	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_void;
-	mac_dev->enable			= tgec_enable;
-	mac_dev->disable		= tgec_disable;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = tgec_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	/* For 10G MAC, disable Tx ECC exception */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_10G_TX_ECC_ER, false);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(mac_dev->dev, "FMan XGEC version: 0x%08x\n", version);
-
-	goto _return;
-
-_return_fm_mac_free:
-	tgec_free(mac_dev->fman_mac);
-
-_return:
-	return err;
-}
-
-static int dtsec_initialization(struct mac_device *mac_dev,
-				struct device_node *mac_node)
-{
-	int			err;
-	struct fman_mac_params	params;
-	u32			version;
-
-	mac_dev->set_promisc		= dtsec_set_promiscuous;
-	mac_dev->change_addr		= dtsec_modify_mac_address;
-	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
-	mac_dev->remove_hash_mac_addr	= dtsec_del_hash_mac_address;
-	mac_dev->set_tx_pause		= dtsec_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= dtsec_accept_rx_pause_frames;
-	mac_dev->set_exception		= dtsec_set_exception;
-	mac_dev->set_allmulti		= dtsec_set_allmulti;
-	mac_dev->set_tstamp		= dtsec_set_tstamp;
-	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_dtsec;
-	mac_dev->enable			= dtsec_enable;
-	mac_dev->disable		= dtsec_disable;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
-
-	mac_dev->fman_mac = dtsec_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
-
-	goto _return;
-
-_return_fm_mac_free:
-	dtsec_free(mac_dev->fman_mac);
-
-_return:
-	return err;
-}
-
-static int memac_initialization(struct mac_device *mac_dev,
-				struct device_node *mac_node)
-{
-	int			 err;
-	struct fman_mac_params	 params;
-	struct fixed_phy_status *fixed_link = NULL;
-
-	mac_dev->set_promisc		= memac_set_promiscuous;
-	mac_dev->change_addr		= memac_modify_mac_address;
-	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
-	mac_dev->remove_hash_mac_addr	= memac_del_hash_mac_address;
-	mac_dev->set_tx_pause		= memac_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= memac_accept_rx_pause_frames;
-	mac_dev->set_exception		= memac_set_exception;
-	mac_dev->set_allmulti		= memac_set_allmulti;
-	mac_dev->set_tstamp		= memac_set_tstamp;
-	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_memac;
-	mac_dev->enable			= memac_enable;
-	mac_dev->disable		= memac_disable;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
-
-	if (params.max_speed == SPEED_10000)
-		params.phy_if = PHY_INTERFACE_MODE_XGMII;
-
-	mac_dev->fman_mac = memac_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
-		struct phy_device *phy;
-
-		err = of_phy_register_fixed_link(mac_node);
-		if (err)
-			goto _return_fm_mac_free;
-
-		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
-		if (!fixed_link) {
-			err = -ENOMEM;
-			goto _return_fm_mac_free;
-		}
-
-		mac_dev->phy_node = of_node_get(mac_node);
-		phy = of_phy_find_device(mac_dev->phy_node);
-		if (!phy) {
-			err = -EINVAL;
-			of_node_put(mac_dev->phy_node);
-			goto _return_fixed_link_free;
-		}
-
-		fixed_link->link = phy->link;
-		fixed_link->speed = phy->speed;
-		fixed_link->duplex = phy->duplex;
-		fixed_link->pause = phy->pause;
-		fixed_link->asym_pause = phy->asym_pause;
-
-		put_device(&phy->mdio.dev);
-
-		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
-		if (err < 0)
-			goto _return_fixed_link_free;
-	}
-
-	err = memac_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fixed_link_free;
-
-	dev_info(mac_dev->dev, "FMan MEMAC\n");
-
-	goto _return;
-
-_return_fixed_link_free:
-	kfree(fixed_link);
-_return_fm_mac_free:
-	memac_free(mac_dev->fman_mac);
-_return:
-	return err;
-}
-
 #define DTSEC_SUPPORTED \
 	(SUPPORTED_10baseT_Half \
 	| SUPPORTED_10baseT_Full \
-- 
2.35.1.1320.gc452695387.dirty

