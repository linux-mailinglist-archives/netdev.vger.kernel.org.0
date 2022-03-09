Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B003F4D3119
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiCIOjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiCIOjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:39:25 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3BC123BF9;
        Wed,  9 Mar 2022 06:38:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLn/qy3LvgOu0gbwTuekCzne+OtoEAjuv4+Bf2xDr0JC/GRH2R+0DKWF/5B5f+Kxgt/Yy101j1te3XGA4tl1YARwlrdGDwzNOBky/O/97conGGFTesT53vZ+KIFYMS7SMcx9ZLuI/FXxQ/7Y/DyO3yVlx7o36I72DK1SB9Xkf0uqnyRP11bZ3+kdng6pvIC1X+rkkujoHawWWIYdI0qtPgf5qTCybQK3uvgzSTtvmRT1gksz8Su/LGSjbw3T3rgJGGMIAvsrUW4/pKougQ5CQzsum6lFGRi8mgcHQFIY1/RVcTRoRmDY7Fic5EOstlBzs22LALzCSXID/nw+nfOIGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NziXLGYCnsFe1va5l952yoXZSoutxMn6w0Wu79STnkg=;
 b=LPCnUL/bx88bCs5lEb12tZsQezDM0xpbOOJ65Qld+FSYLkZP7UkCPgo7YqcMQJ/RFUnBYTEaiK9/bSDxF4/Y2LZd4U+KCGYfNUekwh8Fk+aW1PzexUQmPupky/S2tDxVPW7pJ9YqWChwEZmAGU5r835tfh2SfAS24l/xr5mlFdxgWXmNYot0y42qj4AvWSj4FYJsTG5PcMi5IgBEGMdu2cYe0X4sZLD8hjWkasWrI/npk1sm6GPaz74FJaJTtYm6xF/WP/42hrmqBYly59l3p31YnEoQ7Y6Jq5Jd2aQkzOBe2tnIpeg5aH4y8eO874SSHlqsiclkj7tf9M+j9tfR0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NziXLGYCnsFe1va5l952yoXZSoutxMn6w0Wu79STnkg=;
 b=OwYFKnz1AT7rISkXp3LU6bw1+emydoo9twMaAnliwHn2BQUyOyJzH57N7zWAWbDSBSokHSGjC3kQr/OY1rQjiFQQj2o5hmSHGy0sJQiwqvT2/xKiZTHJTz5a6WVbENURvbO+5ARzHb2Hi4Wbu6Q8u89KVn0QKCReaZyZCC0sCEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB6094.eurprd04.prod.outlook.com (2603:10a6:803:f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 14:38:21 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 14:38:21 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/8] dpaa2-mac: add the MC API for reconfiguring the protocol
Date:   Wed,  9 Mar 2022 16:37:47 +0200
Message-Id: <20220309143751.3362678-5-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 45591fb4-f260-4c4f-5787-08da01da7543
X-MS-TrafficTypeDiagnostic: VI1PR04MB6094:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6094BD43B2436F3A22A7E75FE00A9@VI1PR04MB6094.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOTJbyC2GXw4tATlR8E9dXoxEhmJ458eSoFqo61VjRX43/qkMdYzvLVKHXTqf/noh2IVmN/hdIA7jZ5A7IgdhCd7umO44rq1T6lSMg/3z7a+w5qbzj76Bkxz8duIrLmTJT9PerzI76KGaoDrOoDbeK6HqS3RlmUdaFP+p1I1VIBB75pveL3qhOoGiVMI/rKD2WnUrwZCKXXku2Bvxe9fEDMFxBvGP4VPUkUKHVxiQrdPUPpc0Dr9aD+uBBnFeulpcih6asFp39fyIGfQOEmT3698KiuFCjvLc6TyNiOEF3DeizHiaCeZMA60Nwft3pEBDIG2q8Z4L3TQAlQwuumShlei+DA8kugHyfckP1/jiN3Uplq7foHifr6eyxK6OPhtPCn4sh5AUO+Y96J9kAW7v6r32B+8BDek//psMMSlbNJ/MYhwN1Uv5hoOfSi84exd8PfvGsWLYkOvOBiuQA5desy11xN0lD+RUPN2ClyZRqILAZFKoS5Rlmnda/CN9ZPD2tUkT7Cc9vCSPL065B2U9g0kGwtON7hHLTDZW8XOlXnKhmNBjWxl/tW++o+qsUBMoDg36FWicUrvQZn+ZsMfWglEvE00WFsfck3TAtOk6G6tYHIXT9ds4cqH/LVR6PJk4DjDwGNwZTlbCGIT+1wlZC1QK58ZUZX/sB46L7x9RYphW3JrMlhJmqDi1i+uw40/aQuXeHQyFg2oiLorfnZ2rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6506007)(6512007)(8676002)(6486002)(2906002)(66946007)(186003)(4326008)(86362001)(66476007)(66556008)(38350700002)(38100700002)(36756003)(316002)(8936002)(26005)(1076003)(2616005)(44832011)(5660300002)(83380400001)(52116002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NvToMnalHLgWu2hjX7Ue0ZmBqBH307ZDtzwpRTBJ0Ut74TBEVUXkxQtJ2yeI?=
 =?us-ascii?Q?yT8AAN/ZviyiUVeKAgad+s1klFzKWZwGnmie68DHiyHt/lpupIMbagNXyi7Z?=
 =?us-ascii?Q?4NkQJ9PA9SlDSjoC58HDExigWe5d3vLcIG783cFz8AVVQAQzfULqPlNQalm7?=
 =?us-ascii?Q?3ba5bCxQgAQXI5JaSzBh+yNl727T/oeV2WkQKhBjVlD30+xE3dDIRxXCzNKd?=
 =?us-ascii?Q?sihud1lYtieJCP33J7uIS2qI7JMunXoIW5aS2fBtPMoRd/uvVPHtxwu16Q0a?=
 =?us-ascii?Q?lGh9fvWlSqVbz5UODFc9YYlxGZymr6A3fFkN0EXuzDkm08ybrm61G4YhE11e?=
 =?us-ascii?Q?cfpq6Hmund7TzNfFoyc5LSUn05ycwVNRnR0OzLWWUmnYVej/1lPGoJgXCmQt?=
 =?us-ascii?Q?3T1V8UOxxQW1lTcvX3BE9sfG13Fby+pprZLVkAIHtm5vuyLIm+nJL1RlgCKu?=
 =?us-ascii?Q?4QiFr25qjVGz8LSLVHvxX1C6FFiy/lUBeHcIa7FAlPiEW7U0HLlX2LyxsIDR?=
 =?us-ascii?Q?0zDSM/rqpPilYZIbzv7gVaUlrtamniOYg2wGejshHofXvV36lMGXoiEujOLx?=
 =?us-ascii?Q?ecOgRm/Z8hWBfhiDpuLA/oxDRXT5q7mgLCq/jqIqVbb35AZqiB5E5pTBbJJS?=
 =?us-ascii?Q?KZz8XqRpLMGT0TF4tQ9tB19VpQbj//4YSxemQv3PThSW42EA2flaKr5XQASe?=
 =?us-ascii?Q?c5j10qy2UJZnnvELByS5Rc65ansqPWkfAniVmcO5G92OiHsdQTwanLBwzgZG?=
 =?us-ascii?Q?LYmLIFRBEU6xJe98OQHaAzphV27D8+CVufZcwhw9A8bj4sd+IO+1usXy/fth?=
 =?us-ascii?Q?o7rqVIphWKR5+Jno11yrWVdRwpRnCyhGgcolOPqwq3Cu9BvKWB4ybgD25GZy?=
 =?us-ascii?Q?BLsU5Rv6kISHxZ6zqzArVySPSJoPwWNEduBd40n2ohM/lNr/w+aqYOQABGTF?=
 =?us-ascii?Q?+YBNYKbSmHwy10uAtJetA0PUfCwWFOeQVKkDHURwFu/15Kui/eAdhXqqyPbU?=
 =?us-ascii?Q?k894JFiYYtcOsIctOnx6wkyRvBbqAt979OMJdKmoEIbpwxjVdBUnAUI+AWdf?=
 =?us-ascii?Q?Z7wNzCLMcgAv1jjBVPBKa7ItkCkCSNnFX800USrET7oEcZHlW9WHhBzA5kjA?=
 =?us-ascii?Q?x2396r1iqBTWZErW9VIxHDiZGEl9rzG6wD+byVl0YIU2Z+f5OzS3w91y2taP?=
 =?us-ascii?Q?JJ8TSi0W8NXVtr7YU9pg3d8zJlgD5xTRzweDfqEpdN8+5S9su1d/h7Kzs7mj?=
 =?us-ascii?Q?3O5h2H5Wy+BtxpidjA8DOoQ2mLXMqy/1AY2SZBZpztnqKihANRM5RP7z2z6i?=
 =?us-ascii?Q?Vu11tGZS8L3bDijYJfR33zo4GFrTnsjN/iv658x7v4ncEb+shbFq3QF4sl2D?=
 =?us-ascii?Q?5bS1ENK89qRxpbogka/TbUBqjr6+47tRuTXjXYwVvi3nzcYMdQpvm6bOehE+?=
 =?us-ascii?Q?kSbbO0IYxCeda2qHH/jU9AMn2Q9xbrMWB51Z/CSDvx//boRcDH9e/Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45591fb4-f260-4c4f-5787-08da01da7543
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 14:38:20.9285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1LGX5QEiKxQOr10AiQSnnuJ7mAsNYaruFj9LwXzZt6AqkeceEqlM3PytmYw7f19a+IhotgKwS38kQHgAc96GCA==
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

The MC firmware gained recently a new command which can reconfigure the
running protocol on the underlying MAC. Add this new command which will
be used in the next patches in order to do a major reconfig on the
interface.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
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

