Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C322254FECF
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379637AbiFQUfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356081AbiFQUeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:15 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617735D676;
        Fri, 17 Jun 2022 13:33:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2KNiFBS9SQ7Jyf33GTWDOOwekmUM2rFt0nUPOMssDmIIliybH47dFbjw1LPN5LQ6psFFbZ7/rlp+Bobgno5Y1N9qFqG+xac45l4j4oXpSPwbdXUeM54B5f7vjGZ7JoVFV56ZHD0JUXxralVl7+mDBSejQoYwiATxMK9/wkAjcsYrW2nuMRitAQrTyxH8xuiMHKfjLCAsYb7kcyD0/XWRbBZR8ttP0eoORDojQCr6Q6IX3Y65IRBJx4X8F7r8lBuuz9kwfEfLNE6+Qt6MedjFu6g6+mLasW0BJGqsLtMYLoupycl7gVaYhSTCUU4Vs7xdQ1BiYl2A/9BTCGEux4ZKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGPoE0ZuRIWNg0pvFE6/rEZ/y8FkBn8rniXNIJMzabI=;
 b=C9EhyqiKy9F88O4XwcBD5Ck9kzIHm1rL+JAMZ/we5dpF/XEOCXJv3GU7bOZFmOtzE79Dcd1YHPE8NBQkismXVs1x6cE+lfFexOGOiECp+Ghr7j56ohxlVvZvQZXqYkPISw5CK8by4epoGTq4ivS/09D685z618brBoRlnMV9o7TjX922ylpH+Ht8BupWpcZydf/gMpLCreudy5QyoLO/J05K3kQmL4gvQGsGKK2VuxnZY3jMnXOGBUyn9EfEfwvMgiQlZtOGw/q1QEIOPyLF4s+HamhwhHCqxiEautFBcjsSjpn5oB52ulcnLq++IsgXBnZ280wfKoNz6XmRKj3XlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGPoE0ZuRIWNg0pvFE6/rEZ/y8FkBn8rniXNIJMzabI=;
 b=mL27pm4W0A/GAfdSHYVzUAcAp50q6tt2ntePC2KKe+Sok3epG0kPJsvT3rQwEC9r5Jh8FYhsiJsQwV8wFugHev07V4dvT5yBW/lrKbQc8FQSkFXqLkCvvH3d7+SIdFmZ4h/xF/TRv5PX3kqBpJ6fpSfencWT8OehbD9sXZ/r/YrDD+XO3W3rd0wxqpBGtNvJ/mE+a8CVkdmjQN+NiYOKW2CgU8mdjbF9KjSXZqpYXWwSP3jU6Sik7Yohs4AhSiuwA8pvYlMqd/DEdvJt544ZIzXMYpeG62B59MIjTdbLfJWkXDEvpzI7FLAoBhS/AFHD0mTZUkZYZ4rOpsewz8xa9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:51 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:51 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 08/28] net: fman: Get PCS node in per-mac init
Date:   Fri, 17 Jun 2022 16:32:52 -0400
Message-Id: <20220617203312.3799646-9-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: db14e03c-669b-477e-2278-08da50a0b057
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB6438BC6E6E376A1F02EF0E4696AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3dFYbxIm9uIvcnam1vIMkJfLs9T1tPbYSU3LQUuLe5yowO8WTt1g2zAldK4Z2AKe4GoWCJtwAXseU+HxPV61auh/VgccLuQ0I2fQ3QCAtGzLYL/QyJ6cYNfB5my/GMlB69XeO00WREHToIuremBXApzElI/SeYfZMHQzZjOxjNVs2fNc1yb+T2sn1hsKVNr+pqm9DnZyirfUNW93D0v8mLDWT1XGT1sjdm3bj52bjRlHNXeoq3Z4Hb1/btPnjkX0GOxnnfZ4JkreRmlEqghydELFb6xZWEpcM1GiA0TyC3NSMPIg79KBLpjJsqH/yKEebaPRsBY6YwQ9qBOnHwEIEwx/aZqFl092NlJgyjnPTgI+JOkwsMqIs21ofFNEoNTCMQc1xdfPU6jTJdZBcjfLoH9EH/38rXgYarW3lX7OoWZRduSqC9Q0x9hOe4GZlkjDPKA9uFOUT6gNpTz3cwaWO3IvkPriGhoC1AJnx39LzrDHKlzVLTS/qJHg6QQQ6RW6wt3ExGW/K8YLIJ+QE3yds3BbcoIThyUr+cFYJw01IomSE36G991wPL1o1BJZR1v5oiXs5ElShVPG3qUCUXYS3+H3ENpAT1j+xfe1KxNgJOhk5vB1mtX2KDVf/rJZvOe7pcIhz0kS9xnnx+iVcbgpxEU7wakbKYcgvUAoNv7DQwJczaju9MYiD30k1l9QfuZqhRo/haprtfaVXYvNN3wbSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(54906003)(498600001)(8936002)(110136005)(6486002)(52116002)(2906002)(6506007)(4326008)(26005)(83380400001)(66476007)(66556008)(8676002)(316002)(1076003)(36756003)(66946007)(38100700002)(107886003)(38350700002)(44832011)(86362001)(2616005)(5660300002)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rtjqX6JrV5dtBhEOYkrzR/15AIL8ByKOQ2WZ3cdu+JJrTA+wALd6lv1+Fp7a?=
 =?us-ascii?Q?/eWAVF2l2FtVpWNwr2Ah92caA2xpgpdpL38ENHL46GXQ4XLCZt2pPvbh8aFZ?=
 =?us-ascii?Q?7odDfAlQvyMR7DHZILHQyQaw7QjDvI+uZdRnsSR1Efa9oo/w17f/D+mDBn0r?=
 =?us-ascii?Q?9raB8q1qcHOtd/mjrx30bZ92ni3ILSKKccYabPNNtOdSZo5NKVVrsda4JOPK?=
 =?us-ascii?Q?VLFCOExpalWqrf2J59QoqCJFQq3hyGPXYzuhrsLvDwnJ/1VgSfdvU+0lw0sz?=
 =?us-ascii?Q?8OklLpHWFIhocOi2p27WPo+ywRTQXREoVhMWMcnVTEeuMpgZmD82Wusl46xI?=
 =?us-ascii?Q?GI3o/OYMICRJwHp8rOaQaHSC0shtVX6t2IKl0f8ipq9CCWEh7AwnvVf+hqgM?=
 =?us-ascii?Q?gPzZhhkJcldrhpPttB+Ncbjyu8VB5wdj0wLeL1GawlImm3npgMKVBlY9J/cy?=
 =?us-ascii?Q?z9lr2vSxyySd2bwj3kVWiLS0ZtV8U8HIJZ/KIL9V6pr62cROIhHCaUT8YDBK?=
 =?us-ascii?Q?Jgsa7qZA2MeEzCYeZA++mnfooM7PAE+mANIdDtpN8gkfuQvnKAO5xvfYCfwC?=
 =?us-ascii?Q?hqyr/UkQ1o5bPXl/qse7vbuR7Jl+jhux53v51j0Jc6eyh/N5xHhxUkXgIiF0?=
 =?us-ascii?Q?VQCQsVs3lRSC+wt0hvJbB77kB+hsRd3zKUPLGrvoW4mMtuWNgQZvokmuiKEw?=
 =?us-ascii?Q?Er7pJA3EW9Bf8Cr5ptEYTSgQ7jBw+MCbLks5jFEOMND4Ca/nFor9UXcBzDj0?=
 =?us-ascii?Q?q+nAe/ywyG7epiOt2f36DaNayAcJfaQPSNbM1b8F2rTUDXQ9m/bb4mPOtr7m?=
 =?us-ascii?Q?xxdC70UK/VPysJYO2WqO8fbV0bFcRKA1y3TqZ51TdIQMGOOhLcrZ1Oi1lFdY?=
 =?us-ascii?Q?IAwOy79Xy+x2qJk0yxU1/NDB+pjnu6iOfUwOMa8prjdpt6usj5UTEEIQ94dl?=
 =?us-ascii?Q?so24pCRENyeCWqeawOhg5dai5AjNCiA8+yuLbIw9oQEea+sPEtKKKLErk86c?=
 =?us-ascii?Q?R1BYzI6hgXRyW3/6VCiiBfKFHBq7n8+L7ApaODs9WJeN40c+pzKAZOF8w/lW?=
 =?us-ascii?Q?26/NaduHorXyW+cW6MVRD1DcJmtsL0wRZ9RzBjd6q8ONhZaCQ7Vds71M4BJu?=
 =?us-ascii?Q?KT1DWgrfTK/W0OZSrh2EPRTzmeH7qacydbqcbQ50PpH7gQs9eiWc4lRnPy/o?=
 =?us-ascii?Q?zgS6RSXk5FfHrCBfDAqa7ekncV0mjd0RNVHeMl271KZjJH/lOfbKRX9aEF+o?=
 =?us-ascii?Q?RZV44pypT4Ouiw495/EW/DlYRD7CJhIzQCMqyH/h4JrSgVjnR1EoL5GQ0fDx?=
 =?us-ascii?Q?MgIMqP5uN6meRJvJhOy1/0vVbh42VcPI2vj+ce1Zr/o7xTrTS//AbfLlclxF?=
 =?us-ascii?Q?9sKNAL+P1ZBUwH6sCE+SUv/xborkf+2yKZcUkHWZo1ADpT/YwP0KM1sMO1qn?=
 =?us-ascii?Q?+csLgQAWJAo+z2LMtLllucdBYIR/vKNQ9i7KjQ6phc7LlTHQfiuEt+8K/g+r?=
 =?us-ascii?Q?n8hWMj64uRE6izhJTqpq7AgAWCdVf4WkgwCllElAuuHGYvo8HFefL9VD5Xf3?=
 =?us-ascii?Q?GQ3uGwBIWqBvOmHdzoTIgnTnKyT4WqZWZDF7emtdek6vM/QCWvv//klBi5tg?=
 =?us-ascii?Q?V8/iaJlVKJPZYL9GWASb1Ar2tvl1I3rGMJip49wsGqWCh8vV4g3VzGuL/2QB?=
 =?us-ascii?Q?+xerA65QltmjLs8/uKJieihdqG+IcxUa/07nh0ileDel0+rTuO5h/ORXaNnI?=
 =?us-ascii?Q?GlDqCrnszGkF//Mj5sEBvFOm95+BQqs=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db14e03c-669b-477e-2278-08da50a0b057
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:51.1398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUUQMJOE9ZM9BhU00PLt7VnulgQnOMsX912rfOdlfHgFvtK9HruphK/a7rWE+v+v0oD4g6ohTCJVtMQlCvzAbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

