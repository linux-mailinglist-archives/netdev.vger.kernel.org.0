Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49D2293637
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405518AbgJTHyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:15 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:58244
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729133AbgJTHyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6DBeAwBEYHj4h2J78i8Wz3/z3wKlc/2yXm/Jkd4ohKE8O2c9eSlzkU0xJqpnsysaO3GTfVUGgTkXW85RYW/npx6Nod9A+B/jXZFmMfnyMCfE+Oy1uJFLPvn9MMo+844vV8b4t6t7slHjv1DKXVOrpHj7ZcnktW76cTPcVrTgZhpmfdg+CmRqwPGYd/iw486FBKqoofVhW5v8f0s6z5eOgi4U+jgC8C32l0HzC5V0PvDZx1OitCwH+afvjnvIrOeV+6N3layyq+0+yptzLc+M6gee7kM0cNl2Qk0Mb92apC7v0Neh53JQI9Yow2dVmzQbi/JGHFZg2/nwSzElsdLoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDbAwQnA5enTI3i2f5XQgOnhhQ23eN6woNIFu1j7SmI=;
 b=FYRXfv+iwXs/ufwGXAS1BkwGY1sOoptA/n5Gli+R7Evu/H/qWLcd/S5OcXztf4rKadIqp7NT7LWF9kdx/kVPTV3/WCl1Zyexl6LacTgclP85BmNmcEoNUr8W12r4Ku3TbJ3ANnOpyMJ2JMlWB3pkGag/86qBMRmb8jYqYEhCBckdbGIjH358o1X1lr5uSSlmDlfXiSViY8IPLrq6nfypWjTl1zOGyTlZ/sj1dpKF/ugNFJOoD8aAG0cgSPQibpuFGWaD566MuacuN1RGO6IB1FWulCt+XJZU1gCrInqG4Mt/EIq5sUD1bSPj9XGVC41lKGk3wQJFAmx4GXQO1hDkYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDbAwQnA5enTI3i2f5XQgOnhhQ23eN6woNIFu1j7SmI=;
 b=cJ94K61koPao1HNVNu2lZpPZD3Bd5El0QkOJPIYmuAVzfcUYofB5N3OZQNzxgWu8njhWhftGaC+lD/Rj+63PQnDTVE52iKVt7E6+NR3tDYA7wzc+dDNY0dSGYA/sAgvRd5dpOgTJJcEmEhg7H00PctKybBW4+gPUT7Otp673toY=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 20 Oct
 2020 07:54:09 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 01/10] firmware: imx: always export SCU symbols
Date:   Tue, 20 Oct 2020 23:53:53 +0800
Message-Id: <20201020155402.30318-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c1c6823e-8c86-4ca0-36c9-08d874cd537f
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB733303D3F9443369817B7854E61F0@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UdxeX297gX2mk8kw6qRh+pFbRfCKc6C1A/aVx1aMJk88wETA59hoefjPg5CWpxet4oKK9wbYE1anCjPN2P8p9utO6mwcheojMGI3O8+aqFBhUaGqvbz2Is50mgLGwpYaiJgMG7gIpWu+FBV/X28ZHyDlfahZ4EDX/2QoRMhjE2gbGEYObWsyIRXUpFdPE9qhNnHwXnVsydLKLqYsahkmPsGMANf+utMhZa7tBxRVDJ7dWJw84B+OQsVsxtFvd6L1qsG4zeHlAJIOE9myeVR2yGQJsuYDPDWH18nA6sjEn2NQTC0uv4BIbQJw7Y+Jrx7DILkFNdgUfgm7H1yk1t852+4v+qHlzjdKMQtKaaEv+yEM6bqtUAaSnUOsBCYFfhUJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(6512007)(2906002)(66476007)(52116002)(66946007)(956004)(2616005)(36756003)(1076003)(6666004)(83380400001)(69590400008)(66556008)(26005)(316002)(4326008)(6506007)(8676002)(16526019)(5660300002)(186003)(8936002)(6486002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jXRK5NFYthiPjHsJieZwn44C8eHdg2LMw/HeNu5JWmofzRkCbMrnfSK/8LY+Zkb1g4oYYhTwOx304hGiOb89k2eLGClvdOPhl8xywBvm/hzoGbVENPBBidK+rwwrqlIEP8JhnM6IWbRoByhWUZMiHMsAkGRTLBEorYdIVlYc2s2qOoMKSwOGhQMMfTMmCvY04S4PTEFdPaMMMb4mRxbetOjUTecZi0olZpyA20WDob67QkraiOBFXk37L5DVM0KYG7y373BQL0ib06VrLBtTdDGU62s4aIxXehYAbN2Sj6SvEsctdb9fAXNsMBfVrMG27hzz46fsp6RjYxaTgcuhiMpGO77Xp34Yjjhi1fvx0cfFr8YXPGPcyi72vq00Hv3xETnseWbG/LfTWG2AqYrYrqt4kSbGl3BSab/xUW+8k3fnTsF7SpLNc/2yJ8En7PgVo9PNRVgpdvksRbhmYdv66X/Cv+lzXvBonikd+ijEV2y+Oxj0tcITbVqN/Kgy6EvnvsAgfqp7BUc84xCKMlAkHdk71NiWaPYtVqZykhRsKtFgAJd5l3jyFO+qYNkvvksrrXDXDfFf6BC+gpX1NsZVzbTGas1aTmvzRMkpvcVdHvftttuvAcWIc3Jq45UyxCLjAvHyJU5dmB53DkGz/8FM3w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c6823e-8c86-4ca0-36c9-08d874cd537f
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:09.2661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZixZIi99JqM4zkB7imNoLrIqWLkdmxPhxi3max7q0WBVJFsrgO0BCHjphPsqM1iAlc5SjLEaVFVCzR/gugwA5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

Always export SCU symbols for both SCU SoCs and non-SCU SoCs to avoid
build error.

Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 include/linux/firmware/imx/ipc.h      | 15 +++++++++++++++
 include/linux/firmware/imx/svc/misc.h | 23 +++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/firmware/imx/ipc.h b/include/linux/firmware/imx/ipc.h
index 891057434858..300fa253fc30 100644
--- a/include/linux/firmware/imx/ipc.h
+++ b/include/linux/firmware/imx/ipc.h
@@ -34,6 +34,7 @@ struct imx_sc_rpc_msg {
 	uint8_t func;
 };
 
+#if IS_ENABLED(CONFIG_IMX_SCU)
 /*
  * This is an function to send an RPC message over an IPC channel.
  * It is called by client-side SCFW API function shims.
@@ -55,4 +56,18 @@ int imx_scu_call_rpc(struct imx_sc_ipc *ipc, void *msg, bool have_resp);
  * @return Returns an error code (0 = success, failed if < 0)
  */
 int imx_scu_get_handle(struct imx_sc_ipc **ipc);
+
+#else
+static inline int
+imx_scu_call_rpc(struct imx_sc_ipc *ipc, void *msg, bool have_resp)
+{
+	return -EIO;
+}
+
+static inline int imx_scu_get_handle(struct imx_sc_ipc **ipc)
+{
+	return -EIO;
+}
+#endif
+
 #endif /* _SC_IPC_H */
diff --git a/include/linux/firmware/imx/svc/misc.h b/include/linux/firmware/imx/svc/misc.h
index 031dd4d3c766..d255048f17de 100644
--- a/include/linux/firmware/imx/svc/misc.h
+++ b/include/linux/firmware/imx/svc/misc.h
@@ -46,6 +46,7 @@ enum imx_misc_func {
  * Control Functions
  */
 
+#if IS_ENABLED(CONFIG_IMX_SCU)
 int imx_sc_misc_set_control(struct imx_sc_ipc *ipc, u32 resource,
 			    u8 ctrl, u32 val);
 
@@ -55,4 +56,26 @@ int imx_sc_misc_get_control(struct imx_sc_ipc *ipc, u32 resource,
 int imx_sc_pm_cpu_start(struct imx_sc_ipc *ipc, u32 resource,
 			bool enable, u64 phys_addr);
 
+#else
+static inline int
+imx_sc_misc_set_control(struct imx_sc_ipc *ipc, u32 resource,
+			u8 ctrl, u32 val)
+{
+	return -EIO;
+}
+
+static inline int
+imx_sc_misc_get_control(struct imx_sc_ipc *ipc, u32 resource,
+			u8 ctrl, u32 *val)
+{
+	return -EIO;
+}
+
+static inline int imx_sc_pm_cpu_start(struct imx_sc_ipc *ipc, u32 resource,
+				      bool enable, u64 phys_addr)
+{
+	return -EIO;
+}
+#endif
+
 #endif /* _SC_MISC_API_H */
-- 
2.17.1

