Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA7028144C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 15:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388019AbgJBNlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 09:41:31 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:28292
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387856AbgJBNl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 09:41:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knfxIW4Z1/liVv4V3TwwTjLJSyhygJUkUCA9v7be1Ura8kmWQ582vCNLRhOCg/lpH3gOcEx6YBuyo6pMHEeH+uobumqXFmThNRLSIinIoQ0W/MQSgQhv038KHrqwUowsgmkYC3we1CuD5Lwn9Iax3Lfc+kZGqKvRLaeE1fB9jCsWaxcYDcZ2YgXndBjnE73FGMkWSVf1jtsERkybwWtCbUXLJiRC0nRFkPElfs9E7ReZzsKUIIuHE1Nvz05PDFRm6Wk5Y7kduYFlTS+PNWNQ/itQvgFxtpjcTlbtlcIkXK0y0XcbjOeIwKIHH1bEA67lKPbIzamNRN5CU4NEwP8HwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAfqHcIfK34wsHURRn4ur3FpZkANcaT95hf7hRdHCx8=;
 b=ZmrBEq43H5MDZ9P2PISr+LesoNt+uFlDZs1ab2OXKKILP6DMOZ1vTdawXv/ToF4ciu87rJGV81rXMVbWPC+VNOK51DcIF8O9VyA8MePSAgNB1yeBH6d1mtzn7EQVzaMjig5RzlEi8EQ1HAS1fO0UzHTGQ41nkOQxEAr1gx5q0/IaOindpPIPaFdSyWgCjioSdIzqETbcDNy8pavYRgUm/727qU7DWv8KRkYJWd9qBQ50DELY1PfCQE8fzjfCCLxGj1AcQsAwQCuA4YiIPeJBQoLaKm/vQRDAZ96BqvaXBtn2S/nJpAfC817qqPUJ6hiqKBSm5FFsqc/FWxYWsYgyrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAfqHcIfK34wsHURRn4ur3FpZkANcaT95hf7hRdHCx8=;
 b=kEoKB39OKz5fO/5KT8bQ3mBT7/50jdTBse+FvQ/sO6Of0q5l8H8yatOl7LiuIQCFRxxr2fdiSoj4w0pQTJZRj4elZLjdf1KaiooI5i8rhcBowlo8h5kKJ+ourzbrJBn+Hyd4BhjI/9TldJkugO6SHF84y9qY/XHEgsfdsp3tds0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 2 Oct
 2020 13:41:25 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 13:41:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, andrew@lunn.ch
Subject: [PATCH v4 net-next 1/2] powerpc: dts: t1040: add bindings for Seville Ethernet switch
Date:   Fri,  2 Oct 2020 16:41:05 +0300
Message-Id: <20201002134106.3485970-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM0PR10CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Fri, 2 Oct 2020 13:41:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 44f958ae-905f-4dd1-4092-08d866d8db3a
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB230442CAA3C7090C96779FEFE0310@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQPYIT4LH/tqnuhNzQjnMEtBsSx+RuMh+kCLfLS8ktcgD+h+fXqoWyxMbwBYO79LPrGbMHR6IKy95rr8nILAvLsFBPTW1znRX0JjuZSQjMuG4mJip0Iu9bfSlzTOCvOFGkh81QkXiG7QixxrB9CTN9R5opeBoCaHYzP60srI+W09loImod0vvbTl68BSg10+F8NDvniPu/f2mfDpZkOJ2k6CbIOMxokzZwTbZ9FAeyuCrjvUP5jsbglUD61J79ow+La2Wuz8/zdUPcxrxBDvWWk3C69+38fO++pDoZVjKxHQV2x56O2ictfiSglbuu7y15TZTjR6yNhSei2FXFJaBgyHHZIh04RyvEiSQxFGjAvBRrw7wzayV1pX3RLeOz7P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(7416002)(2616005)(956004)(26005)(83380400001)(478600001)(186003)(36756003)(69590400008)(316002)(2906002)(16526019)(6512007)(4326008)(86362001)(44832011)(6506007)(1076003)(8676002)(6666004)(52116002)(66556008)(5660300002)(66946007)(66476007)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UV6OBMQgs9PLOeirBWG1h2FoKc7K11bU//U2H16uEPTMbOlNmtz/74cIabb/t2BAJlxu3yWTQs7siEi/LECxmlaO0W0RijaNvPW8AR0fXFZT9+KC8fsqmRkI3ol/VaoH4Ra8bBvrMEcsWCwVvMWtzidlGXAaKqrBDuVk1SddBBLmB9BMPU3ROdJ9f12/jAunAMJm4bgAxqoSXRo2yQM5Vfk8KROC7H1fxCvswv1pAhQAcsaxrkzBcHoNchI1dlIABawDmKD5RSupTmVnq3lKYYCh5MQLk8zEIMdgBhJpAi3SaPPSPYEnMeEJXERGOorzfCrNEvR3oQJJcFnnjpKLAO8h4uC9b71P+I/Z/KI6feBSQXNmpPCZdjouNXxhedx1ZOJyowsky7b8kyxxiWEjv170l6HOOo1ZnRPrKYAQe0ib2DjIksJFBOxPttU/hhxtaPKluYt4Au4jPYGJmMDs9X7fcpTAIEFa6wETuZv4XZwTHpfiNPqSwQpw6vjZcUD4uJ7BDx9L7K4Knu6uPwVI2l5By3OxSvXHF6/Suqur/AN48J+M+BF+oBYQkPIPU2bS2hIfJksnNWLvTaAYpwQ6/vjj+iiSKD7BrMH/rrLWqRXfj1+pc3I9FcmC1WNdIdDjg6eNR4i0LNBBXDL5nwGdPQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f958ae-905f-4dd1-4092-08d866d8db3a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 13:41:25.4299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 956xgVWSQHwXgAgY2eglYRVZhRVaCB7LtuN1xsB0rni/1k0Ige435wx+aEmuuMuq28OfthGz7YJajrnwgKIjdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the description of the embedded L2 switch inside the SoC dtsi file
for NXP T1040.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
Retargeting to net-next.

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

