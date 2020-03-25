Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63937192BB7
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgCYPDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:03:49 -0400
Received: from mail-eopbgr40116.outbound.protection.outlook.com ([40.107.4.116]:14177
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727123AbgCYPDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 11:03:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aL5UK4G9HPhmJiwxPIKBVYO0z3c1ThPQbBugioBqQ3ovC8Plrmcxwn9aKlwbTnutmhTvjLxtfCCaSaZ6grOT2BUVtBQvF/9+MQMFydaG57kn6yOGfexq1V7ErktSbItG7bv5IDxflXX+nYHRSEWw2tmx9ifYSPuU7EJ3Y/bT8DhZNqi3WBsCnAnVx847BGh1JgpdBtu+zqJvTnY3W5gAa1LI1JxdDLCNR6iNZrShkPoFW1oNrf9VqMkHSD5vN6zQKmMBh8B9rlqQc/zbl+bzNe5nIpirw1KEAkQGVPsnaMA1mn+Kdhpb7kGT5eXwnXFiae6pjLo6sZg9a1cV02XuHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKJiWvzcNraqSjt8EG3Ql36A51XHoMCiGMvkNJXKhII=;
 b=SHfslB3Q1m5/BOTgKxmBApVkg7xWx4BN7fmO4nXxRG3sP8pQWknBrIZmhBexwEnEauOr7NObzQgBY/DbfRIYwK1PV2QnItvw7YIu5pIf3elxzTDcbAbrM3QwKGaqW30bgj4WMg9vTmccujUI6mI97w/S36vtcKWq5LtP13SlE2GLJq/C7x0ApiCP6NaImHQMXpmGrNdDpipGS77TPDK9rsjiJKFFJjyfl2bqBLYzFe9YDHYH3povGxC4PPI39SegIN1lKutdErUwcLy8DWn8bT3Nka97j9q9Rvw+N8WxvkfBV0Gh73c9NuuMkDALZcml+OFUX0E4BK7+KQy3W3XQ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKJiWvzcNraqSjt8EG3Ql36A51XHoMCiGMvkNJXKhII=;
 b=vZ0o9kxO7Exc1eEHFVKk6Ggyvk9L1BpPqgs/CkoNojhNtSqWObWpZzrMUHm0/ZWqSx+S88fOktCJul5o/SG9XWS8xS/C2r3NZyuFZDrpHWErfbG8lJs2eadk6/+/Ypfs+JiWI9bLf3+ipse6f1HE0VNgqXboHTETGk0jrqTH4q8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=philippe.schenker@toradex.com; 
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (20.179.1.217) by
 AM6PR05MB6550.eurprd05.prod.outlook.com (20.179.6.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Wed, 25 Mar 2020 15:03:44 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e%4]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 15:03:44 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        mark.rutland@arm.com
Cc:     o.rempel@pengutronix.de, linux-kernel@vger.kernel.org,
        silvan.murer@gmail.com, s.hauer@pengutronix.de,
        a.fatoum@pengutronix.de,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/2] net: phy: micrel.c: add rgmii interface delay possibility to ksz9131
Date:   Wed, 25 Mar 2020 16:03:27 +0100
Message-Id: <20200325150329.228329-1-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.26.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To AM6PR05MB6120.eurprd05.prod.outlook.com
 (2603:10a6:20b:a8::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from philippe-pc.toradex.int (31.10.206.125) by PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Wed, 25 Mar 2020 15:03:43 +0000
X-Mailer: git-send-email 2.26.0
X-Originating-IP: [31.10.206.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dbc19e7-6b4a-49b0-07b1-08d7d0cdb65b
X-MS-TrafficTypeDiagnostic: AM6PR05MB6550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB65502FCC16B760B4449657F1F4CE0@AM6PR05MB6550.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(346002)(39850400004)(396003)(136003)(5660300002)(316002)(66556008)(66476007)(52116002)(8676002)(54906003)(1076003)(86362001)(66946007)(6506007)(6666004)(81156014)(81166006)(36756003)(26005)(6486002)(16526019)(186003)(2616005)(956004)(2906002)(7416002)(8936002)(478600001)(44832011)(6512007)(4326008)(16060500001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6550;H:AM6PR05MB6120.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZrOPF0FEJRUBP1y6YuYdW8JbVHDctL5iCpdFp1/CYVpYepNpNNUJAj3DzriTXeqxicVNmUKmU1eQiT+2K9kgj2zKEFBXcviM+yajUBxEZfqoZm4SAXI8nqiDGXIL5jSr9WAE7d7rhB0FNcjnPRcw8/nJLqhxPksUdMeFO3nWkEzQhEm5DY1M54yOGm00Rqel5wqFlNAW2KzThMKP18lqNDUt01MUJROP5pSxC4OhQOFzQ8VJULgZT55Q4fEkNXEkT3XbrHBWDZDXXrx+yzmhkqDZowN+nL0J1VLAYzUkjk0fYBh0ygrP5HPzSOsefRTKYeNUOsAWxHS8ndrbrcaf9T7c8HKvMEk0k7GK1O+66eQtiggYyFwEt0oRw9n2WbUvtMla9bB5RwJdOV0jNeof+bNbqRMnMZITHXAg523HU3W8zL7npdbqUtJD3Jn1popHmzCKfcZcUG5VDd0yb+6zdk7TKnvJx6GIkjVfdRxN3I9O1aeidph4Okt+6wKS3vV2
X-MS-Exchange-AntiSpam-MessageData: bHCSlhHJ7vStP2LjwLWb9VCYuUmdrIuD59e6v4gBREb7J1LaRsdMHSFSBrbF28AAVeJBUVqHawHddT2njyOJ7TBMgqLXZp5oTx8lxexWIoSOQF+e1/bqCwqNgHKF+DGGNFpX40UTs4SiCHAd7fy2mA==
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbc19e7-6b4a-49b0-07b1-08d7d0cdb65b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 15:03:44.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VoqCh++Qwvny867I29l2jlXhqGMvRv22Zh+c/meoow28VfjJBQPIDRRoXSDxbKzHUplIZPCD0CXpw5TY+nZvatQD3VGUEJhGfYus+gGUSgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6550
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ9131 provides DLL controlled delays on RXC and TXC lines. This
patch makes use of those delays. The information which delays should
be enabled or disabled comes from the interface names, documented in
ethernet-controller.yaml:

rgmii:      Disable RXC and TXC delays
rgmii-id:   Enable RXC and TXC delays
rgmii-txid: Enable only TXC delay, disable RXC delay
rgmii-rxid: Enable onlx RXC delay, disable TXC delay

Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
---

 drivers/net/phy/micrel.c | 45 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 63dedec0433d..d3ad09774847 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -704,6 +704,48 @@ static int ksz9131_of_load_skew_values(struct phy_device *phydev,
 	return phy_write_mmd(phydev, 2, reg, newval);
 }
 
+/* MMD Address 0x2 */
+#define KSZ9131RN_RXC_DLL_CTRL		76
+#define KSZ9131RN_TXC_DLL_CTRL		77
+#define KSZ9131RN_DLL_CTRL_BYPASS	BIT_MASK(12)
+#define KSZ9131RN_DLL_ENABLE_DELAY	0
+#define KSZ9131RN_DLL_DISABLE_DELAY	BIT(12)
+
+static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
+{
+	int ret;
+	u16 rxcdll_val, txcdll_val;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		rxcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
+		txcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		rxcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
+		txcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		rxcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
+		txcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		rxcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
+		txcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
+		break;
+	default:
+		return 0;
+	}
+
+	ret = phy_modify_mmd_changed(phydev, 2, KSZ9131RN_RXC_DLL_CTRL,
+				     KSZ9131RN_DLL_CTRL_BYPASS, rxcdll_val);
+	if (ret < 0)
+		return ret;
+
+	return phy_modify_mmd_changed(phydev, 2, KSZ9131RN_TXC_DLL_CTRL,
+				     KSZ9131RN_DLL_CTRL_BYPASS, txcdll_val);
+}
+
 static int ksz9131_config_init(struct phy_device *phydev)
 {
 	const struct device *dev = &phydev->mdio.dev;
@@ -730,6 +772,9 @@ static int ksz9131_config_init(struct phy_device *phydev)
 	if (!of_node)
 		return 0;
 
+	if (phy_interface_is_rgmii(phydev))
+		ksz9131_config_rgmii_delay(phydev);
+
 	ret = ksz9131_of_load_skew_values(phydev, of_node,
 					  MII_KSZ9031RN_CLK_PAD_SKEW, 5,
 					  clk_skews, 2);
-- 
2.26.0

