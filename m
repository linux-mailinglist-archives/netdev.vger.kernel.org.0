Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7839A40E6CC
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 19:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347575AbhIPRZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:25:21 -0400
Received: from mail-am6eur05on2106.outbound.protection.outlook.com ([40.107.22.106]:38464
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348167AbhIPRXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 13:23:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRCJz3CmBW0S/XLTbTta8VAMaXNYqw5ycjqwaBosBWiiPEY6HD6rZ7BfhD+cQttmjgg1DLk66krGkTvYV/qsGxxk7zj8aK2VwjbeBFOd0Q3pao+jWaTh3usgTofc+mFeucyoOtGKWhuw+PkuPK02H5tMokvKA4nzKpGv2LiLWKCng/7PlrsqUkC9uxeBR/fIpSlgrJpJrL9OMnG0j1tad94WaEGbbpYO12Mh6dvR640ZrPrzf0CtZSFt4KpHlZ07Id4o7zLSWg/uQtoszXgZd1nYbgWOPFJuKogOkOfS7gj+QKqk3gAbc96UrrIYaTYysR98/y9SP6zmlyjIVSkpTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aKXReBysgTP8QJZNhRH3aRPtKwEEVu+i2B6o9bzRsGU=;
 b=DpI5Rw/L+7gTAEoe4N6SKOedPenhePzlccGVS+Lsx+tm6xNqUpYsZBQ75KhDEdGEtTkPCZNBRd/dXAb8/5BoZPQfVbC59v+RDbeKoZyK/ZF1CrOQgZ5GHLfm+O+HFwmoiPYELJaLTO8KhFqIiYkM39nogCrMRNLD2JFCZVEGpENFQSdCxEYVsoJG5UWeCVY+oghc27MdMwNfco7DBvdz24Jpp4OACAtTkkJ6dojZBwKe3Hx9WqnouWsiTmrqv4OYk1zRa9Zc8klpBT7xQlDHGTOtL0RTTeNw+H13/ewkDUOiFuqTIwzes8oUr9VLPJUrg7TJqPwNE6Dm2i9z0IF8jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKXReBysgTP8QJZNhRH3aRPtKwEEVu+i2B6o9bzRsGU=;
 b=N93mfu5Hf1XEFIaHn3aV1IWIrGoj5D41ZFJYoC0o/yaunCCIsVgFJfg+B8bnZrYgfwi1kCJKHTNyvx6jI9kHy0N09gz0yGCt6NIHGH/quKLFvUCL0T3Yy52u9ZoFe02g57Mxe6NmfJ5wxifc2sRfLleq5hsVsS40UognrEMAc4I=
Received: from DB6PR0402CA0013.eurprd04.prod.outlook.com (2603:10a6:4:91::23)
 by PA4PR03MB6718.eurprd03.prod.outlook.com (2603:10a6:102:ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Thu, 16 Sep
 2021 17:21:53 +0000
Received: from DB8EUR06FT063.eop-eur06.prod.protection.outlook.com
 (2603:10a6:4:91:cafe::5a) by DB6PR0402CA0013.outlook.office365.com
 (2603:10a6:4:91::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend
 Transport; Thu, 16 Sep 2021 17:21:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=bestguesspass action=none
 header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd;
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT063.mail.protection.outlook.com (10.233.253.111) with Microsoft
 SMTP Server id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021
 17:21:52 +0000
Received: from esd-s9.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id 8DC157C1635;
        Thu, 16 Sep 2021 19:21:52 +0200 (CEST)
Received: by esd-s9.esd.local (Postfix, from userid 2044)
        id 7FD0CE00E4; Thu, 16 Sep 2021 19:21:52 +0200 (CEST)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] can: esd: add support for esd GmbH PCIe/402 CAN interface
Date:   Thu, 16 Sep 2021 19:21:50 +0200
Message-Id: <20210916172152.5127-1-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f95e29d-4e9b-4ea0-c4d9-08d9793679eb
X-MS-TrafficTypeDiagnostic: PA4PR03MB6718:
X-Microsoft-Antispam-PRVS: <PA4PR03MB6718F9BF17CF0F96A56227B381DC9@PA4PR03MB6718.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AdwoLMk5Q0M6W76A9EZqkZBv1+IQevlhJ9oKg/bIzSpt2Y0PNGtzj/lEsa6REfjuNFjBOPm3w190UEIJy8H440A0u+ZIaxgtOycH0z6TkfPb4Ox5C6MGAEixv2s9uoKpHtKHzbbCAYQ6Phj8IcQmfAZEUjopS8i9B0YOqwp0aKF1YwJc9UlcVRf3Bykf5ujkz27HwLt/PRLoKNGiGiV+XlwWIWKJ57Zwt/juQItC4M68jTmZwc4wdH+P5niWTBarivVPHbU+BDEcTZHefpFOZbTgNmgD3jownLKr1TAI4sxrDy74WEYT+xzpB5Tyf8oc9rPXEYumgGk2k2n+oWft+7ZP+J+4Vg/PCe17MtUoVG6zdAitILGS+KUdLiwGR9goeUPGPgmltmbhN5a1A5Xm2xXvQYl//VtcO07MCDDT72oP64kPcn40qHBtg/kxY086sf2snFyCi+hjKWj1E1p453V2nlnbXw17bYjstmP0pxjxlzYLxt5CPAq/T+zl/gSY+NQaFeNmY/HU9jQXWiMOhV6QzQSiui/gz9UVFLb/Knk1k4Nqc/qApX/UCbKPxZZmwMwltYffhklLO0h1cMMHFzHy8l9RRrt0rDaxRc7F0HJ9ngLIPtmA7wYLGMfsixaO05qjraI5vxVbbVevZqtZdBPPGmlV8MkBHCqvu7pRnDXXV+Nfa7M61bSAp0U0eD1UPey5Xa4zzEnMIqEWZQHV8YJP4u3ZP3EDYIRDhMGXCn5BHJpXLno02jlMw+weKUp8bRWJcQMyNfjpswPz991cgzst7ys8cG0W7ShjrJ9YLRU=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(39840400004)(46966006)(36840700001)(81166007)(5660300002)(2616005)(70206006)(36756003)(336012)(966005)(26005)(186003)(83380400001)(70586007)(356005)(1076003)(42186006)(36860700001)(8936002)(86362001)(508600001)(82310400003)(316002)(8676002)(66574015)(2906002)(47076005)(6266002)(4326008)(110136005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 17:21:52.9225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f95e29d-4e9b-4ea0-c4d9-08d9793679eb
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT063.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6718
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
 drivers/net/can/esd/esd_402_pci-core.c | 501 ++++++++++++++++
 drivers/net/can/esd/esdacc.c           | 777 +++++++++++++++++++++++++
 drivers/net/can/esd/esdacc.h           | 380 ++++++++++++
 8 files changed, 1687 insertions(+)
 create mode 100644 drivers/net/can/esd/Kconfig
 create mode 100644 drivers/net/can/esd/Makefile
 create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
 create mode 100644 drivers/net/can/esd/esdacc.c
 create mode 100644 drivers/net/can/esd/esdacc.h


base-commit: cbe8cd7d83e251bff134a57ea4b6378db992ad82
-- 
2.25.1

