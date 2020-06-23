Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876B3204B6F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgFWHmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:42:54 -0400
Received: from mail-co1nam11on2070.outbound.protection.outlook.com ([40.107.220.70]:46719
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731202AbgFWHmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:42:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxOGSvxi3yM480haBJKKpQF3IsZMLh/b+ktKDqrcTxroBv7U+9Q+FqnnXkSmN/w9AmX9pVbBSsjg41a/2IArr08h6h7A/VsmLBZIBqo/A8YFfzRxJn4UimbcWpbfjhy2OH+pG3PjkHGSL1ZTJZ7IsCV8Rl5QCVmWD7fRnP/GStA6TpRA0+LIY/G0mENBVxFxmk8DH2F6NrGwueiOysBpNDR881dpAEluWuN6VKU/F+OAHlRjpSZklyk0/sE1ye1eP8aUO6RO4Cu/JyFCWTRZdM9WJ+aIck717rrorGhwLPGPaFfwd+Ux1F3e+sfOYxr8P+V4bKfhsoqj4RHcjqFS3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jsUm8FmdOgJ5yqiPkE96nVksapvuMuO0NI/a0XLaKo=;
 b=BGxcCwLtL/aEin/oxQR+K5GvBJBmW0U57pYSQmz5xuw7tdcZVoWHT4cbiZEVU9QU1tuXYWqQnTO4NQjt23UFbiTEyW0zFRd/Wfgg3sZuXl+qguJbDxJKBd/q7YfA4+UUILJWcupN5XBOef78QbDyFktjLVzhTjtq5GWff86oRVGqptxXjoe4Vd/w+r9MtwaOl8oubpRMR/zALYFx6yRgNx5u4VfwuB3la38F+CPH8SN6nHzR0Q1yGMYvzg84zs+MOP6ie1CR6+AKwhTqw1Zi/v63gVLJqjyJXyznzQJCHFmFj+ACkXexLvD0tEXoH2qwt8NWNVYUJUIzMMAAyOGH2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jsUm8FmdOgJ5yqiPkE96nVksapvuMuO0NI/a0XLaKo=;
 b=XX38OhQty7RIQXcBLAhzpuVi9Y4/kOpbdNFS+Imfvo5FiH5nWbCuKJnQI6Jp/c1v1WT0l80JrKPj6gKMYgno1NUA0Hl4jwbFxxQDkYMuWYIUq8BxtSZ3FrMkblWaHHt2c2sPxnHHoDVCG4SGNzg9rjOsxv2qHj0YKogxvVRY7dE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB4949.namprd03.prod.outlook.com (2603:10b6:a03:1e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 07:42:50 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 07:42:50 +0000
Date:   Tue, 23 Jun 2020 15:41:37 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200623154137.728d8ae8@xhacker.debian>
In-Reply-To: <20200623154031.736123a6@xhacker.debian>
References: <20200623154031.736123a6@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0205.jpnprd01.prod.outlook.com
 (2603:1096:404:29::25) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0205.jpnprd01.prod.outlook.com (2603:1096:404:29::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 23 Jun 2020 07:42:46 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a7fc19f-44b3-49ea-4be8-08d81749077f
X-MS-TrafficTypeDiagnostic: BY5PR03MB4949:
X-Microsoft-Antispam-PRVS: <BY5PR03MB4949DE035B3DA44C84B16F11ED940@BY5PR03MB4949.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N3zR+xwJbb7h2UEbKrg8f7Nktnsz6jcRDXH0o5fqw2VVoCrmq0zXEhdnw9wFcdIg666M3lSicNrTkGYvn1ahb9iNvxPwSiSy5edEitEDGy2uA6pJ5Ahthor1gANOZu+WxVeNso2Xszy7l5cJ61i5sjcWYYcwTA0d57FKbLK/LjMVI5Yu9jLLaw+j3xlYhbZvdm134zqf8uihuIq1NNZH2zmuThSnD3WDXHoJDbo7j8YxGUxwHoV3ck9E4jW8F2RXExe+gD0MOkj9JZWj7ibLVnfkjIhnpizdAtRS8ZgDwVyodavNMe9bTYDO1WMp46qg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(366004)(136003)(346002)(39860400002)(9686003)(316002)(66946007)(956004)(478600001)(26005)(83380400001)(6506007)(52116002)(6666004)(8936002)(4326008)(5660300002)(7696005)(86362001)(8676002)(16526019)(186003)(66476007)(66556008)(1076003)(55016002)(110136005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JsYzPgWcI8r/nHSF1n3UFq+KgrxS2fxVDm6f0ezmn78KYo39xG2xfZ1+qSU2WTX7EEyRFmKqocauWiEuKGpPKo2EF2D5EC4vjBq8H7K7IzOgFnyhPy4wyhDTB8q9kqiplyw4+9KWhTk0TYud0+0r0C8ehgQkOCJRxkB7kBP7/ADDjRM/YrRvgj8sUeU/y4A3pglvv412xQTdL0oKQKJ8sbNXg9KgyV9IJ9d+0aBD4HtArtHbWUBqUO/8vR4qgILEvpiCKTC4TNnXAMUm2Ca3mLAtyMUYmzSWfj1AoPpCwhdw926t5TUydzyY+iT5vNdqgs7qCZDi1T51Ec0TrRXc9yWPQGDXSBy6mPPDEUryx1o9egdGfStlhZVhzNzTyQLhZn0Yc8paGvEqUZANHyugteXC9I/OCdX/UAjTsLXf3oPcHU2/ZkO/m7Ao7AUvYh4A6XPlHTWLww/+BcbrFD8Nhk9iboRmsNUHcmcc1k0kbdCVRYpPYkOr0vNX1oDrjSru
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7fc19f-44b3-49ea-4be8-08d81749077f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 07:42:50.4416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K4UL3f5DUx8eXQXJEdtdcsM5DMpMm0YkAcxv9/xwBmCjE+rvW+I8zzKugWNz0oYlaOEwWANT5n99RYYZu/mH7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB4949
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call phy_disable_interrupts() in phy_init_hw() to "have a defined init
state as we don't know in which state the PHY is if the PHY driver is
loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
or boot loader could have changed this. Or in case of dual-boot
systems the other OS could leave the PHY in whatever state." as pointed
out by Heiner.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/phy_device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 04946de74fa0..f17d397ba689 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1090,10 +1090,13 @@ int phy_init_hw(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (phydev->drv->config_init)
+	if (phydev->drv->config_init) {
 		ret = phydev->drv->config_init(phydev);
+		if (ret < 0)
+			return ret;
+	}
 
-	return ret;
+	return phy_disable_interrupts(phydev);
 }
 EXPORT_SYMBOL(phy_init_hw);
 
-- 
2.27.0

