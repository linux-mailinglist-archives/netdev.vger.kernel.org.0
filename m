Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FD51E65A1
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404251AbgE1POF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:14:05 -0400
Received: from mail-vi1eur05on2129.outbound.protection.outlook.com ([40.107.21.129]:54914
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404214AbgE1PNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:13:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lc4caU6+ksjRwYqJG4lXONwuG40whT6ctnM02JbeZXUzLsIy7i7K5Lcf7eAUJd4VzgjbTpj+cF9XfxAFljfwhjeTLywSXWuEfIMmD0Y+srLlkP0zE/p+DWtSacPYFxx6saiPz9g2L0zfHKjJgsPFx1QXdeGX9QF5vN1EAUW1VsPOiooEfV3rQNbgwf/RT8y6EtzVK3sdkBp3PATgNk3/P3LHAEzYgE6AC6tGX56t3cJsevwGtU4oW/fN6Oy0tFhvj20eeAQG1j16o//JYuwp31KcNK9cJHZrJTPFZJT3NsDichpkzmpztplMIfhSl7QfBACOvI5Y17jNDcJxpb9xuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=OsKpZ2BhMxdmLPbg1fM5Q2ZLsUiamjYp2i7hwRG9cE1tRiTZaP5EE5k1qTAgZNoV2ojiB2xIze1HhKm5e8c4NQd52Hn03Dh5p90giwFY304Fo5BRO6MZyUO32fLSmruCGNHKZ08x1fouflgyY/ZJqbBX/2BsqSlI3lmUKG7SUM60jYYTZlrPtilyn+cV/FftdAU/0Sns4sZB+SjNWCU8ftGGB49YefnczBzX7yLQQ5Yef+WME5UKTqXi0y8q7ged9MJYGED0y9U1Q7X1qzzkQmfJ1Mu6wJc8tDvlIgmV86+dXX8X86cfUlqaZv+N1AV7jSdus/0dtHDZV+6wA9bELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=hh+as38NkpgckOWD9L9JPDHsWfCXSwzhenATypifTW05dwwO9PN7UoGxKJlNOo1viY0lqji4dU3GHJebvtUHAyQsFbpOyxQAd5dJwcPW4SruypzU278HBj022irEpXQG+FOSRs6I9+/0wGfF9gaYPs+KJsgrSC2ydovCouhp0y8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0224.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 28 May
 2020 15:13:14 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 15:13:14 +0000
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
Subject: [net-next 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Thu, 28 May 2020 18:12:45 +0300
Message-Id: <20200528151245.7592-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528151245.7592-1-vadym.kochan@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0094.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::35) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P191CA0094.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Thu, 28 May 2020 15:13:13 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1da91ead-d9ff-403d-69ad-08d80319a4a6
X-MS-TrafficTypeDiagnostic: VI1P190MB0224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0224C9C06B7B1FB91E14781A958E0@VI1P190MB0224.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rUSo5Z70lUIYvj1Vqkd04fcB62ZdsylLLrj9BmG1nUl6ZKOAlPBH1yrqnKca7gUev8HHymMjYT/B/qT+/6enzDLfqfZW/jaDo0oOALJT5yQgCUZZsxNygLSU4wxEHnLHQ39/SZlnXaokjZHTtAUNjuKKUBV7E9gHuRJaCbtVOB8lZPXg36dmP2YgzVMQmRL+bxVfqZFdklCq5WwGCZgbgC5DguIrcUHZPqlobjPEFaEOho1u0q9vrlHiiIjNyOpq7RvCB6qo1gE1wU2EgHimSgHD/+Ng9wM6IkgZz/OWSXNCFVw2rTpPnbGoqE81qtA+nJjhN2yNBiBBTfOdXlVwz2d8c1VMiiptKQPPKXGt8aBk/zwsLSTvTBWVEcZJDbXbdNokguLx+ll8XB3Gpv6p0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(376002)(366004)(346002)(396003)(66476007)(316002)(66556008)(107886003)(5660300002)(6512007)(2616005)(508600001)(186003)(956004)(4326008)(1076003)(2906002)(16526019)(52116002)(26005)(6486002)(44832011)(54906003)(6506007)(66946007)(8936002)(8676002)(110136005)(86362001)(83380400001)(36756003)(6666004)(921003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rcI3ZVjViPDK9wb3SXECKCFhdURAt7dHoM6E3cAt75RKJD2BrAQydCC/483WFD5UpuEhm6ULJZbheZhcHcIu1tZOndC2gvnya0lA5+Ko8LhpBT6mM3OhK5v+KN4COUMKIHwUdiJpzFeC1s1p2ERy8FiSCTW67z16n4EJMNTtw0Be5PfF5r6KvWqlEatlSvQoDil4/yLnMy46idv4OmLsY9c+2QneDcKnlTdOX4yybJONg4SSLTMWdppG9neNuLi8isrJHlAbV08kNpX9Pn3DsgxdJuIPVTXMMG3sWJLJaMhVVn8Kks08FfFhoiyL5PEwdPbjLBWMcdbT9Q1Vc+W34+pvWZuNIZqD23e91N27GB/4JyBQLk4KYOfKd/LFCL2FHaADnRB/WbwLOBueQWMIgD96qDvP7rApvLuWy6zBtfgXPofKeyMPu8p4Y6ePZq599u2dn09/032f+emW1uIAj4w0UuM4AiSbbWyyWen6I1U=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da91ead-d9ff-403d-69ad-08d80319a4a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 15:13:14.7408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12YBW8nlu53F+WVfai7s3vRKdWl1s0LtZYBbmPqdadU55ntPlEXuRsQlulKHkC/YPXWaxrh+pVGZ5N2fGNPKx/C79ib5We+02t4LAeAlEGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0224
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

