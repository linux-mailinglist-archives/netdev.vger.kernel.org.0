Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C59256CB7
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 10:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgH3IAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 04:00:51 -0400
Received: from mail-am6eur05on2108.outbound.protection.outlook.com ([40.107.22.108]:3520
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbgH3IAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 04:00:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oc3WYVdI15k8IObTP7eon9iVBc9LQHt3RJEnpk90siLGIfokq1DpSR0HEDgXbb92NYKglil6fPv83omcBk2JDo21Lfu8PR234G4O8pPG/0E0ZyathObjoU5E0ez/R+0Azn+BGKwAT0aQXR5XZ7xrfytBeVaQGGoTh/nNy6QdG9WH+8Z5P9pMVpwlXK1vCsIBtDdDHwjxeWwMPfGwIQM4cZx9AXgE+KeHSFMK1N5EFs2JpTP5qzv0dmoUELdk1AWlLbZpvc6uv7/0YczOyPGKivS4CVGB2rAwrIswLSQpnAPwP5jxMDIUUlLTNQitOXBzHQCW42AuRco5KCBLHa45Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cw4TVwfTmrFAQpHtVz0jYm6AimWMQJ0jY8bmLKhO16o=;
 b=fR97blnHsFjsH12p1z43wRwTn1i+jDfaHYzNhoL81gtwe0FWkOx82huLoINKq/MEIGiu7oVgioY04s7Co4qSeEVBs05Ctle+YU2oHh6/DLMoKHwyRealpnPkNFappPfcI+OEK5QVPhgjmkWNvoRncJhftcLCsaVTZPHiWiux/ZcNOI8hi6ZkLdjqDCP1NC+YX3/rhc/aCZSgVsSV9eMXEdWwT3vCmdIgyXBaoyWj0ls/lk/Ii0o4CzExIO5zZ0YaBsuOz30sw4UZUgeM0417ZUZke4Pd3m8zIyUd2hlsioCCGjZy5rnnXUX6bH5Q+U4b/9L9YOnqjIrM4/Ugl+o8wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cw4TVwfTmrFAQpHtVz0jYm6AimWMQJ0jY8bmLKhO16o=;
 b=S+7xAEKpYhmmQwfd+2bPAKHBQuP2oD068JAet58zOgfSL2QwElKKAhErk06qET9UTywQHxv+bv9ox82tFTyU2g9wLfwTpbKxAwB44Uvs15lthp3x+h6RmkXdXyNUWqGgKRWV3HAgBCuCxfZPEZECj9PbJUw3FmT1koTz446SRX4=
Authentication-Results: alliedtelesis.co.nz; dkim=none (message not signed)
 header.d=none;alliedtelesis.co.nz; dmarc=none action=none
 header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0491.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.25; Sun, 30 Aug 2020 08:00:43 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3326.025; Sun, 30 Aug 2020
 08:00:42 +0000
Date:   Sun, 30 Aug 2020 11:00:38 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v5 0/6] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200830080038.GB2568@plvision.eu>
References: <20200825122013.2844-1-vadym.kochan@plvision.eu>
 <7da7a1fd-7e11-b83e-67ef-53bc5f095ebd@alliedtelesis.co.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7da7a1fd-7e11-b83e-67ef-53bc5f095ebd@alliedtelesis.co.nz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR08CA0009.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::21) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR08CA0009.eurprd08.prod.outlook.com (2603:10a6:20b:b2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sun, 30 Aug 2020 08:00:41 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e187104-05ec-4eb7-66cf-08d84cbacaee
X-MS-TrafficTypeDiagnostic: HE1P190MB0491:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0491900874EEB7F4995AFFCB95500@HE1P190MB0491.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RM9egLs+qnnsxGSyqjocxBT7U7XxXZurOHUHkNXp5EXLikjBfk/YmL4hBqsvMS1LUQ3ckRcvmAy9eCh1fcqVctB+5kqyf+QuEBEdHxCUQ2Cbiqfbmu2X/KXwDiKJjbCgo0SXi0xWkOviLBP0JgS8F8VcQLSIeKx6+qZWpkcKOXTsb7tutTJK9iUfS/32BvzPhNgrUi37Q8zjp2ZrZ9C+s2/Qv+MoFlPuDKRYd6ofgDO7KXP1LBG2c5+4igoXLCxqH1lsRB5DYOCRiK6NfB9hcSzewuT/uOnRwL8/FU/GZQPIXtnBANq1DoyNTambsSFgDS33p7cqiwK7nioBoYSEXWToom56Nh0g39k+TX1atLhx9KlBWntCmN+enhK9TRpFsBeTC8ogJP1qGNcyXrRqog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(396003)(39830400003)(346002)(366004)(136003)(86362001)(54906003)(6916009)(16526019)(66556008)(66476007)(66946007)(26005)(44832011)(6666004)(83380400001)(478600001)(186003)(2616005)(956004)(53546011)(8936002)(55016002)(8676002)(1076003)(7416002)(8886007)(33656002)(316002)(5660300002)(2906002)(52116002)(36756003)(4326008)(7696005)(333604002)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: PuvVmvFB5REpXYgrg4HX0XyJrzJ7aBsXfdevNlFHuRrld6b0eJtYLmfsgZnYHdxtmxoa5ON4TRlRh3aCl5WoUupeQGt0UVjIIxYzk2a0I+1ZCkvFgB6G97Xue6oObLgFyYW4xvE1c2LdUIKlA99c6LyHcf7qe0jD/96C6C1E4SEqBrvB2nQkz16AD0b69vK2gblEvtrdTMY9SvL1tHMmzpdNZEJcFQQzOiwhFM2AEZOqu7ekdG2Fy0mXg3tSU9ApLdcn8i3rtnnLbw5zs5Hp3bRRXAPrPG9IE76usB/BIabI9NO6qUu6MFTdv7QiHyJOVOGQczdUBw+rZjAAxzgyVwgFvxJrSZ7ua7x6a+rqut/TyLZk/JdBYaRRdlrDqcDqSnO790QXYP7wQVFseivbxs+vAvpI2naC9lLCoPdUbbK8K1NNU2+QNQnPc8ut60Tf27H1xI8zHGNOTvaan1tudWn1vbp1p0fD7uaQ2lm26aLP528KAgPs3pJZtQ4BA1AbnZtuH7FyaGAAKAu79dCLLtfmgSqnro+VfxEsYToYR3/YGz7DK7066flu5o1f2PpNbDCtLCahwMbiwd6JBOxwIVyAeGQT3dJpP8Ht5+iupCaHVxfDUpWVRU6qDH0Ho4QD5vqVzHZoBJcaM2NCcIg/6Q==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e187104-05ec-4eb7-66cf-08d84cbacaee
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2020 08:00:42.6873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqQT3OmDX9pLm7dYKOqnXFvDJ+JAe/yTdA5yZDg3QYE9x0/XOssOdmtBxKZFBjqij8y6AkMnuosjWIcRdk0xXI0hfTN6/p4aV9NTUk8fEWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0491
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

On Wed, Aug 26, 2020 at 04:30:35AM +0000, Chris Packham wrote:
> Hi Vadym,
> 
> On 26/08/20 12:20 am, Vadym Kochan wrote:
> > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > wireless SMB deployment.
> I think there's a typo here or possibly in patch 1. The AC3x family has 
> model numbers 98DX3255, 98DX3256, 98DX3257, 98DX3258, 98DX3259, 
> 98DX3265, 98DX3268. I'm not sure which variant you're specifically 
> targeting but in patch 1 you add the PCI device 0xC804 which corresponds 
> to the 98DX3255.

Looks like I need fix the commit message to refer to hw id which is used
in PCI match table.

> > Prestera Switchdev is a firmware based driver that operates via PCI bus.  The
> > current implementation supports only boards designed for the Marvell Switchdev
> > solution and requires special firmware.
> >
> > This driver implementation includes only L1, basic L2 support, and RX/TX.
> >
> > The core Prestera switching logic is implemented in prestera_main.c, there is
> > an intermediate hw layer between core logic and firmware. It is
> > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > related logic, in future there is a plan to support more devices with
> > different HW related configurations.
> >
> > The following Switchdev features are supported:
> >
> >      - VLAN-aware bridge offloading
> >      - VLAN-unaware bridge offloading
> >      - FDB offloading (learning, ageing)
> >      - Switchport configuration
> >
> > The original firmware image is uploaded to the linux-firmware repository.
> >
> > PATCH v5:
> >      0) add Co-developed tags for people who was involved in development.
> >
> >      1) Make SPDX license as separate comment
> >
> >      2) Change 'u8 *' -> 'void *', It allows to avoid not-needed u8* casting.
> >
> >      3) Remove "," in terminated enum's.
> >
> >      4) Use GENMASK(end, start) where it is applicable in.
> >
> >      5) Remove not-needed 'u8 *' casting.
> >
> >      6) Apply common error-check pattern
> >
> >      7) Use ether_addr_copy instead of memcpy
> >
> >      8) Use define for maximum MAC address range (255)
> >
> >      9) Simplify prestera_port_state_set() in prestera_main.c by
> >         using separate if-blocks for state setting:
> >      
> >          if (is_up) {
> >          ...
> >          } else {
> >          ...
> >          }
> >
> >        which makes logic more understandable.
> >
> >      10) Simplify sdma tx wait logic when checking/updating tx_ring->burst.
> >
> >      11) Remove not-needed packed & aligned attributes
> >
> >      12) Use USEC_PER_MSEC as multiplier when converting ms -> usec on calling
> >          readl_poll_timeout.
> >
> >      13) Simplified some error path handling by simple return error code in.
> >
> >      14) Remove not-needed err assignment in.
> >
> >      15) Use dev_err() in prestera_devlink_register(...).
> >
> >      Patches updated:
> >          [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
> > 	[2] net: marvell: prestera: Add PCI interface support
> >          [3] net: marvell: prestera: Add basic devlink support
> > 	[4] net: marvell: prestera: Add ethtool interface support
> > 	[5] net: marvell: prestera: Add Switchdev driver implementation
> >
> > PATCH v4:
> >      1) Use prestera_ prefix in netdev_ops variable.
> >
> >      2) Kconfig: use 'default PRESTERA' build type for CONFIG_PRESTERA_PCI to be
> >         synced by default with prestera core module.
> >
> >      3) Use memcpy_xxio helpers in prestera_pci.c for IO buffer copying.
> >
> >      4) Generate fw image path via snprintf() instead of macroses.
> >
> >      5) Use pcim_ helpers in prestera_pci.c which simplified the
> >         probe/remove logic.
> >
> >      6) Removed not needed initializations of variables which are used in
> >         readl_poll_xxx() helpers.
> >
> >      7) Fixed few grammar mistakes in patch[2] description.
> >
> >      8) Export only prestera_ethtool_ops struct instead of each
> >         ethtool handler.
> >
> >      9) Add check for prestera_dev_check() in switchdev event handling to
> >         make sure there is no wrong topology.
> >
> >      Patches updated:
> >          [1] net: marvell: prestera: Add driver for Prestera family ASIC devices
> > 	[2] net: marvell: prestera: Add PCI interface support
> > 	[4] net: marvell: prestera: Add ethtool interface support
> > 	[5] net: marvell: prestera: Add Switchdev driver implementation
> >
> > PATCH v3:
> >      1) Simplify __be32 type casting in prestera_dsa.c
> >
> >      2) Added per-patch changelog under "---" line.
> >
> > PATCH v2:
> >      1) Use devlink_port_type_clear()
> >
> >      2) Add _MS prefix to timeout defines.
> >
> >      3) Remove not-needed packed attribute from the firmware ipc structs,
> >         also the firmware image needs to be uploaded too (will do it soon).
> >
> >      4) Introduce prestera_hw_switch_fini(), to be mirrored with init and
> >         do simple validation if the event handlers are unregistered.
> >
> >      5) Use kfree_rcu() for event handler unregistering.
> >
> >      6) Get rid of rcu-list usage when dealing with ports, not needed for
> >         now.
> >
> >      7) Little spelling corrections in the error/info messages.
> >
> >      8) Make pci probe & remove logic mirrored.
> >
> >      9) Get rid of ETH_FCS_LEN in headroom setting, not needed.
> >
> > PATCH:
> >      1) Fixed W=1 warnings
> >
> >      2) Renamed PCI driver name to be more generic "Prestera DX" because
> >         there will be more devices supported.
> >
> >      3) Changed firmware image dir path: marvell/ -> mrvl/prestera/
> >         to be aligned with location in linux-firmware.git (if such
> >         will be accepted).
> >
> > RFC v3:
> >      1) Fix prestera prefix in prestera_rxtx.c
> >
> >      2) Protect concurrent access from multiple ports on multiple CPU system
> >         on tx path by spinlock in prestera_rxtx.c
> >
> >      3) Try to get base mac address from device-tree, otherwise use a random generated one.
> >
> >      4) Move ethtool interface support into separate prestera_ethtool.c file.
> >
> >      5) Add basic devlink support and get rid of physical port naming ops.
> >
> >      6) Add STP support in Switchdev driver.
> >
> >      7) Removed MODULE_AUTHOR
> >
> >      8) Renamed prestera.c -> prestera_main.c, and kernel module to
> >         prestera.ko
> >
> > RFC v2:
> >      1) Use "pestera_" prefix in struct's and functions instead of mvsw_pr_
> >
> >      2) Original series split into additional patches for Switchdev ethtool support.
> >
> >      3) Use major and minor firmware version numbers in the firmware image filename.
> >
> >      4) Removed not needed prints.
> >
> >      5) Use iopoll API for waiting on register's value in prestera_pci.c
> >
> >      6) Use standart approach for describing PCI ID matching section instead of using
> >         custom wrappers in prestera_pci.c
> >
> >      7) Add RX/TX support in prestera_rxtx.c.
> >
> >      8) Rewritten prestera_switchdev.c with following changes:
> >         - handle netdev events from prestera.c
> >
> >         - use struct prestera_bridge for bridge objects, and get rid of
> >           struct prestera_bridge_device which may confuse.
> >
> >         - use refcount_t
> >
> >      9) Get rid of macro usage for sending fw requests in prestera_hw.c
> >
> >      10) Add base_mac setting as module parameter. base_mac is required for
> >          generation default port's mac.
> >
> > Vadym Kochan (6):
> >    net: marvell: prestera: Add driver for Prestera family ASIC devices
> >    net: marvell: prestera: Add PCI interface support
> >    net: marvell: prestera: Add basic devlink support
> >    net: marvell: prestera: Add ethtool interface support
> >    net: marvell: prestera: Add Switchdev driver implementation
> >    dt-bindings: marvell,prestera: Add description for device-tree
> >      bindings
> >
> >   .../bindings/net/marvell,prestera.txt         |   34 +
> >   drivers/net/ethernet/marvell/Kconfig          |    1 +
> >   drivers/net/ethernet/marvell/Makefile         |    1 +
> >   drivers/net/ethernet/marvell/prestera/Kconfig |   25 +
> >   .../net/ethernet/marvell/prestera/Makefile    |    7 +
> >   .../net/ethernet/marvell/prestera/prestera.h  |  208 +++
> >   .../marvell/prestera/prestera_devlink.c       |  114 ++
> >   .../marvell/prestera/prestera_devlink.h       |   26 +
> >   .../ethernet/marvell/prestera/prestera_dsa.c  |  106 ++
> >   .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
> >   .../marvell/prestera/prestera_ethtool.c       |  759 ++++++++++
> >   .../marvell/prestera/prestera_ethtool.h       |   14 +
> >   .../ethernet/marvell/prestera/prestera_hw.c   | 1227 ++++++++++++++++
> >   .../ethernet/marvell/prestera/prestera_hw.h   |  185 +++
> >   .../ethernet/marvell/prestera/prestera_main.c |  646 +++++++++
> >   .../ethernet/marvell/prestera/prestera_pci.c  |  778 ++++++++++
> >   .../ethernet/marvell/prestera/prestera_rxtx.c |  866 +++++++++++
> >   .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
> >   .../marvell/prestera/prestera_switchdev.c     | 1289 +++++++++++++++++
> >   .../marvell/prestera/prestera_switchdev.h     |   16 +
> >   20 files changed, 6360 insertions(+)
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> >   create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
> >
