Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D0827C553
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 13:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgI2LeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 07:34:18 -0400
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:7136
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729564AbgI2Ld3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Reqcky3FzGc8PhDNXif/xczpugQouTMmw4ynix/7kCQbOH6ahInWS2QTRmhN/rYP36i3gmpE2rqqDz7gKux2r2SpQp5INZnb/OTVNSp2keTX9KJnQ8AF81/PF/dur3ntimGJb/7MGF162DbAJ+sSgTqgcy3wTrycXZcXRn6X9WNqrKOr+o3dL1kkC8PwsKrX6tGqWXoAsoEUMbWECeaTZ4FbI1aQHFp3RlS9rZX6C9WVIp2iC9UI489MlOOmKvNZAHykzG0aD8BxuFB5oNykxzDi0MCydBaHwSb9qaX2XWpiKA72+kdVmKLAZ6+jKKT/Y7h5jS+m7+EquzWTdglX3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDj2atOl0im16itVrLLdeKpTlXAVvCK71oypg+vqzNU=;
 b=fd5S7HWXjMhZ+J9SEL5nTOOb7nwuyqchMO3weSVH7nmcBMa+sdj2W52z4H3bXpwKxfHhJoR4x3af68tUwjZ2Pgo0FWzpy9SPxyuDCK7l04IuStcG0KWICIdvchuX9TrR4Mvfb0AOAIvY2ewzpuUEh52LCDo33o4yUZI5UxrY+hrppTLc7lMW0YN4eMtFnGntxy6+WgZHSJ55BafGlLYezKxPHf/cdvnwrUnL/9Tz+KqrNLJa3prniwDIT16TUvrxQgLfga2IrguLPh5mVG/43b1fDCe/X0YWyDaP4cbYuD3AOvX1/Upm6fZdbUD6/cXw+8N5r+fqL6/56KQVuieglA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDj2atOl0im16itVrLLdeKpTlXAVvCK71oypg+vqzNU=;
 b=Q15nMGQb4ZBIBiVupSeDR65VEUSMSzPxorULk9DNBZbmVoQrzBm52PQAXQWmJzbMYzNK64aMf+RnUh8EHgam5zgg3GgCtax9lostiETuYKdZrY2AwaQvQCRMm3QxZneSIPRnlff0FxtrCeaGjgIW5yNz57+orgXNFAcNNdDVzio=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 11:32:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 11:32:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 devicetree 2/2] powerpc: dts: t1040rdb: add ports for Seville Ethernet switch
Date:   Tue, 29 Sep 2020 14:32:09 +0300
Message-Id: <20200929113209.3767787-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
References: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR05CA0008.eurprd05.prod.outlook.com (2603:10a6:205::21)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR05CA0008.eurprd05.prod.outlook.com (2603:10a6:205::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 11:32:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7399e800-0784-4a35-826d-08d8646b5543
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504DEEFB635C7AE60F643D5E0320@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kx4jLjWqz1u6NV1xi5YWeCLXc2bOXihbffNnL0WEehxJAA5LlIgJyQQONo0vquATkKRlGvPBNYnNseLFzMs35GEmqsVb6SCyGeRmsQB83uPo2F+6TEUPlaZYUSS6Jj6DQEFjBXhr+hyCOgSaPN6+IGmE184df6B1Sefsa6jUsN1HHIKQSzAV8Cnh4fg9Xcvk3nhL0T768ZA59F1qBHE31R8Aqnk0LYe6rio4suOM+SaN5acvyWMcP3iQosri1xkVhHxD5tnRLgKkmA1J3V3CRnJVW5scJ3+DIO3dMIb3P6hC38a8JoD7YZtNiGYrS7LWj6pL7rEGm7EdyliXO9igR/kc9h1GkHjao1N65qXAKtG2kap7uHeidu2kfDNj9Uel12zTnfMBEzsF3WkDm4rkreKL7lqmKJfIF3ucceCqTUT1z53rTaRCQMVV6exSymaI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(36756003)(66476007)(66946007)(66556008)(1076003)(6512007)(69590400008)(44832011)(83380400001)(2616005)(6666004)(6486002)(26005)(4326008)(956004)(52116002)(86362001)(186003)(8936002)(16526019)(2906002)(7416002)(6506007)(8676002)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rhlHLVAf+c8dN5D6a3rDcOvCp9YVR4z1ofYoOmccB2G5eM79L6skwnwVnTb1AYJWIjqcml6Eld4fOroBRMUkQ2GykSngM8renKt40LJ/rOHBeOFieFGFfayT7Kp8Fp1slI0OgKh9IIHPt/01XHtC487x4ft4+/+8LEPgsdOBsInTk3plZzopSbL182dQCgT1+YTLJXJ52jJR7odVI4UzcLOt8HsNFxf5mL61KPykdWgEoCvudRpGnBhvmVbyyAbLlri4ae0RlKhsQ9+mCRsBRDnFAXHjJKxQD5QKftkTYHj6lrpkdjEUZ20RJmzuBIKuXtsyqqC8NCEqHy2/Ku4bFU6kAUltWP6UZtfN8mqdoiYIcTAiKpSGFOxyRxV22lBYbTBxp+0Ps75oKxkNtDsnk/9hoj6iPX9mHrYgi1wTKW9QuEgTC2PnpDc6khcp7yAmygYgBfh7JQ390/EYyCIVuqWDP/pDm0OWAmlffCLEqUDQhMz3Ar+WShQahyk37LGc0ZcmeqAHB7n9qTNoSZWPegF8jv1GLZBSKGbaVMyx8bwV0uUU8Sj/4fJe/z3wjq+EjMyzePFpMShNzIh5DaONJa2qnafJA+T9JW0Sc8gUQF1sdtrwevpnUQDIgTihdPWZyJjwwR405pEQCe4p074+EQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7399e800-0784-4a35-826d-08d8646b5543
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 11:32:22.9649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vIlkU+GoZ3SPfn3f12U5lgzMdptWnQ3T162NaQTc3WRYNNZ7Wqu2psRHnoHeGynu0sRoDrEReErbKLda3hGzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

Define the network interface names for the switch ports and hook them up
to the 2 QSGMII PHYs that are onboard.

A conscious decision was taken to go along with the numbers that are
written on the front panel of the board and not with the hardware
numbers of the switch chip ports. The 2 numbering schemes are
shifted by 8.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Use the existing way of accessing the mdio bus and not labels.

 arch/powerpc/boot/dts/fsl/t1040rdb.dts | 115 +++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb.dts b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
index 65ff34c49025..3fd08a2b6dcb 100644
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
@@ -76,3 +110,84 @@ cpld@3,0 {
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
+	/* ETH4 written on chassis */
+	label = "swp4";
+	status = "okay";
+};
+
+&seville_port1 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_1>;
+	phy-mode = "qsgmii";
+	/* ETH5 written on chassis */
+	label = "swp5";
+	status = "okay";
+};
+
+&seville_port2 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_2>;
+	phy-mode = "qsgmii";
+	/* ETH6 written on chassis */
+	label = "swp6";
+	status = "okay";
+};
+
+&seville_port3 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_3>;
+	phy-mode = "qsgmii";
+	/* ETH7 written on chassis */
+	label = "swp7";
+	status = "okay";
+};
+
+&seville_port4 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_4>;
+	phy-mode = "qsgmii";
+	/* ETH8 written on chassis */
+	label = "swp8";
+	status = "okay";
+};
+
+&seville_port5 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_5>;
+	phy-mode = "qsgmii";
+	/* ETH9 written on chassis */
+	label = "swp9";
+	status = "okay";
+};
+
+&seville_port6 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_6>;
+	phy-mode = "qsgmii";
+	/* ETH10 written on chassis */
+	label = "swp10";
+	status = "okay";
+};
+
+&seville_port7 {
+	managed = "in-band-status";
+	phy-handle = <&phy_qsgmii_7>;
+	phy-mode = "qsgmii";
+	/* ETH11 written on chassis */
+	label = "swp11";
+	status = "okay";
+};
+
+&seville_port8 {
+	ethernet = <&enet0>;
+	status = "okay";
+};
-- 
2.25.1

