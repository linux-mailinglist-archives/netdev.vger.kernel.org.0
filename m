Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A23F22D860
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 17:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgGYPH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 11:07:56 -0400
Received: from mail-eopbgr20111.outbound.protection.outlook.com ([40.107.2.111]:54759
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726567AbgGYPHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 11:07:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqZTCBApdFyVlmbq0BBUloOvLA4lbaqiA4BnbS4zsloYbcmSb5JjHJ1QwxRmbyHZHtgz6vzlZ59WiYsZky715V/OY1oiCx2mfCrayrfNf7F5swcya7/bCjgVIs7UyJ6FlA5VJLMo5iCERVpMef8vPzWLerQTCBBaEtdEeoHdfTIe9z7iyU+Kf6Wg3n0H+Cm1JztxGTaKIzc0aZqunFa0gos7aK+AmOrRkaWIMlh7eIPcjWZyiQs52M6RczUh+FTOYTN55ZTix46j2ki7LxJUsUz2MWq0X1dLDbrIXvJdxBGZp8W5aSq7Bc/qUVDjRnc3WqZN1wUuJ3XR4rEsey46Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=D1SFBzget2uoabrX9V+WIBu4DDhslVOitzkP97AgM1dNSmVGuURRndv86odS1BLoPCHUmNNiX65kbbSZmdKOZNk7HToPymXXORjcGcTPZy+graCO7Arq2pnlanfprSOnkE9+YBTskX70ejTQ8aTxHqyoWpygWEkHfXLyc/wkfRJVX+fKY9b6TmwOHEvLxFbmwWE5hA0vO5I+pmdlL67/XN+TyIYuq1Ry62XBFDWXk2mdKuGKOcsmjeztODcd/OYeZAPd1lQUMqyFrviCkn83iBvCYgKP/SCFWWv6kjcVQRcqAX4x6QSh1K2Dy5GVO89MnbmBLp3puLURsWZAM6apCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=qZZ3FZ5JFO1lKasgkhv1kC2WknFU2OovIoiFlavFbbWLbdGOXS2NjePteuBaZFtqB/fq3xh3HfG05lVTV27xwdwKNFxeDucLT59BZTBi0UHLPK7i22pEeWIcrJXAiEwuWbLJO/9iCoQj+2GJOGZIzDVRL4oaNjhf8uumKhsSXkk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0568.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:31::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.21; Sat, 25 Jul 2020 15:07:20 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.028; Sat, 25 Jul 2020
 15:07:20 +0000
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
Subject: [net-next v3 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Sat, 25 Jul 2020 18:06:51 +0300
Message-Id: <20200725150651.17029-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725150651.17029-1-vadym.kochan@plvision.eu>
References: <20200725150651.17029-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0032.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::45) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR05CA0032.eurprd05.prod.outlook.com (2603:10a6:20b:2e::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Sat, 25 Jul 2020 15:07:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79314075-e8b8-4fa9-7422-08d830ac6db1
X-MS-TrafficTypeDiagnostic: DB6P190MB0568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0568F4D1A599FCCF768C76AB95740@DB6P190MB0568.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +n+cnZmahHkFA/+vkoaVVl+BxLdiJ2y/JRpH1uMWJG3yU3LGvgrRTZBVAi+Gk2Nw9USC8Xve0VsFSLFSPJ7KsNkSD8GfWIsO/qA3bnLMkIBhJGMRWpNrU0T4SC1btofPbTmDKivPnaFNRiTxk7qynR/q0Cn5StM0cdCplMjxMCQzcEAW1/T+6QTGOYlHeeCLbW0IAWlWcCJCc+/ijGU2E1HhIOjrdzdJ7DFEPHKHiLhULyNjJi5Z1cTx76EwHOrPin47VsJ5rMs5LQhjHhRxiw1v6pcS9OJp6LLflkjcV181tQ5PCt96WhRLd4devY/Jy6wpTVPI1Y9iE+4qqA5zrA1Wvt/Q015J5bL2mdAfVJ9cmp9no+SGCmW6kdO5zch2APZgqX9kjiqgEljemJQK6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(376002)(366004)(396003)(346002)(2616005)(86362001)(26005)(1076003)(956004)(6506007)(8936002)(4326008)(16526019)(36756003)(6666004)(186003)(8676002)(83380400001)(44832011)(52116002)(5660300002)(6512007)(66556008)(6486002)(66476007)(508600001)(107886003)(66946007)(2906002)(110136005)(54906003)(316002)(921003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: efsQcYK4wDm6OsH5gFSzYTGu5l/G3+K2aIAZYMKcaGd8af4nIoumMZ/nOZ+ETKeQNvqLEsSHCkCGNuT4MeBLPXUzhUwtr9fLPG9a14KLSo5fkCE68F1r+N3sVU438ejeR0V1jXY61UZctV0tlxjVYxvThp0kYjZM6+Q2fWjk1wDzjA8CEzTEZAzN2MF3mu0wlSgdMCSwi9xu1M8R338o8rbkK+Eb1mhdfrzSfrPN+EsoFshT71OYksVw9hx06ky4h4cLz3wBOI/4tLksGmhQShnFeSA0qDyxvVpr9zlaMXSuN5aI9Es1+p2BQhdICpNgQnD83YTfdYzFkINAp5uB6uE/UjG6IQbpKbl/0T6EoQJNijPCtYg9zRrL87sdlarMslETBoP9p0LvEQb3xXCInXKNfwYnXFMREoxsntcg5ECRk7ju0hYtBA+AeVCMbi/Olc+i8hDzd0MGGJHFccdjqVXyWOIj3Ar7mo5Cnvd0kxw=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 79314075-e8b8-4fa9-7422-08d830ac6db1
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 15:07:20.7978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RllKaqvEPUqSz0JwKYQHpnLxsuekQywwXTuFVFwOb9fDUsSZrH0YI2VrbmCTGMMealsSim34fOC7gD4sJZOLnd2Qgo3zgGotFuTYogtqJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0568
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

