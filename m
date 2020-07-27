Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C1222EC08
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgG0MXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:23:45 -0400
Received: from mail-vi1eur05on2133.outbound.protection.outlook.com ([40.107.21.133]:30592
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727078AbgG0MXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 08:23:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWbZauqValTq+lPOcUwqeeWENnQpMlyE3mJWraLU9YcCgpy1sZH1F0L/AfyeP7npS/Hpustpd/ln5f0XIRH7ZLZ4L5rZF4ZnVUCjkTgXvm3mq8XpJS0jDIDKjGF+2R4y7T0Zrt0zOVe46c5TSCY+nT5axYi1Glyo+NzqEvu3fJZR+4V3OZT9o3M4iCocnvuO+v1QSNwr4fzkdeJRHP78uvYHK/6jDws8+Oxfduju1stLfotcjOVzxEUeC5QooGeKTYAAgN7+NXmCCiZK6HaoJVLJNG7QPMlosWiNwJs0GPWxRvtBorcIFV90oSARqiSLi8W+v8DK5syBi+e0firivw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=nJpdiXBchMStZp12/IDSoxNnDWNMrSpzU0a81V7bhcPq90lwZHcXZjbAm8f4EIXRpYMzmjcX1fkT7wz6r4Tkb5UF6LOGFjFWXVjtkQ9w0ihOFWCXcIaQIHnOBcJ0zTgsTIrEg/sHK8e0w9vVb3ULN/55Zcz+/5sU0q7qX9D+Z3qLaZyIgAeArk1XdRGssd8U1rnAj3ng/PwbRMwa0SFo1s12Ny7PIvc8Ahf1+v2rXmUf29wFRkmJ49N0p/DUXgF7iYNBflmhYJC4crN7BNv7gqm5yG30KL6NRoeYnY7rJeEUOWu9xCrB9IVlxwII5MqoqXU6jIuF6F8Dd+5JRLSWPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=cqNj4ifF4KDZ2CorUfUPihKYoM+rS0uVInD0iog4/jdW8Gs/Sja78kAxqTqECyLReSOf2HKsmWJOqrcp9/4eUvfEnxxMj9n+SnTbYIA1BH/wM2WDBnbco4RG1XopIvf/o1bkxtdcMT1g2WV7JI7/lqDyP2JYy+gLE3YU2qsI234=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0151.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:88::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Mon, 27 Jul 2020 12:23:18 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 12:23:18 +0000
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
Subject: [net-next v4 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Mon, 27 Jul 2020 15:22:42 +0300
Message-Id: <20200727122242.32337-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727122242.32337-1-vadym.kochan@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0010.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::20) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0602CA0010.eurprd06.prod.outlook.com (2603:10a6:203:a3::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Mon, 27 Jul 2020 12:23:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df3ce69f-3289-4faa-1f96-08d83227d808
X-MS-TrafficTypeDiagnostic: DB6P190MB0151:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB015129C183896F872E12A90D95720@DB6P190MB0151.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wGnzy4uoyOHPaRmcHfrAOeXZqtvyxMkA43WyP8c/Rs6nJSH3c7xzwsYriDNxp3Zrat5+1M+hkKq3PJ9j/rUShgoiOQP1jNKQPnyh4lWRMcrI8rhqo+kIYuqZhExPw9LPT2lSvwViF5ewbCrlktSwhDxGRjhoXGeqK6ImTsRbLsrg5pSGHDkL6aMM0oWhnKtekqa+Oar1S4ZNH0Ep8g/rBfCaTJbB4t3V1kUVxpTWXGtmWkNy6/AU54Encpc9spvmELVmEE/35Giz+9pl7lFLMuoMD6iZ+rA9lEozXgmYpBq13RsGwVrcnbLUjl5F32NPPQfOcfnMg+AA5YUwMVLo5sEuXxeZHK9CyOkN0eCtMqGfNg9L9KfSUAe112K44S5VxBaH88hN7t2mzGfelZtUzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(39830400003)(396003)(136003)(376002)(346002)(366004)(6506007)(508600001)(83380400001)(956004)(52116002)(316002)(66946007)(8936002)(36756003)(26005)(2616005)(8676002)(66476007)(66556008)(186003)(44832011)(54906003)(6486002)(110136005)(16526019)(6512007)(86362001)(1076003)(107886003)(4326008)(6666004)(5660300002)(2906002)(142933001)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sBya+nhjcfsePgY3ef/d495K4fsHKwCT1k0Zuxm1QR0gwbKD0a1pNRga2vMIClfaBLpoyyRNEUX/MKU3unrkn+uu706MwzRDA3GtcJxZGcXnprlhk9+K33c5LYSVut24ZXgl2tWMluxzou5QifdvM5Mt5ViqLf2nb1TIgnCXst6X0HEF9cwKePi7zhnRfDl4sk8GeWSdyfGq3YjJQWLvOzRo/M7RPsjwD0KP1/f24QrZo4TN2R6wedi30kXtH08fQ5bnjT/pskenpj+uw6s13V0XkuuCc9fz9wxc1xBKL94kiIoPLA7UhjgubiJ8FWZc9dxsPcQqaqqKmgN2hdz0W3ivqj9zPcEqCv8TNwnTR1nJSqh6GFPDGcYVeQpE8ABLckObH8rexyMp16rwtfTOCts007sC+oVqgS035SR3cMe4bvl3EF8oFkO2pC/fSJXav3Id5OXWObBbSG+LOzaUC85b6SV+KzaiW4fFdaIEX1w=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: df3ce69f-3289-4faa-1f96-08d83227d808
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 12:23:18.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ifNWvjCB/7VJuBoBvrEWq56bAxkuuPkeYZdmvc+AkqRjHY0g4Pwz0n+KWJw1Hi7CBPoQLSwz7FVf3DRzVhj7AVD9oI/zeKYnPVk0kgJnyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0151
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

