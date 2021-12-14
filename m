Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC94D47422F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhLNMQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:16:57 -0500
Received: from mail-zr0che01on2122.outbound.protection.outlook.com ([40.107.24.122]:35264
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231808AbhLNMQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 07:16:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfCPdq5Znvvu7G07d1KEP0A2NpL6r/iYOH3yBLJi8kuH53KuAKczhLkzIbTqHcTWilnvaqfKLbf7chkMbvcLwkRkfLNd6gNO8KXh+htZkfz28CYgMEDNTD1J6JhhbyHQjpobhmmAxrV/L6a+7DSqd+0cg57kLVw5TIrv0bzhWqUnN2jbu+38O7ZvxibhaqvvyBXorCyow1hsmKFxZhPtBDDQPQOhphv8+wKKOwNIRattslRzG9thpdOSsiM3Ln4h6ErjvMNtO6c3KZqPQw6o8rcMi2mcxGDIoN1THumBiQW5fRyDX5dNM5QqNXAQp5KBourIHcaZPW0dYV+ooCqKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxQ9vroGi8XCJhlxryfAysI5HU1US+RVSjmWZMbpSnw=;
 b=dqk8MT004Dc+gepiKGHH725xOgTbPxbbWnJqZM+s3vk5WPytb7XQHjFEuEZdoqVhS8Lrxtjy2MR06PRaot2r2A8VQupLttF11b4bw9hPqWgXSxygpE2kvYDFP8Tqdl4vNzEaoa4KN94xZyR8+/7L7qSHC+VAMdWQG5cKaH6wDxKcAWcBHpnAxSGMD5udGVSzboZ0jOUKMaRVvwokVQHODGg84gnMvEIfB2YQXgpwS02dWHE1zD2NFKoUiBL6iQvWZrII7NLPkmbcJsmXvetunbSdnQQ0V1dCSdLobcaTG6uKeSQuzMEKZ927lQcGyOV3lDmSXD3e928lPPDDfPT0yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxQ9vroGi8XCJhlxryfAysI5HU1US+RVSjmWZMbpSnw=;
 b=rEVdwrSkyfZzDAQRS72KTw7qo37WCOqfosWQlxkYznW2mLPg0DQTmEScU68HQidUf6oBcEofCxkN0YhHGrpb6iBxJ454trC0EHDfkjoR8ODwaTVO8IKN2ueTmerrF2ITXG6AUMafePX37GYWziD9l74X5CpamF+uCnwp9NjgZ8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZR0P278MB0234.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:36::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 12:16:52 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%8]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 12:16:51 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: phy: add phy_reset_after_power_on() function
Date:   Tue, 14 Dec 2021 13:16:36 +0100
Message-Id: <20211214121638.138784-2-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211214121638.138784-1-philippe.schenker@toradex.com>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0167.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::15) To ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:34::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59d61e07-b0d3-4d59-f77c-08d9befb9c52
X-MS-TrafficTypeDiagnostic: ZR0P278MB0234:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0234EB6D345D49F1D102FC3AF4759@ZR0P278MB0234.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AP/VNhgu0IfSTTBJvtSzH25mKutIl19hEH9RVgQa7vlOxORAZScmdWbFsj3lNKRALk3gpNVAk3Mi6Agj3fhHqF2F8RiwZ6fFbpJdyMq2CrRZ1NKIUmdGk/xLihR12Aa7TuMwU/dWcuf+3MViZhQvPvxyh6rFKbnQNkmIu9DQE0lcBuT32kK6LTiAhBNAAhk5YHlsi31PRwlgZDa9yZAyjxKzNR5w/sEtH6QsrR+/M5JPydN8wckmUqz+KbeISA7o68cThQQyh3MeNsqg/HvqB+SfJqCjg/y/S7ahJlPOgyqKh42BnZjbU7BpkjnGiDtm9IDMN18wbn0rZWpEIr9QvqUzhNjMJVjZpOOUEzKAPp93PtSZXz/C0b1G0huuVszs/6LNOaxewRt6yHLTN6fXkIuwhxy54OQOyIwAoeDOqfGBwCsD9shtXvjnohNT7VOnqyuOyfs7nwR6Op/YOyfoiXoJMrWf141zYWfh5J33gTwID5bMOESb4BnJnplpXzVr6fMHuF2lMUZn6B/qFesyyNiPgPa15xCsDOrpn8ADN3GxXOyR8Z9zWfGG5+j6GX34gIkp2BdGwqd97R/xgXfKjYgxBsWTeIylTB2HcK1QURkAEHVyshu5064W9F37sUFV5+2WkTpRSs+qCgZC7a/25+T6FmCMfqLZ0CN+TuSP5NeGPUwQfDL+jaiWt+ugBhO0X/4rMLBi1ABrwxn0VcBLdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(396003)(136003)(366004)(8936002)(86362001)(6506007)(66946007)(52116002)(316002)(6486002)(54906003)(5660300002)(2616005)(1076003)(508600001)(38350700002)(38100700002)(4326008)(8676002)(186003)(6666004)(26005)(36756003)(6512007)(44832011)(66476007)(66556008)(7416002)(110136005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ty1+hyeQhJgL2m0h+bzlj1R38aNmcZTwvpRkSMxifYlQs30QDeEAjy5WXBUZ?=
 =?us-ascii?Q?r6V93n0HSDmqTdwh3At7vYhz9ME84avN+ZYHq1N1PP/E0UKSzCMLUt2069oC?=
 =?us-ascii?Q?RZoCxV2jKlKPb/pPBxBfhgBmshIzraVH9obcG75U6AAB8Bro+J31560oM1j8?=
 =?us-ascii?Q?/kz3fO6OI5An24Twoey2wuAVcNaedB6uXH7gZcxbZ5YQOajscX9Wzl4w2wpN?=
 =?us-ascii?Q?TcD5kuC5EH1KyGJ2OEVMMTx0Z59GJtAg0Jr8wA49fvr6HfBdXQH/D0lD6Mb0?=
 =?us-ascii?Q?c16GZP22/NQ2lxljEvG0aPpCr1IQMnuQ/mCLODiX8ZNAv/34cK5BBtPYgRsX?=
 =?us-ascii?Q?Nb5Qc1TbZ/s6bcWbscZ7ZkUubNe2l3a2xGvvJ+GLZqD9jbXX2X8Ok3G7jGA3?=
 =?us-ascii?Q?fRxjcl3TMg9Qak39bkrt9a4ovUB8DZCzQCHbnEVVLjqeexgBHz2ehLuld8dN?=
 =?us-ascii?Q?xVdS+8U2dR2F0RHxTe/i97coJajLiDS5rfG1wSRui0U/JZZy9SNrSkVgKn3W?=
 =?us-ascii?Q?FDP48/dUMpyDzPzOI4Aac+rtP80ni7jvs+cuaNbAo/pNJcPXJvze2jGtGwqx?=
 =?us-ascii?Q?eW/uMCPH0XzMsBP9xaE6ShkNr20xbwpMoLrbWQiWwPAR2othrjr/an46CTM8?=
 =?us-ascii?Q?4agfo0lUEM3Xr97zrCKIOlmoYdkbX9pkwMwibrBaAupwMWAf1yHgie3gbFG7?=
 =?us-ascii?Q?kGUdR/lHT0i6J7YfvocpTyFfmmZN4Kl3SopP1IYBQHSGneTSpqbGib7iUI6t?=
 =?us-ascii?Q?rHeKUJHinNZXy1lrahp/RVY3bWzbTR0KilExn+rvteypxH0nU2sC/29Oz7hJ?=
 =?us-ascii?Q?ECVuRwS2DuZQhw+akrCTxeTOWrWjWmsWmeOsyG/JmJgl5uTeai9n7j0vCl6A?=
 =?us-ascii?Q?tDfJ8VyjjTXnkvqLkC4XFZ8Axc69UI16SQBuxNWS+3Thr2WcUkGTaiufO0vN?=
 =?us-ascii?Q?NnaKhZxX0mO333l4a+HeBuE7amTpC/WGy4o/WhYSj+gtt/sxnE0tkzwTB3dp?=
 =?us-ascii?Q?KQwk/b58HbCfdoAcbJTQ6IojqlleS1/YJ1vZko7cskxBUa5GUCuFwow73lUT?=
 =?us-ascii?Q?j8UQqV3U2fWU/bJu20di0IBf52LvwhHNiNG1Kb65v5f3lSn2vjlyG+QiHLRZ?=
 =?us-ascii?Q?Hl0n3eXfXkFOaLNT4s2v3i0O+glCe7dYzkQr4EO+agTEXaacn0r1yEmDVrAB?=
 =?us-ascii?Q?CRNCjKDNb0z8Y+Yuy+3heq1GsqlEgv4nuFWNzLQimsfhwNb0Kf47eDgzwr4G?=
 =?us-ascii?Q?cKRm3Nkh/+xZIPpdo3i5x8483WuHCYuV0uatMemvV1cnKf28yL7j9xt7Yogw?=
 =?us-ascii?Q?uzRWypzd2FUtFATd++T7K8wnJ+72gb1zDBvNbf+ildTIoW7CCl+yU3g/jmI1?=
 =?us-ascii?Q?1RBbaDZl0l+gdAwxZvUhv8WNUlBXm+6djMpfzgzRuNzHryil7f0j98qODM5K?=
 =?us-ascii?Q?s1hHU6zB1+eEyMDld2Jaj+gb56cAd8uE2rj5PTCb0bYb541pag89vISzbchD?=
 =?us-ascii?Q?vlfk4OMQefyi3KBdvvocPGI75ubgNIUaAavw17UUL+VHXjGM1KToQjsup1rg?=
 =?us-ascii?Q?0qjJTBCWElfdVGJCmOKNZRTf2S+8QJzPS2uvY8bfLqyMxqI6g+Lpsc2tZWD8?=
 =?us-ascii?Q?bZYX3MSHIO3dEKVRuop8AXjfqckI6mkbyO3T7D3/oGrDH0cV8hWyzhy5I2dm?=
 =?us-ascii?Q?h9Boyg=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d61e07-b0d3-4d59-f77c-08d9befb9c52
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 12:16:51.9313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXL72wuck8bMUKsCAnEqmsKQb7mHP376l38lnM9kqjTQafmLSZSnxrONxNEQeP2qlNfitnT+NRz0gML7LY8Xc2FJyeKoEfpFfZTrEnVxcrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0234
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHY requires a reset after being powered on (e.g. KSZ9131), add a
new function and related PHY_RST_AFTER_POWER_ON phy flag to be called
after the PHY regulator is enabled.

Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
---

 drivers/net/phy/phy_device.c | 24 ++++++++++++++++++++++++
 include/linux/phy.h          |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74d8e1dc125f..bad836a7ee01 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1878,6 +1878,30 @@ int phy_reset_after_clk_enable(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_reset_after_clk_enable);
 
+/**
+ * phy_reset_after_power_on - perform a PHY reset if needed
+ * @phydev: target phy_device struct
+ *
+ * Description: Some PHYs or hardware design, need a reset after power was
+ *   enabled and rely on that software reset. This function evaluates the flags
+ *   and perform the reset if it's needed.
+ *   Returns < 0 on error, 0 if the phy wasn't reset and 1 if the phy was reset.
+ */
+int phy_reset_after_power_on(struct phy_device *phydev)
+{
+	if (!phydev || !phydev->drv)
+		return -ENODEV;
+
+	if (phydev->drv->flags & PHY_RST_AFTER_POWER_ON) {
+		phy_device_reset(phydev, 1);
+		phy_device_reset(phydev, 0);
+		return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_reset_after_power_on);
+
 /* Generic PHY support and helper functions */
 
 /**
diff --git a/include/linux/phy.h b/include/linux/phy.h
index cbf03a5f9cf5..0d88cdc97dbd 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -80,6 +80,7 @@ extern const int phy_10gbit_features_array[1];
 #define PHY_IS_INTERNAL		0x00000001
 #define PHY_RST_AFTER_CLK_EN	0x00000002
 #define PHY_POLL_CABLE_TEST	0x00000004
+#define PHY_RST_AFTER_POWER_ON	0x00000008
 #define MDIO_DEVICE_IS_PHY	0x80000000
 
 /**
@@ -1499,6 +1500,7 @@ int phy_speed_up(struct phy_device *phydev);
 
 int phy_restart_aneg(struct phy_device *phydev);
 int phy_reset_after_clk_enable(struct phy_device *phydev);
+int phy_reset_after_power_on(struct phy_device *phydev);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 int phy_start_cable_test(struct phy_device *phydev,
-- 
2.34.1

