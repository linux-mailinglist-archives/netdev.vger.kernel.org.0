Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F8F4D3115
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiCIOjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiCIOjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:39:22 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51C3123438;
        Wed,  9 Mar 2022 06:38:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLOuYvfcZEBFUfrnAdGo3udPHdObzOkZ1wvIUKlyzGXiO2N8RCU6maOpmXymGWZ9MOh2iWEqrXhoVfLliKhSAc47M8xHIle0mQpJm9eD2FhsEZSnpwyuy4Z9nbD4/rLa1BzBs6gFhITXnptkULf4UsnishswmPfIQvcWnR0jIy8BJ3yDBzv2k2EP9Yl3fi/ZJTJCruSIasEftb+fl5CFxTmMDxxivbx9ofWpJxKNdpkCDGkYtu9RG31oRtKeJ3pxawL+euFvr+oKVngd0R0UfIdNJHYllrsFcxXja9V+NYtJk5EtbRPU53TBZIh8e6xux9hi2YrSllq+vi5bEvjXkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NsPnYMn0htizGz8V8doalWPU6+1KAqrJL9WN9FibWM=;
 b=DV6VBa0rnEup496A6ItecHunO2VxzqaNvgL9yKVpkmne2lHcTgVjTIOZvX9zot2LzsqkRloTqOCAAPFvjTP1z9srQ1G2k7u/MEJYqEer4ZUvE77JfjbTJer2pY0uQQJqAmA5kCDcc2lwc9bJmCTbs50qFwPtLPvOokZiuz/E0iYrJgcZgi9Xt9TVAwNu98ObSArbhAS5HTnL7AE7ubB1vAZ2FKOf89WR3MEJ+tbQrmet78hYjXbv3o5D3Fr1NZByVDNBBdQmDhJlZgMI4GNXZ4s/2qEYc42zQGzvAm7LUOYdManTrhJ1Kf0oDSMMSIh6jlnifIzozGfHI2W1Vv6s0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NsPnYMn0htizGz8V8doalWPU6+1KAqrJL9WN9FibWM=;
 b=G7rzsO9BFeaNEOrNEy+fFZuIgUHhtkn3newQIeTGf/mOpOZCkOY09ugWBonwibyOSgHvRysSCyDvHIy6xzqEbZmbRRAa5aRxA82Pv4W01Tp02ARzX3kZrSTGbl5E6mnSnPgSpWG6XzKzgdR/yxlP2HvF01Lw9CT7dNC/xdS/v24=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB6094.eurprd04.prod.outlook.com (2603:10a6:803:f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 14:38:20 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 14:38:20 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/8] dpaa2-mac: add the MC API for retrieving the version
Date:   Wed,  9 Mar 2022 16:37:46 +0200
Message-Id: <20220309143751.3362678-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
References: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3580b756-0a3d-4898-3117-08da01da74c7
X-MS-TrafficTypeDiagnostic: VI1PR04MB6094:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB60945A46853A24F7B1BCE85FE00A9@VI1PR04MB6094.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OybndI4+zEmjw6AhOY1uuqbRYSjEhN8fqVyAxPTGf7dDdWpT4cJeyWlaBkLsDMq5POGLsfe8QRbPlIWc/w/nhqaRiU72g+Ad2FCv8bc+3Sd2XhGfAmwn9Z5a6qAwzJuYm44TKK8TDDr1kY3HbfT81uVw8tAQPS6lStb91eOhKL+rcp6km+pu29qw3wlH1J6gE1NdlcnmDvg2PcDn+5slj2wKfZ/B05NMVFGkIfx/CW7zP2AKFxl5PID1Awbx8AiNUqNWicI+8fNrpKoBuYN6hVgUsBNS49beQ1WgJeSp5ZrNMrUPnRBSKRNc5n2gsG+YwruT0uCbzqVKg0IDsOmG5Y4+yesUBH4ZlvgbigMQNHrknRMNVDpQ7vWlXtuWj5QZ3unyvH8rLrRqLw2kG4NFA/1GGXovDh5rfRc+jP6w7c2s2Z/R3FOwgft0f5p7K/5YBUu6bA2EMPBeWo0bqFwWRjtPyu9MVaRJrInkHNlAiCaqzq4ATAcw3zYeSumhfCdp1Q3wsBR/b4uxBggOFh/3xhRo6qrBC/MoTWMPogyNajA4+U5TlaiVVWabDqbJwVECvC8DH5zm3PuOGkmwS96Hhu9ly1PRrDv1JlAJzFOH3U99sXhzdsMEs5lfsmVomT+MCWXmivBKxBkRCVi0ChnXSQJdhpfA2W6aXRekklt3YSt+GJlxt/odXJ4LxR54+6vhj1RorhaLPygC4boXQLBfWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6506007)(6512007)(8676002)(6486002)(2906002)(66946007)(186003)(4326008)(86362001)(66476007)(66556008)(38350700002)(38100700002)(36756003)(316002)(8936002)(26005)(1076003)(2616005)(44832011)(5660300002)(83380400001)(52116002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Av1GU9a6eZIuOtEuZd2sZcY1eRMw3EhKxAC02oC2yTDnEAjUFi0jhjpyVlS5?=
 =?us-ascii?Q?7WEjyMVbC7PgJKBBZJq9fPpSiboiXRiktGv78Ns49HjAXqOhLRcvLuIYXno9?=
 =?us-ascii?Q?BRtyw/DHcNq/2dP9MZqr8/VwAMurhbZoymt6D8TNYYy2bDS2H6uW/s0uONSD?=
 =?us-ascii?Q?yhvXx6s923R0myeOKyuxOK09hoP4JPXdJjdfP6SjJnD6EnoPD7yhM74qaQG6?=
 =?us-ascii?Q?XH4I2kwyR7JuRuFDaoLtS2TRS0rP5Cj0MuWk1YqDGNbGDnUaTuz1OFKraZ+1?=
 =?us-ascii?Q?DYA/m/PO5EcXxQNA/eaY5w6NDfFXwqPKGwXaP/e+J5IB9Pu258x/mMnXQjLX?=
 =?us-ascii?Q?knr5TQzMHc445lBSpphLxAz2FA7uDP5cITCxnA9/lqVcJ1kTqXPEhDxofonv?=
 =?us-ascii?Q?NwUqyad+7MN/dWZNhrBtbOPc+gaYxbLuuskEjj0gjmY6UnBN3pwXFpdsgUJ/?=
 =?us-ascii?Q?yo23gNQmIpjnwomRoDAyQHXEMKmtNHA4vKm05EwAduTcL7unf0o25KBPs04W?=
 =?us-ascii?Q?tYmMVmsC+eHpfUufzMdNAuMCPAbWbieEOsIV1Y23I66bSPiemintL8/GM4Uf?=
 =?us-ascii?Q?u9gGIXzQzoZh4F3zTmoUDzmdfGmR1bHYJBMFw8xfAJPrA8w7I1Y+W4eq6IbX?=
 =?us-ascii?Q?VeXDoNQU7/orDE669V6Axe9JIfec/Pulx1mzWPXtDShpNriV+URVXCEIpvDE?=
 =?us-ascii?Q?MbjjS5KYnaEmb7NP6cPBcXiY3H3tN/fpE0BjSt/r0k52RssT0CedB2EixPB1?=
 =?us-ascii?Q?lsAWNfysBi+gqvNWPmgKpq9V62gfqfv3rTkLIQTuh1ZIIpuQCwIGYMtzsyrt?=
 =?us-ascii?Q?mJqgyMoQie+MSbwmS7t68LnphHC6z+vlBax5JVwn9s86x5Pi/LlndIjhPQNi?=
 =?us-ascii?Q?fq6rK6GD5d+mZdcIIpHNLlqQCvoH6avHqMsKCK3N8YYuf/MwW8Gaxv101j0C?=
 =?us-ascii?Q?X4BO7dKjYAMxVH2/xihmXXX+pG14Qyuh6SjQCx3EgiN5g1PqmJVvfercuqhx?=
 =?us-ascii?Q?iUwMlbZl1ex1cCCUtBKbCmzDJFQjgzWNbgZ4VPPGnRXC+FkGNNCh1w0c5ggH?=
 =?us-ascii?Q?nHsw044FrphZC3DwT8mqWui0BgLmoDlN0xO+YkuOTK0nyEyrJR3k1wacYFUX?=
 =?us-ascii?Q?VrQ2cD6BNL3qW++wxhVU1LLBNSVjMSOnW3xzSFpLzs1RLg+RaJ4gnx4YZnAz?=
 =?us-ascii?Q?uCXx+DyPBEcjM0hS00LF+uhaCbQAnPp+Y7v0WS3bj2tolYjz8XpU8MhFFPkM?=
 =?us-ascii?Q?coDEcNMEB7WOCyp78Y5fEzTRkRFU7auGTqdG429edp78WnO4wxNlZKxZXMl6?=
 =?us-ascii?Q?qWDY9bPldpNgpoWjpciSJMOKc2yf0ZcFEKgXdaAibbDmT7cdhjIIy2B8wNGy?=
 =?us-ascii?Q?RN2YwqWW43Jg9MG12oLYKeOD4LcdJGmCFhu11q4g0N9Gn/wXaUQtODnrULKL?=
 =?us-ascii?Q?HV1/0zRbEJL4i9ryhSTq0upYWBK3PjH2gMk6Erajz74tKqL52T2BfA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3580b756-0a3d-4898-3117-08da01da74c7
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 14:38:20.1462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sc8UJIK9LeZFn6nP2RTR8Pp3wCUjpiDsFge2JKwF+ajxVa3wyqBzNWmAJ38LO+b7x+fcBdGjIN82wNkxT51kqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6094
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

