Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1090059889F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344750AbiHRQUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344660AbiHRQST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:18:19 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F11C12F5;
        Thu, 18 Aug 2022 09:17:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpPpBdlghjCwc648DRp4dmZfh4FFC/2OMITYVr4ZvMR/4q4FdT5EjBLaGe0M1No4r4pBD04FrWGN4v7Iyb/YnnjuG+rlkczuzDJDic71ykwqi3PO9nVml3woLgbvw2he82wVtjFAyzL8z+iWyy1G3WbakQQlA+fvy93uq4NQowVX2hv2GZNV5pCuBX/Zciu0BN7QawwfPdMev3Xs6LZ46Hy8kJVFVIaO2z2WnD7DwgDdLUN5heqF7dCmx0I7350LF5g+N8amK89VPqXFPLjPS6eHO9pRzQkeEJZVWvnl85743GKlWIy5m7pNT7UtuA/Am/RS2qVlNNxHcij78BQE7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjfdFtV2Kn0MnN32TKkSGHoI29fYTJaUy5GLPYutZkA=;
 b=MAcmcWsxAKbHHn6JmoK5uj178QG3qVc0lEhT84rw5rkU03DXeM52OQdGFqSF2OzI+vJMn1tt6ymrxq2i2f6j2GUP94GuDwiPWfCkH4V9ILGWyxY/+V0FO83008lVuJW2NuWuRg9t/T8cZk4Wm7qclJsF/z/mZk+OWkGdw87DVtnp2afPtYs/iXPPhwEzvUqmGL65BD57bXADfsNJwymZ2nWmJXqQ/UjGfrU7hpsGeWpoWrdmEC32gvv0dgOAX96LjS9eqzncm/qAyTbCPiJlouNETlxR3SXLQV/VvxTvoxeWJT8n2H1k+ZGIbPJu8phzJQ27el1bttUTLhoPM4uPLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjfdFtV2Kn0MnN32TKkSGHoI29fYTJaUy5GLPYutZkA=;
 b=uttU97xbL2rQvEU5zew86iw3/fYQxUS9M3EM+jMqLgInAM22ho9mT1DR76w8IpYt6yr8rIl8/ABpVusg/judPgJOliiUj8hdH9YFTh9s1+oltf8axxgPm2CylHj7TplrfoUaZk4xb/bh0+nxNA4cWbqhHLP700lXszucHWPhupkEdvlMKV7/cRhFER39eqRHlmuLT0zCeFmkOvVi7Oqi4x1of3tEUoZguQB4YbyI54GjTgIwRLLgzjwWkAOt/xKfmFvIEq5AOWMvlOEkHwhE4Oh9/uCEG2DZqnI+SReBhsos2koekWMSlAiPC3uobPE2fiRCJBEzqvlZEI2iBbV6CA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:34 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:34 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 18/25] net: fman: Use mac_dev for some params
Date:   Thu, 18 Aug 2022 12:16:42 -0400
Message-Id: <20220818161649.2058728-19-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f1c71f1-e98d-40c2-47de-08da813528b6
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oFfmLIBhj7gCl5GzbCwMBzbq4qie8zt+ktBnU9qadKaJcADzdCSP8xTpSLirrG3wPA0zXQHTmFLN0XNiuaeeNQgKMI00Ig9l5UD07g2nWb4ZK2p12V+9f9QREj6uXR9Z6JYXLvVZmLnVZzo3R6yYmU/jIM8gHQU3MMjor3HoitSBt8KR0o62ZXivnBroWRsBmovIEQvpzCs53B9rNWPTZYpqZn+hOxWg7GI5TRi48ZQWWkCa8xYnxM69GlkBpIlZy3Aplq1JmB3XoTXBhJKsM+dP5aH43W4+w+sONQ74UPUVEZ8sFMK06DSrufVEYVcFgC1mOxwgiFreOITKeZUAYCn3aVcU7PdNNI7K6t+5sxkx0Y5EsmlQBqvRbWK5+GzggetZwKkIe6q09QiHo60uPvhcf6Lf0ME1tnTW9kz6FnlcVz8koMMjHuudIC4BZuvT6iib1xaYupd5eB5T+RoSoK3y6V9S4N+KS5a2h3MX4RE70r2l6QlgkTeBR7BYPejceDGVIEP/84rDcTq0MQgvIX/ErYCY79WUGtN4FMeLThXo2t8PZLZPLtP/bSIMCJUfj5avgctWAsXvDt4VXTF9+SPcV8C7+309NuUxGT+WRoStH1NjHHStbZQMlhhlqAlEWEuQIPZF2CT0vTPk8CzcDiRE0zqeFwzordMASq+tFjoUgS+dhRDPOB25FUDbwX3QY9SR+/fGlPz26TOymlRakO5Sb+7L1l9lQmHbw51JrHYOGGg78yrjvJe2h9GcGieHEx2djSsZjNoA3XWIh4X/Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(107886003)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UMtdPhAME3RHUTR5WUB5vGtp9ANQzk566zUGpkHSmMVpPJ2rAfiQZ76rOFz4?=
 =?us-ascii?Q?EXBQyBoD5WqH+2C2hH/Dv2hJc89Ii1DfJAnaylBortUdujMCY7+ediaYStCM?=
 =?us-ascii?Q?QfTC7f0criFJkmIC4kPL0wImX/YfqUlR288BZflJ8Ue857YQCuZx05Yglx8m?=
 =?us-ascii?Q?2s+JdDJJTB7ol9GYfaIxQQMJktUG2aNyLoCmcMK+QVk9ZjUtbpYoqvDPOpdK?=
 =?us-ascii?Q?J/4xGsDz8dDYt/iN4a5c0z5Djvg0kmQeVgqQVRVNUHWtTGDI6F4jNuf4AuZW?=
 =?us-ascii?Q?NEXMZrGHXJcBRs1ejwJ1Z8eczvIEx1Fq61XEPXiEDD2IAvdAlfwDbrGB0/ln?=
 =?us-ascii?Q?bE/LXt9LNkbnJ/bjBvrOJQ9QMZzk8czfePHZIpunpfU93aIfUFSFf+r/UNfL?=
 =?us-ascii?Q?5vCb4lWv4e6F5S34nbnDrMZlcDLU2IvkAurpBWc/5/tW9CxIyER9bfJcvcsZ?=
 =?us-ascii?Q?TzMPHgF9xd/Y69ywUC2BHAwIQFqQN5cBfMARHI8LNZ56QUWlUzBTAoGG1482?=
 =?us-ascii?Q?mtsIhAgOL/xQcDsIfQHerr0pbsTdLGSU9LWE25SmSSjUHAlCMsrc7/RQ6cMS?=
 =?us-ascii?Q?rTVx0ZyVET7j6erx/3PXgCsuyRCIIPkKtT9KlnAQrGX5UKJ0Jafn6on9k9O9?=
 =?us-ascii?Q?cZdeaTqkovDZ8OgpA83tyz8QIe5twyNh8KhKljurUPDTX03dgqgSrn7jPpcq?=
 =?us-ascii?Q?qPz6ljyS5Tqw3Qj3RTyEr0pJtK/bS3qEe7vxUbJufQ84qf7+9yXctbu508n6?=
 =?us-ascii?Q?xdFgqwcS6BVRS+tE3K4aLKJAKr+2i6qzjHD9Vj4draZH3zZ+KaKOiEZev9lc?=
 =?us-ascii?Q?Gc1db13sjowYniZE9Hp07t4KXWX82QMp0k0TGgEMeBQMPlI4OzxjvTMVuiml?=
 =?us-ascii?Q?bHE6CiiOElcf5mb/5928hvBaATPj1xSlvjLnc61sWogzcKh5smrCEGLYKyy9?=
 =?us-ascii?Q?TSdod/x3QuwpDKmltjEdb/6iyOZSjN4nVxDr4p0c6cq5+RpwaQlsOjZ1d4AS?=
 =?us-ascii?Q?V47/VuL2s96ul+Ax9izjjQPfPiwVfnIteYzgJh8vzRaO6nJ9XrZST9bGO+4N?=
 =?us-ascii?Q?Wm6ED82EPvBHMjrxrJ6nRl4L6gIvomXkHIPUz0Pokjy0uFy/auixSRH2IiG6?=
 =?us-ascii?Q?89yh+7jVTttyP/LUkT5vPgrqx395v66GjeDGgjd3/md/1alGjitivHCPpPLc?=
 =?us-ascii?Q?OdOghyV6L22rO7nsQa2pr3CWW7qedO3n8Eh0hKh7LTh9XYRpOEVLII1U53x7?=
 =?us-ascii?Q?9zqgNEhFx/0CkMgwWk/hywxsag2tkbv+7BLcZOKLZsg6z4gbXWIwMcERt/Kw?=
 =?us-ascii?Q?df4SvwIh5R0ZeicwFbHsNgyODKI/JJNrsBDNcRErtkIKK4YGPXunVwhdNsY8?=
 =?us-ascii?Q?olguButmvSY4f5Bi/XpmF9nuXwzL1BVZlvblAZnlprnGDoOTvcE1N+ZGOTVF?=
 =?us-ascii?Q?JSycCDwa9iR/8C+A/XFxhkaGhunv6siEPGn6hXefoMSu+o38jtpncGw/iFy+?=
 =?us-ascii?Q?LGXtndu8i0taI1RdqfcqdQmWZY2f7iTK5fTUEdHXgYtVj4IatjLpC6FhMEkJ?=
 =?us-ascii?Q?1qWC3G/I1pNN0j1HHVLeCpalXYcXxaFO0TP64y94cz25b+q7O7HVt0UPsIsb?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f1c71f1-e98d-40c2-47de-08da813528b6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:34.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0P+F3gRFVRy+e3tszhVrRbV1R+6/WU0a7vdMyMhfy9gUG73PG9dqROcIf+OZuQb9UKKy7Zqq7iHDiMIvFoMreg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some params are already present in mac_dev. Use them directly instead of
passing them through params.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c    | 16 +++++++---------
 drivers/net/ethernet/freescale/fman/fman_mac.h  |  7 -------
 .../net/ethernet/freescale/fman/fman_memac.c    | 17 ++++++++---------
 drivers/net/ethernet/freescale/fman/fman_tgec.c | 12 +++++-------
 drivers/net/ethernet/freescale/fman/mac.c       | 10 ++--------
 5 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 9fabb2dfc972..09ad1117005a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1413,13 +1413,11 @@ static int dtsec_free(struct fman_mac *dtsec)
 	return 0;
 }
 
-static struct fman_mac *dtsec_config(struct fman_mac_params *params)
+static struct fman_mac *dtsec_config(struct mac_device *mac_dev,
+				     struct fman_mac_params *params)
 {
 	struct fman_mac *dtsec;
 	struct dtsec_cfg *dtsec_drv_param;
-	void __iomem *base_addr;
-
-	base_addr = params->base_addr;
 
 	/* allocate memory for the UCC GETH data structure. */
 	dtsec = kzalloc(sizeof(*dtsec), GFP_KERNEL);
@@ -1436,10 +1434,10 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 
 	set_dflts(dtsec_drv_param);
 
-	dtsec->regs = base_addr;
-	dtsec->addr = ENET_ADDR_TO_UINT64(params->addr);
+	dtsec->regs = mac_dev->vaddr;
+	dtsec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 	dtsec->max_speed = params->max_speed;
-	dtsec->phy_if = params->phy_if;
+	dtsec->phy_if = mac_dev->phy_if;
 	dtsec->mac_id = params->mac_id;
 	dtsec->exceptions = (DTSEC_IMASK_BREN	|
 			     DTSEC_IMASK_RXCEN	|
@@ -1456,7 +1454,7 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 			     DTSEC_IMASK_RDPEEN);
 	dtsec->exception_cb = params->exception_cb;
 	dtsec->event_cb = params->event_cb;
-	dtsec->dev_id = params->dev_id;
+	dtsec->dev_id = mac_dev;
 	dtsec->ptp_tsu_enabled = dtsec->dtsec_drv_param->ptp_tsu_en;
 	dtsec->en_tsu_err_exception = dtsec->dtsec_drv_param->ptp_exception_en;
 
@@ -1495,7 +1493,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
 
-	mac_dev->fman_mac = dtsec_config(params);
+	mac_dev->fman_mac = dtsec_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 7774af6463e5..730aae7fed13 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -163,25 +163,18 @@ typedef void (fman_mac_exception_cb)(void *dev_id,
 
 /* FMan MAC config input */
 struct fman_mac_params {
-	/* Base of memory mapped FM MAC registers */
-	void __iomem *base_addr;
-	/* MAC address of device; First octet is sent first */
-	enet_addr_t addr;
 	/* MAC ID; numbering of dTSEC and 1G-mEMAC:
 	 * 0 - FM_MAX_NUM_OF_1G_MACS;
 	 * numbering of 10G-MAC (TGEC) and 10G-mEMAC:
 	 * 0 - FM_MAX_NUM_OF_10G_MACS
 	 */
 	u8 mac_id;
-	/* PHY interface */
-	phy_interface_t	 phy_if;
 	/* Note that the speed should indicate the maximum rate that
 	 * this MAC should support rather than the actual speed;
 	 */
 	u16 max_speed;
 	/* A handle to the FM object this port related to */
 	void *fm;
-	void *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *event_cb;    /* MDIO Events Callback Routine */
 	fman_mac_exception_cb *exception_cb;/* Exception Callback Routine */
 	/* SGMII/QSGII interface with 1000BaseX auto-negotiation between MAC
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 7121be0f958b..2f3050df5ab9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1109,13 +1109,12 @@ static int memac_free(struct fman_mac *memac)
 	return 0;
 }
 
-static struct fman_mac *memac_config(struct fman_mac_params *params)
+static struct fman_mac *memac_config(struct mac_device *mac_dev,
+				     struct fman_mac_params *params)
 {
 	struct fman_mac *memac;
 	struct memac_cfg *memac_drv_param;
-	void __iomem *base_addr;
 
-	base_addr = params->base_addr;
 	/* allocate memory for the m_emac data structure */
 	memac = kzalloc(sizeof(*memac), GFP_KERNEL);
 	if (!memac)
@@ -1133,17 +1132,17 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 
 	set_dflts(memac_drv_param);
 
-	memac->addr = ENET_ADDR_TO_UINT64(params->addr);
+	memac->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 
-	memac->regs = base_addr;
+	memac->regs = mac_dev->vaddr;
 	memac->max_speed = params->max_speed;
-	memac->phy_if = params->phy_if;
+	memac->phy_if = mac_dev->phy_if;
 	memac->mac_id = params->mac_id;
 	memac->exceptions = (MEMAC_IMASK_TSECC_ER | MEMAC_IMASK_TECC_ER |
 			     MEMAC_IMASK_RECC_ER | MEMAC_IMASK_MGI);
 	memac->exception_cb = params->exception_cb;
 	memac->event_cb = params->event_cb;
-	memac->dev_id = params->dev_id;
+	memac->dev_id = mac_dev;
 	memac->fm = params->fm;
 	memac->basex_if = params->basex_if;
 
@@ -1177,9 +1176,9 @@ int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->disable		= memac_disable;
 
 	if (params->max_speed == SPEED_10000)
-		params->phy_if = PHY_INTERFACE_MODE_XGMII;
+		mac_dev->phy_if = PHY_INTERFACE_MODE_XGMII;
 
-	mac_dev->fman_mac = memac_config(params);
+	mac_dev->fman_mac = memac_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index f34f89e46a6f..2642a4c27292 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -728,13 +728,11 @@ static int tgec_free(struct fman_mac *tgec)
 	return 0;
 }
 
-static struct fman_mac *tgec_config(struct fman_mac_params *params)
+static struct fman_mac *tgec_config(struct mac_device *mac_dev, struct fman_mac_params *params)
 {
 	struct fman_mac *tgec;
 	struct tgec_cfg *cfg;
-	void __iomem *base_addr;
 
-	base_addr = params->base_addr;
 	/* allocate memory for the UCC GETH data structure. */
 	tgec = kzalloc(sizeof(*tgec), GFP_KERNEL);
 	if (!tgec)
@@ -752,8 +750,8 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 
 	set_dflts(cfg);
 
-	tgec->regs = base_addr;
-	tgec->addr = ENET_ADDR_TO_UINT64(params->addr);
+	tgec->regs = mac_dev->vaddr;
+	tgec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 	tgec->max_speed = params->max_speed;
 	tgec->mac_id = params->mac_id;
 	tgec->exceptions = (TGEC_IMASK_MDIO_SCAN_EVENT	|
@@ -773,7 +771,7 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 			    TGEC_IMASK_RX_ALIGN_ER);
 	tgec->exception_cb = params->exception_cb;
 	tgec->event_cb = params->event_cb;
-	tgec->dev_id = params->dev_id;
+	tgec->dev_id = mac_dev;
 	tgec->fm = params->fm;
 
 	/* Save FMan revision */
@@ -803,7 +801,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
-	mac_dev->fman_mac = tgec_config(params);
+	mac_dev->fman_mac = tgec_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index fb04c1f9cd3e..0f9e3e9e60c6 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -34,7 +34,6 @@ struct mac_priv_s {
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
 	u16				speed;
-	u16				max_speed;
 };
 
 struct mac_address {
@@ -439,7 +438,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_dev->phy_if = phy_if;
 
 	priv->speed		= phy2speed[mac_dev->phy_if];
-	priv->max_speed		= priv->speed;
+	params.max_speed	= priv->speed;
 	mac_dev->if_support	= DTSEC_SUPPORTED;
 	/* We don't support half-duplex in SGMII mode */
 	if (mac_dev->phy_if == PHY_INTERFACE_MODE_SGMII)
@@ -447,7 +446,7 @@ static int mac_probe(struct platform_device *_of_dev)
 					SUPPORTED_100baseT_Half);
 
 	/* Gigabit support (no half-duplex) */
-	if (priv->max_speed == 1000)
+	if (params.max_speed == 1000)
 		mac_dev->if_support |= SUPPORTED_1000baseT_Full;
 
 	/* The 10G interface only supports one mode */
@@ -457,16 +456,11 @@ static int mac_probe(struct platform_device *_of_dev)
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
 
-	params.base_addr = mac_dev->vaddr;
-	memcpy(&params.addr, mac_dev->addr, sizeof(mac_dev->addr));
-	params.max_speed	= priv->max_speed;
-	params.phy_if		= mac_dev->phy_if;
 	params.basex_if		= false;
 	params.mac_id		= priv->cell_index;
 	params.fm		= (void *)priv->fman;
 	params.exception_cb	= mac_exception;
 	params.event_cb		= mac_exception;
-	params.dev_id		= mac_dev;
 
 	err = init(mac_dev, mac_node, &params);
 	if (err < 0) {
-- 
2.35.1.1320.gc452695387.dirty

