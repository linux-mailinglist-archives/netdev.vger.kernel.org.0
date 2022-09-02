Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC7F5AA5C6
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiIBCaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiIBCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:21 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20077.outbound.protection.outlook.com [40.107.2.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC23399CB;
        Thu,  1 Sep 2022 19:30:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFgiS4dGtMnB6ItexXt5YUYowRsyGHNQMGco3cWtsYpxIPLOxAdVLYibZeR0+Ktk3YKQxj1md+OUXXyviVEjTO0Qi5NiSSXCI0G2tCXXwTHxsoKRT+ze3+7EZTizQRMArBX6ji7Ip69ZSH3ibDHwiVl3pRWMjg6n9N3M7cfINTl9qsR4cMVOTogADqsaf9DdxnmaiVP1e69BFMmS8vQ67LHTbE0dwg/ufuXNVQk1QM4NjWaF3VgRFYnu+VZ1OHbtgAwu9rP8m1EmAW6Ei7KQYvX9w5S7puv7QfIZCmhdinyrkjUPTTeVo1nuCiCj+YyLhe3Nuhmj/2TxmLq1mLhVfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJaP4NzbnIVd9hBbWuNSC5ezZeNiUWCRkf2ZLiB/BYI=;
 b=b88WB0upPTga08jHuQR9y6m4RTy48JFNBC74cO2MMrtaxM4U/qXyQ5q3vgyOicUa4toDtsb3Gn7hRKzWIRCm85Lf7WANiLMXeiH0qiH4HjUpYL68bi+07Ewr5T78hm6eaeIJFLUxAA/H29vslKDr/ruNuwqVCc6DCftcWCxlwjihUzcgAiFtmdBgV1s6hG6iBOaIR98aF5x0jlabempIjn+WiTzWMEMm98ZHu8DDe/ozltXKC+0MwPAL5g2W+VNDpps/fFfvG4RBuJ4/pbD0MXgE87KcSA5e2xZl22iU12JULaJfzI++uy4iSYYQsBSw1cSIY+CTYNNHgDrkU9g7fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJaP4NzbnIVd9hBbWuNSC5ezZeNiUWCRkf2ZLiB/BYI=;
 b=T5hza8LFZSkrFLHkjQNNXVJk1J8bagSYgVNSjLx2dBk4cMe3Q3I+DlW8qPElFIcIU7L9OtsRLzLPXEl7CT7kZN40E4LrEEgStyM6zk+iLd97yRyTTP5Gaxl64cs7ARcx+lqCalwhMjjqSRx0CMOAjGrNQS2xU9fN2ZNXkZgZbIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DB3PR0402MB3705.eurprd04.prod.outlook.com (2603:10a6:8:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 02:30:15 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 02:30:15 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next] net: fec: add stop mode support for imx8 platform
Date:   Fri,  2 Sep 2022 10:30:01 +0800
Message-Id: <20220902023001.2258165-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:196::9) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d070da7d-4ae6-4c64-bb60-08da8c8b11ce
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3705:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6HzdKGtr7hFgHE8sv26sdz18yL7oPqxbIeyz+lA0pO96caXo/1QnDJT24zgaoOxzuAXKi/UZ3ud3GkOcDR9MPpH/EOUwKyjLEjQHTSe6H8K17lkYtA/tPKhIBK/Ty9QPja1WiBLpgOcycXZ89Ixbe1NYL7tqGGU87p82vsJFca7iZYpJhm6duCg+Ntt+/i6VGHJmFPq2DaIWzo2g0NIHB/seBAM3M7prIeuGULZzKhWSp8RVafbmwO2rQSGDPEFP9L/MlttOnwfDzqTxuhxbR5So9lA/2Z9pBOJQOQw6zhT3XJyErqfkDJ+OQlSI7gelRWcJ5wGEAnhQKOUq8Wj0qHmdPh/cUhHgDJ6mVHLYFf4eH41B6F34S8v5m/BaVrIMmH3S3MYN5xysmVWplLo+fbh7KAPKeUJeT249kGx6UL8ESlLPOvXnBEeFRH/7HBspOmLBY3kuvtFGRSbdyIuMO/jcz0vahIGY38tkp2fvF8/WRroTzmO0y+xrGpHVMSPkEfHv2P0HPSzLwl25MK0WMmtiI23mEq2KBRKm0kfKFsPcNn8WXfyaeJ8gAFPMZfMkeDKjrnb2vtaASh7UImFwGRxKmWL2fnDWTDKZzcwqwGmcSqNgfT/nSb7dq/VXb1+jm6XxopD3LN9usS5tcjfvK89xd2LD7NviIWb3uRRDr9N/ipQT8NzskWj1p/Fih2EeE3jSMp7eSKZLGRAcTBFoFvk2Rnbk60pAuJHXVCAD4HFsZ8xHGUfueDu5yTqHf55
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(6512007)(2906002)(38100700002)(6666004)(316002)(41300700001)(6506007)(186003)(83380400001)(1076003)(86362001)(38350700002)(6486002)(4326008)(66556008)(66476007)(52116002)(9686003)(36756003)(8936002)(2616005)(66946007)(5660300002)(8676002)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3cfT8KbEU7sjlumZSI0N3cEuQf8DRHwJ//iq9GNPuZ/yxu6kI584ALdcQwCM?=
 =?us-ascii?Q?Ca7bgEgjh6vH8PWWoFrhHmFnrCLn2rFIaTAE53ic/8Mgd7wIqTXEyCiFoGOE?=
 =?us-ascii?Q?0qOPzRwKKv2AgUnPHf/3H0zckEPgLU/eRdL6h//GOr0lbLXb4qErxkvrlMBi?=
 =?us-ascii?Q?oUbReREjzTVZQHzpVQssLLjdSad47SKRD9glD3r/HNbo82187byPYzCs3MvO?=
 =?us-ascii?Q?yNcVQxiIzJPNkC+RODxndH1BnFQVrx+ITEZcKhau+JTVtgUMQV99iHCvcmee?=
 =?us-ascii?Q?nNsbSsd8Kvc9kmoyjraKAO55LD1Fsc5BRlSuWIai3kuEg/cuWfN+Fp1m4u4g?=
 =?us-ascii?Q?lkHKkCsyBmAeb2M9KlfypLHaunMaKcZrBVuzxNORD/c4OY4aswAeeqMojoP7?=
 =?us-ascii?Q?2kMopDY7wpTLhTn5HYnI88HyUKm6mpdUrvZsEqL63N9S3Env5nGi5XSc8P5/?=
 =?us-ascii?Q?kEZhvE2/XxuL2WtWTktxOWEQ/P7ofsvW9oWrhmmaW3Ol7uTkGBtHdNQq8YUK?=
 =?us-ascii?Q?HkFvoClyo+wkc228hUOGytB79Z3YC2WgXdWBU6fpv5yI2EalQ2jpq4Ppl8g0?=
 =?us-ascii?Q?L+CmIvdTlAoYgk5Wobvi43i/BPe8D56aKGx4098mqhlnyKeKQXGgktgenuDf?=
 =?us-ascii?Q?QquZxpttklF9iuHiaejkFydwKg+paF0Ff1yl5Ow3HMZ8AqCSIOfKt6dRx37Q?=
 =?us-ascii?Q?AqyvKJJkGf62RZ1wo00QW4uDMv/HZGz+cnDDOpp+SX6JD01i7wQ5+9ZtAmeD?=
 =?us-ascii?Q?SDOOrzY5vGzpbLyQkR/1oP1HlMlofE1C5SKL98VpfsssgunDKemlWnK0cnJ9?=
 =?us-ascii?Q?gU6Wkc6t+Xo0Q2yDLcJaL7nhVtqP4gfLO8mhQ8P1UQrIG/YJ+M+1/gkr9XiN?=
 =?us-ascii?Q?UbzPCVeLvhNCO+g/WjWP97rBehpTomMMjwwsRnF5uEClcljyKMtvtqnyinww?=
 =?us-ascii?Q?7YlwZbrb1GXZKK6g+CrnPSbeHX40Qc0waIFZzEPt09pnR9DmKAO/Y/5uN5Nh?=
 =?us-ascii?Q?3/SpUA+ajVleywhjgJJFEf4mrIwufVLJatJi959llaKfMAHWfm93rlmGX/KH?=
 =?us-ascii?Q?z3UVxTFyBzqvpyhccA/DYLv6wULzjkcWjnR+Ytynw/+njq0qYb+kGpB5/KT7?=
 =?us-ascii?Q?CchfkVr03jz/K4TyP6OnGT5gNdknuxiFxOw1Mgf6uyk+heSBeZItOlRByXKD?=
 =?us-ascii?Q?eiMD2pPHQYS1wqMwmx01LflPbRqa+FsCj+8L2zdMynQH7bLuWTtC/MfwyJ71?=
 =?us-ascii?Q?r3xqyXhcFaAD7qV/fAL77P9XMyOtUVt/J46aeCcSvbuCJZl0OsyT4sbxwlxX?=
 =?us-ascii?Q?tkWCQkK073TGyDqBfL7mpKFUTf8eUJtelfgGSxl4mXwJDI3DTm0UXe8V6BdZ?=
 =?us-ascii?Q?ThpPNu+0uBHBGFlgSFEVzId1lg1k1PyQkGD3u/tNgk27QfQ5b/hjdyvU/1NB?=
 =?us-ascii?Q?nx8Rr+gBjjxCs+antBVSYWnHrMZf0DiO83b85K+EDajdg+yxmqLvbMTm4bay?=
 =?us-ascii?Q?+YPqt4ULfXo18dMC3ngkmZEhATIbwNeCkP+W42FQBGIwyHon4dc0a3+UzvxI?=
 =?us-ascii?Q?7Jq5TxOyYtrg6k6e9O7j2OBBiJRoJf9Wpcfopxxe?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d070da7d-4ae6-4c64-bb60-08da8c8b11ce
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 02:30:15.8148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqZR5Q8zz4jhxsNTxV6VIC/mL2uO7JxOVNmZiPuN6WB4OnQzRH9J/L4/G2qpJ8wgFBVm5iFD6JiRqqgPvi4AlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3705
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The current driver support stop mode by calling machine api.
The patch add dts support to set GPR register for stop request.

imx8mq enter stop/exit stop mode by setting GPR bit, which can
be accessed by A core.
imx8qm enter stop/exit stop mode by calling IMX_SC ipc APIs that
communicate with M core ipc service, and the M core set the related
GPR bit at last.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
V1 patch does not apply, so rebase it.
---
 drivers/net/ethernet/freescale/fec.h      |  4 +++
 drivers/net/ethernet/freescale/fec_main.c | 35 +++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0cebe4b63adb..68bc16058bae 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -18,6 +18,8 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
+#include <dt-bindings/firmware/imx/rsrc.h>
+#include <linux/firmware/imx/sci.h>
 
 #if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M528x) || \
     defined(CONFIG_M520x) || defined(CONFIG_M532x) || defined(CONFIG_ARM) || \
@@ -641,6 +643,8 @@ struct fec_enet_private {
 		u8 at_inc_corr;
 	} ptp_saved_state;
 
+	struct imx_sc_ipc *ipc_handle;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 7211597d323d..8ba8eb340b92 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1181,6 +1181,34 @@ fec_restart(struct net_device *ndev)
 
 }
 
+static int fec_enet_ipc_handle_init(struct fec_enet_private *fep)
+{
+	if (!(of_machine_is_compatible("fsl,imx8qm") ||
+	      of_machine_is_compatible("fsl,imx8qxp") ||
+	      of_machine_is_compatible("fsl,imx8dxl")))
+		return 0;
+
+	return imx_scu_get_handle(&fep->ipc_handle);
+}
+
+static void fec_enet_ipg_stop_set(struct fec_enet_private *fep, bool enabled)
+{
+	struct device_node *np = fep->pdev->dev.of_node;
+	u32 rsrc_id, val;
+	int idx;
+
+	if (!np || !fep->ipc_handle)
+		return;
+
+	idx = of_alias_get_id(np, "ethernet");
+	if (idx < 0)
+		idx = 0;
+	rsrc_id = idx ? IMX_SC_R_ENET_1 : IMX_SC_R_ENET_0;
+
+	val = enabled ? 1 : 0;
+	imx_sc_misc_set_control(fep->ipc_handle, rsrc_id, IMX_SC_C_IPG_STOP, val);
+}
+
 static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
 {
 	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
@@ -1196,6 +1224,8 @@ static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
 					   BIT(stop_gpr->bit), 0);
 	} else if (pdata && pdata->sleep_mode_enable) {
 		pdata->sleep_mode_enable(enabled);
+	} else {
+		fec_enet_ipg_stop_set(fep, enabled);
 	}
 }
 
@@ -3851,6 +3881,10 @@ fec_probe(struct platform_device *pdev)
 	    !of_property_read_bool(np, "fsl,err006687-workaround-present"))
 		fep->quirks |= FEC_QUIRK_ERR006687;
 
+	ret = fec_enet_ipc_handle_init(fep);
+	if (ret)
+		goto failed_ipc_init;
+
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
@@ -4048,6 +4082,7 @@ fec_probe(struct platform_device *pdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(phy_node);
 failed_stop_mode:
+failed_ipc_init:
 failed_phy:
 	dev_id--;
 failed_ioremap:
-- 
2.25.1

