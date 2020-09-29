Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3A727CB75
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbgI2M1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:27:50 -0400
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:50641
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728941AbgI2LdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzVwxlUslI9E7TgUBdRl9z5NvT93K8Wwfed8FnAm1MZtvdIzQgmrJ5ZUp1i+FmsMpSQkfY2t9YDdn7LyAy9JaMeCLEEX/NCmD1l/b6N05aVEoZKfwEUZ9XqrrAGhNkxD+B2Y3Qbv1cs8OBVPcjKITrwA9bh2NHYL6CpwKKuO0f9RRmHMvstXp6iYvDTe3fqjAcL+YpOMT0NXfq9SSZBVhciPYZIjvwVGnEEqRpyOQ3ppk8Q7rQAVwpKMcjxWSiTvjpUf2Sm4xnp3YhEBmWfytCNFtx1YyU99BopyYAXKhtA2VIl6+NOm5koxThLFjWoARMKfxFVOQeTm9iLbk5oQ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBtFqIM9cnXfFNVvg+Vo1W1+DlyTfFyFKvsPCnw7vYo=;
 b=bq+KqoLZyxULlwit1/tKKbnKJ0rikk1f40LKBWhJ7offdZMKybiaaQ2YpBSchtkZY2IvWQCWH7DOBbhHRT7vpKPozx39ql81HYWr5fekmE5V1NvSZHfMpTG0+X0W1bwChH2+0jaMXm67Ua6Uq3UCkfy3eBq501diBTAhBhd3ESbrQL6MGOfj0LvoYSgKxQT11Sxt3kUg1xYJx5ChPtzPudEGWlN4SHX1/YcUlRemQHGdSHD8jx85pNU6nfHGVvN2g23zX7V2KhPorYLASu1xa/hmc5qJm3TBszlSlMGwPsdIriN+Jmo1CbWRE902vwdWlM6BcgJhArm/2dxT2Z2LsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBtFqIM9cnXfFNVvg+Vo1W1+DlyTfFyFKvsPCnw7vYo=;
 b=Z6zLrR1hycn1YhIEsuflnjJyYZPrH86ceDM6IY4CzvEGEJMNFajCqyi/A0ru0hpkkeyp0GdoBMzUdvXmP7+/+kpnCMrBJiQDk+r+95ishHxcgZfa7Tnjj+iGcS/4WWHqEpue9Rf7i565z9ZUobH++5ONZDnYd2GD1woIrzsfB28=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 11:32:21 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 11:32:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH v2 devicetree 1/2] powerpc: dts: t1040: add bindings for Seville Ethernet switch
Date:   Tue, 29 Sep 2020 14:32:08 +0300
Message-Id: <20200929113209.3767787-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM4PR05CA0008.eurprd05.prod.outlook.com (2603:10a6:205::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 11:32:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 791a1174-f38a-4f06-2150-08d8646b5460
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB550438B79EDC64F0090DD353E0320@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsGIHn/GF+uL9MQG72zvlpWB4OgnGRdi4jHDYg9+vxQVYaO++nO8l643Hdf/pW6YhrIsjnUSkJQUhBkKwnX6PwPcBvA4mMhMn9Rm2bMUV4vITAu/tfECtCvUxj65qy8crC2wC4LdWQTVb5YY1WwOM4rzKf0z3HQnppm+3o1GlhRLQ9RVzWR66kNE8KePj0FfRxopt8i0fvG9bYWB+UB25yIyZxx462rczQwlDzeA6NhFH3RTIgfCPQiO2/sLrdjvb24sJYmqLdH/+nMnGCS1/rskaqoFDcipeFNbJPDqlkqaUkRlo/ap5eRt72yqt0pD1zS7BgjcqJO7MdXVPihqHqKQpSJOyh2FxuZMIQsqIbV0cMQsg3xPOXVKtwZ82AMaY8EGTzuSMS/4hr/ExbPLThmlHEHvKXrlCWxqv+DIiKgzP4IVaYTGvJnUG6ZwoPVr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(36756003)(66476007)(66946007)(66556008)(1076003)(6512007)(69590400008)(44832011)(83380400001)(2616005)(6666004)(6486002)(26005)(4326008)(956004)(52116002)(86362001)(186003)(8936002)(16526019)(2906002)(7416002)(6506007)(8676002)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yb6sjnl9B+eLW1bvaO+FYEAYZYvpaLHykJ7o+MEzEeRJw9itHEQtSif+Yt8VWoz69xS62vBEgHK0CxiV00OWqSD7v/yh1HBFmToASf5M3znVrBaYPC83CqcRp+b+rV25nxOQiMnwCkr1u2nCbcbJh4z8tx0+nsuijpbYwNxEY3JfVFUF1sUyXKreSwe9whas7xBFGA+dTTyleJ7TEuGsFpLbXxH2F1mdGGpJGHD9rpx/O0PA5+9cAsK4YNMx00q01JO6Td35TDh7HKodF4GPHyZJxWaUjzsv0FNziMOMWYwbSU7sJg9D5nOZDHG6pzQ+qegXc7OskkGtCZjbCZzxkp4X2LACluqx2M5SuAMwdmFl74frdc7Tcu444RNKYvKDPpJu2fnv9eDpOtCh/sLYLY49IkMtxAG0TkalESZtfJ12NB5sKhb8UhNnX2qSSsyptrTnJ/rCkFsoiOv/RQx3JRhpMVhXFnAS+lC2zw5/cUECe9IVNioDz0abZpuDv4wgJqrWF3cnNljOt0LA0kvf5knVS3G1VgSYssE+r4sRvu9Mi4PUoUcUTd9OHbIdlApdyBNxp+/OeljkiW7fD/K0NLCgSECO4U02Jd1JwrLgE475OwrFleZrRHnbtZbcpwlnxneAr5Bf5TmTJvpjUa/EdA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 791a1174-f38a-4f06-2150-08d8646b5460
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 11:32:21.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VcxDmi3Nfpsm165PNzd9EpIDoVFUoD5puAj4gLzq1hRZRSi6ztTlvntDsQ7tUtfdvesdHfn8aCvR2XbBzU+UFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the description of the embedded L2 switch inside the SoC dtsi file
for NXP T1040.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Make switch node disabled by default.

 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi | 76 +++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
index 315d0557eefc..5cb90c66cd3f 100644
--- a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
@@ -628,6 +628,82 @@ mdio@fd000 {
 			status = "disabled";
 		};
 	};
+
+	seville_switch: ethernet-switch@800000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "mscc,vsc9953-switch";
+		reg = <0x800000 0x290000>;
+		little-endian;
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

