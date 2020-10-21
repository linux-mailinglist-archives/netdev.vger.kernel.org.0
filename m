Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E8D2947D6
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440466AbgJUFYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:24:06 -0400
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:29223
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407460AbgJUFYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:24:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2FHJgMQu9NRvziGayr4YsLGNDNhlssRsVExL6i9Xa0Yjpf8t/Fu3+86UUPjmayds6fNRvgKNlcwiHx+9QcussY7zMdJffh6H8JI3yWoc6WYM9vdhgYTJC7tpvnlKsldELSwhECctJkDHjWW/QKO9HIcCuYhYO+PnoMwO4KyOFY+LSFji+jIbngRv9CzhX3OszLHqPAFBbJApWGXOLhaOh71iLThx1Q1b8Fag4qX2kyGRF8rvzC8Wuc+iYgmHxo+kcScHOODKOOkHsmdoXv20wCpae6xH2j4xbStJvi5Q2ee5CtoQ6cABxp9komS1HHLh07fWSboiQ1vW11gqKyPFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDbAwQnA5enTI3i2f5XQgOnhhQ23eN6woNIFu1j7SmI=;
 b=MtPJ4pogxHLFryXqmfmeMeTHHyipZ2bJ3OBS7it2lEHCz7Dg03Eq4g8eqKI1dV4u+Q97EY6d7fMQlnH3tWKnShXN0RXH/ztk5mksuz37fq5yKzZm6X2O/Mk2Qh9zWOUxtZRm3oT8hLmAnTpxTMqzzvXt6u3WxqCGJ5R8SOnoDpSRUw6aYWGBPUcEuCeKkP4CKaDeLosZ+/C0oAFtfdvyEcJgHvpQTvCynbmJTuqfZvqRjKC6J42UJJoI0hoaJkFdaLS0m5u7hNNGuBl3ElxcfIrBsgi4ZrS6tvAaUpmfYYB1BBAtIMjh8oE19xWDEfHhfKsKxMhvsYI70XCJyjfqJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDbAwQnA5enTI3i2f5XQgOnhhQ23eN6woNIFu1j7SmI=;
 b=HIN8JOZlFIcFeyXyOgje6mkm2cuBiPPJtkbk2YF/RVgv0WPM6ZXmLgISjb3w4nCrsVzv61j3A8vicEiNb2jho7KFuNNM9AyMBLE8a0CQDHp4fBODQodCfiXnAEK3sgVOOM6iWJad76/CqR4OOr6xyFhFPmBQsk/KRFnkQGvt2As=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 05:23:59 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 05:23:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 1/6] firmware: imx: always export SCU symbols
Date:   Wed, 21 Oct 2020 13:24:32 +0800
Message-Id: <20201021052437.3763-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0157.apcprd03.prod.outlook.com
 (2603:1096:4:c9::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0157.apcprd03.prod.outlook.com (2603:1096:4:c9::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Wed, 21 Oct 2020 05:23:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 752dec2f-3708-4e08-f412-08d875818368
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2726FC1617D6C83819D2B10EE61C0@DB6PR0402MB2726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86sVCjnLBAO7W6KHhiDPZJmNzuHo7JaMfG5LFIlQanzheAHPys/FrtU7LKtvrNorU9/wJyLyl8bwJ3WtrebsVatYu1mHz54a/V/Gi8e2ruO16HjW969FNllOFBVVjb0q0M642CSzFiEoXHY2zuQmLsUih6yJpQem1PLUDNZYF3y+sA7HdIMywnjPXdAPQXA4e9rpkbkEXQZ/l3B8Ksr4kXYdRTS2QpEwitBKi6Md9jcqMx4jmUwir8brZK62+eTMepQQmXRhOl2w9Fep0stYqqD40NE0UVnsLSGGh9iMVS+rX/WTzscgLGx/1WtCCoJzhsyAo1NUGINplywDsi7Loy06RmWNoLEgthP80rVREZLAxstRq+PBt9zpkQwsJfpR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(478600001)(8676002)(186003)(16526019)(6506007)(316002)(26005)(52116002)(86362001)(36756003)(4326008)(66476007)(66946007)(66556008)(83380400001)(2616005)(5660300002)(6512007)(6486002)(2906002)(8936002)(6666004)(956004)(69590400008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qsXbRmySg72wyrQHIF/55U9pJ9q3jwNY8q69+WAjk33K5AF1MkS1lMetHwa0fleL4DWjHPQ/rxr1Dl3DdAiKv6rCZ87o0IWm1kOFAk/v7usaF2+y/7WjJJjkGEOF56LJb0gpV05ya4meAi5AwOEpSljQWO/BguJ98cxcTACjEDmct9AmH7bB8r8jcYBFxF3lOBp53tIjii7901kclti1CUJESn1B/v7sKyPsKKKKX5Kl5pIFunhVxuNqbgmrq4JBkLT0MifaV7Dj/d8/PMh7THDa2T/smJxk7aiVvyxl10nFqk7QCMkAp3Dh5oJpZTggH/71vi3hw/+4UrO1C+nxk1AZn1cW8JDB2D8a8mO2vqf5hgmFRexJw8+W8SwtI2TsdCloziciWbyt28XugjslN+i8KpYI/lMRpqb66dfiQcRKg7bf0d7SylGoBgrbDDukHT3IfAHkdJaci/iqGRC3fkAt9/oCWUoU8R6eh2P6TGg2UoVDH7rrsyuYQk+WXyX6vkGBo7ME7koHV7XDB7oKYAWLppcrklLfBnPTdkDWvGt5OPQ3JSOCkaZKwlPO2rVDK2igaAK7YDq6oxggoLyKV8vWBRvZTIN0lnRzyj5/SjkxBvDc6SVLZ0cne9ikRS8FWhyPiSiyLJsFCwVJiu9Phw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 752dec2f-3708-4e08-f412-08d875818368
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 05:23:59.0641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAJujuX6c8vbR5JtDRfJiVs6kEHXdGREzrASItXAvodjDsJrKw7peXWM3ssmtHvLIoBRSeBPztfEdVvhu+Qa6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
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

