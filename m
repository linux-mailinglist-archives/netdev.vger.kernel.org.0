Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E81422D851
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 17:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgGYPHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 11:07:16 -0400
Received: from mail-eopbgr20112.outbound.protection.outlook.com ([40.107.2.112]:19488
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726567AbgGYPHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 11:07:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nyuv4dj/ntMqi5G3x8LOWh41QE1sCf0MDAN5utGyGaPI9sBCAYIlkeAAJZQgXwggnDAcI+iiwQoLizSpixOKp1s5kpkamwkGt7ogYVmj8mkDt8f/ysix5taogjTqtDDZxS037ilIeQgoE0XwSz6WXvWhXJy4FrgS6ZiUj8I32D/MeE1Ow+2o2J9qu7BCiS4htjvSeUHveALFkfbEupOs461lOqEOF6iCoN1DiqO0wbmtk+2dHVvrsxQexDAbR12d6OIuvfWGXZjfdH0NMHIjaIQiWAdFB33M+lSlZhC/ttotBmA5INapQxqKZoOQm7sccfsuO1+f6r36Yq+3jevepA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mssPno6W/69hiI/l4t7WcGXj6Wg4jhyTiOfV3Rs3xSA=;
 b=Ee5vAykK9t8HBGUozBJeUbP5JdZ1dM83J63aUJbhcASLgSQpzVNlAre3I0q9XSD9fgBJoqEPVvLfKCf831tXr7FdG6BESyt2DFRD1eV9C9ZM/m3Ouco0u1rWu7L8hkcdmGw1yNBSsfNzB5TrjYyNZjDvSMu2MJs4S/+GRoZ9G8RviwOqymt/pNmC7t28GtlCu1bk9Y0MufiZnaVb6cp+RjpRXFQvnZ5kfgHATBeCET5tP0XuNBiXk8e6rcZ284N50ISfgKy2tQz45eKo1C302n+B2FWPDqWPMQOeD6sw+Il+EygPz34RhTu4nwohu3jouS9rmpn/sXWQ3SNMMsm0AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mssPno6W/69hiI/l4t7WcGXj6Wg4jhyTiOfV3Rs3xSA=;
 b=BBF0SavlOxwlkG0SOPpY9aJvjb4WoYfFxFAgJPNsHLtoNMQYN0QDc6Jjwa2A6OZGLO7ehRz27LbERrys6oXnv3bCwPR6b209LYUKaBMgerv8ZyVbRKHLjDSLISgZeJe39s99wBe88WLp6AcH8cL/Ne5UtI7xpTH6SHDilMgvngo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0568.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:31::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.21; Sat, 25 Jul 2020 15:07:11 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.028; Sat, 25 Jul 2020
 15:07:11 +0000
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
Subject: [net-next v3 0/6] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX326x (AC3x)
Date:   Sat, 25 Jul 2020 18:06:45 +0300
Message-Id: <20200725150651.17029-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0032.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::45) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR05CA0032.eurprd05.prod.outlook.com (2603:10a6:20b:2e::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Sat, 25 Jul 2020 15:07:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8212c9-0aab-4034-d729-08d830ac67fa
X-MS-TrafficTypeDiagnostic: DB6P190MB0568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0568ED5627F5E0336D4E070C95740@DB6P190MB0568.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXtackj7anccKZbOOsEG4sQ8BMiLgcfBn8Ch5yyhqTxe0Q+gRQLbb//ukyLwUvHjZfTHi4dShp5Vi4HBfjtbhb1R6yPeBKg8Lv6WuPC7PMCBToYvPFxdRqLpxlAMFdXLxAsfBd1ThM/SaGm8sv7gE913K6yNFMUctGodHSwww06WMePfCfD6xCzpTpNXf7xU2/dyzKYBpt/KHqxMphzfjSkAkib6JH7OMiMIA1jjqNF3nebaeAQ3KlC+Tu/gNE3iQNhW+jk5ZvECu64AMFJCLdmHCsV5huHXZgz/pTtaWC/Zx6qIXswWnNLm9T+HaimI7CLcM7X2DxW24EMsJFy0LbdrgjYkXe4IKr+uIVZkQF1b1RIac3XfeOYXQe3bZzWf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(376002)(366004)(396003)(346002)(2616005)(86362001)(26005)(1076003)(956004)(6506007)(8936002)(4326008)(16526019)(36756003)(6666004)(186003)(8676002)(83380400001)(44832011)(52116002)(5660300002)(6512007)(66556008)(6486002)(66476007)(508600001)(107886003)(66946007)(2906002)(110136005)(54906003)(316002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: q5LYqs3UyFbRRkwr1mDORkOSg7U959H6HENoK8tOobeiIDvba7lH5DU2D82D/fJ7F5ljzIG4cz1LYLR5WAP9RrmYHzZjRZixSiQ+CMvWJOaOLMCRBLiNcqOXbAiMTsWoa8sUXSJr06GEsail5tsCA/ID28MGNPGQwbPMli85Ck1MT8xbpvrti/ahi0EI2rdSWtYuNtLHncg5DMVmZG3wCux5A4OoNeGne1y1YZS4DNPrIC7iRLfebT+yB1HhalwKRMp39ZsCHGKQ4vN1JEbvbPHap54bw8YdSRzDysZ9Nv9W/3fnk7X5b/3d6+KytE7r0z/wulGgfLP+3mxSBbty8QvxQLO70o5QO/gC0KltJF81AQ+K3t/kQmPUDpmAyUx8FzM1dOQb9nDLqQU9ap+WBZcmSpWhza98Ve/4vG4yU6cQS7iFUc+BJkXmPzDWhZI7DmI5dRSKChnH7J2t4INiZ+oROufVjFozsOgXF1vTiN4=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: af8212c9-0aab-4034-d729-08d830ac67fa
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 15:07:11.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CHGLbsVLF1i+onyuzWAlD9JZSM1Ov5cwtDavlBGAIEU3N78is2pVFKRXoz+qVudNxpgMUSiHUBEpGEuxiPBlknlFelsHRDQ1EDmEjY6M2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0568
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

PATCHv3:
    1) Simplify __be32 type casting in prestera_dsa.c

    2) Added per-patch changelog under "---" line.

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

