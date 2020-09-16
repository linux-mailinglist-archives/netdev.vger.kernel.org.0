Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2926CD39
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgIPU4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:56:04 -0400
Received: from mail-eopbgr60101.outbound.protection.outlook.com ([40.107.6.101]:22501
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726564AbgIPQwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 12:52:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVTDqn52YkTlBgSY4sORC0oWl74QcohlvQJb41Z5KsKkcpTco5RgA3k7DESpL5htG87RFnqxEYLThBAdGorGCuKx/LdY4BwcfuDZEn6ViHkytP9TwVOrVvLaSkenubTfRf4uobp7umlvZ8qLkU0d/4X4nOos8EmxTq2CTjvUjGSWxscvuhqFXTmn4VtAGM+lHDE+kAXhH8Quycu7swujEEPcIlO7M9BA+JDV9rXovTMqMndU2mWRTr+LCODEc0JbAn+xiQ1mJxgolTO+yfGcxvj6LbDw4f3K99nqQxNdpu+LoiOY35WTrf0QmkyJBMjq8zbdt9WD2tMyzTLwpma7mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=GhbB+pT/N7FngoP6kgb2zDulq3+SNASyrTKLASq6HbY3OMZ320zVQB2moesfyyqnG+OuFdMw89NIbAfNhV5a1Ksl85tJH+neJKE+ixgQUkKydrOFs6PlkXOFD5IYSMPDaLr/7YYv3gBazva2IVwE9edVbDqv6KqRwUu4YjSUESf2vwg2H7d2NlqrMUEgBUhtM8u8j06GoYr0mGuUnYBZE4JCqpREDKyhI9mnvuv1F9ZerFTwI7dwe6lL1eBzTrBYVpeWkUHsb2h7H9w/m0HEck7ggsYQasy2nlBzI0f0WdmDj2zDFf0i2H+LM3zCkRfLtrYkFmULI/v/nGCNatNLWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=sDRrWMOX04F9eD3opjjuYT0Gjr685BRmydBWbW/skVdIwa3jtd0XV1hmjVPIQpvXEwoDl9XXhLTeODkwojoZpyjNu0iPefp4E1RDTyxzw3nFXRTchtvzZkdyzsxQvXk/PA+p95QhN/pC/PBhvHst7WghOXvWzXr+ldTzpoCLIXg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0332.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.19; Wed, 16 Sep 2020 16:31:40 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 16:31:40 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH net-next v9 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Wed, 16 Sep 2020 19:31:02 +0300
Message-Id: <20200916163102.3408-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916163102.3408-1-vadym.kochan@plvision.eu>
References: <20200916163102.3408-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0202CA0070.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::47) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR0202CA0070.eurprd02.prod.outlook.com (2603:10a6:20b:3a::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 16:31:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af904b29-67cb-4e36-9ae5-08d85a5dfd22
X-MS-TrafficTypeDiagnostic: HE1P190MB0332:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB033284F624E03F099924EC7095210@HE1P190MB0332.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pnq4Dcm/TPKqWZfCSuVvtBnXcVYGyREkT1DIvfd+Vg4+ZrJrLDGgkfq6u72ypxyQPi6QNwZUcfh67xK83ZypvuieVJsIYDyFibRVvN7BXzL6hsliSvZ6a4yusWCHKbuOjkspn4U3nqMG1G4m2mHEGvIaegUziVXTtu54I6o013nCUzQk0Ln8lLb2Kw7BXKY7K+hH74QsgeTRMaoqCE9c7So+kWQ4TPaddjAZTKuT/msaPOP7oqRyPlVY6P7RzU4EV/AzeMzQwY/+dL5b5RKCCUuOCfSJ9PG62/RinHP4NQeEbyuVngYg17HAPZGpbP+TxjfXvCHtnUQiuAaEX8394leLtLr7m9ul3kn340EFi/s4gMigfjVPWBG46+ZVzw612PikHhewLCdVac+1En4rlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39830400003)(396003)(110136005)(478600001)(66556008)(66946007)(8936002)(4326008)(66476007)(8676002)(6666004)(6486002)(1076003)(86362001)(5660300002)(6512007)(36756003)(44832011)(83380400001)(2906002)(54906003)(6506007)(316002)(52116002)(26005)(107886003)(16526019)(186003)(2616005)(956004)(921003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7KNhlx9AK7wnmp1G4Xj8jO1tjyGXolBXI4fP8b4YEgabe+a9w2UnI9i9BVoHIKxNunged2jXti0JfHDIyNy7Mn2LZrQO7V5jTH6FU1ZAPCuY5v5aL30zOK9TMsrvOegaU8RJ2s2N/N6x/lvSA3bOqqMrBSjtZce1bQqykg56/K4h8Vfh+vs8GCSdGwQ8qRL88cw0C2HJOcSD7r/bIDc+qEXfY35r4c6pGKynv4EYmL/P4EYJxt2OllONaC5gUwKQWXKtCXNWyhIqibWVPPtQo1LhSGTJaK2nzJoiHdOJCHOQevMTOpbxJ1DimunmIJKSsWq/K2UfaI/oPG4324E14tZKLik+3vUJ9YcNxp+b4Khuz8cjp6edJZPQV1eeIucFXO7tiU+FdRXqwGTC4R6tlaXqumyIe8vH97mUB6x32PtktJL4J/yiGgEazFpCIvarp6Nd868+XWbak3vLjc8B3+IweRLUXVX6WKM8kq9i70j3WjJQO8rkmJQUYeiSoJ2hfWb52UgfRSPoBFLURqjtHzMp2xJkqqfSkxB0kawqUzyuZW4h9y3w82lpKxLnxhR0ZkgboxIJd3M+vtJd9t9B8rCkz7TCDj2m7zNsinEkQjgXXrybA92UJFV7DtP7dUA9u7Q81iyPdWcf6h4YreJGaQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: af904b29-67cb-4e36-9ae5-08d85a5dfd22
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 16:31:40.0385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R77SlOjRfPdpozWahE3sHFNFkmrRmh62NkgA2Wgt10Zx5OD1Y5kbqm26HJBtM+PxZL9kH1CK2ywcX37X5IggQoVcqztQ4bQAB8M2yOqdDEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0332
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add brief description how to configure base mac address binding in
device-tree.

Describe requirement for the PCI port which is connected to the ASIC, to
allow access to the firmware related registers.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../bindings/net/marvell,prestera.txt         | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.txt b/Documentation/devicetree/bindings/net/marvell,prestera.txt
index 83370ebf5b89..e28938ddfdf5 100644
--- a/Documentation/devicetree/bindings/net/marvell,prestera.txt
+++ b/Documentation/devicetree/bindings/net/marvell,prestera.txt
@@ -45,3 +45,37 @@ dfx-server {
 	ranges = <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
 	reg = <MBUS_ID(0x08, 0x00) 0 0x100000>;
 };
+
+Marvell Prestera SwitchDev bindings
+-----------------------------------
+Optional properties:
+- compatible: must be "marvell,prestera"
+- base-mac-provider: describes handle to node which provides base mac address,
+	might be a static base mac address or nvme cell provider.
+
+Example:
+
+eeprom_mac_addr: eeprom-mac-addr {
+       compatible = "eeprom,mac-addr-cell";
+       status = "okay";
+
+       nvmem = <&eeprom_at24>;
+};
+
+prestera {
+       compatible = "marvell,prestera";
+       status = "okay";
+
+       base-mac-provider = <&eeprom_mac_addr>;
+};
+
+The current implementation of Prestera Switchdev PCI interface driver requires
+that BAR2 is assigned to 0xf6000000 as base address from the PCI IO range:
+
+&cp0_pcie0 {
+	ranges = <0x81000000 0x0 0xfb000000 0x0 0xfb000000 0x0 0xf0000
+		0x82000000 0x0 0xf6000000 0x0 0xf6000000 0x0 0x2000000
+		0x82000000 0x0 0xf9000000 0x0 0xf9000000 0x0 0x100000>;
+	phys = <&cp0_comphy0 0>;
+	status = "okay";
+};
-- 
2.17.1

