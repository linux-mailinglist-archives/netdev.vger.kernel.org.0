Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D57327C1A
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhCAK2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:28:17 -0500
Received: from mail-am6eur05on2075.outbound.protection.outlook.com ([40.107.22.75]:45056
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234359AbhCAK1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 05:27:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvltnSwUE0ZzyS3Pnrs0E2Uu5As8AHFso1gVru/XNA3tyh10QYJ+3NBnBdpghisOvn4oedYVRBwXGuNByCsx1Q6tvOjEaXJltnl2kQMJUJer5GGnfJ+xyhvmpXvNPJan8LyU6uPly3yuWKzNMHXgrtBNScJBIyojv1VvgP+LwzykFH2ok8Q7sFaRWuQ225GYETRU0b4MKtU1/13Z7zpy9nCvu5ybky8pGVQSeCaJhq3+1Vryz4jCGBuhPKdzwj425Q7YAnTXrVyDxyJQ07kSgdgkPxPG4/+DZtDnJdofbUOFmkSqYpDleNijfjNmJMuFPWDNxZBVtE4Kl6Kv9QC5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRYrrDDiGe4l9VJ3X+XpaO71UTe9l69v2sCjPWw2Jew=;
 b=Str7UynqwvpIO7Ch55zxZOmsMUIBc1F3Z7aRaluTVgmDrJY/qyK2JkaLJmo1w4ECD3HH2GJdLPHx/QzjVLJNSwwaDKu0fSpKb9bDCGzMzWjdr++adArjXjHumwz8tZMYcl8+wk3ALW/2mw4JyRzUjkj5J1vaKlrTop1I0h22Gxc/PGFCqLG+fnm+0/cA0CxUAUHS8ENUUh7ODcts4ZqIMUT5EJprj8OlacK6K236U9HL2jY14CSTkEQIYtfL6pQI2+4fPNcX7XgphlVlqstTTLFthL1p18tOXqYrUvQxtE//UamUjISXF+ITB4R3kNHLSgkqRB0t21rXMTZSmYc7+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRYrrDDiGe4l9VJ3X+XpaO71UTe9l69v2sCjPWw2Jew=;
 b=dR/5vyu/EQ0hyCAcy0tzWZTkAgKs1dSFvmXp/RLMi8GS/WusooCSibQxQ32zzVoRcLsYERINz6LFVC63QZ6/50U/YXFoXzbvUE+6sR0/QzwkGDAyXfYU6pmTvd8NYaz0jjTIlsLujP8TB04nPQ8wWdwI/c0vL3lZFftm0gacwuk=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Mon, 1 Mar
 2021 10:25:20 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 10:25:20 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [RFC V2 resend net-next 2/3] net: stmmac: add platform level clocks management
Date:   Mon,  1 Mar 2021 18:25:28 +0800
Message-Id: <20210301102529.18573-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
References: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0045.apcprd04.prod.outlook.com
 (2603:1096:202:14::13) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0045.apcprd04.prod.outlook.com (2603:1096:202:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Mon, 1 Mar 2021 10:25:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5614f12-6281-4daa-10f6-08d8dc9c50a7
X-MS-TrafficTypeDiagnostic: DB7PR04MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB49531637BDA80A28A58AB8FEE69A9@DB7PR04MB4953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 28phTNNN2LXGOze28pjgJ+sIuimlg5rPSRiIv2defedyQ66rpzzu0TnO+aV+m3fz7cDQci6eICFVeKjFBtjuVcl/0NkRNe59yieabWtbvZf1IYutKZ5xQWwADnFayN/wI85FaCoxyzye5hwt5gCYZr3jx9VQKX+DqxsLn8x0be0m2AwnFfgvHbOpf4HScUef6kcZGfTq9x4avWvhZTmvm5ix98LNyPjEiSkAvXyVpUCjUEE2nCuiCShok5M8ts5hMjXHKZoI37UznfCgz7n+SnrpnLIOIBGQhPOHmAYbbLfwRr2orYVx4ZJLYGn87BBtgL/1sjnCxt/hUggd9U3l8L69wUV5ngGEqK9ebh6Yn5FsFzw0sHTxmO+f6XBYEPXh08vHiYkuMyeLiUrV5pC4WTiwDvXASbcnpFCp0GjVc17HuOHuhOtEmIEphsKULQvvBkmoYizUrivHqJCMBHryQ2ryk+OjY3oV30bfS5NsyftJ0658JbdC/Ni4nYC86Oj/xSBVZTbSVXm4xGNLOQf5TmU/CTwyONVlzZf/iPhl2BTyQvyQMN43387UpikGgSgdoGRYhzcGQxtjyZ0zaJj6fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(5660300002)(6666004)(6512007)(2906002)(1076003)(86362001)(52116002)(6506007)(36756003)(478600001)(6486002)(26005)(69590400012)(186003)(66476007)(8676002)(316002)(16526019)(4326008)(2616005)(956004)(83380400001)(8936002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7l7mJHB/4lEWJO3KMQCNNaC91uiZ9be2RlUcJS9XG2KFFG7MgQAcNqclMOtX?=
 =?us-ascii?Q?57tLvUY7Vj7j+dOhlyagooWq6s2b//HnKz275xDTvBR1OEmKUan3+qpbhNYE?=
 =?us-ascii?Q?+4qigEK83IMNwzVCWIMoKSuf0jbXrUGjAgzS8bLUvTHzwD4p8fgS3Do9GoVH?=
 =?us-ascii?Q?V8TGixBe30er+QGdM3QRc2061WW5x54KejLcalPfqgOU3SmBgJsLhAbEQZRB?=
 =?us-ascii?Q?GzizF3bKQ+s9nw22Iy7zcbNAPWMqDbFA3rN5triS1dTFK3bNA7ZD78c1l551?=
 =?us-ascii?Q?WkzcgWx/BcOZ66A5G+QuZ9E27A325keZglEFFqkYtxbX2atPoNZAtgQvweVj?=
 =?us-ascii?Q?U3SSik1gTUG5nX1dIpfWukc3L5BhzffsB8yhD10J4DQKwSI15vbHrM5j85lj?=
 =?us-ascii?Q?i2eif1+I8Ta09oLakoh71Y0ka8QmkxtI7raL1pXNxsf5pA+KDomFLjs/LrNe?=
 =?us-ascii?Q?5YbHIZrhSyTqG6/wxHU5t1LY84dJT3RHqs8t+DlRmF/FrPe+V20DSdBKs01R?=
 =?us-ascii?Q?V3FKkYQeauO2W4eKsOz2w1oPvm0saZT47+ju6B4MDuEL1BHsfPjgk++2Tkb6?=
 =?us-ascii?Q?9lBAuKHWVrU4fE4yBVoRf5oc33e8s9tiYlf7NalPm+pQONOtlWYRBqlOFVNw?=
 =?us-ascii?Q?pbVeCFVmKlXx6FpiK4iPC27qkaVpM/f5gsf2HgSEViPlzkW0CQWIa1ym7u/6?=
 =?us-ascii?Q?vR3ogeBhn0D/E7Y1yv14SwecXkDBRAh9mqXy+O0H4eRqOXsvYNdn5pWPaU2Q?=
 =?us-ascii?Q?DVFwNsJY0QPZxsxgIaPVLwCIAiF/tjFXfuDvi0KdZEJg9sMczufkGLzZvtCr?=
 =?us-ascii?Q?AWFWNKPIE725Y13ZTCvoKyp5PcHxkeEGWygUzS/J6Ql8PT+Fv4+b2p9A/kEl?=
 =?us-ascii?Q?CBTQ1iBKv3H5SZVTrVJXcYIBEu9ur5KM2T9xLJNIe7rHMmsI1uwC0jg2AFi4?=
 =?us-ascii?Q?/8e4iCOZP0mTYoRUWr/44mZWMJ1nk7GQbbfqs/Xs/gYJkDdqVSztu4aRcBoD?=
 =?us-ascii?Q?cEuoQmezYQRpIHnwrUEqcLG8lp9Ysc6gsqZBHqJBSAdLe9DUxyLd905tX9Ky?=
 =?us-ascii?Q?9q3HYJBbNkjS3opI1C8jP5+bFCj2IN7HJ+Q2l7DMU/hNvhWNzlN7EzudWugN?=
 =?us-ascii?Q?QE/iCXB2xqVsyCYQLbU5vBwV3lkVQRVO8n3biAJ60Nvy7MqDcghTQYskPPI/?=
 =?us-ascii?Q?Hv1OSku9lgnwmxkl3c/Uj+doJ7R01ACDatrdK5KTYrGPo9TTr6x854CnDZNH?=
 =?us-ascii?Q?bqvepyDwfPvhjEpluP/OJKgX/pH6Q7/an1BPBGEV+5ykKZCQ6qE+o3lTg8k7?=
 =?us-ascii?Q?siaPx1FCfvqaBihqEG2Ie3wv?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5614f12-6281-4daa-10f6-08d8dc9c50a7
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 10:25:20.2664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qey6Bxn60DsPfohwqy2iQk6wCAXPP2bGMOrP7frmltz62onzHpOJB2BtOLyLDQb8o3ebBjuOQmE9KxPd0sOTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add platform level clocks management. Some
platforms may have their own special clocks, they also need to be
managed dynamically. If you want to manage such clocks, please implement
clks_config callback.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++++++
 include/linux/stmmac.h                            |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b4bc1c2104df..33b0783de270 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -127,9 +127,19 @@ int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled)
 			clk_disable_unprepare(priv->plat->stmmac_clk);
 			return ret;
 		}
+		if (priv->plat->clks_config) {
+			ret = priv->plat->clks_config(priv->plat->bsp_priv, enabled);
+			if (ret) {
+				clk_disable_unprepare(priv->plat->stmmac_clk);
+				clk_disable_unprepare(priv->plat->pclk);
+				return ret;
+			}
+		}
 	} else {
 		clk_disable_unprepare(priv->plat->stmmac_clk);
 		clk_disable_unprepare(priv->plat->pclk);
+		if (priv->plat->clks_config)
+			priv->plat->clks_config(priv->plat->bsp_priv, enabled);
 	}
 
 	return ret;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a302982de2d7..5ab2a8138149 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -183,6 +183,7 @@ struct plat_stmmacenet_data {
 	int (*init)(struct platform_device *pdev, void *priv);
 	void (*exit)(struct platform_device *pdev, void *priv);
 	struct mac_device_info *(*setup)(void *priv);
+	int (*clks_config)(void *priv, bool enabled);
 	void *bsp_priv;
 	struct clk *stmmac_clk;
 	struct clk *pclk;
-- 
2.17.1

