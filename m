Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAC528FDB0
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 07:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389655AbgJPFnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 01:43:06 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:8065
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388851AbgJPFnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 01:43:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnvS750N7Nfq5isWvZqrUE7WE7XyEsD6frH0AzrOe0uOwB1XkhZYO4rAErT2oU5n2aD14Bqn0Xv8LDs8liC4e/qp3hqUVWrCeyjNuP3DaJAeXnRVjWtANMpIpswzLZ7MB/sim5S0it3oZScNssm/Gif4ggDYJhaQbM95vj1ir6G583MD9vIvyN8Z3amfHcN2z80JVprzwJJsW8rV6V0Cgg4Ox0/06TauE2xRuJ3M6AuBVBRaWlKhrW9RHfs6GoGDcsFxjKcjo9NqxhND8So1qFSt2QOUWvBaUymed9jh0NjdbI1ihDJG9/mxmRZqEMwyy1RWx5uSV+v8lsE9ObwNVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDbAwQnA5enTI3i2f5XQgOnhhQ23eN6woNIFu1j7SmI=;
 b=XOdfQ8zoUPVu9osYZ/BBsOJbRRv9mz8EnWUH5AXIqxa5jHxRQi3V4kTzYLX2nTX2MhMe5s7GvZUS+cmjh0d8BifIvNKbzT4L/Zz7UAcckMVnc77AqPCGYMhbsj0uIgkEx7vSSfqNwvnIZIQRM3dofPB4059s7CbxxahQh3dZcHq6x8SAT4J74AfnufFrEbfdfhpmTefKJTJaCNOLmDx9kjN65tig+Z8Z87Z1VtpC/Q8+cSas//CjXevItIZADzDGrQVlklqul228+GL4Ljlz4uPIuE9hp6c2IHNi0WUWj6NGmwryV5PnE/Nfv6gmk6HmAxtmtWW7rqu7V1I28V/kMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDbAwQnA5enTI3i2f5XQgOnhhQ23eN6woNIFu1j7SmI=;
 b=W1wcKSr2snvI49D5qRdva/Gf6czTl4c2EhjKV0wWCg9Wv271p1gj5ktLzF4HkEhY6fEnc0FR2sCgth65cqz7N1pwM54gE9sgQ4DpSQNB4P+ttCk2J31S1uTLWwUIMwIG8SeFcLU7KjTyr5Hw1dAfZK1GYuSB41VP+0E5mh0R/MU=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 05:43:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 05:43:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] firmware: imx: always export SCU symbols
Date:   Fri, 16 Oct 2020 21:43:15 +0800
Message-Id: <20201016134320.20321-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0068.apcprd02.prod.outlook.com (2603:1096:4:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 05:42:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 13a9bd34-94cd-47c8-9123-08d8719657dc
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB733354260CA74CA5AF1634AFE6030@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WDKD7XcFlt/ar03cH+EJ7/oQK2PgHVjz7Pe1ymw2mJaDS8jGfxobxim1Pm/qkqBSe7yVKlOjiwcQ4adUczJnOV6b84uWmCXk9gzIQRu8LS75iWwgsU2gDcrYQww8kj6sd0YFM0vpySJEjsTpeKT5fsRZD4f77/YSo1rU0c5IdYy/Zeumh9+8ntep+arprEK8gqc5z09h2h01N2dKt0Wq+OzgIuR8HLIA0ykoPbEgzBn57u/gMCi38xVFco96aiiLHUq1AucN8BfWJ0QoI3/KfjG75rWAx1HNRxdkaKgRrKHqTDYZJ0rGegYjGqb+7haaZM1pW2bOn2bj8KsyBUtMjBUZj7BTHrGSfJ2QTSUO1P1ddh8E8dlsqPrhihuOFT/gCXkHSbDd/aoM0nz/kcdiRMbN8CT+E/q37rd18VvFEoA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(34490700002)(2906002)(316002)(6512007)(8936002)(86362001)(5660300002)(1076003)(69590400008)(478600001)(52116002)(6506007)(6486002)(66556008)(83380400001)(36756003)(4326008)(6666004)(26005)(186003)(2616005)(956004)(16526019)(8676002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Nn2OuamZEOff9hTH15XcBFljwAYmY5JlX3D6tLIOSuHkpDwBXZMAxXVzTkUoIuC3qnDLiEd5XxMYugI6HRmOB6c9SARLdP45QWTU36QZtU3bAWMGzyq6Uk0wpsvD2UCcmODitcOhiMInpHGG5w37DEn7HTySLJIAyK732j1E30Hc0ktWx+J6bdsEiWpp6QVlM1AQzdt1BasR03c3peqcv6HBqWTpD8FzfvsNrfpPL5a07bSD67n2Vf1x/zC24gQsYtUyIf/7mYPv0PvJF0W9fo+VFvG52w6J1IplAduuKAFBgBkrBsgvS1pZ0sCG+/Kfy9X7FK3KHDhGp3SENLH9z7nlp4qACTEznEVzXeH0bdLDYtoxoWTHlOGwDOXgp/3TYdNPOv1Lhk7EauDHeZ/th984KUOdlbQN7hfDvibpqbQ6ypfHjF8JjnITOrhXqOst+TMo7klfOVdliIQ90OVyhESQgYr+xlefr0oZQ/Iqn7FpvvQcJDNQJS4Yma+m+03EAPQmtxPpzDsli/mu/VRGVhTae/ENvBsiTRIwTwPQOeGwKlU6ZPuo4bHu90RMOK0loghJwx1Ac4b2nCyQY6j+b5nr+/ATAkkedrEZJ1h/j+FtfLaRHRvsEoqM+XkXiZ0dMmY9tdK01mUyxTgH2avoZw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a9bd34-94cd-47c8-9123-08d8719657dc
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 05:43:00.8420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHkB26GYl2BjizHcB8eYHSfdvBmuMemH+uXmMKLkcqxT5+Jwg7KK8bzLF+ULBdT5vAb9sgZEnk4ePavUcABIsg==
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

