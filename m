Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8142C98E3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgLAINO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:13:14 -0500
Received: from mail-vi1eur05on2106.outbound.protection.outlook.com ([40.107.21.106]:54048
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726120AbgLAINN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 03:13:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7LWwyKCJLUShE4mocVP+IP+9hIZ/9BUdz2RhLVy6I38tv+7N5EnmgObuOdya2ewlzH+OzhfoIrXZgixudHvanMEY4o+z5GA+lVgU9gmRy+NRRm8xBQqc0QHuE0WynBlgF4XgWyWxDTNDrCwocUBLtFtb3KrVUR966oQCtdu6yPKbtKZr9f83VlWO21UGERdBpqjjEhbpwioSNUOmxZtLXKv9I1v1GtMzxVTl9uAFZvthPjF5sJA8HzQnVRxvRMwapODyPtIwaOdfyCtESSy/6UdNIpk35adhLuERvucxZXCGg+k9gQKJO7+BqafLlnxc1NPt1VvfGNmfiLXLTxv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFu8IchtZOeRmHXf5iVcFo2EuAipSvGbYA7AtnDYf2w=;
 b=R9ec1/op6+pyDSM+TUbUNSgW1ZMGndaYPg6Jxe0ySq8s0AcaxdI/77/FZ2gK3dQb+69bmwsDFvYaJgrROk8TS/wmJlxu3bp7KBqdNfcgbNXcXnaEMd16jS2heXOjuygfub1tvjfflMFjxR/HC3HmIbUqzcbx9Cx3gt6eVzJhFGrIKuwJw3o5C/bZKGYoh/AMWxC1w09djeyjzOSJMUFTcibAei9jZVEZPePY7L3ijCOMIurxP60mS/VWH8FN3ZBE21ms0lA3guJXvwTbVuqmmd8ODflJnB3lj1OZwDExi2S79E/ujnMRu7/tiQuPZQaUTNCS6zS99JK+Lox12xPgbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFu8IchtZOeRmHXf5iVcFo2EuAipSvGbYA7AtnDYf2w=;
 b=Ja+4mqKzVO5WKsW9ExJqfmaIpdoWq4qrSZUIJnzsN6ya9tsOoZjsPCS3lRU2H4Jiuq5n7hgmXLZ8aNp6QMCOtcOwZd/AGTBVXbxdfslCVL7cNH2CEg9WJtFUM+VSueySlgXYP5MH712bCzfrfqxDiUs5jbwcGNbTYB5PvgtPCgQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2771.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:131::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Tue, 1 Dec
 2020 08:12:23 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9d5:953d:42a3:f862]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9d5:953d:42a3:f862%7]) with mapi id 15.20.3611.031; Tue, 1 Dec 2020
 08:12:23 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH v2] NFC: nxp-nci: Make firmware GPIO pin optional
Date:   Tue,  1 Dec 2020 09:11:38 +0100
Message-Id: <20201201081146.31332-1-frieder.schrempf@kontron.de>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [46.142.171.176]
X-ClientProxiedBy: BEXP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::25)
 To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fs-work.localdomain (46.142.171.176) by BEXP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6 via Frontend Transport; Tue, 1 Dec 2020 08:12:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ed47b71-d9d8-487d-3d60-08d895d0d4c6
X-MS-TrafficTypeDiagnostic: AM0PR10MB2771:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB27719009A0AC6056C19E4D84E9F40@AM0PR10MB2771.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aSVMowvIA4ssfiU2RSFwL9aKYzqWOqG7OFS+btYDwRiq1wWQrnQuXnPBdKhor9MDe5lE0ymCJ1FaHoYK3FqOOG+szMiaWqCDRGI+/XK5JxVvm5/0GvUYy1jP1BQphR5ywCnddUUm134s+4vHlvo5gG1hdlOFyo0wvq3sY5aFJvmsxvkum7F/N0QcQz5/x+N3la8e57AZujSy58Ps2RCLYdz8HvdoWqRFQhpExUa8ckohL/Yj1fsg4hi0EX6ecoitVkAw/U3weCCMb3NDpg1VCmgFRI/v4GLkDBvzGMj0kfueSfkC2DWIP5QInX+EDf7Ly7dm+LivTkOfx91I/wVvGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39850400004)(396003)(376002)(6512007)(2906002)(4326008)(478600001)(52116002)(6666004)(1076003)(86362001)(8936002)(5660300002)(8676002)(2616005)(110136005)(316002)(956004)(54906003)(6486002)(6506007)(26005)(36756003)(16526019)(66946007)(186003)(66476007)(66556008)(83380400001)(7049001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Qfs8mUQ8Ld+VklYM4IEPV6tdaOUZ6yYpWlHjxW8gCc0yb9zPwE1cAD5NdmaF?=
 =?us-ascii?Q?5VCDauADuwaibnxQDkxTP5BGQu7Bcq/zdVXPM1FJNC9QQAIsV8f2H2lulFt5?=
 =?us-ascii?Q?DEZuT1tZ/VViFCvpniZZUZzJxsOkh0Q2pdqWbszwstErmgvoR06tLZ9DTdFj?=
 =?us-ascii?Q?76FCmduf2iwfAcBCuUgRzFsejV4ZQLbr6RpCeCDbWFY40e1qxTrPC7/Bqt+U?=
 =?us-ascii?Q?uTt2c0iVyP6l//r9XXPREgBNsvG60EStO/zrC6fzv1psglgUBFrRNqnncxV0?=
 =?us-ascii?Q?DhdFZUTeLOuxjwSZa0aKuM0Ojr7soROqe5sqpGbhpU7zX6Z2F43TgbdmVdbH?=
 =?us-ascii?Q?yyMCBedKtoDWSkJB98yv3o7a58AlsUVVeDQiIOHqjAlI0XBn6pjArdAzmUc0?=
 =?us-ascii?Q?1lwkt2/e2Q+Sv9AOweggLXBIHw61c0pJ80cjwjs/czFqLLyMJyFPmDzsUv0P?=
 =?us-ascii?Q?oAukA8yaTx3ZISsaRND64oknHTWAl9BGD4h0YaJY1rsHfUlp8rbVkWggnvv6?=
 =?us-ascii?Q?c+T2asolOyiG92wDFHziBjFOsxLv7UwQqBtqLRi/PTGxJxSnN98jlNndLB95?=
 =?us-ascii?Q?HcqHndmcip5aEmUYDCMFyy1s/C+UVRZtUZEAaxbfTc8dCkD89NarHq1tt9rL?=
 =?us-ascii?Q?TXZqoL2UAbVDfrRqqzTBnRND2augcj0McqVRGOjaj2vOy2qfYyeoLrU0PmJf?=
 =?us-ascii?Q?fd6qV5X3q309YEEjvlNFmfEuoZustLHE1EGTeRT3ygAas4WdhwixCAIaVYuy?=
 =?us-ascii?Q?n8hL+jtY/l0E3EKjFclgeX16/HZi4YIXGOnK7NghuaLRiV9F07ORi68/r6Vn?=
 =?us-ascii?Q?mbKgN/WFunErUtp4C3KltctCU6eHqNghjn12KagHA9f0rcIqro6fwbWtoWTS?=
 =?us-ascii?Q?Gd4OLghTuILcZE9Iwk67k3HcWRc1iqipeLT2vauUzXIf08LyKjYSSIbjKFse?=
 =?us-ascii?Q?xCezjHN0pq20wXiXgnUjASLVtjI/R8o7tG9zevTopSSEfdj09TS+9GecoAfE?=
 =?us-ascii?Q?yheb?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed47b71-d9d8-487d-3d60-08d895d0d4c6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 08:12:23.0341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CoJASr+x/O3ldhQwZ/EFe6JZq7+Tpog0rMd9PrFtGK0bmmH12nToSxFnLVXR1yGIDM6rfUw16MafJB+s7A5xxIASsN48A6Pswk/WVgioRoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2771
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
Changes in v2:
  * Remove unneeded null check for phy->gpiod_fw
---
 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt | 2 +-
 drivers/nfc/nxp-nci/i2c.c                             | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
index 9f60e4dc5a90..7e451c10985d 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -286,7 +286,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 		return PTR_ERR(phy->gpiod_en);
 	}
 
-	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
+	phy->gpiod_fw = devm_gpiod_get_optional(dev, "firmware", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_fw)) {
 		nfc_err(dev, "Failed to get FW gpio\n");
 		return PTR_ERR(phy->gpiod_fw);
-- 
2.17.1

