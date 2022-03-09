Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB5E4D3603
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiCIR3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbiCIR3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:14 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E0E888F7;
        Wed,  9 Mar 2022 09:28:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xb5+w0gmKgbWt6ykmcjcbJi/LkmAhrroMxKcBAOn3nVWJ4MxkbhiebOq1hAjQJbCxR1058XqlhVPlErgkVSEB5yQEm4HtZeUniesxJE42relzZLcrAkz7ZEUNg2k8MeMg3I0v7Bo17InFWMhVewrswRHlB1FIQHrgpwKgVcKWQshNtmsYKBEFPFawTQwc2vgrXLZpARDpPQ4ytHeO5nsCjDgPH9aOjX9Xcewa78rV5St/QGDoosr335K3KgbiJn6alRdj+UwB7W0oYvTGGrA564IaLbG3PWkypCfiZ5j5sakSuoRt13RMZDO3nvQRuXreF4wcEXE/MJPlusJuiUGCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iw3Ycsma/+sJBmXhQFSTxXI/+6xRXp42ASo7U6HEBVo=;
 b=iK80OesHo/uxPHA8aK+9F8MM77SxYIQypHkkulobOHPT3AyjxCDot7Yr5kjTaGGXE053+uFitQkvTqp76YQM1ORdqmbD85JRYHhtTLg31i5O7Epie4AjJr4zFzwT0QPMWY8kAsMmPMrvCU1sjxh5fPsV+GvR8fw3aBVj2JPhK5sGSdiWweRuuPIaLsG3gbEP3z6CwoQYmpgslsK0Menep3lsvruLFApSe+QlNJQTz8ibBEEE7OFHkBIsrC21+mPnVGQHGGQKHIeSW1Szvx5GT8FI1+3sRsjvmU2+H18/QzE91GstsO8LtYx1W+EjgnmtK98+6vkrCt99aHogYCquBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iw3Ycsma/+sJBmXhQFSTxXI/+6xRXp42ASo7U6HEBVo=;
 b=fvLJ7NLHJY1FBE6g4txRd3np8VGBPP9vvnPV/lC8krK5ERxmHXOl2RwizZVV4hRvE4BX3Gib1U9S6jIvICFe5H5d7knvAu7JXdHSFhFiPa7W0/gxjgthYCNHGvUZ6mpBGmqmDaOyse/Eqo/tHbw9oj5LMx1i6HzgX45/WupEFzk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by GV1PR04MB9101.eurprd04.prod.outlook.com (2603:10a6:150:20::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.25; Wed, 9 Mar
 2022 17:28:11 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:11 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 4/8] dpaa2-mac: add the MC API for reconfiguring the protocol
Date:   Wed,  9 Mar 2022 19:27:44 +0200
Message-Id: <20220309172748.3460862-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7812c74-0139-480b-2519-08da01f22ef2
X-MS-TrafficTypeDiagnostic: GV1PR04MB9101:EE_
X-Microsoft-Antispam-PRVS: <GV1PR04MB91014D4F0B9A5D20B9CE1AABE00A9@GV1PR04MB9101.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DvTdfCbA52HEFF7Oxviey9AW85F6k7bq4HjqX4Dug1EYziDR6ZGCi0UMqIb2bvxg16zGu6I37cgTiLUnfm0OXUG4h1pKX4YszbPJEAKXyPn2UDwKbHjh0emZQjo6rxfVie2bgt4Hp8+XfURdx6Hmc17Ricss57M6YBblAbT58aUWMrt5qPmZsM6Ig3Jk8QtKF5FeGt8wzHW2vPlcle1rXwW0yz9ujErIBMFV1cBasm7TbrRVmBNa441sSwtglweKZv086+fpfymtb5QpgR+X9pHO4HGcp7UBus9OgxxmyyzvN3HfXmnFnFVvEph6jZjqUYM5pTtZ2BDy3qDObnm/JpblBSD1tF1nXt6gW5NWTObnQBVJSIDNFmTlVu4jQAdVEnX2Lpm+s+G6BfCSVjZHlXC3qTP7+powjkQ+SVCm5/+9Bv+l6Jc/5KGbQ8KayNjVaZt/LxsnB3Bd8ag+H5r3rsz+hUw3EzS5rDsh8X4AWFEF+28t6ty6zPTzjgnVnuLuBmgjLsFFHJLCFtrn9kgK377F4ciV/vb4NjM8sXYetpOuP4jiv3yg+uma9P3x/DKLiulvNsW+oS8gjlnILCtKyZjF9GQVcNVoqzzG5lbiLI2mGRZuQr3uvbYBW5T76BAHWdjBZzhS7GZmPgAdcfDIxslvBpxtymQ3Fbo1Ff9YXQcQITh3U9NpMQt73+BKtODKiL1VfJzZyE+wGtx0WoT8vQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(5660300002)(36756003)(6512007)(52116002)(8936002)(498600001)(83380400001)(44832011)(2906002)(6486002)(7416002)(38350700002)(38100700002)(1076003)(4326008)(66556008)(8676002)(26005)(66476007)(186003)(2616005)(6666004)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HbIBGgbn4MqqJiUD+u+fG9hxxdqtjeXf+Rayj+wvH0GRRmePjPptBnXDsWV0?=
 =?us-ascii?Q?oZ57HYM3W+2Dgz+cOD/PipjVHrCGlAM4/l8xXyvc+/C5/SUlFL9r75pClcw0?=
 =?us-ascii?Q?jIq8qQg5GxJ1/dF3Y/pushQzUleR/fxuAAJCje7DVG41UFE1z7QY6cigxPJx?=
 =?us-ascii?Q?DYOaZvQxlfXxLs+HEvcSIwj4g8S6YF0SGuwksx9vA5f/mpSzycWD7UE9fJnu?=
 =?us-ascii?Q?2KVa2DaBSuXI0Eq2nupTz3rIzaAKX8G/Pa8XYyxLsdbbE3oKJXC/Qs7wME2W?=
 =?us-ascii?Q?fcb3ntmuK7dZw7NCYiaOhV5GutFY7W6Z2Q4Ccw5q13F0kWUwVu1LPUTuUPv1?=
 =?us-ascii?Q?yoec0P+8SPeNVHyNPGjYg/hRuLgsOPAAZ2oxQW+uGbYOP50PBOLJELfXMB3y?=
 =?us-ascii?Q?h82NrQzPYSXi+Q8GnHdDR3Rr1sCbycnSwfTnIxHy9J6jZ74XCQCTYqN6dmwz?=
 =?us-ascii?Q?5B/RpJxCPArwQklXa1ut+PFfH6Tf+TluZIgjmg0WdrSB5anpTal7XloQL6zF?=
 =?us-ascii?Q?6VuGFPW6IBSNi7XTWXZZyVhuqM5jewUF/iSFw3TJnezXU3FIgeEZOCbvTbnn?=
 =?us-ascii?Q?5kb18I/XhYGB0CKhd2vxfxxCcL7Moz1a1WSvr9dKIolwX6YfSU+ddJaVt1Hn?=
 =?us-ascii?Q?NnSJSVGyv0Usg6v3YwUhDZVrRHTwYBK1/yiVEdTN9f+2F1z4K548ISiMPjm6?=
 =?us-ascii?Q?5JBovFJL1bkjX6nuUbcgLRYFzZqka9di/X2KRpXgOW+BLQIdVhOE/GMc+MxI?=
 =?us-ascii?Q?RK0nTWYNt8B7yP/iNdkf/B1O0iOs18ufkdoC//Xz/JU9VvSRC6D+SgBQiOup?=
 =?us-ascii?Q?5G874kDNI7lfxArIGiz2UbkXueYEhKdArQ/YwA+Hzeoy6feogUusPMluu/i4?=
 =?us-ascii?Q?YuUTk3VRxSPS7x2l9coX1LsvMKb08gSgC32aNfh9Y1p4cagLOFVaroHbkgkq?=
 =?us-ascii?Q?NHxr2nMD+QuaHpb3AXYD/BoDAhTqPOvbevMszvtV856ZOEUbzT5MN7PsMpG5?=
 =?us-ascii?Q?RcL/u7K/4eKEn7qauGOPHnV4h89/lLoFoCStcAbj/hQEL860609ftUmYxly5?=
 =?us-ascii?Q?SB/4DHoCm+RlnYbv6T9MJjmj3zDdShOShwLNs0RoDcWs0+O1ej907GAjf+3D?=
 =?us-ascii?Q?3LA4vLn4MOzjVR2Th2+ItDqmJEshxHR6EMlga4WoCnG2WcXBXVPrtZfJ0VvA?=
 =?us-ascii?Q?lTL7TSCPG5+5i3oi6zBKxzIE82134uSQPIEaC1JADN0OVKQ6Ex6fZ5CyKtqI?=
 =?us-ascii?Q?b1SDVPssT5diqb6Ywn/yLP5JgCPAl/NyjnkdgUBibQzCtexaT2YcYuvZG8tC?=
 =?us-ascii?Q?1miE2K95tivXiUcgBM5k5mNRRIcDRswBteERR8t/H7E1JekEtprdEUEAK8Iy?=
 =?us-ascii?Q?JFurBiOd5kqHzVxWHrPdKWXLnjAaRuBJOHEDT2s5xaq2YTEbzEPIjR9vD60Q?=
 =?us-ascii?Q?7eGOTmYmd9nEK3x6gfXZOf7FVMoWC3yY7b5+XKkNIaYQP+h3Rn/ortHZkXHD?=
 =?us-ascii?Q?5FRwH/zwEJqBFUYQh6wEQhDXmD1tgE5UP4zl35gpJyErk0Ve7LgIWPhPgZAb?=
 =?us-ascii?Q?CR+WRwlaN6qZdITFXDWOineK2FeHNL3K9LWWUcnAzZqnt9gWTzx7LUSI1Y/s?=
 =?us-ascii?Q?dAq4cEInYkk0I4+yLX8CygE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7812c74-0139-480b-2519-08da01f22ef2
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:11.2055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2v2mP5gMogmNg4OaewRwh/Q9YbS9W1sopZxL1ac5saFua4ncbpGoBtOUk8g8b/d2SWwUf+o/u0uEFtFE6PfP2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9101
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MC firmware gained recently a new command which can reconfigure the
running protocol on the underlying MAC. Add this new command which will
be used in the next patches in order to do a major reconfig on the
interface.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none

 .../net/ethernet/freescale/dpaa2/dpmac-cmd.h  |  5 ++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c  | 23 +++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
index e1e06b21110d..e9ac2ecef3be 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -26,6 +26,8 @@
 
 #define DPMAC_CMDID_GET_COUNTER		DPMAC_CMD(0x0c4)
 
+#define DPMAC_CMDID_SET_PROTOCOL	DPMAC_CMD(0x0c7)
+
 /* Macros for accessing command fields smaller than 1byte */
 #define DPMAC_MASK(field)        \
 	GENMASK(DPMAC_##field##_SHIFT + DPMAC_##field##_SIZE - 1, \
@@ -77,4 +79,7 @@ struct dpmac_rsp_get_api_version {
 	__le16 minor;
 };
 
+struct dpmac_cmd_set_protocol {
+	u8 eth_if;
+};
 #endif /* _FSL_DPMAC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
index d348a7567d87..f440a4c3b70c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
@@ -212,3 +212,26 @@ int dpmac_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
 
 	return 0;
 }
+
+/**
+ * dpmac_set_protocol() - Reconfigure the DPMAC protocol
+ * @mc_io:      Pointer to opaque I/O object
+ * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:      Token of DPMAC object
+ * @protocol:   New protocol for the DPMAC to be reconfigured in.
+ *
+ * Return:      '0' on Success; Error code otherwise.
+ */
+int dpmac_set_protocol(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		       enum dpmac_eth_if protocol)
+{
+	struct dpmac_cmd_set_protocol *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_SET_PROTOCOL,
+					  cmd_flags, token);
+	cmd_params = (struct dpmac_cmd_set_protocol *)cmd.params;
+	cmd_params->eth_if = protocol;
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
index b580fb4164b5..17488819ef68 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
@@ -207,4 +207,7 @@ int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 int dpmac_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
 			  u16 *major_ver, u16 *minor_ver);
+
+int dpmac_set_protocol(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		       enum dpmac_eth_if protocol);
 #endif /* __FSL_DPMAC_H */
-- 
2.33.1

