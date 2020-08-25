Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDC025186E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgHYMUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:20:45 -0400
Received: from mail-eopbgr00093.outbound.protection.outlook.com ([40.107.0.93]:59392
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726015AbgHYMUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 08:20:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=it5XZhsQPRtm0874mPPlch3XVrQNcXB9uQaB0cLt9WspfPhkuTRvJhWTgGA5GG2d1QUuHl7Ii5UPZOx/g6SbaHLtIExiCXnEBIUyKR0PKRgjuynQWDuc/BYh9VtfuN17llI8we7L5QDkhL68qP9M2/oMHRonHhKLOF9qe0VLMEUwWEhDiXKg0R8zxBvOXAz6P1WFtN8Pc+pPMTEFqb+4fTWpKRtSnIm+MReCaOIv5XKRjL6ei6j/JYMBdsf3i/2UJi+y7FKzwb6M8XM58k2fAw8XnqjD4XiXlWIgEW7vaPGNq3cuFeeB8q7pjo+SKsuixhyCV/qljpDfHE42VNupfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Kje8SIpDGhTp5bdGi816fU5fSDJ+hhoYSPp57fjG6g=;
 b=V0vLlQio8p0EdY3dLIf4qhQVzw6m4REL967OpYXXH6eQYtmNjPB8ToiHtN3AtS6/T4ky9La94/yvvtZb+IliZc6UH1Myv6hOzv/vAdPvqI4cS3vZuaAKZfsFI9o5z0/2apZTtPBdfx3YARALi0y/W8VkLPoBM0azXLZqgylrigSPIJF6B/aiotDk9/cwmOtnJfojsUjCE7jOSCWqnhhar6q/Lt36nE5AhmSmnotQJVkTwNi1ERdB6CTqmGlVUmMKblHhzmvzvXBgfQP20prXxhCWADE5RyT5SJ99mA5KA8w5jCcao209LthCpvwGqUAZnDoRykmL7dsfs3gwe/iNig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Kje8SIpDGhTp5bdGi816fU5fSDJ+hhoYSPp57fjG6g=;
 b=S6qfD3TGtrJqdCP/3JjXzrnhT7QwPoCRN2piZmlkupBDxav7TZP1eNafSYmRUzBnLkfxFoUvM5fvugYI3XR71iiXO7vYWoRmNNzf+3+RqgD20Xs+tdoM7XbNxmO3FDD1mCfyYRBimPvVZ6kySK21cT0iNfSYUYiksaf17OAFvDo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0395.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:55::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Tue, 25 Aug 2020 12:20:34 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 12:20:34 +0000
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
Subject: [net-next v5 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX326x (AC3x)
Date:   Tue, 25 Aug 2020 15:20:07 +0300
Message-Id: <20200825122013.2844-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0039.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::27) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR08CA0039.eurprd08.prod.outlook.com (2603:10a6:20b:c0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 12:20:32 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 097293ed-14d3-48ff-4e9e-08d848f1442d
X-MS-TrafficTypeDiagnostic: HE1P190MB0395:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0395FC29E10CE8F9DE7B5BBE95570@HE1P190MB0395.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hkj++vGVF5JnLi4hrO0UPk0KiL0P90zojwvzX1keGg+Yq9CKk6Cl0h8BD6JNOyWA2ZdlzKkVs4Nt+EIRWMEZRAkJ1ZNpvBUBE48SmuoNBXbVH8hA889bX72LN8WMg2e3A0VKcDoykEwI0BCxhjdjyjzSLXWxoxqu9Msns3Z+do2jqglCXu1++5p7+TrQUyE7Mqsd6K0mr/2R6lTtAFfC0a8LtfYs16FBkklKVmRftccc/lWtKZ4fTLrrDxBr5OEHv1uAuqL+BFZjjdgSVHPP6kdsGx0K8R39QAbVmBjsfQ/OIWgiRmiFttorqQlR1f9J2X+1WpY08i1BmIgswTJV+iDCA2ls8d7TfMJ2Z01lOe8cu8qCxA87g3JrXn1QAXj+pZJDMdBQdiALotgBJ1TgYfwNKvULmb5XXoiAUUathxc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39830400003)(136003)(346002)(8936002)(16526019)(54906003)(186003)(107886003)(110136005)(6506007)(478600001)(316002)(66946007)(26005)(66476007)(66556008)(4326008)(5660300002)(8676002)(83380400001)(6666004)(6486002)(86362001)(6512007)(2906002)(2616005)(36756003)(44832011)(956004)(52116002)(1076003)(333604002)(921003)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mCF0pgpY5W2TxtCRE1kmlEV3xo+fwH11l/IqRvdebK4B+j/djC52hbFMNvo5Eb3Y4PxZhCAoh5p0t4OPqwM3ZIlXX4N9hH/sP7ce5rZWzngvoq3zhEJSRcHI+Mq1NSiU+vWUFXHzbGBVCmNqaKSOprqyme3Prf3lj1zPjBqINEOXjJFIU6XEGjlkcwVa16jg/ZOLE563DWfGtFGFzZgVLN3I65gjffasqrTUCpP1xjIfk+w3GmXsnoa4lz6C/heLVFWSFa7jL1z7BeVTuOWVHquJlBzocktBG72ITqxJY1+ppJO+yCv7tA5v3XkmDQsvCHsk+FZTMYD8GPCjEisI4NgtIbvbNzLMLkTaXfNfvkxUBnRABeQqGQd+X3noQ2J5+WGRuxIt1g36p3Pi0V3KAjH+sIFrhxN8Id3oB/pqJjstNS1Lki3JM+K2sE112bE3xc70CtNreVP/DCAYnf/f4if2oFasJwstxQaOcjJ3lAdxXCdmG5fY6YMbOO70j57ew2BMxcNMfRCTCRUqn1sdTLDPXdndsqeCA3p+L4xzjS8lkFT0oEJGWa8Z4ad6afirj1PAbGrre3ridhQN9KqZ/3XBwIsR4BsgV7BwTkPVwr2O2Cf4/Bx0TfJ+JxGSRRC3BGISYfH4IB2WyH0X5O88fg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 097293ed-14d3-48ff-4e9e-08d848f1442d
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 12:20:34.3393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjxtssO8XlTMjIzmWCULedYFI36Ldg/eIiT7pkTX4HmS1a5SKnaDrOp+RGwSxEtQLgGSZfDUmtNwP3S7SmyPrVCeuNKhzPADmP3ExEEYn8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0395
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
 .../net/ethernet/marvell/prestera/prestera.h  |  208 +++
 .../marvell/prestera/prestera_devlink.c       |  114 ++
 .../marvell/prestera/prestera_devlink.h       |   26 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |  106 ++
 .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
 .../marvell/prestera/prestera_ethtool.c       |  759 ++++++++++
 .../marvell/prestera/prestera_ethtool.h       |   14 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1227 ++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  185 +++
 .../ethernet/marvell/prestera/prestera_main.c |  646 +++++++++
 .../ethernet/marvell/prestera/prestera_pci.c  |  778 ++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  866 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
 .../marvell/prestera/prestera_switchdev.c     | 1289 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 20 files changed, 6360 insertions(+)
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

