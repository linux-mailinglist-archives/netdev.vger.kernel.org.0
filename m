Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFA52648B3
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbgIJP0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 11:26:50 -0400
Received: from mail-eopbgr60116.outbound.protection.outlook.com ([40.107.6.116]:17127
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731214AbgIJPBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:01:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkLVMkWKo8xPgboRy0k4xBPq/y7zaENQZxP8O5bfddLmFdPqyH99g8AVStlvKWqBBnB0V7YNfhi8QB3rHhsfZuv3Z7x1pWiDNVWsR8MfrqGxi3yYpyPSBMubwPvf88aadRHDmF8WQ/KK4irqcp6juiv/DXx3fEwE4bdvn7WNsGpzJaz324vGbFZr89fgNjNuibuFNOhp79sguJKRJHtuHA3vFoX5X+VpvoTFuwc6tG1mHUis9fnMc/qpgch1+uqhFjXWXu97gqCxxp2oYNiXIcL3zGSM658aRLOchqQLLDBiNxknc6la7IzdRwd9cX7L96omGzw17PqRUSpWv3AYCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojHdrgyWQavrC3WmAeeTJPUVIb9uOC159aW5l6WDvVU=;
 b=B4B9O8w4DKyFnRzJxUEVL5WLG5Q6Fj214dpKUkzgcW0qe9O02bfxKwTS8U6VlvKMuIHobVOAfIAO+wAk18yjIduC2EYL4B+xsgPdfM/YWpXjsFfeEsnhBD1NdeFtdHi6kAK82AKrZBytJdtrgO2vG43Ev4eAWp+cqmUpjgLqV0npdhqNgZjffObW17OFNJqUOtkDoXuDJC3Lz+LMLHnAstWhLzPyAcvLrHfYe2lMJNcdpuNmoHQ2+4I3Lat7swR3YlXRvGPD5SqnAnsWtc2jLJgoMMINKpppTjk/ypIFR3MBfIPjJZekLh9dgDdmf/Xf3ME4DRO/GMIO+rLDA/92Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojHdrgyWQavrC3WmAeeTJPUVIb9uOC159aW5l6WDvVU=;
 b=qD2YQ/CM623l89EN8oDhr7GOLuSYvRrR+6H2tryx/VJN5gUD+TgeEKETX2UTkaGIQsTh9mTwrw6BCdm64f4VLl1ZkH8bHnij9o2jX3l6UC9zMFw/33Iv2QG5VYOUDtBA8fU7Brm1ASRqyMdGRg5kuBW2VI0OTahml5puHLATKdA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.19; Thu, 10 Sep 2020 15:01:16 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 15:01:16 +0000
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
Subject: [net-next v8 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX3255 (AC3x)
Date:   Thu, 10 Sep 2020 18:00:49 +0300
Message-Id: <20200910150055.15598-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::19) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.10 via Frontend Transport; Thu, 10 Sep 2020 15:01:14 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41211a0b-8652-4476-9776-08d8559a5d99
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0459F5689237D26A9846192195270@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYAVxiRr1SgLUjWwxbnCNWnlGASG/+01Yfx6zp510jEkjUf2Wtpo/6dtbVxx14hd18OqFi+YKebFnXOp04uHw2nY69dQpesRlgFGefdi8gBL6vmxPCG5uH2ZsRvr1dLlSJKesX84znQoKl6uMLRVV7sE+iyGrkXdgfXEVZFR2wrgP6fOfOwdchs5aO4IbTxPnHQqPGAaazJdpslTZxfvrCEHV3B6Hx/y1RBaFmjpcoqo0uDDDFYzE9PPblbWPVpzQGgqlLp+o0WcCbiNjByVk6i5Wc4T4SAB0dK+qAq5WhqelI/XOY4ZnzKlhyD3BchMPzmq8xL4FqWWubSCIFt80+4aokRnszxGPHapZem4yJT1E/43oH4FBY3ePGsmCMnd+xH8LB/CiqycB4mABSye5yA+quzOBC2ELED9jpakKQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(366004)(376002)(26005)(2906002)(8936002)(110136005)(186003)(16526019)(8676002)(2616005)(83380400001)(44832011)(4326008)(66556008)(66946007)(54906003)(66476007)(30864003)(1076003)(6506007)(5660300002)(6666004)(107886003)(956004)(6486002)(478600001)(86362001)(316002)(6512007)(36756003)(52116002)(333604002)(21314003)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4/nAIUp6zC8Xm/8QGvYrK+fPnucDxcsOnyWv+q6Y527UFZs6kDujkJugYSCSOWenFWygh5Az4A6hVPAZLl5+7i31bevzRxX7rKqPySMywWZlwBbJb+7dkj4OW+usR7c36EhRo2dyvShY1i2ldiDogCvG1qDxiSP7fn2T7+0AwwJ1XQFPvrH8djLNrWb7WtVa5AeGbdtzrwMVOgksWNrNZjIqNqeruvv9oUR2jLIN5ptVRwJYh4Q1pPtHi3rUcD+rQ9n6qgxIPEaJndlu1tBepyE7idshQiXt6Rt/jaDoshimpM/DAmGNnvuNylcmtzMrUXTVxf/Ti/PIOt7jHEdHVh5LFG2NVFtnLWSg/N6y8/1rtftL2rONcZjlOsSDEoVN2N1izFI7RBqRxoDyMe+/XTaLPlHa0eonlZu4KuVFafAGgbJ+G1ekFIpH75CP4wR/snDW82mVwkAw4vDHE5mPee6FKhBLwbPgM9qlp3SThFV+wn8kQD8FTTznxbLS1kFYBUa1m8cFF2rJ8xD47RZBSH2tRBs8L2BaIl2QwAjpzY51jll7E/mpCIv4uABtc1sY2Wk8kO7aEnx5HNbJI4MNx/uUslnR/Sgan5e3r6PHAFJktZ0cAjJqNVEP/7uGJX/i8rIgAnDLrdHOv5r3kYrLyA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 41211a0b-8652-4476-9776-08d8559a5d99
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 15:01:15.9894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBknSG+qdqMxH9bMVChyRgamIFs+v42HV3joeir8lXLcs1HEIfTJE4x/G6oivf49NDNZSXAF6iZG3wkVuXEdWgpete15tgHG33sVZ2PrNso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
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

PATCH v8:
    1) Put license in one line.

    2) Sort includes.

    3) Add missing comma for last enum member

    4) Return original error code from last called func
       in places where instead other error code was used.

    5) Add comma for last member in initialized struct in prestera_hw.c

    6) Do not initialize 'int err = 0' where it is not needed.

    7) Simplify device-tree "marvell,prestera" node parsing by removing not
       needed checking on 'np == NULL'.

    8) Use u32p_replace_bits() instead of open-coded ((word & ~mask) | val)

    9) Use dev_warn_ratelimited() instead of pr_warn_ratelimited to indicate the device
        instance in prestera_rxtx.c

    10) Simplify circular buffer list creation in prestera_sdma_{rx,tx}_init() by using
        do { } while (prev != tail) construction.

    11) Use MSEC_PER_SEC instead of hard-coded 1000.

    12) Use traditional error handling pattern:

       err = F();
       if (err)
           return err;

    13) Use ether_addr_copy() instead of memcpy() for mac FDB copying in prestera_hw.c

    14) Drop swdev->ageing_time member which is not used.

    15) Fix ageing macro to be in ms instead of seconds.

    Patches updated:
        [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
	[2] net: marvell: prestera: Add PCI interface support
        [3] net: marvell: prestera: Add basic devlink support
	[4] net: marvell: prestera: Add ethtool interface support
	[5] net: marvell: prestera: Add Switchdev driver implementation

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
 .../net/ethernet/marvell/prestera/prestera.h  |  206 +++
 .../marvell/prestera/prestera_devlink.c       |  112 ++
 .../marvell/prestera/prestera_devlink.h       |   23 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |  104 ++
 .../ethernet/marvell/prestera/prestera_dsa.h  |   35 +
 .../marvell/prestera/prestera_ethtool.c       |  780 ++++++++++
 .../marvell/prestera/prestera_ethtool.h       |   11 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1253 ++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  182 +++
 .../ethernet/marvell/prestera/prestera_main.c |  663 +++++++++
 .../ethernet/marvell/prestera/prestera_pci.c  |  769 ++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  816 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   19 +
 .../marvell/prestera/prestera_switchdev.c     | 1277 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   13 +
 20 files changed, 6331 insertions(+)
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

