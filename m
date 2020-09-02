Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6258925B588
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgIBU6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:58:07 -0400
Received: from mail-db8eur05on2095.outbound.protection.outlook.com ([40.107.20.95]:23974
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726226AbgIBU6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 16:58:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUs+nlL4OI8C2boIG7Wxe4ZNvWpBgCjfAFO8t60UUPFHOfimKDvFnQ0c02fwjatWp+PTacr7W/bl25TzvxJZvEfpks3N7vwlItAP2Q6BHFCnfEEqe4QzwzaW7/GS2CmlbLo5eBlaOCUj/iIMOeAr2dKwdMuq1wT/ykOHiYE2/FFVSX4mY0loHwlnfPGVbudt5alFZBsL2X2/bUJ/d5ma7u117Ktt+Tv3v1HI6oJdbo6tZGRrOIXDJ9YjTxcg3B6boJ57hOUE1KLQt5+UaMypTwrIc3fB3HCum60beztbLFYRhTrKMUJzwgVUfvG4/qlrEXOGP248CXwKwNTS5xIq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSQ+7qAnWeCvwowyI+lZH3qfHXvpq+W4o27x/Opo+ow=;
 b=QMWW8lPzCi1z70NdERdQuUKMFwMr5k5EW8hLrPHDU+Oqmw0zxT6xHQlloZypH/23vygGKDGRlo9Nf5XEAclya2MeNF/JCaYVbz3+VOYdBsW+GpvpUpgnvI13D4xzA+eitNRYJh8EQlotM0XH/XBU3bq/xBc/ym3CeryevZjejWDw68O8DQAO0rKyfIyPBqBaVOG8v3cppwhKaV6tctSyoBhZZdcJ9m2bsQWuSgv8pNa8R/TtjLXJMWrV9rd+yYs5e0HSMKxebU2i5mcDRWHnF2qL0Nihk/hf1uJuCSv8PQDlMX2qK58ee73LRpT0v6/HqZyZ3EVpU0A0pzB4Rneizg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSQ+7qAnWeCvwowyI+lZH3qfHXvpq+W4o27x/Opo+ow=;
 b=HaBC9uJb6ZvZZeBP5fnu84MvnwQRHigmQWjcCZkMlQRTQtAK4Qq0/paEE/igw6dpywMVKrop7/cwbMeFPU+j3yX+tBkJsD7IAQ2ugW9akc6ncmTpnKJ77a3vzrv+NJFWGTVv/t4bsZE2eCek2w37IQZ1TzPi2RelCZ3tt2+v2gg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0220.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c7::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Wed, 2 Sep 2020 20:57:56 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 20:57:56 +0000
Date:   Wed, 2 Sep 2020 23:57:47 +0300
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
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [PATCH net v6 0/6] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX3255 (AC3x)
Message-ID: <20200902205747.GA1685@plvision.eu>
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902150442.2779-1-vadym.kochan@plvision.eu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0101CA0015.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::28) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0101CA0015.eurprd01.prod.exchangelabs.com (2603:10a6:206:16::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Wed, 2 Sep 2020 20:57:54 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97007e9a-f00a-44bb-c55b-08d84f82ddd6
X-MS-TrafficTypeDiagnostic: HE1P190MB0220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB02206C85EC03055658C5C545952F0@HE1P190MB0220.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grle8R3Ca2+MyJ2kExOJ5O2+ONiKk8yfMMKHtXsMfPzpAtAHZ57/sTkcgEqi9RX5fXE24S7mQPJEq6UziQdCU+fL7Bz5mlF0DXSA1JMm0y4k0ia4/91mljjbxPCwzQt5B6kRKDIJRMd+AcsEkxTfhaKQRn94tmomV1w3OSzPgm+r+IaN2GuYgwWoiLoliXEosXcH3YvedLFUVM47dg9iCrw1/WWwMK+y4UClWuZiaDvKQRupmXj+XgyKtO1jX33qHjUTj9Qp2z9PWWo8j7DHIQbkBfk9cHkxi7iUUMzWfjWaK85eMRq7bPq0raHEhcHah9rynCMhvUdjQlpgsv/aaga++PHMX8bz/FECHse16I0rI50L5PhUM2H1bW+Y6KEmMqcJ8hN0rz37v///u0dHszdJoGxsW5LPFGdTPP6xnQg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(39830400003)(376002)(396003)(136003)(2906002)(8676002)(478600001)(66946007)(110136005)(8886007)(66556008)(66476007)(83380400001)(2616005)(4326008)(186003)(44832011)(316002)(956004)(16526019)(33656002)(7696005)(52116002)(55016002)(8936002)(5660300002)(6666004)(54906003)(86362001)(36756003)(26005)(1076003)(333604002)(921003)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3yPqnb5am66IQoZdut0x4A16ZXzuv0Z35dxjCNGXRG50Ryx8xWC2tU6uSTR3yrPlwmgNnQFTgZIma5Ra7NYfF2o3SqV7Qo8VlMjgAA7oS6RysMSKc0IE+d58Gb6ue7g9QNbM3elZgjQepl1XSjr8bFRp2ZuyHZ9lu/O23dAO7dbf0wf4xwgD+J5OSeUTCPR27O30shdq2rhiOFPf45M9AHtRI94pYSepKIBdzk9CEknjrC3R/AcIJneCGMwvov5ZuTGnJb/Bi4J7LAgHWGSocu3wbMUsk5D/cK8fCcYF0xb4CKV5uMysbbGhP1hHULW/4uIdyWHlfauEB9egwYH1jccsY8/e58r7ykrFp0GHiB5L5xb4pAK57sqnkL7jwhF3hF5d1IZv0YWkbjp9YNc6i/DXoZth8ThVPNO08envDs9FGdwzYlSzt3fzbM/FNiFIB7WMjfXpKRUaOsldOeG46Pn8NKbPXavTilUDet6ju0Utaey2lESmfypLlg0MBp3+qlHt311FKv94VCYi6yBcUcCucCoogxw3RhaPJj9e/Fq8knWR14XdEHTMtq/gnEf0fPzKIjTpFGZf6rd9HQxLXthtiT8+LKVfsTX57Z68QA/MNJ5BfYoqBlgPGOhCnPL1z/W58Vp4MCxjRXPIFRVNHQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 97007e9a-f00a-44bb-c55b-08d84f82ddd6
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2020 20:57:56.2296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0s9+/OmDrExDexFGH9IQzWkj21oGJ9UxZhtKXVCwEtZgd7xRnkAQTWqk/By/5NbNyf0L86SZaAhgY6fZS0wm4WPlqvaajoH2hvLrTO3IcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0220
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I mistakenly used "net" instead of "net-next" as label.

On Wed, Sep 02, 2020 at 06:04:36PM +0300, Vadym Kochan wrote:
> Marvell Prestera 98DX3255 integrates up to 24 ports of 1GbE with 8
> ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> wireless SMB deployment.
> 
> Prestera Switchdev is a firmware based driver that operates via PCI bus.  The
> current implementation supports only boards designed for the Marvell Switchdev
> solution and requires special firmware.
> 
> This driver implementation includes only L1, basic L2 support, and RX/TX.
> 
> The core Prestera switching logic is implemented in prestera_main.c, there is
> an intermediate hw layer between core logic and firmware. It is
> implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> related logic, in future there is a plan to support more devices with
> different HW related configurations.
> 
> The following Switchdev features are supported:
> 
>     - VLAN-aware bridge offloading
>     - VLAN-unaware bridge offloading
>     - FDB offloading (learning, ageing)
>     - Switchport configuration
> 
> The original firmware image is uploaded to the linux-firmware repository.
> 
> PATCH v6:
>     1) Use rwlock to protect port list on create/delete stages. The list
>        is mostly readable by fw event handler or packets receiver, but
>        updated only on create/delete port which are performed on switch init/fini
>        stages.
> 
>     2) Remove not needed variable initialization in prestera_dsa.c:prestera_dsa_parse()
> 
>     3) Get rid of bounce buffer used by tx handler in prestera_rxtx.c,
>        the bounce buffer should be handled by dma_xxx API via swiotlb.
> 
>     4) Fix PRESTERA_SDMA_RX_DESC_PKT_LEN macro by using correct GENMASK(13, 0) in prestera_rxtx.c
> 
>     Patches updated:
>         [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
> 
> PATCH v5:
>     0) add Co-developed tags for people who was involved in development.
> 
>     1) Make SPDX license as separate comment
> 
>     2) Change 'u8 *' -> 'void *', It allows to avoid not-needed u8* casting.
> 
>     3) Remove "," in terminated enum's.
> 
>     4) Use GENMASK(end, start) where it is applicable in.
> 
>     5) Remove not-needed 'u8 *' casting.
> 
>     6) Apply common error-check pattern
> 
>     7) Use ether_addr_copy instead of memcpy
> 
>     8) Use define for maximum MAC address range (255)
> 
>     9) Simplify prestera_port_state_set() in prestera_main.c by
>        using separate if-blocks for state setting:
>     
>         if (is_up) {
>         ...
>         } else {
>         ...
>         }
> 
>       which makes logic more understandable.
> 
>     10) Simplify sdma tx wait logic when checking/updating tx_ring->burst.
> 
>     11) Remove not-needed packed & aligned attributes
> 
>     12) Use USEC_PER_MSEC as multiplier when converting ms -> usec on calling
>         readl_poll_timeout.
> 
>     13) Simplified some error path handling by simple return error code in.
> 
>     14) Remove not-needed err assignment in.
> 
>     15) Use dev_err() in prestera_devlink_register(...).
> 
>     Patches updated:
>         [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
> 	[2] net: marvell: prestera: Add PCI interface support
>         [3] net: marvell: prestera: Add basic devlink support
> 	[4] net: marvell: prestera: Add ethtool interface support
> 	[5] net: marvell: prestera: Add Switchdev driver implementation
> 
> PATCH v4:
>     1) Use prestera_ prefix in netdev_ops variable.
> 
>     2) Kconfig: use 'default PRESTERA' build type for CONFIG_PRESTERA_PCI to be
>        synced by default with prestera core module.
> 
>     3) Use memcpy_xxio helpers in prestera_pci.c for IO buffer copying.
> 
>     4) Generate fw image path via snprintf() instead of macroses.
> 
>     5) Use pcim_ helpers in prestera_pci.c which simplified the
>        probe/remove logic.
> 
>     6) Removed not needed initializations of variables which are used in
>        readl_poll_xxx() helpers.
> 
>     7) Fixed few grammar mistakes in patch[2] description.
> 
>     8) Export only prestera_ethtool_ops struct instead of each
>        ethtool handler.
> 
>     9) Add check for prestera_dev_check() in switchdev event handling to
>        make sure there is no wrong topology.
> 
>     Patches updated:
>         [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
> 	[2] net: marvell: prestera: Add PCI interface support
> 	[4] net: marvell: prestera: Add ethtool interface support
> 	[5] net: marvell: prestera: Add Switchdev driver implementation
> 
> PATCH v3:
>     1) Simplify __be32 type casting in prestera_dsa.c
> 
>     2) Added per-patch changelog under "---" line.
> 
> PATCH v2:
>     1) Use devlink_port_type_clear()
> 
>     2) Add _MS prefix to timeout defines.
> 
>     3) Remove not-needed packed attribute from the firmware ipc structs,
>        also the firmware image needs to be uploaded too (will do it soon).
> 
>     4) Introduce prestera_hw_switch_fini(), to be mirrored with init and
>        do simple validation if the event handlers are unregistered.
> 
>     5) Use kfree_rcu() for event handler unregistering.
> 
>     6) Get rid of rcu-list usage when dealing with ports, not needed for
>        now.
> 
>     7) Little spelling corrections in the error/info messages.
> 
>     8) Make pci probe & remove logic mirrored.
> 
>     9) Get rid of ETH_FCS_LEN in headroom setting, not needed.
> 
> PATCH:
>     1) Fixed W=1 warnings
> 
>     2) Renamed PCI driver name to be more generic "Prestera DX" because
>        there will be more devices supported.
> 
>     3) Changed firmware image dir path: marvell/ -> mrvl/prestera/
>        to be aligned with location in linux-firmware.git (if such
>        will be accepted).
> 
> RFC v3:
>     1) Fix prestera prefix in prestera_rxtx.c
> 
>     2) Protect concurrent access from multiple ports on multiple CPU system
>        on tx path by spinlock in prestera_rxtx.c
> 
>     3) Try to get base mac address from device-tree, otherwise use a random generated one.
> 
>     4) Move ethtool interface support into separate prestera_ethtool.c file.
> 
>     5) Add basic devlink support and get rid of physical port naming ops.
> 
>     6) Add STP support in Switchdev driver.
> 
>     7) Removed MODULE_AUTHOR
> 
>     8) Renamed prestera.c -> prestera_main.c, and kernel module to
>        prestera.ko
> 
> RFC v2:
>     1) Use "pestera_" prefix in struct's and functions instead of mvsw_pr_
> 
>     2) Original series split into additional patches for Switchdev ethtool support.
> 
>     3) Use major and minor firmware version numbers in the firmware image filename.
> 
>     4) Removed not needed prints.
> 
>     5) Use iopoll API for waiting on register's value in prestera_pci.c
> 
>     6) Use standart approach for describing PCI ID matching section instead of using
>        custom wrappers in prestera_pci.c
> 
>     7) Add RX/TX support in prestera_rxtx.c.
> 
>     8) Rewritten prestera_switchdev.c with following changes:
>        - handle netdev events from prestera.c
> 
>        - use struct prestera_bridge for bridge objects, and get rid of
>          struct prestera_bridge_device which may confuse.
> 
>        - use refcount_t
> 
>     9) Get rid of macro usage for sending fw requests in prestera_hw.c
> 
>     10) Add base_mac setting as module parameter. base_mac is required for
>         generation default port's mac.
> 
> Vadym Kochan (6):
>   net: marvell: prestera: Add driver for Prestera family ASIC devices
>   net: marvell: prestera: Add PCI interface support
>   net: marvell: prestera: Add basic devlink support
>   net: marvell: prestera: Add ethtool interface support
>   net: marvell: prestera: Add Switchdev driver implementation
>   dt-bindings: marvell,prestera: Add description for device-tree
>     bindings
> 
>  .../bindings/net/marvell,prestera.txt         |   34 +
>  drivers/net/ethernet/marvell/Kconfig          |    1 +
>  drivers/net/ethernet/marvell/Makefile         |    1 +
>  drivers/net/ethernet/marvell/prestera/Kconfig |   25 +
>  .../net/ethernet/marvell/prestera/Makefile    |    7 +
>  .../net/ethernet/marvell/prestera/prestera.h  |  209 +++
>  .../marvell/prestera/prestera_devlink.c       |  114 ++
>  .../marvell/prestera/prestera_devlink.h       |   26 +
>  .../ethernet/marvell/prestera/prestera_dsa.c  |  106 ++
>  .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
>  .../marvell/prestera/prestera_ethtool.c       |  759 ++++++++++
>  .../marvell/prestera/prestera_ethtool.h       |   14 +
>  .../ethernet/marvell/prestera/prestera_hw.c   | 1227 ++++++++++++++++
>  .../ethernet/marvell/prestera/prestera_hw.h   |  185 +++
>  .../ethernet/marvell/prestera/prestera_main.c |  665 +++++++++
>  .../ethernet/marvell/prestera/prestera_pci.c  |  778 ++++++++++
>  .../ethernet/marvell/prestera/prestera_rxtx.c |  834 +++++++++++
>  .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
>  .../marvell/prestera/prestera_switchdev.c     | 1289 +++++++++++++++++
>  .../marvell/prestera/prestera_switchdev.h     |   16 +
>  20 files changed, 6348 insertions(+)
>  create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
>  create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
> 
> -- 
> 2.17.1
> 
