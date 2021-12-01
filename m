Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F5B4658D5
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353411AbhLAWH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:07:29 -0500
Received: from mail-eopbgr30095.outbound.protection.outlook.com ([40.107.3.95]:34887
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353257AbhLAWGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:06:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmNGAoFHjV0rH65KdUQykfvBGWYwfwulF2aEtlOwSyDxC6np/K3n0SOCx4QlHjBQvi23SBfYguT/oW45RYMAl5Jz+ySTwkL3UE/sAgqAQkezwCeBHJYYApOiSCQI9W+jtrmjGwcpWj8NelcMnHlx2fMSPmcxeCo7gZ4QDijxVqiE4TtXW89lZV8gNzAHSPqIhaCD9G5/4fcQFwGroeTwSNIabgTbt5EjaCYx9U6Bopt6LBflgL2XPF92NNDML5EppluSgwfT6jTlHKh4l9N7Y7Q2Yl0ot9qYf/YWP5KWoHLRvyzGa3a/7gi/QMEhoK1Y/nkiz+m1H7W0rti96IaxCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MpkP7+6K010kHbEAgEWgIZ210CfNUUHdUCVKLgg4P8=;
 b=KcfyeVoaVFMioxKMQ4zbR2jhxh8wJUKU9IcfN0OWHQ1gTz9XOjTT96u7w5dmgPGagbG2GPF8LsO8u6w2kisXdIqJqO3p2YXUIavuW5noALvSRYbzPpJO7K5rIZyYLmkpi6kMYILIpL3DoVCguiLQPQHAmVl70ZdByIasBXc5wG43D85t/JEiPJorS279UNzFm3+1wiuX+cDPPUssb3TPqUtAZso9bIVzrynTrmWHDWbV+wHQwSDPiZTF6iMlRQqTstReWwt12e7Kbs0ZBm9x9XkZUv+itEcbnla8+Ekg0Wtpd2Es6BzZMCV0+vJgl5h5X7ZnmF2Eaau3q+GwskIFIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MpkP7+6K010kHbEAgEWgIZ210CfNUUHdUCVKLgg4P8=;
 b=UqN61Us0u4Ac/+aZp35/2R4z+zE3xvsdfCOYekSSMFY0CReG9c+hDBfFlscImlDz+fPqSXn3l5ZO8+SwRr1fIRQq5hls5BLSSooD/BBBAJvpzXSipo5MguuSTnaGervkhmZT9oekfhMz68SV11zPxH0lUOoT02PuNYKFH+GoIms=
Received: from DB7PR02CA0019.eurprd02.prod.outlook.com (2603:10a6:10:52::32)
 by AM6PR03MB3799.eurprd03.prod.outlook.com (2603:10a6:20b:17::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 22:03:29 +0000
Received: from DB8EUR06FT032.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:52:cafe::80) by DB7PR02CA0019.outlook.office365.com
 (2603:10a6:10:52::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Wed, 1 Dec 2021 22:03:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd;
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT032.mail.protection.outlook.com (10.233.253.34) with Microsoft SMTP
 Server id 15.20.4755.13 via Frontend Transport; Wed, 1 Dec 2021 22:03:29
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id CF6427C16C8;
        Wed,  1 Dec 2021 23:03:28 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 67A9F2E453F; Wed,  1 Dec 2021 23:03:28 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] can: esd: add support for esd GmbH PCIe/402 CAN interface
Date:   Wed,  1 Dec 2021 23:03:24 +0100
Message-Id: <20211201220328.3079270-1-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: beeeec8d-cdb7-46f4-3f1c-08d9b5166837
X-MS-TrafficTypeDiagnostic: AM6PR03MB3799:
X-Microsoft-Antispam-PRVS: <AM6PR03MB3799FF7895625EDAF965D7E981689@AM6PR03MB3799.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3dpHC/ZzkuLS2pp4RN+QcCU48/CZia5K3nN794e4r6tK2EoIDW6UIpoMZZ8MBMUOMhm0ulFvoIHqnWDb8qfG6gHVkLDqd+8R5QbPGqEs+KKqveODDQDrlEmhbxjdmqmGUAkHa/eRltl/5Pf/g5Et8lkRdhOVqpd4IXws4GgGRNmZ094UeaB+UmEGThYTG6incIzQhy9xUYa/lXCLWdJRBN1y/3iymn8mbj9tSs7/Y7HqM7keoSi9BBgLABj8kQJ594bExqx+HZYEYZR3ooqPiVh/Be4H/SV0G9cCeP6yVZPEZyCpLN3/fkXlAGJwK2fb4Uiczyc3HOKhW0BAVbHEB23qfUi9MpOufx+ZRIdL307xkyJXTcInnxo0TMEOS+gvofJzwf2qsCKfo1oHNi4X5Nr8DXvm9tCMlJab5agXlFT82KaI2l/I5b79vV5betlR52s3SYXLlGgrUR3gIbt+15ME2TF+RKUE6ohzcmu3xePVveD1l+IP57aCgagek4UAUrB6XvJmLzjaETW5JK79+7ucH+zcdJOBog0ne1x3c0mh4Bvr4jUvvUdofEBBpqAMMvu+19n8835JXQdgkVDLbvwnUPvmC8cXGhinN3EBdwbwgqCJvLoVryM584gw6wy6+WpqkLSbLlhW3M+juD0mGHuVP01DyljvwxXb4ctlxjaoZuLCGE821Tv0uHi91Tww2nbC6mmRmUnZsQtXyRC+7129DV/Jyh1jT0NmeThpLVxDjh54lBmHyWGmE0P30fZmUbeUTWWUnghPT6a8hN4+povbIuLMEYnWxi+b/WR+ALfIg4iOP4o3k7r6hN8jf0SQ
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(136003)(346002)(396003)(39830400003)(376002)(36840700001)(46966006)(47076005)(26005)(70206006)(36860700001)(2906002)(83380400001)(5660300002)(81166007)(70586007)(36756003)(40480700001)(6666004)(1076003)(8936002)(336012)(356005)(66574015)(6266002)(316002)(186003)(4326008)(86362001)(8676002)(110136005)(2616005)(966005)(508600001)(42186006)(82310400004);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 22:03:29.0916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: beeeec8d-cdb7-46f4-3f1c-08d9b5166837
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT032.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to introduce a new CAN driver to support
the esd GmbH 402 family of CAN interface boards. The hardware design
is based on a CAN controller implemented in a FPGA attached to a
PCIe link.

More information on these boards can be found following the links
included in the commit message.

This patch supports all boards but will operate the CAN-FD capable
boards only in Classic-CAN mode. The CAN-FD support will be added
when the initial patch has stabilized.

The patch is reuses the previous work of my former colleague:
Link: https://lore.kernel.org/linux-can/1426592308-23817-1-git-send-email-thomas.koerper@esd.eu/

*Note*: scripts/checkpatch.pl still emits the following warnings:
  - esd_402_pci-core.c:270: Possible unnecessary 'out of memory' message
    This error message is there to tell the user that the DMA allocation
    failed and not an allocation for normal kernel memory.
  - esdacc.h:255: The irq_cnt pointer is still declared volatile and
    this has a reason and is explained in detail in the header
    referencing the exception noted in volatile-considered-harmful.rst.

The patch is based on the linux-can-next testing branch.

Changes in v6:
  - Fixed the statistic handling of RX overrun errors and increase 
    net_device_stats::rx_errors instead of net_device_stats::rx_dropped.
  - Added a patch to not increase rx statistics when generating a CAN
    rx error message frame as suggested on the linux-can list.
  - Added a patch to not not increase rx_bytes statistics for RTR frames
    as suggested on the linux-can list.

    The last two patches change the statistics handling from the previous
    style used in other drivers to the newly suggested one.

Changes in v5:
  - Added the initialization for netdev::dev_port as it is implemented
    for another CAN driver. See
    https://lore.kernel.org/linux-can/20211026180553.1953189-1-mailhol.vincent@wanadoo.fr/

Changes in v4:
  - Fixed the build failure on ARCH=arm64 that was found by the Intel
    kernel test robot. See
    https://lore.kernel.org/linux-can/202109120608.7ZbQXkRh-lkp@intel.com/

    Removed error monitoring code that used GCC's built-in compiler
    functions for atomic access (__sync_* functions). GCC versions
    after 9 (tested with "gcc-10 (Ubuntu 10.3.0-1ubuntu1~20.04)")
    don't implement the intrinsic atomic as in-line code but call
    "__aarch64_ldadd4_acq_rel" on arm64. This GCC support function
    is not exported by the kernel and therefore the module build
    post-processing fails.

    Removed that code because the error monitoring never showed a
    problem during the development this year.


Changes in v3:
  - Rework the bus-off restart logic in acc_set_mode() and
    handle_core_msg_errstatechange() to call netif_wake_queue() from the
    error active event.
  - Changed pci402_init_card() to allocate a variable sized array of
    struct acc_core using devm_kcalloc() instead of using a fixed size
    array in struct pci402_card.
  - Changed handle_core_msg_txabort() to release aborted TX frames in
    TX FIFO order.
  - Fixed the acc_close() function to abort all pending TX request in
    esdACC controller.
  - Fixed counting of transmit aborts in handle_core_msg_txabort().
    It is now done like in can_flush_echo_skb().
  - Fixed handle_core_msg_buserr() to create error frames including the
    CAN RX and TX error counters that were missing.
  - Fixed acc_set_bittiming() neither to touch LOM mode setting of
    esdACC controller nor to enter or leave RESET mode.
    The esdACC controller is going active on the CAN bus in acc_open()
    and is going inactive (RESET mode) again in acc_close().
  - Rely on the automatic release of memory fetched by devm_kzalloc().
    But still use devm_irq_free() explicitely to make sure that the
    interrupt handler is disconnected at that point.
    This avoids a possible crash in non-MSI mode due to the IRQ
    triggered by another device on the same PCI IRQ line.
  - Changed to use DMA map API instead of pci_*_consistent compatibility
    wrappers.
  - Fixed stale email references and updated copyright information.
  - Removed any traces of future CAN-FD support.


Changes in v2:
  - Avoid warning triggered by -Wshift-count-overflow on architectures
    with 32-bit dma_addr_t.
  - Fixed Makefile not to build the kernel module always. Doing this
    renamed esd402_pci.c to esd_402_pci-core.c as recommended by Marc.

Stefan Mätje (4):
  MAINTAINERS: add Stefan Mätje as maintainer for the esd electronics
    GmbH CAN drivers
  can: esd: add support for esd GmbH PCIe/402 CAN interface family
  can: esd_402_pci: do not increase rx statistics when generating a CAN
    rx error message frame
  can: esd_402_pci: do not increase rx_bytes statistics for RTR frames

 MAINTAINERS                            |   8 +
 drivers/net/can/Kconfig                |   1 +
 drivers/net/can/Makefile               |   1 +
 drivers/net/can/esd/Kconfig            |  12 +
 drivers/net/can/esd/Makefile           |   7 +
 drivers/net/can/esd/esd_402_pci-core.c | 502 ++++++++++++++++
 drivers/net/can/esd/esdacc.c           | 772 +++++++++++++++++++++++++
 drivers/net/can/esd/esdacc.h           | 380 ++++++++++++
 8 files changed, 1683 insertions(+)
 create mode 100644 drivers/net/can/esd/Kconfig
 create mode 100644 drivers/net/can/esd/Makefile
 create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
 create mode 100644 drivers/net/can/esd/esdacc.c
 create mode 100644 drivers/net/can/esd/esdacc.h


base-commit: f659c5c7de7982018bb961cf1f9960e60f526bdf
-- 
2.25.1

