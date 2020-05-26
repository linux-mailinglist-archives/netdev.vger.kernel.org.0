Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967F41E2830
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgEZROp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:14:45 -0400
Received: from mail-eopbgr80131.outbound.protection.outlook.com ([40.107.8.131]:36848
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388612AbgEZROR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:14:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9q9TLujYxPh4CF26CmLfUOPOToNgf7FvuitcoWsUY3HUVzAaxf8UZYpSYfzh4HX6VURXUmKIDCkeJrQKbv7yGh0FuliAkJhLR+vFsfTPpTkO57zxR3mXzogQB3Y+8DPvulwsU5pxiazvKFQPf4OOK9P8LiUQuLqacEuGheWOsAKwhB+lW8/MeJ5v3+zr1a5nHK04fRDtPmVN8uk4vNOsRunfx2iNyBQoKwu7Qtk+Eu6jFYajldvNYcRisxnJ42lyQ+sOrI8/S+lKUQrlVrIW0m/MkyNcW4I1lrOfHzOfAPz9TX854MvN5v+c1dCoQ33++EQ6U8+oLADhNNm8Yvasg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=e6rp5zvUY8PwFnf+dBh7JMFaWFAgZQBmRMS72wcj0UY/m4s4M4A/gD78nys91oRLYowNPh8hfx/BBVRVcM4d5bSEIe0fEh6a/ojwafE+EucoIhkS1CgAjsoDSmjCTuQ2QCVXyH5qWkzqC9N730w32FXmZBR/DDfnntsInGAP//UkipPUASk/pbbqBpti57KepSvB8M/sQjFqR6A8bG7L4LkWhPwflBTDdV4b+GUcC6nwfVsyuDJ/ihicfvcGPjOXtUiIQwnZv1xwG+ySx25UfYIGSINWFmlXBRoz87X544t9mCIjyIaq2MqZUl3iTpCyTSr0oBAd9QCvi5AGOvrTSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUm1aS9UUuseD4nWcf7QHncYBRxQA+2Hm6PztoMAtIA=;
 b=eowH02iJ5OQMW1jolI+0oYysB+NullErXVP+JFtxUbnFPYciKjwdaDDDiiKpYQTJOppTk/dHkBfsftiMx4oGF9MtlL+rnOP5ZwMtmluqLcD2n15T63ctYAVZQnGGVCoNQ2a72zhLznAEogoJtlOqcc74KRaz+bq2e7syHynE7vU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0431.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 17:13:51 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:13:51 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
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
Subject: [net-next RFC v3 6/6] dt-bindings: marvell,prestera: Add description for device-tree bindings
Date:   Tue, 26 May 2020 20:13:02 +0300
Message-Id: <20200526171302.28649-7-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200526171302.28649-1-vadym.kochan@plvision.eu>
References: <20200526171302.28649-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0061.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::38) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P192CA0061.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:13:49 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a104f7f-ed0e-4494-5e77-08d80198295f
X-MS-TrafficTypeDiagnostic: VI1P190MB0431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB04314F0DB6F9EEB7CEBBDA4895B00@VI1P190MB0431.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: reD6EA3Cr8Vnzs43DCM1mBCUqfvQtM+faSFwYFZhcy4fGH/h1L/fpsBcEVQ8AtA7CvP2784Mcms87sjim6xxD0RS/1UdpJbGtFKUat28EjEogZ7hMxL5AwmkEg2ED6Ja66Go1WNUwyJvA/cA4wQiG88IJZVINwCHRgawXI5wlau5c4mqHlh+p1TloJssuiK0EMU03kRRPkoCRPtxdBJ4ba+5tZEvid4RrgCDlCmIun9xgWHNXz8NZYCqOa6ta2TmlNW72GHoInSouT13cawYjbdi3QZESO78Hf7H6BOynJ7ir5hLQogzm9b0l5mMlqke6S/F6tEkNMdc+fAiI+MHEcoO0d83baXsD4SVKkPK0rjyJLSna+zsqpN41MRZ0GResBOH1//BqfaS+xIpUinV8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(39840400004)(376002)(136003)(346002)(508600001)(16526019)(52116002)(2906002)(4326008)(36756003)(6506007)(186003)(86362001)(26005)(6486002)(8676002)(8936002)(316002)(956004)(54906003)(66476007)(2616005)(6666004)(66946007)(5660300002)(110136005)(107886003)(66556008)(44832011)(1076003)(6512007)(142933001)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3L6zQF7MLzh/MbkpkDvThRVJH7/vs9zsgw8KOyBdW46hrNeHakP/0O+WueX41Vp0YGq4p8qy7+oOkTjQAmlWgSxObi2PiARj12F9vV2YT9qBL8jIUCorjUWNi8qaskGTrIdY991/TmVGMvOKEAvo/vxPfSdaub8FHJcdjKqxHawuw31jJlA6gQKvKNr2G4GgUYLvfB15VbLUgWog/FzSGoVv+vCNAPTnZ4RCkQJzyCcueyJHBBQeYK+wg5KvimIwbwNMmuZcOQ6MlnIUj6xPU8WHEnsLwYvmQxEglheTGjISMPAOYy26XjttFJoiygZ6q54KBH8ImlyDG7Rl8uaH23KajqUjqg4hhocCzsByzVejz5heEW21eJhH7x33bVTYPROuaRTiYwYnbiikNWfAYSMU6pR3wzh1WsrL5M0pTkdPLqretbTzf3F03xtqJ2w5UHaXy4KQCMDeOibV+IHrkhBLgDxPysnkEMlRA0zDB6o=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a104f7f-ed0e-4494-5e77-08d80198295f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:13:51.5147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0hC22uUTkU/DnIzymAqUvTxJ5ogN6Zm8JGPdx5WqiubLNIngZf/f4GjP2Q+/TSYZxoWG3dx5/kpXam8u+4T8rmpl9NdRcliG0PipTNyNZbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0431
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

