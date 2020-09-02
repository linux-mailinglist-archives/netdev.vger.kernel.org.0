Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E491125AEA1
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgIBPFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:05:40 -0400
Received: from mail-eopbgr140100.outbound.protection.outlook.com ([40.107.14.100]:20302
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727894AbgIBPFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 11:05:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glBMJOkIuc+ibCSOCDLDSJNIBdbZIN68YXdgIKZL6VW8YAWf5Fc3Di1nqw4yvKBVkzgjZzS2WgsIQjFYfSSXEXbiEemaIRbsabhwtGcp5JXkJ5dVky8cELoDNpwE/okbwKTSeOyG+FSrSXP/4QGXnyEsutY0Y+bW0LY0fV9/4eRL5gflMUHE55ZkYBy0+yRLO4eEUW6iKKkrKPdMbKvRNEfvgNuKPZDk82QjfKQUJQeYH2fnlNP7/zL4WMvHcyTaXu6bjLym8m8oH/nJRQWh0FOWSYajdANgnDyc3Zo3o1FlVdVNkGsbA2FIl4GhOOLYmwt9pMR7XlImcz9CbTMTFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfmSaw6c1eZSetmty6flt+2YusY2E//HQpP5YgNgt1Q=;
 b=NbNBIgt8Qq0wL9O5BkHVVVjQpVcl50dqE/FzCXzwVs6ZGhZfsYprOyuZyfVfN8hgmUhbmaA6nHF1mo17D8RkTS1Wbjqdq1JIM8/qRRsJZizBxzY6S1PPj9HyRRo8YHJNDoAsjv7puxBjLPyVycDFDCHiraosJrnBHlkIL4nxs+wV+hW0mg8OfcfoXMz+J0pRax3hHpxhFhzSwd2nNImal/NixzQs2bjMmu9UEYMBsSvX/iz/5n8f4V0DwlGyULUYjl5Sz8/jgOO9F8bP6fNS1zNboRPl7iRJSZTmLlip96CXSIi3S8ig2JOXP29BKvoWYF76L8QZqCi0nfHfNZEw3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfmSaw6c1eZSetmty6flt+2YusY2E//HQpP5YgNgt1Q=;
 b=T49+R5bqrk4WM+9yF4/RuQZAZuRjjylGEc4ghsN4MOfun+E28M9QHS9sVn7R3XqK8NuPo2bQjzJ4aymh+cRof1rd47LrjadZT/+UbZULvd9UXy1IdvH1Y/EHR9PH/J6SCRb6mgJyyI5ScohPoY9SGVc/MC0LYbynhBHweG0UlDg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0058.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Wed, 2 Sep 2020 15:05:02 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 15:05:01 +0000
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
Subject: [PATCH net v6 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX3255 (AC3x)
Date:   Wed,  2 Sep 2020 18:04:36 +0300
Message-Id: <20200902150442.2779-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0110.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::15) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0110.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Wed, 2 Sep 2020 15:05:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e69c9f6-7054-47f1-13d5-08d84f5190df
X-MS-TrafficTypeDiagnostic: HE1P190MB0058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0058402273DDE6DBD2CDDA7D952F0@HE1P190MB0058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: axRZfI1sbVTa1VYsqTXi44o9oi/Cnjx2T2VcrWsKv2/WBhhGGW9xH+bUhBNz3BomL3To/qjajtPVpa0r4fiu0X/qtIkRiatwTUgrXvZNx9trFB/qYuk9iw2MhFq7y/4xcpLnbLPiLMklr2D+gdui/1mWzbuwBPoCF6lsNP/xgMS0NdM82G8W6GIIvfjhHGahHfTVr+EVu6vxVUY7tBHpKBZpcXCcFlzIYbdEU97kd/N1qRdLjbHt3yAzl73/J+9+Cq9sipBkkQQSBbY9ZRPV3b/q0kH+PN6qQqvztMPcXGmiZ3uryxlbAEEWHFvy4PSR5Wnf/KOwo/uoG2yUy6tj232vVN1L9D0JiETTMzuZRvWPAtgyTZ1T3gtXC3sxC9rJDia1JAW096/rS52o/8+awx9nVoljcfXNMyfFV56eypg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(39830400003)(396003)(346002)(366004)(107886003)(83380400001)(316002)(44832011)(478600001)(54906003)(6512007)(6486002)(6666004)(110136005)(186003)(66476007)(8936002)(4326008)(26005)(36756003)(86362001)(66556008)(2616005)(2906002)(5660300002)(1076003)(16526019)(66946007)(6506007)(956004)(52116002)(8676002)(333604002)(921003)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ehegFYmr2Lh0eX55IoEL4jcxdcFRd5pIenD2dcJ6KHlk9RdGB/F8PA2LR+WhSyvLHnTATflI9FdbK0Ebx3ks5xrQYqOiYm61SPpDVy/FWKzR5VciaZcSK7lA2zI91PztIs6sk3ex5K+OUkUj1GXuBxi9acCMxej787S0jK/v0QxauESYiVLpPuR9vYv5iehHF5pjawxDcZnN7Tj/C9Mghe10eYcMgDRwDzBbmR2sE/Ci8O3793SVr3MVj+m+olIUzJTZ2AG+NlOMofC+K0GgUCABnXw7UFH4O5P12pnJHsoE4FvT2WS13FSpduYZG46N5eJoy3nE59+em+2lgnrwjIcbJdVwhicDxxm/+Qf/eU52XRYOazSFsVPa5Qe0u4sysDWOZFq7kxQO4ULwE7yPCmahl0ghTrkNU2CjiHsf8nqMKDMmSTm55fQNC+oKxDnLacST/CnLhK2QwUZcDp34sRXnRzl/i8EQOWrMHKM7vuLYRkxWJt9yNFtnNdpqHZ4Qb1vis+zMrdxIvE0d34gAjROpBLqs8JuFmjPTTAIocTBsZY7/L7BrrY+4gLhE6msZsj+QLMVxgcU8R10n89/VcDecQvn2b9vkY8iOghbvirVb/esHVjh7cBPRIxYFloXhCapYX4hfh1jsZRm2CoCRHA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e69c9f6-7054-47f1-13d5-08d84f5190df
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2020 15:05:01.6597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJw6nD0r3xSqrhBcb7sD1BveVLyLaylnfx2GQSqX9XnBZk9CdP3CYmxzPh/W9MRyyIIgXbjyrPMj20SK3kEGHBPL8Egy7lzEA+GkEGdnJOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0058
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
 .../ethernet/marvell/prestera/prestera_main.c |  665 +++++++++
 .../ethernet/marvell/prestera/prestera_pci.c  |  778 ++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  834 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
 .../marvell/prestera/prestera_switchdev.c     | 1289 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 20 files changed, 6348 insertions(+)
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

