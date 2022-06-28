Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB2955F108
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiF1WQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiF1WO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:58 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E3F38D8E;
        Tue, 28 Jun 2022 15:14:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6xxZvIYq2hDUpBev45Sot+G15osthQ09qD6tebCh7TA6lEPcpqtI08tVYlcnqADBmOVPM1/sh+85AHdMhIUwURwF82OctD98/HNOYxZosq9f2xEbRfHKZLckVYXw5FHQT9gg4iJlAKcp+4HWlCLaQGO9xQjwhMzCjR4iuzxtRtjxByPJ3UIbAzO7UYDiuotYsi2TOlNSSDJ8r79a47OW4YCF/W/1L5d1g41uIH77dUbDd42Rm7PZzunR3vwvU7gvONnveHn48JZNvWU6WL9Ggw8+1Nr/1IYLC7eOEZYrIJCoMVGAU/EHd/CVQ4wIM0eOP4lMQvy7N9pcc8Sh3+sqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlxXAwRxUHEl+QF20HVm9skJ8pNWO1cyP6OWWH5uXMw=;
 b=aBlsEVFj6748EgmhDBuelNV8KEyqiPo2YTYRna6pY3Zo4bzZIZGJUTE/NSspGZGsjmUXn1FttwW/IXmYwbslgUHN3ZePNPiVXeTKxOsJiKTYl0e7MmcyXjOTDk3IG8ITATnmuJap0amkRSAq0uKwvSMG3N0buSqJAsgI+yp4kaZ3ZaQ7n20ZJUl5DvwGWH/qg6lFN0eulItY75BiQHi0BXvI1ApjXbtYWV/JCtCsvIXo6Kxm7H/MPm50l85aW4i5cEXAmcLR5Kp0iWDWSfio+XZvkX1Hrv34Vu0ocU6fFFfLqo7HMrDUXH/hMnV12JVl8W+DUcjWqgYlw1XbPZWUVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlxXAwRxUHEl+QF20HVm9skJ8pNWO1cyP6OWWH5uXMw=;
 b=mRpmtxwybIXCV343dz58FfLv1RW2+bNkudkqOcyqogXigQMWKUVXT1dKOmYDYAHsgAIYxjnUknUOcvzrX9WQv0pxiHI77zjViQvIXR1MPcWAsJ4Awhr8FlGb3zBa7YizYq95jeAx9jNyEEvx6Alk5ZA9X48iQWfkQ8iSVdz99dlUl+r1m48k/knkwlEjelp3ZSXWyedVdEeIBMZ6TdkKBTWpp7dyCc7NqhCdoBy9GzbsAYI/nPnKPjyaXnhOoqt/iTxuJC4rRccF4y57tUYEWKbOqoaHMW5kUcw5qdm2Hyz0w2c7tjxe547fXpTMpmB2VPC0WXXBFPXpPB1P3sdezA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:43 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:43 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 15/35] net: fman: Move initialization to mac-specific files
Date:   Tue, 28 Jun 2022 18:13:44 -0400
Message-Id: <20220628221404.1444200-16-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1283cc5-eedc-421b-6c47-08da59539a34
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AvVsTlbVV4NSKpQeyNq8OeFO72/9Gg+IKtz36X7RMk41k2IaihgAl96tDvNncS1q9y9eyBFYCvpLLgY8AFXAUQjror+hwgT0pCAxZk4p8tXAeyyER1A9jIInMjpckbQKZtWo1xzBKx9hWL3O4mrx2wahbqBAnb5jq+mQA5LchJ6Gr2bHkwBU+PqZW4M4bPpA0C30u8UBBN6l3HvWnkKY7FoVI3y20ZUVUV4dBdIeDUPH4GogZ9MFxxPPJ3G46OCgvpeMguODPvKEKyP5u2K49JhLjUVRcZ16hZP9gtd0ZUh2HEyXTmxLYIa3e+BnyHJuB0vwkSZWQAiW2WtxPkfGFrk0X3TUfHI8NnpeYqV36+zDZ97Hg30YUxplY4OR2brnN4T/n2vW62s5xpqrjYTb9DAA6qabLuwu7VNIdCAA6q5Ho8TaPGLloAX+42+wtUfEvEQPZ2dWxe5Uo9KWcQmmrzIbNzD06QSSvcRjiGdMu8hozCp5oDw+bthppLG5UTcT1CxdytrmSGbe26pRzVf5W0t1n0eZ8nObVDg168B3epT21yJhC2LVLdHIP16az2z1PV0OjkW8jZNla40xL1vQ1dQa8FgyYFrN6+Vp160a70b2VRdC3E1UD7x2rhlfp5FOPwAeh125QuyTB6Le6X1gdfzOxOnik/y8ZHyw2q7yT4sdr/IhFACvZfwnYzoOtrHZ7xIW3jfzX8VJpI6zzdMIfYQwqQVjTrm+57XoxSFOa4mpeTWZU7oDYoYXhSI0AqOn3hYRlbTbxcj2CLMGVbA4/zEye7ZfWCM9SD65XvOeFJ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(30864003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FOW2R4522oIyhRmlDzH1KN0TRsKhbJVQdM+kJ8BO5aX+GlC1b4/HR+dv/cf8?=
 =?us-ascii?Q?UR4pcZReZAS18sFeKAbFjps4hbVfSPuHaYTWnBOmkZjhjj/bZQ7GVd/BN/js?=
 =?us-ascii?Q?0scdNUdgE65ucKboJFQEsr3ebYmam6BKqtyN0DMdLt18g/RDctz6wjQ8S2vD?=
 =?us-ascii?Q?wim18+kLYDdgA0NoAimGbUl10Q6r+nHFuKwiN6/AX+drkLukTA+siht2r0/j?=
 =?us-ascii?Q?RQOWp1Uu/Iy/Re1BGS85ctSiQeXtVZ1fvtPuKS8BuhwOxw3kR3QLYQSJUwhD?=
 =?us-ascii?Q?9JzsxDv++6OqVx9z1ld+iLaxasAo5nkqHNi2ye8SLIsTM63LYQQZGd9hw3y3?=
 =?us-ascii?Q?DP3ojrsQz2PCTwzLUD8UABpq60NBt5lhGn3qCGQFghOkjhMcWFv8jMkt0ol+?=
 =?us-ascii?Q?dvrYL+fCC1tGVnGxLQjBzacH5w1tsSte4BpjpAT25hg5HREXKbdfE9hO1TDC?=
 =?us-ascii?Q?hQ7EZwiqemmLnBKGPsYmS8Sj86LaW46M5JwwUmVnG5DZ8xm224/2xLsZYbA9?=
 =?us-ascii?Q?Cs5km02pX/fb1aF/xLNLWi5ZYjKNU6ZqMc57FDDZDO1QmQLbJi597TxLSJez?=
 =?us-ascii?Q?FuKd6CyDlb7d7JNOJNr4XIDzPsfKAn9SpBDkTmPXFcGnAqnhiUvK4ufCTk+P?=
 =?us-ascii?Q?VqshMTt7ZUL1+IjbRbxM0YlTJ/U6kBYEIlYQwaU3iHkmOmQWwQSnXjww9xJl?=
 =?us-ascii?Q?GU0zQl8QVWC1B0+UneFTKuUyT3WTLnBueXsC0/iaaeyUSK6xdGe5ByrlnhwC?=
 =?us-ascii?Q?jCZYN7m/xzDllw7J0p7rTN20cXmjBIscnC2fNYQ3itBkNGQrbB8PHd6udH7N?=
 =?us-ascii?Q?FojWSy91dXvgJSA/6SWIfZ/6IA/I1/ZIopc63ytNmeFBfm0f4DUQfjt3M/Ju?=
 =?us-ascii?Q?JlZ/Rqhhnlwytj9Uy/UAG+LlqMuz3T4igtszyHHoqXzs+2mOO/g38xH585yn?=
 =?us-ascii?Q?Ha0RGharxTlHiU32vSlJBudT46wZxOEQO7PRcQXG2HXwPOZrRdtVft3QzTxg?=
 =?us-ascii?Q?nc0z0SVvy0ILM7trYodUjC3OWO7L4mU9fNGZ9D0oa7pcr+XAiAfkPe77EDDX?=
 =?us-ascii?Q?y5TH3ErNG3Fdkl85FhZNkaya93iiy7TfKR4eAnuU8A0uffx7bmyGd397W+5R?=
 =?us-ascii?Q?R+mr2sKOtGx4a99mAa6DsN3XsGEgKy2FDZnNc2mtWGkl0as9GSlYczp3SP+A?=
 =?us-ascii?Q?2xoDM9kNzdD6RpdGBbj7JozDR2scH+fWFUFc4u1gRYbgKp9fkZJogLA77eRI?=
 =?us-ascii?Q?eaoTt/txq73ZMoMxiFpxoiWmfuQHEnt8LDPdC80E2Ydd+qNo3NkcRh8itC/q?=
 =?us-ascii?Q?0OPBeHkSjJTWFe+COrXnn2YGF+ms11nmeUMDtNufK1AXb0nhm323Na2ev+or?=
 =?us-ascii?Q?Cp8khzzmPi13VgDEHxXg32MS+LWvHkpEeEiz43qDQiUtasjU+/hlz9EAn3mf?=
 =?us-ascii?Q?o7fhWtUg5EwVCaN+aGWJ/V5efZQQ5gOMe4ICwE9nGm6ZRp3KhoG1s0QdvpET?=
 =?us-ascii?Q?8GBFuRcCS6nbivC7XiJvTL2zQhgaYhBuWCo270lCFSbNV0LSMO7+UGTUK1/t?=
 =?us-ascii?Q?JZNsFgf6wW38Le4Bn7wqOyJWhAJUii9hIk/OWIuvAwhbKS2zG1Lg27dPrVhn?=
 =?us-ascii?Q?gg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1283cc5-eedc-421b-6c47-08da59539a34
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:43.2974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gaiR6sCMhCikrpOKXsqIqMzqH9OLrorem5Ocjns1SkABy+pXhgTYP8QSRy0xV4OYr6sTbjwt4xMHgWGeBq2eNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
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
---

Changes in v2:
- Fix prototype for dtsec_initialization

 .../net/ethernet/freescale/fman/fman_dtsec.c  |  88 ++++++
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  26 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 111 ++++++++
 .../net/ethernet/freescale/fman/fman_memac.h  |  25 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  65 +++++
 .../net/ethernet/freescale/fman/fman_tgec.h   |  22 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 261 ------------------
 7 files changed, 276 insertions(+), 322 deletions(-)

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
index c34da49aed31..b2a592a77a2a 100644
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
index c376b9bf657d..7afedd4995c9 100644
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
-	struct fixed_phy_status *fixed_link;
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

