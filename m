Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642F228144E
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbgJBNli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 09:41:38 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:28292
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387877AbgJBNld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 09:41:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7GtfHWlHJHXD2BVFb/TsSfx9Wup0oh1bjHORUgyrneG/fbEKAkry0dJt+DkbEL4NENdg4OpwdGYMnOJ7kbSrifj9p2OopINteW4Q6Z2EqPjPHoKiJiO0PNojKwTr5hJvXgi+tiglp8KTn1yxXw/o4iD5hTSfjdGe9+civf7Yc2rO7aG2t3L2UCLsceDdl0ZqtH5QXdZwOwU5wRfjKm06fiPzgipXOjhEldb90qLuLrzH0Uac9Ev2xvb9aBFeXfKl7nATPWMvWV45rjE/Dzlx8VIM+1BxC9DdhCixobV8HBt+II6FwFZZbdYXvJFqce0vlzg2ABjH36kqH+Mm/FSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3TI/k5/fdSU368AU+zsDWNX47pj9vwRTVef/kxRHas=;
 b=ELqAOAH8OxpRh7EtDcof5v48Ydk7uKkf1EnDvGMudturo4dYrdA/HRDKxQRtLzgPT2v8BBOEOCghE4++PvFGRFk8UZ3iPlPJJygIRh4r3R1V6AKqro4Whd8lP/kyHd+fHvb8EYx9Z/WfHuQE8oI4LstyFaY0QFgOAr4IYphmTsI9EdcAAjCkjKEVWbeuv0ABng+CWGs+ClrTAGlfSLFOe+pLfsI89qJ/LuM9NWp/ENmhBavVFwZ4Z7dnbgA5X2GIndDLYxe5BBpmV8psfxLVvTSVQ/fghIPlGgW3svoTACyD04rGaXQ+8SX7+vnLX9A9ohEICA6Yq4Lw4JYxnBnqfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3TI/k5/fdSU368AU+zsDWNX47pj9vwRTVef/kxRHas=;
 b=cvQGOtwZvXIMfIxfVEtRebYd5AKzmhQZb7kDtKgheOVToQceMwgWLkeqTgcfSoxPZkDMCW0LFb7rsFX/EXcmw9+3sxnnfeTeHnPI1LQUoGH14os+EG4+LV+fbU3lGV0jbKcsb4+a6MI/MVTi3HcQueqcFIxqoEjY/qX51IUKzwo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 2 Oct
 2020 13:41:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 13:41:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, andrew@lunn.ch
Subject: [PATCH v4 net-next 2/2] powerpc: dts: t1040rdb: add ports for Seville Ethernet switch
Date:   Fri,  2 Oct 2020 16:41:06 +0300
Message-Id: <20201002134106.3485970-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002134106.3485970-1-vladimir.oltean@nxp.com>
References: <20201002134106.3485970-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR10CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR10CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Fri, 2 Oct 2020 13:41:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9fb25651-fb6d-4b9f-867a-08d866d8dcac
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2304DCEB7E2046F7A029F9F4E0310@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEbwXrVWL+iZr5n3o078zxstbDOzHT2sqhpRvcT5VLr2lXXsjsKFG75/TbADcOJX8Tp/igxHOkjs/+cqHfcuBX6WrHtv5UGTGQlGNXDjsq6574tT5BUVJHAnW0vKD4xd5b9rxZK8fjWgwZMDNLJEm06muy5+b5t4ou2C92hiO5JWK+TRmiXGJCG5VvK1UR+R2DqVvz6W6t6LKqzahrj+V8END5O6LIZgbHNSODsvYoCBoc+BRWMAvP1h1XUJtHiayMQoPp+TFJ8hemP29udBpHjqWMS4MoD+KrGEZ8J3Lz+y/flDNgzWMsT6g2xU+qP7b1BfS/nA9mkYbM4pARgnmZ6i3DogvfshDvgWSoWqFV9dqyXeHpcYH+HMH/+ZzsR8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(7416002)(2616005)(956004)(26005)(83380400001)(478600001)(186003)(36756003)(69590400008)(316002)(2906002)(16526019)(6512007)(4326008)(86362001)(44832011)(6506007)(1076003)(8676002)(6666004)(52116002)(66556008)(5660300002)(66946007)(66476007)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /jl+udZwVaqSNtwTZvY2nTP0ypvzNOP62vNyyFNnbpci3SSEv6QNAz7eKSMqIuxQSMkOEBT0vaKRUseWIiKnFpSRzyBIctq0LoMWHFrp5Mj+PXfjH4eo14AnP+NJ0qiQVlML4FN9hgzmWZTnTirwlV5N+ppTrQCfatFxPtvNj6p2EDYo/QHo6KWVd7QAdsT5bVIYN8YaLpwGmU954gUfKraO5gXZndrbz4R3fUCWexn3C917R3xTohUIlYyLN5EFFbR7SZBxYTpI+y6lg/WRD6QEePHfuvtkrQIChATWzW6rpT2nmVgsrQoDhR1Ge8zUJT9vAss9jCfEpBKB//RAooZeNeSr1tWjMQlPjKDu4Z9jasMnDbU70SdS63puGJ8vdN1NGNg2neIkACgg+R73SnrfAhxpAcmsTd+3dsulmQsXDdCqRvHWRY9yhPsV4nzZJRLJxWbHlG9F4ezSjLayCEmSgMtOBijxp0BCyVCLldlt6BXSuIdFj/Z5eLkXAXg+IoHZAXHwMcLfU+doNZnK1SwFu/eQ3TTsNf+ZW1u+bTzfVhQsz4L6zxg+pK5kfdV2ZYaJWZ5EvBNQpKtjfhxh7gtv6/g/jSpEWhgn61MR8tcOQFV6ZLm5olRfC+sTv2HY1ZtN+y+Wg55JJYIatWJdHA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb25651-fb6d-4b9f-867a-08d866d8dcac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 13:41:27.7786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p05QyIrMZtLNSgiSOh923CJuLexV4B4nNo21uoANVEp+sBF92v2hxV+YKfgGe6qWb/vna3bGM5+UScyrC/kboQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the network interface names for the switch ports and hook them up
to the 2 QSGMII PHYs that are onboard.

A conscious decision was taken to go along with the numbers that are
written on the front panel of the board and not with the hardware
numbers of the switch chip ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
- Retargeted to net-next.
- Fixed the port labels (ETH5 was ETH4, ETH7 was ETH6, ETH9 was ETH8,
  ETH11 was ETH10).

Changes in v3:
Renamed interfaces from swpN to ETHN, as per Andrew Lunn's suggestion.

Changes in v2:
Use the existing way of accessing the mdio bus and not labels.

 arch/powerpc/boot/dts/fsl/t1040rdb.dts | 107 +++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb.dts b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
index 65ff34c49025..af0c8a6f5613 100644
--- a/arch/powerpc/boot/dts/fsl/t1040rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
@@ -64,6 +64,40 @@ mdio@fc000 {
 				phy_sgmii_2: ethernet-phy@3 {
 					reg = <0x03>;
 				};
+
+				/* VSC8514 QSGMII PHY */
+				phy_qsgmii_0: ethernet-phy@4 {
+					reg = <0x4>;
+				};
+
+				phy_qsgmii_1: ethernet-phy@5 {
+					reg = <0x5>;
+				};
+
+				phy_qsgmii_2: ethernet-phy@6 {
+					reg = <0x6>;
+				};
+
+				phy_qsgmii_3: ethernet-phy@7 {
+					reg = <0x7>;
+				};
+
+				/* VSC8514 QSGMII PHY */
+				phy_qsgmii_4: ethernet-phy@8 {
+					reg = <0x8>;
+				};
+
+				phy_qsgmii_5: ethernet-phy@9 {
+					reg = <0x9>;
+				};
+
+				phy_qsgmii_6: ethernet-phy@a {
+					reg = <0xa>;
+				};
+
+				phy_qsgmii_7: ethernet-phy@b {
+					reg = <0xb>;
+				};
 			};
 		};
 	};
@@ -76,3 +110,76 @@ cpld@3,0 {
 };
 
 #include "t1040si-post.dtsi"
+
+&seville_switch {
+	status = "okay";
+};
+
+&seville_port0 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_0>;
+	phy-mode = "qsgmii";
+	label = "ETH5";
+	status = "okay";
+};
+
+&seville_port1 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_1>;
+	phy-mode = "qsgmii";
+	label = "ETH4";
+	status = "okay";
+};
+
+&seville_port2 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_2>;
+	phy-mode = "qsgmii";
+	label = "ETH7";
+	status = "okay";
+};
+
+&seville_port3 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_3>;
+	phy-mode = "qsgmii";
+	label = "ETH6";
+	status = "okay";
+};
+
+&seville_port4 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_4>;
+	phy-mode = "qsgmii";
+	label = "ETH9";
+	status = "okay";
+};
+
+&seville_port5 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_5>;
+	phy-mode = "qsgmii";
+	label = "ETH8";
+	status = "okay";
+};
+
+&seville_port6 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_6>;
+	phy-mode = "qsgmii";
+	label = "ETH11";
+	status = "okay";
+};
+
+&seville_port7 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_7>;
+	phy-mode = "qsgmii";
+	label = "ETH10";
+	status = "okay";
+};
+
+&seville_port8 {
+	ethernet = <&enet0>;
+	status = "okay";
+};
-- 
2.25.1

