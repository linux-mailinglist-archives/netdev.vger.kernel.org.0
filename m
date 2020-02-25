Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE5716EB73
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbgBYQa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:30:59 -0500
Received: from mail-eopbgr20118.outbound.protection.outlook.com ([40.107.2.118]:38414
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730966AbgBYQa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 11:30:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkKkfxvzvlaIGhUqSiEYdDQbVqXAaQW651X+KLD4pbFC53Yj24G111+Dudbj/IYod3p2fxpsy5J07mMsls2LidnYaZKKrxGdCDiASIJC+nRJqbDT0XcIJnFlwswmRzG6J75Xn1h1PR+lcXOD2EYkcOpesx3bs5+gr+HXfK3hjh457Td6WYQwVBbccKh8TAn6HABu3WNxni3WthHla2+SEQpbCbfZSBnuL0nEUIVVTrVItKHw9IT/o6KK50m8YkyUCHBwuCrhv//fAuea+7kIN6RogX3c4iCrqWL3POl6SAu5sRdFMJkkN2LQC25y5fwrqbBiiMdCk9bH9FjCOhjkMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTTr3Kb9+HPFKyFpQNnRg38BUptkaLoxOxjFpzhRrrU=;
 b=VksEezN+O2jkHArKciGKYvGSsATXIBH7XyF+bDD9XgY+OQQ0CPNLU3PhxlqCn14+4UEumAq5fSbqn1AFtOYgE4yiclsXDpqLgeU77DkmC+KIcmEtdkBgLnZDp7qttNmFtdtT+DviQuD7s+OZTwRuKk+SlJOMpr5ydQGDpGgWBz2hnrtf89Ew4Y1wd5j+7cMzJPSzGXwzL6km+gD7ijdaLghKVeNsXnOWLXRSmofmvIAQ6KV9bzCkfZyzPhTxd6qKFDU8Nz2vNyZsF2ozII4dKnAnIc76+fGCKyMLKP6KWJFj2HL+i9TEucXieTIQ+z/rm3nSyctOzACNsFeYOkyhWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTTr3Kb9+HPFKyFpQNnRg38BUptkaLoxOxjFpzhRrrU=;
 b=l8qgck3DoS6H+KGu8W30qbTp5tjZ+lzQ9d5mQaCBUCtgUT2Gwe18YBFGE2BUHspNCvMcJyY9gtHDKaQMl3/BJYF/ABOMDDG7nQwd2T06TRmlotL/jTfRfD+mCU7QhbfhUyZ0k7Swgnl25CAP0BLBnMKYjPawB6mmsYZCu/7y1u8=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0351.EURP190.PROD.OUTLOOK.COM (10.165.197.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Tue, 25 Feb 2020 16:30:53 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 16:30:53 +0000
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Tue, 25 Feb 2020 16:30:52 +0000
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
Subject: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver for
 Prestera family ASIC device 98DX326x (AC3x)
Thread-Topic: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Thread-Index: AQHV6/jy7mjUjxYwxkS7hliqOPvXRQ==
Date:   Tue, 25 Feb 2020 16:30:52 +0000
Message-ID: <20200225163025.9430-1-vadym.kochan@plvision.eu>
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
x-ms-office365-filtering-correlation-id: 4d1a56dc-5725-445f-0b26-08d7ba1014c4
x-ms-traffictypediagnostic: VI1P190MB0351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB03513DF5D7DE4F098184571495ED0@VI1P190MB0351.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(136003)(39830400003)(376002)(366004)(189003)(199004)(6512007)(5660300002)(316002)(110136005)(54906003)(4326008)(2906002)(66946007)(6506007)(66446008)(6486002)(66556008)(508600001)(64756008)(52116002)(66476007)(107886003)(8936002)(81166006)(86362001)(16526019)(186003)(26005)(81156014)(1076003)(36756003)(44832011)(2616005)(71200400001)(8676002)(956004);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0351;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1R18D48drhrot5H6XXTrxXkYoOXgjnhJMCKl6OgGvb5P0uMkwQmD/sGb0aIQfNDu6ATh1fhhOevCiFLAxk0aoxV0pVcsgFaYaHJnbOFaJjtf5d2ZfMIflSJPQExV+WYb9b6ts+LuD1QbJ59i2ZfWhJBFu467GsaoBMuPoRtLC7FMvBVp1r1NT7LMYJ/AmtSff4aOvLt7NG/5E1wNK+vg1Fprp/EaLc/VrsklYEyAxsndmNQyq+3mlusK9CDTRPMQ4P6JKff77Uaj0hXAX1RDGHzBIz0esKJ4WpEjZk09wEKi0VHM2cak1DqPxzuJVhybn8Dq5NC+xa45BcA3rAcjvXpMHsuhqbop+FZrY0Vk5+Zbbib2/YU+28EpT1eO5RE5AkGCW1DAvn7gdLceyamwDTpjkU8MAabFguv5q1mq4s9s7ft4FSOPnQXeNQZ2ao7G
x-ms-exchange-antispam-messagedata: YdBzIo4PVWgCttPTcVhCvsRFfM3TEtWR0i6+cF+1dIeJhbTRoSF12X2gjEV9OVQCgNBBiIWaZD/JoS1C/4WAfB9QZXdybaWTruPvtYpGwx4l5GeCuR9TSM4anyORGWo8FXw89WkR647pbM7TrQqdLQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1a56dc-5725-445f-0b26-08d7ba1014c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 16:30:52.9528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1wtcg7BWZzEkFO7l2fh6diq/LYgKB9Sr7rUGsp0X4R3O1nuvQLRyJ4mi053qyzhmAOkf6QlkKxFxcDUJSfy1n27F5zAhj19eR1nkSJZQGaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
wireless SMB deployment.

Prestera Switchdev is a firmware based driver which operates via PCI
bus. The driver is split into 2 modules:

    - prestera_sw.ko - main generic Switchdev Prestera ASIC related logic.

    - prestera_pci.ko - bus specific code which also implements firmware
                        loading and low-level messaging protocol between
                        firmware and the switchdev driver.

This driver implementation includes only L1 & basic L2 support.

The core Prestera switching logic is implemented in prestera.c, there is
an intermediate hw layer between core logic and firmware. It is
implemented in prestera_hw.c, the purpose of it is to encapsulate hw
related logic, in future there is a plan to support more devices with
different HW related configurations.

The firmware has to be loaded each time device is reset. The driver is
loading it from:

    /lib/firmware/marvell/prestera_fw_img.bin

The firmware image version is located within internal header and consists
of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has hard-coded
minimum supported firmware version which it can work with:

    MAJOR - reflects the support on ABI level between driver and loaded
            firmware, this number should be the same for driver and
            loaded firmware.

    MINOR - this is the minimal supported version between driver and the
            firmware.

    PATCH - indicates only fixes, firmware ABI is not changed.

The firmware image will be submitted to the linux-firmware after the
driver is accepted.

The following Switchdev features are supported:

    - VLAN-aware bridge offloading
    - VLAN-unaware bridge offloading
    - FDB offloading (learning, ageing)
    - Switchport configuration

CPU RX/TX support will be provided in the next contribution.

Vadym Kochan (3):
  net: marvell: prestera: Add Switchdev driver for Prestera family ASIC
    device 98DX325x (AC3x)
  net: marvell: prestera: Add PCI interface support
  dt-bindings: marvell,prestera: Add address mapping for Prestera
    Switchdev PCIe driver

 .../bindings/net/marvell,prestera.txt         |   13 +
 drivers/net/ethernet/marvell/Kconfig          |    1 +
 drivers/net/ethernet/marvell/Makefile         |    1 +
 drivers/net/ethernet/marvell/prestera/Kconfig |   24 +
 .../net/ethernet/marvell/prestera/Makefile    |    5 +
 .../net/ethernet/marvell/prestera/prestera.c  | 1502 +++++++++++++++++
 .../net/ethernet/marvell/prestera/prestera.h  |  244 +++
 .../marvell/prestera/prestera_drv_ver.h       |   23 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1094 ++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  159 ++
 .../ethernet/marvell/prestera/prestera_pci.c  |  840 +++++++++
 .../marvell/prestera/prestera_switchdev.c     | 1217 +++++++++++++
 12 files changed, 5123 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_drv_ver.=
h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchde=
v.c

--=20
2.17.1

