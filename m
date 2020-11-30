Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AF92C82DD
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 12:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgK3LHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 06:07:03 -0500
Received: from mail-eopbgr30136.outbound.protection.outlook.com ([40.107.3.136]:7771
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbgK3LHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 06:07:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIlVrFiUY7HY/pdZOd8lADotpjMIGAGML2Q2E2znlNIeGN8wgw6QZrIDdztipvBJrzYEmQtVwEZ0zo0Vg+53ht0Q2KAlf8wpGuj0LHxZaakuos4WZCfh+7H+AE8ZW429lT9iLIg/r6Ee3hEYDsDYuag9DJ7cZJ5R2mbrsMXTHy9ModLbMy0PzTtXnTkRk/LF9SiaYsYgb3fdpaPHX6qzskxH4gVSBMr4CHm60MZDAfHmvXwNolwcJeXDuYeL97iBxYoYwl0MEeRUUJ159vCdJaSFj0mOzBv1vMN3TwPZiGlQqCJO+/duQLw2frTMG0SemrktaYIaDF7/rs2Glf27jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUaJY7H2/xYjdqK7u0vsVk948Vdpp6mlyRYfIXVtwhs=;
 b=bFqxq3rOVEansJa/ZQ/gX9FI1yxhJTnE2jweivyCqP1hR5FNLIdplj6D3wc4kiSvRQ7lTBKqeUEsQEBYfVeHA4oYXYzhygnFU/1nCHWcEXxXe5n2/CerTWSyGoWyJ0AiN3j5Xg1mx3/0ejvjpV3vtadnGUvdFhBPFfS3ZP2NRHWcwqd/U2mQcNfv+n8Zcf78wMIHSy3KJPYc+2jxHB/4U7ha7TiYiwianmfhuHSbANiNCVfFq23gl+rF07U9kvA8yzAWGXyF7yBuJyMxGAKVljMMVvZsQG3dzTLPM4MdDFNkMsyNPmuJOA2XX9yAZ+1LA7k6VhIU2PWnMhRd+L6MoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUaJY7H2/xYjdqK7u0vsVk948Vdpp6mlyRYfIXVtwhs=;
 b=bkaGmmrUbEX+GV8L0uWMSbguUTbeDT9MKVpqU+zUzqFiwpmA/6pIo3yphzZYvw1SjN+6XJiKA9cy1vLEBKxNp6S2bSlSFtEqFwxx+HfrvNPh1DMWdRkOj1T2mPvKPqy1TY6oSAJ2/B1HyrbJqCpz9Yc7qXGLqYrk7cR+o86rW6g=
Authentication-Results: effinnov.com; dkim=none (message not signed)
 header.d=none;effinnov.com; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM9PR10MB4402.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Mon, 30 Nov
 2020 11:06:12 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9d5:953d:42a3:f862]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9d5:953d:42a3:f862%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 11:06:12 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Charles Gorand <charles.gorand@effinnov.com>,
        =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH] NFC: nxp-nci: Make firmware GPIO pin optional
Date:   Mon, 30 Nov 2020 12:04:42 +0100
Message-Id: <20201130110447.16891-1-frieder.schrempf@kontron.de>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [46.142.77.113]
X-ClientProxiedBy: AM7PR04CA0003.eurprd04.prod.outlook.com
 (2603:10a6:20b:110::13) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fs-work.localdomain (46.142.77.113) by AM7PR04CA0003.eurprd04.prod.outlook.com (2603:10a6:20b:110::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 11:06:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8cc93e9-0864-4d5a-bb01-08d8951ff274
X-MS-TrafficTypeDiagnostic: AM9PR10MB4402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR10MB4402242ECB3AB4B4192B179FE9F50@AM9PR10MB4402.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sA19WqVjsjCsNjoq15JVXb4GvP63dViLXqDDFWfz8J7jWpA6RG8Fz1/Mwx+8qb+xjyWIusktL0ni3vc/wWATKH3+KWmhMLOMhv3WM+0eeeqbwgC7Kd9jfFR462hvo8LX9DjK7az/jqFTUe8ph4tymPtJH5vpO/KNZ3A84GFQNKosfU5u4eMoqh/gNHMsexJ8RYKksP/LJiGyn7ZyoivdPqgN8wn4KykWorO6TrWxb1oK3QQ0t9Zox8N/Dh3VifMIH3K4zAT+N1NigdN2wbCuVmGRTfWERw6bzfaqwwzMtEMB7g0IFkVrC/pMlw65DsAE2z/PoJRG7UWQy7v8EFdGzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(2906002)(1076003)(6486002)(8936002)(478600001)(5660300002)(4326008)(8676002)(66946007)(86362001)(66476007)(66556008)(36756003)(52116002)(6666004)(6512007)(54906003)(83380400001)(16526019)(316002)(7049001)(110136005)(2616005)(186003)(26005)(6506007)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Fa4jlFQVo4Oc7xoafkMIQKv/Ip6fckLJPJ2dKXDc7j1JnWjdkn4qS2jlMbRf?=
 =?us-ascii?Q?cliZJ2qiLYtynmfLELinB+z1eCjKi9aO8V0iSapT14mr5Wd7vxfBofB8wygE?=
 =?us-ascii?Q?tNlTVKtzNkCivZ2/ousY9xLoyuxDmp5kmvyZTfT/lvGEWO5oVtc+94vtC1Du?=
 =?us-ascii?Q?Yt5QlJXE2g/YHfGbCtHDvgA34Kuhoaf39NsJeIHnGJs/yyAo+Wt06RhaPV3b?=
 =?us-ascii?Q?KXaJBmHjYn2JaKu4/T4rTOfaIJ+3P8kbMfbyBfSagIuKlVHPe8sSVdY/rifV?=
 =?us-ascii?Q?6jxP0qqDoidFi/5xRli2K4/VJvoo2wcnqvSftw8MHnLXz7CFY9OPUhbdzDBT?=
 =?us-ascii?Q?TfXGDZDtW7svSXI5PcM7/nY4ideJdxyrquVp/ZQfOdqEl20BtNYLDF9EoBlR?=
 =?us-ascii?Q?lowfoPVDptj3PyvJqbiFnWlbh9U6yYJsl6POLrYiBhoLh6MHcRMeoYdqk8MU?=
 =?us-ascii?Q?TQip4aHwNtUZK1cR2ece8rxTYt57kY1nB+FmpIxuhLU1hckAgtbm9zy1p5u0?=
 =?us-ascii?Q?CxyBSOg0HZZjvO4R35oGG13jRBGx/7A7KH4Q0NLciUV1aw7eHFObJBVoKRZj?=
 =?us-ascii?Q?wnJVLHhb5vsSLsTiHHHAcknajVtwUYqoxY/XTCbTsiMV9Ne5S++Lg2ZCRE00?=
 =?us-ascii?Q?LQxWzukVep80Bidl98UhXwYyiTBt91bXb3O/OVNsyAH7DtjI1xtaWaDt6yNx?=
 =?us-ascii?Q?tCfL+2TuMcT4Sy1gWAkWfr4VHFk79fHULFsS+jDrlaz36ZA4pwToz8/I8om2?=
 =?us-ascii?Q?1LmC+LQBfe/Mz8TxveOYWr8t1LwuJx5nlNYWK9EFbEQzXTuaWDe8JHvOKOWz?=
 =?us-ascii?Q?yGqT+gLPflIYQBhbcg5UPH1Jf2Y2WGc5jLZeNwukjZWBm9YaFL86kRT8ymYQ?=
 =?us-ascii?Q?P1m/1CMRRL69ESnyfZV1gHVN2HscYcBaXr0NG/i3V1qQo8F7FPx+iyqSCiop?=
 =?us-ascii?Q?kLVUNTTI4M2uiDAWjVOaDIi/1YA0KhVXQxnli04FfstOxJIbR6SONKspZrm6?=
 =?us-ascii?Q?lV3g?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: d8cc93e9-0864-4d5a-bb01-08d8951ff274
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 11:06:11.8765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vuSxMiZwSCNd+p++EIundfCdFlSCkTDjlzebHfwmauJnjt9WNalCLHonedwUN9wdnLehX34+ABU97mhRUW61O0ymT0qZxReZyii8MEkuUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4402
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

There are other NXP NCI compatible NFC controllers such as the PN7150
that use an integrated firmware and therefore do not have a GPIO to
select firmware downloading mode. To support these kind of chips,
let's make the firmware GPIO optional.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt | 2 +-
 drivers/nfc/nxp-nci/i2c.c                             | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt b/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
index cfaf88998918..cb2385c277d0 100644
--- a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
+++ b/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
@@ -6,11 +6,11 @@ Required properties:
 - reg: address on the bus
 - interrupts: GPIO interrupt to which the chip is connected
 - enable-gpios: Output GPIO pin used for enabling/disabling the chip
-- firmware-gpios: Output GPIO pin used to enter firmware download mode
 
 Optional SoC Specific Properties:
 - pinctrl-names: Contains only one value - "default".
 - pintctrl-0: Specifies the pin control groups used for this controller.
+- firmware-gpios: Output GPIO pin used to enter firmware download mode
 
 Example (for ARM-based BeagleBone with NPC100 NFC controller on I2C2):
 
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 9f60e4dc5a90..528893686e18 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -47,7 +47,8 @@ static int nxp_nci_i2c_set_mode(void *phy_id,
 {
 	struct nxp_nci_i2c_phy *phy = (struct nxp_nci_i2c_phy *) phy_id;
 
-	gpiod_set_value(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
+	if (phy->gpiod_fw)
+		gpiod_set_value(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
 	gpiod_set_value(phy->gpiod_en, (mode != NXP_NCI_MODE_COLD) ? 1 : 0);
 	usleep_range(10000, 15000);
 
@@ -286,7 +287,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 		return PTR_ERR(phy->gpiod_en);
 	}
 
-	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
+	phy->gpiod_fw = devm_gpiod_get_optional(dev, "firmware", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_fw)) {
 		nfc_err(dev, "Failed to get FW gpio\n");
 		return PTR_ERR(phy->gpiod_fw);
-- 
2.17.1

