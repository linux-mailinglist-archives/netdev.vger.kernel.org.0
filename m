Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D1D264FBE
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgIJTul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:50:41 -0400
Received: from mail-eopbgr60110.outbound.protection.outlook.com ([40.107.6.110]:16487
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725616AbgIJPEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:04:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHkdPiq3mss8syqZNNTzgfS9ZtJufjpw6trLfRJMGn4l3pSOgEhdxkdpkjutIBAvPMYfrq65auGWU8fTGpzQUVCOehURtTxrRQ1UtmoH6EUrPsAEpqojWQyKZ6J3Qa+gnmcRzUEnhvb+CY3l8JeDav6X3+MQypeEoLrwAe51a2IVhn9JQjctWdxhsOnj6amfW1VCkhZbEQCMWLND0TF/ETMAHQgs+Ba+KH4autW1txi+NH4T8h1lPbYhxPxTZRvNyso9zOpa6AE8RbViytHfrdSqfR85uuUoYzZcVO1P3lS2yOpvUFIVud3FO/dXbiGoJuZgYXrc6NAKzxWGTDVzsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=NcuSxIAgj61H84w0e46gnf89tHzCpthPEXeVjd5eW2imodpLDFX9XPgcGjFzYlRcfjF7NAaDohYSJJX85wuzYmVqSj68txyG6YKZCQaG0BIpOoDZGKq5REtWamBHZu8ZhDkq7LuUAL057vOEgffek8A0VygNcDfDTMGJI5wF/hK0j8KvCZcEpTe4H+Zsmt7O3r1ul/R709fTptWEiwZhAyFhsuOQ0RNfYi4kbOD/tbZkOQb0DElszlPKrrJKyAcYabM+oAe3OD1BcAQ4JXvPvJdI/V5fEDAdaIeDoFreXov2fCk/uWqJH+iPNRLEQOao/6UDYBodo31fRjHl4it89w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=NojERvsjo54O08RnMfIYKkuxV2VC8Cmv6ab7CrAf1GXSmuMaercf/q+Fo8QzfLXGEM0AwdrLwoWCK+Gj9JZ/m+WDk+RkAcV+TbyZod9v+WoWltsfMjBr6PVdT2/Sz+wRN385Zn2XWq/iFjep626lF2Xfs4WCkPlFB5+p3ic8LmA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.19; Thu, 10 Sep 2020 15:01:25 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 15:01:25 +0000
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
Subject: [net-next v8 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Thu, 10 Sep 2020 18:00:55 +0300
Message-Id: <20200910150055.15598-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910150055.15598-1-vadym.kochan@plvision.eu>
References: <20200910150055.15598-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::19) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.10 via Frontend Transport; Thu, 10 Sep 2020 15:01:24 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c48ebea-ecfa-45b2-b60b-08d8559a6389
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0459E594078DF47F00DC3D1995270@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: haBAvJ0it3u0Qujw43GjQBSdFiV8uALErBvD9wkgNyqrFQwIpm14/tnHqnZFffxkEHm16CoidzbCJ/Zdf9nKNdYmecBQPcx9xspLaqkIDPhlC7LkcgmUpMKvdOg37a0fMAwhakk8miPjw8OQz/65vxzmNNu3Vq9jsjbYc8lhZkQNk/NVCZ0xMRTaBsrG3CPKgyslnOG710p2tnHcalv2ym+0rshA98xJ+mhGAUeWxFFkk/3aig8yeIBCF5NO0I71MvVk3QSEAiMozb55ix/gFs4cD676nFOciNleeWi61GJIYVJO3WsoVQh+5zEqNkYnk0h2ijxrU+qv0rQ1JsIJXe4gt8Xgwyhhi+CKgMbEe0cQNhN3QgdJDz3WiTGYTt+25Kw5W0NvluEkC1bj0e94sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(366004)(376002)(26005)(2906002)(8936002)(110136005)(186003)(16526019)(8676002)(2616005)(83380400001)(44832011)(4326008)(66556008)(66946007)(54906003)(66476007)(1076003)(6506007)(5660300002)(6666004)(107886003)(956004)(6486002)(478600001)(86362001)(316002)(6512007)(36756003)(52116002)(142933001)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jnm1mTpkrVFkE2+MIVfvsnkCib78YJWuQg6ySoy47j+QxTl5DBNt5Wj0C1ZfGDTsRpqXBkjmZLE4/7GBqJFCR/QiEflHJktz3eTqPWFX1jL9nQ//ALsJAOAyOoTXbZFgaO4Mfy0qDXs3l+KjSDafxdF+aqTeQwiw7k5ef6mjTfALXciCxIRytt9DCaHH9vn86i8baoeZmAKItRNLAuQH2E1G+snaszlRP2Ez5HTMwmVt7l/yJHq4AO8AR9B8Da6tPVWUivlTKyeLM7Rh/2ckOXtP7sRYg3bLVUUp6cAkGd8JqtzmFaoVevwyH+jOt73bEaLEgH2tWvyuaYFEFrrl8EAPekf2IIKvlMTy9Y0AxKwU7+6UgFaCzTG2dQ6GSWFq7AHF6EsnhW5vkHj6zXdaNEzyBNfTpk6hJ7f9T+8/z1XpY9x2pI1lPQsVimO5k5hHJAYnxBGGPMsfrDnPWsi29j2cNHeaHTEoJQpVvEUVPM8bYzls/y2+d7qE6qoir9dS4QnxDgwu1Qthq7ung6o8WVXV9AR3diAI1yqgXJ7hqCljfFhWIw/P6xu3pexDekhsUf+rFqgWilB1N8Reu2gwmFMYNGaKpeX21n4926JKHvdbGZtFXJDzBT9aWFGtiFbArKemN/b2zcwrkzdJwufFbw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c48ebea-ecfa-45b2-b60b-08d8559a6389
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 15:01:25.8287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZC1W7zyoXsAAzA4+q1kQrPOa/Ut2YGlqZLk9IwXRstDWgrWDbtUNer6jinVbq2SUeOGaRjabZ2hX+FE1GBcKU3fVy63RBNCO1yJNUEvL2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
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

