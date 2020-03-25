Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA6192BB8
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCYPDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:03:51 -0400
Received: from mail-eopbgr40116.outbound.protection.outlook.com ([40.107.4.116]:14177
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727702AbgCYPDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 11:03:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6YRUQccHDs5yoSJSGdwpsAHQeEr9OUrJXNkX3pllhu2HMCFGRzF8crfikqbn/an9gNo+crGhZHqAWkLURWsKxRZNfXOXeWegaXEYb+3PBm0nNNZHhdULSz2pb/lVsasksg6kqcPUCnPpo6wZHcD6JCT27XO4iKZKW2WRcf0I4RSW9mEglxkwocchEp/kQjzIfsfO3VDo4uZOlahJHdi2Jd2ZV9vZv6aTXM4EeYIEaQfudDY0zSgFJFPCrKqg20XwsvPAiirQGIT5bav3WnqeBXaoan1VbZu4x4ZitbSYyBh3rZrxMPbEalqjFyvsLgU+7GJhDlObxeAHEmKNtFyjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8caUUiO8lgJRPNXpzkKDk7dJR3pfkPToAl991QP+r2Y=;
 b=UMCA02xwfKBczoSJBlBQqls6YWY0X12NFrCnIUMFigMxrh6m1F2LVfPN7NAfpUO7QU7tj/bR8EtFS6zY9uqxZpf6znx+ReExC1zYUdlqEF6UGQjuCHuUB5QaRebQfQIOSwmEfUwIQh6iZ0dzCqU2OXbmpV/ghR1lgg04rBZTmssZNzWbQSvse74U0kQCVFutXfIeXulaQxX/yBJznsSjnxsdrdlIKdShuovIXH3C/YmWGYLUPEkWQZh4louKb/mG+BT3DTZ4b71fqytC6BC+/O8enLXm4mFSSlo1WCIfxnWVRnTVeE2vq3W4oXc+0zjMrOcAavNZZi+U/1t29HDKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8caUUiO8lgJRPNXpzkKDk7dJR3pfkPToAl991QP+r2Y=;
 b=ANSfrtEgNx8yIdffzNWNDWs3lpAgo3InHU8z9hSIkqJm8lKzEnGLnrqEYjFAx+f+hNMgp6P8tWf9EJlpZ4HjxHw7sES0epOX1JgCsFXaIfqtp0QwfA7pNGmpRqbM4xyH+jNXIytagkOEwz7P5yHEQjC3aFuzn0ggqClTkFdY+10=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=philippe.schenker@toradex.com; 
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (20.179.1.217) by
 AM6PR05MB6550.eurprd05.prod.outlook.com (20.179.6.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Wed, 25 Mar 2020 15:03:46 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e%4]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 15:03:46 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        mark.rutland@arm.com
Cc:     o.rempel@pengutronix.de, linux-kernel@vger.kernel.org,
        silvan.murer@gmail.com, s.hauer@pengutronix.de,
        a.fatoum@pengutronix.de,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] ARM: dts: apalis-imx6qdl: use rgmii-id instead of rgmii
Date:   Wed, 25 Mar 2020 16:03:28 +0100
Message-Id: <20200325150329.228329-2-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200325150329.228329-1-philippe.schenker@toradex.com>
References: <20200325150329.228329-1-philippe.schenker@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To AM6PR05MB6120.eurprd05.prod.outlook.com
 (2603:10a6:20b:a8::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from philippe-pc.toradex.int (31.10.206.125) by PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Wed, 25 Mar 2020 15:03:44 +0000
X-Mailer: git-send-email 2.26.0
X-Originating-IP: [31.10.206.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b38a5717-81bc-4adc-1b76-08d7d0cdb73e
X-MS-TrafficTypeDiagnostic: AM6PR05MB6550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6550B34A8CBAAB9032EB0751F4CE0@AM6PR05MB6550.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(346002)(39850400004)(396003)(136003)(5660300002)(316002)(66556008)(66476007)(52116002)(8676002)(54906003)(1076003)(86362001)(66946007)(6506007)(6666004)(81156014)(81166006)(36756003)(26005)(6486002)(16526019)(186003)(2616005)(956004)(2906002)(4744005)(7416002)(8936002)(478600001)(44832011)(6512007)(4326008)(16060500001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6550;H:AM6PR05MB6120.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZxmASxFj+/PkeYmhT5MSkvNEcCk7eHENOBfyC7qJaiKzX1mU29Asjm5XoLTopwnfEC2r21Nl070WF1J5EQIUpkAzLzl+LEMeWTjEbayeacKSn3gJp8gwwtIgxkzrsiyLI9HVSEWzXB4geukwPSgyz7oNzW5ygikGVkfay2sAqYxleDHlAus3ZU/AiOkkc7rV4e5udFYY7M3PWFt63vvpiA4l9Jya9cgpDALMzNlUQ4sQgy5q1xIhqE4dAbSpEXv9GHTylLwxYJ/5M13V/1sJYnfN+JPFn+CX0HlJM1busxuOib7izM6/yIDB2HDKW5CbHqbT92XBWHz3opDq1cUTZArYB3+gVDDqI4c8IJaXfTj6PfyBh2qVsLJVZ51D7+1A+2ohWlwlA+zPrzs7QNseX9QgdYZn1f6zkTODnZ02wuwuk6TTl3WAZiySjGd2IwhMoxIwpTvs85Ss5TQ0ASdmi4xmNgH0tSrBz20P0hDmPMsUEsHugLxN/Sbn2bqNE0qL
X-MS-Exchange-AntiSpam-MessageData: qdXPhZteQntn9qgRnT8PDa80+9tAhoU3TQrrkmd9qQYTJylqg5dWWZ3D0l3TrVyjYbHUbYToDowytHpAm9H6zo88rLiLAqxO/RfGs7xhFj8aIDcK/b3mjlIQ6WkT7tfdefJCLlquPdDTwIzW5UAMhg==
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b38a5717-81bc-4adc-1b76-08d7d0cdb73e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 15:03:45.9067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KrNmBGYc3oR2xER3Se17/g2Lq6b1/nHs/E/LAAqwSgT7r3/LRPB+BLTq1mqmSdl0LHiUHESAQPJVj3GJ5PDXYXR79zmUhVh/IeoNSKeyM54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6550
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

