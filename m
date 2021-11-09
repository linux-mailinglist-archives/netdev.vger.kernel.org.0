Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3586F44B0BA
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbhKIP4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:56:18 -0500
Received: from mail-eopbgr70098.outbound.protection.outlook.com ([40.107.7.98]:15942
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235835AbhKIP4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 10:56:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJCa//JUoT/ORZy3mipVG1whi16cQ6V0qn9AoCukQGFd8aP8B0UMK7Uo+G+3oLL9sk3rTQWZGP3ZfKbxTvSYxfS6wzdoMwRmcwDAmE6Azxe7bJEmLrZJJEVzBBcO/PNyGN2U+GHsWgldgCewweXFtRtwI4UD7O04JPUn1emglCa2fgXa7tlRv2CtWF0os9U676uVPjMM4w/Xhp9oNbS/nM2HDt2jQ/V3NSTLpdxN2Qo6Vkr3lOQKq3S4OZmvuJRvQ3082/IuA4u/DQhDZG12WKw2knouqdKMHp8Oc/ILgKDbZbfAtD3B+5NC4QqJ48MwfvzlZd8TlyFK33CiLP6u7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=va9awj+j7aSpQCaReh2ZhCKoU6txCVBLj6W8+uSTOpk=;
 b=dvqLR2One9is2LnipIj1epm0ibHUV9OnLDgaFmZ8OaMjh3Mz6saFgjwseh1YrvA94Va8qwKb5vDd4s7yGDFfesEAEyx1VJxJ/+vZRPBUs+sTrd2eINEWG7BurM6v8DzUJlVVV8hZ3ADztZwjWpIaFGcNkk/Po0Ayb+UQrguBeroeAR09lJ8VWylN7goexN2f3/KpCLax54Dly4B8svulSNobxf0b5AGi2OYWaf22G2pdhKU+aG3CR7tVrYbCNhxleyjmCGAG/xfiKiWFBH0Kk3Dx2CaI5g5Qzy6mnnFAQEH7HF7vU8cabT0n6evYVzwxtAJJeZjnG6AN847QjtYggA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=va9awj+j7aSpQCaReh2ZhCKoU6txCVBLj6W8+uSTOpk=;
 b=Ha+pbzEBoGA++TX4LrGvT6zDdMSn+pghZZdalg2Xl0KCFb2hm4LqfDSyx6RR5EA5ylNdJRnXDQQmxgrKn9DxRgLHFr5r03cKDkgrdNUcFg65Eog83CZeJEplE/hFhhAiUe2KQHuxVEFrDw3/gjxH51OUuAYMJKIGeHb4SyX0p9c=
Received: from AM6P192CA0054.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::31)
 by AM6PR03MB5443.eurprd03.prod.outlook.com (2603:10a6:20b:c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 15:53:26 +0000
Received: from AM7EUR06FT039.eop-eur06.prod.protection.outlook.com
 (2603:10a6:209:82:cafe::f7) by AM6P192CA0054.outlook.office365.com
 (2603:10a6:209:82::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Tue, 9 Nov 2021 15:53:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd;
Received: from esd-s7.esd (81.14.233.218) by
 AM7EUR06FT039.mail.protection.outlook.com (10.233.255.74) with Microsoft SMTP
 Server id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 15:53:26
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 521217C1635;
        Tue,  9 Nov 2021 16:53:26 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 434292E0192; Tue,  9 Nov 2021 16:53:26 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/2] can: esd: add support for esd GmbH PCIe/402 CAN interface
Date:   Tue,  9 Nov 2021 16:53:24 +0100
Message-Id: <20211109155326.2608822-1-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f33e695-f75e-4a92-fbe7-08d9a3991150
X-MS-TrafficTypeDiagnostic: AM6PR03MB5443:
X-Microsoft-Antispam-PRVS: <AM6PR03MB5443456A5E14BCB9404A72C381929@AM6PR03MB5443.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jaapU9JJPZ+Hda7W1yTE+ZUOfr68HAyQYFIEu1M7BYGrnluhY2cyLb/ClP5ZTsHP0mDudYPm+ov5Z5NlTpQSW3bvYMLVciHadbCKU/ZNhZvbs6wrteLoLJluQHnrBj8vfDcxPay3UCDBUhdsHdGAwR1oSrz/O5Csp59kwbn8xM4/yC5jy6lEfNvky7wXnZMaPSdMxeiOL/gnfoH8acUCGTi9L6BcASKVXNXAzMAWkkFV7w0C4rHd/j3ply1PdTlwp5Zad9IQRpmeDr73/jKC88k7oaaDBBWS1oXDpJLJZOj+w9L9KpsJB2sD8cX/n5oFfgCd7LFWyD3RGtGwJg4pYxekJ6vGo2sq5fOArHiOne6vZdBxN2tgEpdnmRv/glaymKnJQFmv1ytcLoJxRTh7yKgJPdJyMmZSfU5nv3G6nInncoEqBXP7xXm44qrc2FtLOibgNt22LXCXVKxOHUr7Hc7PDeqgno3nqSEWiSuLFdPAiobmpS7GZFwr6VYLRpMsnk9BbSieFAHcGtnKZXWOtLYA9ZR3olEL6oID6Rifkk8nCFunH80ckX/XlZMKaJejsT6IfeS3BNjxr32TFYX3jD6Z4/s0hCHnmFm0eRMauKMWvJimfy67cF5BnAbZm6z11azx5qi5Gdz3+A6YpDIaq0KwfysyLM3JPRdK+D2edI8Q5DXf8hmney8obdyjQyJl/dkMvw5zu2vn4OKv6AqASI6X/IwvlSY876KrUkA4wXRc1dDwpP1P5dGSX/zIuOYe0DlRkc85sUj4/qVi18wwa/4LYa3jbdf245yCa4BpKAg=
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(39840400004)(46966006)(36840700001)(83380400001)(8936002)(70206006)(336012)(186003)(2616005)(4326008)(36756003)(70586007)(966005)(1076003)(81166007)(508600001)(8676002)(86362001)(356005)(2906002)(110136005)(316002)(42186006)(5660300002)(66574015)(47076005)(26005)(82310400003)(36860700001)(6266002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 15:53:26.4650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f33e695-f75e-4a92-fbe7-08d9a3991150
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR06FT039.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5443
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

The patch is based on the previous work of my former colleague:
Link: https://lore.kernel.org/linux-can/1426592308-23817-1-git-send-email-thomas.koerper@esd.eu/

*Note*: scripts/checkpatch.pl still emits the following warnings:
  - esd_402_pci-core.c:270: Possible unnecessary 'out of memory' message
    This error message is there to tell the user that the DMA allocation
    failed and not an allocation for normal kernel memory.
  - esdacc.h:255: The irq_cnt pointer is still declared volatile and
    this has a reason and is explained in detail in the header
    referencing the exception noted in volatile-considered-harmful.rst.

@Marc: Since v4 I've had no feedback on this patch proposal. Does this mean
that there are no objections left and the driver now is ready for inclusion
in the 5.16 main line kernel?

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

Stefan Mätje (2):
  MAINTAINERS: add Stefan Mätje as maintainer for the esd electronics
    GmbH CAN drivers
  can: esd: add support for esd GmbH PCIe/402 CAN interface family

 MAINTAINERS                            |   8 +
 drivers/net/can/Kconfig                |   1 +
 drivers/net/can/Makefile               |   1 +
 drivers/net/can/esd/Kconfig            |  12 +
 drivers/net/can/esd/Makefile           |   7 +
 drivers/net/can/esd/esd_402_pci-core.c | 502 ++++++++++++++++
 drivers/net/can/esd/esdacc.c           | 777 +++++++++++++++++++++++++
 drivers/net/can/esd/esdacc.h           | 380 ++++++++++++
 8 files changed, 1688 insertions(+)
 create mode 100644 drivers/net/can/esd/Kconfig
 create mode 100644 drivers/net/can/esd/Makefile
 create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
 create mode 100644 drivers/net/can/esd/esdacc.c
 create mode 100644 drivers/net/can/esd/esdacc.h


base-commit: f659c5c7de7982018bb961cf1f9960e60f526bdf
-- 
2.25.1

