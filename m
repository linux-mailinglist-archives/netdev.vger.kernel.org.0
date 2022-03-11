Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4414D61D6
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348690AbiCKM4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348675AbiCKM4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:56:10 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60079.outbound.protection.outlook.com [40.107.6.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E18B1BFDE8;
        Fri, 11 Mar 2022 04:55:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLU9wfbw2Ri5oATyvcDiEY9gR/YvzZavy7Ta5nw4MNjY6Utn2RsOhWdMeyFxtok8xTyEpP9goM0Nk1cdxXTWZwYykGVMDVLB+RcC67Xi1yp7OE62dFu9IRBPRH2BUiwq6mpPXMHs0cNe7zDLE7qBMEcT3BoLjb8LH53WInBDFYJ/TzsiKEybqtSmY0JCVux2I4v5mR4P3aVO5Kack+ceejoFDy2bfWWno6z4A5rVLKlTqukrdi1xU3qnwU2uLVQnDM3WkcYgiM9Gh0RlDNrYDh/Fe/gafrKPGZ+3C92cyzk5RkWsTSYYvVy6IULfZRzVurNCCuskYhPs6CPmlHVgQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xx1bfnDpKmeKksRKzlhPQVt865Yn9+yqL59/h/9SHqI=;
 b=AJyxOrYvz4gfc7Eg2ZkjoRszwvHp12EoDSgp6RNagr149XHbtkH1n698x1jloa8nHdQfZUPXcpvew+QYiquuVRs3lvVceyO6l47FQY/UqcQZqACDy3RpWV/WQ1ERfZUYq6bVqNU/ZC94aO5ZAPKlPoXIdunmjngz5GI6kMJdSIVgBWF0eWKrxpL4rchLxHpkiOoBNS8srKzhL1fXDtKkZCMY8GOuuaYeyaJ28GEE1eOc4mAfo/5Sc6Hi8jCUTxpJs9f7f10D5Fao++LDDlO/fYlTHzHbz3F0sUOj8qE5Oyw3RuXzphA+tn76/wYU4blGznAmuomRJTogL/DlcNjzyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xx1bfnDpKmeKksRKzlhPQVt865Yn9+yqL59/h/9SHqI=;
 b=WE6DRSWAl3hVgEpl1ziZzKCOkJZIiudKRsBM9WdBJTTO+eMF1zvAM5GPHoNGIBpMZ4u3ojIiokks01ZpUCPM9R40A2t8BGLYsm0MO8q8lEbcpPuvsPqJPI4328sr3Z24mFyZ+TaqjZ/ivngf2LIBBjNy2ubJQTbQfiS4wkbIfOg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM6PR0402MB3431.eurprd04.prod.outlook.com (2603:10a6:209:e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Fri, 11 Mar
 2022 12:55:03 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 12:55:03 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 3/8] dpaa2-mac: add the MC API for retrieving the version
Date:   Fri, 11 Mar 2022 14:54:32 +0200
Message-Id: <20220311125437.3854483-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0402CA0014.eurprd04.prod.outlook.com
 (2603:10a6:203:90::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9af508d2-3460-4fa5-5eb1-08da035e5c1f
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3431:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3431E2AF0ACBC8FE62EEC33AE00C9@AM6PR0402MB3431.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uO05Fa8oHL9SXnAt+dmhBZ3ifnDAI6lbTpMAugY+yoQ3WedZMN6GHPxh3SLA13qtbWxH5vGlfg2kECVsdTAYiGWw5oIFRirmkKCZDZeg3l7E6RGDGrbvs8xmxVTY1LL96VVuevFbalLF/1C9bOAWY0mkn8w4+kEtRCkO4wNrzHj01jFNpIYYKKAaZdYW3ZcBXd0q4cscbgoSQcfPclzuwo53CAVezL50cR7HVJNWf2YGsyqFeKcnIKYJnWHRV6eNzXWtn7yNwVpK99N9c5IpPTh9SBMsL+zGiXHktcjaa96ksRic/NmZyyK3lyeAI8MOvg7/6NReoQVP4arP/E8APgl+5Jg3e1NT5iJzZBkLr4inx9HQRgPr84qQJhvc7Gh3bdCRNcOtSxfPHqSwq11jflsBYWmObjm8w6Vx8yweHfwLHb8nhFX4RvXmwjkCZCPodMymHIy1NEljgJQYSZXB1gtwDnJjs0ome7s366M/7zc8jn0Ku0fSRAqU88/W3gGLDTkyIer/zURMnyyBUGWxO5qLOrLmZaFXKXHLr86ibb5cyL8OMo/FDQbFaormRS20+zYLDHVhnZJJlZJ9kt2Nib4dNjY7CyMRKQSIWPQJXWPYytzDUO/m41g6kH40VyGV/Q3tAcmgaLKwSgr3VbQ4r7XvkSMtL0jgu4lk05MZa0kbwAZpgvcsGQbg2ScciNOm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66946007)(7416002)(5660300002)(6486002)(8936002)(44832011)(508600001)(66476007)(66556008)(316002)(4326008)(83380400001)(1076003)(2616005)(6512007)(52116002)(6666004)(6506007)(2906002)(26005)(186003)(86362001)(36756003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0GD23OQPGRqTiM4z9q73mfve+WZcqVD1Ci+oSvHAGA//2L9AwwULW7ciyHR2?=
 =?us-ascii?Q?KbLJs6WXWdn9qcQDesVUXvyHExDzbI6a/R5FFowvATdTmwPXDypevt8kp3tX?=
 =?us-ascii?Q?/RjdmCeMzGY7666wg3xmrHBvJhwXUfm8i6IZV470QywdVImJrwr4pE54JSsY?=
 =?us-ascii?Q?yMZcxbvF/ikbAtZ+kMr3cBqRv0qJ8akwGB7c4Y+LZVZfYEJQll10cKmLSp1M?=
 =?us-ascii?Q?Fib9KnAsYab01gpO33UDq4fQxPLqKr38FnlRqHTDEqhNs2Z7MxzByX2HVqq4?=
 =?us-ascii?Q?ag6Diz0uXrL0Dq1i6l0U0prjJCDLvHiNH8OKox7JxpA9JzNQjGjMSy94VqhS?=
 =?us-ascii?Q?t92Ov/RP4kkVodokrQfkx7U1rq9/8q/Gm7zRBFNLhtFmEnD4C6tx38Vh5ZtP?=
 =?us-ascii?Q?t0QmBsI9viD0Mn8RmkIvsZMy+YZfHfYjquoo99TUzStYJmkYpOTjijwF/vuF?=
 =?us-ascii?Q?nT8E/LvEMlKPKFUP9bSGrzLzcartSp95XwPr7eZZcsSnDbOHAkpwXhjkIOL4?=
 =?us-ascii?Q?rHAovckWaS8MVgkY3saG4S6AlODcekFe7Qi1NLehNQBswDC/8ACRwA6MmThR?=
 =?us-ascii?Q?S64sOwZ/wjorkizEwdgdxP3LG+Rvk+vfrxcogv+RrXkFlKk9T5T24sEcc8Y4?=
 =?us-ascii?Q?PdRUYf9miADkqMrhBHvAFfWoAgV+S6WluUku8Qd4WPywDIuxYPvuUWHWDWey?=
 =?us-ascii?Q?VHOBqLUskFfq9WXqbe3dyKv0AHE7GQ74ODxX7umvAj5RRtoydRXB2TgjgueJ?=
 =?us-ascii?Q?ke3gKKC8hQjmOSs2OpuUfSiex4qjgeFf6CvXCw6vc6ueEspFhjFf5xx5oEqe?=
 =?us-ascii?Q?tFwJIhwIJg1p0x+tnChZX669UE/bVzqrXmLaQAgb8JbTcvTs9dSXAn3r67HB?=
 =?us-ascii?Q?OJzXXOzavuIhi/PhXNy1N1cl/tFzLB94LjO6nbXPoKHyyG8JgYY4r1LGbhYO?=
 =?us-ascii?Q?6A+DCmyUf+QjdajGKzOUhgmCfmDQdqD1bPXL1X/SLdpB+X3t2O798i1u0YlR?=
 =?us-ascii?Q?tmZegUABFrTaB2dqgT1qkXoiFdNfXHdpeHLC8WG1fS0EExc6jKQat6R3FXN2?=
 =?us-ascii?Q?wVwWbmWmiOfd8cXNQ2BdRbFLAZg7nz43D3B99A7vmXJm0ExmjfiCHqywDRwK?=
 =?us-ascii?Q?uIvrKdIYeAlGx9DHfYCBDQkws+V2wVin+f5/ZvDsi+s1WFo60SH4PUG9iHIa?=
 =?us-ascii?Q?aRCOQQ0zwfwQbg5LWEMNRQPomURcx0m2hnUI9WarCB0MK/cH7yg19qTJ8GsT?=
 =?us-ascii?Q?amb71xyiwnzaQ8KLhBR41be0sq9LEmMfjmei3t1rqkZIGEtmypsGzK8rwmp0?=
 =?us-ascii?Q?74q8Tm2RxjV+JRTZ20whBY+metNcnJQwFAq8+hwRkDdtdKA6CZ/ZvbfDdf+v?=
 =?us-ascii?Q?tZAIxdCm06gYMPfBxsfTy9gpHfW1+B0IQ0NB6qhI4SUti2GF/+wcXy0c6YYt?=
 =?us-ascii?Q?lbVnOreY2O/xvlNhYxqkeA4p6SEhNgvb4wAT9QWvh/6Ua42yJypuOryCLwHk?=
 =?us-ascii?Q?oWiynzgMzUD9yMpdEx0mBz9JgG0o+rw/+9/TQLNtyg+d81R9sVhj+ccvrYTp?=
 =?us-ascii?Q?GLL3WNk362zNagB+5bZWF7yOEbp5DJpMNoO0toUluSS3LyyYUfgBODdEi9wY?=
 =?us-ascii?Q?TnrthGDsES38SNZE7KupSRo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af508d2-3460-4fa5-5eb1-08da035e5c1f
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:55:03.5121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ne0/nvtqL8/pe0j1Vu/Cdhazlajew2USteD0bS3IIRrfSSFXBZKdUzqy1jI2zjwmI2uVsuCq+ZoQeClPoHJddA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
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
Changes in v3:
	- none
Changes in v4:
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

