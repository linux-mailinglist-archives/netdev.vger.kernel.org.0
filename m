Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24A527FFEC
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732276AbgJANUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:20:47 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:1530
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732018AbgJANUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 09:20:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEfzA0dX0vu6XSZ1BmgEpVg6ZTHCQeo8AmtW4YEoHjWadcTY2Sz4glVbGzxVZMED58nqPwZPXByt2oDQZMeYkcRLtB82bMnQkwl0n2leNBNWB2tuCsGSOB9ZPaLSN0XocGKqPylz3KSDSEQw2h7gIxXcF1zNCGBfwtyaJdgrdC0jIsjgsaY/GWAt0zkZ+SMjxqH5lzv6pkMyMCV13msk4Uq41w9e2ISjH9fYNbFPCjJXnSwcEhP5gpUHVpYTBetV0pJ0rISEqd+sM4Ou1idYpBmBBRkt4VdWk+xk21P9nFgCoY5Wqe1H2Po8lUL7xH4HJI3xW1kIPt5nLYMgCQnDFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3/Xyq3rsfPktVd1WFC1eSvBi9kBb47rHAozahNZjt0=;
 b=WnKoYrWtGzluNT4tY0JCgN0M9ph1t4JWpgnebidNeOEeu/ZNrV6tH60xMzFAh6m5vEO5zcUJzxUXblyCBePlhRjLTk9csXL4eZmwdYfTtUOdOD0Y0TBiftVcn/HueT/JiKJdpkagXV+LGEeWegZn8nQPPWQ60QLOb38aLL0xoevl2I92HDY+nkD2kTdMcfcMxFdcVJscIJpclqglBubA7clcVd8rUa7NhdpguPMGAiAg6/Ojw+hPhA1zncoGBKjCJoTVtlsxu7FfBo6AHurTf3fBuNBR/EKwMHuy2/NhNoASfpTnT3bk0uddbX6ectD9FV9kTW3wH6tMhnhSgbnoAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3/Xyq3rsfPktVd1WFC1eSvBi9kBb47rHAozahNZjt0=;
 b=PX9mhZwdDpYZdCh0NlAspLKA8NyowlttaoSEPnLSfXLBaCtBIbK1xuSxqv10f1GZmg1lvWIdWIH5kN0PWHZx1KmLm87XAR+EUYo8CIKeoo8CFNVtlWbg80HNpmM12/mcSNMtbuuyet7S1nXve67zh2uoIEQWXgxVgGeDE2zYAmE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Thu, 1 Oct
 2020 13:20:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 13:20:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, andrew@lunn.ch
Subject: [PATCH v3 devicetree 1/2] powerpc: dts: t1040: add bindings for Seville Ethernet switch
Date:   Thu,  1 Oct 2020 16:20:12 +0300
Message-Id: <20201001132013.1866299-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by VI1PR09CA0064.eurprd09.prod.outlook.com (2603:10a6:802:28::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Thu, 1 Oct 2020 13:20:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 625d4bef-09e1-43ac-0352-08d8660cca0f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73747328FF47EAFBA868C103E0300@VE1PR04MB7374.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y4SqmbtVKQORV+Pbt0X1CpnhLVFwh6fogRxJ8ExQ5iXJ1M1DuS/anXGH2L10a2Kw6bpgvfOehT25ZaXLtawMt9pMjfRpl6PlJwre73uKkhtINfX6W/3JEPnRIaw0u8k+kLky3Md3qsPy7cZVQko7gSj42DXkPRoHm7to/VYdMjnIsCPH1r3u1YRJvZ/7e7Q5uivkby4IKY23S5/bJnW3ir4WHhfrjGZ80ZBQQnEZocdrrKP2rcDa4GCg/Kj8sIfxWem8U9DiDyEOwgl0dxjQc40oy6Kb3vCd5SCAKcKG1ZGy2KOPdXbm2vBqCEI+dsVahvgCJuGm+Hqgk29IezIEPZLZj/saTgT/e56qRET+O2/4c8FCJNn1UGcl1VqHXvl5basXNbCgmxPV9TfPMIWRlgXaj00HrbUKI6UFzvRoKgY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(5660300002)(83380400001)(8936002)(316002)(6512007)(26005)(6666004)(6486002)(2906002)(66946007)(66556008)(86362001)(66476007)(8676002)(1076003)(7416002)(6506007)(52116002)(69590400008)(956004)(186003)(44832011)(478600001)(2616005)(4326008)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YpDd5q6OANUgJBxz9u0tA6sAdPvn//t/1BZbGW/RG6jMBs8ITA2B0QWpcJOyXRCS0QRKqCKmjL7AvuVj3u22pkttKQ6VUbhmCJn1cYV0yTa6wOW2z0hG5NLUmIE7reri+N0oO7Xf/jFsACkrnMonlAr9ceXhdXvvJ++MJxxCx0vsEblpY420NBLSWDCMXPXiCEjNBBGvdtSPbkP/ht8VM1kt3JlhDTWR5Z04GVML02AiIBXvV324iAVez6rfrNZS0ZqOKBayE3l3h9Of/X42UHfcep3gTGBUamOHwSAtZbbiCCvZiDwqq7ZPNxyLR98y+1i1QHxuXHxF5KFhfPwaL1UGUls+xqLL906xXBBFVHUCS9+rW8w2jvjojfoZwAAtVvaxzvoO1ZFvGvgbO2JVu28QkMWTj2YUdLxCCtm6fGc+CH9UjO/p5iYPrxNyRyOghEL4O/KNQb2qwhKWnJeGL0FUnszsGK748wB6lWqriYyIPZrvHzsQfVosU8xY4gzNKrY1lafjGZysFoZXop5AegYOzQyh69TUcIRtcyvPeNNQgQ4Q2nw96nF3IrJJJMfhaQfPdJe6Nath46s2nBdKIgtq3d4zXPKSP+42L3oA8uZTTrjqw5qB8Kvi+ZGf2QMVgbYwcIzm0tN8nQ6UIaFElA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 625d4bef-09e1-43ac-0352-08d8660cca0f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 13:20:39.0926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxPPZ/nTZDJfM5s9OdacDXDzNynuE2l3XPf92HHceCpswVQUczDfFbX4O2br+vuy0NhJAUrmBYy/VsWjsq45ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the description of the embedded L2 switch inside the SoC dtsi file
for NXP T1040.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
---
Changes in v3:
Added definition for frame extraction interrupt, even if the driver
doesn't use it at the moment.

Changes in v2:
Make switch node disabled by default.

 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi | 78 +++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
index 315d0557eefc..f58eb820eb5e 100644
--- a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
@@ -628,6 +628,84 @@ mdio@fd000 {
 			status = "disabled";
 		};
 	};
+
+	seville_switch: ethernet-switch@800000 {
+		compatible = "mscc,vsc9953-switch";
+		reg = <0x800000 0x290000>;
+		interrupts = <26 2 0 0>;
+		interrupt-names = "xtr";
+		little-endian;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			seville_port0: port@0 {
+				reg = <0>;
+				status = "disabled";
+			};
+
+			seville_port1: port@1 {
+				reg = <1>;
+				status = "disabled";
+			};
+
+			seville_port2: port@2 {
+				reg = <2>;
+				status = "disabled";
+			};
+
+			seville_port3: port@3 {
+				reg = <3>;
+				status = "disabled";
+			};
+
+			seville_port4: port@4 {
+				reg = <4>;
+				status = "disabled";
+			};
+
+			seville_port5: port@5 {
+				reg = <5>;
+				status = "disabled";
+			};
+
+			seville_port6: port@6 {
+				reg = <6>;
+				status = "disabled";
+			};
+
+			seville_port7: port@7 {
+				reg = <7>;
+				status = "disabled";
+			};
+
+			seville_port8: port@8 {
+				reg = <8>;
+				phy-mode = "internal";
+				status = "disabled";
+
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
+			};
+
+			seville_port9: port@9 {
+				reg = <9>;
+				phy-mode = "internal";
+				status = "disabled";
+
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
+			};
+		};
+	};
 };
 
 &qe {
-- 
2.25.1

