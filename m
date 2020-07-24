Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45CB22C7CB
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgGXOUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:20:23 -0400
Received: from mail-eopbgr60094.outbound.protection.outlook.com ([40.107.6.94]:41134
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726576AbgGXOUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 10:20:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOTOUoTuCNItDrS+eZDtE0ud21qXLgb/lZbqHTDx8nyEaf62lUs4ed+k4brHMQ64DKcpPLw6oDXcphBO/QA3ayMLlfIr5pAcszzFH6bu2DATDCg3j1Nepte3RGGDAf4ziZHkL0cym8/3X31WTk9nCZqV1uUSbjmuL3aYI7cyDOG7OTVyW7NWHtAVO7VN+6E8syew14qkrd2SEDEEQdlkRKdOg7Hp+VDhQ1ctgFsGEGPV142o9RMzxVBUjL0VugW8JgMDiv9kp5VI8/SYRqZWSwWc3xwlZ+DMYaHVQh0p0qg7BUWvRbQ5fNMb0D3TA2exzb+HMISi67sEDgw+jsciRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcrskVZp20FA5BnxoA9k4ub4CTqVgMdflo4rQQib6NM=;
 b=XQYXdXjT6waM1pj5cabply4mRfbbKNSpIS9TMKaPIyprUdklSSXX2pofDYmZYMg7hNkCeKysmu/DCo6RxngcISZSIHkwDMFJJc+ZMHm5o0W8coyCwuAjmCmZ5VP0HOy8Q6kFNk67h7dT/KdBQ07zJZRkdzc5U796HnpD5Q+yH3anyhf5mfUEqYDqHtYj0SPW0Cj1HAiUy/sfYw5tULN8drvEDgpJtVyEE5UT2wnsjSABoqeFNCMeepTJjUgllnpALNBnyUAufDohx/WOmKqO81I8NxbaUJzgdnbHmt8hS/2ywTIhHjZmu856Ds/J2uw3btbgT2PgRdr33AbJClbCzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcrskVZp20FA5BnxoA9k4ub4CTqVgMdflo4rQQib6NM=;
 b=FZSlvFFonbwN9YuDsyXAoJg8B3U/TT1BFUpUibTA7u4msveDoPJlJz0NA9JhW/VvsF4DaZGkPex6pFBby+H83J4hBMGA9M6fb1MnlHI4zo9MZfOAcSDfqG6ZImiQ8e7iKoTbqjzc7B40IqbUljIoDT09yEx4Sg/NxDQVB3rB7bU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0117.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:87::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.23; Fri, 24 Jul 2020 14:20:18 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3195.028; Fri, 24 Jul 2020
 14:20:18 +0000
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
Subject: [net-next v2 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX326x (AC3x)
Date:   Fri, 24 Jul 2020 17:19:51 +0300
Message-Id: <20200724141957.29698-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR01CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::44) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR01CA0067.eurprd01.prod.exchangelabs.com (2603:10a6:20b:e0::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Fri, 24 Jul 2020 14:20:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6cdd4ec-ed2f-43b2-bde0-08d82fdcb0f3
X-MS-TrafficTypeDiagnostic: DB6P190MB0117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0117FEC6EBE6FA7086127EF595770@DB6P190MB0117.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pBceiTzS+BJUl43rRUla3CKPneyBYx1WjMbGmK7Hjvdbhd6oR0hdMQu260vnQkZMEy3rJMC46UdawewOuWQcFZBNphBeUfQtAm++nG7vGjk/r+3JJFpvNYshmA7du8FmSgVfEcDB1nppTiPSgfqkMs67kWJ9jrTwGsJI8GkSauEnuKdRhXk5rQHcom7iAavMAkTW8suKb9DfjfbJ5vGGMWC0zS81cKnKwueMzbGAz1GeDpwWQ38oN6/HdnpdL3h/hwOst0mww9CYPxf+nMqPs24HIx9BxHxnyW09J3+WS8ZYO3a2etPiq7yvRcR8HjL1ShLC0l6C/ox1umcPxM0QPU0+9iok/f5YAY0QRYf3KFNE/x9C7XFKJDFEykYjLwB2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(39830400003)(396003)(376002)(366004)(346002)(136003)(8936002)(6486002)(316002)(110136005)(83380400001)(2616005)(54906003)(1076003)(5660300002)(66946007)(66556008)(66476007)(6666004)(508600001)(36756003)(8676002)(6506007)(86362001)(4326008)(2906002)(44832011)(26005)(956004)(186003)(52116002)(16526019)(6512007)(107886003)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: X7AtcjvW5aWBF2bV3akqv8A6cBI/aOJsWkVQ30Uyqj9APZqZuuLWFnJl/c+tCdmQbhyDJpsEThoTFLHawo+z2IxnZl5zGdanWMNaRUHZn3gnuM51FaPaAYhgJlISnUkfqhKP9M1EG/qPDNRMYz2Bx5R35eQVRSMd/W3yAfa5TyZojdwS+dYRZuhdNmubK0Yyx96N/1FYlF8l/25LiF08mD8diwTkT78htJeLYRB5NDOYyu2lc4kC8KL97+2JrTEsjpAKaiulmD6JflpcVJGrL/CGC6r+pVRlSqkwHmqzK1H+GsuwOgP7RQQpLgUYxEi+uABPnJPmQYxT08EOFFZziMS8nKOOr/EoZEmUD3KuoqWPAAa3uCekcUlyV0xY584B7G9EoNcSmF0UooRTR9j0F35Z2X5v9xjslkRSB1nnoWzC8cqiTib48GcyDRNreL58j7L/z7zPylNIFJBurXB0x6O2dFDzsgxotMsFtcmqh2g=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e6cdd4ec-ed2f-43b2-bde0-08d82fdcb0f3
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 14:20:18.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1WxdO+rF/jxlXmW/P4yq6VRye+67mdPzNlyzfY+/cwHEn+yxOq3joTxFeWiz69nIac6qmqIMXR5ThImd4GEvEiMBOZxP/z80XqgSUQYG+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0117
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

The original firmware image is uploaded to the linux-firmware repository.

PATCHv2:
    1) Use devlink_port_type_clear()

    2) Add _MS prefix to timeout defines.

    3) Remove not-needed packed attribute from the firmware ipc structs,
       also the firmware image needs to be uploaded too (will do it soon).

    4) Introduce prestera_hw_switch_fini(), to be mirrored with init and
       do simple validation if the event handlers are unregistered.

    5) Use kfree_rcu() for event handler unregistering.

    6) Get rid of rcu-list usage when dealing with ports, not needed for
       now.

    7) Little spelling corrections in the error/info messages.

    8) Make pci probe & remove logic mirrored.

    9) Get rid of ETH_FCS_LEN in headroom setting, not needed.

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
 .../marvell/prestera/prestera_devlink.c       |  120 ++
 .../marvell/prestera/prestera_devlink.h       |   26 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |  134 ++
 .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
 .../marvell/prestera/prestera_ethtool.c       |  737 ++++++++++
 .../marvell/prestera/prestera_ethtool.h       |   37 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1231 ++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  181 +++
 .../ethernet/marvell/prestera/prestera_main.c |  653 +++++++++
 .../ethernet/marvell/prestera/prestera_pci.c  |  823 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  860 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
 .../marvell/prestera/prestera_switchdev.c     | 1286 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 20 files changed, 6438 insertions(+)
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

