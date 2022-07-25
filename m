Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A6F58015B
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbiGYPNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbiGYPNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:13:08 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2971B798;
        Mon, 25 Jul 2022 08:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6wQQzTjESDLCswkMF1Z5x1l6CeE45k2hOaAZNW/5LUkdhRdfRG1lrHkli3Tg4AXrp7bYOnwIgzVAsQBT6DMpU26p05Q719p0fe56kk8HcsDcMx0QNIE4cuMHJCYA/f5ouQsKJgriLLs1KPlW9n6U6uV08zlVLHyWThb0y0ihn9sueMOIy+vDLX1acskCIP4tePge7lMq2b/bzqSrewy1BZO6mcyNFcrrzt/CUwBZ57+rwWFMUChd7geByZJvydVZ4ByTIAjRi1hfUk8j42E4y/fHa0AZWcwSnzWNtdm4SlmN5aeerBcCW7ly5K/FbcGZuai4BOuAeQ4SQFaPmhRMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjfdFtV2Kn0MnN32TKkSGHoI29fYTJaUy5GLPYutZkA=;
 b=DP2tXQ47sgRe2fkOJigVW4S5KOKcvxp+xJM7YSIB2Kega3ld6AcP52oJhfOeFfSt2UqJ42y1eSicq1mnYjmVb2mrwPFnSSmdlp1J5ng89sbFz/SuMROmJuWYP04xY6m57toVvU4MM8ay+DyMJKUvt1H+0Q10RNzaVsGycejozdQE2Is1oeAorxkB8x9JdRlOWT6eKQLaEe9XR0FBapfBsBa/aa4gAcYaTCBc2f/kfy83m2kuFUbqvp9Vh/qqbdT9HdHlLp/SgN9OluiFZQ4df8XZ4lyi5Eh12cx+zYPVnvmcdjyyFHylPTbgoyHbVmjjldqn1OKkHKhLaQkKn5Wptg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjfdFtV2Kn0MnN32TKkSGHoI29fYTJaUy5GLPYutZkA=;
 b=lK+T255Dd44hvtu5abdhCbEk1K4Gzx6HXPGoFP6ljc7WmzUrherGIqBngHYBBynQTxxHyM/Xi8YfKzidye8Z/Y8Qlsk2e6oU6fgQMZc0yv5HhE32Elp5XLBa40YIjP++pdCqthjV0pKx/XqKELzFWcJpVLkJLBl5+tkmGoIx02kwm7rcXVHeNqfC0UYSV35hYVbk5Q7Uf8nlG7AsrZwDSWCQTm13HvnfAFVxmhFExQJRLiIrI2xiLZ9B8Xkx4nbKFizNVFN7EKBRu6YMXeKU9oHaXt8dsAdWvIg2IenzoKsCU8EDTG3r561tQjYZfoqhFCSnoDJIDTImDGsPeBa/xA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 18/25] net: fman: Use mac_dev for some params
Date:   Mon, 25 Jul 2022 11:10:32 -0400
Message-Id: <20220725151039.2581576-19-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86a9991d-3ce4-43d5-7ede-08da6e4ff493
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PvWVOJqDfm/nK+a6w3gq8A0Uoj5YFZCLi1//aUXL6bFBwTO2wpEi0BdTyjdHumefLX2UtOHxx6Lea/XN/YxqdjeBLcytXNnboTr363oq8eQwTBzKzoATN6ZqCariNwOE9dGTyPKmk/9YMnUjM893R/EKExqsvkfqhpMDdk9+a/69530FO6k9qolzoDpe3cjVlIj8bxWMWWx2K1PkEhVyxeYSc6Cj/eCPyHrTJSnQnFI+IS/bGHkcSE9vEMSYUUGnh++WcfaM7hEXW9G+dUgZnfidvlzbG6irvlsLTFGoAM5kyamJWHjfxcWO9oxT0mLqeKKmkK81DuC6BLmRXyCz3yui5DIEI7DnigCjzpD1+05Dzj8VYPEhOSaWSiuV475Hwb7hwAeovxn+l0ZZKOXZ9E5wH4PjmiFiX2H4TNPnH+9v0tiF7+VEtqoytl7ZOL7/tP/rZA7YPmaXwU1yojBstaYZ0xd0mua8AQreXsRPZonHjfKboOKkTHusjpK2O/mxKKgbawxYYJBlSCn1pSW4maIGstb32KfvJtCJS2xbxQcj1Mqdrt4j0okUOFG68M+xwJhNmImd4Tv2ahIrT1xCtSQcTUTQ8gb/DLdHEpuI6lFeJ10grILu9BsmX05B4xYjU/tkVyuFjHNOFaz+7gRD3FdIkhqdOnJK/R6tl+pVYZQdGM5vjr1z5Q6Owoj0O/IUKWd2hhi/gFFYbPTTbME2z/RFdhLk8FDxhM5jE4Rn48qI2ftFLrCTpwRuHLMLdwe9GwrigY7/ydxpFhI2zIbO8IuD6gI1lhCnDhqEzX3LxC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UkQj+8DecIyarePBVCwWvo1o3ZEsJx8DekpzqVDWfjuqBcl/pnfa8DgJuQUb?=
 =?us-ascii?Q?+3UkSKf6hDqe1mTzeCyHzpBikC9uGFke3O/MKLA/JVkFiGPUoWISjvtdm2ym?=
 =?us-ascii?Q?79dxWUdXRgGbZPTt04UfYqHiVJjQT0e+RCXt1h/Wjz/Y9nJ2aiWICkFdww0s?=
 =?us-ascii?Q?Xpn4MybFIJ21h6a+0JnuZQHpFtKFsGHmUHVmXeogmPYyEzRo1B0/WTlQ8Sbk?=
 =?us-ascii?Q?HGMinuOX1DicU1UsQVj1I7WjIlkQ5Zn/R13XHm2iUb80vtrcy2ct3hyK//qd?=
 =?us-ascii?Q?i03kbllsOrpNYTmjmwZUMnhTJUs8Qb1ccKKlj5Q2lHpbMyW0o0WRHe5TJnZD?=
 =?us-ascii?Q?IX6fZK2H/JdyVPRu1j4YTA8wYhBnUUydJuT2Zy02O/dRVgOqrprPwG56mBKk?=
 =?us-ascii?Q?s9XH9pb5Ligz7kXA7IbKYhoWoxftpUFcR3VKie+t8B1aH77tg5l2rjNuIhuw?=
 =?us-ascii?Q?YBLTa+9Rpg+Vu/riUXsJUd166QM2PUu8k14otBt28qi5A0duwGpF3MApFUSW?=
 =?us-ascii?Q?PtjeivrhtZGYN7h3/F0LYo0/+fqSJqpw2wLhBPLS7pbJOJMMtDFl7RIh2s5V?=
 =?us-ascii?Q?jF65L3kIRc4UPzW7LD9t7ZL7My7Fv8j1ES4H9StF35Q6mYNsqNx9aAkA4T8s?=
 =?us-ascii?Q?PmZvzD8ROMOGSl/cNrX9sqRN1QaCMBB22ax4HBXjIvXO4rKqngdYL05ieQI6?=
 =?us-ascii?Q?sd8a6cGgwy/9sw82Q9udAeFcF1zvXhnsG7mb4QoF9OAK3NWEjpoIlguIl7Nv?=
 =?us-ascii?Q?r2QpG+3mB1daW9s2muOgwzUu9wgxWqkFtfCcp6ablPi9T5FaNXhsvOrErXWE?=
 =?us-ascii?Q?wZHv5worMJQcpkt+jTnaSIOzinmsJVpy2eKcz9+hViJls5s39h+vozFlO1gv?=
 =?us-ascii?Q?9mKxVY5+1dPt0WN8EJ4B9zqg/3S6X/DsaEtdeqBFwSDNSb7pBzvRLrRedwOx?=
 =?us-ascii?Q?gJ+OiUUq4HuLwQMMn1ArbEu0swzcBI5ERlLuGmWmJ3sNEAVByZfdO9VPb1f/?=
 =?us-ascii?Q?/jOyJOSVrl/lLUFAIWBKi3+WFxJR8gn0U2rnii+NCmfzjmmDB9AR32ctdAc9?=
 =?us-ascii?Q?vJ0XIeS1v39weItSIAY6bj86er2JxtsMgbCDnSviH8YkH9js4K5KKod2Z+to?=
 =?us-ascii?Q?J4sgUg6RAdVzULW5ypzr+t2V1E5uqahV9nQD+iYzxfpw07loTJ818uTVGKUB?=
 =?us-ascii?Q?S7Xdd6V1VVGF7+jSzSCmYqlsJR1659sC4hhBg4ENg6mnAY3ZTAyx8fnUPa7/?=
 =?us-ascii?Q?275awv6qOpXpUB5KqsWHjrVd3zeABiFH/vqwvC55B7yz5ZpgmUUy0TTdBgz5?=
 =?us-ascii?Q?iVOEXxMCHJTBu5lVlAdJDTQtmqyOVa7IZZ2kE3J+2sVqCjwEYfDhTBe4/EKg?=
 =?us-ascii?Q?Yuy7bujVf24WmBA6bvk+ZWtcxp1Uf1UpWvFXhLDRAxP9eWdLeV7CdO0jPTMp?=
 =?us-ascii?Q?6/n32p7+0FBzZl8t9hQwfASnDGHCVolZKc8gXRX8REusl9UHTP6I3SxEazce?=
 =?us-ascii?Q?jF0nJQ0P3uKNPzOVyOHNpx6pvSWmK7MgDzoZsV/FFtnMzYdYhJezdi90PrOO?=
 =?us-ascii?Q?SJNLzrdWmPwkb6sQJqaVS9V0ZtB+FvnFRWrS8bLoxB3bi91cDQtQdNI0ACkb?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a9991d-3ce4-43d5-7ede-08da6e4ff493
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:31.3156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ScN7c52vEfa5lG4bt6uh66LuAOd342p6vMkBGScifhTvAQzTuzt8KRBiLJUWln3D2NQXRZ4vJarfI6rCmWYPQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

