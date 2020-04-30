Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687531C0AEC
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 01:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgD3XVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 19:21:23 -0400
Received: from mail-eopbgr130109.outbound.protection.outlook.com ([40.107.13.109]:36160
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726384AbgD3XVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 19:21:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwakUdd/CY1Vc/YNdUIUx8onDZyelZaqM82yKlg0mHAKHeFpMky/ayo4DEGuWJWltBBDKuzmEWcBaLi63IsfFctGu+ROsS/KSF2JbF2aizxl2anw+XH3E6bsDSNVgkgkOhjiW4Ecol/Ah8ZRsKiwtFeT7CjjWmjjes9cNI5aUrnrMqXC77vEd6d7vNJJTTB5VEqoMGrkqTzc4i7vKXQO+D52RtstznrQ3cgrug5Tf/61+TlvLjscLmAEZ6fxXc8rgrk/x8OQFfX/5OicbPzs+mLzaFslLThWlRVdQ6R9hyrk/cpkairRUhiORaWM/Esvz4+ajudAKKZLEfyyR0x5Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piSK8B47Kxr1L7tXunndAKvyAuBuqgGjfZ9fEzZnjgo=;
 b=BW3BabcxoVeFX8mhRaBsBnrSnNfl2OtvlwjP3e/JlPEkmbjcBj8fztrcXKQllaRXLG52yRaR2XT04fkP6aM36HXxQvDbapW2VrDgkv7LooQnulK9ph2Mvy3l/7ZcEoFoJsCXIuty9ptg+JC055ZB89xGHU4vXEw1mVNZFQOLBllMcjdMUXMs8/2Xn7qKFmIybupHuV9TyalGh2gaziz8N6UnfdGarM7rOiiG9StfwFPkEjqAdMWK8MPZXPsmuR6giSGIeX6yNq5rBmLzz4iCGPD0U9RffNX/vXyAlqBLT396/yjm3CqMEmCZSoFaE14MKNIW7+xaxfkZoTBCuSvbvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piSK8B47Kxr1L7tXunndAKvyAuBuqgGjfZ9fEzZnjgo=;
 b=nBFxEDsiTNRcgcL2WSZyXOcH5Fzan2J5bESSZHVMH6xlbvapjjZKM8M6E7E+TwrEfURFJSt5QH5psTVkKPYUZ5BkpXngoQz4HAhiXllEYYII2DCFAJrf50r4p3CmNdfEel9pZgzMOLPGlsSU9XB8zCmwTerc7BoYhA/9PP5LjIw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from DB6P190MB0390.EURP190.PROD.OUTLOOK.COM (10.175.242.25) by
 DB6P190MB0471.EURP190.PROD.OUTLOOK.COM (10.165.186.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Thu, 30 Apr 2020 23:21:19 +0000
Received: from DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 ([fe80::c59e:e6ed:2bec:94a6]) by DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 ([fe80::c59e:e6ed:2bec:94a6%6]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 23:21:19 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: [RFC next-next v2 0/5] net: marvell: prestera: Add Switchdev driver for Prestera family ASIC device 98DX326x (AC3x)
Date:   Fri,  1 May 2020 02:20:47 +0300
Message-Id: <20200430232052.9016-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0036.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::49) To DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P192CA0036.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 23:21:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7408b52-2b74-4747-791b-08d7ed5d2feb
X-MS-TrafficTypeDiagnostic: DB6P190MB0471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0471996B26ADA0FFFB85064B95AA0@DB6P190MB0471.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Z/0AFir/o5kO8eGJM/jSjCalw29/TRXzCYfD9+1A4H9jrfJTJD14NMWegTn9HnYS/ophROt8wCKRhMJ2u4ejFwR7pNKpUK9pukMEiLBItMtLsrXnk1Bc72U81vgnrO7pZkvIDanOFx+KqO436WH0wWPGtlD6w78D4T6mVBfyn0R4/qIfeSD5qbU1MHu63uZlbHFTENAqfzCE/4rnlGCLO/XH9tMowbzjHRtoixzGADeYIJc6sTiJ/wIk+LedYNkoaQY8B/Rgv7OxguGLcT+2TOR1XUBp0tKUnFaTWJ2edDZ/GJop4HOZvOoj5bEElEIqY30KI4OrEoLc3ectYsH6gox4xgW56laGZgmRviIXLAYjrrQaH7lB96XZm8v5nUKQM67cEWWZsEdtdSTg7L3+a/Y1gCYGFx3cEg88oWsevbJPDCVdyjb7aicZG05ZAOX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0390.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(6512007)(44832011)(54906003)(316002)(6666004)(2906002)(956004)(2616005)(508600001)(4326008)(66476007)(66556008)(66946007)(86362001)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(8676002)(52116002)(1076003)(6916009)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MVVrzvi4eaoaFUSuNtnEJQBaAjnOZ/kreIfTU5N613aT8kA5yhyWI9dHNgBI+x1aDvEckEkSxpzBsgLu++cbmpHcgAqFFkAF2TAZz6+nCYbVGVPe3AyZvtDpQbzrq+8nQpxRE39rua0uT4cKWrc9+PWYxoaHnXM6OJlHL1gI7keli2leqn5m+SvClhVxwL7IztJJJ5mUI6ERGZJjOPqovdVo7xobHjqRe4bPluHuoBW9VPAIkoyu2BVSD+Aj+Z90lhIyu1+1O3jiLRes+VvR/I1aJlDK77pEqMx+dV4kbAL0AKuVSULjhYwR/GKeOA/pIbInYU/B8EHoc/UZwGg3k1h88RVrKt/hJIo/wmqcRkAQHGywWYJUVlYi0U8a8PFYgQasjMn+8eMzC2NEakdZj/IJHXTBJwX0OsrH81s1FHb1dNCdGxADDAG+S4e9TnieonbYy87lk9w7N4SkIwJ69DGZ6FUL1MUQUtLIueTyhzoBrJSN6ZbOblNiZmhABMF2JxPrTiPI5TLOlhyz8/O7t7ZV6JCjfKJRmnbTQ18ujxzrbH/B90CR+/+Z37k8Lab8joC6rOCaZcoTqULXLu1QIHcPdr9wslz/ge08C+asFNoH0+EYDlnX8si640BPvda7uusMStuOVFmeTZ8qf4s4LG0hBGaamI4ruxrD1JbX5HpUkQcZjbHULb6vkphTPooFVZwM6T1GdCqMdyTAFu+OgAFpA9XuyA5BY3FtTP77ArJSjcR3U6gQngfgNkz0Xf7PixoyjFJxoR6zp8CP/7V71qKzWFKJ+AycMtSrnszMr48=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e7408b52-2b74-4747-791b-08d7ed5d2feb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 23:21:18.9915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1nUYXy5hWt3JM2Io0XvAcJHjat8nwOLAi4DWcB8a4DBobDHHkFTqdPEeikraOBNM7H75ewzPzI3f3hOnsljMch9ZYALXddZJGHzRQwwLFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0471
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
wireless SMB deployment.

Prestera Switchdev is a firmware based driver which operates via PCI bus.  The
current implementation supports only boards designed for the Marvell Switchdev
solution and requires special firmware.

This driver implementation includes only L1, basic L2 support, and RX/TX.

The core Prestera switching logic is implemented in prestera.c, there is
an intermediate hw layer between core logic and firmware. It is
implemented in prestera_hw.c, the purpose of it is to encapsulate hw
related logic, in future there is a plan to support more devices with
different HW related configurations.

The following Switchdev features are supported:

    - VLAN-aware bridge offloading
    - VLAN-unaware bridge offloading
    - FDB offloading (learning, ageing)
    - Switchport configuration

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

Vadym Kochan (5):
  net: marvell: prestera: Add driver for Prestera family ASIC devices
  net: marvell: prestera: Add PCI interface support
  net: marvell: prestera: Add ethtool interface support
  net: marvell: prestera: Add Switchdev driver implementation
  dt-bindings: marvell,prestera: Add address mapping for Prestera
    Switchdev PCIe driver

 .../bindings/net/marvell,prestera.txt         |   13 +
 drivers/net/ethernet/marvell/Kconfig          |    1 +
 drivers/net/ethernet/marvell/Makefile         |    1 +
 drivers/net/ethernet/marvell/prestera/Kconfig |   24 +
 .../net/ethernet/marvell/prestera/Makefile    |    6 +
 .../net/ethernet/marvell/prestera/prestera.c  | 1394 +++++++++++++++++
 .../net/ethernet/marvell/prestera/prestera.h  |  200 +++
 .../ethernet/marvell/prestera/prestera_dsa.c  |  134 ++
 .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 1200 ++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  172 ++
 .../ethernet/marvell/prestera/prestera_pci.c  |  829 ++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c |  825 ++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
 .../marvell/prestera/prestera_switchdev.c     | 1176 ++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 16 files changed, 6049 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h

-- 
2.17.1

