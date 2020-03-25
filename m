Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FA7192F64
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgCYRej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:34:39 -0400
Received: from mail-vi1eur05on2093.outbound.protection.outlook.com ([40.107.21.93]:44928
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727826AbgCYRei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 13:34:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxmLHBrAQ76p5JSnfhAO4SEVp0a4OjLQTmGEjSXCwKUVCh6doOoOCWTYnWYpbHqNc+4/W4G3MKDCNO/kyFPgOWqGI7+6o4IMXQbKk3B/fdsySMiSQ8TmtJo1d4Ep1cp0jwNLUNoXauXyW6avZthSy+tpUt1G0oyZZNOHi9RFWYuYhEh1xpA22+kM3eU7lEq9UxoUekCs6by1MQ/p0cMN6VJqerxqd3bFwubONKKfM9RbNkFkyV2UPnnPP9aem6GDK7VwsLPCMr0Q/kUoR0msMCywrWrEmEKXLQv+r2ZfzKd8N4KvbgpzMApe1wfQtbsMJCoUWbqiyyytMyGxB5nkBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjvHwBGRxFK+ntY1V+/Z1SBhak1VnHXEBM3TshTQBqo=;
 b=R3bsEW+yBr0lxeI+n5McypBxsRKPS0HH/hdXHAdP4aIJCt+uIPAZD6B6//MttNxS2T6BIQQl+dXrYaEI0723PdatyT5v75WteX63XqlKWdSjyL5gZgZHYr3oYfxBHV0JergJzF5cQimzKLjtFOR173KHxuWCkh9v6NexQwJTSTZrFu2PdH+HCRLludt9Di8DFryRr8ciFi7ZNLvUIymVMUwLsSbwqOKKmmLRIhiK6+k6sd2240H8dcas2v60JawTQB2IEzochpLD9nvI2dhzXGILpU8eQH2VDz8/U0lJfwAzAXR/M/vwM1Nw/V4qIZIUvI/M7yI0IegDff2h/3tQKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjvHwBGRxFK+ntY1V+/Z1SBhak1VnHXEBM3TshTQBqo=;
 b=aLWjosbURosEzHQdzoX8MDDUtih7TLsHk3oevVIKKY2ftbjpERvTU9VFz09YAxjSmMjGkkwX4j3/b1etC5eWXOYUoFJz15Bn0a/dDzhefzBH5IK5uGiEkkRTSQ5VC8cMWD4intn5ke9BzQYAVTp+XE0Pm4mmK3uFGoAwE94dwRE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=philippe.schenker@toradex.com; 
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (20.179.1.217) by
 AM6PR05MB4872.eurprd05.prod.outlook.com (20.177.35.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Wed, 25 Mar 2020 17:34:34 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e%4]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 17:34:34 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        mark.rutland@arm.com
Cc:     linux-kernel@vger.kernel.org, silvan.murer@gmail.com,
        a.fatoum@pengutronix.de, s.hauer@pengutronix.de,
        o.rempel@pengutronix.de,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2 1/2] net: phy: micrel.c: add rgmii interface delay possibility to ksz9131
Date:   Wed, 25 Mar 2020 18:34:24 +0100
Message-Id: <20200325173425.306802-1-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.26.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::11) To AM6PR05MB6120.eurprd05.prod.outlook.com
 (2603:10a6:20b:a8::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from philippe-pc.toradex.int (31.10.206.125) by ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Wed, 25 Mar 2020 17:34:33 +0000
X-Mailer: git-send-email 2.26.0
X-Originating-IP: [31.10.206.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 071784bd-ed96-477d-f729-08d7d0e2c871
X-MS-TrafficTypeDiagnostic: AM6PR05MB4872:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4872FA7E6D4F35737922023AF4CE0@AM6PR05MB4872.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(39850400004)(396003)(366004)(346002)(81166006)(8936002)(8676002)(6486002)(16526019)(2906002)(186003)(7416002)(478600001)(86362001)(66556008)(6666004)(66476007)(66946007)(956004)(44832011)(81156014)(2616005)(5660300002)(1076003)(316002)(52116002)(6512007)(54906003)(4326008)(26005)(36756003)(6506007)(16060500001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB4872;H:AM6PR05MB6120.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J1H01iw5wQNNsEyS9SLAeGNLoTaXpQjrf1wMag3FjXgXumwQrIR1/xB61XdnmXzuUCWj34rAc8bF8iwFwzSgsTCgEawBXMT63Xr2Tg/4DDXRtEz+cEVx4ZAEXT5T/gqGwtENGighVQUQMCP3b+T1ARdCLVW26Ge3/fnGfDv4CKemGBAps1mis45o9Hin1q9qtvNTwSS8aZ+TUpvmk9dMnEfnFs4LW71IkZgrGnr1ineZSHHJShZmDP7QnuXNDMWc2OxGkBJgTCvsbc1Ej4HzzZVOf/1BdKlRGjGqpr7lkrGHNtImEE+Hc/6CSF02jx5LD8Kon592ntRvvmvHRIdmGJMlt1lZv09znWOHmwwlCKVDA9KtkvgETb7Fvrk9CU2Kz9UaAfVmz53pX8TMM4C2ZwxBGY+3UMAUD7WUHT2sDMFWOYHDuGsxfg4uKXOKz1asNknNPEqDuruO7xXcc57OiyjEQTVkbWxFZ41W0WB5B/NxF30lTzKPJaDh7ojMCcnE
X-MS-Exchange-AntiSpam-MessageData: PYZJ6/aGmpPWKSn0Cy8YtnsBjzT5CPuIbfeDL3ppBsZODxtFa1sPBp6J46K1xEFN9SXBu6OdlIOr/qTqyF/owpJk5Q8RkQ97NF8utwsWFq3TyYci8nkEgeK8+r3Poj9wJtpbPLI5E1ApIHkVa9zCSA==
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 071784bd-ed96-477d-f729-08d7d0e2c871
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 17:34:34.1901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJzvA8lMkc6FAwBAQr+Zd+mrAQUNwVxuqwvX2VeNE9FG1sKR0oGH+kQQuxTSG/RpmLSkgEa4OZP1yc3izm4Ji/xFA6oOft1B0/lCr/s//LQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4872
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

Changes in v2:
- Use phy_modify_mmd instead of phy_modify_mmd_changed
- Use define for MMD Address instead of a comment
- Check return value of the newly added function

 drivers/net/phy/micrel.c | 50 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 63dedec0433d..2ec19e5540bf 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -704,6 +704,50 @@ static int ksz9131_of_load_skew_values(struct phy_device *phydev,
 	return phy_write_mmd(phydev, 2, reg, newval);
 }
 
+#define KSZ9131RN_MMD_COMMON_CTRL_REG	2
+#define KSZ9131RN_RXC_DLL_CTRL		76
+#define KSZ9131RN_TXC_DLL_CTRL		77
+#define KSZ9131RN_DLL_CTRL_BYPASS	BIT_MASK(12)
+#define KSZ9131RN_DLL_ENABLE_DELAY	0
+#define KSZ9131RN_DLL_DISABLE_DELAY	BIT(12)
+
+static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
+{
+	u16 rxcdll_val, txcdll_val;
+	int ret;
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
+	ret = phy_modify_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+			     KSZ9131RN_RXC_DLL_CTRL, KSZ9131RN_DLL_CTRL_BYPASS,
+			     rxcdll_val);
+	if (ret < 0)
+		return ret;
+
+	return phy_modify_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+			      KSZ9131RN_TXC_DLL_CTRL, KSZ9131RN_DLL_CTRL_BYPASS,
+			      txcdll_val);
+}
+
 static int ksz9131_config_init(struct phy_device *phydev)
 {
 	const struct device *dev = &phydev->mdio.dev;
@@ -730,6 +774,12 @@ static int ksz9131_config_init(struct phy_device *phydev)
 	if (!of_node)
 		return 0;
 
+	if (phy_interface_is_rgmii(phydev)) {
+		ret = ksz9131_config_rgmii_delay(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = ksz9131_of_load_skew_values(phydev, of_node,
 					  MII_KSZ9031RN_CLK_PAD_SKEW, 5,
 					  clk_skews, 2);
-- 
2.26.0

