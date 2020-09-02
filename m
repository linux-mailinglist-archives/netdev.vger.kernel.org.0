Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DB125AE7B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgIBPLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:11:44 -0400
Received: from mail-eopbgr50103.outbound.protection.outlook.com ([40.107.5.103]:57523
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbgIBPHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 11:07:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d61yNW/Cp/RXIfSBMc3J5FCo8lPgwgXWiYj+pqByuptxr/3LCak6HlG0wGYwphMWUz1nYZt02cX0l9LMAYDgBuv+SvXK8HJsNVXXqyxhguMjmbgaKVI1PRXy+Z5fblyt6eT3AkNcYHyz0k6mJFzuNQkc9SvWOk+lmu/Is7YJZFDJnsDO+O5bZ8MFKE7ueBXDfUS/m/xLDXQT/i5qZDvWEdQRCv6MRHW1K6z4slyHQVKoG/OZIdKy5rd22QqNVuu+KR6H+iHm89UKdJJhro3Xu3MqAqmvFfFSI/58Zz+jSEGIvxRWQjT9pATnjzwkcO8zZ5MFHQ9z0govq3P/Yc+9kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=mfLDYNistCmWo333IDH7dkg8wpwP1l+xDM8Jbww0YMPb8vlRNU8mROxGThGLYfteWIy56B41fe5TZpeSEaeb8n/cBVQPYiePFy79CZBIJ0ojMEor97QEYaVtAicmb1NteaopxcaPTavnzunOvzcAGk4kaGlzJqdRY5QkcNscW7mB9RTyLBlVL+YF2uWI6fbfkiWGau0F8+LwFupNKQuN4JWoviq8/ZWbtKswxLnUSUol904POjzqiNm5Z+F1D+ynEm9A7z2C/vSvMT2DKZ5T2gUR+XnA8yirrVC4mtwMdQaaX0chnO+CXpb5WlFc8LkScsFw4sV5ImtS6nJaFYQYyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=VOUVSifYGzYGTXDA/qBOKJe/uk67J+7e/lKIC7ldAzYnUltQtA9IgV5Oj7dq/B0b/WIkjeMnxBh9c8fRUjvC89XQ1glAJuWY/ip7/ZCRqbFPkIs6lbFwtpJIKuNLE3rBoZ8bWdKK12OWD0wHjG4qh5hq89CJ54mgzXWEtNt9/+o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0058.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Wed, 2 Sep 2020 15:05:12 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 15:05:12 +0000
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
Subject: [PATCH net v6 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Wed,  2 Sep 2020 18:04:42 +0300
Message-Id: <20200902150442.2779-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200902150442.2779-1-vadym.kochan@plvision.eu>
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0110.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::15) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0110.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Wed, 2 Sep 2020 15:05:10 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaf4028c-557d-4517-1cff-08d84f519726
X-MS-TrafficTypeDiagnostic: HE1P190MB0058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0058633C3B84CEF7AC1D28FD952F0@HE1P190MB0058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aqcUTNU97lHGcdbr1h296UXk1ZwcaZOIcutcx4anw0T+KZ7hynoUiX3x0GkVgPU4LJwzqn0zghwnsDUyS27DTF7tBL8vdENJiwwyedWeg5VyjZ2N6nyaJ5hZz0JuzrdUphAli6xc4MOgPvn/bVM5pOCrSBwmozFiFNw6/AP2o4FLFg7O/6gMYfPK9OAF5ReSmNfYEDRddKVthwtwDuSMfpVqlp9flPjWaqU/4apX+gWFqzBseQvD6xJ5TE5A2nlm/XO2dbwrfNmJA9nMKWtTIdtPkBdjyYvIKt7S9BVw1aPLRSmgqWECoLL4P6Nwcuep+msMQHO6Y8XaCpoCXqACj6QzO3fMA+NWee7gg2Uqm5zDO4DnSPLU66LjUM7n21oyNWW3gW0fXXqKwM0pIY1sGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(39830400003)(396003)(346002)(366004)(107886003)(83380400001)(316002)(44832011)(478600001)(54906003)(6512007)(6486002)(6666004)(110136005)(186003)(66476007)(8936002)(4326008)(26005)(36756003)(86362001)(66556008)(2616005)(2906002)(5660300002)(1076003)(16526019)(66946007)(6506007)(956004)(52116002)(8676002)(921003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tyJta28nMsznEmPiv2yTGz+Hr0pKeUcowkTYCLjxYM7PTJzlgqdvVoPb5wZrpx3uR8+83p7FEAnnIbt+zmAg3bPcLscoFC0eER24BImtU+odek5eEycoJcyzsbryCo11pOCuvzjrESi5U988/CUSFP9qwDM+jqDTWAovLMqMa7u86OOt2Zc23x9IDtOmtXibjfPPrEgh25Vvln41t4xbmRg6yKvXugA+Zozrja3ltbrwA26h+RhtIHHB3GlAencNn2i5PKJtcUy9nPfEyZC9OQPHWn5SSC7VIrFqb6jBwqq9akY9+s15uJR4CGOLdGkdu01s9pLwBJiSwt4n+ojLTx167zMowoLhUYEIoPo62E/P+EghOl2AluMjGuAuTGclqeETEbZOCbMha5GP68yX7LOalRK7jo8NMSVosWvCB4TbL/qXRpbxS6rztV6BfMGqkGw4oQXU44ugEM2A33pWG+NWLlsufQ8S85P1kGVV4pKihDKcpO+T6LfgnXJyxEYT5RClc69m40dTqlPGCM0IbxgxCDpAtqIOd4AY7ebxmNsT7XPNta1M8LKF3hJCPRBo7lIH3TfIPPuUnfVkpd6bhxrdtHQlMNo1FfafdvQ9IW/BgqormkUUvRp4pG7rphThA3jO9wDXP5n/sPMvns9WiA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf4028c-557d-4517-1cff-08d84f519726
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2020 15:05:12.1117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/X9CjtWhPvVC388Hk/2eYycvsGzJ3mzhRG/Z906uU95Q0G42yXeLx/Qp+5uvxUIF6sJYW80bCnQ+QMxG6Alr0zmRWtJ+PB+4GwqjLYoDI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0058
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

