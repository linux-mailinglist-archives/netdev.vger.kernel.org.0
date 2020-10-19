Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D8D29232B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgJSH5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:57:45 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:12225
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727420AbgJSH5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:57:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5uOqsKWpKiH53eoGfD/jq4fD4QKn5VMDn7BeJmUX4oQxRZq02BzDo+FquaV+gwcRSNvbNMzSONTUc9HoVi9xqg6wCsTumJ/7Tjpf3bP2wyJGzEqFjQKE32miUyYH5wM8HuDg+xByhpjMkDzmC8mPz4Bf47xJCx15CwBypo2F/cupB9za9zzpSUOMCCWfXgSD35dhLgsexAJsM4urgoce+cx6T/iyagqco6bdiw2i4rXa7QhOgqtgRqbAB+2G421PgxEnGbB41u8JYebRJ1cPHG8iIsalvNd9SxadB33dif/+E5yYbr/N4vgqxn7OiN3gqxtlY++lmJB7tSYucyqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDbAwQnA5enTI3i2f5XQgOnhhQ23eN6woNIFu1j7SmI=;
 b=H37QGilN9Z3suFh7+j8e80MFiopMCweRLwYxjwNAD0r/kHeG2Nu9lgrVI1+C3gmpkwEOooOdCY9h6jDDsgwInENFEzr0sw90xzIccn2AN+DM9czVu+hLU7ht8Mw3VnjX14Iy+SfxufBfBRkvLcl00vTz4r18u2i5vTH/0wGweNiCSWOoyE2yqPcpjv6vtDyvJhmFR7S7wv/8oRHpbN+LJctK1mksDCGpEZzCKIhV7OBeTf9RxqxYMRlxm4UZj/hh4JrOPOiHJZXqMmgKscq68Izp427/NdSpnBbjVIyeRxatx5mY1/uoppg0/zUg7AxduP41El/TM+yeCNx452FHQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDbAwQnA5enTI3i2f5XQgOnhhQ23eN6woNIFu1j7SmI=;
 b=g6xhdVPoYVhtc+f3Z44VWCQAMftnETQT/vhs2zLVyLS4cLAbBGeChnXtRD7B7h8a02xk3JywmUaNOnVu70YUqRAn6vUBIO3/al5aUKXp6u2EgsX4nDeGw6vGAhNiHz4IHIZkxbV/d2PHWVPOrSIynPUFcK5zb6Q8yr0XucXitI0=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Mon, 19 Oct
 2020 07:57:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:57:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/8] firmware: imx: always export SCU symbols
Date:   Mon, 19 Oct 2020 23:57:30 +0800
Message-Id: <20201019155737.26577-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
References: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:57:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 828803ef-6097-45f2-9473-08d87404a73e
X-MS-TrafficTypeDiagnostic: DBAPR04MB7430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74308AD366AD2F19578A9276E61E0@DBAPR04MB7430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lAZaTOyv0rnmxgDhEfblBZ5LEHGzOXH+z4oWWq0jxvNH1zkuuz/mRVBPqc0u7sIAL/epHd2gYY+3QyXeVDdygaoeK1UV1zNhpBvkQn79oMpwG8eIHlwABoMrWBBopdTGmY5zthX2Pc9QhCAf6IQq6WnGJUHvBiLHMEyfCK6zFR6pMwCs4BgKTF6pAmLpWueFrBbQNZ9roPFlqNvoCmtNFceF00mzJgy04gdQg4i60UaArDI5p4SEQh6dsivwP3fm/7k3K2aZAozIvGR+WDqGaLdphUmw2tApcBFaVyFIPdiiQMuOE/NEk1eT6jh+U78mTZQR5vlOE0zdlG3LHSSiUuS0Yso5jt8b4FuwghOQTJhTcNFJ8YOHjnUSp77lBAzJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(1076003)(6666004)(2906002)(4326008)(956004)(2616005)(316002)(5660300002)(52116002)(36756003)(8676002)(8936002)(6512007)(6486002)(6506007)(16526019)(26005)(186003)(86362001)(66946007)(66556008)(478600001)(66476007)(83380400001)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MuXqvkdBK1g/cRiwLXK7r4Xf74UYh4fetPvwEUYT4l9g8ZJtWOweKHXqqbw6hEbAwPlsn0/T3IuYu5zTPN3kvh5LpD23wqk5Dz0hn9bcRMMFE9yCugLWKr5Y/EJFA5nLljKgb87F6g8kVfkCAO4DmhUdAafqccKYEWhMstqCTM1qfH3qjf41uKjz00/UWKhntb3dPbhmTRnogOrrotG9jHicRrqNspC/VAfbcWd6ugCoMvvNVVfn9W8YXQ0rkFFyuFRCnpviSwHIFP3z5D9XMC1KtcnLh7UbTJSaCWcII2Slhcxpr0KV0htfbD1Jr+gQ5uH6P56iBfxh8WrMknO8LoVQGKdpQwUGaiBIZaYJbM0QMVKqOk8s2FZZxKA5Y9ch1HtEI9vHVHOy/OZEGbi3z+FMFBRIR4QJfedRv7oy8HDRr2oIRagF1QbZtEEjCUXF4oWLCF0uYxepeluC/ae2QRfNtxktjQCbtyteLQCqaWY5zLM36k5CP6mRC02XpWD/70Ft6JqqWZvBZOy9lkCYGwbHrLqurRqBIDZejiuPhynFp/K/E6gGHNqoRB9NtulvV2qabZ7X+p7Whg5Y5b0f7pu51Exnv4F0jOwEHz7Pd4+dU4hhYpInfMCVWE7a2m+mfwGi2r6dKpNbYe1wldIl1Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828803ef-6097-45f2-9473-08d87404a73e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:57:41.0360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5sTO0Z+oAj3KWS4VymHFpixV11jXJ28rVrtPNodzGjK7xbaE0Xhz1aRbqWgcJJw2l8kB1nKveGY8hEymcLIJlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
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

