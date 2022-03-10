Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49A54D4C85
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244598AbiCJPBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344079AbiCJO7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:59:15 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E68170D4E;
        Thu, 10 Mar 2022 06:52:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZz15AwR2KkCmTcn9J5CxLfjV6lBahYIFDCfHA+D0ctoLqTAueHeSV9FevvdnW9gbcwN+kVi2vgnhl85zj3zZsYy6dpqHC9HYroop9mxvrlFOXNJlR0fWfd21nrzgTdkjfJdeFM3JP175jN+CcqjMsv0nWeqd1ZhC4vwd25eAKDPZn0751qpvkBKW8p4mHwu0RzuSG++Mihta+fOiOCq/+wifMJFaoTVAioVP4ZqIcVp5vyh1TdgvUq4hNrMUpz/CNfcCSmzOiklhndwIE+WpaALzGpEvoaLAiMqsneyVjmQRtDR7/MTKKgmZYzFj36eEB18u6RjPHDBj9xiMLgL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fBIJvHMWv4r9AMpMsxzoKC4fiaQUORo0wrCWFuU60A=;
 b=Zvqen0DzyFxhlrSxLFNshR0mrs4d5BQygJVzkC4L8m21Sv6PPn3/R3zvxcwY8NiugJFZZg3O6vO9f8d+znEkhzHznZ2ncld5pD7pMrkc83Dljm77zaqZwwM/EoShPumWbg6VufzvR/Aa0pbORkURN6K3XN6ZH+r/p+UEiCevO2JGwNpFGfFIpy+LGEAXNDYDdfULItYRkFNAPp9RQDkqyVhCRkE+KDKAkfoUqq/AWtZccRSg7MooMogXH/dbx7VFtFbGXvrlLnIqyCiAcxUVY57eZx7BTkBGZdHk3UzsMi8jfCSTzv5oJ2Kz0jfRHhxJujWspR08VCV9wIFFXB/RRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fBIJvHMWv4r9AMpMsxzoKC4fiaQUORo0wrCWFuU60A=;
 b=YSf8hjuJBVstMDGHku5XVaB5MOuUiwnJ0WSHm5EhCU2gcI4/8DKD/tkjF1FM5tOnakQNycSA9VeXX4oKU87YrlupAh4uvTbstsPZm9Jb7xeDC2BfVC8wqHOQul5rxy2VTK/D9EN8wtGxVlrLt/0yLy05O5LMRzPgc/YLpt7mg1o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29; Thu, 10 Mar
 2022 14:52:26 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 14:52:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 4/8] dpaa2-mac: add the MC API for reconfiguring the protocol
Date:   Thu, 10 Mar 2022 16:51:56 +0200
Message-Id: <20220310145200.3645763-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0288.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2bbc2e1-4dae-4fa1-7680-08da02a597a5
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB728181084CF97489CFA586CEE00B9@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILXEwS7Ms3FppEgwPjOrdgzJ24ifBqv9llO9647VJrLfpo7YFl829gRuhzhy1oHR01xQt7ZAxgjTrDSVWvnR1uCLMp7JOcPDAhHEu9NUCH1jY2fU94n6tqcEdoisB/3Rj6bEP5tbFtTqH9w+BoDmHv0Dn+TM3NV4S+mTmTeaaXapJX/xwg6kKr70wtTOVpdxQkD3ugOGFUE1PwpfE0GnWkHeaWrLeVsUn7oJsHewIFiBPJjLUOgh/leZYE3Zr5SSms+kyZYQJyI5Dw5uccjfyC1VxJ/Gzu5kYej2QCBuC6b83fhbVKZJSFEmnMXA2Hj2dP+W9o0FfGuzLQDzDiAcRRDJocXpyCuu0en2EzeDwIqJP+yTTMaHHod3T7WLnYNlyAPiv3UUx0WFZ77cCbqcbT+gDmVWjM0azAB58lREP07t4pVZy7hI0bHYYvsdeoSp8WgX//HuNwYavs2N46Z/pYiXXIkko261LoPaB84Zh8mL39zs6iby2+oNPzHixxj/XeodIsFTrPUwGhjaE42sPISfyhP61uXRDTE046wyy3BA+hvS5WMmA2yYt//RTK5ldQB9zGUmeE5sZ9+PMfUF75bBeuBTP8RoCWj4KyH8/+L5ZbBO2AUkERp7vvosoAfbmz8X3jvw+62NO7yXfNUOmMnQsn4I+qJe/9qEeocYgcCowGGNe18DNz6punVX9e/IzHJJuvhePC7gR0JI0jWdNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(66556008)(6486002)(52116002)(66476007)(8676002)(5660300002)(6506007)(66946007)(4326008)(2616005)(2906002)(8936002)(86362001)(186003)(44832011)(38350700002)(38100700002)(6666004)(508600001)(36756003)(26005)(83380400001)(7416002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?udsZFuCqIuKPvIK+RQUET2Iuzwim/juwRiTeTk9ruSPazyMjQKHzAVGEADrf?=
 =?us-ascii?Q?oCcvla0VLaTAT1KxdtRxGK9Kbo+rvehfsZIa39KS+PH4otVTzJG17O4xVW5H?=
 =?us-ascii?Q?NVzKNL7FJwPI5sobZZ2spXWe1K+OPVnIPnBgEnmwyhKxcj/TRVWJh+T227Yt?=
 =?us-ascii?Q?5kvg/oylVQfjM4s8JN8SkYwbz6BNx1jqv/vhYyFr+Kih1drpN6psQ7jGMna5?=
 =?us-ascii?Q?r8UY+FIxfQT1nEDJtXQgRisIXMLjBrgO2ypUN09tFYfA+AOcJz+RfqnNGmLn?=
 =?us-ascii?Q?OjWl9dzfOmx0ArSaqKMt0zFG1zzSzMT0i+ILGF4pFPzOqfOoHBHG/efNLNgu?=
 =?us-ascii?Q?EnnCyU+z8LDuC7e2qtcodtgCW9pSAkAemkVI1whTrrmllmNyBMAtUIdFPQOp?=
 =?us-ascii?Q?4hxc7VwKPDx5eLeQ7LSrrcj94pBL++Sbx5LlucI/hSTv+h7vjxk+DLa+BGvi?=
 =?us-ascii?Q?6xF0UbptCfYTXW9aI1jp0ZSUmi9xAGK9d51DrfFl+p5js2x8xAyuF0B3JD49?=
 =?us-ascii?Q?oY/5J2Z3njcJPenC5WQrm2Xal+2uuck4YXVEdMxg9pcMu9xpXp43YIV3Aptz?=
 =?us-ascii?Q?fhDpovOg5D0HbXI7Jh3rl3UZlSpP8u9UF31KCa8VSuugesAZ5iFeDCSHvOER?=
 =?us-ascii?Q?CzDSFv/vFwzt+1nyu04fPAnVy1X6rmAMSDJzYM18ZZRerIBd5fPedSkzZGCN?=
 =?us-ascii?Q?KzNG6jITEc8FguAQbh/tXV37pUkmf59QgAl65N1RUgyhoy0PffXnqNRNQMVx?=
 =?us-ascii?Q?nbHXrhlmoKtwxowmZI9DZrc3tKILY8kMZcapvRI8TVgwiTNcL96sj5ey3VDk?=
 =?us-ascii?Q?jELYUFJNvxrCQBJCxXQVIZ2ETrT+vr4Db94PvmL0IoTpS9Gb2MK760KdKvxe?=
 =?us-ascii?Q?Kkt3BpMRG2yjkVBVsFZrSkc4c5LI5lNmJLc/ivATHryqAPiQbbUPDZ/GFh6T?=
 =?us-ascii?Q?5lsN8gZev4DZaKxepf/Wu50f7YWi4e1taACjTrHZe24aXfd8D2HX3yrVNMIw?=
 =?us-ascii?Q?PjyoRuCZibHYKzge0/cK8UKwuBHTjCzAGm3LQtEny54OLePfP8D3ANMQ25rQ?=
 =?us-ascii?Q?ez5mv+Nc3FwpFU/dTxPWObPRP1UfxjEPsgfveT3M4rzAdsJ1Q0gdkia15hbU?=
 =?us-ascii?Q?EUambzL8whLhOwyrr+w7EGHuAzDeHAtD7GkcZrNq1iEDi2S4D5bN1519Hu0L?=
 =?us-ascii?Q?GqdLyiR5UpVav/fd5lty1YqqQcoI1IDe087FukJ2omArWsI4uUT84SoSWVPH?=
 =?us-ascii?Q?VadynD0/82N8Po0bAsjl035jgiEt20U+Tt7lOowszbzS1+2kP5cBQNBJLTf7?=
 =?us-ascii?Q?w1BG9b4R2l1qnddUb+0iWpvUdPi1vlWfSUdWB2Ytbi9QR/HbfKvpw1MsgMM+?=
 =?us-ascii?Q?ZjPt3DE9kquQ4bFdPiig1OCYNkDI1eXkTPNnlZTR5IG8qKcogngGmCY5noir?=
 =?us-ascii?Q?niYSnEC3neI52k1EvotUlVCg3WlkUDd8pHG6gflsnxkdN8Urq5tAcUJ0UPB5?=
 =?us-ascii?Q?DlrbgfqexNj+0ts+q/fpyGARZ+QZ1NI4dFtshvX73Wvtp8T78Qb/FTIgQpsf?=
 =?us-ascii?Q?EniGWdObeNLJiLq+iJB0qN7/ZKCtXDBen1pxmnFZTVDASGNY6d/hblTfC1Ph?=
 =?us-ascii?Q?jjBgioyvz5VfSvnVaU7wm9I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2bbc2e1-4dae-4fa1-7680-08da02a597a5
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 14:52:26.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFsbPxw5DOU6DlnOF9C7jsVkiP4U7dDG4SOMww46BHDtz1aFHQJqwoHCYPTuLKgPt2dGF1JyctcjGeh9nU1f6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
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
Changes in v3:
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

