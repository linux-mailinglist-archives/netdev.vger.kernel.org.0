Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC6125E055
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgIDQyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:54:39 -0400
Received: from mail-eopbgr30131.outbound.protection.outlook.com ([40.107.3.131]:14643
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727103AbgIDQwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 12:52:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDlvKCGa3cmRYydUdSs1CwZ+2fCoLxSNQt2Z5zKHE3SRUQv8yhzU63HjhDaPwTZEucwz/G2y4Ywtc/rGWSY3U2V/9WEnrWyGI6HibyvA1DwBDUGMC1VP6hBn8Djf+xH4i35Cyt5FWfy9P1SimC0ktavXOLdeU2VL3+0E2IxB22JaIjFZGZf0j779CxCtfO7ko6NzYRSPA453JaXRn6zrlVloSeYKWF1x1HN5C2+SJ769khHdeFFoAR/GzoOgSDHYRC0j4dtLtVvxJoeCuiVRV3EkUFQDaHzKOwMdQRZpu1DNPjwJx2T4x4rB02LxyADhiOiclPdHfXWR1zpIRcQ6Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xEuZBWCg+k77C7WDEm0rSwHaiVTKTekW2jO3XiGmOA=;
 b=eiG7pf/ldTboCYYa/7pJdEdAYUhVxpv7dlt4RPJdcELkda9xi3xdGwVgT1f9qGOIFvRNiGbfywmbLAL8wQtjiCyYdptDNbXQYU334UU9eQxQcYB6tTYJNKEggwFiK+7BIhdY8ba+VDZ06KwerCtUI6ZNqJ/vsMXAwMGE0mVnwtUh06gLlWT5X9krOe+HXX+BbDEpbbJcDZfLFNwAkA3pAGXH8xXOZEJQqRIum07ywKkE09Aj0dcFBdx3aE14ej/qlRop7pzUw0oSvLtaqe6lnGLy/Cw1W4wkRCZ+OFXQ9U9Vd/DYX5nSKPg3P253Oi/7ZuiirhzP2ahjkYa67kY7ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xEuZBWCg+k77C7WDEm0rSwHaiVTKTekW2jO3XiGmOA=;
 b=afXsnlTB5Lw0nFGs+XsxG7UzRwWj034CV1lckvnz4KMHpc+lbZXQtrzm8C3BAIqL5zTkwR7D5e12CJcPyOUgihu0DL3SreRyDFfAqL0PN9V01xNpOmMRmvh32EVSw+34UXMVRW6Gk3XhRqiPhJW8XPN60NIM36WxD1R8Q5iU20A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) by
 DB8P190MB0730.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:12f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Fri, 4 Sep 2020 16:52:49 +0000
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765]) by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765%4]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 16:52:49 +0000
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
Subject: [PATCH net-next v7 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX3255 (AC3x)
Date:   Fri,  4 Sep 2020 19:52:16 +0300
Message-Id: <20200904165222.18444-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0062.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::39) To DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:3e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR04CA0062.eurprd04.prod.outlook.com (2603:10a6:20b:f0::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Fri, 4 Sep 2020 16:52:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc581236-c1cb-4d42-3fc1-08d850f2f4cf
X-MS-TrafficTypeDiagnostic: DB8P190MB0730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8P190MB0730F89C228AC33474F3072D952D0@DB8P190MB0730.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /9SZnoGTo+1ZLCz8mn6pS50iH6XDmwamCQjsVUtjt98L0hwix1npADe9Afg7SxOEsWRJ+T7ZOLVd7UmXQzmuVWFor1UVsxCVuegMGDVn1OqhQ2BkQKOQA2OHSYZyLRpuFpm4A1dtoSuB4/PKtyajMP9lYn3rsksbOcFY+J/QzLhPMCXb5+u5BYmeXt+G0O3UxMoCuJXuQTGceYkyTtm6b5khKXup55CLzUtZJA97XQSoA275/Qy+rjJjFY3Hoen1Igt9qAtIw2qk8SXzOeKekPajmzeA3v1UIj/661jNTyLVVuwq58Ea3y7Rh/kAXC0ZSzBMubkMSJYTqZwrZ/7vbiyCzaxfKxoiYAhbnSl1PQy9fKH0Frz59yVd0NEdVJ2vUgC43l6aZAr1Qf5Fb0XvzxUn+L8Oi9Ujx8GkcpuEKRE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0535.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(39830400003)(346002)(36756003)(44832011)(4326008)(2616005)(54906003)(956004)(5660300002)(8676002)(6512007)(66946007)(66476007)(2906002)(83380400001)(110136005)(66556008)(6666004)(478600001)(86362001)(6486002)(30864003)(107886003)(1076003)(8936002)(16526019)(6506007)(186003)(26005)(52116002)(316002)(333604002)(921003)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LCJj2sR9rQJ+dQZRSda5ByQOsi3BGIr4Sg8Qa9V0HCjD8ZIG3XNQyuS8PPmjTs3yM/yIvS4O7nsDRVsuDHhZgoblbYUIXNTds6uucqGNeaLJrzl/eosjTu9/2t7RdLWyiBEQYlLESKM3R0HuSGhx1qY+dID3fdSpIkqUEM/I17FzX2lAQwAf+ypjOyzzmUVtLM2qxIQS57cSLgpdZvR6b7M9uM5aiAdVWUEPcOHkFbId42DFFV5L4fi9NJN0FemjHDWaXeBu7p9ojhdlC6dFYNZWWKr7e0Xk979b5p0395hU6nohD5QQzyPi/T/iW7vcm/yJbaCVag39BxigizMGA5zQ3IW3TI1kJa9PDfTJFNu+2DTeIaHKvbhHNwxuXdlXSSGJxXOZVTLGAqMuIhKeUgnf8hnwgPTN4yk/4x5nrq/C3QXly/7zGCd1+yA5Xm5W5DrAysxKL/Kf0AK8AzslYQ+61BsLBCzVJa9kCD8mWqWFW5MQXVthqmka0+Ei/BU3pMr/1NWVxQQ9+hC4eUpYl7P94IRW6nyIkOiOKyrFXq2U48Znkrc5I8fYemC2tu75W72LP6vsiDJJx+weeI+SWA/vKqZ5zsSqV0SN/7NskCVkOo+0u/cZdMdmvre6SVzBbPQYYBUHyS4UuREpmW/sHQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: dc581236-c1cb-4d42-3fc1-08d850f2f4cf
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 16:52:49.6823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+NMoactnBCtM1c6am8iu0F43ZdimN+g1788eItaOgO2ZBxsLGeAV2811lcJ07s8Ld6qlHoZ98YOSMGP3YitfO2suJEcRRaT+NUfBHgIspI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P190MB0730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell Prestera 98DX3255 integrates up to 24 ports of 1GbE with 8
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

PATCH v7:
    1) Use ether_addr_copy() in prestera_main.c:prestera_port_set_mac_address()
       instead of memcpy().

    2) Removed not needed device's DMA address range check on
       dma_pool_alloc() in prestera_rxtx.c:prestera_sdma_buf_init(),
       this should be handled by dma_xxx() API considerig device's DMA mask.

    3) Removed not needed device's DMA address range check on
       dma_map_single() in prestera_rxtx.c:prestera_sdma_rx_skb_alloc(),
       this should be handled by dma_xxx() API considerig device's DMA mask.

    4) Add comment about port mac address limitation in the code where
       it is used and checked - prestera_main.c:

           - prestera_is_valid_mac_addr()
           - prestera_port_create()

    5) Add missing destroy_workqueue(swdev_wq) in prestera_switchdev.c:prestera_switchdev_init()
       on error path handling.

    Patches updated:
        [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
        [5] net: marvell: prestera: Add Switchdev driver implementation

PATCH v6:
    1) Use rwlock to protect port list on create/delete stages. The list
       is mostly readable by fw event handler or packets receiver, but
       updated only on create/delete port which are performed on switch init/fini
       stages.

    2) Remove not needed variable initialization in prestera_dsa.c:prestera_dsa_parse()

    3) Get rid of bounce buffer used by tx handler in prestera_rxtx.c,
       the bounce buffer should be handled by dma_xxx API via swiotlb.

    4) Fix PRESTERA_SDMA_RX_DESC_PKT_LEN macro by using correct GENMASK(13, 0) in prestera_rxtx.c

    Patches updated:
        [1] net: marvell: prestera: Add driver for Prestera family ASIC devices

PATCH v5:
    0) add Co-developed tags for people who was involved in development.

    1) Make SPDX license as separate comment

    2) Change 'u8 *' -> 'void *', It allows to avoid not-needed u8* casting.

    3) Remove "," in terminated enum's.

    4) Use GENMASK(end, start) where it is applicable in.

    5) Remove not-needed 'u8 *' casting.

    6) Apply common error-check pattern

    7) Use ether_addr_copy instead of memcpy

    8) Use define for maximum MAC address range (255)

    9) Simplify prestera_port_state_set() in prestera_main.c by
       using separate if-blocks for state setting:
    
        if (is_up) {
        ...
        } else {
        ...
        }

      which makes logic more understandable.

    10) Simplify sdma tx wait logic when checking/updating tx_ring->burst.

    11) Remove not-needed packed & aligned attributes

    12) Use USEC_PER_MSEC as multiplier when converting ms -> usec on calling
        readl_poll_timeout.

    13) Simplified some error path handling by simple return error code in.

    14) Remove not-needed err assignment in.

    15) Use dev_err() in prestera_devlink_register(...).

    Patches updated:
        [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
	[2] net: marvell: prestera: Add PCI interface support
        [3] net: marvell: prestera: Add basic devlink support
	[4] net: marvell: prestera: Add ethtool interface support
	[5] net: marvell: prestera: Add Switchdev driver implementation

PATCH v4:
    1) Use prestera_ prefix in netdev_ops variable.

    2) Kconfig: use 'default PRESTERA' build type for CONFIG_PRESTERA_PCI to be
       synced by default with prestera core module.

    3) Use memcpy_xxio helpers in prestera_pci.c for IO buffer copying.

    4) Generate fw image path via snprintf() instead of macroses.

    5) Use pcim_ helpers in prestera_pci.c which simplified the
       probe/remove logic.

    6) Removed not needed initializations of variables which are used in
       readl_poll_xxx() helpers.

    7) Fixed few grammar mistakes in patch[2] description.

    8) Export only prestera_ethtool_ops struct instead of each
       ethtool handler.

    9) Add check for prestera_dev_check() in switchdev event handling to
       make sure there is no wrong topology.

    Patches updated:
        [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
	[2] net: marvell: prestera: Add PCI interface support
	[4] net: marvell: prestera: Add ethtool interface support
	[5] net: marvell: prestera: Add Switchdev driver implementation

PATCH v3:
    1) Simplify __be32 type casting in prestera_dsa.c

    2) Added per-patch changelog under "---" line.

PATCH v2:
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
 .../net/ethernet/marvell/prestera/prestera.h  |  209 +++
 .../marvell/prestera/prestera_devlink.c       |  114 ++
 .../marvell/prestera/prestera_devlink.h       |   26 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |  106 ++
 .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
 .../marvell/prestera/prestera_ethtool.c       |  759 ++++++++++
 .../marvell/prestera/prestera_ethtool.h       |   14 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1227 ++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  185 +++
 .../ethernet/marvell/prestera/prestera_main.c |  671 +++++++++
 .../ethernet/marvell/prestera/prestera_pci.c  |  778 ++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  823 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
 .../marvell/prestera/prestera_switchdev.c     | 1290 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 20 files changed, 6344 insertions(+)
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

