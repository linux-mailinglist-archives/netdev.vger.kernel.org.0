Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BE02CA1A5
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgLALk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:40:27 -0500
Received: from mail-eopbgr00096.outbound.protection.outlook.com ([40.107.0.96]:12193
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728042AbgLALkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 06:40:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiCx60ZvIVo2ubwdNceZ92fug1CGxKJg8fq+VD2iHwk7LIXnQ1T9LvX98xxWNgjxN/j9m3KssXGZVpDu8X61CD7h98J00DV8DUga11fVVPcmHRurqkKEyVkRD6/C9iDvmxGB3CoeGytw3ngjJra6Xgmrnw5jLsYSOFm4/D1+h6mbfWNzY7jhwPTGrm14QsuqmmcwWr68c0Wv5Nvxe5vekiwrRagnKX59QlCqt8CGqeMbgc4TJz8UTzrD6hYKDD2s0Miiz2LxZIP9Nc/FIdq21JBcOc/JKg51Rp7mtVrMdYz51fkLZx3ryMQ/LOfVtJ2U35FBOhZ6DEGvFBEuOGZzUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUTw9bqlijiLWiEMXVx49T2fVCgvkcJZfeVjvSZxtTQ=;
 b=NJdocxYYAlvKP3DZQSNTlUL10NRN47uOkkoaVxU13s0EIspZPfSGV7lqw4iO8eb+4r7iBsH/unfNIy1R//xsrxWAubf7VziQbfASGsalZ9tzLoR8XmvpyAL47tLeu60ZeAEsmQC492j1SUUFuDlh9TXYuvhkt1M5cdDLLFCDcbNq7CoAfi799FdyB6JzCpAjWtkvbsvOa6mod73s6Sw5I8RCBW7wtNJg7JqsLWFEPm6j+VTDJ1QiCbSN+xm4RLRvFYxcvMNVZ+x7L1s2ZwaHWW7sPVr09Dn7z5y1ikOcnKZ9EF0MdrVWI1aayVRv5xIclp+g024Flo9YCy90jL4BqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUTw9bqlijiLWiEMXVx49T2fVCgvkcJZfeVjvSZxtTQ=;
 b=g1PHGS1u45J2izsf/0RHS/M/R5E3N6kG64/FJ47I2xbGuQcbUkx3M8nld/o1q1aduQpzshid3qgsYgidGTJk8+qCOyj0vgCW5NWU9kFwkkmB2oCG83CvZWnTGVnnGq0I0xFY0A0TSyiNcanZlzutrNxtZE256QlohvxoeVkucu8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM9PR10MB4514.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:26d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 1 Dec
 2020 11:39:35 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9d5:953d:42a3:f862]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9d5:953d:42a3:f862%7]) with mapi id 15.20.3611.031; Tue, 1 Dec 2020
 11:39:35 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH v3] NFC: nxp-nci: Make firmware GPIO pin optional
Date:   Tue,  1 Dec 2020 12:39:09 +0100
Message-Id: <20201201113921.6572-1-frieder.schrempf@kontron.de>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [46.142.171.176]
X-ClientProxiedBy: AM0PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:208:14::22) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fs-work.localdomain (46.142.171.176) by AM0PR03CA0009.eurprd03.prod.outlook.com (2603:10a6:208:14::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 1 Dec 2020 11:39:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfbe8d01-9d6c-4a26-8a70-08d895edc70a
X-MS-TrafficTypeDiagnostic: AM9PR10MB4514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR10MB4514318E0351B876FBC4DDA4E9F40@AM9PR10MB4514.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/xuLoZYsy4gzVNcfjw4mYp9JW2f1FcavmdxtBWnf/kP+F4X1EOBmJCISqHMNGCJBp/PzPF8uEw/NKpqc92HysxvG2IuhlkIGWluGE+ApjCpsUpCflyyiKwBROKCMHKkcCgTL4wU9Ka+91eDwy67C0YNYlYIZvnF1d6QVuYl+yDRjPkciEx5XVavKaNd4P5Iqo/Cvq2w+4y/bT1B1pspMM3ZcDW9AQXAX7wugB0hb9eIwYG4OIKVSW+hwCWYuRV6Tpvkxatv4FtU9hj6gZiZTGKek5Ph8JdnK93IJt6bpZ/pnOVxBampueuNq0AKmjxmK9cNaTPYfqQ+rJwQ9j+xxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(7049001)(6506007)(8676002)(26005)(83380400001)(16526019)(186003)(478600001)(110136005)(6486002)(86362001)(8936002)(54906003)(52116002)(36756003)(316002)(5660300002)(1076003)(6512007)(6666004)(66476007)(956004)(2616005)(4326008)(66946007)(66556008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7u14C0wpsYA9beuGLuhUSyEYyDeQ1K0yMT60ArfxrRCZ0YiIQURB7D5/W0px?=
 =?us-ascii?Q?R6SsWKKpPJBwVmXD7QeosKeOWcazG7FAlkdTPMfUFJ+RRSnDWR6LbHzgzqrq?=
 =?us-ascii?Q?Qpd6U586dGSRrZ3HtMndjc/+PRuS+eOYWdyALuvgIOoCazW2XiqoI0+FFz/V?=
 =?us-ascii?Q?PTjmmGCkMOaUG406M4epKza3dYorLnZ87o+xXDhTmDa4WnsMkjuQrno7D1rZ?=
 =?us-ascii?Q?MAHLQEYhRpIDuZH5ILG6kspfzQAA/ZjIfnkKAoQa7YHshVvmCrTTFwEz5wRF?=
 =?us-ascii?Q?JFwgrnkOuBJqf0/RQ7Qb1uKhjf9CSIceqK5lqQ/NuL9ivHxCoI/SMtwOzoDK?=
 =?us-ascii?Q?MHDC3CzHhn6ZvaqU/M2ocsno0ic8DwgO1Ti4WUGSs7Nq8df3w++5U8zzypu4?=
 =?us-ascii?Q?Zd4FPk89kUJHUpDF/Hp03uc9N2BdeacUyOrsdVJR4vPlRMORvMSPmoKuQRoy?=
 =?us-ascii?Q?RQ/+HXEy2d/0HMzaKC2Pu/2y5prfdMPp9GGIInOTiNcY8+QC44DJQH9HxnVo?=
 =?us-ascii?Q?qV5TGLic/i/ydOigwAOhMJXxogPFf9Ik1MwwHhDUwIC2C94l2AGTyfEcRH/y?=
 =?us-ascii?Q?pkRsTgfn9TjCjJ9IKoQzRBBKrDkUdG/8meIDJSSAM02+zO9JmEeiGv0aDZoe?=
 =?us-ascii?Q?z6WTKQvAk2Fowt+bUw0QiuZtNttU317l82JTiGGItpmrKsgwGoGjfC69IyaX?=
 =?us-ascii?Q?hbtETgoBZylzA/fnlcRD1nTPbw1JmN8kLhl1R0YWdp2ADJH0eiU8bZLEqxux?=
 =?us-ascii?Q?MjN/a2QysJtDZjPwxHPad63YWRX8aKXHNVYd9czKQ8vtz5eQj2TLSZzkYbWC?=
 =?us-ascii?Q?KzKNOWgl/iidkzJ/LMimhzXGCJEvaSYM3zLiAGPkz0tpNAsDFIv2TzH6MPY0?=
 =?us-ascii?Q?in+GrYw3c7I8kZRm4dUXgX8+Ccwqg7TDbFX1G4Mfh3yrU7y0BAeAkEOX2ZCY?=
 =?us-ascii?Q?McTdMeBq1iDTCQI/h1XAFkSDedfTdmJOmnHhLgn9HvW8yLhTGyTO6rIZjgCj?=
 =?us-ascii?Q?aEvZ?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: bfbe8d01-9d6c-4a26-8a70-08d895edc70a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 11:39:35.3628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9rwXakWHE6YQgqWY1HwvLj/8t6Y06jX6WgafPl9haDBD+faZ5TpX8CkpC8RcLvNtSqVDGKrPfOwYSlJkknZQ7e6kBINlrNNi6a4NHbVPmEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4514
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

There are other NXP NCI compatible NFC controllers such as the PN7150
that use an integrated firmware and therefore do not have a GPIO to
select firmware downloading mode. To support this kind of controller,
let's make the firmware GPIO optional.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

---
Changes in v2:
  * Remove unneeded null check for phy->gpiod_fw

Changes in v3:
  * Improve commit message
  * Add Andy's R-b tag
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

