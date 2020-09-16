Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9C326CD3B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgIPU4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:56:02 -0400
Received: from mail-eopbgr150138.outbound.protection.outlook.com ([40.107.15.138]:29813
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbgIPQw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 12:52:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nd23UyMHQs4v07T0LCJcftoSnO4sAf/FT92AptBe2Ob1x3RduDUeBrMIloLJ/UhUGdRqpgqYn+EqgdUowyVriPv/WpZbP9BEhdsD3n66MUVgsURlKjc6YR1Tp5RA/COySTFcD/b+rAUaiCuuDhNPAfEkCobmVPXM9D/NfXHtIVJ5HHJy77J7LmWzcy/RehzoGIa78EFRYcxkvsvxiQbiSEpcLGQ5Gl2LO6UgGSkS8UOsCThbWMfF3hq7YEavEzXUjFMyFuwQsOWo7rF2AthMOzKgegEcbkJTbTQbHqLo30I1phBm50my/oPPwF8eavpU5WiR0M1/v5fNNR+ZMc8IuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXDEn90sJz3GIFZfbChYqBWW/6m8b8+4jaiaMmD5n1g=;
 b=KI3Oo89ZB9CGBOG8J19qb69rp1sJSABLnwUVqk0eQ13hFZhRnJHXm8BhK3Szcmht5HSAj7aguBXI0IsUFAgDbNMkO7z1O8mzgT5h1n1PHTwxZo757KyLIFlq/K3K2P2IZqSyohN1oyrkW+Nr/t5aSXIYhida4xNf7zzLQJ6QSeC20q8Ac6eb/lewJ6vuIHDLRY5Q+vA+GxX/8PJbzO1bGaV0e4na3b2hdA3Rml2tVj76hDi00JyK3Orla8h1MSjEhxRRP6SirkM6JtD/X55Ex4kYc/NMylxU7OLiM0vYBN/cpDrVd7rzUQlfK7+dLgWvGYzoXyAJEwPW4OjYwISqbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXDEn90sJz3GIFZfbChYqBWW/6m8b8+4jaiaMmD5n1g=;
 b=G71/rClE9joL3YWNqRf7it/TbNERCuz/ISNdWoHOpIuJ23vX9qgxTt289a0Yp2t0Ml5jxJDlt3qCkAo12Imw13mnyuD7w4Fyn5vCerCLa8zf9SLIeryk/o8gTx0mxq/gXL16ooRi3nSwShCyahnLUchvkEXi+tHhsC5zR3ahsL8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0332.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.19; Wed, 16 Sep 2020 16:31:29 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 16:31:29 +0000
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
Subject: [PATCH net-next v9 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX3255 (AC3x)
Date:   Wed, 16 Sep 2020 19:30:56 +0300
Message-Id: <20200916163102.3408-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0202CA0070.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::47) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR0202CA0070.eurprd02.prod.outlook.com (2603:10a6:20b:3a::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 16:31:28 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a98d314-fc96-4b80-c265-08d85a5df6ce
X-MS-TrafficTypeDiagnostic: HE1P190MB0332:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03326DA1B46F3C4ECE3A24F795210@HE1P190MB0332.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSPEJ/aRjr6LU8GgtduLRDovq3qub/Gubpilk9VgaCpvdbaBUydMY66K1fmjjZrOeVo77djtWMCGqVp+9GBK1vez+PhY3dy5Hvg9KSmB6T8TchKgF5dgxPybYQLeJLTNofRYI/VW7GdgWErXJ+m4jfTDqvmsWDY1kXkc6hrraAeS4T3UlGndQ/BCYStmJBc77kF8qyLz7Lmr0CEzR2U1xPf4IQ4teFXQ7n1kX6zPOemjSLBotJJ7ojN8eMotYrl5GeGz3N8Zhy1KMOa3uqDNoi91Xtakt6c3TNeYhoT6cP4hIOEgAl1y1iRrJ9XCTHy93YY1uTWGIBpZTIhhJDnpsODlS+x5qnq9MOTGtsZ2l6fzSR+i6CSUkX6uwY9oVxBjWF/1fhXDipDEqd52NgDsBVFaSI8rzkFgC8uze8ZbtOY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39830400003)(396003)(110136005)(478600001)(66556008)(66946007)(8936002)(4326008)(66476007)(30864003)(8676002)(6666004)(6486002)(1076003)(86362001)(5660300002)(6512007)(36756003)(44832011)(83380400001)(2906002)(54906003)(6506007)(316002)(52116002)(26005)(107886003)(16526019)(186003)(2616005)(956004)(333604002)(921003)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: N1jOQMizW5sSODmoTz9FG+FY+scSf9oI6wyjRZ6mvqAd05Y4jKg+gduP+IBOpeIvntwKxnjsNhLriucLDd2qUzwLTZZtaggug1M4FP8LAhF6J47lk/RXo81PaugP3++a84E60cfhpmPpoXOo29N6Yms4r9HJsZ1+486P2osqGZLK1eTKvRVeo5l8uHlFlgAuGptOT3uyP3ULFiZZlg0OQ3ys69Da+fvJw8cW3x6sXX6sMG0wZW5xupWppnHjSyCA9qu1KdiT7mdw5t7OQsfDNjC+qWHI9C8MHZGcgl1tv2PzKzVSfm7pxjz70UzFgbepHc6qs2gxQsY9bV+n/7918GCpMwe1OTwy9QmNWuVOsZmhyM6lUYH1mbl1dyp81c+4deN6+kzkSzab/HHW+mAp1xshgXaB5tQvt9Qfg2IhztCsrMN5nxZohAbE8XwSlHOaN4aGaMwaeEOH/PxUM+XwmVlmjIA1cy9FG1t5S+Hl1MbLBkjstOE8IwcF1DH6oLbjYEZumUGXOD2wF82M0t/vUVl3Z6JgKt+H9cqQEs53G4Y1MJLBt2CC0SeEMVjZKLbgd9JN1nC5MuniIwOUGofer6Aohtselt9UgIQLv+qOjv13dyZs769dfTjSJnBb6oVnnqZP/YqQX3hVUAeXnNP3nA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a98d314-fc96-4b80-c265-08d85a5df6ce
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 16:31:29.5327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kg0U5cplWZwS3cWyoCd1fwYs8LxMqXumWrsiX6GQBCvr7UihlxmTXrAjaGyOROabdoIUHnRSROnoSj+7ZmHjr6AH+ct8aBSz57EcZsDabD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0332
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

PATCH v9:
    1) Replace read_poll_timeout_atomic() by original 'do {} while()' loop
       because it works much better than read_poll_timeout_atomic()
       considering the TX rate. Also it fixes warning reported on v8.

    2) Use ENOENT instead of EEXIST when item is not found in few
       places - prestera_hw.c and prestera_rxtx.c

    Patches updated:
        [1] net: marvell: prestera: Add driver for Prestera family ASIC devices

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
 .../ethernet/marvell/prestera/prestera_rxtx.c |  820 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   19 +
 .../marvell/prestera/prestera_switchdev.c     | 1277 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   13 +
 20 files changed, 6335 insertions(+)
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

