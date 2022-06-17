Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A9B54FED3
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382937AbiFQUgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376469AbiFQUen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:43 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FE54B41A;
        Fri, 17 Jun 2022 13:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cL6xGsFdDpbPRv86UUQNsh4SEQNQVt0uOWXP3XDP2/g2tfJ0KdierM37MyIIUBpVc41FTsz3DmtS/dB3IrBK0Ouje518eYWc6pKH8fxeZmzGdHjMMDnZ7OoXbc62g4ijZN4VFPGqEquHrP5eVqiDtqpVW8H2jDPh4QZXFvKVB9LxFYLcoZc2IpUYW9jzzBggcHUUD8oeHGPaJBNz5Ry563LBOQZlS1Pc5tvIcY9OqLeo6JOWYcdDrOsnEzXuafMcqaCpHCQC+xwkQ84vsxscIM5XXiwpDFh4itpd3G0fVFVtVq04Zm5QuNOkFdQKYppBRD4nRqKAO9ug38iJn49XnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YilwA5Zrogv3QaWa3jbppLG2d8NIsOs1Kb7V6wRF9aE=;
 b=IiIHt+/WbaYowdAbCgu+Ts3aNEcesEs8MoKcymZ299w8DzFEEW9D/evC6hi6vtI4LuQlVq4abw9BrEK1RWutkf0l60/Oiybnck2EcU+dpBm3AuENaLXzkRa8KxEtrUAzRG3b+GsycF0LtqNw/Cw45yc3pxszBHGE43NfgZZ+bPxLlSrestvoyUeuYXWn0WmEklELqB++bk2gmmrMsanIB2Ur1Sn1jpF738wuxrjdzfpnkC8dLI0AuhRDzsf1XhZoGylykocPjsoBu4tR3vQbUi2yCE4RLLU0IJLk8ImFWjzvD94VN8960JPQ98FtZl4sLU6QJ30FYqRcmzRkwfYkhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YilwA5Zrogv3QaWa3jbppLG2d8NIsOs1Kb7V6wRF9aE=;
 b=vn0BKWGCkDX9IsjCpTNdIxBI0vgY6Qg5jQb1KOV05wXWZERW7qaRvDBjJ/RlWjr8dJLEvP4N//k0jwKioeTS7RxhleKiHQOu7XOdTp77gMZaXivoLoYuqKtB/iDAXkTmS3r0ToZlRdmsZSnkLrItpxySL29GUgFPRy5WCDpPU0Jwce/jdj42WL8BZLcspre8GFQT2hRv2fRGkUrLJfme8oj3ND82W0bgCkDF4GR+9NgtMyx+wphkhZbe7ByP8yG2nbicOs7JdteZllJ6hE9p13Zx8cFSd3T5wirMbks5+pnhOqCky2TqQ7crsRUhUtR00IhGKSKkoCDtoYXRJPbFsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:08 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:08 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 17/28] net: fman: Remove internal_phy_node from params
Date:   Fri, 17 Jun 2022 16:33:01 -0400
Message-Id: <20220617203312.3799646-18-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 737a7221-0a90-4225-8827-08da50a0baa1
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB6838B2DA39AF558C1D69E4B096AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKBzkpu/MeoQE13AEDqQsL0V2HYvyPTthPIwQgYLlX28LorSMI1pAf1Q6DKg2K8aFGWJ0IB3/Q/zSPn/fT5+UKT51lArEh9tLiJe7L/eKfMMZyn3kLfUheULv30u39bGwf6wrN5KCAQhwI0A84kbva6TtLLYfng1iNf0bVKfRxINpDeiqDM9kNDCKcKB96JWP5pfJancIksJ5oaKQ0IqUfoKgDZdM4tnugyw+89gTcXOfySMkb5akWrELEjqk2pWy49feLToSJg9lh5xJYS00mBwBKjb/9XtGFNgjsJln0dYTUdFyfld8NaXQJ8TGMN5xRX886mK6Ffw0k1ehtCCV9N4GuglV9K4aI2lbwnPzTCBSORTcd1v+VfqoH6xib2xA6heF4hlq1GgH1LE8/hbdAV1RQ5u+MKOhQCKn9FyZzx1D5FUFSKp3K463u4Zh6EX8eVbTbzUdoUAqID8jDb3huthKLV21wv1QXtc2lQgoOLVICJe+NH/45vS+vdg440SFEPTkZQaLw0D+avzwl326njlfYzlK19ptF8fK1QfbgEyZzMpII/1wgivXTR8DwWrVoasZlBNIdIjO1K5L7AUHGM9p+BNPLj7+9bxRj3rSRX7Cxm8Xe1/IPN5cV/qQn09JTa5j8R7d5CQ7gps53jQKK43vnFsQyvai0WixVJC0DDfBry/EMVobaYQ0OTVXmvB2RWbzByyF2NwiBujzqbIhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pZYuFDIHPvWt0zcgtNgT3C6cNmR/LGbmT+etnS8T0QYyJONIubXLJH8AbwST?=
 =?us-ascii?Q?JzE5JF9LuebBw+oBoJvRC2aa4Sey5dODl3JrZQ/RN0I9p7zU82TLxrqK8yP9?=
 =?us-ascii?Q?fisQtHXLSfbnbzrdqvQ0lWpl83wZAV/Rp5fcXRRynfvbyM/av81lbEntTE/k?=
 =?us-ascii?Q?HbfVAzEcAh1b3vtPV8Xu7lgqJMpLjD2FMlsU96nqd6WEBqdqr6hNd1ev0IJx?=
 =?us-ascii?Q?T2rw5sbqwwdt4niet5deOkAF3pzSiaMfAy+XmUDipCvx4LSgMB6bS2XJilzm?=
 =?us-ascii?Q?vZlV6+6lAQAORItg81LXjeqy8+gRa6BGumFUFHjNioamO/2ncYV8Yu8BO7qy?=
 =?us-ascii?Q?ptcRqi8sbHBBJBMOxVNE3ixaJGNZYeATQuYGKLTMqUme42tCsVWqS25wnf4U?=
 =?us-ascii?Q?topbkgNE4Tgaz5SVKL5WWSw1BgXzltJMHMllFHCUFYa9yhMzA9GMsjK7DQJc?=
 =?us-ascii?Q?+54ZbIS8+2OXWwDjpjS5flREssdz5HRKTdqpSBIfy+aV/CrweGVMPRJPps3u?=
 =?us-ascii?Q?sIxe5wYWDttWwnXuIWqvt4t8UeALZk+1O1MpKCmZ90fXJH3e6I2RVcXU4IQR?=
 =?us-ascii?Q?Ycd14GROYQ8fokyfHMKy+Qa4fwTcYiSZg1OY6XP+ZA5VrCIUwH5VnStIMpL6?=
 =?us-ascii?Q?Jdz2XagXHRafq4Q6pfN9XMxhnyN9VCTS9GaVPz2CTZIhpfXiaVENCudkBYJm?=
 =?us-ascii?Q?80AwtDyNJ3osyV7LIz8SC2jYDHBRcC5h6R86+W7L0fhBn1aJ0rMY9Rk9xl84?=
 =?us-ascii?Q?1flxnhSETPFxnMagKe6giEVG2KiG/sZgg6l6Z3gf2HM2xUy3CDpN9IuqrkOE?=
 =?us-ascii?Q?LinXfGEThO6v/9nBuSjMFQ5eD5QM1FZt2Q3KPPF0w33dyW4kYcaTR/bi015e?=
 =?us-ascii?Q?OVOUqL+ZnedCz57a9skd7YaGq8LnXFm8YNySIbrjaP5RFzni6fphTYyLsooT?=
 =?us-ascii?Q?VEqkNHVCyKmqhP6npBmQNGEr2YBGxDbRCkMDAfOY5JKz9BYZEpP5vOwUpaxQ?=
 =?us-ascii?Q?tdbMX2HlWxEcn+PtIjdnOLjLHbDptKPNyFu8e2YuAnAI30WRnx9zDLhGfLDc?=
 =?us-ascii?Q?P/cruDAQLfIHuxjZn73qDn1wiuW9A+l/Kz9IRVqX0CXkmUU+vJG4XuiCrwon?=
 =?us-ascii?Q?j1hgLmCORiKcKPK+Nmi56ftkBAF6q4DAvK7X53+GAKPnkRTsgD6HIsqAbwPu?=
 =?us-ascii?Q?Ghp2c/YRmycEWDq9c/3qhsNQBd95lhhGiwOnndeLIzGf0PtbkYU3ZOENCB3p?=
 =?us-ascii?Q?tteAF9aA8bwWGvNDuFcHCZ11T7rdpcwRPwny/pjMAO29ryae1WPEkKWNp+SH?=
 =?us-ascii?Q?7GPdq0s5OTLmA8jfOPmjRdRNSs4I5YlBatrMgyufClD+vgvOrD7FElTjqTdD?=
 =?us-ascii?Q?1PCMBQr22qFzmFTFHJBt826luGN7y+oyXdKNFWY/Esa6VDLc5Y6y5F/c+tK9?=
 =?us-ascii?Q?Acczpgac6Uc76T2MZllSYAGEnLNoQsS2jcv33roaK67HlvpkzSmwyoAnTBjN?=
 =?us-ascii?Q?EuNbQF8gkAAr0IhDv9qpL7Gy3ukde3Sauw3fMjNos4iy/JWUDZORodiG0nuB?=
 =?us-ascii?Q?S35MjYoe+vrIJRtPu3Fkb7HOKlhWWPNy4yF7yWpB1bCHHbVnR1huVVljzs3y?=
 =?us-ascii?Q?sEW+8mx3b56CNdGFOpWgicAGqZhNAjZkbiqtnyj+heY+xmwgvwMxnGws1k/Q?=
 =?us-ascii?Q?Y11NHlLD6dNlgAkNJF5YVl/7+FxE3uAFzWDGzn0pqmCzDrpeLWSrcZ/AzpE2?=
 =?us-ascii?Q?np884/gG47VBDJm99yUaXzRPx6oZwn0=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 737a7221-0a90-4225-8827-08da50a0baa1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:08.3890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoHTSbpJ2YdfdZ8zqTgx9w4ZiXuE6V8MSV/X4bLTNh4kTm4J7T+VqMd64JdNVIno0MxNH3R9Kwx+549EJtcKPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 33 +++++++++---------
 .../net/ethernet/freescale/fman/fman_mac.h    |  2 --
 .../net/ethernet/freescale/fman/fman_memac.c  | 34 +++++++++----------
 3 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 44718c34c899..b94fbc38cdd9 100644
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
@@ -1495,6 +1480,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	params;
 	struct fman_mac		*dtsec;
+	struct device_node	*phy_node;
 
 	priv = mac_dev->priv;
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
@@ -1514,7 +1500,6 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -1525,6 +1510,22 @@ int dtsec_initialization(struct mac_device *mac_dev,
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
index a97815287b31..cfa451c98d74 100644
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
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
@@ -1196,7 +1181,6 @@ int memac_initialization(struct mac_device *mac_dev,
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
 	if (params.max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
@@ -1210,6 +1194,22 @@ int memac_initialization(struct mac_device *mac_dev,
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

