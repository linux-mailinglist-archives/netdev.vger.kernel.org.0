Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EBA3C366C
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhGJT3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:29:31 -0400
Received: from mail-bn7nam10on2107.outbound.protection.outlook.com ([40.107.92.107]:9249
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231270AbhGJT3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 15:29:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5tD1Snm7ETc3gj8xdTtVNQS1eK0gTVCLGJb80lLyNenifv75/tgoN+7D9Qx90/2tMqOKU0UWw1zvlYMD2CLIG0L5KvRwptf/gGtaxW1T8lMtlfNNxkqJQPTvxVeQIeNzLLvQhKlJjVia1eMYgyhYTTpCJxtseKoUWTEeLMoA++Hs0+aVT/E8FuYCIJEyUGXw2KoHdGKPHvr2kmYXG0tj0ypiAGQ29Q5JiFeEVLky1Kn2/KPnM+4WQhbFBTTNutBSmO/e5m4/xd8QSsfjw1QC++L3bsqsiDQEmMHXj5bEMKzzbKKRi7BslkTnPAOzYfww/Rg2QLc7X+UDY6iXUxblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kzVX/APDWZFMXE/nte6ZHwoytOQ0NphKRfHF81nBWA=;
 b=Xa5sg1yhcqe9yoY7uTvyu4Pm5uvQ1ULT3e74khdhWCRtjyN1acnaNRJTB/pmEGu/lUjT5OznS1y5wnUnZCyfMBAYjr8JIYDpCV6hDidcpjeTbqfMDIemYUAUrl5A1aHCwmMhtJ2rNkLEhJ6YfhGxO/FobqQZwI9YrA1c+8mMecWWuFtkU8S7h3eW4zLnBJZLLEjdiWAQRThuLFJGgPG30c2P0bIt5WGNTEkGiIXxc/6LlNtUr8YDrvKvzp2/37P5qaxh3RrVJLAyZBq/nBpOWvnyy4kTl2PIRJ9D4eoCJYqtgf3uOrut1e7J3CT9aXIHmI1yiT+J7oVPrOIzfc59Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kzVX/APDWZFMXE/nte6ZHwoytOQ0NphKRfHF81nBWA=;
 b=lO1Y8T84kjmz4KScoz1lbDo2Gvgj1rl/0B0qmYkuqGwmwMPW4HgxGKCAhzFI0X/nv5R1ER+zYOPCBDHcoCqrZueFtVmYxeZ1d+p/62S5UR3qImwXBgWwfvCXVHPk0+RFzwrMsKFgX4TqZhCVWrUr2WBEYq7ji9qF2137IOFNJtY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1709.namprd10.prod.outlook.com
 (2603:10b6:301:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Sat, 10 Jul
 2021 19:26:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 19:26:21 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 net-next 8/8] Update documentation for the VSC7512 SPI device
Date:   Sat, 10 Jul 2021 12:26:02 -0700
Message-Id: <20210710192602.2186370-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 19:26:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71e6c8e6-c2bb-4316-ac7a-08d943d89939
X-MS-TrafficTypeDiagnostic: MWHPR10MB1709:
X-Microsoft-Antispam-PRVS: <MWHPR10MB17096466EFE0ADCD09326E9CA4179@MWHPR10MB1709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/uIBlY14Cy9bBFBISrJbNhuPXlnGsWSixrkAemDMxCsKqqfgT8WUpAU5c45cvNUwiRx+QG8/4TxI1ZQk1qxu64uQkCw81OCJCLJuvfuuAPcRXhzWq5kMIXA0UFhtgWjW2VvKTEsQwVmJBKp6xAzGB2c9SKQKSJq5MUmCYab0HT2opKncOFKJsyoaO25xCaye/ZrA8BAj/pcpuHUpwPWUWcIRIoyS48KtHHqIYeE7ndbOwM2GJlwkBdN4sBH4IwA4zN2QoN1b6aCmqYqTL2tlJsQDjdonJsy8js+BeaNBEq+mWHpMBxlAjUvpIOgQiXLoTeNpkTAYpTMqL+0+En7J/7fx3ampU1+z91yUjoOG4xrcfYat+dwnqeHWVuDreaDkXfu4apj8Y6D/jWX3PV2WzveSKS53XVSwk4ZsEPnW622illtjULEIDlq4rJIVvaYK1sj2lFOpJoyef34sNk4VGBXxbastuBMNuqKM6r1XU3fnkEnrcTHJpuYMKP3dOjIfgm+b+TR7DACjZlYBNL81DewV1PD+ZOV5LZgxi6fX5loNSURhsID42C6ISQUhF+1gUw+NINybdMb2VwwHCEEcpa4BR/ix2ISc1QypCWsDI1hL6frmd0rEpUolIm8M4suI0M4jpBNam9yRlvTrelQcm4j7Ze+O5REcTF230ONtc3FN3egtMHWztcOX8gBbDL6JLCyg8LyK634gRcYp31voCkg3f8ni0jVYWspPGJ9/54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(8936002)(7416002)(6506007)(5660300002)(2906002)(66556008)(26005)(2616005)(8676002)(44832011)(6486002)(6512007)(66476007)(6666004)(38100700002)(38350700002)(52116002)(66946007)(921005)(4326008)(956004)(1076003)(316002)(36756003)(86362001)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yz6dumXtxiJ8Q3dIgvbg1qCKX5fY1RoiFOrqRCmGnEbnX2yCYDRJryTg804Q?=
 =?us-ascii?Q?3WMewUsaA/rOa1k2iKNv5WYfbQUhS7LhXipJwfcFlsQQ04Vl4PYTKrpSugKa?=
 =?us-ascii?Q?ZKEZttyP3b14epEHlMpkaQKouIkegBP2KUvJ7WCG2s2b7GI6vRMxdqTZeoEc?=
 =?us-ascii?Q?5DKDct4KL7KEO9ET13IVhQEho/hIXGgP3/J6pYgIMhXjwgwIlnirSbI0Ql7S?=
 =?us-ascii?Q?/21kTwUmlTm8SwcAipJn5WCmRGI5e8Iqupx/7ZUJGKCLINV3AnuMTgUnkvEj?=
 =?us-ascii?Q?V8Yb+Yi++JKzfPj1BtwdjRmpmwW/LGYGqoydKIgzsGYN3GgDUrDu6VwQKSud?=
 =?us-ascii?Q?tO8z8D4tVQERyrdoV7bNlh8JMvfJ/EXvBlS4vcvoC/u6Depp6u4aQPFm8HIx?=
 =?us-ascii?Q?HQ7fG7xdkX3TgkBW3JP09k4NOYPYHJdVt+a9MXgpCh8euqtEq3kUPdkp0p2c?=
 =?us-ascii?Q?UVu71FCVAnk4nxJ7Uzp2CbV5VJbymazFmTR0aEEvVvTej8E2Ef9S3LEhHK44?=
 =?us-ascii?Q?J+Mx3TacxwONah32ah3XMWLOew0wXgjFqQbuZEptF0NMVdZNHBTJyQ8C0N37?=
 =?us-ascii?Q?Hu5kHgX5O+bp5vK0CNqfJeJZ2gGi65MCgD8cXK+m4qFmIWoei5mX6IkiJdD7?=
 =?us-ascii?Q?vmeUnDSkrR5FMod4PD79Z5zmMss64r5+t2Mo0Xyn3P4APe4ZqgTkYx+BFmiS?=
 =?us-ascii?Q?y7xgXdfalqOATydGViOhtVFNqCzZwsNGO0KqTHxCM7ROiOf0MgnF2fsbTEd3?=
 =?us-ascii?Q?l+b8xjgBmGQS5SzFEkAK5ai+hHF0VzkPypg6Akv2PqsGEkK/nk7A2pkQO/hZ?=
 =?us-ascii?Q?TFq0rUXqQ03tvBtXHeUHYmp4C7+h/CXG0F2yi0oxQP1f5GBTvMnxs3EQKwk7?=
 =?us-ascii?Q?rUNaW89V7LHa/XoelEv2vsb+NmDVc7ztjZTRL7hMG9VYLvhsn54CHaSlBGbO?=
 =?us-ascii?Q?bJcVIqPu5/F0JJf4d2COrLMBqhqJdI92z1DXg43zy0FUi7Bvqo5sW91W5IX2?=
 =?us-ascii?Q?BDSktosWmZKXn88TvciSGHFon0FkMKa/Y8ndzUScSCjZRzeaRKZ4q0ZJ0Xo/?=
 =?us-ascii?Q?T6O9wEu4iR5Qdv0qT7toL7Rsasvsm7zAmKOdHLaMzKW3RAvI617gfEYF6KFE?=
 =?us-ascii?Q?iqLRlCZAZVi3+N24k/pzj9NO146rV1GdHhtP0fZRN6qpEyrWZmeWQqU/iMJ5?=
 =?us-ascii?Q?cJUHVf6GUX7W3AbsjJjqlrv0SCZGKCP0ZGz2DkZgItKpiUIDMgesqe9nwifV?=
 =?us-ascii?Q?CRlQix+zS8l5nZ6BM3lM45oXKaOrg1/Rwef3jI0h9rY4dtZq0bjhqGdej2G0?=
 =?us-ascii?Q?8ARFHbdjbx5MlDap2w2Wo716?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e6c8e6-c2bb-4316-ac7a-08d943d89939
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 19:26:21.4465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOvBPnsGMPwBn77zhUaZZeLXQZ4Tb1corlMuXM16WxZpYM+1+z93yWWCU1pnl8xEcFWILi2mDvs85bQGyOjzAWeEXHokKlQ3nr5RMeLi4kM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 .../devicetree/bindings/net/dsa/ocelot.txt    | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
index 7a271d070b72..f5d05bf8b093 100644
--- a/Documentation/devicetree/bindings/net/dsa/ocelot.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
@@ -8,6 +8,7 @@ Currently the switches supported by the felix driver are:
 
 - VSC9959 (Felix)
 - VSC9953 (Seville)
+- VSC7511, VSC7512, VSC7513, VSC7514 via SPI
 
 The VSC9959 switch is found in the NXP LS1028A. It is a PCI device, part of the
 larger ENETC root complex. As a result, the ethernet-switch node is a sub-node
@@ -211,3 +212,70 @@ Example:
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
+* phy_mode = "internal": on ports 0, 1, 2, 3
+
+Additionally, the VSC7512 and VSC7514 support SGMII and QSGMII on various ports,
+though that is currently untested.
+
+Example for control from a BeagleBone Black
+
+&spi0 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	status = "okay";
+
+	vsc7512: vsc7512@0 {
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
+				phy-mode = "internal";
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
+				status = "okay";
+				phy-mode = "internal";
+			};
+
+			port@2 {
+				reg = <2>;
+				label = "swp2";
+				status = "okay";
+				phy-mode = "internal";
+			};
+
+			port@3 {
+				reg = <3>;
+				label = "swp3";
+				status = "okay";
+				phy-mode = "internal";
+			};
+		};
+	};
+};
-- 
2.25.1

