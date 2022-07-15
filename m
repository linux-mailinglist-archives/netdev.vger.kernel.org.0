Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC22E57696E
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiGOWDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiGOWCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:02:44 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50080.outbound.protection.outlook.com [40.107.5.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2047B8C764;
        Fri, 15 Jul 2022 15:01:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnfihahGVKsLZLAeZtd384envdsE3JJxvEp8QHm4QMMu9fhSBEsmzPP2RDxAPRVXuHyGV1DcfY9LHIKQeeWlgk/EH7RmRYhK9OZkm1Fsqr81ReLd82q+GJ4oZG6LYF5FfNx9g8eI7EX3iiUVzpO/scYGhH8DXaS2963E4ppfrRWWYHILe1V6rOozPaA3X5BMONcX5HCUftHmcsGwm6JEAgJWbcWDzd69oIJguqntsyWH/XggTEYVn6PYpr8PyfEQpP+6AT+Aggcz2HfZ8Vi970D7ZTweYr0+oVOOR3DCLrwB+kIvJRKLXMnz1UfRKrZtZPXioZM5LARFimMxSB2cTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olcQBbmzRcg1gnh3qf6bLgAGov4YUNKRcu6ttbNphqI=;
 b=MFluLrzQYWbefG87uK65RTjFj32gVIAuSWDk2Z5WQ9j7+OedVf73HGO1xxqoGUiLrBnynnZCq80viIWk7uwCaxlF4wlDNt1HdICSfcghzNOxrbGM0mVLYs5Iyp7kCMEqlBxg6TcPn0A5tJ94FHnB7VL8pszruPNvszP+tSLykVvHNlIuLQB6f1gtlDMAtNfyeAPX1orii5FgvqmtF2101Jx9W1gwZRwE7i46m/CiezPrv+xDFetJEwT93b+LunNht1dYvCP3CfnpRCl5LaPcGTJ9Y8005wde8V8WPsNlv5bq5VNM1bLLoC3NIp3od2cD+mMPcB9YBWzC2/T5zI2QSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olcQBbmzRcg1gnh3qf6bLgAGov4YUNKRcu6ttbNphqI=;
 b=kXY5ZjLbm7Nxvuzxgy97HnuPA0SRZ7qCBcM85DC08orPSgZBrckbcxgiPQhUJTQ4WFc6WEiPzlMAz6Gb/6VBgvqd66lomGDLNtddM0YjGFDrjphLCCfbBZqnsPO7OrhJ1FjHVnZVrOIKw/LpF66szgdgigpNpAcGWtHPThLk57GFTYo4XVtYkSi+iOTXvCq9pwUw7anGYAgV7KnRxL/xWE28rbBFWKmXQ3aSZ9EEuemf8RTQYz5C4P8ynYLry/RJDCjgp6zfTagN0QuQBZ1n8vtPldrcquWdH+PaqtCeNCVXX+snUNVrACcKSYEBNcOae/BpLx+nGtD8sIv1qoO0bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by GV2PR03MB8607.eurprd03.prod.outlook.com (2603:10a6:150:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:00:57 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:57 +0000
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
Subject: [PATCH net-next v3 19/47] net: fman: Get PCS node in per-mac init
Date:   Fri, 15 Jul 2022 17:59:26 -0400
Message-Id: <20220715215954.1449214-20-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 01a67b91-6fca-485a-ec0e-08da66ad7f1b
X-MS-TrafficTypeDiagnostic: GV2PR03MB8607:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jXc4W+h0Yn9UCZZJnnyOK8T4APth8WzFiqk3tMA+segV0/lI8RpsdlM9imVAElX7LS62oqujqjwDYla+2DNp9d2N4lSkgsAmGSfgyEBGoygSQ+gbCwchkJPP5HO6GyFGQclFKdpLdpUsqAlw22N5qZ7uFaYa750pJ80hekjLM7JG2CHwq8anlJsp4dK0ZKUfhdpd93i1VREqtz4aTWA8S3GstHANdfq79HOuJtjfrLEhbIz+RQvIXu5fPMoOM7sarBkSqDxxvx5yW1DLND692tycvVcaSgqOC2MVdXpVMssmBDIOCk0NTQSmSEunc9U4JRuLj3U0VYZsywhZgPliwYhsrucAOZRL1DtutaYEUdNZgKyu021mJ0V6bEY0VlAfCc3wmyrckpGfsQaUbn/0XaEZsYjXKLaJlzIjvRm9zwsnmQ4JQjRBkwJ5Mvildz34R3Nh3Oyzu4qyVArzTTh+tYvxdaLz/yxIdFQWRsQfbI3UR2Z57+uGHlr7SeEf2tRUPGl0u2a50qtuH1piA2lmGxHZtgA/wKv/pqx3+Z1KRwuwNG2qnndEmhRgH+ApXNyeBxGP9fmRBr54WiL2VJEttnNdJW8u7mH1FQyah+EtUJzYDWAjYNRAobd3GQ82VByLmzy8kWxYazTfPzia6d2f85GeUpyIWhw5BnMVADiYS2Np4DWcgt4Ufa2e0v/fymVhfjVLeKEJL2XMG/3c7i5LjXG0eRLFkOe8g2mEkZmi0Sp6dqmxIKbjmdgifjQyR72pogzlNJarhl+dk2RSKCPJsVt6WdWsRSS8Lpx6tqYyYce0GgKsw71bbdJSjhxeNYM+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39850400004)(376002)(346002)(186003)(38350700002)(66556008)(83380400001)(38100700002)(66946007)(110136005)(316002)(66476007)(36756003)(8676002)(4326008)(1076003)(2616005)(8936002)(86362001)(44832011)(6486002)(478600001)(6506007)(52116002)(107886003)(6666004)(41300700001)(5660300002)(54906003)(6512007)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BHoGofft4MwwswWPia0OQzgIvAABhS2KJO3lFl1rZw68dSD7GlBbDhXrzzsb?=
 =?us-ascii?Q?8xSfoo9suCs+4S/50XGMGMffsEc8Vhi1v+Xpx51ue9bH68lqvxCIrrtPEJ0J?=
 =?us-ascii?Q?HV1/AhfPrTdVu7rkmGC9uBrNxXWnz5gaVHPBj5jdwDzStqMSN1hDxh7+Vnab?=
 =?us-ascii?Q?reRYB+GQNcW3Iv9/1B3LVYTrFTVO/4WtvmqQxL+/lQZX+uFOwrmoWHEH+IMI?=
 =?us-ascii?Q?L2o0Hv7RrM6A++2724ZIgLdPzOOjjc4+ZrYHunm2cI9ViSzl4R91MECB7P3m?=
 =?us-ascii?Q?PTWFeyqUy1W3WA5OK0HDdFObXMI7c9PP4ndbgt5/V+nexd2bkb9Y6MfE26Gh?=
 =?us-ascii?Q?0Qd8bVrSg/SGZ7gvBaatipxobtdm+hWG/ADTNIYV/hzGaye1hnrQtD+t1Unk?=
 =?us-ascii?Q?HvV5dDSXtSUimW5f1BiDBgHvfHvlR1UVBfhMkJ9eZ+vC3CxmA3BEEhJEv0aX?=
 =?us-ascii?Q?n8Z/gBUoSWc04qNVKmiUvMVVtMq7bCmxJrSFqu3VfNH3g/d8wmqphu67+nAl?=
 =?us-ascii?Q?6pkxVIh6olPbD4C1j4b4v++INiVKBrGAbdBrCYtkKzlFniSc06wk7o2DWi+j?=
 =?us-ascii?Q?/38XEZeJOMp6g79AVVc0120U4ONzWN1kpw5BRTND+7+4AzcurYYjuRUR9QMs?=
 =?us-ascii?Q?InktqAUtRGXr6sbsEwEeSQTApRa8VN1bzRIiWLlo8934x9prPJsE1MNx22zt?=
 =?us-ascii?Q?hDyG/RXqa4P1gKpftDVRtUM3f43iK/8hZHdT41utaO9FdPzuRuY8MJS6Xxjt?=
 =?us-ascii?Q?bxGM5kWbwpStWqncmmNI1+KenNz/zUzcpFKB167CkAa+R6ZVzf+GVwGrLUYh?=
 =?us-ascii?Q?Kp3F8/QaLPWfZ55FiMWfwPAUISkuNbXtbcloSLSVFrv18ZAECAlcujCWkXY5?=
 =?us-ascii?Q?itXcQqbXiSfNO7fIFd9SwxeHYdMR7UojPQ9jiN4UZk7dQVzQr+iNJ3eqihMJ?=
 =?us-ascii?Q?rd4jFYIBVR9jOWw/nKHVTyax6XMB2D3b7EGFMKfTpYn57oRrMw424XYSrsUy?=
 =?us-ascii?Q?amFBM1gKw/1+UqtyUqP99RD2nRxPwoV92TpIzemlsVoO0rhDgoahKoGqj97u?=
 =?us-ascii?Q?7KfSaRKmTJPajHP7XOKZTFP994JSUFyI3bTUN81zoJkz7Cwv1pbB6IN4M+oJ?=
 =?us-ascii?Q?6N7xqjILLXetQN3huLiRE2yt11G243lCJj1HU65EEQIk4kG27cRKsg5Do9gv?=
 =?us-ascii?Q?ZjiunnL8OIKc6wVXVVEVt2yD9GSVKGAnEMekC7cjOkIyOdL4RkJlNwhziAkI?=
 =?us-ascii?Q?rQAsQnBNhnQtGug/tarTjW2tQg6WhXBj534XzAO+rZMQXmwkvWPC1Xe4PdB+?=
 =?us-ascii?Q?m8NXd7pekvpzOwiItJLE8qzUfmBDoU8khuakuikc/osST8XffM81BpDY24yr?=
 =?us-ascii?Q?OjgE6Ry43gnoZODl0TJlxzH1BU1tBQPyEtjh8+QlQN5oFSkhaiCqf+XNORcr?=
 =?us-ascii?Q?9b4L7wPdzjIBYzZSotvg0HcXhcJ0I2LStDBZOavs8nBMhpMmQpGhDZRNAoYz?=
 =?us-ascii?Q?LPXRmjmFtATDvmlkcewTK33zL5zvGHSzKK7My/Edi0OOShQzHYDZpJlDfgwQ?=
 =?us-ascii?Q?sQQ8fUUSaTJmeyFm7dBz/Zea/bbHAZudU7zFJXWxI7Y0GB32D4GUNbmFi6BZ?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a67b91-6fca-485a-ec0e-08da66ad7f1b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:57.5195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mg2fpactM/yv81ac8BZwFpc9Wl9Gn7uHhAZ2XpmBnmV7eoAfkY5UAG/GbDg4MRQ+qmvOV0uymLeEKr1oLSN0EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8607
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves the reading of the PCS property out of the generic probe and
into the mac-specific initialization function. This reduces the
mac-specific jobs done in the top-level probe function.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 19 +++++++++----------
 drivers/net/ethernet/freescale/fman/mac.h |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 6a4eaca83700..0af6f6c49284 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -32,7 +32,6 @@ struct mac_priv_s {
 	void __iomem			*vaddr;
 	u8				cell_index;
 	struct fman			*fman;
-	struct device_node		*internal_phy_node;
 	/* List of multicast addresses */
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
@@ -85,12 +84,12 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	params->exception_cb	= mac_exception;
 	params->event_cb	= mac_exception;
 	params->dev_id		= mac_dev;
-	params->internal_phy_node = priv->internal_phy_node;
 
 	return 0;
 }
 
-static int tgec_initialization(struct mac_device *mac_dev)
+static int tgec_initialization(struct mac_device *mac_dev,
+			       struct device_node *mac_node)
 {
 	int err;
 	struct mac_priv_s	*priv;
@@ -138,7 +137,8 @@ static int tgec_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int dtsec_initialization(struct mac_device *mac_dev)
+static int dtsec_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
 {
 	int			err;
 	struct mac_priv_s	*priv;
@@ -150,6 +150,7 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -190,7 +191,8 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int memac_initialization(struct mac_device *mac_dev)
+static int memac_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
 {
 	int			 err;
 	struct mac_priv_s	*priv;
@@ -201,6 +203,7 @@ static int memac_initialization(struct mac_device *mac_dev)
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
 	if (priv->max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
@@ -583,14 +586,10 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
 		setup_dtsec(mac_dev);
-		priv->internal_phy_node = of_parse_phandle(mac_node,
-							  "tbi-handle", 0);
 	} else if (of_device_is_compatible(mac_node, "fsl,fman-xgec")) {
 		setup_tgec(mac_dev);
 	} else if (of_device_is_compatible(mac_node, "fsl,fman-memac")) {
 		setup_memac(mac_dev);
-		priv->internal_phy_node = of_parse_phandle(mac_node,
-							  "pcsphy-handle", 0);
 	} else {
 		dev_err(dev, "MAC node (%pOF) contains unsupported MAC\n",
 			mac_node);
@@ -783,7 +782,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		put_device(&phy->mdio.dev);
 	}
 
-	err = mac_dev->init(mac_dev);
+	err = mac_dev->init(mac_dev, mac_node);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 95f67b4efb61..e4329c7d5001 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -35,7 +35,7 @@ struct mac_device {
 	bool promisc;
 	bool allmulti;
 
-	int (*init)(struct mac_device *mac_dev);
+	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
 	int (*enable)(struct fman_mac *mac_dev);
 	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
-- 
2.35.1.1320.gc452695387.dirty

