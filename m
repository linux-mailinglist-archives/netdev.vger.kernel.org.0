Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F03EBFEC
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbhHNCvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:51:15 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:10517
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236925AbhHNCu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEkXTCOXum2ROJK1S5/Yg4BQf+lUnKuH1+2NLbaBfAMJktPWNsTyJSdkJyc6lIMz05+R//Z2KkbkRS5n++O4M5yYUabYJJ4xyRLxDrntPWLULYNqDeh93ZbZHEvVtMs4SFHM3iZ+5Hfl/DwIqJPyTIoi24fPEbUOFQcuyTWOqpjG70r0UOBnqrgqCGUQBqrAiuMFHrz657OWMZKEPP5dPfxNwSXsr+fDlajzlLXe3jsU45swPAKjOTIufBFXvsuLIJtWxszc8nMajSGqkie70SlrZtiWpVViVyqX1HNcKJNJ1hf+vZ+1YZyxHL58k76RCDWvoT1l+rZP0S+VJSx42Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4WWHlzvfyTj70DE+SDbW/HH5KuOTZ4GE0wgFtsR0oU=;
 b=Vs7OIu0akrmYu/VqY8Ly7/imRRq+RJjp49OxdTXi/A0QMfCad66ddqAVUpSIQvoqTPhC2ZK29eFgoURFaHYL3OXA2K3HU3Yu0WrYQdZtwbQorsqwjpR2GGO5R5jaf38cnSjtYF6OnEwSYmlKRFPZEi5BEwn+hAFi/8RPy7eWp67S2XGko+8kEsuV9/946Vx853WUt+jun0d4zzmKiJi7rO4Fbgza8jsDNG7DvI++bUpqqiuzKwB3SkWRtENk1ug3S5ptkPJkaxwPYq+9E45iu4yOXydlfVwQPuxhuxK8QDD6bYRS8tIWR+ffEsjjUvyrRi0oZGFllSkG0LzIDowMpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4WWHlzvfyTj70DE+SDbW/HH5KuOTZ4GE0wgFtsR0oU=;
 b=nfdDWeTxKoUn66knUSgv079AgQuumzaN5o91K3lLg/R+44YhEWf+HYuM2Jb/sSB996XaXShJuu5t7mON1ZvcVFARGQg67LMsedvgoEOIQ40km+4xV7d9LgLW7SCkG6oFt9Qe2S5seTEnrXGJriI5vdzC1SNTNe5t5zDjYJh4tbA=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:23 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 10/10] docs: devicetree: add documentation for the VSC7512 SPI device
Date:   Fri, 13 Aug 2021 19:50:03 -0700
Message-Id: <20210814025003.2449143-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 154a79ee-fb31-41c0-802c-08d95ece428e
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB203041E1B7210BA486D2CBE1A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+I/hLRJtdXcC+paLUXUIuQC7+M9fXwYfu3W6IYnPH87PzeW9uZJreUPJIpvrpduKexHHYcZsnK6jzCSiLFf1iVteNCaLFevr5sB8tqAM1QcEkmXGHhm1zagk5YODf1MyKP5rdKvSdwC3r3LfWkCpOjhdpV520lzZVSlnLjx+6tQJFCTpLDt5d6RU5pAqdANhR9IdDJ6O5oL34oVRUfI6av963gYZz5+2NY0s5pi0l8QQB6+KwhEzJ143807EUpFDrwngQYP3ngSYHE2UU+4veZEjLjWsUY/cfxjwS9AOQGfydgjtN2Rdzk+9Njq4af2v4IBLOP4BeUsqEPoJAasDpxknrGpJJ7ct4J2XrXOyAAW3NPGvsUsfUJfwwSr7BWj/y6YoHQktnHoLo/UO09gJU+HyBhueBVGyYqx3567D7qHCCoXJKdfKRvrRKIyuZlb5HoONrMxbOLeg9NuBS4TrGL3gWJ82gbz8aejsQHTWuzkkxw3iVCEagDPgBwKz9pN78329uyApVjCrEqs3iwkm8ILkNI+AXjRQlneayav7m5UlrfNeFN0qsmnyOx++WEcL+pz8qOar1WaXXjOKiU4vzg5ju2B75C4BbXZHkG5CbMUqJeJnvEMVZtK3YMySCcdT9lXJhXC7idG4hz1/9974l7QZ6RDt/DNHstYg/rP7t2dh5XhlwHAGnTI9nbIPw+8buKnh5JgVuUzo1/0bz3Cow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LcEYxJRP/H9bHqvf19TEHTjRvepDiMsebssvBbuTW1ac+0grVxQPphaix4HN?=
 =?us-ascii?Q?KTXmM4a2PWkbSO0MEHeXZ29ex6kkdF4mzMy1NL83niDH3pqTIE5vWlv6NBpQ?=
 =?us-ascii?Q?aozfMfD3XgaoTCKToq8WRMnO1Sx09MvqUet3j4Tn0fvfh8OisQyxHcnWgOPq?=
 =?us-ascii?Q?9Z+AqA9dMpR9XH5NoOx/D/uXBsFOqZPPMuusgMCpMBKerVT1VZGnbo5PI0fU?=
 =?us-ascii?Q?V+ljWuTBQXUT/6gUzNUvxXcr8C8MjopzjVNIFuWv3jg5R0blPL+WWzeps1xD?=
 =?us-ascii?Q?YZcei0dsEddwChb+Wc+/fpZ+Yb/lIVWsxrQ99MFb5zYT/SZRvTIPVH8bpYli?=
 =?us-ascii?Q?Rd1ii1PmZe5k420Lu1IPxJHXQS2cTviS7aSmvg5L3SkRWxI0U+0PTzTnzbFU?=
 =?us-ascii?Q?B/jFe/9KETjYkKjQ9QCaTZgtL7n9e81UY/jSt5h1MKxyx1zf6rfanHCkCj52?=
 =?us-ascii?Q?chbli0WpPJq3baFNw8KQrMPXprVzBj05nA+bbDFsWrRJULCDVoNZjuJDX8t6?=
 =?us-ascii?Q?ER6NoqKgoRlQJ4g0gXymar0/o3157KGRBTetNV1xj5oFLttcQstr4rdytts/?=
 =?us-ascii?Q?M1Vl+EaBBmUoQWVsWXDvEYGOLSkZxGx7adccJA06YzfGwhnb3lXmXiDsW72E?=
 =?us-ascii?Q?ZZp+TftXvy0dAmJ/VO0NMnL3b/W5aPNTRQcHaLi8aB4tKYXP+4YXM/l5UG5r?=
 =?us-ascii?Q?Zfyty0c43YCLsR4gOl6xAf4cUQm17kdRGwn1iMtDw5F53vFgHSBPWG+V6Bz1?=
 =?us-ascii?Q?QB3XVHairUTiy7XcQvVB2KX7IfzxsBxufaFTFM0tnnq8Fo7tmoLjfgFTYZh5?=
 =?us-ascii?Q?MJC0DeOAbVCCqNvEb4II+8BQGKN6uIW3kqs2Ib7WvqiW0Ule+qq/+KuEyWuF?=
 =?us-ascii?Q?+LNgQ0UgIqBbKCfs/w+kv+Dy7nRkTfU/ln2jZMbYQhntidlZE+SficGNBQaF?=
 =?us-ascii?Q?ggaECO4syh/X5FBjvcYS4+prvnq+nkY9Pf4sYA+F0e9E0+g5EubSEFN8DEI5?=
 =?us-ascii?Q?3J8PxwemQZm8eXzxJJNrWOAnIuvHQgREPcLpzNf7tUbm9NSNg3cEeAj0BqcT?=
 =?us-ascii?Q?9JuAVWrn2Wj6KI5xiXcWL7qD8ux9Znkg2XhWMXVSKGOTLfdYTXo04G7b09AH?=
 =?us-ascii?Q?eo57+qmwKXcUsc5P7x7ofPMWsfyHSx3vWyoqzcalg5lo/mtcfFZzajvhFq4/?=
 =?us-ascii?Q?r+ru6k4M9KD+N+JENrbnLI+q5fFp0QMHUC6opq/5rW4T6RaYHxaquh1DQrFf?=
 =?us-ascii?Q?CO4v+OMouSYreVtdj/50vLJIT0PVYVPmLYep5gXrUPJH5ex7QRsHLIHWUODr?=
 =?us-ascii?Q?i2zGXcZdf2/3O13kJ2e75CWi?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154a79ee-fb31-41c0-802c-08d95ece428e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:22.5163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kI4dI+2aHDloKhYGdxtRgZpZfHtUiGVJUk/cRliXTYPjidF82URNRg23QHXSh1+DNrD0Y5giweRT8O2P4ZJl+OpTP0S/a0D9A6k0Gdo79U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 .../devicetree/bindings/net/dsa/ocelot.txt    | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
index 7a271d070b72..edf560a50803 100644
--- a/Documentation/devicetree/bindings/net/dsa/ocelot.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
@@ -8,6 +8,7 @@ Currently the switches supported by the felix driver are:
 
 - VSC9959 (Felix)
 - VSC9953 (Seville)
+- VSC7511, VSC7512, VSC7513, VSC7514 via SPI
 
 The VSC9959 switch is found in the NXP LS1028A. It is a PCI device, part of the
 larger ENETC root complex. As a result, the ethernet-switch node is a sub-node
@@ -211,3 +212,94 @@ Example:
 		};
 	};
 };
+
+The VSC7513 and VSC7514 switches can be controlled internally via the MIPS
+processor. The VSC7511 and VSC7512 don't have this internal processor, but all
+four chips can be controlled externally through SPI with the following required
+properties:
+
+- compatible:
+	Can be "mscc,vsc7511", "mscc,vsc7512", "mscc,vsc7513", or
+	"mscc,vsc7514".
+
+Supported phy modes for all chips are:
+
+* phy_mode = "sgmii": on ports 0, 1, 2, 3
+
+The VSC7512 and 7514 also support:
+
+* phy_mode = "sgmii": on ports 4, 5, 6, 7
+* phy_mode = "qsgmii": on ports 7, 8, 10
+
+Example for control from a BeagleBone Black
+
+&spi0 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	ethernet-switch@0 {
+		compatible = "mscc,vsc7512";
+		spi-max-frequency = <250000>;
+		reg = <0>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				ethernet = <&mac>;
+				phy-mode = "sgmii";
+
+				fixed-link {
+					speed = <100>;
+					full-duplex;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+				label = "swp1";
+				phy-handle = <&sw_phy1>;
+				phy-mode = "sgmii";
+			};
+
+			port@2 {
+				reg = <2>;
+				label = "swp2";
+				phy-handle = <&sw_phy2>;
+				phy-mode = "sgmii";
+			};
+
+			port@3 {
+				reg = <3>;
+				label = "swp3";
+				phy-handle = <&sw_phy3>;
+				phy-mode = "sgmii";
+			};
+		};
+
+		mdio {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			sw_phy1: ethernet-phy@1 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0x1>;
+			};
+
+			sw_phy2: ethernet-phy@2 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0x2>;
+			};
+
+			sw_phy3: ethernet-phy@3 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0x3>;
+			};
+		};
+	};
+};
-- 
2.25.1

