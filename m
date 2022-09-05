Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9449E5AD469
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbiIEN7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238069AbiIEN7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:59:16 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2057.outbound.protection.outlook.com [40.107.104.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A405A2C1
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 06:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZMDVcyZ8ZR5LTnBP5tJAYeQYzrLlBlcaCuiK4DzDf2K2HMZyJghBkRr1JDwRgT3CrkagY8wLfhjwk9xY6D2OvCWdjrT2v84UpQfk9d+pAD9p3ZyqD/G9JQZxBu+Qz/c49eMnrwQ++OM+3myHU9oyE8+51z+wH2twhCxzl5UAoIizbQdstjDbZ0N7kAc98Mzv6RJ5F5ADBswYTi9NS1afJk+jXN2PkWwXPTuVSbpQgsPwG04BcOtqVmMr4l1Mk+HtuT/+AlCCC/25U4hO2JjL5XRJFdovcs/Sk3oyHyPYz7cnAUFg/v9k7Ews9d+7cNREssxeNfy2vFvtxpmQDMD5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qc3Dci0whyWID32rvt7mYjdVEEH7KtoiXxdIzF0iwMs=;
 b=fKpA90Rpqy31/KYVhvgvb6yqO0HaTTN7ouEEaonEgelG2hsd16snwIwEhxRWqJmvP1BZ+0w43sQ2sNAj813va2TzLCD/y2zvAqHbIZSQhM/TrO9r2z0nB4Ckgt+rEDG493AHUQSD9RzqyZ732kMz/NslAbpNExSfQenmeaO6HAkCrd5Ye2kFWe8pgOsm/YV2iLMHgYH7HZpHkyB2/K+XVgbrLqNvnt881NLbK0Ebz6dEK3zLszUs+ijxEHLOtZubkam6SQLiVqqZ6GCpWkIFgSYfur7LQz3bAip0tcBzSGVDMf+tA25e2xW1c+SuoMYyRPKrSF8QQooyT/M+mTFEgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qc3Dci0whyWID32rvt7mYjdVEEH7KtoiXxdIzF0iwMs=;
 b=OSYQp0XSX0F3pxxvRpWrvEejKcfWRnwkqxsdDamInl3Ieol0vZJBomy/YqHpQ6OQECG+DZyIw3hn+Ot/IJjxciU4tMHADoSgYdbW7KUMA3B0sSsIBdWUycrJ+oxF2Zzf1jcdUumUG01YS8QDTQuHhF2dZYYOPX6FfHPc45+gYdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM0PR04MB4354.eurprd04.prod.outlook.com (2603:10a6:208:57::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 13:59:05 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::b9df:164b:d457:e8c0]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::b9df:164b:d457:e8c0%4]) with mapi id 15.20.5588.018; Mon, 5 Sep 2022
 13:59:05 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] net: phy: aquantia: wait for the suspend/resume operations to finish
Date:   Mon,  5 Sep 2022 16:58:33 +0300
Message-Id: <20220905135833.1247547-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0143.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::10) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d1d32a8-8879-4fa3-85b9-08da8f46cb3e
X-MS-TrafficTypeDiagnostic: AM0PR04MB4354:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: atOVHT2nBWRclYEq5wMXbYdAqXMZ3CxxELkbvfka5cIx0sobS63ubZuuRK8OeY+T9wS4aYdYXgEsqfT9YxREQWNRnbHJKMb+pqqhIYeAN1efae35XgSmNkMlEUgooxJWBGveqgeG9Osy0gjwUb10z+JiJJbp7c+TLZc7r3O8jOBhfzMwnEtG9f4FJ12cvKmLkUJnxsbnI2AnQGsNGlba51/riIMz+9ImTXhLlwbEyKlJQKAzE2LjEDfExnDzYIzRKQ6wnuZRbO82g041NJhh/wqTumjsUdUhpwVWsd0loFb2YgAAzJ7qD8Amg0joCwPIrx8a37sYd6BEYLUyhrUzPxBzmYXfWHMyitZaQUNCQMcSRFS/YcOpHpMlKANKUybigHPQeIdiTybKcP06Qk36x8+9mmC4kV9D11YUen/u3tl4Yge4bYp98r3NxkAbmLcnDihuJaTGItQUyGx89bWLful2WokHD3uEPVlawOJkEK7pcgg3HIHSW6yWTKrZ+C4CWNFtjd6j1slEurnUB7yXv3ZUcE9zJWVa9rhEcKtUfj3iKvTdUP32ejgy5HGj3q7qOp+AUNNjYShjECg5PuUyP7JZctIACMTXT8ycxhU9SYm3mdW4qWjrLKhmdeeHj3vkBHzR/721XWDrdv3Hp1wwxcUcb2pLYnZOzXjTkV1KXILJvnaEVssvl+eItDY9kcYWYChPN3Gyk+1uyjFgZwk1YaF8agBRCRgHtNI2PNoPJ4UZavK2GOwIgM1o6e8I9Q+DJc9arsbpVHLc3bPIEhEqLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(6506007)(26005)(52116002)(5660300002)(186003)(1076003)(2616005)(8936002)(44832011)(6512007)(2906002)(86362001)(36756003)(6486002)(6666004)(41300700001)(478600001)(8676002)(4326008)(66476007)(66556008)(15650500001)(66946007)(316002)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HZivLV0zjA9HOExicXZ7IiQNWdIDvEfrKIT7pdMYSbwV4asWMJnllsUh0Z1s?=
 =?us-ascii?Q?DzjMe6P863qDQ0KTgKAterzjpn1idGtbQCgtHqRgcEVVFD5TGWIsG/o9wvOn?=
 =?us-ascii?Q?OgCp/D70ObB3sXaErHaWhMDCiXCalo8wknPLNLqWA6Ou/lyE/qazEx0/HiO/?=
 =?us-ascii?Q?sIG0twCIyUPoRBFRXZFG+63+3/p9epRkKHhZcvAuWR3buORI7gj/thAmO9JV?=
 =?us-ascii?Q?opIJu3h+UIKr4/t99ZHcEZV77fMsV0MwPRGk+DONHJ93GN/lJrv8Uj/u5b06?=
 =?us-ascii?Q?cH0NZpslrWFEGY0ljM7Gb2t+AWf3FJ59CrLM5Q5eOFYomoT++3qr/SiQ0nzu?=
 =?us-ascii?Q?OklIYSo6crNFEEvuEF8904IA6CVfsVmzl/iV8D48WclbOxz7xdtQB+kx0fWo?=
 =?us-ascii?Q?2iyRajs5qqxt5sGgzo8BVesydpUeL5tZsL2cOIyt8uT0G7o2XTM1mPR/i/vu?=
 =?us-ascii?Q?zG4/0cp6ug1E7d5bEQq8DqytBwkaGcUVPvTipkbIzstliTbV0ssdXiZAvftZ?=
 =?us-ascii?Q?fmNkZf9u7oc71R1Kz0sc8m8Pf1CA81UXE/Xjn6LWj/AceO8F1QbInExP5X5o?=
 =?us-ascii?Q?f64mi6x1P3TuqLzyYfrWPbkAEjWRJmiTaTNLk82MvBiiLKoLOFM0c5XM3T98?=
 =?us-ascii?Q?35cMkgxaKsjKIzRgEzVbEiLNEHmWiO8qJBVoTVfUfmXW4l/6KXvj5tOcr8Mq?=
 =?us-ascii?Q?2AMqRhaPwFkLRYX7tgY2rN4cfB22BDyyRMQxr+0/XwnGo0RtlQrOaJrhuICQ?=
 =?us-ascii?Q?cCUeULOJ4LeCBN+mbhYkShh/Y5/xNHCH6bKS8P5WZO/CSxkw2A+NMJ+tDbZI?=
 =?us-ascii?Q?j/v/zrPFAIOixK6uHfpqPQ4GH74pLqweBYnYblBlTtaj9+XZD7O3cbERq91D?=
 =?us-ascii?Q?LjY04K2gSR/NCCFjgL3CPNY413cJxdqg6tZFGq4HHGSjasXAgcaYVE7O0Czl?=
 =?us-ascii?Q?PTskyZgTkjSiNrG22nRmwT62jLygAKgPyTDLrxwcr/3sp7VGGa0uS3IZPpJ/?=
 =?us-ascii?Q?CdANgr+PsSUqI3k87qY0lUOVFPIF/0h77nONYE1+vMyxxL2VjtJ7WqQWV1S1?=
 =?us-ascii?Q?HeQpEUz10R2g6cX4ICWfXcmdBd8QsNm5rH8XIfAfyEt33ojPh858g8t+SnKP?=
 =?us-ascii?Q?3P/1BG5ujH9PRHvqQcDq9TPTzoeahzUnGtWHGZ2obitDJe08Un5OMshEgEb0?=
 =?us-ascii?Q?WG0BTR3/gw2aujZxhr/Je7rwf1fBgUS7V0EiC9OtTHbNSn8xQXI1OWZPv03U?=
 =?us-ascii?Q?f4I2BgZIeQqXqz/AhLFJEDNeMSX1wlvc2XtvVavnIjz0RQfqcx2hw+9PCqpF?=
 =?us-ascii?Q?/RZJYTkrT8NoPSy2FnN3OYatw/V7MKlRNkMzCTeDcdDaIAFqIJnpgCqMT4/m?=
 =?us-ascii?Q?sw7FFnqg/AauT+6NKNZkdlVP1FOh9nh1rwJ263x21uJ9F5SQhBN4b4G2P8LG?=
 =?us-ascii?Q?cktJBBc8ytUV+I1diejr/2G2aElqeMYA8I9xJ/IhExPns6cqt8QPh8dcUDJf?=
 =?us-ascii?Q?g1zFM2QeAHyJVBb/pCJAo4lqF5vvOl5467SnOoyQGseKC03UdBs1CH1y2+mj?=
 =?us-ascii?Q?OlP8mb/SX1LbFlAZAehqf8yFFrVcYE+MGY6blIfrjdimWWH94QRw0jRbrnYB?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1d32a8-8879-4fa3-85b9-08da8f46cb3e
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 13:59:04.9513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8V60kiRhEpddPj5SQ4dHaa6LbSy2VvW0iO2RVHrtBN2/hBWqQCIsgDBb3yY818FSHEPhWxBvVp6tPFTgQbNvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4354
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Aquantia datasheet notes that after issuing a Processor-Intensive
MDIO operation, like changing the low-power state of the device, the
driver should wait for the operation to finish before issuing a new MDIO
command.

The new aqr107_wait_processor_intensive_op() function is added which can
be used after these kind of MDIO operations. At the moment, we are only
adding it at the end of the suspend/resume calls.

The issue was identified on a board featuring the AQR113C PHY, on
which commands like 'ip link (..) up / down' issued without any delays
between them would render the link on the PHY to remain down.
The issue was easy to reproduce with a one-liner:
 $ ip link set dev ethX down; ip link set dev ethX up; \
 ip link set dev ethX down; ip link set dev ethX up;

Fixes: ac9e81c230eb ("net: phy: aquantia: add suspend / resume callbacks for AQR107 family")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/aquantia_main.c | 56 ++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 8b7a46db30e0..8537ce58a597 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -91,6 +91,9 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+#define VEND1_GLOBAL_GEN_STAT2			0xc831
+#define VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG	BIT(15)
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -125,6 +128,12 @@
 #define VEND1_GLOBAL_INT_VEND_MASK_GLOBAL2	BIT(1)
 #define VEND1_GLOBAL_INT_VEND_MASK_GLOBAL3	BIT(0)
 
+/* Sleep and timeout for checking if the Processor-Intensive
+ * MDIO operation is finished
+ */
+#define AQR107_OP_IN_PROG_SLEEP		100
+#define AQR107_OP_IN_PROG_TIMEOUT	50000
+
 struct aqr107_hw_stat {
 	const char *name;
 	int reg;
@@ -597,16 +606,55 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static int aqr107_read_vend1_gen_stat2(struct phy_device *phydev)
+{
+	return phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_GLOBAL_GEN_STAT2);
+}
+
+static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
+{
+	int val, err;
+
+	/* The datasheet notes to wait at least 1ms after issuing a
+	 * processor intensive operation before checking.
+	 * We cannot use the 'sleep_before_read' parameter of read_poll_timeout
+	 * because that just determines the maximum time slept, not the minimum.
+	 */
+	usleep_range(1000, 5000);
+
+	err = readx_poll_timeout(aqr107_read_vend1_gen_stat2, phydev,
+				 val, !(val & VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG),
+				 AQR107_OP_IN_PROG_SLEEP, AQR107_OP_IN_PROG_TIMEOUT);
+	if (err) {
+		phydev_err(phydev, "timeout: processor-intensive MDIO operation\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
-				MDIO_CTRL1_LPOWER);
+	int err;
+
+	err = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
+			       MDIO_CTRL1_LPOWER);
+	if (err)
+		return err;
+
+	return aqr107_wait_processor_intensive_op(phydev);
 }
 
 static int aqr107_resume(struct phy_device *phydev)
 {
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
-				  MDIO_CTRL1_LPOWER);
+	int err;
+
+	err = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
+				 MDIO_CTRL1_LPOWER);
+	if (err)
+		return err;
+
+	return aqr107_wait_processor_intensive_op(phydev);
 }
 
 static int aqr107_probe(struct phy_device *phydev)
-- 
2.33.1

