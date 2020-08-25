Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA94251871
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgHYMVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:21:06 -0400
Received: from mail-eopbgr40122.outbound.protection.outlook.com ([40.107.4.122]:1511
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726015AbgHYMUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 08:20:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnuHUESqRpeGiUUtwZz7EkVmq6un0B7jXoNt963iBinTPOrFzgthWmGgAx1hRgWSxu3c5w1LiJnrwDTeMfoPglWWopZJMiUta8A0kxYs9+Adpn2IhPP2aAln8Y0EWc/NzGiaAfayBu6OcLvZPQJPRzLKzOT+k9wQi8r/9L6NBHBzEOpa0p4+wBpBg0oui0H3Ye7y1KhGoDRDmmq5eZMtOr/Gmrhlx+tc6vY82qATE3yUss80FX9CWXo0PW35ZOtN25D3yMaYofVA9IdMScUWrufbCW9uzjCW+fbFAedbE0bzPp6zL3yHk4tfsCyjrIBmTqq+MeDUKhxOi5xXuURuGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=UHkrhoJvibPl2cfJWGDDgLe+aabDfItQlOs7qrSa9TR57vjJ3rqYaZgTMCucou1gwQfDXP+H2vB3CdR+dR2RUd9tOQktS/JQtOWxgBPZr6hxH4qvESqvL7N1NEt+T5EPPZrZb/ZVB9CQZxdC985WtjrS+V9Q/zI12izKgzXkrdvVKjQnBe2i1x0zG63KV5MllTLjgsQQ9Tfypu6HmkmrPD40QJk5x4/in19ohlueDk3/qvs76pDsxvxcy6wA9IXy/8aPBnVvu/TH5QJvj01FEDdwdSeJ5C5evxR6J5vbev7aHvd82ibj2c3Xigok6KRlwJN953QLTPAWtO4duskWew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=kV1OSLF7dsuIlsvePPth1FA3BqLHhUOaw1wfKW0Yo4bpkwby+YIbOEVXRcgnhkk4UkIebBQxSXpTt3YTENoemRuhxz70A79c3O9aq1KPT0iTSA10oF8msRG7oX/fSBo5tR62FoD91IH69mmM+nD/G2p+0YD8M+MPC+9VASZf1Qo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0571.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Tue, 25 Aug 2020 12:20:46 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 12:20:46 +0000
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
Subject: [net-next v5 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Tue, 25 Aug 2020 15:20:13 +0300
Message-Id: <20200825122013.2844-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200825122013.2844-1-vadym.kochan@plvision.eu>
References: <20200825122013.2844-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0039.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::27) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR08CA0039.eurprd08.prod.outlook.com (2603:10a6:20b:c0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 12:20:44 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 025c3205-da84-4c57-0131-08d848f14b17
X-MS-TrafficTypeDiagnostic: HE1P190MB0571:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB057118C41A2D6E3D621FC4A595570@HE1P190MB0571.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v5Pu8x2dVvRYOJXzXWFKfq504x+dcb70TysduWH7tVAFIR/eQUp3eH50X/0IKnllrikwVTiJOyseSxG5Q5WZglNMenrs6MxO01wfEoiMh27g0FyEUcXp33S1Lk5huSa9MZiwPwntwGQ6pucbvm+eO9AaRdR0z0VsLVm+WhQlq3blA/KTRb/zXuDESlhdz/BV1SYV53LEdEPhmZB29yliMFroMXkAUY9j2yZKfwrx7aY4ZmZviHA0reXCCGGhXtyOeXZIOfEIIlFHq6F+jKhxbXI0kxGOolGaKCSlQVFD+nmvxmRN+ZiMwlYP95qtjUGKgWVw99srJWSbJuybwUirYwCR7Erwu/pRbZVUzRq7dFbMJ2mTAPYRGEtzceIrVWwIg2LAWmFwwL41uZ7hsWUMSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39830400003)(396003)(136003)(5660300002)(8936002)(2906002)(66556008)(66946007)(8676002)(52116002)(54906003)(4326008)(1076003)(110136005)(107886003)(66476007)(2616005)(6506007)(956004)(478600001)(36756003)(6486002)(6512007)(26005)(86362001)(44832011)(83380400001)(186003)(16526019)(6666004)(316002)(921003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BmLaAyLOiKKCZ1L847+OFfhUoXghWa1m4rxe6cMoe5BVM/LNs/Do6Kj+s/f4jOreh26hhJ49/zhrXPWwAqRwfmkBcCRu4o/9+lJu55KrPVa82mMD3USSTamyMJDCp4/c43dT79r5vvTx5bj3DTwAX3XWjbByIQQE59mfvFSS+Yp0/THrf3T16dP3MNXtj5l1qA5RdKllnKlvUOOBzyPK9pSkS6qxW2lJIu72rMaLtUKXhRbhZQ/QlUocQIOP8oVBL+p+IfQK/e094FPXZOGCf30ZLmXX03RcUnTmuLBtD31Yn8Oe+L02wj68PYwYqSyvWUvtEuq9fi3WvJY8dhuuNnnXWGgWjv387AxSKsOHJmsWnX24ioe7j1xzVV2gUImBp6h3OGduHeCkWvbNUM/vwm/DePPjqKkVgIeTYfUbL/8PjjYxBJxb+cZQkO5um98Hd3NTn0fMUYR4JUCYadpEiichPa3joAYJSuYpN5Jaskx2VgOtmQ1y1w0i7RTDQv8i4P31PwjbfNXlgYgkXyxf7PCi+PjzhX4FBIqstmhA+WzyVkmdgYvPz5A8CL5L9An5QsbSOrV9rydPUhlnIraMue/23VNu9ai4d0s3WlzDNCgajK01BQYXCo3WO52Itl6VWWeWUiy7N+Ws9N3tdfRv3Q==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 025c3205-da84-4c57-0131-08d848f14b17
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 12:20:45.9163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zXrFnrnYHXLDNm9Bce5s5ItXxZbUJaXWa1PI4P3mJqHoOZNunQfQEURQ3fFeyxcshv9cIy3FOH/YuhD/Nsyh4oDfy8fGoK1Nklo3ul4LpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0571
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

