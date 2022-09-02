Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9965ABA7E
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiIBV7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiIBV6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:25 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D6EF63EA;
        Fri,  2 Sep 2022 14:58:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ec1be/RkaiLx/2IlrpxsiOMekqiJnOtp+nbSkbxVKXn0k/IsXfZGYnJw/hqm1YEmfT/ua/x8BiLZiknY9b4yts81uyyKJlBg3I85ezb/QCBhWOA6yQaRniqpMyaxFjKY6hCIHS/nNXQbmDRtm364H3ytbyOZmfbLTGRy4ARO5H9CJouu1+Iozj4AA6scaYI9OApB/U3N4cAyuqMcylZhSjEglQQZyehCbFzRbx8uh7/kd0tnJPS8cp4rOQGLCdmkD1xTefmdjtdY/ORIIQ3eoqnc01ZGCUa98CBIzsQkzY3CUSwMNEGuOhr7YF3tSAJ5v9a+zwdsJApDG5CJ2YNphQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpPL6u4EhYR2Y+5IJnStcnatWnT+xiJhHgRNjD9gT6k=;
 b=TPj1wjHtgP1t56ipv2HbTnJKf6GUybbbqXno8qK1CRQUcKlBmu58KM6xHjcps1NJ1yrfwlmy4z+tQ8LCG5jXtozMk/MXhSHIMvjxgPb6NSnU3+dBpTvj0b9Tm49ubEuppaKHZJJ+4vCTBRCKZK3goxqgPlYcPWozwBcXcBlc6R34i2z3gCMDXBT68lSnHtnv+/etRjZ+gSKHADVFvJWnh4GN47WRV/RIAGLaPCXte37im3POuU0TxaPmVK1O6yDBw0GRjVvVXxTaRD57EFrrZVLH8VopBP9lm+sgq3kecmy6bnX8oJTFh3GQdpOUbFbTrjbXA/Fe4VYLpnPhF1/RZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpPL6u4EhYR2Y+5IJnStcnatWnT+xiJhHgRNjD9gT6k=;
 b=cBexR3R4ArUIzgJDUULedXl/y6xtXTCdCh6IheIDTcL2XCXP6kArXC+iJK111EdTp/3GZGkxJ+t4i0pf0J/O/BklMkRw4jltbfOWnfT1HFTVjhhCKwVWRe/cxZ3eorV5qozAWKzL63DLI2opCjmLJxZnoliuFzgR+14kzvd8EiCQf6h8+nTsE9sQeYDMYNF7DeEXHE8upgaJZrwrnLFKfaPnETktdJSMWhqhcVhoFWYEDOtQq76HiJDU5Gg0DlN8hBlMCgwra9UiCuPykbuTd6sDniJWESX5Hv0iHSMGy3Rsei8025LVZH9aoVdhEc3V98E4yL0RSlxLdUfdCcDdag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:03 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:03 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 07/14] net: fman: Use mac_dev for some params
Date:   Fri,  2 Sep 2022 17:57:29 -0400
Message-Id: <20220902215737.981341-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e0f944c-9aab-4e0a-5eda-08da8d2e353c
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hozqHNQfyTZXQy5fziepuyJ4hRDM539/FqYnk9++cVnvTHVihZkChC+zGCNtW6NLh21s7gGhEDl7iKHPgbpNmhkmxs1QFQEKGKOaoNxt+vd2riF9n1SHJFcgzh3O/565Xmu7y9gmRnxxyds250pbtFZDzHDr/eT0yVnrOPuivnIqrHFGCStzvyKdACBl8LDrZhVaMCHLEnmWMFbnDWY/jWlwnYjPTjw4zOFCkp6UVgmqf/bK9E/oWD4wSiG5B8/7GQUsOTmd4ETVMunDb8W80lZZHZoSdTVEYM1z06l82DfNa0rA3KjoeMEL7C0LI56zidxSY26gcPXerARxgNsYizn1RCxeQ8nDPiZJbjCVQwMwrBgdwB9I7QVu5q/YLx+2yG9bDaxO5eeoxKgJ1HVoKObAZ9g5TYRFKn59ngx0FFiVOij641fJtVcaqPvA3Jo13ynwxMniMVtav6oC69Hklx4KYuHNs4wSvpf0axPwj7geQkNRHHiM2vSXltMdBbFylyIRaNKRQHVCnF1FyVnwzI96eLdYfkw/FrnLcunSIddLde+YKyXkTNss6y8GvT8nxkFGLKPh4DW9c2TkpdZZNx/D7gRGzy7D/UiW16RVW65+u7QLyac1rxJ4H7BFqQhJVD2hZ98/2TZopNHpNYG/8dJNY5aX1lPtTNcQs/Um8txnhaSxzEIs01uUotty1C6tabx9uVLfc8ps8f/7zHvl8l8RvFhiAUIgfdztFK1+xF64Rovj5AXd2Adu6k3d6W34Gq3cLFeVmHCZBwaYqKOZ6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A/t3f0T4LOnDgCN5pixYOj69TGmqbS8uUn4hbzLub0NDwZanTO9gwPm/3gf/?=
 =?us-ascii?Q?uttxPl/5ta30Uqn8yzCjdsLPIAlhMaFwWkyOy7RrDiKGCXBmnEJDMFm13S2G?=
 =?us-ascii?Q?CWmZQZOpWFUHHEo53A/B8UOJtnBiexTJkChPszQqrW+Ja2UG2bHB3Dd77K2B?=
 =?us-ascii?Q?b9XuHoSGlMCd1do1j6XnymiG4e8vgOSYX2L3cNt2w4Sn0UVVpiKzSWMqPqrS?=
 =?us-ascii?Q?npXgFkDAoIhcuDyR6eIZQxM3D5Ba+CTOXyPyFi7gBkPIa56tYKlwDBQHjuJf?=
 =?us-ascii?Q?dfPi78SBv7dPDJAO5isEacC8yekm2GBCu66j3O7giKhAgYHchQeXfBORW6KL?=
 =?us-ascii?Q?wla914you1/iZpyIb4oTszifavrAehEkqehL29vXa9SfZeZHrvDb30HX7KWy?=
 =?us-ascii?Q?S1j6TBAeGpfg4RbpsWmC2RHI3EgtaQBtPM3BZTJfTWpaOQXPnr37mfx9Ok4L?=
 =?us-ascii?Q?lH0FXamsDgeOrMTiod3FGxX/EdlesswXbo+6sFMTl22sLigMZqnsi/hSH5iU?=
 =?us-ascii?Q?g/31FWbM2n236fZgj6z2WfiERsbAUxCKBiPJXFgSy0GU9Z/vT5dUWkY2sJzP?=
 =?us-ascii?Q?/wDBze4d2J/SYtQdoBVvNRufJ+vYicXab09OSbmOTnYagDNYGl6ZT5uuYijq?=
 =?us-ascii?Q?gdOdXa7WOS4vNXOV9uEgQ8A5SMpJYkfE1v/NtAuDjCfR2azF/0JhItSC2fEB?=
 =?us-ascii?Q?U1nOZdidE/eiEcXjOZv34yQN8YLTltQeP0GrIHn4vtjmLM8A7xCboCFQhuES?=
 =?us-ascii?Q?14X+JnR67t/gQFgsMGoe1NI9KqlNAu1wyemR5aZhXk4dHl2IIZtGzBfo7MFB?=
 =?us-ascii?Q?1l3wtrNYL+XDBm/X7r57FeaXbY2/tnXWOuGUN/jApnRFbB6wMBxF7n83VW/i?=
 =?us-ascii?Q?Gtrj48cEPZB+yTS8lu1qiu0K2/+mun/QenMdEsPfHCa8tgLw2DDtERJhclJ1?=
 =?us-ascii?Q?g5eDS6aYdcF7zkJDHyZILliFF6rjwvyh78VpiiZYkIWfn0LqA8IEkV4kRfwy?=
 =?us-ascii?Q?zyePJnxO5au+IZwdoVY6i/SXQK11vLbyjqL3/7rhQm00tYcDKqieJz9t0wOH?=
 =?us-ascii?Q?qhGw0uaoS1DtPQLRc074Dg6dF60I5c2EpI16lUAUCdCaSIszFGZIpkefAAcF?=
 =?us-ascii?Q?ryYDOGbbuYdhgXsHeNnn1JWDhm6F0eUAqJ896NWdqrOxFawJ4vwsg5Il5YdJ?=
 =?us-ascii?Q?gkUXL5PesQaFjf/xzTwMpXpI4HyHZ6PrsI0ET49mcTxRtRmoq7dM0fweYG0z?=
 =?us-ascii?Q?uM5QdE1yqqIxW/nJxzVihRgU0dALi2eEQZ0YwHhmrprnj6/cmXpYD5Gv63PG?=
 =?us-ascii?Q?VawxVWiprFPVtC9dxczz/2zc9HzApvaww9m3fMD3uBMwJHshfMgiX61w+nMW?=
 =?us-ascii?Q?o+PSmyUS1mFwPikx3HU4YwMgJ7xjzZ7Vi2+k9oN61eaWT4/D5BMjpV0mRlxZ?=
 =?us-ascii?Q?FnsLagMiSpe4eYzq76cZ5huHS3NZe3um8/QkwBOjKHfi3iX9VdvEdByfJ9li?=
 =?us-ascii?Q?dmjJXgSrOZXlKugW7InpovlhltxEd4kMjCMd2CvJqxzkKOOILci/NFG+4TWn?=
 =?us-ascii?Q?ShZvr2NK/5cjFiEyqy7D2j5oP2ld/k+scB0giPVwwC9+a0898FXqViwh8992?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0f944c-9aab-4e0a-5eda-08da8d2e353c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:02.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lo5o6ghG8srpXX/XJoRUOXEIhXtD8lIeTUYx2vEksEJs/7WDVjDbDZFflhg8qea0PjQ4wkY/eT40DC0rx5QMvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 5daa8c7626f4..af2e67a250de 100644
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

