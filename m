Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354F3192F66
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgCYRem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:34:42 -0400
Received: from mail-vi1eur05on2093.outbound.protection.outlook.com ([40.107.21.93]:44928
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727718AbgCYRel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 13:34:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDt8+Fu+WEG8aM2Zxkjr0ZCx0LjlVKeT2mYTmYlDjZjUe//vyxhXJD6F6kZZA7VLgchxzl0YN/CJdOFvPZv8jCwQiztIj7TeqR+Zm31cp7qpgL0XefruIV7+3lHJbLSSsROCd0rIX5rDHsuVY/P0+kEeCVyHhsoWKPJQpyGsoGpg+QLRP4HkgBwp92hyniyq+XTby4rv97rjAT7zyjT+20rb+99BYTWmzo1paB7t/aXsI2xa3UMvgePucpdC7KDmMDTvodlIk5+ADSJIo/uWyMomOCIP7FwvqrwriS83+pZ6uJv64Z3QShC1ikPq7l+gCvoU53Jru8m9wfKnW6biYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4ZcaHWkuaQBByNYHGizRq232qJwHZnXa7JSm9iT4iQ=;
 b=gT49errYXDsf5X3eocjyWYHR35N7az0q15bEKg7PliBhMfDjdHujuUbZb8GplDPECML7yeNCc/jS6G4XbS0PGDOUGDbQyMbRHwAqgLh9wsmJ1jUiXNpQ3E/VyfJXc98TKfhdkCy0MCbulMo8QjIywjK0c31yq8Dcp7sfk93oP3AuM+gciPJ4+P5IAPGDXVonda6rFSzKx9SvyzSsbAetWZ+7kRmwLlWxTAksf/3nqu7HmJrByeE4yPk85BhEYKk6L2ZQ5hREefidDrjLo67tZNxfG8KMYQAr9eyClgv3YIcJH1vTUdDAzzE6ajS1seFFCFgail2SqsytkUIWBbtD1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4ZcaHWkuaQBByNYHGizRq232qJwHZnXa7JSm9iT4iQ=;
 b=aN+73uG1hXIexJasfuiqX7R9G6BybtUIN/YBa7gMZ9CtwUHqfB0sLaKRkTmk2g3GwLqYn+0U07GMuVD1XEeoWzsMSzVUIND3ebdDFlQJAVe9wH+4F4qicriW7bFH9cjxE5VhJsaWBZfc5T4MFeqUIE2050xvk5ZXssMOjSIm2ec=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=philippe.schenker@toradex.com; 
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (20.179.1.217) by
 AM6PR05MB4872.eurprd05.prod.outlook.com (20.177.35.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Wed, 25 Mar 2020 17:34:35 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e%4]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 17:34:35 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        mark.rutland@arm.com
Cc:     linux-kernel@vger.kernel.org, silvan.murer@gmail.com,
        a.fatoum@pengutronix.de, s.hauer@pengutronix.de,
        o.rempel@pengutronix.de,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next v2 2/2] ARM: dts: apalis-imx6qdl: use rgmii-id instead of rgmii
Date:   Wed, 25 Mar 2020 18:34:25 +0100
Message-Id: <20200325173425.306802-2-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200325173425.306802-1-philippe.schenker@toradex.com>
References: <20200325173425.306802-1-philippe.schenker@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::11) To AM6PR05MB6120.eurprd05.prod.outlook.com
 (2603:10a6:20b:a8::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from philippe-pc.toradex.int (31.10.206.125) by ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Wed, 25 Mar 2020 17:34:34 +0000
X-Mailer: git-send-email 2.26.0
X-Originating-IP: [31.10.206.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5deeabd9-930a-4bb2-8c7c-08d7d0e2c912
X-MS-TrafficTypeDiagnostic: AM6PR05MB4872:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB48722E871B6B61C31FFA01C8F4CE0@AM6PR05MB4872.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(39850400004)(396003)(366004)(346002)(81166006)(8936002)(8676002)(6486002)(16526019)(2906002)(186003)(7416002)(478600001)(86362001)(66556008)(6666004)(66476007)(66946007)(956004)(44832011)(81156014)(2616005)(5660300002)(4744005)(1076003)(316002)(52116002)(6512007)(54906003)(4326008)(26005)(36756003)(6506007)(16060500001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB4872;H:AM6PR05MB6120.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZYe5pXT7AI6rJRL4XgclEeA3D+syEkMQM+suuRrEq89wAA4wuXUCdMHUHlKPWZR4uEdxodG3DamtFbBIQoFQywwg8F3l9FRrp46mIDfZ5pcplrUpPKgsjvs+Kmn1SrUq18PiJkDAtwkhSrMLv33tItW6opNUS6QnN6opxUeSN49rsrhxpelgv2xHLzgtk2JS7W+arqVnX0UYOXPYO0m3uNBfdDF0GZRK9oQ7vlYtVEIXZ3e0NLe9j+o/LtiUm7n5T1v7y2Mw1J1Vu97kMHVxV6SBRSh6mv49s4fAMTSCZXEWA7NQGUSgyqCFvFTa3BqLEzpekwlNLeDGPmWB7I+vokDZdYwo5TNxBN6ChxgGE6RddsmYuLqw/LvlHWjPSj8gdrrjd0lISbcQmSIL2KTnZsKQfxiGKjK5FQEn3bhTeRBPqwrqwu2k8dAmQRCtwoCvBB/rY/iB9xke0RjmLsTQTvnaB8JOv6v52ABkMq8TLgfu8bqleohifjp9MGWpUIg
X-MS-Exchange-AntiSpam-MessageData: 5JLHK6nddyFY3sDV5EX3ZrU5trGRUAzWtsqVwf0J9+ZOLhlTxAEZuR/6vQi0neRbNU5L1CLr2Wx1la6lIFxNUgI3THmchBUlhZMQ3wmWVDrMxjia+awiu+vruOKZ0JIUIKmcZJ7+hV5ejeQHojeAjQ==
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5deeabd9-930a-4bb2-8c7c-08d7d0e2c912
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 17:34:35.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zezU0R3+IqTNgu549o81moS7JG01UxWGNMaUphyjO4VrD5HXz3E13zwLyEE2pD7FdPis9mUgwvvkhtpwqHOqxm9jM3PdWtpHpnWux2Nd5SM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Until now a PHY-fixup in mach-imx set our rgmii timing correctly. For
the PHY KSZ9131 there is no PHY-fixup in mach-imx. To support this PHY
too, use rgmii-id.
For the now used KSZ9031 nothing will change, as rgmii-id is only
implemented and supported by the KSZ9131.

Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>

---

Changes in v2: None

 arch/arm/boot/dts/imx6qdl-apalis.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-apalis.dtsi b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
index 1b5bc6b5e806..347a5edc6927 100644
--- a/arch/arm/boot/dts/imx6qdl-apalis.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
@@ -180,7 +180,7 @@ &ecspi2 {
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy>;
 	phy-reset-duration = <10>;
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
-- 
2.26.0

