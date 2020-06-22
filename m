Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2072034D8
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgFVKbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:31:08 -0400
Received: from mail-bn8nam12on2049.outbound.protection.outlook.com ([40.107.237.49]:17472
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727876AbgFVKbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 06:31:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hv/YnjkCQBxFMjwj06n9YEGUr0jQ3mB9QA/OG/SDTzxInn3hoxfm7mxkVcOwI/+H8TxTsUDHbfM6zXKDJZcadjkeyUzqHR3E88mkbbORqQe9SPpxRYRI9BzRAlmb3O80RzBlS8lDPJvy2LPZeCHBfOoCFgrXoBgG0inHiSIZE1ZNOjSsbsEoB7B0NNoVujXr4K2f+yP7GYCQIMNfafjy1rqroy9xCq8me4CUyjiz53AwMQj7fVsIP31xINU9tiFGD/EGBDM8Bk7rctHB1NcWMK9q8I3rufdYjBwaGCOLEeZomDFAD+on1wZa6UVOLmXz8XjXj571oa51tYkbrcXglA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLqXYD5+M1qr6969+54SQO/N2iaUDB9aJQm0E0oXLNo=;
 b=GY3GCjnq1KFlxHiE47Hurv3p1dcBqs+lmhaiSacbA7wiuisRa/U+2ulAqQGAyaDx6j44LLk+sUh7rOEs5IGzsrAZgS2Ifz9H6n76L9MB0SISB/ZZT/6CxH8Hfl/+WKcfj3g71/LrS9d00IZnD8oRVli6oAcRLBWWn86iSkZ+LF3OtqJiVXYOhRoDzKU7Dm88VvVJwjByYpdbz9B4OMIuyjvSlfANWiAFUjJj4/VNr2lSZfW2x0RGCralcBvMeSSbk5dRJHSjClt112I2OIKUHqzwr9IAQBcFmvNqgyN3f2GnpF/D4lSkoOQT5jx6CwdKWJ1BztfixiaTRzY9RquCcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLqXYD5+M1qr6969+54SQO/N2iaUDB9aJQm0E0oXLNo=;
 b=GU61v2ZLCDwzZ5qZB1LPuLv7/cLwZHOoizjRn2kQzGsa4kFPPk2UnB3KsxPWcZSVwnVECyPmCYZ0tqxLjhw+2wP+0gJzkoioJzqd6fkKAEZajp0RwONYGBDuVexpdz/z9klVRdWOJrEdCc5IunTxfB7vPvwYDJxQ+tBpux8f8u0=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4134.namprd03.prod.outlook.com (2603:10b6:a03:18::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Mon, 22 Jun
 2020 10:31:01 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 10:31:01 +0000
Date:   Mon, 22 Jun 2020 18:29:27 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: phy: export phy_disable_interrupts()
Message-ID: <20200622182927.7679958e@xhacker.debian>
In-Reply-To: <20200622182857.3130b555@xhacker.debian>
References: <20200622182857.3130b555@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYBP286CA0043.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::31) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYBP286CA0043.JPNP286.PROD.OUTLOOK.COM (2603:1096:404:10a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 10:30:59 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dd8137b-601a-4659-8418-08d816975c3b
X-MS-TrafficTypeDiagnostic: BYAPR03MB4134:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4134FA469D54202697B2C7B7ED970@BYAPR03MB4134.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vl7G1RWmpuQ/0PGIoTdv1p5CECCQ5hlxI53S0xh8X2AHzh33omHWxiY+ay+7XtEg+ubO08iFg7npWho0Pz6QJJBeYu3CL99oUXeNcBgTSZaa1dQpsGhsz1r117VE+NduFcqSi9tpCkgQB2pmdUuRX+ps48Ax9LgMyAr8Pondw4yzlxiKijc2mNAiZ2cXiIGPWkuPMcFLM1S3jxUNcw4ZtHSmkkwrfJPX+l/mrmkjJ/6RbUjBaUTO0CWsi+pzU6n8D7wuNptYKzObKoXkju50zWG5eYUyFI2eiDfJF9nEPEe3oH2l/6XBBCBxVnxmcgHM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(83380400001)(7696005)(66946007)(16526019)(186003)(52116002)(26005)(8676002)(956004)(8936002)(6506007)(4326008)(6666004)(86362001)(9686003)(1076003)(5660300002)(55016002)(110136005)(66556008)(66476007)(478600001)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SjJFpd2Fu3kp3jnbwvPnZBtQR1Qs3Aec4GV3hnQR7sCqUJFGYpaUfPVwzrTLa1X16hldel8qOCT7OPEH5Js0lwQxeto7utbbGSb39RH2AaywVRsaLUYiTExFxIzrQn+x9o1Ce/3y20fyEJOBFttKp8qGUkazNizLAXrnmjgl5G14+Wll0o0nQKEGtstOH+AX85HJv8zRKpdvYr+y5h8w2qEAaYGf4RW7ExDYMtOvBYO+oyW/ltDfP5ephfa8583agmGhdg6eAOyq1emw4OMpZKkwMDgYd2q30Ikzpi5JtA0p0XAjjury0FXtI9oGAd4XORwm/0YPpvjOIpPXxLice3N8na+evL7p/KpbYc3RJMm0OnmNDD+NWLrO7yhWOp+RzsfdRoKKhuqGND16yowhYRZDR4xNOP1xuRzBXxVIQCFRS5eNEVbtDXFkz9I7+VHQvEpiYE5NhVPNuRpMvbmOQ1oZ4n8wMkh489l0jdGzxdj6NkccEDgS4cReg0f0O2Mk
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd8137b-601a-4659-8418-08d816975c3b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 10:31:01.7391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdqjdRJdPol3sz/ZOVEyFE9KjeNXrnRWHg+96f9jw+OMZs7xy0aMFtOHqydwxVvMqSEm+jqd6BEQjlS/QKXuyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We face an issue with rtl8211f, a pin is shared between INTB and PMEB,
and the PHY Register Accessible Interrupt is enabled by default, so
the INTB/PMEB pin is always active in polling mode case.

As Heiner pointed out "I was thinking about calling
phy_disable_interrupts() in phy_init_hw(), to have a defined init
state as we don't know in which state the PHY is if the PHY driver is
loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
or boot loader could have changed this. Or in case of dual-boot
systems the other OS could leave the PHY in whatever state."

Export phy_disable_interrupts() so that it could be used in
phy_init_hw() to have a defined init state.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/phy.c | 3 ++-
 include/linux/phy.h   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 1de3938628f4..a3d92a15da71 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -840,7 +840,7 @@ static void phy_error(struct phy_device *phydev)
  * phy_disable_interrupts - Disable the PHY interrupts from the PHY side
  * @phydev: target phy_device struct
  */
-static int phy_disable_interrupts(struct phy_device *phydev)
+int phy_disable_interrupts(struct phy_device *phydev)
 {
 	int err;
 
@@ -852,6 +852,7 @@ static int phy_disable_interrupts(struct phy_device *phydev)
 	/* Clear the interrupt */
 	return phy_clear_interrupt(phydev);
 }
+EXPORT_SYMBOL_GPL(phy_request_interrupt);
 
 /**
  * phy_interrupt - PHY interrupt handler
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8c05d0fb5c00..b693b609b2f5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1416,6 +1416,7 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd);
 int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd);
+int phy_disable_interrupts(struct phy_device *phydev);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
-- 
2.27.0

