Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514F11E6593
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404150AbgE1PNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:13:11 -0400
Received: from mail-eopbgr30115.outbound.protection.outlook.com ([40.107.3.115]:18196
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403787AbgE1PNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:13:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5y+eOWvtsgEeMUTgiV+YCdSFvQGMrTA2powDHh43lNnhNVR/O4gTdOyugJphJhXxPSoiL/aPdHoElVVAu6JzIjGERN15G8MwFH+sC1ly4dEE8cu6zHM3v5BLk8jmgv7f+A2eoE/LQ6KgnrcbGsijiCWXv6VO9vOq8QjFLfleZczOBip802dHTQEugBFTSXJHYZFzmXWYUy5dMF72BoDXUEQ77JE3zRScqezInxuZPTPZ+tGaeHeYVsa7vQmOBHnbggaFmYplntYVU8eidn+1QOm+xBOV2mzJ90+WoKAHYOHTlcOyQpACR5mxqx/pbZKDVsYwcko1xhaFf1yw9XFKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0M4u1NBSzX0/HGhp+IIurFvvl5UEQ8qWMnyD6aRDZTY=;
 b=gXuQqgDszVdFsPqiD+PQtg3XvZz0oU9TXs1yJNgtnGEJ1qJs60ReN94jVumVSfbstxqztNskDGSf0siMirvHt7BO4vC3Ox5k1Jc3XEacI8Rh1rSHT5/sCD7rSZ1zgEBJKdiXI6/5LZ8ovNeJBQipzDm/pGUlhv77WUDiAOkFcQINtuyH9v9uyWELYUz4rOUbk4LHa/T15LB1ZM/hyPHmPhgbVJLO7SaxAgQUwyhC8izU4oits8J4CFneHOre81b0oECkQZcYByiB4paYjDP4Z10yvbZIwECb/UjMjZXmto2cpYpOWLuwvqIKY7M2B5fA1pBW5F2dsQ8vrqOHcSl5Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0M4u1NBSzX0/HGhp+IIurFvvl5UEQ8qWMnyD6aRDZTY=;
 b=vhou2IllEDLNBlVmQeBTq7pUeLBjjNY8rlxbRaNx95myu7YHiwR42QNsWvzS800Yk4cLcjQHkMnyWkkmuMD3lzpPzMNd5Xb2+fNv/B+B60qi1lqdUVmdZv3cMR3NTgoBNhFem8k1RDArGHVHASiFA6HWOeQqtL6UzYdpjVqYc3k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0224.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 28 May
 2020 15:13:04 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 15:13:04 +0000
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
Subject: [net-next 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX326x (AC3x)
Date:   Thu, 28 May 2020 18:12:39 +0300
Message-Id: <20200528151245.7592-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0094.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::35) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P191CA0094.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Thu, 28 May 2020 15:13:02 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4d39b48-ec7d-4512-4045-08d803199e78
X-MS-TrafficTypeDiagnostic: VI1P190MB0224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0224268946586BFD64257218958E0@VI1P190MB0224.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +FTjp0BW1PJcjmM+w2g2q91KmbKx0wISblmla87evK6tSDWZ1zlSWPRQPKRTmbwc7aKrDHv7ZbgyGGgii3C6W3XjcBDFuWkWG0Sxv0seYqklghLhhkJttZWScPnLMCaNI/yYLyVBzQGHrswTpctt9FzDHSK5J6SFhuhlteggNogn6mC4VHORk4TUT2cJcfsK8V8Pn4//X5+bpWU5vLgnkx8sl0QKSwQD9CU25P71us5Z/qAIv31T8Jwq1xx/OGfE4Fn5Lmz0AD4ySt0IidyVjD35fD9kb2P4l+PFxxTpPWDD3HNmdFEj4iIbIw+gYvhyS0FPw2bllD2CKOkLrTlNh7E8g4KawVO+3QktnwvKt9PU9qiTO1BAYMcg93I9+p19
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(376002)(366004)(346002)(396003)(66476007)(316002)(66556008)(107886003)(5660300002)(6512007)(2616005)(508600001)(186003)(956004)(4326008)(1076003)(2906002)(16526019)(52116002)(26005)(6486002)(44832011)(54906003)(6506007)(66946007)(8936002)(8676002)(110136005)(86362001)(83380400001)(36756003)(6666004)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SjwDJgCY5xeCnmUPSkZ4y/wMVR2hV/GDI+OmBnEzJ1893tSj/jmjGsae1bAwSI7+RvUmnN3PckHBBSw+dPVq7ndtXTDUmuH9HDbA9MtV+DU3QYQHSp1yozztMUwKu5VCQEB4KaX8HpXNOQdG817E0/SB4XmVF01LhG/GQn7Pk/+M0aHvVh17e2VRzApBlJw3jSsR8KiyBPVtwJnRXzZ4m/t5/RvG7QEXwFyeB7s5++545HRxBHXcwAwkquHHNdwNn46ajddpLqHnR6j4Q78CfrjHKPvpMdHSrMsNEOw3orOCOBG0SzMmqpJYluJs2dl9JLe+wd0RQ6kTNso0B/I5SlB8B+wsvADqDdL6jmFjF4dsTVmgBm7pyrJ8ya8OG4YkHjZntAXena+oLALFLmVMCgzu0LQkJzd+rnA/Dg0P/jIFaRZx4hTILZ6AhZgam1NJfWTAGM7TqP1grSTTxidTXxbV9uSkB/dRhnXqklhnc9Q=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d39b48-ec7d-4512-4045-08d803199e78
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 15:13:04.3480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SLLgnlNyU8H/JAxKorBKVvR41uVaPOOQNtGGeutkGO09tti/unE4vh8UM54VO70ipcjVCO4quN7R94V6bqsi2yk//Vr6eP+ZbYIOEM9aNlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0224
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

PATCH:
    1) Fixed W=1 warnings

    2) Renamed PCI driver name to be more generic "Prestera DX" because
       there will be more devices supported.

    3) Changed firmware image dir path: marvell/ -> mrvl/prestera/
       to be aligned with location in linux-firmware.git (if such
       will be accepted).

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
 .../marvell/prestera/prestera_devlink.c       |  111 ++
 .../marvell/prestera/prestera_devlink.h       |   25 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |  134 ++
 .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
 .../marvell/prestera/prestera_ethtool.c       |  737 ++++++++++
 .../marvell/prestera/prestera_ethtool.h       |   37 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1225 ++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  180 +++
 .../ethernet/marvell/prestera/prestera_main.c |  663 +++++++++
 .../ethernet/marvell/prestera/prestera_pci.c  |  825 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  860 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
 .../marvell/prestera/prestera_switchdev.c     | 1286 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 20 files changed, 6433 insertions(+)
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

