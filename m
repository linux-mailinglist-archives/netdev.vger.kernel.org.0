Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EF657697D
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiGOWEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiGOWDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:43 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F448E1F1;
        Fri, 15 Jul 2022 15:01:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLxXMLbb5Z687wf7m1V2y//PCuJI3IvIMPaaUBWkQWUF3wYC7sm2IZm+mvjSGqwoPOkdQgrEtM3Gz7mL7CFxBMCATalxrhks1baHFo2z9AuFRiska+m9wNMuTbEC5ciOEXslNNEN1fUbo4K0xp/or3Dc00g34QvqbaVH3Duhwi9fwQiO6AACY/Ntg9uOaJbA8e/gGthTvL0hmRDq8XCAJ0oVPBvjbUJ3HIwmV/GLsfpofCP340tq1FSh11IBk2I6TMxqASM47784Z8M/voL+8X3xP8/i7wEoaoFaqe1AA7esFWeAKtfP3mcR1UcR/52BwjbQ//RJxfA5wQXps1+Efw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GDp9p2z19h9IzDM8RWXvgmOXQ38jj8WkWnhniK7X7A=;
 b=dRVoF6FmNM/u8irh09sroKxG7nswVC69Sm+tzm6MngWHSGdcVJu8tEok2igWM8/TiBY0RL8YmrdZop9yEiDMzisUzuH6b7r+87PDbqYGvsxr0F8JC4doxaVk5lX8F26e5tyz4Tkz0cU0L1QAekwuCTmOXH+wzlaGkK2jO2I44Tci03FS5ztNEZlSyAeIZmGm+7aBgAI2aoSdMuq4/P/9aLpKd6/a82gusQPcZM6dCQcbp2xAvvwwrQWpQWHzfCJJ0lXsqW5SZaa07iCnr7tS14aHuHiG0a8WXfyWQjm0p5/1rfuKWDJM+YzXRxl7MxIMQJLRngXe1qjlYE4VwqBM2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GDp9p2z19h9IzDM8RWXvgmOXQ38jj8WkWnhniK7X7A=;
 b=C2Jcz+L/vKkb1HSYJrXNO7CIwsrDQExQMeJyvt7g2FiWQYaMKNvjdONtTaoohhBcgFIerz57BkaCPbrypnbl25Z+lt1sfUy95T7RDJaU80Z/CwP4KC4e6M/Lhn4nIKJvyn/mgwC46V7FM+W/U2ruofEdE17pydS47HhAC31+qOqbnnGp4T3rlyqtWaeUZFjHncOvgxc+EViOY1a2wVg9D4rkr7muOczIiTH6jDP4slqJiDslhIeJAmlM/YfFDVc++ExPqg7udrDyxPouFLYXutJfTqTDn5GGx/m3xuPxCiOBpTgiV1q0EeL0XgOFe/s2GVUxJKqnL/DFm8HtCv3viw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:17 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:16 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 28/47] net: fman: Remove internal_phy_node from params
Date:   Fri, 15 Jul 2022 17:59:35 -0400
Message-Id: <20220715215954.1449214-29-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77fce30f-9344-4b05-cdbe-08da66ad8aa5
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nADs2FYDHIdoUseaLPS+FQkd0nJj3XXMziPUOlPmNuTaMvczB1w4fCDF4heQh8wIP6zUKEw2dB7HD1mqKeimYK7TK7H5zvMXXByPKUVwstIQHKxbgbiCl1/q+A2qaB7Iv/y8NBQFQgIYQfeph0tM15alcUF27KpN6fGRKG9oyCvaBlHTkp3nnQKNagUG/3vSGLr1YHe3sidljNGuaqUtt8wmP2L4hW7ivHLP0rxEQBziapTL1lYEZKbVd2Tlc6zioje1DbvW66QHhycmJJJn2fv2p/YVzTHFwVDhRtjBNmL8QDqDyKYtJFPa/0rO2vYTTD9D78fk2E1BFP9fttNMsvPsrJs2TnH5FTAjB+B9srTuWAejsvX0zG8FnoKEH9SQ0HMCfUqi0HEWXnhdoNaV0uA/AWC/xEvpCx3XeH4+1oW4xx2SWD2YP2XcNt6ZsVqDM93abc6beUkbPiJ4/Dj5WdyV9RGoPtHPMj+Q2oDmUBi3ppwn1762yHqNB/oNePH+mKu/7mlhiGLhPbHayWbq+nfFEayvrXiPSRzX2pbDF48UncdOSlbQGY0mc8vWZdGYw9nDzvnG9sxtXZLKNpRvCFsz4p59kf/vN1wgyNvuMzd++7Ki8CQbM/fcTTdLKZWolAz/Xz8WQGpmz5UiRL60rWoPG6eypaDJnjy9tp+myzYZZakBEVVQJW2oS2rykUe5HGCZsCrF659jHHiT/l6dEk1Y7ke3614E3I0ptcupxbnM9na/9Ep0Ex2nOJDrendBHzJ0no8lpR3V05MK5NUx9OxfCvRfPKYBIOZFfOtn0U/0N4gGsR+MgsqCS0TsRXk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hsi82WSBPH+OL5/jrHbp61wSS3nRciGYg0SKRj9aGfVS1oMc0Z5/+J0U7T1h?=
 =?us-ascii?Q?7o0zUioOXAyaPFEGznM3PIn6g+RrD5MidLNBUgGtn4SOw/hcmy66IACNXy0H?=
 =?us-ascii?Q?7sABCQK2WnfgFS4aWZ0VwyLnqxL5uv5SRv4vrj8xPu8T2UdCm6lDeiT87oKA?=
 =?us-ascii?Q?yC6nhgiLS0HXsTzkD4TOnF3fwdNFDOOm934Ni+/wAAkDvfg0fGmOsBkTBQyb?=
 =?us-ascii?Q?Vn91K5D1CboudP65NOAVjk4llipUskcFhZ3YFptlcqSWQmxgPVcFhaFadqJQ?=
 =?us-ascii?Q?9ZWr2g7zPJDu4eOZ5bi+EQeEFo9vv0l08V36V1lNxMq5pqD6lWesPQdd+q9G?=
 =?us-ascii?Q?1KYm3fHsSrawaeKyfVgBVHhVf6WsuZnoeLMJN0dtJFFmPXXRfJBCg2Jb83dw?=
 =?us-ascii?Q?LmqtJvZnaIqtKUvJCVq+x7wq2CGk7kPpizw/MehW8/e/BKMK9rFtpyelPg1g?=
 =?us-ascii?Q?etvSQnKEcHHLNeqsCdHg2Xfaxrq/pX1b1P/DrWIomSuwpmBApemd3Qsh+Ql7?=
 =?us-ascii?Q?GD06wiQ9HpwFRBYzbdRVezKimo9f4MM/f8wO9Xwm/jojd6fvq/tgFUMXaxJ1?=
 =?us-ascii?Q?poDMduKyI2YoDk9A3kqQBrOU6X/cAWQppc+qZ5VCUanCLnwm2eITOhP2ddxd?=
 =?us-ascii?Q?vPo/ZtTexyYbA7mX7ugVTuVG14KrYgaulHvW+VOR0SseMPu2YXc2MbVsEh+y?=
 =?us-ascii?Q?lUJYVmKJMoQ0gpSAH5+juo4bRL5bkqw7zYGk0zWAjIw2cuvRIUrcHDvWtsA8?=
 =?us-ascii?Q?IB/BuHy7ImuWMQ6vDiQPLJi66BfDQDwUFlLFMJka53WaOkZYN6pSapg8To2H?=
 =?us-ascii?Q?aivuArAdeJEY7Qv07tAGKf35jOMMfUgnpvOq2iW+ohdTLR9TqHyqS2W4LnfH?=
 =?us-ascii?Q?3rC9lNqTLlmA9zq7W2utqX0j/ln35gMe/9TNZz2K9qLMB42Fh4GD5ZXi7n1O?=
 =?us-ascii?Q?Uh15jlYQPVkY/Mn/3yYTg6vHq7zqirx0rEPhofHCZ62ffZ/SDYklyeXneG+a?=
 =?us-ascii?Q?VlyOYKIrOPgAaJjDqhA2F/mWRjPGoNiTaz4zPqOL8MTTZqhKQN1Uf0P5yZjP?=
 =?us-ascii?Q?k3qFsho/p8tRHygIx4JRvuM9AnjTlvg9W+cRrNHaqJ/nuFaeyKXQs+a8w8nk?=
 =?us-ascii?Q?CMjMXx1/cS9Ol7fBE1CSOBhKv5pxjaOY5QWmbzHIgHAMHE8kLjH8mImKjqrD?=
 =?us-ascii?Q?WVT2fzK7Ma3BYX8Hx1JyvoInp7++7ralPsBlObeCE96sGHIis60xcs0QYHFQ?=
 =?us-ascii?Q?8LkkiN+/7lO+fA+jvFVR9UzfOHa1Q5m4kSsDc53vPAK2c4nIkY/9pBDqCDwr?=
 =?us-ascii?Q?gwmDg3eqLQGZJf2ophCx+VXbNpxt5+RZfWTHrDHpRH3AkDwCZnqw9Z1U8h1i?=
 =?us-ascii?Q?gZsFo73svfS3Cn9hsgIcdZAKl3LvuGbkHmoxtZ/kkDfsKIpmqOs7OaT9KMK8?=
 =?us-ascii?Q?LE093b61ZlgMJjbwZ9S+tRvIiEU4sG0intXoVwUg2Ip0ZWiunMiwbcHjPm8k?=
 =?us-ascii?Q?MzKGMB2l762lCygydXAxG/paVnqPZHAkag7E75Jv6n9cnlYXK2zGTPSfswFU?=
 =?us-ascii?Q?xpVb+uBgsqpR9qzUg2mTa9I7Xm5y0miWhL0SJI3K1envYvpOdOnb69MtATmR?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77fce30f-9344-4b05-cdbe-08da66ad8aa5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:16.9093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIuI+O6adgfjLUkm2LtR8CcO8hhmNUCtP9Gevo3GIHblwF8J6rTxemrkO6QxfxnQayVKgRGX5I0kQpGwWPPQ4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
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

