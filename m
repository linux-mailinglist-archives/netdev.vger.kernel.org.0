Return-Path: <netdev+bounces-1350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F9F6FD8D9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D4251C20CB8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73AF46AB5;
	Wed, 10 May 2023 08:03:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60604258D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:03:45 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2014.outbound.protection.outlook.com [40.92.53.14])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9557D1BB;
	Wed, 10 May 2023 01:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiNLETpt0YlxMHAPXVXdUsA2uV7ZEB7qXQyEtCGMthUXmzExcQwLfg0XQbi/+jO+v+6ojmT6XStbGjRTMMjv2cWXRgoo/jGGfsisSauHJ+xOkOqZzeE+Zbn2J2xSwGUa+2LFDlrkMhGmsoPNFcHPpL+/ETYNAeMwTNI2Lg2ahhT6k2diZG1QIKZvygconfH9jFjsiIiFOdUhsO2qxIa5Ryr6dTFvH6VwOrRg2VcHk/lli/ZNg90wvXBOvS4hE98p4hAyyt+dy03tYnlHKnkTOQHxZWlexmKy2dVSRgnlAI4XbopMlodmSKmzIgBe1M5tDmJzmsx31C0ITZDPe5KkvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvMsFh4FPO1iP15Ypt6iloZ1FDVKWvXhmfyczyjOwM8=;
 b=Qev5T4zOnH+ld2wZM4kmQ8lr6nIF64huY8xwlPKkGWq0z/mx4pL1381LQ0mU6fae6Wiyh8Q6pcTBWTfv0ydrvso+HRLey9RPH1H1S7nvnVT5DRLdWZC1qoEA79tXDpgqoRaCuMVlZquhrCkHSeDYP3an+LkNUVy+qfeODgWB2dobNZB5WbLvILkRYT52Cebt16sYf2aAGQR1NG+X3oUCKnurpYh4hRFmZnLLBuq13nDaAJ7qoRqmFMBM7GOyS2r/uyYxAZWG2E5SLbaXhYSSTJXy8cYga+QU6HXOHgQSYHo7G+GtG6MM//md0B/JQrpY+weIGu8wIndZ5GJpZvNGuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvMsFh4FPO1iP15Ypt6iloZ1FDVKWvXhmfyczyjOwM8=;
 b=R3NtbwNlpiPiH5g7W4VgHPwnuxgUlffSMzNiRHShefgbmwwtYBxEC74SKOjq9VLW2kgYkCw70c0GDJBGteBpFa4vCOGGrrs/a0uvIDFK+lCMKCTGLUKIla2gXy1LrPnmYz+SDf5b/YB83Ukwf7oeDDjOIbk+RVHT7vB23Mu0r3pRASfFsB7aM/FTI5BuSoe0KNn5xqxWUCLQlrwd7CGPac9x+JBdThzAJg+7TlRK7OlCi7icGkA/sklNhmy+77sUKXvlu5MPgaJLUiUnTKGDENi5BtBnx+kFmlPWsZF+5HaMTZmB+slvzw5KPjSkMStvz0Iry8T73OWYM4Iy9GSH/w==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by TYZPR01MB5157.apcprd01.prod.exchangelabs.com
 (2603:1096:400:342::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 08:03:38 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Wed, 10 May 2023
 08:03:38 +0000
From: Yan Wang <rk.code@outlook.com>
To: andrew@lunn.ch
Cc: Yan Wang <rk.code@outlook.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] net: mdiobus: Add a function to deassert reset
Date: Wed, 10 May 2023 16:02:52 +0800
Message-ID:
 <KL1PR01MB54482416A8BE0D80EA27223CE6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <96a1b95e-d05e-40f0-ada9-1956f43010e0@lunn.ch>
References: <96a1b95e-d05e-40f0-ada9-1956f43010e0@lunn.ch>
Content-Type: text/plain
X-TMN: [EWmoEiRTzNj2A+LopQ533GNSoOZxDleJBgyBYkdfV1s=]
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230510080252.8584-1-rk.code@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|TYZPR01MB5157:EE_
X-MS-Office365-Filtering-Correlation-Id: b881ed19-be2f-401b-1500-08db512d0ca1
X-MS-Exchange-SLBlob-MailProps:
	YfhX3sd/0TX2BmCZQdbdnh7GRQzK1Scz7pFxnsAzYmi/NvFeTcavnYsLt8sW6SRPHvQ9N986QLLiN2tE8mrB5ilPKZ98oHLdmTWqVHBQcj4gL8ad9WPnHPd74G4FLxXXPkn+EN7fWqdR/b6ZWob1s1GI2/grzPF8NqtUsG5SXtdJMKY2SKaoC13EF/CYWp6HEJ7sjPPHERhWLaS5ULtc2QUcAZYX731zKGNMruUv0Wxg5jGJGDiyPRY4/Z6VIt/17tUSvYWf48e8mMPLYqQSN3xCjVg+W/VodkOioWq363mPvzTfyej7rs6nqiNXnnux1AyYQqdQW/rEfSXluCNxeEDorcBfh+l5hAojUCS7QZnr7YEe68C6K46CcRvWzLioZ90vxuXcbp8Ymjlm6oy0UKHPfH8i1HcYNeeN+XIlyus777VvRK1bq0aMUR/AAz1imU4j75AKk9puo0Oisy4DEF/sgMKxr0kEfarVs7kkXGAGncILkrENqnbWGQ8XxrBiIzeRzC9iIXxlwrkKyuh/9nzaM6U3Sh/zINrcS7t3bO+f5p4Z40su1G1TpmfbTWCspQn19uWIA87Ub+BMWwFMBtEJV4QAb6efaRIsgt5auKqOpKIKi1XPbdTnPahTThJ8IEI+kceQcOqxvi+yVF1YU/iyeQhUEk0O5Gn8PkrMn3W0OeD4G0h7FZ9U8D/pt+D1XnbnD9k/mcnqurRGx4wLm1WSJu1hVODKK5Ndbb8IO9wL1QuR4nPdzhUdlIauqPLkgtA5NBQB/IxSXaBGjjdq7L7KJ1Ajx3tF/aEFGM+dgpQ=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6Fli9N7P8blhukmc19wOrQMa16gHnbl7s5z+MLuUfIKWn7+QviPwRQROa1hrCEiwj7NNKhkqT5RigaYpQWv8j8u1KoBVnJ6qt4DLJhMSfpVDm7KUb6w8EVKQRX4NTRt1wma6+AKvYTy4i5y9ylh9zZAn/rc6m9f47dV3zUPaS06Uo9BTSVUNtIlMdr1Vmxj3Gy73fr8id13P7l+YNWrJU/cf7KkN/T+U8g3+YjOLl0y8VzM0l/YAo+fVKQDCAoDBu9Yaj9lfba5pZ3+dxLRY7M7JyeTqDn2rojRk7Ga9r0juMlxuSoBZ26n9ejUlae/HJ/NTfLBvDd+hpHe4s7zUdr0tcq8rwzozXguRQTsK06SNSoA1ndN9skz5pijq6auu8aBBfBJzQxzGIteZUacLRQET/m16VXpEUAAYzK3kkktugIWjbANTP5/abN0QXwVRue5BbiGAV7OBJyZB6h0yQLoOzB5RxDqeb3v85guSutlMb+LIhxcxvJQQWNpHxDd+XWBtWe4vOFflqHbNVQs73sLBDdGkXJygRSSSWbdMkqh1yf8t1CGubQn12Ly9NnQYyO1n6xldNKtkS1Y5Y0aXjzw3qMhn3Mf1kaNlVAAA3Fo=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rEmRRDp6iOHdLxxDrxPBNSuR1cANfqTpIkanbEh+nfh8YWoZe98G8QifVTPY?=
 =?us-ascii?Q?76np7S5D+Jv1ZHZVBVAMpSzi0+I1xq3V7jvuw88RrCvHHkQKLtJJmD8ny3dC?=
 =?us-ascii?Q?6Kf0xPYJ+vBBWMbl1KTlAQMNA/obCL+EgRdoQW/iBpsottHLW0rga7TNQxfV?=
 =?us-ascii?Q?BlJkobymHFI8x9aHWoasOHnVTVN9JwVNF+ePnW/sW+T0dsMWCdB9myxwWVN0?=
 =?us-ascii?Q?unIDkMHQ9GGbQPMqBRERs5gdymZCmRQGnhfVZBcsqw+f3Kjk7lGuEroTAeXE?=
 =?us-ascii?Q?+CS7KB0JPiSNiMUWLHSAUVqAWoGwlRvvYtccEIABpo/yRoFAigBvwNsgmxvW?=
 =?us-ascii?Q?P3/+4E8ImD7TdvbaNoNwZ7dqTPYcmtQuv+F3gaZEggCYWeu1dNIzlAsztjyb?=
 =?us-ascii?Q?XrdYZPchZPaY4vFcwU54T+2MwaR2VsL1XiTCY7EX8Uk3dmHeyQp22qbVTfTf?=
 =?us-ascii?Q?GDZEH5cu1JjD+nNJTupS68mOPu4QM0+9X3V/3Y2JzeTDPaiuv13DuaSv7sRp?=
 =?us-ascii?Q?gIco8lIxsbs4A989Hx6nAumoW8GfI5rar7zYqc7zaDa4mepRzQyLao6dMA7q?=
 =?us-ascii?Q?mGU02urdlrt7Mwn/hTBAvocMwVn8UjwC5AKN2W4EKs1HU274aM+LuwkjR49O?=
 =?us-ascii?Q?8DywCS9YB5CChJWRjrTnTMRBcaLXmTysDJ6vcK3TgQqLCuQIKl0bxG6rvbzn?=
 =?us-ascii?Q?Z81mY3yJQS1bbsgNEpr6qIbrk8LH+FEnQ7uXVvwIUrSnMSgoHZL/Y01C/PSL?=
 =?us-ascii?Q?LcmOhxuEdYgtyMgySWe6DYdh6Hc7/6ms3ckz3NB/HeQ0sgGz6bMQy7M+vaT3?=
 =?us-ascii?Q?PmmP0aOwlVFrH9FXYzJMK6biriml87+ow7w9ayZ2d01wTqLHaDeGGzyYVabt?=
 =?us-ascii?Q?h/4z44Qag6qAuHWNvaTTa/IUNcJ58x87qGv4XYO3fAztkCMPNZtQhqjikAhO?=
 =?us-ascii?Q?7mj8NQjic5t2Fp1tYZ5R3nhF+pvEvbpKkarK7G8z3NhCtEvYLBN93ZcEPpCk?=
 =?us-ascii?Q?W1see3V3ApgeJkrANj0muA29/Y+twbGmD2JFyqMDnd2GWaTP0Sr4gOVAR7a7?=
 =?us-ascii?Q?NqUoBmKEaEacmofLVmyyPC6Qn+evaqNMd3kPLr0RzSaedi2gMa0vmIw2WQ33?=
 =?us-ascii?Q?DDsS1Dh6QhYfUriXQG+RWXlGp/lnGTqAeBvbcM1SttrQAQXroOnVrcOG/ONS?=
 =?us-ascii?Q?KyZpUaz1mfc8zdyLMvVB/WgoGUuQmJfEhS0kXA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b881ed19-be2f-401b-1500-08db512d0ca1
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:03:38.7585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB5157
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It is possible to mount multiple sub-devices on the mido bus.
The hardware power-on does not necessarily reset these devices.
The device may be in an uncertain state, causing the device's ID
to be scanned.

So, before adding a reset to the scan, make sure the device is in
normal working mode.

I found that the subsequent drive registers the reset pin into the
structure of the sub-device to prevent conflicts, so release the
reset pin.

Signed-off-by: Yan Wang <rk.code@outlook.com>
---
v2:
  - fixed commit message
  - Using gpiod_ replace gpio_
v1: https://lore.kernel.org/all/KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Incorrect description of commit message.
  - The gpio-api too old
---
 drivers/net/mdio/fwnode_mdio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1183ef5e203e..6695848b8ef2 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -57,6 +57,20 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
 
+static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
+{
+	struct gpio_desc *reset;
+
+	reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
+	if (IS_ERR(reset) && PTR_ERR(reset) != -EPROBE_DEFER)
+		return;
+
+	usleep_range(100, 200);
+	gpiod_set_value_cansleep(reset, 0);
+	/*Release the reset pin,it needs to be registered with the PHY.*/
+	gpiod_put(reset);
+}
+
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
 				       struct fwnode_handle *child, u32 addr)
@@ -119,6 +133,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	u32 phy_id;
 	int rc;
 
+	fwnode_mdiobus_pre_enable_phy(child);
+
 	psec = fwnode_find_pse_control(child);
 	if (IS_ERR(psec))
 		return PTR_ERR(psec);
-- 
2.17.1


