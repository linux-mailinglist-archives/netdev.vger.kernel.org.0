Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7F626F11C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbgIRCsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:48:52 -0400
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:1760
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730203AbgIRCsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:48:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkE+9UTDKdxxmoZBz9DKbkWeGtse8Szkn447gWC0FcZCGLMO/8WcYwn5p7MO8NSV7Huw0L/LIMiANaNdLPjRmsmSn2/yo+im5cD7XwzKs+9I7K9F7kFQIdX70X7NrXdQjTFRWkCPr0Q4vNKd2J4un9nc2fpnhoGdrkxeIvFRLv65DjK2N/7exlwHaxFwuxoPAjsvwrLkUCZqKMm3Is+fUiICmBMPvbzWoA3Q9gL7s6xdl7ZFQyRIA7n0bOpODHgKKh07ZtQ7rEQXRcdSlgmr0+4MdqrxToxiYylmqmYXvVOoH1pkMOl5oqWba2nLdRppZL2sRkD0bba+yQs5bpkh6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlnggPJKUY3Qx5pRNvFZgONgogBR19amHI5SIx5Qcic=;
 b=cBLPKX+VKtkwTAXebnKsbg4veO3FtkVhd4OeeOXLKKiBfSBMTkd6FOFCHajxy23fp3C/uZbkDzeKPqIm+HqncYsPp/hHE1yDS95spoRjat9qNCBfeOv2B4kGyiFC5d7vPTMBfviBPAxKaplzxdCPWPGImDAH7wfBYH1eDD1BbtQkuniyMTDqDCY1n+oR4t9IBHiU5+DePzRxe9ujdvlJWkMf2ugEOgEpjewunaAgaQAkXdjbG31l4gSf/gWf6RL+SkSn3zvwjLRFm+ZbVNe0f8P/ECkd0HwWMWxAdOmUJVhPni2mfdfOuKhttDPox3CEd7+uQMyXAIRajyKa8oIcew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlnggPJKUY3Qx5pRNvFZgONgogBR19amHI5SIx5Qcic=;
 b=GDA49g0jFjjxWkYLfkHU5OrhRu4Tjdb1K8bUyJ5iFIWaN0naasU7Xfh3a9ixu0vu5N2hLIYPvvem2elqWLImIY93cFY3Aw41ddfuW6xqHKins0kNkRwo/PdzxyzxqCXbBruD9rViqnk+Kmh/GVsxqUvO/ref7hgJVBscnbakthQ=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from DM6PR03MB4555.namprd03.prod.outlook.com (2603:10b6:5:102::17)
 by DM6PR03MB4441.namprd03.prod.outlook.com (2603:10b6:5:109::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 18 Sep
 2020 02:48:29 +0000
Received: from DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38]) by DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38%7]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 02:48:29 +0000
Date:   Fri, 18 Sep 2020 10:47:56 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: phy: realtek: enable ALDPS to save power for
 RTL8211F
Message-ID: <20200918104756.557f9129@xhacker.debian>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0185.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::29) To DM6PR03MB4555.namprd03.prod.outlook.com
 (2603:10b6:5:102::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0185.jpnprd01.prod.outlook.com (2603:1096:404:ba::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Fri, 18 Sep 2020 02:48:26 +0000
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92b6edeb-6c91-4832-ef98-08d85b7d529c
X-MS-TrafficTypeDiagnostic: DM6PR03MB4441:
X-Microsoft-Antispam-PRVS: <DM6PR03MB4441912C22083990A97DD05FED3F0@DM6PR03MB4441.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:153;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oriIKMqxMUU4NPS5VJfkzN4FxfdHj5bscvkxJtIHCAr3+t0uaudg36i7Qh0bkqtFEjhbioIAcfekNG8Bs9X0/zui2D9RqZPULVrL/i2+Q6OqxKNudK6GFO0uR+Q+378B26hogFvL85qHe8IRfZCohEpH7vhcy6g1PCKFVww6snKLgfLvVKNG9f/OPwtz1Wi1HnLz7J8FJmRZmBWRftSOdeZpiHUY4xF+9ZJVo8qfLzfjQuTEDqZloU320SWtVrArJYy3SPsYNe0Q3Jw8llrLcE0WVDSYTqbnIbi+GA9NZKfe9ug4UdX/D52/AHHzwpfq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4555.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(366004)(39860400002)(55016002)(2906002)(26005)(6666004)(6506007)(86362001)(66946007)(7696005)(52116002)(16526019)(1076003)(8936002)(186003)(5660300002)(8676002)(956004)(316002)(110136005)(66476007)(478600001)(66556008)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ft48Emz7GUfB30vfijgmAUR5LiE0FnCQbP4P6vRXmjUcNuLimshpYOJ9PDpscpn9v+YN2FAYxRYk+2rZFB3RWadEYluHXx6Bw0wekvbarSpLBKC38Q+rUPmGKini4CVuSxnrVnQg0zTs8JVd+n0TrMrRmqbQR58kIc46ygGsP6N+yD5Bym8tc2enyrljLnC8hK0cN23I8oLW7YOKAVQUQpC2g1PMvuYmLamiSu3LKhgigOt2NZL30AnE6LQIb3HNzW7wVGdwE+kHr+2yvTs+YKH3zLFMqK98v1SdyAaq9YWJiB83s+1M3g0CQqjShodqttBAOZiA7xKpH5E0MaCXHVI9iHa/YV5r1grbAD6Pw64p3zRPLedSB5oY5/XPy6PgBHLIQJxpcoMhsEGXHF4QfwaVLujSj8hHcVVTQsnkZw+uLQ27AbQNje6zzE2qHTg+i9nyry624QXjntLYHG7ZdjpkLMGlmt+vhnHRuzJeb4Qjii8OKOZhngcYxwlUbJIKTykkY5NIhflOBE17wW+5Qz+9A4AuR29WXdKICpzJx3AQlefBJITn3aKPuVGZ00lOAD7+e9fAQc5GriokGXDyyL0M8nx/Hzxm1QZhi3Y0TP0flGXDn3J3bBCunSruWRPVR91k0oCC+DNCkt59rkTRKQ==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b6edeb-6c91-4832-ef98-08d85b7d529c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4555.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 02:48:29.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZD6LyY8pFHGhH6N4YsVSEI3RyJY59HaSMb33IPf/YiOsBHlio65znMeuSur30r0bcWcTZea0BuiFWxvPGiz5GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable ALDPS function to save power when link down.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/realtek.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 95dbe5e8e1d8..961570186822 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -39,6 +39,10 @@
 #define RTL8201F_ISR				0x1e
 #define RTL8201F_IER				0x13
 
+#define RTL8211F_ALDPS_PLL_OFF			BIT(1)
+#define RTL8211F_ALDPS_ENABLE			BIT(2)
+#define RTL8211F_ALDPS_XTAL_OFF			BIT(12)
+
 #define RTL8366RB_POWER_SAVE			0x15
 #define RTL8366RB_POWER_SAVE_ON			BIT(12)
 
@@ -178,8 +182,12 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	u16 val_txdly, val_rxdly;
+	u16 val;
 	int ret;
 
+	val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
+	phy_modify_paged_changed(phydev, 0xa43, 0x18, val, val);
+
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		val_txdly = 0;
-- 
2.28.0

