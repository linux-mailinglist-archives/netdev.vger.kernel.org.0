Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576861E2816
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgEZRNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:13:47 -0400
Received: from mail-eopbgr80134.outbound.protection.outlook.com ([40.107.8.134]:17829
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728138AbgEZRNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:13:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIVsnuUcEIjk4EojWx5jh3cQZiCo2KH5MENQqgkIYpjOibTf81qtXbUDiA26b330QjqlkTTKLfHfUj6qOjWAo7t63pKYskng6IJz/nO2MKJ8mXwBJB3Za4dtZvDHu40H3rT9Ykmun0N3D7BRuJuxOJ6e/JkjXU88OmZ8MYxbAT+NT+s9Pn8s8fNyA87fd+Ei/OWGvVhajjzmJEQ4eUC9Ifnm7fciv/8Xaw1safma9/KeiXjMYVAgsZHWAbQ31OmXjbmktIEV7kvRsI3/3Rjg/L9Y0HBNUerCfV7YnksYWX5hoarzVAgwect4rlpMHGrqTrtumnNvsW9fHBiDmr6Ihw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfWU+Ke6Ck1f3S9Ufc1JtRhl2CIPThndU7lSsLE9I1M=;
 b=UqjRE5OB0ikEHREJ4BCEtibS7/ne54Gi/h2qA4UudjCbeldAr0XhWw7PQOuCO5ktKJAsw4eIWM4g+uzsuEgD0jjYdFWJGNwU8oXp6Ja4LEhwf2fA23IHudsLztkTSZfc02amng3pGHG/AJtsGwobc8pYQXLVoHCtIY94nTO3/Ik/xIbvqTEpp5BtLLMwtx7zh6mpH/kmgB57YnN0mAiaNgHdp1jvugcspsflN6TYvaWzkzKvaHRHgonpb03d1ZHsFL6hePpeiGiFBUuRfnxHSh0CJd0WqH9Kgr3nIMHpljYBcbDKgmWmwadH+C0qp62VX/cwJLh40QDFC0wzLTmIdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfWU+Ke6Ck1f3S9Ufc1JtRhl2CIPThndU7lSsLE9I1M=;
 b=ZGhDoL8N9bUMTHaViFpvHH3HhaMB+hPDysIy8tiGUzReyY4NqWFw4CmfUfgbLogHBJh1+AsjwQrInydFp2TCtlTzc2kbK3ltnQoX6y4MgNJZ+lWhGz+nsOOD1Wb6Ga5mVyfb9LzxAQETRGZGMzDeR905lYBmJxaIl30oszxjAws=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0431.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 17:13:40 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:13:40 +0000
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
Subject: [net-next RFC v3 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX326x (AC3x)
Date:   Tue, 26 May 2020 20:12:56 +0300
Message-Id: <20200526171302.28649-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0061.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::38) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P192CA0061.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:13:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac0458e8-edae-4be7-fcbb-08d80198225d
X-MS-TrafficTypeDiagnostic: VI1P190MB0431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0431901D062727FF2174FFE895B00@VI1P190MB0431.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcs7zIsM37HKaQqEMrTh0fIWBeNIIUTBONMJdjzUv+nHaO9qFDF9y9g7tCaAbRD4g0WPSW8Bka5MPZslSdbbHWvl0zjf7mKtorgEgDKSmzjKd3xX+e+D93OljzMFgq9Q85UtyWpdvAsVom80EhWlL6CgIg0MXTitw3cnLsTbP9NCv+HzwrMF7ugZwl1oOeaggeEUDceVNZe7E9YuO7kIXBML0Lgexh8St8AOKk9N25M3hPg2cXkGfQDu3B4kC3Pcz2Enlgqqv0fwoHyKIk6hjRKq42Yqb98StZ3cyHhdDWshPjbL5u+kJty1gaiUSrR46LnY1YeyIvK/lUfUhLpC+DLpOIm8AK3tKaGDUWuHpXD3F/tTd7bXcvT/AjrJPxrT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(376002)(136003)(346002)(39830400003)(508600001)(16526019)(52116002)(2906002)(4326008)(36756003)(6506007)(186003)(86362001)(26005)(6486002)(8676002)(8936002)(316002)(956004)(54906003)(66476007)(2616005)(6666004)(66946007)(5660300002)(110136005)(107886003)(66556008)(44832011)(1076003)(6512007)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6LmqMB1JiieJwq8wo0yf4JJ055hwZ5NTwNUVW9+yuGW5Ne3AjPXr5vBrgjpG3f457VAG0+uOr8CaDFDmk2Nqs9r9AJP506lhw6Ec21TZWKFZcaTIF03TTyW/2X7ej057vA46LWC3tSK1vTre7nBQPzRobC9qRcNL2H8FPi/XpOalDxEpTThrETnV4XlLO7xXUNGDQpv+8LqEEU2CaJdidqvjsOz8WgX8+8d2LgE0Xzw5yWm0mxyUFI9+M1yfMfjU6wTjz/SBPqGNxbN5tR2O96G1jbvA98gO/6gvxE0Nz1QUbVIvUEYwGlot0aLyjySamAPZrp+Dn/jQ8IUR6km0Tsi2vE4UZu/u6hvS0LaeUQmDET/HnNz41D9wu+FAx2oTa46kcGbdAsJ0Qbgo/S8kOobD+3gt3+fROvi62Lb5cRI8gYRT16AJP8qTBt9NU705PQB4S3rwb73Ao3I4Eyf4kPUmwzUe7JV8Mf0/AiZ1NPdXMWkX2R1Rj7vDEwZe2paJ
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0458e8-edae-4be7-fcbb-08d80198225d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:13:39.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ArzVJdxVVbEh112qWXscv3hkQJJnBTNoT1BDUq65KiRV9RRKDLXZuAI0gM6Mq98+zXxJGqAzWthKPFczJLORynPCqSOdMhuv7Rugk3nrdFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0431
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
wireless SMB deployment.

Prestera Switchdev is a firmware based driver that operates via PCI bus.  The
current implementation supports only boards designed for the Marvell Switchdev
solution and requires special firmware.

This driver implementation includes only L1, basic L2 support, and RX/TX.

The core Prestera switching logic is implemented in prestera_main.c, there is
an intermediate hw layer between core logic and firmware. It is
implemented in prestera_hw.c, the purpose of it is to encapsulate hw
related logic, in future there is a plan to support more devices with
different HW related configurations.

The following Switchdev features are supported:

    - VLAN-aware bridge offloading
    - VLAN-unaware bridge offloading
    - FDB offloading (learning, ageing)
    - Switchport configuration

The firmware image will be uploaded soon to the linux-firmware repository.

RFC v3:
    1) Fix prestera prefix in prestera_rxtx.c

    2) Protect concurrent access from multiple ports on multiple CPU system
       on tx path by spinlock in prestera_rxtx.c

    3) Try to get base mac address from device-tree, otherwise use a random generated one.

    4) Move ethtool interface support into separate prestera_ethtool.c file.

    5) Add basic devlink support and get rid of physical port naming ops.

    6) Add STP support in Switchdev driver.

    7) Removed MODULE_AUTHOR

    8) Renamed prestera.c -> prestera_main.c, and kernel module to
       prestera.ko

RFC v2:
    1) Use "pestera_" prefix in struct's and functions instead of mvsw_pr_

    2) Original series split into additional patches for Switchdev ethtool support.

    3) Use major and minor firmware version numbers in the firmware image filename.

    4) Removed not needed prints.

    5) Use iopoll API for waiting on register's value in prestera_pci.c

    6) Use standart approach for describing PCI ID matching section instead of using
       custom wrappers in prestera_pci.c

    7) Add RX/TX support in prestera_rxtx.c.

    8) Rewritten prestera_switchdev.c with following changes:
       - handle netdev events from prestera.c

       - use struct prestera_bridge for bridge objects, and get rid of
         struct prestera_bridge_device which may confuse.

       - use refcount_t

    9) Get rid of macro usage for sending fw requests in prestera_hw.c

    10) Add base_mac setting as module parameter. base_mac is required for
        generation default port's mac.

Vadym Kochan (6):
  net: marvell: prestera: Add driver for Prestera family ASIC devices
  net: marvell: prestera: Add PCI interface support
  net: marvell: prestera: Add basic devlink support
  net: marvell: prestera: Add ethtool interface support
  net: marvell: prestera: Add Switchdev driver implementation
  dt-bindings: marvell,prestera: Add description for device-tree
    bindings

 .../bindings/net/marvell,prestera.txt         |   34 +
 drivers/net/ethernet/marvell/Kconfig          |    1 +
 drivers/net/ethernet/marvell/Makefile         |    1 +
 drivers/net/ethernet/marvell/prestera/Kconfig |   25 +
 .../net/ethernet/marvell/prestera/Makefile    |    7 +
 .../net/ethernet/marvell/prestera/prestera.h  |  208 +++
 .../marvell/prestera/prestera_devlink.c       |  110 ++
 .../marvell/prestera/prestera_devlink.h       |   25 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |  134 ++
 .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
 .../marvell/prestera/prestera_ethtool.c       |  736 ++++++++++
 .../marvell/prestera/prestera_ethtool.h       |   37 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1225 ++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  180 +++
 .../ethernet/marvell/prestera/prestera_main.c |  663 +++++++++
 .../ethernet/marvell/prestera/prestera_pci.c  |  824 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  860 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
 .../marvell/prestera/prestera_switchdev.c     | 1284 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 20 files changed, 6428 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h

-- 
2.17.1

