Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4389F403DD4
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352162AbhIHQry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:47:54 -0400
Received: from mail-eopbgr150133.outbound.protection.outlook.com ([40.107.15.133]:32480
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239629AbhIHQrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 12:47:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoGYHVzBd2+85hsNBdJMWd+pA0KU57e7FR05BPf9vjwChX/kI2Tr79fEj39dLcqTHkuBfwQKHS0bwoetk6HmSY6LN3ctAIkkY2v0s5jQsuN36oXxdPhYfl3CjybVM/YVG9rg+vMMedkSr3svzGzHs16vLKMLzI3zuwXcCg8yUpsNM5294daausdoEFXt2HqPMX24gIhfNEiGEnlYTz2w52DcjzRsBPvhvahdVmvp2r8MGjV+NLTzAVK/yD0nHC8/WgJ6oWhLktACGan6DjscSsWfovLgx4xxVeJZTCccYMjEoKtqGVSkYG0Kx0qip4EuXebjylxlEDoe3nFhR2W5aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=exu4Z9RpkXimEFkfY02JNpiPmybYEFcw1GVEddU8GX4=;
 b=kC1G1G8Z2qOE2GxwcMQCdD55M/uZ4ZcboE7CrOc57kPmpWJio8tD5eP5wV4pCKCINTgOawShRCoQoHqCVZ04fEGIX6IQZVVU9dG+6ki532d7wxfudHsDk3bZyoCdq5GyId5tRxxo1m0ERGt6LDN6Y5xPwwk++4iTbkQ+lGcKbUdfVk+ZYeiP/iFifkEo4DRaLKQEeYBSWe3Nv1nBa9YOjsnpoVM4P8GpyUrZx3Vjw3lNJmRZXGiA7uSp4CFR+3qedcPkNSbaidTx2IoDJmDLVEjG2GiWgUN0Ph5FNCNjOcCXHf226hL57cgJIkV0wD17M+V5648wo1XXdAfhWw8SWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exu4Z9RpkXimEFkfY02JNpiPmybYEFcw1GVEddU8GX4=;
 b=cAAocTo9TYxa0HgFUymjF3OVfJI/fbgrdoJ3OXpyXaNeNjiz93EL+lEol4hIvDb3z7ZoGuPawPsvnGZ+5cqOW5ecRq65zeOFiLe74hYSjCJ0cVIXiJ07nCsXCZHgXcSd9wn/9FqouEKF1QrPL4MencY4078vAMzp4+oUlsAHXeo=
Received: from AM5PR1001CA0068.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::45) by DBAPR03MB6360.eurprd03.prod.outlook.com
 (2603:10a6:10:19e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 8 Sep
 2021 16:46:42 +0000
Received: from AM7EUR06FT066.eop-eur06.prod.protection.outlook.com
 (2603:10a6:206:15:cafe::55) by AM5PR1001CA0068.outlook.office365.com
 (2603:10a6:206:15::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Wed, 8 Sep 2021 16:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=bestguesspass action=none
 header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd;
Received: from esd-s7.esd (81.14.233.218) by
 AM7EUR06FT066.mail.protection.outlook.com (10.233.255.219) with Microsoft
 SMTP Server id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 16:46:40
 +0000
Received: from esd-s9.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id B9E947C1635;
        Wed,  8 Sep 2021 18:46:40 +0200 (CEST)
Received: by esd-s9.esd.local (Postfix, from userid 2044)
        id 9B012E00E4; Wed,  8 Sep 2021 18:46:40 +0200 (CEST)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] can: esd: add support for esd GmbH PCIe/402 CAN interface
Date:   Wed,  8 Sep 2021 18:46:38 +0200
Message-Id: <20210908164640.23243-1-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b7f9788-aaf3-4294-ceed-08d972e83bcc
X-MS-TrafficTypeDiagnostic: DBAPR03MB6360:
X-Microsoft-Antispam-PRVS: <DBAPR03MB636041E5C6F25779115CF9A981D49@DBAPR03MB6360.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kwDa9C7Gz3RXx9FeHuhZE5EluCublF+gsOQ1ytYOyvl75mK/y7LBrE4iRw7MbUZhmkAEggaMjHlRA8F8RJEHw0S3SMhlw5A/k9EEx/KafP5/COQl/v1CAlXhMXzwLlfw8meG1W3mqyz5t6bLpKmdWxkSUptVNQ2NsE+xwd3F/FuJyfd68a6rf5m4YVt/XRFB3sjJ1oQWHAPK5t8kr1DCEpSPLP12llEtigUp2scfROGtTn3iMAFUHMUjnQOYWdEgjWCja1fvO32YLjJV3gjz54Em77+v0M91OXKbAXOPeJC2XdeayaYrlamrZOJ5MWQeLpI3EVEhuxOzZiasfZ7eSI6mMXI0c52Nkh8ZVIj5NzQy8JBh7yuyiNeHlcgpBWeVOEUKynLaV/UIiR1LIYzzcOBT6Q/LJxYZojUda83LBh643UN85NToYJ9JKVfiipJoi+Is2ht8IjEqessGz/YhtMZiHBhdcR5GLD0tRFDPPu8zfF1Yr3KSuUMPa9cgvssnqeHYbaAT9VklUGnxAGQXJ7EL7fVeqSqV6TGVlhf9gUzpKZJVjOCK5bc78G4BrH17aUuYqmPbWjSCFaBx/fsv3hVyFPF3bqeRnWJiulh2rzaDfwgsyriNaxUqftFQlBya0is91wwN9dO2GSr3Hch3oP4dREi9PWCbpigitecrf+jRmwmz6N34J16h+OU++IfeGhttG/KOY8jKb8F4D03xs2nyZ6QMpxFq1Y0TKqoVctNXRkC8oHaL2EC+N+M69S7n6yKlpTaYPebyslcL8IAE9gaAGdwEOoKJv9grIKG/43U=
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(376002)(346002)(396003)(39830400003)(136003)(46966006)(36840700001)(36860700001)(36756003)(4326008)(478600001)(1076003)(70206006)(186003)(70586007)(356005)(110136005)(2616005)(86362001)(81166007)(6266002)(5660300002)(8676002)(82310400003)(966005)(316002)(8936002)(2906002)(42186006)(83380400001)(66574015)(26005)(47076005)(336012);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 16:46:40.9843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7f9788-aaf3-4294-ceed-08d972e83bcc
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR06FT066.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6360
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
  - esd_402_pci-core.c:283: Possible unnecessary 'out of memory' message
    This error message is there to tell the user that the DMA allocation
    failed and not an allocation for normal kernel memory.
  - esdacc.h:255: The irq_cnt pointer is still declared volatile and
    this has a reason and is explained in detail in the header
    referencing the exception noted in volatile-considered-harmful.rst.

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
 drivers/net/can/esd/esd_402_pci-core.c | 514 ++++++++++++++++
 drivers/net/can/esd/esdacc.c           | 777 +++++++++++++++++++++++++
 drivers/net/can/esd/esdacc.h           | 380 ++++++++++++
 8 files changed, 1700 insertions(+)
 create mode 100644 drivers/net/can/esd/Kconfig
 create mode 100644 drivers/net/can/esd/Makefile
 create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
 create mode 100644 drivers/net/can/esd/esdacc.c
 create mode 100644 drivers/net/can/esd/esdacc.h


base-commit: cbe8cd7d83e251bff134a57ea4b6378db992ad82
-- 
2.25.1

