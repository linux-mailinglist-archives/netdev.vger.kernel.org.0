Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4F016EB79
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbgBYQbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:31:17 -0500
Received: from mail-eopbgr20118.outbound.protection.outlook.com ([40.107.2.118]:38414
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730966AbgBYQbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 11:31:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3Di1F0xiX1Ab6Lv8AJV3qyjnEMdWrhDPtu9Xuu8nFrM6rgA/uB/cLX5utgyMKogAGvOz5QUx8ToSi2CmcAOPE99SIf3O9mN8J8Kj+QgTN8bDZRnP2z+dTTFzIt045WTuWSiXzWv4FgQKsveXZ0d74jkUTCYX4u0lHUD5qDNbf6c5DGfPX75G2L6JNmh7mUR8QHRBFG1vFLKJyXoqNPa9W2YFGlYmh51LASZob5eVoXjDLufG4zwCR1AtS+X1QbK7QpIyqF/vH3hMDQ0wVvv3tdWyaa8G9/hN0dnunIbPOs4ZJHV/UV1OKkEn1fs+MwwJCiHevoIOj+IRu1v6uj2Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xas0iQMFGz5y2US6vWpyga6exfkC4obs6q7F07xuJc=;
 b=H1c/XZ5AJLzlEZZIen9Jns11NyKVESINhAmAdXfxmMukeqFBw9X75vPeSvx0D0ncxGr9xLIAkminvtI6eMVIRZqsZuTKiic/7vQbCx4c/3NiuoQDqHuzR0WzpbGkrMQzNU+cuzpLgTTxc7EzNkP85UdKliODuX+d+hTqu0lnyU36z/LviNSUyGgQx8xh8G1BXKGyfkci6nyhfQHowMioPof4l7vJ4azHYx4qKjIzqmXoUTsKTDlIZiTKeeXZ3GloRjsCsSEBQHAx7yOcL+CQd9uNHHJ593aGMZ1sduB4akQQ9X41Ttnugd6AllEHCVZn98d2DhkwImPc+K6dwux9uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xas0iQMFGz5y2US6vWpyga6exfkC4obs6q7F07xuJc=;
 b=k1M6fd4H9jgEP0m1/dc6ugpwZxLrzv1l8R7SD2ItajrcltrHKMFdMac85N5N7kQBpxdd4n0J+BKAxEX6ijotAdcFZbwtm3E/LS75O6CypSCMPOGJ2BGlkw7m87k3eunS5K5ot3tzRUEBfo3OlbqbUV1UV54Gv2PiiMC6g5FQZuo=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0351.EURP190.PROD.OUTLOOK.COM (10.165.197.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Tue, 25 Feb 2020 16:30:56 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 16:30:56 +0000
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Tue, 25 Feb 2020 16:30:55 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: [RFC net-next 3/3] dt-bindings: marvell,prestera: Add address mapping
 for Prestera Switchdev PCIe driver
Thread-Topic: [RFC net-next 3/3] dt-bindings: marvell,prestera: Add address
 mapping for Prestera Switchdev PCIe driver
Thread-Index: AQHV6/j0r0vD2EV43EyyXZ3VANqMwQ==
Date:   Tue, 25 Feb 2020 16:30:56 +0000
Message-ID: <20200225163025.9430-4-vadym.kochan@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
In-Reply-To: <20200225163025.9430-1-vadym.kochan@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0030.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::43) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [217.20.186.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37215e17-fecc-4e80-b57c-08d7ba1016c8
x-ms-traffictypediagnostic: VI1P190MB0351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB03516890BEC4496D367D7BB795ED0@VI1P190MB0351.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(136003)(39830400003)(376002)(366004)(189003)(199004)(6512007)(5660300002)(316002)(110136005)(54906003)(4326008)(2906002)(66946007)(6506007)(66446008)(6486002)(66556008)(508600001)(64756008)(52116002)(66476007)(107886003)(8936002)(81166006)(86362001)(16526019)(186003)(26005)(81156014)(1076003)(36756003)(44832011)(2616005)(71200400001)(8676002)(956004)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0351;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MgDOcJwcn0z95EDOpJPmOjgWcutM/CxSoiQChiDvYWU8+NSnedT8ULxWQ0Gn5dKhgn4bWndwvPpeV7VcSOwiLJFqIM3M0nvOzUPsCpN6ytkGiBWp0ItbuIrw/UirwyIs4qUCKfcy/ambu0dletfi9N/zROaWe1Y5IZAngFUSV2WbTEMwwLuFDGYoZ43Tpc+2kpgsJvTQn0jNtfuKLZ19UjxDAvvd/b3s5kHoq3hZBc45OTdGlnJ1Is1fG7mqw1Au7uUxexZq79EGtlIl3pEnUdKMFvRCeW0pZhlv7xMCHHOcr6n3eqZmiUfLSCC0KxOnzX7DJoOZzP+3YUTcwkLSFrSA7z6f+QCRWY4GnRtIUfN4nPnczEG5j/075/VX3lJK9kJHSvkAb/1FUPe5J2l6qC99DBSJApyFiAefDkp6/WB7nVjU8zU+AKq51ofgbUbVdm2BLSw41+uX2FnwguxpumPMDykDTAbLTgmHG2+eyPR/k1y5p7OLMOSy+7ZZk3l8
x-ms-exchange-antispam-messagedata: j7yVmeLc05Lw21uFB7pApmT4E1f4Hhyjj0oXzxntGwcWrDvaUdRkxCDQTB8SWpIPhFA9tdVZSK4cTyJ22noQ/jWB8qKrmWIOZqDN7h6QpjnYeDsU/hRxvQYq+nr2tohk6iBiBd/wQfHyGCj9sGJYCA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 37215e17-fecc-4e80-b57c-08d7ba1016c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 16:30:56.3218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TS5r+hMF94VI715thm1oYiSQ2VuNohY/twXVSBjiHR/QVqfXbuEHAq1KoldX+dMDcjqGCo5NQAKpPCQGY8cl8tnAlcJdxnArmbSjBS2ZUMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document requirement for the PCI port which is connected to the ASIC, to
allow access to the firmware related registers.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../devicetree/bindings/net/marvell,prestera.txt    | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.txt b/D=
ocumentation/devicetree/bindings/net/marvell,prestera.txt
index 83370ebf5b89..103c35cfa8a7 100644
--- a/Documentation/devicetree/bindings/net/marvell,prestera.txt
+++ b/Documentation/devicetree/bindings/net/marvell,prestera.txt
@@ -45,3 +45,16 @@ dfx-server {
 	ranges =3D <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
 	reg =3D <MBUS_ID(0x08, 0x00) 0 0x100000>;
 };
+
+Marvell Prestera SwitchDev bindings
+-----------------------------------
+The current implementation of Prestera Switchdev PCI interface driver requ=
ires
+that BAR2 is assigned to 0xf6000000 as base address from the PCI IO range:
+
+&cp0_pcie0 {
+	ranges =3D <0x81000000 0x0 0xfb000000 0x0 0xfb000000 0x0 0xf0000
+		0x82000000 0x0 0xf6000000 0x0 0xf6000000 0x0 0x2000000
+		0x82000000 0x0 0xf9000000 0x0 0xf9000000 0x0 0x100000>;
+	phys =3D <&cp0_comphy0 0>;
+	status =3D "okay";
+};
--=20
2.17.1

