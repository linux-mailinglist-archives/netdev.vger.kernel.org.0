Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4122EBFB
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgG0MXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:23:16 -0400
Received: from mail-vi1eur05on2133.outbound.protection.outlook.com ([40.107.21.133]:30592
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727078AbgG0MXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 08:23:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZGBTBbLAlNwpZcZJPcVzW9idK3prGXZv5SAvRC6JqD6L9ump0NrVmWKruq+TB2sVzTnD8J29HAmcAklHV9cvQtm2Ur57LxjdpQE6Nt3i7E+6kIUa6YT2M4k8o7wcfd8E0pAvrshTLr8j9UsdlNyhI395v3pFK+TaO5Sr9ZNPWjv1SBrZYVosT9sgxEHK182Up1K7YPtxl/w/3V7ZwopVnT10GvGQT3VBB/37VChpfOMvTxsNSmR4B6BORg7OMs6L7BbIeMNCaTcj8ePNNjGjWpAsg0jiwonb4z6eHnBmHhGCJi404HZl6WPVBBuga0sm222pMJBjGzV/7OLZs8+GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0t2ZXOlTVnMlgNUjfmaUblgPx1JpYb6gG9RlrlS9Yo=;
 b=YQx0smbb1sKQV0umcPUeOZDo+aB3Sh1ptiTKS9Fb/ZoY2hG37Cpz5asO/tdd71AOZoa2DQtMbuzWj2qkTNjSRqvnaoOAbpiAbiVoe3YxhULIyYir5jSnejTGi6gUEaQDzLxA/Z0mLx6DsJbcpbHZ5fBPn0/pb7znT81b3yTP69J5ePa6ztIF0/us7MKE+rUwRggIrSsutiy4gOY6TJ80auaHRVnfudDYE/cRnUihAWY5YOmW4ozhXkibdY8hme51dR2WWXalC8JYFDK66kWnQ5LMbXrUnZx+8ZlYkumaW4k068ppDBW1esvW66VS7kWXVBkhxRwH56QMd2ZWv345Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0t2ZXOlTVnMlgNUjfmaUblgPx1JpYb6gG9RlrlS9Yo=;
 b=T8MbmVVqPMJedQPswMscWNXKSTZhoRMUhBK5vzP4HpMIo0CyT7F++PY+EXC6stBvOZltW3YxCQj6wG1wqsp5f+Gn5PUsJKXynVUNzl3JTTBisY3GYDj6KMAb46/z4li7GX7+qIOjHGmEBekusaih9/U2nn8xe2IU3FS1LvoLD54=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0151.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:88::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Mon, 27 Jul 2020 12:23:09 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 12:23:09 +0000
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
Subject: [net-next v4 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX326x (AC3x)
Date:   Mon, 27 Jul 2020 15:22:36 +0300
Message-Id: <20200727122242.32337-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0010.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::20) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0602CA0010.eurprd06.prod.outlook.com (2603:10a6:203:a3::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Mon, 27 Jul 2020 12:23:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa47ae27-a5da-4f59-8e0d-08d83227d276
X-MS-TrafficTypeDiagnostic: DB6P190MB0151:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB01519800CAE77AB7302CA2BF95720@DB6P190MB0151.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RfEcIWQQauhJRcmTgLGxytU0euRzNtow0Np+vEr2z+rGe2ueVmzQzMYwgzhpse0vcNH26YvUE+cBS6zEL6IiSzfTofdZ17TTAc065tQffIPMAuYtGv/ptr+9G8AR5fkzhZZ7utp91ymZ7hDB0P7oFMk/a6OxA6vWpFXIjGMygkyBB9d+GkDkk4T0yG69mB3rUeFtnkR/G5pHS4mhmQ6+mQN7QBavTX4NEnxOOXBvpIy7SB04nnwVuun6OgbILtRUxK9GuwDyH9b46vrxZg2oyRnPDKjzPxHDcpf/9qIppGMWcznyMJL1IXuCbT4vkeMrmlcEDRaOXGIbDQ2vh9e7n7gOYop5gs0ALcccgPWjsomlj4GRmV/K7MqYXhoY0328y/OEL315xjrXPlRbMq3JWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(39830400003)(396003)(136003)(376002)(346002)(366004)(6506007)(508600001)(83380400001)(956004)(52116002)(316002)(66946007)(8936002)(36756003)(26005)(2616005)(8676002)(66476007)(66556008)(186003)(44832011)(54906003)(6486002)(110136005)(16526019)(6512007)(86362001)(1076003)(107886003)(4326008)(6666004)(5660300002)(2906002)(21314003)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QTo6nNCC7LUfIidRGOLVeJiwI4mn4AfghG67odeHVsABzpw+tCTqd1f8hvJHFoUYacUCKwq3vdz9KCA99XlbcXDgs4CdxO2HIaIJlKjToU77xDbubcFMh7BogSyS37KOAh+g5E1ZZC9CYgYB1LBvP25MjHiis5KTzbWQn42SDUs+0e8IggJrc7vs9DDmshlHnJuCaIPivyuMMYqDD+UGrAsJ3SBzALbItQ+HgWozhCQ6xht1pPlQu0fI53mLZDtm5hLDiOxssMwwD26+0SKCeKw/pOGLO0ZdTG4O6nMk245hcBuR0h0Zu6zjkMKcY55+JHFvdQr4a3TWfb7EVKMB9D69jiTaJCd0240OoBSQCz7m7ypZURHc4ePSvcx7BCeTSvCpSe+7MMIbApcy8f5OaSGVGdS2tKU9p3ChpVsnK/4t6Vh1tr0cSO29w76uGs0o1Z351cVnRc+mxX1Ti2vXCgYowk7v6NYavjzMZiZyJeg=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fa47ae27-a5da-4f59-8e0d-08d83227d276
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 12:23:09.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6dpAZLLpUKt3B14PJKfxvzzX07LNP8vOTNxaaw/u93+9sUjOI66rhfAWpILZcEwhhJMQgFwpQH0iWYdAV/holMBC3m33r5e3ImRJeQHdDLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0151
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
 .../marvell/prestera/prestera_devlink.c       |  120 ++
 .../marvell/prestera/prestera_devlink.h       |   26 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |  134 ++
 .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
 .../marvell/prestera/prestera_ethtool.c       |  752 ++++++++++
 .../marvell/prestera/prestera_ethtool.h       |   14 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1231 ++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  181 +++
 .../ethernet/marvell/prestera/prestera_main.c |  639 ++++++++
 .../ethernet/marvell/prestera/prestera_pci.c  |  778 ++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  860 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
 .../marvell/prestera/prestera_switchdev.c     | 1289 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 20 files changed, 6374 insertions(+)
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

