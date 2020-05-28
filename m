Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4D11E657F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404092AbgE1PHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:07:13 -0400
Received: from mail-eopbgr140135.outbound.protection.outlook.com ([40.107.14.135]:57672
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403787AbgE1PHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:07:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laJpm+qY0UdRmWpjhX5x4dxrPDLVx3lO2DEh7TXYRoDJxH+DrynFZiJk/IaSYtpg2VscpsAUxiOrcVtxElq2AC1LpGYHSNE24PleNfr81n0ZPl7PzYRRFDdjBbTiLvPEgOJfB8ZrDI1qwwmPPkwHdj7qorFB3W0CWdN81DmEczAsqVzSFs0CRsugTNxdDnfQD3QYNZkSr8BJhnMM+8N8gN76fdlk1igl/Kbk6cRznEloQ/2LyDnm7HFKnYDJTyePvmC4Jd595rDwl5BLO6QWIiF7mw4XamkiUEZNBlTZdioWeId/JaI+1D2PF50YoNWP1r3ZUhA6rmHcxOuP/atTuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0M4u1NBSzX0/HGhp+IIurFvvl5UEQ8qWMnyD6aRDZTY=;
 b=RIRJ0Oz/RZ3AJcUdGYUDvHcI+pzzwA6Bu5/Ah+cpXHJOwxVkFX5J/RdM+ussNb92ItMaK3j4yxwbmncR0zRYKJdHCnGpXzSs+PFY5GJg4K3K1fhkb8qg8MPJPN5WqqsOpT4BIRPk4CWRCqpErmOUAYkVxHy/T4IejEnP1qvo1/s/MC4xSwnOaYsL2ED7D2RFg0BsLQWuXVvzLXZW7ayKp2SPwHXL3P4bOMpNUDK6A8N0CWmKzCa4dS5nWDFIt1ompc5D12PE2SqZA+HRFlZpFernIo82yhB+XlxlkRjHsT0hjFt5Gl7mO64qDvVYt7yYK1ApSBpjCU2XqsdgMNaWBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0M4u1NBSzX0/HGhp+IIurFvvl5UEQ8qWMnyD6aRDZTY=;
 b=GeDAZSXr0twrAJ3KR0bqAHkQKmswy8O4Y9ImeSBUrGbokvKs2CAKhYjQTgnGlZQGnKFIBKxML/qygxHPYz+4lXzV46YoIil4gdBPTwkJWeq1oFvpXG+tRV+A5yAcuvC/Tx90YVVfLyOxj80js1qQwxQRJ6TKaswfrz8asH76akY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0590.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 28 May
 2020 15:07:09 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 15:07:09 +0000
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
Date:   Thu, 28 May 2020 18:06:27 +0300
Message-Id: <20200528150627.4869-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0027.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::40) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P194CA0027.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 15:07:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c316903-a79a-47c9-3e69-08d80318caaa
X-MS-TrafficTypeDiagnostic: VI1P190MB0590:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0590CE1377F310582BB1B249958E0@VI1P190MB0590.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AY0Rtm66CF7Ks3SlIr7IY9XScGkCjDofFoczv06+DNYmKkX4A80MScNy/5yI+p/Nrck+oqaVWMjPe2OmJAPbv1+ZLH2/wPATuQdm2ms7nN9FIkei90O8KUNjmb3xg9jcfh5Ykj3iDExm9ZLE2mSFsNSQ0E5lYfU2875LaXghZ9yglMZjoL90+FFtH2RPgOjPkMKkki/UuPOPfnwcGc3zDwpOILeOEIvnIWhS+9wYZPgeEWC/RqEkbgCehtd12fPfC2P3KYaJUdQJy/34fG+U8i0KmQc1l96Sv0Etpplgn7/b9WaTHVvnnQUBbPgfbPKLatLCJNZ4nurYhMu+0hrLIaGsgnNjN/4QwmOAsfpw74jMpCwaAVI0+TCdU58dQjeq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(39830400003)(376002)(136003)(366004)(186003)(26005)(508600001)(4326008)(107886003)(36756003)(6486002)(8936002)(52116002)(2906002)(6512007)(83380400001)(6506007)(54906003)(110136005)(316002)(86362001)(8676002)(16526019)(66556008)(44832011)(2616005)(956004)(66946007)(66476007)(1076003)(5660300002)(6666004)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: k7orpAri3GjaZeHSgeVCE/umy+IG6ZsHwSuPVNAS6QroR8EokkrbSDHw6Dl3ysB0FjlmnE09I9cHMNwd4k5SiAmcL5pxyvWj+3AryKaeP06evhqee610xw9QxEWXX67Vn/nz+RWBY7fnqNo634srOernqdmM8nmCNG7W8Mcp8mrGJVzNdwOvEAOOtACOsq36GuSy2Fq0gGg8D74y4jINC7O5loE3nLwEadSf9zBzjTl62lFhiLRab5soauUQugwlDOKlOWhKJlnr9/ikaqKLrpA+FXlqEX2ZRGE6aaMcNRfCyqz9eDx9D5pshisYDG00qCkcYKbjAekGP2n04sDorTN3WYoahknEDHqIjcM2Xmv7EhuOP5pFKrZtvjpx45kgqESYRJPemF97ub3aqa+nSAnPdfp04PR60YcE46rWYuRwOzWPW7U+CrEeSnUTbVo0vTjxrBoqFzgnvz/BjJGNRp9yay8BL0PHHGFzT7Uybik=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c316903-a79a-47c9-3e69-08d80318caaa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 15:07:09.0016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zthOp3+QqaIr1W5fmIqn9WDm8OhlAeIRJL/+9KGpVI2rSZ3/aZ9ULX1bCqX8AMboRnuhq6RzMRwt2Q8xBlAAoBQb6mcL32Kiy/t5aeKTvjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0590
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

