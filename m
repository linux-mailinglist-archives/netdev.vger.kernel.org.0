Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E2525E04D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgIDQyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:54:06 -0400
Received: from mail-eopbgr30131.outbound.protection.outlook.com ([40.107.3.131]:14643
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbgIDQxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 12:53:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndcFT1NuqoteNUfY7sWTOWRzno3+/fQhSVjw2WzBHkGmrVeW50Tu/dS2EaQ8S+RDR7hYCUvFokwHKOmnah7vxlqkpqZNwT+deGk2xNH02AKRIQBxbAB7hFzmDyvCf9rUW2DbijqkQBRdTWdvtaiRk0XN5wWCGwq1C3BaJJbmQY2pkabh1yzEG2S+sOirCVfVGONxBDH8sFad7wQ/u6jkUlviBWZ6UCvYQuQtUsPBYxmlykjJ58nEBwOraUrX+j2VKvN8bkhk1xemKb5LmDSKKtFDFjGE1DCDfTa+IDg0GaLkjuXFOCI6U7iLmzzCR6PBPU/XzOLK6WSFgoA+MmhMDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=m2lWzXF+BZe2UAWcyUSbT+cTAL62G1SHv9my909iqhNUF285tRVGmXCqx57nkvBt+mxm8YDnLIkI+0piseHwWqBuAn9gvtte22zoYi3Ru47X3w/3ERD2ABc/7DsjJF70w6xSOvhVty5VWBufDBUrXaeXhJUcaeaalji1Pr9pfh+kjL1CRJiZImOeLNk0FDL6CiuzIgSaACiMXp1TnvQchXnH0KSuB5AP6qgu7DumGKQsUD2kYW4xD1wboyozi384EK2D4RAjO3gu9m/iL8gI3mVc7VnFPVpGasuumQSPLpwccLYJwuy7dChz5d0NsrnxzCGuaPAjdKl5BuKF5hoP1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=gSINGzSBjjL9JkRC/BVfeA8enlSyfNxgypGVACf/7NtNMo1ALVoWNrYDo4ieUmHQlz0xKEb6eoKK+LXbOpqkgbTLFPgdun5/JM9ByDNvdmHesjdx/wBtuEmd9EjBJg56STyWD+6vFWdcGYkxwJtTqAYq1FDVfs8ApHAlWM69fp0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) by
 DB8P190MB0730.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:12f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Fri, 4 Sep 2020 16:52:59 +0000
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765]) by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765%4]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 16:52:59 +0000
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
Subject: [PATCH net-next v7 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Fri,  4 Sep 2020 19:52:22 +0300
Message-Id: <20200904165222.18444-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904165222.18444-1-vadym.kochan@plvision.eu>
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0062.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::39) To DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:3e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR04CA0062.eurprd04.prod.outlook.com (2603:10a6:20b:f0::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Fri, 4 Sep 2020 16:52:58 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e099d3ee-0951-4869-d028-08d850f2fada
X-MS-TrafficTypeDiagnostic: DB8P190MB0730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8P190MB0730CF891E550E0EAA3DBFD7952D0@DB8P190MB0730.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PjqJn6D1Od03QKZ7U/Ge74HRW/SA50S8KsDq2M1LR+rxvjEULXKQLanmrak/8fEgbKyJ/xMZVNf87tSb/NkVCZCz9HNBqZtpFqkq/Zdg0n9H1WqQoaDGtH2tfjjbASpCWP86sFJmRMtFz2mV12K4XR+vQirztsBFrO1sq65I3rg3Ib1k82w0/f22aMs506bZdYbVr1wTZtIxVFtb10VBORKElIARzUtxbjotygX1abFig7M6RQEqAeLoUnBLB4OYDpOm6GF5kZx+jp1AZxXTl61qaIy66uOXRK/0mgA5hpxGU5YQkpcJT+IR2C9tzFwKZss66p2ZRNWAvoZ4tAFTNTlCfVpPSKNufs3NBX6Ig4u+jTxB2p8wkWdbfccdraruuDHr06csoJrPBPXAjqTBEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0535.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(39830400003)(346002)(36756003)(44832011)(4326008)(2616005)(54906003)(956004)(5660300002)(8676002)(6512007)(66946007)(66476007)(2906002)(83380400001)(110136005)(66556008)(6666004)(478600001)(86362001)(6486002)(107886003)(1076003)(8936002)(16526019)(6506007)(186003)(26005)(52116002)(316002)(921003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eRkececr5gE7esYdKe4631+HzrpNszY9sLAQDjSxc1uvHo0t4f6qU3cBGp5Bes8lRdg0g3BglWVYUpWLqpO1LMN5vf686a/qkRQN9CBn73ECGtK5O+jDT65OUREnciSQdssp7/DN8wUCBpqgv07sguX3UAbxa1ysXJxzTWXlNUcO3QLcFZfQIba22gd+ByY79WrhjB45OS0WHbjYoP6nGq7jeINKe+4I7yjusMutXdcwj/IuPARWptzi+eJaJjKI3hAqsS5+07CKFHEVnoL05ITAp2uqNpxSsPWZnRw6CDn8gNhvehX4w/ciw7ohDtmnrE8/yFfi6Zxq8WvXY5hXNmLCZ/8H2H66pFemKXo5VFUrXuc67kJDhtoP+IqS7lg1Xe9pumRrc3djAaGFFsIUjkcY+ZdTQZrGBFR0o6s3BTMSrQGazH5YSvDbL/dj1feg4y9gh5r9sTtxj9O5cJEPb+GkKZTztWXo6ktqlobG/2g1rGzp+QZMxJ8B+9kRD1CdnZVhr5yagrweM64xKrl3ANB5xB2lqkOan2rv4UoUVVzx0Ya49YONATpFxgt6sDYJrzvz0NW3w4qLR8F4ZOwMbEyyXJ3zBDHyAiOcKtpoInk8vgKfOsFa18lWUYNyI/KRXDaxM3P0178+s+tkRBx0CA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e099d3ee-0951-4869-d028-08d850f2fada
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 16:52:59.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7SP89KzUq0xtqHL39nihwZThCfFvq2QdNRa45NFZNJuxCVV6OV116/bav7kOEoS0jXa22b6zKddnsY5kZ/2DAQi/nbtw2YdAZHdYDiPYcvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P190MB0730
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

