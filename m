Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828784D37D4
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbiCIR33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbiCIR3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:16 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8258594D;
        Wed,  9 Mar 2022 09:28:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHAJSW1KlsprbJ4SoacPdzWrTupZuhoAuxwPLg/iZxDEJS7kIAblc28zRaYPN8lAC9JlxoUd2yklHqrtjLPc1FAsA/b9uZu4avCKiiOfnCs97iaOAre/BUh1W7anHkuIka1yDJuWMaE0qpwp+vt+atyU8rpHVCqW7gNaEfTuh/VPODi1/seSz3MQLgaUCACDG8sJzftdjisqlJWMPMwK/DRsQJOHdO8Vh5ulTJoQE/8PJQm55B2WHXuN0HyFTvJJ1Lu0OFk17UO671MNRi+ohWHcsFh2O9AV4mwwLeXcG2lY0OoqP1AzxNouSWlt+kV4FxWoW7B1r2EZigE01gtg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNo7HTEsBVeuHUdmrNNv958T41ND7Bi9O6w3SiauMI8=;
 b=El/jbq8RsKkf3vENQZM7e7rZ8Fsmn8aF3z19hfOoRnqiJJE7RXNR5Igzl5+ZMFifV/pezWq6bnMjYyTHDOVDUAm0WU+MkWC6LCiyDcAIL8MxpBgc93w4sj/VOGVZLBr4y+1Capy3cU3v38eE40MgrOkL4DFJaISaHFgGIK19tzHFDT1jMQA4R5yHd8gxRBh6LOYiOpbdb9sb6lNNb8NO3HTHdjVe4W7GZIuo34lTB4sSwPhRKGZWkM3iQuj7YncEaPfLrtLlNK0psXYgLU4pxnLX5OhVCD3I5vD2hDZMkfaMwSvV8biQOWQWSy9GyFbLfBAZmsOtgVzyfYi4lnCcAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNo7HTEsBVeuHUdmrNNv958T41ND7Bi9O6w3SiauMI8=;
 b=TEsvtd7RLOB+3SLSojl1uczA+HHKNDXvY/QlmvSC/0q9Sq5EhzvD7Y5C6tsJw42uU2KRXu7Avp3KZ+Pz269IeLZK42hSBtEFLAp8eJHsYr49NZvdY3ftDd8FdRxqFDmFB0LBuMLxhHxNrvFaOIQeZUUDoRMKHJH/moYOJBGQ8L4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB9422.eurprd04.prod.outlook.com (2603:10a6:102:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 17:28:09 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:09 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 3/8] dpaa2-mac: add the MC API for retrieving the version
Date:   Wed,  9 Mar 2022 19:27:43 +0200
Message-Id: <20220309172748.3460862-4-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1d294568-9af8-4d3b-2b68-08da01f22e3f
X-MS-TrafficTypeDiagnostic: PAXPR04MB9422:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9422DE663D351E26CBE5986FE00A9@PAXPR04MB9422.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hlO3KJdc+4R7CkOV/I8MFTJTGn1dqZGWRwOtEWZbA6E8wfpEQ+fJFMmtkYNXRCluc1tsnrz4ZUNwdhG6uWDLHhouMV6538Jqpc4SxANP+noYZNsrJkOlEyFIjOeIZCxc3BYbVDerUH32OsKwIMdm8arY1OUwBWyT8RpobcQ66uMnJi8AVNtkpEYBuC6th2EKALjzan5o8O568SWi2uPJu7Uh+YkzJZLY2qUlii2KOAPea/4NkaHiHFhvQqUe99+FjSgRxzxtN1T2jTaDjp45Ut73X/nkhZ4+YBO1LD5V16lg30KNk9L7AuxdJucXkCQPWW4NBuXJkzsWCvsXaCsLJJuBA4C6AS/u9s261zoRNGnWJqNGUK7IknxXna+0KmLJALzFnHm5ytT5FhWdWsJ+WapmRBXyhDoVdDp6yNvAQK0ZetlF9XKd7foKG+cpmhOWjz5am90p9sacROPu9HvME//2WanYeIfV4ewaveMUDoCVX+btb61yHVfFtgpTYQqOEBp8MBWCHs78x7Hryf1BJwrkrMldU5hQnsYwihIDRQRWk3A35R4+19EW7DgY3jVx14hRtJMm73C9ikXWpB7VeFwTflhKzoCdDneTGPs9zq6Yek4m95uSluQqDcDdhyG9iJ9b/Fz7ghPcN9NfrIaNXzWDj9OMIF9iIyr6PAALmrDNlF1iu8TAShwxI0hWwh8VgBVrfcT1ZAV3s2uTVTGEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(8936002)(52116002)(2616005)(6666004)(6512007)(498600001)(6506007)(5660300002)(66946007)(7416002)(36756003)(86362001)(38350700002)(38100700002)(2906002)(1076003)(44832011)(66476007)(66556008)(4326008)(83380400001)(8676002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k9NlAnEurJ2VDamacx2XTQSnzTbsSosz+m5xzCw+EbSDIjLBwzEO74wqu1Xa?=
 =?us-ascii?Q?SVukP3LC+P5j4IXpTL8HvahL7ze6qO1rr/sxuKA6NVNJkKn8GfzuiK81ZWwh?=
 =?us-ascii?Q?4s2P9p1o+OypFFUIJssWjsjB1OK9Si7IyFH/z1djkcggm1/7+UxTpNViSVGO?=
 =?us-ascii?Q?QHlvUohf+I7O9jLdHv6R7OVhidSdBNGjBqCTW3Re3HtQFan+f0kiymTCOE4r?=
 =?us-ascii?Q?A3lXzCz+IYJedjK4yScW1oSV0KNA/WectJioBTTnPPMWaXg8vHZA49Kg9up4?=
 =?us-ascii?Q?QuvFQqKwfP/S9d07i5x8W6RL3t6f3mzDJjSbAufBPrQWXmkayphyTm00MMI6?=
 =?us-ascii?Q?qiEGFmQKxP0se4CXT448e3YnzYs1HPBblH+jsmRsH8+c+tsIomkGRloDi6WN?=
 =?us-ascii?Q?mkudXUIWUv5jvygK3ba4ljxTAT/7Im9ZFpl7DdaNncrvwJP3LXZbF5v01Qnr?=
 =?us-ascii?Q?WzJtb7Jpqnu1x9pUgKOKM1aSNNwKdlgnHT4A9h+M/P8AgNFvUx51u46tzciU?=
 =?us-ascii?Q?IVgmrOEV3NhZ2NB+U+CDdQ0Q7hIpnHDZaBV2WBZCh6d9QOitSnsjXhv7Mhd8?=
 =?us-ascii?Q?sLNW4HiKjqTeHGM+1LWWTP6Wh0lxe0T9+baIU/5hDr89OkuL69ohS6kb/0Ou?=
 =?us-ascii?Q?ImjKye2Zj76Hfa4QDTY70QiROckISN23k+K9cf9+oR4SZKK5lsybvLDV695D?=
 =?us-ascii?Q?LnZhvIWcZ8DMmyLgdTDGNPZM39wuWDCxPrAFiS26x2Toq75kihU7y+s/WPp2?=
 =?us-ascii?Q?t7QypSyVKg0iCaTzb34/08YkfFIY8AplnwAENjUSYosgJkjs2yePSt98T8Vi?=
 =?us-ascii?Q?pZeRIPzkzOoeJuBza0/+ZNDzpE5jKFTLSsgqRxQY1FGhZ+LdnVnQL6vl21pW?=
 =?us-ascii?Q?Oa8R+Yr5BV4qJBDmmhOTmdRBaKTEKTXbcYLu7XssOZ6duLWARyRjvDxEbA7c?=
 =?us-ascii?Q?dUt7nfqq5YZt52SUvk4YKgDy+WBOuN3Gp5QNvy1J5wJ1PzHAgdMTMx2Yse3i?=
 =?us-ascii?Q?Qsns5pQdd68VQmn7fOMs140fPK5vPPsRK4jNZeLblqXngMJRxO7iOraucb+a?=
 =?us-ascii?Q?P1GypH2PN+kR3BwtjnHP4m5Yq4OtMx/hnjfwplNNyWxRVQwmW2nOoZfrmgUq?=
 =?us-ascii?Q?KVs6Hx1CcgDDFr7NsBTleLFNf2KOHEB3FILEM7D1bto14dGhYBCxaiB7CrjY?=
 =?us-ascii?Q?mr6kbQjpbLU5AlkA8eQe7M0goAXzDcNG0FZeDigPB08VVL/FXz+VF17bhz2b?=
 =?us-ascii?Q?+n2rdalk3hI316Uw/cmqMZ5AUS7qIs3r0YoC+6yG+c2DbbHkheTDKIS6ltm3?=
 =?us-ascii?Q?vhVyEeSq8KGnP9axuUsr4Oo2doNvk5OgalQ2zCWN4nM/weZd2FCYH09dgOCK?=
 =?us-ascii?Q?Cdsa1vVlSRqdocgqoHW6oehHFbsFpFGAfmdZwoXffHqr0bdqVys7Ui5yiPBT?=
 =?us-ascii?Q?DrWQNl6VkDnZ25OlcnT++35RKvvW4Zr5RqS7yIVwo265aOgzljMN/bnfBTEO?=
 =?us-ascii?Q?TcqTHRhCL9Sz/SVegTO3f4kcsgp6qczkNS763GkJXa+yJJDsBvSQ9sF7Wewv?=
 =?us-ascii?Q?bIfM6PQoECHHWST2FgrJ9HplF9/4n3AcMqXh6GaqYeBQ9xGET60oso7z1RLZ?=
 =?us-ascii?Q?ZsHT0M6fIXIruInxq/gy1Kk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d294568-9af8-4d3b-2b68-08da01f22e3f
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:09.7201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9DsyZ0h7RDZxfvP3tkdQQD2IGhY2Tn1LVmZu5xPhYpa2Hq06SaPB4hzp3jNSOdXKhuPth0ARCXC7Vd6ZqpJiaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9422
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpmac_get_api_version command will be used in the next patches to
determine if the current firmware is capable or not to change the
Ethernet protocol running on the MAC.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none

 .../net/ethernet/freescale/dpaa2/dpmac-cmd.h  |  7 +++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c  | 31 +++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |  2 ++
 3 files changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
index a24b20f76938..e1e06b21110d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -19,6 +19,8 @@
 #define DPMAC_CMDID_CLOSE		DPMAC_CMD(0x800)
 #define DPMAC_CMDID_OPEN		DPMAC_CMD(0x80c)
 
+#define DPMAC_CMDID_GET_API_VERSION	DPMAC_CMD(0xa0c)
+
 #define DPMAC_CMDID_GET_ATTR		DPMAC_CMD(0x004)
 #define DPMAC_CMDID_SET_LINK_STATE	DPMAC_CMD_V2(0x0c3)
 
@@ -70,4 +72,9 @@ struct dpmac_rsp_get_counter {
 	__le64 counter;
 };
 
+struct dpmac_rsp_get_api_version {
+	__le16 major;
+	__le16 minor;
+};
+
 #endif /* _FSL_DPMAC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
index d5997b654562..d348a7567d87 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
@@ -181,3 +181,34 @@ int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 	return 0;
 }
+
+/**
+ * dpmac_get_api_version() - Get Data Path MAC version
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @major_ver:	Major version of data path mac API
+ * @minor_ver:	Minor version of data path mac API
+ *
+ * Return:  '0' on Success; Error code otherwise.
+ */
+int dpmac_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
+			  u16 *major_ver, u16 *minor_ver)
+{
+	struct dpmac_rsp_get_api_version *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_API_VERSION,
+					  cmd_flags,
+					  0);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpmac_rsp_get_api_version *)cmd.params;
+	*major_ver = le16_to_cpu(rsp_params->major);
+	*minor_ver = le16_to_cpu(rsp_params->minor);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
index 8f7ceb731282..b580fb4164b5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
@@ -205,4 +205,6 @@ enum dpmac_counter_id {
 int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 		      enum dpmac_counter_id id, u64 *value);
 
+int dpmac_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
+			  u16 *major_ver, u16 *minor_ver);
 #endif /* __FSL_DPMAC_H */
-- 
2.33.1

