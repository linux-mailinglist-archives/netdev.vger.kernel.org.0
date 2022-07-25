Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F39580154
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbiGYPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbiGYPM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:12:27 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FE11A3A4;
        Mon, 25 Jul 2022 08:11:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aiyJT8k3h0vUHOEMv4PX+eKFvvoTkFr2sanOiATV2sFkR9a13LY955eKKSPQ41aaT7EkjbX8+9Zc2vWvcAdoFVoCM3GLCHMQB7Dn4xgIm7P0cur6rf3L48iQy6gmn47UV3/wPP+qQ9hTZb5NYA4i33BTHB6A3+f58X45gJKsWrmt6rfhGVPFw/Dtf1itnnhYg8sfsQtpp9wSf/GY/Q2MCsn4pQiyZBGf9PdOxXdYU6dIwzT8Segxw4wZJghr2O4VI1zmY/YbZMfV+Mm3j3WSrTt7p4I6JYYEDE0W1w9LV0S2sCVrwQiXQqJmlEmwa2LxWfQYc08wjpypVfc3Rc+jWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uF6t3FMJH8eO9mFKLCWfuB6lgblJYlx+5+0EOJAwDQ=;
 b=T7GY93biXr0iRWWa3tBmacZDL9gYHMReCiTAYJDu0qwhA865bINC2kSGReJd7JmCfHlw+Jc+DSJmnqZSTTFjACXpQx5cgKS//YGZ5Az82Y71hvx/vIn+vxapP7QQsQz2L/XUMQnKQRWbxZzd65tVK25jX6BVs9oDtynmwrJuM10X5JMilPWf1gTeExkvvPQ5nuIcmclsKfN9IxdS0j/7+7/u2Af1Na8XQ34FBRh5KMgibPGhABfnpaeYIG4kmiCxBqWoSd7z8KQ8CULRzblpfSnx/xgV3mdnHwQg6SoF/lJIEMsL7f0/WxKsHXV61tM4qn53fZtG++OGUPDbLg0J7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uF6t3FMJH8eO9mFKLCWfuB6lgblJYlx+5+0EOJAwDQ=;
 b=msyFSZBOG5wADCUIJTrWazCq5JkJkQHgfs1Z8JhDbT6F5WaJwdyNtVU48RyGI/dCNQ0G9FFisEtFoBw5amaY+6/F3drksJo3lGLbeQ0PurjByoxikXP0afeHaJqyKbJqizP4hxgpldsd+PPYWNHcUMxM6uAwaRu/UeGcNcrbfI9xzoalBDtDuGq8X6vsfN8p/FfIaxG2pWOzLVBRZZBrccQxbGmAPBxJY9W0N7BWA/X4K6hWuiyR1SWZ0Ww4ppqd6PUvPyNiUhHyXlvJhWJHfj/LKnGbTlqXUNcoCqre4OFeSC4E9a+sxKq9ujwJKKpSQ2s9C2YollSWy5KFF0Yuyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:25 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:25 +0000
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
Subject: [PATCH v4 15/25] net: fman: Remove internal_phy_node from params
Date:   Mon, 25 Jul 2022 11:10:29 -0400
Message-Id: <20220725151039.2581576-16-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7b9eb516-f7b4-42b4-9eb1-08da6e4ff15a
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3PYlLBhbZM+WB0WC/EPJWwHuHbBcw2GriUzQMf8QvKo2SSNzhgytkb95uPGUXdZH/rgz3zEgwI6O19xF0dNcOCHUz7uZ2z3CchsZPYl0gaF1A8ZSBgNSTnkTEE+og8QAn1AXWfwPPQsuM2UQUD4MdQclhSEmzB2DOA0LHrSipFP5RTryfNVbi9J7upNcOmiVscM8iWlUKUVHbrj3ejt4irzhaBZNcnjtOex2nFZeH0FBRXnZ95bPJTRmsyTuxjrjkwjyeRArrMDD9ZAzGKvmXgfH8Im9taa+2ZlkKBspdslIsa7hYisS/lWwdq5/FQ2tf8IEZpI11WeWPDDdfRj6GvdqZ9+3P+Y9KpL1j9ozuaihNqAl3E6mSvJYM6cDpLGBOBSjh60KAV7unQBxGBjiJ/9YK9JNkNfxfjVm5AHRY5sgw+F+aoMgJsC5jsAOcq5MIt3FP5oWQP2F1MIK1UKcOzUKURQ5g0VO44u92J92ni5KkfUSEAKtwVOxdI3IL4iltkDA4yUWRk89vyXbpBXH93h+pztPtpZzKk2yIP07d61e9l2SjEH4rVCVS3sUCWe2p3iuL6PuhvJxuWE5As0KtHG50gM7SrPZ31npR//6vD2N8bM6A2CV6MVSMbXgwehr3ujc07fagrgnONwtxr9l4RlQaOQZrZ5NWr3MsXLVc8dXbtmnFQfYCxQX1jb9b63ef7toDnK+096EsVtta1Y3zaz3Amynh0kHUoCNrvLnDM5+/55C9iFhPML6gI7Cb105esBWGwG8+lIiJkIWG3XGef6lqvS2XWaAfDKsGgzWNvg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mBKElNbawYZJH4lycEN/aJeC82XQC++L2ipW/W1tEUXnXQd7iQERoc5F6A84?=
 =?us-ascii?Q?v9fzbBPE/emWLfHa67xSoYKH5WZGNezTmK+lkmJYIO5+58uNpeadylKvtEeI?=
 =?us-ascii?Q?guy4Yrah3c8PLZ/gnYP2HTmp+J24XxxtYoq/kLRVYULpjV0dXKgjpGXTQDFd?=
 =?us-ascii?Q?Pdt3o7dCcQiKZkrO3a5Cq/nZdRXdl0t+10DIg/sSeZgXAuKVyLeQHl/hmSbP?=
 =?us-ascii?Q?ygAQAMRfeLrjmhN4momDEBfpww//oWtrvBfMznFl6Rx+Gl5ikqA1r9cUMnBk?=
 =?us-ascii?Q?cICrvP20XIgAxQStVvZHgT9Ww8MFHac1/NasEu+vdYTzrxe7LfTStDRvbCxa?=
 =?us-ascii?Q?N8953PifCbcaw68ZlwXb6FjdoWOwfrwhDv75qoeH99Mv5fcRQjGGXSdvM5GV?=
 =?us-ascii?Q?NxpNnaEeTubAE7fA19wd8vuv26hToD4seeWGmj6gRVRoN0LNpLAZHa0ZnSvx?=
 =?us-ascii?Q?fuV547KPfmd+WmzZt40SBcBgTNeyFKlW2MKxwUf2Pwr9qrjcCvTM8M4A120L?=
 =?us-ascii?Q?VkciglEUwsjfPXqqzpt+OBLl/Y5Ao9veNhU8op++emffvLPchn0eXqmjhet+?=
 =?us-ascii?Q?9CEKCTftKibKPISg9sRXXZnIBEf4cKPdYy+HZVrsb+nVMRYfBFAWw2Y7u69o?=
 =?us-ascii?Q?cZgziLRGzjpQRxOum/XEJxvFcqcCnDasTpyC1IIQGaoD1wV2HQdmMxEmTPlW?=
 =?us-ascii?Q?oynySYQW7NhhMfVzIkifgU9/p9Dsjq45L30MbhW4G/gtzr/a4Pc4nWQLuhxg?=
 =?us-ascii?Q?mgutTWZ+BBz9E67bMBmdBNj2KHdXkoVKMaYCwxOVqkZvpMbp/uPAz2S0USDn?=
 =?us-ascii?Q?zU4Bd6PIfDxOCQa15OMJ/0YnuT5x3KEvbV7hKRCG/cZLtqII60YoIXtzPtme?=
 =?us-ascii?Q?qV6Xh4p1sBBimGQ7cQ9MZnjq1zrj7N4lStwbEa++wNzGqK0B1Gd77zLP+F4M?=
 =?us-ascii?Q?6KNxYnq3EVBnhBeZvACHl8qQAcJiIn9o/rxTlcsfgxlvIW2q17+dmvJji/6h?=
 =?us-ascii?Q?DGRkPGANaz64HkgK2yAyF34E5TGsPL4+eqJPpSXa1PdfYexBdm8Hk+Vo/lkm?=
 =?us-ascii?Q?vE1CcriyyrzVzVsoxlGdWPo8RWGGXFT2ATVB/zuqRfGgHAflSZvDJjJNbiYJ?=
 =?us-ascii?Q?MUl/4fwxZz9JTbqew2BcUg2J0d6aWgEKDP+jF0XMgr30cWjfchR58HjtODut?=
 =?us-ascii?Q?5zujjJpHCdYZ99QK073iUpDiq5HIAWtk7I56+xG4OR2cw/hP4Ia9e6kPyXWJ?=
 =?us-ascii?Q?lzRoWMP0bZHH/cOPZOtdjtqq1wQi2/Ofrc3WAWv8WVhOIW2rBmGhdIhI9ful?=
 =?us-ascii?Q?vit3Tr7z5GJZvau+PoASVoZ2246pD5TR/KbzsyCbQvVooEcMG0jcRKHDDKvt?=
 =?us-ascii?Q?ey5I9eF0NRrGJlsZb6gN/C3RzGTAUkl9ZC49bJq7zmMaQ7Za9l5OQlghb0tc?=
 =?us-ascii?Q?vthtLgyiNmk1BgbULKoS1yHP8zKZ7uA+5rolOd2onaUZWDUDqeZKureXK7Y0?=
 =?us-ascii?Q?Uy7ayMAyi8qnOoR1Ow96CC763LTQw1kaT0S8ewW+S9wUfGF5LlG9VzGuUCXF?=
 =?us-ascii?Q?Z969iHw1vZR5DP/oyjk/QqfN7NidLxdb00BeNzH8fqEX0f04qh4xWn/Xx5cH?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9eb516-f7b4-42b4-9eb1-08da6e4ff15a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:25.8159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7IJtq7YCzEOlsGGunsUvR5cqOx9zqTi9qPdqF3DdHsz6fyTdeRYP/nVeU06ClermrMDfJKmAnp4LsC66pJrKQ==
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

This member was used to pass the phy node between mac_probe and the
mac-specific initialization function. But now that the phy node is
gotten in the initialization function, this parameter does not serve a
purpose. Remove it, and do the grabbing of the node/grabbing of the phy
in the same place.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 33 +++++++++---------
 .../net/ethernet/freescale/fman/fman_mac.h    |  2 --
 .../net/ethernet/freescale/fman/fman_memac.c  | 34 +++++++++----------
 3 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 84205be3a817..c2c4677451a9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1463,26 +1463,11 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 	dtsec->fm = params->fm;
 	dtsec->basex_if = params->basex_if;
 
-	if (!params->internal_phy_node) {
-		pr_err("TBI PHY node is not available\n");
-		goto err_dtsec_drv_param;
-	}
-
-	dtsec->tbiphy = of_phy_find_device(params->internal_phy_node);
-	if (!dtsec->tbiphy) {
-		pr_err("of_phy_find_device (TBI PHY) failed\n");
-		goto err_dtsec_drv_param;
-	}
-
-	put_device(&dtsec->tbiphy->mdio.dev);
-
 	/* Save FMan revision */
 	fman_get_revision(dtsec->fm, &dtsec->fm_rev_info);
 
 	return dtsec;
 
-err_dtsec_drv_param:
-	kfree(dtsec_drv_param);
 err_dtsec:
 	kfree(dtsec);
 	return NULL;
@@ -1494,6 +1479,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	int			err;
 	struct fman_mac_params	params;
 	struct fman_mac		*dtsec;
+	struct device_node	*phy_node;
 
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
 	mac_dev->change_addr		= dtsec_modify_mac_address;
@@ -1512,7 +1498,6 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -1523,6 +1508,22 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	dtsec = mac_dev->fman_mac;
 	dtsec->dtsec_drv_param->maximum_frame = fman_get_max_frm();
 	dtsec->dtsec_drv_param->tx_pad_crc = true;
+
+	phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
+	if (!phy_node) {
+		pr_err("TBI PHY node is not available\n");
+		err = -EINVAL;
+		goto _return_fm_mac_free;
+	}
+
+	dtsec->tbiphy = of_phy_find_device(phy_node);
+	if (!dtsec->tbiphy) {
+		pr_err("of_phy_find_device (TBI PHY) failed\n");
+		err = -EINVAL;
+		goto _return_fm_mac_free;
+	}
+	put_device(&dtsec->tbiphy->mdio.dev);
+
 	err = dtsec_init(dtsec);
 	if (err < 0)
 		goto _return_fm_mac_free;
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 418d1de85702..7774af6463e5 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -190,8 +190,6 @@ struct fman_mac_params {
 	 * synchronize with far-end phy at 10Mbps, 100Mbps or 1000Mbps
 	*/
 	bool basex_if;
-	/* Pointer to TBI/PCS PHY node, used for TBI/PCS PHY access */
-	struct device_node *internal_phy_node;
 };
 
 struct eth_hash_t {
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 039f71e31efc..5c0b837ebcbc 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1150,22 +1150,6 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 	/* Save FMan revision */
 	fman_get_revision(memac->fm, &memac->fm_rev_info);
 
-	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
-	    memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
-		if (!params->internal_phy_node) {
-			pr_err("PCS PHY node is not available\n");
-			memac_free(memac);
-			return NULL;
-		}
-
-		memac->pcsphy = of_phy_find_device(params->internal_phy_node);
-		if (!memac->pcsphy) {
-			pr_err("of_phy_find_device (PCS PHY) failed\n");
-			memac_free(memac);
-			return NULL;
-		}
-	}
-
 	return memac;
 }
 
@@ -1173,6 +1157,7 @@ int memac_initialization(struct mac_device *mac_dev,
 			 struct device_node *mac_node)
 {
 	int			 err;
+	struct device_node	*phy_node;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
@@ -1194,7 +1179,6 @@ int memac_initialization(struct mac_device *mac_dev,
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
 	if (params.max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
@@ -1208,6 +1192,22 @@ int memac_initialization(struct mac_device *mac_dev,
 	memac = mac_dev->fman_mac;
 	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
 	memac->memac_drv_param->reset_on_init = true;
+	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
+	    memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
+		phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
+		if (!phy_node) {
+			pr_err("PCS PHY node is not available\n");
+			err = -EINVAL;
+			goto _return_fm_mac_free;
+		}
+
+		memac->pcsphy = of_phy_find_device(phy_node);
+		if (!memac->pcsphy) {
+			pr_err("of_phy_find_device (PCS PHY) failed\n");
+			err = -EINVAL;
+			goto _return_fm_mac_free;
+		}
+	}
 
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
-- 
2.35.1.1320.gc452695387.dirty

