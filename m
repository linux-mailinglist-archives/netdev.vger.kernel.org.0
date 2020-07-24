Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8246822C7D7
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgGXOUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:20:53 -0400
Received: from mail-eopbgr40118.outbound.protection.outlook.com ([40.107.4.118]:8615
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727058AbgGXOUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 10:20:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3aOhLRFVeEJ3GCg4nZVI/t524S2xEpAJE5sWBxK0JS+PqY+QOejxVWF4tJz/AxyMKpdyUTwmFA/cesxo7wAyNnk22ltBYuf9A3Bpfbx/aEP3ia1CTWM2mAmFQPFCweewznMrSdIH+NXoITX9pCvbbTQqBiS32/L/kQ9XJdKlZbsZ0NdfMOGMLkYS7jeh+j345nyZjCWbQvXPKO+AArWzqUGr/qotL/gA+Zmz0TczNirbJ/jSBsFFqEqZsfpUUB5DtDDwviPAGcXY//CE6xK5TgSOD5+V/x5plU3oHc0LyEp12G2RdnsioE5t7HyxO8x6BYnDEA5QmVF58u02Dt9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=JjZwbKcCdtLcfCByNeg07pCufCzfdkImNxwWc1c7fFytoFOguyzQ6mUPH3k2q0XMxsk/ANW85kccLB02MF0E5I5O9aJ3TbpvIx5NUMb1yAYXYaG1N1laMNb/bMrqfTPN8tSQQNkMiwhyNQLl0kfggidqGXUeJq8dJvByDzzVG5qJUz4IMg9/vflpE7GNLmUC0gayTyoULlJJqsmidhiAJNHSkwvssG8FbkvEvcQE77D6kLiq4qPILWs2zRCrxUYpOWy0P0H//08lKs8ttQjD5jUIA1GY2znAh/mzr6aWXnwusQalT6AAiszwAP2lanL8vTC0OBE2ObOphhi2i+XT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=wotcH5GLMCasj63nE8GmMC3OhN5l5TY/kO47JYmd2kDzGrDP8/vDOA62veHIGBOKW/7HkYn/WH7CLScWkBP8lduz1vpvcoYvy2DwtA+vmBlxnYjJZzdBCOr26W0s68KRT9MK8fXWtUvvsS1vXNzasWEVNEE4H+mz54O2k4eDFqQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0181.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:88::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Fri, 24 Jul 2020 14:20:28 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3195.028; Fri, 24 Jul 2020
 14:20:28 +0000
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
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [net-next v2 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Fri, 24 Jul 2020 17:19:57 +0300
Message-Id: <20200724141957.29698-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724141957.29698-1-vadym.kochan@plvision.eu>
References: <20200724141957.29698-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR01CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::44) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR01CA0067.eurprd01.prod.exchangelabs.com (2603:10a6:20b:e0::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Fri, 24 Jul 2020 14:20:26 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36b1963b-c554-4132-a247-08d82fdcb6be
X-MS-TrafficTypeDiagnostic: DB6P190MB0181:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB018139578ED0B737E8204D4495770@DB6P190MB0181.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sB12euReiPELJxTKIaqo5g+lXcQLSR15NN+2XGfx0hmbjPeKO2J1fIvtxDWEphj4BGYbQyJptmvnxtRKaVeG41fjUvIVAQ6q4FwsNtThiuN2MxAmAosryUqShoqzFNncuaCgIMr8gaYpQg4nQ3j+OzMnD+ev5yYXWgZcumI/iYbpKFOmhUIzqzOUy+ell/swPOk2szOdt7nNe45yrtxl+jQsJoYEukEg9EId5BbYHEh04655L9RmyFsAIV16YXhyKOX/Q7YK4JLl6kskDNffl4EZEKwMBy+gEq+QK0Qp2uJYySzt5bIEYV7Ivhbr4JFF8yJFIKKX67K9BPnLoMZm1tVgM2zeSieTDB2kGoZqj5EewI9EnugwI2M5FeSAY4iZph8HaBRy0kWSmUQrKI+9rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(346002)(39830400003)(396003)(6512007)(508600001)(8676002)(110136005)(54906003)(956004)(44832011)(2616005)(66946007)(66556008)(1076003)(66476007)(5660300002)(316002)(6506007)(6486002)(16526019)(186003)(2906002)(8936002)(6666004)(4326008)(52116002)(26005)(36756003)(107886003)(86362001)(83380400001)(921003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2dpMMvrwT9qL3hyee3TOIGwkEtcKJAf/49i+tKidZIgmjaLnkIb5TZElE5yFcY7KFrGPc6r6rHXxOpuJ1YUQ8CBjeReXHtApHzdWbwlKjAfFPA/KkTbdP1WpfF1Jur6vck7PiP9TbnxlmyUoig8Jz6qx/q81gohfAtrSDbocu3gTUGXvo4pRlUy2oLNfSN4RwPTDG4QtlMpagWiaZKfdVPneJAREha9kKNAminhUItH8Dw//4Z8vtI16FKBaOQySmh+vxSmBK0N+BrBXMCSv9bW6gl68GGtMHc/vIAl9otOYDHa6+GpAsMWDo196b7tJ0BEnSOGDsXx320HPI9DaOvM2nG09iHiOovU8A3p60GnHDGgrcffCBvUYJwpERL/386nUpVH/Pxm3gYzlthCCm8n4l3Q46ySjgd0vpwO/W8FDPzif1n/BzuuN/RrCZFSb5wI21bgaZceTK0iyNQLFvguFkA+SfWlJ4xeWl27Z82c=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b1963b-c554-4132-a247-08d82fdcb6be
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 14:20:28.0191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynpEevo5wbgAtsG0jLtz7FREOZmmXpixOUqPn2PUVyWI08XMpFq34TwJWmR6QgzrpWUl8Ly5G6GZzQVsoAg9VBeXJCSphbqN+tdcxjsnNBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0181
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

