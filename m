Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C20427FFED
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbgJANUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:20:55 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:1530
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731993AbgJANUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 09:20:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OV/IPc5NmonPLSEL8/JYnHAqjZg24HOL6eQ9yhsN+WtyNhUtNDyoNlMhTgHE3k+R2rFnI2WaozxzUxr/wUU95gUbBUHoVRvpDB1lVk9cK4k37J0EpbGtnvX2AddByan0nM2dUhLi/p4JT4fm+yPN8TY5dLqiYeMt2lkQozQgENlTk8Tf66Pbeca4GgoGmn3wNMHuo/yl9KK/CjNXJKrhi7Yx7cOqVa6s6yl7A6SabX0uRC6ip6eiPjt5oN+k60fZfOvgfd8bidM2ZTZjrHMs13zEVG3nhct6Dr9afOCULxXu4d+LQbf4flqIxpu3i/Lov7l9T1aDEstesQ4jmCcgBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Refz6xWjsnu07/TZ2DAFn8k1Mzfxvzx9uLSy8+yuybE=;
 b=bw75R27ZrMAKECbJ9NCALe6AW88a3T15lT3BjWlO7gNKo0S3mkgetCe2dP21jpnaipGhUfZ/zy/SdT4shDJS6lPtHEz5znXA89KgurMesbdLdhJQRoeZwkEunWHmSUDrgKF7avxarpMMOcSgpfWudqYleStC6vIMZeZR7nsaMG2Ty0ReIhn5gZsXJp1qEihVM2voYzbYatmo3X2QfoVQAXXI7oqrhWEK1emL+oQP+C1q5o57xm81aiQ/St60Bli7/Msmh/NO9I3+O3WORLZiOPQtG5A5tADT0QYe1U+kyBtD+OGtZd2sJ16y/iakM/vq9IWPruUS2AUV5qnHgkOcvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Refz6xWjsnu07/TZ2DAFn8k1Mzfxvzx9uLSy8+yuybE=;
 b=WHaNh3NUS48JE08zCooQRCv04HUsjuGtN83kLQ3qAOK28qNQJqKzuJHb7fm7iZXSOTp6dkke+uShZ7R80drC+ggt1XeY8PLrcXXPohNyBEPhol8g9PcBpVDEnP2SYa14IGUa0ymph1PMLgZZEolA9x8h42neG1FD1YDJt/UZee8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Thu, 1 Oct
 2020 13:20:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 13:20:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, andrew@lunn.ch
Subject: [PATCH v3 devicetree 2/2] powerpc: dts: t1040rdb: add ports for Seville Ethernet switch
Date:   Thu,  1 Oct 2020 16:20:13 +0300
Message-Id: <20201001132013.1866299-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201001132013.1866299-1-vladimir.oltean@nxp.com>
References: <20201001132013.1866299-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR09CA0064.eurprd09.prod.outlook.com
 (2603:10a6:802:28::32) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR09CA0064.eurprd09.prod.outlook.com (2603:10a6:802:28::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Thu, 1 Oct 2020 13:20:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d0fa78ee-c896-4451-94f1-08d8660ccaa8
X-MS-TrafficTypeDiagnostic: VE1PR04MB7374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7374FABA698EF62D45ECF3BEE0300@VE1PR04MB7374.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PGkATylz69ms2ppTvZnxFkweF2RjuzY2h3OERp0Q1tsXdVIwmJVHMF4UJUjWx/acDXYiqCHy1Bmom/e1jTaICOGirrSaltwpZCrIaZkl/lL2pr9Un8aTIAEG5wCZ9NC+PB98rQoHGk299PlpWRaId9y9xlB4Th1YnVTJwL+S0jLtMfqKjlNkWVTdQCqRqKgd3FnYk+SEY+TmrUP5rzbmM5Z7NG3nS9oTu5LFTsHDrDrGVlhCZBcFUxDrvrzQedRTVSpOoKIZA1jtYsrzBt+xNsBQUVaY8lMhgzfQe8wZOCmRhxipVpUvzmxvxhvfiRTjbO8p37nSb4tkh7lfyVIQJOXpgRSC7lfF3v4cMJ/F0LR1vVgTt5kKKyEmW1Lj/NAuBkEeUjZcDhLxdT6xKF2D49OnjEI939kojA+iERrm8BpmC84HKQHWt2Qf1oNv62a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(5660300002)(83380400001)(8936002)(316002)(6512007)(26005)(6666004)(6486002)(2906002)(66946007)(66556008)(86362001)(66476007)(8676002)(1076003)(7416002)(6506007)(52116002)(69590400008)(956004)(186003)(44832011)(478600001)(2616005)(4326008)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AXaiFhCFAORAvFqR9yITCX2ONBM1NaQYyYKLZSFhtdtTfAbJK1bNMUHsbcOTut5KDdLLUw4kfy/i3QHz0BdchMjO++CAqcuqN0+/6haS4/vhrVscY6ikNN4wMRyTx7tRoLDADU+KSQlRs49oWbZdVyn2/r3pKVKyfO9OoO/uQNxx0moYzqjg+k7KuKA42/sQWnmiefSUmwYEPOXyF6260i+DXyaA8jQx7XepnYHtLcZ7Lf8rbMt4LdOQUuWp/XsKYL2m9/sbRHybraHP/b/S6J1sNjM5anjbDMXnWVAR9Q3No+bCqwJf4ImsriaeO4v6ciHuflFL8lTwxJrhczNbRv+XShm1AnrKh3CIWozBf0ZCwKJOHyv6lApfkeHLnSCxzA9uljKlLa8lIQgSy14eWGPS8JLghFyEK/HcuSdJt8bU9iOMa8YEIpXjJIWNWupLlRdICuE1SUnI+ZzB3jccl/w9o4OBIFFnHAoICSWfcal8QUDu81XpBB5WLvC7Yw2T8Loa7KzIYmxOZcxF7fXFRmj0tBZ9/f3lMbm2rvh4GNYyU+ryuZEA/zVvUyjPs2vd/A9e7Gny9o4ELP2B+NAXNfpJl8FAL3t0C6i3a7kUF85hLNp8S7l+51Bee+oRbrAYoDxbQe0ipVvxhM/x81jh9w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0fa78ee-c896-4451-94f1-08d8660ccaa8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 13:20:40.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UslRyUHzCXW2M1VA2jKT5x92bKNWiHA8ohcds2sXe+VQT21duwIeVxOR1TMlN7q/D6YZTm1xms7vhN2Dh0WeHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the network interface names for the switch ports and hook them up
to the 2 QSGMII PHYs that are onboard.

A conscious decision was taken to go along with the numbers that are
written on the front panel of the board and not with the hardware
numbers of the switch chip ports. The 2 numbering schemes are
shifted by 8.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
---
Changes in v3:
Renamed interfaces from swpN to ETHN, as per Andrew Lunn's suggestion.

Changes in v2:
Use the existing way of accessing the mdio bus and not labels.

 arch/powerpc/boot/dts/fsl/t1040rdb.dts | 107 +++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb.dts b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
index 65ff34c49025..e4067f3d2980 100644
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
+	label = "ETH4";
+	status = "okay";
+};
+
+&seville_port1 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_1>;
+	phy-mode = "qsgmii";
+	label = "ETH5";
+	status = "okay";
+};
+
+&seville_port2 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_2>;
+	phy-mode = "qsgmii";
+	label = "ETH6";
+	status = "okay";
+};
+
+&seville_port3 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_3>;
+	phy-mode = "qsgmii";
+	label = "ETH7";
+	status = "okay";
+};
+
+&seville_port4 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_4>;
+	phy-mode = "qsgmii";
+	label = "ETH8";
+	status = "okay";
+};
+
+&seville_port5 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_5>;
+	phy-mode = "qsgmii";
+	label = "ETH9";
+	status = "okay";
+};
+
+&seville_port6 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_6>;
+	phy-mode = "qsgmii";
+	label = "ETH10";
+	status = "okay";
+};
+
+&seville_port7 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_7>;
+	phy-mode = "qsgmii";
+	label = "ETH11";
+	status = "okay";
+};
+
+&seville_port8 {
+	ethernet = <&enet0>;
+	status = "okay";
+};
-- 
2.25.1

