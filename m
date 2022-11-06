Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B36561E6F6
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 23:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiKFWmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 17:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiKFWmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 17:42:07 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20123.outbound.protection.outlook.com [40.107.2.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4201FCEF;
        Sun,  6 Nov 2022 14:42:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBQH7lN23x4j3M9xGYbtzv3Ub3rSw/0q6G0nHWPZrC4RWu+WpKfdCpxLXSrFXHhRlB3AyTCF3CsjN+9ee1rW3p4j9Ub6a2pEMdb9jsbJ0UJgXvXq1Z5Yo7abNQsaGdYtIPEhsc3hPUJywC8jtfYQ8kEwS+WTA9Z1ksEZvuDvdBV82keOqFK+CpD14VOYiilLRB0KzeYXYj/Zy0A8shVUQsCV2DrGpqCtTLjB9g7n3Ck1l6/cbYlkACiO14mg9jL0h+r1yftDv9T8gv4fejxf41VhnHf1+RCK/Qr4MlzXBK3tcg7VedoX4VjPBVLjw4g6UvimRvDfIZu+0gLzN9UBsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHYL4mBsvdqzQFMLWgHN72Pk4f+d5hl2swHWonCGJBA=;
 b=aHRVVEZTqYd/9ITDdywGQaFDEtzffVl+DWp1vvH1T8q9jA8b9Vxwm3lMOPz3igMYzUSSiFt+P7jDu95XVej3eReOmkZRbJXwYRXN2fjH147WL3fmggkeKocDO0v7gtL+vNaehfCAZAGCBMzjd9LT6nsqVQJJia1XqW9Opu7T8lWxgyqX7hosTbXOwbyJTGqKvN8b3psWArNfqUfy1prTbVMYeUlIyTPbr+dwXnpwyhZagKvGI82I05dPM9wp0yw72AFWIAgJ7Oje+lx9cVL9R4mzVvGQbS6sFbFnkXBQ/S1QkL9SS9645Yh6PeTCyLx8pk/afqhm3C+bI77OFYv8pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHYL4mBsvdqzQFMLWgHN72Pk4f+d5hl2swHWonCGJBA=;
 b=ueLJNp8PXEHRgpVXKwQ9tfjlj4RqtcX0O/lcRdLgf1okRrfTSikw7qT4qAZwQE01QNKjSwpdchB0FrkzMl08HnjqrZ1SO8tE5CujvDsN/f5PG4goWQkAiyPx246/8QopmFU4AxNFejeHDRuB1fFmiTpePZDxcGqB41unLUvXNZE=
Received: from FR3P281CA0149.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:95::20)
 by DBBPR03MB6730.eurprd03.prod.outlook.com (2603:10a6:10:1f6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Sun, 6 Nov
 2022 22:41:57 +0000
Received: from VI1EUR06FT004.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:95:cafe::af) by FR3P281CA0149.outlook.office365.com
 (2603:10a6:d10:95::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.11 via Frontend
 Transport; Sun, 6 Nov 2022 22:41:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (81.14.233.218) by
 VI1EUR06FT004.mail.protection.outlook.com (10.13.6.111) with Microsoft SMTP
 Server id 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 22:41:56
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 6A1D57C16C5;
        Sun,  6 Nov 2022 23:41:56 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 52BB52F00D9; Sun,  6 Nov 2022 23:41:56 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/2] can: esd: add support for esd GmbH PCIe/402 CAN interface
Date:   Sun,  6 Nov 2022 23:41:54 +0100
Message-Id: <20221106224156.3619334-1-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT004:EE_|DBBPR03MB6730:EE_
X-MS-Office365-Filtering-Correlation-Id: 915f45e2-3c23-4db6-0e91-08dac0481c3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eM4H3iENptKNkt+XhuTAemVGKBmRSimXKabuoprHo4vbjTqA11i8JKinaPqi+SoL0vLu3b2HSb4eOxzwzsuPe/egrHIqDK++Ik9kpwbuIiDLRk+YhdHo/M9UB6TuC2HGAHxDdjNP38A3hwHFaFwCVCTd3TC0z9LI7eWpaM87DUsuqIfRiUdMeWClLsK0Ljy7x3hHpquYIriunV0KxM2tCnAeykXzUw5Jdi56CqHSOvRaojeZiyR+Gt+TX1Xa0JBLM3Pia280wFlC1ECY6RsrA1huTBEyKM1PQno/CtWFPnQZfdCrIU3DOyajvM5wxJVn6LY6tsnfOUllxm2llf2BRDLuweXAr1+9BMtzlzkS9ZDFo5xpH22I43+uohgfYf0+UgNU/X2CdxKSCcWm+0wLg4OQ64aVc2q2YDw22bZuShM8GHKum2/V2sy6WS20FvSH8XcvPYhOQFaBO5Qbmo8oqLSd8FhuHxLQHhh21jEiXZO71i1xd3k3fL+L0F4UbKH7ajevmS/qpau//nMgzB4OiwgDogxSWTCzN7JwYLVEHxRqnNYkgeyimvsIdkEdeAtMeUz4J44YMwq0A11g/37j7QcDFP6MCzEnkYelEexVNZJTz29d6s6LArMDrsjtIS2e+bD9jF/zHZHs3TCIE7NzrEjiensGh1kmSLbOPqJ+/adNujuNbeVbAiFnFKSFEvkzo0w0Qw3CX4JMLPKPu4n5BOumkvOfxzDQMgTrmTRZzs2l9+XO4+GrmbLnVYDKa1UUGAJOY+8lAOwFYqSUZ6nZJhXdEKfo3rvTQRy7RslyOdchd4mM0X0/bzULh2ABhrcPk057MS5eESsvpVuYJEPTXkkFD7XPo12JtvWFetDKkpY=
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(396003)(136003)(346002)(376002)(451199015)(36840700001)(46966006)(336012)(47076005)(66574015)(6266002)(26005)(1076003)(2616005)(53546011)(186003)(36860700001)(83380400001)(30864003)(2906002)(40480700001)(82310400005)(110136005)(316002)(42186006)(478600001)(966005)(41300700001)(5660300002)(8936002)(70586007)(4326008)(8676002)(70206006)(66899015)(36756003)(81166007)(356005)(86362001)(559001)(579004);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 22:41:56.9063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 915f45e2-3c23-4db6-0e91-08dac0481c3b
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT004.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6730
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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


The patch is based on the linux-net-next main branch.

Changes in v7:
  - Numerous changes. Find the quoted email with inline comments about
    changes below after the changes list. Stuff that I don't understand
    and where I have questions is marked with ????.
    Unfortunately I will be AFK till 28th of November.

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

Am Dienstag, den 01.02.2022, 18:25 +0100 schrieb Marc Kleine-Budde:
> On 01.12.2021 23:03:26, Stefan Mätje wrote:
> > This patch adds support for the PCI based PCIe/402 CAN interface family
> > from esd GmbH that is available with various form factors
> > (https://esd.eu/technologie/can/can-und-can-fd-interfaces).
> > 
> > All boards utilize a FPGA based CAN controller solution developed
> > by esd (esdACC). For more information on the esdACC see
> > https://esd.eu/technologie/can/esd-advanced-can-controller-esdacc.
> > 
> > This driver detects all available CAN interface board variants of
> > the family but atm. operates the CAN-FD capable devices in
> > Classic-CAN mode only! A later patch will introduce the CAN-FD
> > functionality in this driver.
> > 
> > Co-developed-by: Thomas Körper <thomas.koerper@esd.eu>
> > Signed-off-by: Thomas Körper <thomas.koerper@esd.eu>
> > Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
> > ---
> >  drivers/net/can/Kconfig                |   1 +
> >  drivers/net/can/Makefile               |   1 +
> >  drivers/net/can/esd/Kconfig            |  12 +
> >  drivers/net/can/esd/Makefile           |   7 +
> >  drivers/net/can/esd/esd_402_pci-core.c | 502 ++++++++++++++++
> >  drivers/net/can/esd/esdacc.c           | 777 +++++++++++++++++++++++++
> >  drivers/net/can/esd/esdacc.h           | 380 ++++++++++++
> >  7 files changed, 1680 insertions(+)
> >  create mode 100644 drivers/net/can/esd/Kconfig
> >  create mode 100644 drivers/net/can/esd/Makefile
> >  create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
> >  create mode 100644 drivers/net/can/esd/esdacc.c
> >  create mode 100644 drivers/net/can/esd/esdacc.h
> > 
> > diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> > index fff259247d52..47cfb6ae0772 100644
> > --- a/drivers/net/can/Kconfig
> > +++ b/drivers/net/can/Kconfig
> > @@ -170,6 +170,7 @@ config PCH_CAN
> >  
> >  source "drivers/net/can/c_can/Kconfig"
> >  source "drivers/net/can/cc770/Kconfig"
> > +source "drivers/net/can/esd/Kconfig"
> >  source "drivers/net/can/ifi_canfd/Kconfig"
> >  source "drivers/net/can/m_can/Kconfig"
> >  source "drivers/net/can/mscan/Kconfig"
> > diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
> > index a2b4463d8480..015b6fc110d1 100644
> > --- a/drivers/net/can/Makefile
> > +++ b/drivers/net/can/Makefile
> > @@ -8,6 +8,7 @@ obj-$(CONFIG_CAN_VXCAN)		+= vxcan.o
> >  obj-$(CONFIG_CAN_SLCAN)		+= slcan.o
> >  
> >  obj-y				+= dev/
> > +obj-y				+= esd/
> >  obj-y				+= rcar/
> >  obj-y				+= spi/
> >  obj-y				+= usb/
> > diff --git a/drivers/net/can/esd/Kconfig b/drivers/net/can/esd/Kconfig
> > new file mode 100644
> > index 000000000000..54bfc366634c
> > --- /dev/null
> > +++ b/drivers/net/can/esd/Kconfig
> > @@ -0,0 +1,12 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +config CAN_ESD_402_PCI
> > +	tristate "esd electronics gmbh CAN-PCI(e)/402 family"
> > +	depends on PCI && HAS_DMA
> > +	help
> > +	  Support for C402 card family from esd electronics gmbh.
> > +	  This card family is based on the ESDACC CAN controller and
> > +	  available in several form factors:  PCI, PCIe, PCIe Mini,
> > +	  M.2 PCIe, CPCIserial, PMC, XMC  (see https://esd.eu/en)
> > +
> > +	  This driver can also be built as a module. In this case the
> > +	  module will be called esd_402_pci.
> > diff --git a/drivers/net/can/esd/Makefile b/drivers/net/can/esd/Makefile
> > new file mode 100644
> > index 000000000000..5dd2d470c286
> > --- /dev/null
> > +++ b/drivers/net/can/esd/Makefile
> > @@ -0,0 +1,7 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +#
> > +#  Makefile for esd gmbh ESDACC controller driver
> > +#
> > +esd_402_pci-objs := esdacc.o esd_402_pci-core.o
> > +
> > +obj-$(CONFIG_CAN_ESD_402_PCI) += esd_402_pci.o
> > diff --git a/drivers/net/can/esd/esd_402_pci-core.c b/drivers/net/can/esd/esd_402_pci-core.c
> > new file mode 100644
> > index 000000000000..80d816a78859
> > --- /dev/null
> > +++ b/drivers/net/can/esd/esd_402_pci-core.c
> > @@ -0,0 +1,502 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (C) 2015 - 2016 Thomas Körper, esd electronic system design gmbh
> > + * Copyright (C) 2017 - 2021 Stefan Mätje, esd electronics gmbh
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/pci.h>
> > +#include <linux/io.h>
> > +#include <linux/delay.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/can.h>
> > +#include <linux/can/dev.h>
> > +#include <linux/can/netlink.h>
> 
> please sort alphabetically

done

> 
> > +
> > +#include "esdacc.h"
> > +
> > +#define DRV_NAME			"esd_402_pci"

There has been some effort on the mailing list to replace hardcoded driver names with KBUILD_MODNAME.
But then this showed up as debateable
(see https://lore.kernel.org/linux-can/YyLkrj5v2EiBIXk+@surfacebook/#r)
How should I proceed with this DRV_NAME (i.e. keep it use KBUILD_MODNAME) which is only used to
set struct pci_driver::name?   ????

> > +
> > +#define ESD_PCI_DEVICE_ID_PCIE402	0x0402
> > +
> > +#define PCI402_FPGA_VER_MIN		0x003d
> > +#define PCI402_MAX_CORES		6
> > +#define PCI402_BAR			0
> > +#define PCI402_IO_OV_OFFS		0
> > +#define PCI402_IO_PCIEP_OFFS		0x10000
> > +#define PCI402_IO_LEN_TOTAL		0x20000
> > +#define PCI402_IO_LEN_CORE		0x2000
> > +#define PCI402_PCICFG_MSICAP_CSR	0x52
> > +#define PCI402_PCICFG_MSICAP_ADDR	0x54
> > +#define PCI402_PCICFG_MSICAP_DATA	0x5c
> > +
> > +#define PCI402_DMA_MASK			DMA_BIT_MASK(32)
> > +#define PCI402_DMA_SIZE			ALIGN(0x10000, PAGE_SIZE)
> > +
> > +#define PCI402_PCIEP_OF_INT_ENABLE	0x0050
> > +#define PCI402_PCIEP_OF_BM_ADDR_LO	0x1000
> > +#define PCI402_PCIEP_OF_BM_ADDR_HI	0x1004
> > +#define PCI402_PCIEP_OF_MSI_ADDR_LO	0x1008
> > +#define PCI402_PCIEP_OF_MSI_ADDR_HI	0x100c
> 
> nitpick: please use single space for indention. Sooner or later new
> stuff is added and the original alignment doesn't fit anymore.

Changed to single space indentation.

> > +
> > +/* The BTR register capabilities described by the can_bittiming_const structures
> > + * below are valid since ESDACC version 0x0032.
> > + */
> > +
> > +/* Used if the ESDACC FPGA is built as CAN-Classic version. */
> > +static const struct can_bittiming_const pci402_bittiming_const = {
> > +	.name = "esd_402",
> > +	.tseg1_min = 1,
> > +	.tseg1_max = 16,
> > +	.tseg2_min = 1,
> > +	.tseg2_max = 8,
> > +	.sjw_max = 4,
> > +	.brp_min = 1,
> > +	.brp_max = 512,
> > +	.brp_inc = 1,
> > +};
> > +
> > +/* Used if the ESDACC FPGA is built as CAN-FD version. */
> > +static const struct can_bittiming_const pci402_bittiming_const_canfd = {
> > +	.name = "esd_402fd",
> > +	.tseg1_min = 1,
> > +	.tseg1_max = 256,
> > +	.tseg2_min = 1,
> > +	.tseg2_max = 128,
> > +	.sjw_max = 128,
> > +	.brp_min = 1,
> > +	.brp_max = 256,
> > +	.brp_inc = 1,
> > +};
> > +
> > +static const struct net_device_ops pci402_acc_netdev_ops = {
> > +	.ndo_open = acc_open,
> > +	.ndo_stop = acc_close,
> > +	.ndo_start_xmit = acc_start_xmit,
> > +	.ndo_change_mtu = can_change_mtu
> > +};
> > +
> > +struct pci402_card {
> > +	/* Actually mapped io space, all other iomem derived from this */
> > +	void __iomem *addr;
> > +	void __iomem *addr_pciep;
> > +
> > +	void *dma_buf;
> > +	dma_addr_t dma_hnd;
> > +
> > +	struct acc_ov ov;
> > +	struct acc_core *cores;
> > +
> > +	bool msi_enabled;
> > +};
> > +
> > +static irqreturn_t pci402_interrupt(int irq, void *dev_id)
> > +{
> > +	struct pci_dev *pdev = dev_id;
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +	irqreturn_t irq_status;
> > +
> > +	irq_status = acc_card_interrupt(&card->ov, card->cores);
> > +
> > +	return irq_status;
> > +}
> > +
> > +static int pci402_set_msiconfig(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +	u32 addr_lo_offs = 0;
> > +	u32 addr_lo = 0;
> > +	u32 addr_hi = 0;
> > +	u32 data = 0;
> > +	u16 csr = 0;
> > +	int err;
> > +
> > +	err = pci_read_config_word(pdev, PCI402_PCICFG_MSICAP_CSR, &csr);
> > +	if (err)
> > +		goto failed;
> > +
> > +	err = pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP_ADDR, &addr_lo);
> > +	if (err)
> > +		goto failed;
> > +	err = pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP_ADDR + 4,
> > +				    &addr_hi);
> > +	if (err)
> > +		goto failed;
> > +
> > +	err = pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP_DATA, &data);
> > +	if (err)
> > +		goto failed;
> > +
> > +	addr_lo_offs = addr_lo & 0x0000ffff;
> > +	addr_lo &= 0xffff0000;
> > +
> > +	if (addr_hi)
> > +		addr_lo |= 1; /* Enable 64-Bit addressing in address space */
> > +
> > +	if (!(csr & 0x0001)) { /* Enable bit */
> > +		err = -EINVAL;
> > +		goto failed;
> > +	}
> > +
> > +	iowrite32(addr_lo, card->addr_pciep + PCI402_PCIEP_OF_MSI_ADDR_LO);
> > +	iowrite32(addr_hi, card->addr_pciep + PCI402_PCIEP_OF_MSI_ADDR_HI);
> > +	acc_ov_write32(&card->ov, ACC_OV_OF_MSI_ADDRESSOFFSET, addr_lo_offs);
> > +	acc_ov_write32(&card->ov, ACC_OV_OF_MSI_DATA, data);
> > +
> > +	return 0;
> > +
> > +failed:
> > +	pci_warn(pdev, "Error while setting MSI configuration:\n"
> > +		 "CSR: 0x%.4x, addr: 0x%.8x%.8x, data: 0x%.8x\n",
> > +		 csr, addr_hi, addr_lo, data);
> > +
> > +	return err;
> > +}

Reworked pci402_set_msiconfig() to use defines from pci.h to access 
MSI capability registers.

> > +
> > +static int pci402_init_card(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +
> > +	card->ov.addr = card->addr + PCI402_IO_OV_OFFS;
> > +	card->addr_pciep = card->addr + PCI402_IO_PCIEP_OFFS;
> > +
> > +	acc_reset_fpga(&card->ov);
> > +	acc_init_ov(&card->ov, &pdev->dev);
> > +
> > +	if (card->ov.version < PCI402_FPGA_VER_MIN) {
> > +		pci_err(pdev,
> > +			"ESDACC version (0x%.4x) outdated, please update\n",
> > +			card->ov.version);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (card->ov.active_cores > PCI402_MAX_CORES) {
> > +		pci_warn(pdev,
> > +			 "Card has more active cores than supported by driver, %u core(s) will be ignored\n",
> > +			 card->ov.active_cores - PCI402_MAX_CORES);
> > +		card->ov.active_cores = PCI402_MAX_CORES;
> 
> Where is that limitation in this driver? PCI402_MAX_CORES is only used here.

Most of the structures are allocated dynamically except the size of the DMA area which is fixed.
I decided now to abort the initialization of the driver with ov.active_cores > PCI402_MAX_CORES
because it can't work properly with so many cores because it would overflow the allocated
DMA memory area. PCI402_MAX_CORES is derived from a hard FPGA limit of the current implementation.

> > +	}
> > +	card->cores = devm_kcalloc(&pdev->dev, card->ov.active_cores,
> > +				   sizeof(struct acc_core), GFP_KERNEL);
> > +	if (!card->cores)
> > +		return -ENOMEM;
> > +
> > +	if (card->ov.features & ACC_OV_REG_FEAT_MASK_CANFD) {
> > +		pci_warn(pdev,
> > +			 "ESDACC with CAN-FD feature detected. This driver doesn't support CAN-FD yet.\n");
> > +	}
> > +
> > +#ifdef __LITTLE_ENDIAN
> > +	/* So card converts all busmastered data to LE for us: */
> > +	acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
> > +			ACC_OV_REG_MODE_MASK_ENDIAN_LITTLE);
> > +#endif
> > +
> > +	return 0;
> > +}
> > +
> > +static int pci402_init_interrupt(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +	int err;
> > +
> > +	err = pci_enable_msi(pdev);
> > +	if (!err) {
> > +		err = pci402_set_msiconfig(pdev);
> > +		if (!err) {
> > +			card->msi_enabled = true;
> > +			acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
> > +					ACC_OV_REG_MODE_MASK_MSI_ENABLE);
> > +			pci_info(pdev, "MSI enabled\n");
> > +		}
> > +	}
> > +
> > +	err = devm_request_irq(&pdev->dev, pdev->irq, pci402_interrupt,
> > +			       IRQF_SHARED, dev_name(&pdev->dev), pdev);
> > +	if (err)
> > +		goto failure_msidis;
> > +
> > +	iowrite32(1, card->addr_pciep + PCI402_PCIEP_OF_INT_ENABLE);
> > +
> > +	return 0;
> > +
> > +failure_msidis:
> > +	if (card->msi_enabled) {
> > +		acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
> > +				  ACC_OV_REG_MODE_MASK_MSI_ENABLE);
> > +		pci_disable_msi(pdev);
> > +		card->msi_enabled = false;
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +static void pci402_finish_interrupt(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +
> > +	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_INT_ENABLE);
> > +	devm_free_irq(&pdev->dev, pdev->irq, pdev);
> 
> A devm manged interrupt gets automatically freed, it makes no sense if
> you free it manually here. I think it's best to use a non devm IRQ
> instead.

The interrupt gets freed here explicitely to avoid problems if we are
running on a shared PCI interrupt (non-MSI) with other interrupt
sources which could trigger the interrupt and then the IRQ handler possibly
could need stuff already deallocated.

When I switched the memory allocation to devm_* allocations I also switched
the IRQ request to a devm_* request to not to mix devm_* resource allocation
with non-devm_* resource allocation.

Should I again use request_irq() / free_irq() pair even in the face of this
imbalance (devm* / non-devm* routines)?     ????

> > +
> > +	if (card->msi_enabled) {
> > +		acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
> > +				  ACC_OV_REG_MODE_MASK_MSI_ENABLE);
> > +		pci_disable_msi(pdev);
> > +		card->msi_enabled = false;
> > +	}
> > +}
> > +
> > +static int pci402_init_dma(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +	int err;
> > +
> > +	err = dma_set_coherent_mask(&pdev->dev, PCI402_DMA_MASK);
> > +	if (err) {
> > +		pci_err(pdev, "DMA set mask failed!\n");
> > +		return err;
> > +	}
> > +
> > +	/* The ESDACC DMA engine needs the DMA buffer aligned to a 64k
> > +	 * boundary. The DMA API guarantees to align the returned buffer to the
> > +	 * smallest PAGE_SIZE order which is greater than or equal to the
> > +	 * requested size. With PCI402_DMA_SIZE == 64kB this suffices here.
> > +	 */
> > +	card->dma_buf = dma_alloc_coherent(&pdev->dev, PCI402_DMA_SIZE,
> > +					   &card->dma_hnd, GFP_ATOMIC);
> 
> Why do you use ATOMIC here?

Originally a pci_alloc_consistent() was used, which in turn uses GFP_ATOMIC. When 
pci_alloc_consistent() was replaced GFP_ATOMIC was inherited without deeper thought.
Since I believe we are able to sleep during the PCI probe routine when the allocation
happens GFP_KERNEL should be ok too. Changed it to GFP_KERNEL.


> > +	if (!card->dma_buf) {
> > +		pci_err(pdev, "DMA alloc failed!\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	acc_init_bm_ptr(&card->ov, card->cores, card->dma_buf);
> > +
> > +	iowrite32((u32)card->dma_hnd,
> > +		  card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_LO);
> 
> cast not needed

Removed.

> 
> > +	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_HI);
> > +
> > +	pci_set_master(pdev);
> > +
> > +	acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
> > +			ACC_OV_REG_MODE_MASK_BM_ENABLE);
> > +
> > +	return 0;
> > +}
> > +
> > +static void pci402_finish_dma(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +	int i;
> > +
> > +	acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
> > +			  ACC_OV_REG_MODE_MASK_BM_ENABLE);
> > +
> > +	pci_clear_master(pdev);
> > +
> > +	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_LO);
> > +	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_HI);
> > +
> > +	card->ov.bmfifo.messages = NULL;
> > +	card->ov.bmfifo.irq_cnt = NULL;
> > +	for (i = 0; i < card->ov.active_cores; i++) {
> > +		struct acc_core *core = &card->cores[i];
> > +
> > +		core->bmfifo.messages = NULL;
> > +		core->bmfifo.irq_cnt = NULL;
> > +	}
> > +
> > +	dma_free_coherent(&pdev->dev, PCI402_DMA_SIZE, card->dma_buf,
> > +			  card->dma_hnd);
> > +	card->dma_buf = NULL;
> > +}
> > +
> > +static int pci402_init_cores(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +	int err;
> > +	int i;
> > +
> > +	for (i = 0; i < card->ov.active_cores; i++) {
> > +		struct acc_core *core = &card->cores[i];
> > +		struct acc_net_priv *priv;
> > +		struct net_device *netdev;
> > +		u32 fifo_config;
> > +
> > +		core->addr = card->ov.addr + (i + 1) * PCI402_IO_LEN_CORE;
> > +
> > +		fifo_config = acc_read32(core, ACC_CORE_OF_TXFIFO_CONFIG);
> > +		core->tx_fifo_size = (u8)(fifo_config >> 24);
> 
> cast not needed.
> 

Removed.

> 
> > +		if (core->tx_fifo_size <= 1) {
> > +			pci_err(pdev, "Invalid tx_fifo_size!\n");
> > +			err = -EINVAL;
> > +			goto failure;
> > +		}
> > +
> > +		netdev = alloc_candev(sizeof(*priv), core->tx_fifo_size);
> > +		if (!netdev) {
> > +			err = -ENOMEM;
> > +			goto failure;
> > +		}
> > +		core->netdev = netdev;
> > +
> > +		netdev->flags |= IFF_ECHO;
> > +		netdev->dev_port = i;
> > +		netdev->netdev_ops = &pci402_acc_netdev_ops;
> > +		SET_NETDEV_DEV(netdev, &pdev->dev);
> > +
> > +		priv = netdev_priv(netdev);
> > +		priv->can.state = CAN_STATE_STOPPED;
> 
> The state is automatically set by alloc_candev().

Removed this assignment.

> > +		priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
> > +			CAN_CTRLMODE_BERR_REPORTING |
> > +			CAN_CTRLMODE_CC_LEN8_DLC |
> > +			CAN_CTRLMODE_LOOPBACK;
> 
> Please sort these by occurrence in can/netlink.h

Sorted.

> > +		priv->can.clock.freq = card->ov.core_frequency;
> > +		priv->can.bittiming_const =
> > +			(card->ov.features & ACC_OV_REG_FEAT_MASK_CANFD) ?
> > +			&pci402_bittiming_const_canfd :
> > +			&pci402_bittiming_const;
> 
> nitpick:
> Please use if (card->ov.features & ACC_OV_REG_FEAT_MASK_CANFD)...else here

Removed the ternary operator and replaced by if else clause.

> > +		priv->can.do_set_bittiming = acc_set_bittiming;
> 
> Please call it directly from the open() callback.

Unchanged till now. Need to revisit later...
Should then the can.do_set_bittiming pointer not be set?	????

> > +		priv->can.do_set_mode = acc_set_mode;
> > +		priv->can.do_get_berr_counter = acc_get_berr_counter;
> > +
> > +		priv->core = core;
> > +		priv->ov = &card->ov;
> > +
> > +		err = register_candev(netdev);
> > +		if (err) {
> > +			free_candev(core->netdev);
> > +			core->netdev = NULL;
> > +			goto failure;
> > +		}
> > +
> > +		netdev_info(netdev, "registered\n");
> > +	}
> > +
> > +	return 0;
> > +
> > +failure:
> > +	for (i--; i >= 0; i--) {
> > +		struct acc_core *core = &card->cores[i];
> > +
> > +		netdev_info(core->netdev, "unregistering...\n");
> > +		unregister_candev(core->netdev);
> > +
> > +		free_candev(core->netdev);
> > +		core->netdev = NULL;
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +static void pci402_finish_cores(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +	int i;
> > +
> > +	for (i = 0; i < card->ov.active_cores; i++) {
> > +		struct acc_core *core = &card->cores[i];
> > +
> > +		netdev_info(core->netdev, "unregister\n");
> > +		unregister_candev(core->netdev);
> > +
> > +		free_candev(core->netdev);
> > +		core->netdev = NULL;
> > +	}
> > +}
> > +
> > +static int pci402_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> > +{
> > +	struct pci402_card *card = NULL;
> > +	int err;
> > +
> > +	err = pci_enable_device(pdev);
> > +	if (err)
> > +		return err;
> > +
> > +	card = devm_kzalloc(&pdev->dev, sizeof(*card), GFP_KERNEL);
> > +	if (!card)
> > +		goto failure_disable_pci;
> > +
> > +	pci_set_drvdata(pdev, card);
> > +
> > +	err = pci_request_regions(pdev, pci_name(pdev));
> > +	if (err)
> > +		goto failure_disable_pci;
> > +
> > +	card->addr = pci_iomap(pdev, PCI402_BAR, PCI402_IO_LEN_TOTAL);
> > +	if (!card->addr) {
> > +		err = -ENOMEM;
> > +		goto failure_release_regions;
> > +	}
> > +
> > +	err = pci402_init_card(pdev);
> > +	if (err)
> > +		goto failure_unmap;
> > +
> > +	err = pci402_init_dma(pdev);
> > +	if (err)
> > +		goto failure_unmap;
> > +
> > +	err = pci402_init_interrupt(pdev);
> > +	if (err)
> > +		goto failure_finish_dma;
> > +
> > +	err = pci402_init_cores(pdev);
> > +	if (err)
> > +		goto failure_finish_interrupt;
> > +
> > +	return 0;
> > +
> > +failure_finish_interrupt:
> > +	pci402_finish_interrupt(pdev);
> > +
> > +failure_finish_dma:
> > +	pci402_finish_dma(pdev);
> > +
> > +failure_unmap:
> > +	pci_iounmap(pdev, card->addr);
> > +
> > +failure_release_regions:
> > +	pci_release_regions(pdev);
> > +
> > +failure_disable_pci:
> > +	pci_disable_device(pdev);
> > +
> > +	return err;
> > +}
> > +
> > +static void pci402_remove(struct pci_dev *pdev)
> > +{
> > +	struct pci402_card *card = pci_get_drvdata(pdev);
> > +
> > +	pci402_finish_interrupt(pdev);
> > +	pci402_finish_cores(pdev);
> > +	pci402_finish_dma(pdev);
> > +	pci_iounmap(pdev, card->addr);
> > +	pci_release_regions(pdev);
> > +	pci_disable_device(pdev);
> > +}
> > +
> > +static const struct pci_device_id pci402_tbl[] = {
> > +	{ PCI_VENDOR_ID_ESDGMBH, ESD_PCI_DEVICE_ID_PCIE402,
> > +	  PCI_VENDOR_ID_ESDGMBH, PCI_ANY_ID,
> > +	  0U, 0U, 0UL },
> > +	{ 0, }
> > +};
> > +MODULE_DEVICE_TABLE(pci, pci402_tbl);
> > +
> > +static struct pci_driver pci402_driver = {
> > +	.name = DRV_NAME,
> > +	.id_table = pci402_tbl,
> > +	.probe = pci402_probe,
> > +	.remove = pci402_remove,
> > +};
> > +
> > +module_pci_driver(pci402_driver);
> > +
> > +MODULE_DESCRIPTION("Socket-CAN driver for esd CAN 402 card family with esdACC core on PCIe");
> > +MODULE_AUTHOR("Thomas Körper <socketcan@esd.eu>");
> > +MODULE_AUTHOR("Stefan Mätje <stefan.maetje@esd.eu>");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/net/can/esd/esdacc.c b/drivers/net/can/esd/esdacc.c
> > new file mode 100644
> > index 000000000000..13f7397dfc4e
> > --- /dev/null
> > +++ b/drivers/net/can/esd/esdacc.c
> > @@ -0,0 +1,777 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (C) 2015 - 2016 Thomas Körper, esd electronic system design gmbh
> > + * Copyright (C) 2017 - 2021 Stefan Mätje, esd electronics gmbh
> > + */
> > +
> > +#include <linux/ktime.h>
> > +#include <linux/gcd.h>
> > +#include <linux/io.h>
> > +#include <linux/delay.h>
> 
> please sort alphabetically

Done

> > +#include "esdacc.h"
> > +
> > +/* ecc value of esdACC equals SJA1000's ECC register */
> > +#define ACC_ECC_SEG			0x1f
> > +#define ACC_ECC_DIR			0x20
> > +#define ACC_ECC_BIT			0x00
> > +#define ACC_ECC_FORM			0x40
> > +#define ACC_ECC_STUFF			0x80
> > +#define ACC_ECC_MASK			0xc0
> > +
> > +#define ACC_BM_IRQ_UNMASK_ALL		0x55555555U
> > +#define ACC_BM_IRQ_MASK_ALL		0xaaaaaaaaU
> > +#define ACC_BM_IRQ_MASK			0x2U
> > +#define ACC_BM_IRQ_UNMASK		0x1U
> > +#define ACC_BM_LENFLAG_TX		0x20
> > +
> > +#define ACC_REG_STATUS_IDX_STATUS_DOS	16
> > +#define ACC_REG_STATUS_IDX_STATUS_ES	17
> > +#define ACC_REG_STATUS_IDX_STATUS_EP	18
> > +#define ACC_REG_STATUS_IDX_STATUS_BS	19
> > +#define ACC_REG_STATUS_IDX_STATUS_RBS	20
> > +#define ACC_REG_STATUS_IDX_STATUS_RS	21
> > +#define ACC_REG_STATUS_MASK_STATUS_DOS	BIT(ACC_REG_STATUS_IDX_STATUS_DOS)
> > +#define ACC_REG_STATUS_MASK_STATUS_ES	BIT(ACC_REG_STATUS_IDX_STATUS_ES)
> > +#define ACC_REG_STATUS_MASK_STATUS_EP	BIT(ACC_REG_STATUS_IDX_STATUS_EP)
> > +#define ACC_REG_STATUS_MASK_STATUS_BS	BIT(ACC_REG_STATUS_IDX_STATUS_BS)
> > +#define ACC_REG_STATUS_MASK_STATUS_RBS	BIT(ACC_REG_STATUS_IDX_STATUS_RBS)
> > +#define ACC_REG_STATUS_MASK_STATUS_RS	BIT(ACC_REG_STATUS_IDX_STATUS_RS)

Should these defines also be reindented using only a single space?	????

> > +
> > +static void acc_resetmode_enter(struct acc_core *core)
> > +{
> > +	int i;
> > +
> > +	acc_set_bits(core, ACC_CORE_OF_CTRL_MODE,
> > +		     ACC_REG_CONTROL_MASK_MODE_RESETMODE);
> > +
> > +	for (i = 0; i < 10; i++) {
> > +		if (acc_resetmode_entered(core))
> > +			return;
> > +
> > +		udelay(5);
> > +	}
> > +
> > +	netdev_warn(core->netdev, "Entering reset mode timed out\n");
> > +}
> > +
> > +static void acc_resetmode_leave(struct acc_core *core)
> > +{
> > +	int i;
> > +
> > +	acc_clear_bits(core, ACC_CORE_OF_CTRL_MODE,
> > +		       ACC_REG_CONTROL_MASK_MODE_RESETMODE);
> > +
> > +	for (i = 0; i < 10; i++) {
> > +		if (!acc_resetmode_entered(core))
> > +			return;
> > +
> > +		udelay(5);
> > +	}
> > +
> > +	netdev_warn(core->netdev, "Leaving reset mode timed out\n");
> > +}

After consultation with the FPGA people the acc_resetmode_enter() and
acc_resetmode_leave() have been reworked. 

Removed the loop that called esdacc_resetmode_entered() multiple times
to check whether the state changed already as commanded. The bit
ACC_REG_CONTROL_MASK_MODE_RESETMODE is flipped unconditionally when we
write the register.

But keep a single acc_resetmode_entered() in these functions to flush
any PCI write posting buffers involved!

Because the ACC_REG_CONTROL_MASK_MODE_RESETMODE bit is changed in any
case after esdacc_resetmode_*() function, we don't need to check for
the state of that bit where these functions are called.

This simplifies the code at the point of the call!

> > +
> > +static void acc_txq_put(struct acc_core *core, u32 acc_id, u8 acc_dlc,
> > +			const void *data)
> > +{
> > +	acc_write32_noswap(core, ACC_CORE_OF_TXFIFO_DATA_1,
> > +			   *((const u32 *)(data + 4)));
> > +	acc_write32_noswap(core, ACC_CORE_OF_TXFIFO_DATA_0,
> > +			   *((const u32 *)data));
> > +	acc_write32(core, ACC_CORE_OF_TXFIFO_DLC, acc_dlc);
> > +	/* CAN id must be written at last. This write starts TX. */
> > +	acc_write32(core, ACC_CORE_OF_TXFIFO_ID, acc_id);
> > +}
> > +
> > +/* Prepare conversion factor from ESDACC time stamp ticks to ns
> > + *
> > + * The conversion factor ts2ns from time stamp counts to ns is basically
> > + *	ts2ns = NSEC_PER_SEC / timestamp_frequency
> > + *
> > + * To avoid an overflow, the ts2ns fraction is truncated with its gcd and
> > + * only the truncated numerator and denominator are used further.
> > + */
> > +static void acc_init_ov_ts2ns(struct acc_ov *ov)
> > +{
> > +	u32 ts2ns_gcd = (u32)gcd(NSEC_PER_SEC, ov->timestamp_frequency);
> > +
> > +	ov->ts2ns_numerator = (u32)NSEC_PER_SEC / ts2ns_gcd;
> > +	ov->ts2ns_denominator = ov->timestamp_frequency / ts2ns_gcd;
> > +}
> 
> Please don't craft your own time conversion functions. please use
> cyclecounter/timercounter instead.
> 
> Have a look at:
> drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c
> 
> > +
> > +static ktime_t acc_ts2ktime(struct acc_ov *ov, u64 ts)
> > +{
> > +	u64 ns;
> > +
> > +	ts = ts * ov->ts2ns_numerator;
> > +	ns = div_u64(ts, ov->ts2ns_denominator);
> > +
> > +	return ns_to_ktime(ns);
> > +}

The time conversion is done here. The esdACC provides a full 64-bit timestamp
with 80MHz resolution. This timestamp will wrap after(!) the kernel time
ktime_t. To convert from 80MHz a multiplication with 12.5 is needed.

See the simplified code in the patch.


> > +
> > +void acc_init_ov(struct acc_ov *ov, struct device *dev)
> > +{
> > +	u32 temp;
> > +	/* For the justification of this see comment on struct acc_bmmsg*
> > +	 * in esdacc.h.
> > +	 */
> > +	BUILD_BUG_ON(sizeof(struct acc_bmmsg) != ACC_CORE_DMAMSG_SIZE);
> > +
> > +	temp = acc_ov_read32(ov, ACC_OV_OF_VERSION);
> > +	ov->version = (u16)temp;
> > +	ov->features = (u16)(temp >> 16);
> 
> casts not needed

Removed

> > +
> > +	temp = acc_ov_read32(ov, ACC_OV_OF_INFO);
> > +	ov->total_cores = (u8)temp;
> > +	ov->active_cores = (u8)(temp >> 8);
> 
> casts not needed

Removed

> > +
> > +	ov->core_frequency = acc_ov_read32(ov, ACC_OV_OF_CANCORE_FREQ);
> > +	ov->timestamp_frequency = acc_ov_read32(ov, ACC_OV_OF_TS_FREQ_LO);
> > +	acc_init_ov_ts2ns(ov);
> > +
> > +	/* Depending on ESDACC feature NEW_PSC enable the new prescaler
> > +	 * or adjust core_frequency according to the implicit division by 2.
> > +	 */
> > +	if (ov->features & ACC_OV_REG_FEAT_MASK_NEW_PSC) {
> > +		acc_ov_set_bits(ov, ACC_OV_OF_MODE,
> > +				ACC_OV_REG_MODE_MASK_NEW_PSC_ENABLE);
> > +	} else {
> > +		ov->core_frequency /= 2;
> > +	}
> > +
> > +	dev_info(dev,
> > +		 "ESDACC v%u, freq: %u/%u, feat/strap: 0x%x/0x%x, cores: %u/%u\n",
> > +		 ov->version, ov->core_frequency, ov->timestamp_frequency,
> > +		 ov->features, acc_ov_read32(ov, ACC_OV_OF_INFO) >> 16,
> > +		 ov->active_cores, ov->total_cores);
> > +	dev_dbg(dev, "ESDACC ts2ns: numerator %u, denominator %u\n",
> > +		ov->ts2ns_numerator, ov->ts2ns_denominator);
> > +}
> > +
> > +void acc_init_bm_ptr(struct acc_ov *ov, struct acc_core *cores, const void *mem)
> > +{
> > +	unsigned int u;
> > +
> > +	/* DMA buffer layout as follows where N is the number of CAN cores
> > +	 * implemented in the FPGA, i.e. N = ov->total_cores
> > +	 *
> > +	 *   Layout                   Section size
> > +	 * +-----------------------+
> > +	 * | FIFO Card/Overview	   |  ACC_CORE_DMABUF_SIZE
> > +	 * |			   |
> > +	 * +-----------------------+
> > +	 * | FIFO Core0		   |  ACC_CORE_DMABUF_SIZE
> > +	 * |			   |
> > +	 * +-----------------------+
> > +	 * | ...		   |  ...
> > +	 * |			   |
> > +	 * +-----------------------+
> > +	 * | FIFO CoreN		   |  ACC_CORE_DMABUF_SIZE
> > +	 * |			   |
> > +	 * +-----------------------+
> > +	 * | irq_cnt Card/Overview |  sizeof(u32)
> > +	 * +-----------------------+
> > +	 * | irq_cnt Core0	   |  sizeof(u32)
> > +	 * +-----------------------+
> > +	 * | ...		   |  ...
> > +	 * +-----------------------+
> > +	 * | irq_cnt CoreN	   |  sizeof(u32)
> > +	 * +-----------------------+
> > +	 */
> > +	ov->bmfifo.messages = mem;
> > +	ov->bmfifo.irq_cnt = mem + (ov->total_cores + 1U) * ACC_CORE_DMABUF_SIZE;
> > +
> > +	for (u = 0U; u < ov->active_cores; u++) {
> > +		struct acc_core *core = &cores[u];
> > +
> > +		core->bmfifo.messages = mem + (u + 1U) * ACC_CORE_DMABUF_SIZE;
> > +		core->bmfifo.irq_cnt = ov->bmfifo.irq_cnt + (u + 1U);
> > +	}
> > +}
> > +
> > +int acc_open(struct net_device *netdev)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(netdev);
> > +	struct acc_core *core = priv->core;
> > +	u32 ctrl_mode;
> > +	int err;
> > +
> > +	/* Retry to enter RESET mode if out of sync. */
> > +	if (priv->can.state != CAN_STATE_STOPPED) {
> > +		netdev_warn(netdev, "Entered %s() with bad can.state: %s\n",
> > +			    __func__, can_get_state_str(priv->can.state));
> > +		acc_resetmode_enter(core);
> > +		if (acc_resetmode_entered(core))
> > +			priv->can.state = CAN_STATE_STOPPED;
> > +	}
> 
> What about always doing a full reset during open().

It's not quite clear to me what you mean with a "full reset" during open.	????

The acc_resetmode_enter() switches the FPGA into a state the is
equivalent to the "reset mode of a SJA1000" i. e. the CAN controller
is off bus and configurable.

But due to the rework of the acc_resetmode_enter() function this code
has been changed. The if(acc_resetmode_entered(core)) vanished because
the core really entered reset-mode after call of
acc_resetmode_enter().

> 
> > +
> > +	err = open_candev(netdev);
> > +	if (err)
> > +		return err;
> > +
> > +	ctrl_mode = ACC_REG_CONTROL_MASK_IE_RXTX |
> > +			ACC_REG_CONTROL_MASK_IE_TXERROR |
> > +			ACC_REG_CONTROL_MASK_IE_ERRWARN |
> > +			ACC_REG_CONTROL_MASK_IE_OVERRUN |
> > +			ACC_REG_CONTROL_MASK_IE_ERRPASS;
> > +
> > +	if (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)
> > +		ctrl_mode |= ACC_REG_CONTROL_MASK_IE_BUSERR;
> > +
> > +	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> > +		ctrl_mode |= ACC_REG_CONTROL_MASK_MODE_LOM;
> > +
> > +	acc_set_bits(core, ACC_CORE_OF_CTRL_MODE, ctrl_mode);
> > +
> > +	acc_resetmode_leave(core);
> > +	if (!acc_resetmode_entered(core))
> > +		priv->can.state = CAN_STATE_ERROR_ACTIVE;
> 
> If the device didn't leave reset mode, then return with an error.

The if(acc_resetmode_entered(core)) vanished because the core really
left reset-mode after call of acc_resetmode_enter().

> 
> > +	/* Resync TX FIFO indices to HW state after (re-)start. */
> > +	{
> > +		u32 tx_fifo_status = acc_read32(core, ACC_CORE_OF_TXFIFO_STATUS);
> > +
> > +		core->tx_fifo_head = tx_fifo_status & 0xff;
> > +		core->tx_fifo_tail = (tx_fifo_status >> 8) & 0xff;
> > +	}
> 
> Why this extra level of indention?

This was only done to introduce the variable tx_fifo_status late in the function.
But the variable declaration is now at the top of the function.


> > +	netif_start_queue(netdev);
> > +	return 0;
> > +}
> > +
> > +int acc_close(struct net_device *netdev)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(netdev);
> > +	struct acc_core *core = priv->core;
> > +
> > +	acc_clear_bits(core, ACC_CORE_OF_CTRL_MODE,
> > +		       ACC_REG_CONTROL_MASK_IE_RXTX |
> > +		       ACC_REG_CONTROL_MASK_IE_TXERROR |
> > +		       ACC_REG_CONTROL_MASK_IE_ERRWARN |
> > +		       ACC_REG_CONTROL_MASK_IE_OVERRUN |
> > +		       ACC_REG_CONTROL_MASK_IE_ERRPASS |
> > +		       ACC_REG_CONTROL_MASK_IE_BUSERR);
> > +
> > +	netif_stop_queue(netdev);
> > +	acc_resetmode_enter(core);
> > +	if (acc_resetmode_entered(core))
> > +		priv->can.state = CAN_STATE_STOPPED;
> 
> Better mark the device as stopped, and make full reset during open()

What do you mean with full reset?    ????

See my comments on acc_resetmode_enter() before. After
acc_resetmode_enter() the device doesn't participate in CAN communication
any more.

The if(acc_resetmode_entered(core)) vanished because the core really
entered reset-mode after call of acc_resetmode_enter().

> 
> > +
> > +	/* Mark pending TX requests to be aborted after controller restart. */
> > +	acc_write32(core, ACC_CORE_OF_TX_ABORT_MASK, 0xffff);
> > +
> > +	/* ACC_REG_CONTROL_MASK_MODE_LOM is only accessible in RESET mode */
> > +	acc_clear_bits(core, ACC_CORE_OF_CTRL_MODE,
> > +		       ACC_REG_CONTROL_MASK_MODE_LOM);
> > +
> > +	close_candev(netdev);
> > +	return 0;
> > +}
> > +
> > +netdev_tx_t acc_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(netdev);
> > +	struct acc_core *core = priv->core;
> > +	struct can_frame *cf = (struct can_frame *)skb->data;
> > +	u8 tx_fifo_head = core->tx_fifo_head;
> > +	int fifo_usage;
> > +	u32 acc_id;
> > +	u8 acc_dlc;
> 
> Please add a check for can_dropped_invalid_skb().

Added like in other drivers.


> > +
> > +	/* Access core->tx_fifo_tail only once because it may be changed
> > +	 * from the interrupt level.
> > +	 */
> > +	fifo_usage = tx_fifo_head - core->tx_fifo_tail;
> > +	if (fifo_usage < 0)
> > +		fifo_usage += core->tx_fifo_size;
> > +
> > +	if (fifo_usage >= core->tx_fifo_size - 1) {
> > +		netdev_err(core->netdev,
> > +			   "BUG: TX ring full when queue awake!\n");
> > +		netif_stop_queue(netdev);
> > +		return NETDEV_TX_BUSY;
> > +	}
> > +
> > +	if (fifo_usage == core->tx_fifo_size - 2)
> > +		netif_stop_queue(netdev);


I need to revisit this later. Not changed yet.


> You need proper memory barriers and double checking: See the mcp251xfd
> driver:
> 
> > netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
> > 				 struct net_device *ndev)
> > {
> > 	struct mcp251xfd_priv *priv = netdev_priv(ndev);
> > 	struct mcp251xfd_tx_ring *tx_ring = priv->tx;
> > 	struct mcp251xfd_tx_obj *tx_obj;
> > 	unsigned int frame_len;
> > 	u8 tx_head;
> > 	int err;
> > 
> > 	if (can_dropped_invalid_skb(ndev, skb))
> > 		return NETDEV_TX_OK;
> > 
> > 	if (mcp251xfd_tx_busy(priv, tx_ring))
> > 		return NETDEV_TX_BUSY;
> 
> The magic happens in mcp251xfd_tx_busy():
> 
> > static bool mcp251xfd_tx_busy(const struct mcp251xfd_priv *priv,
> > 			      struct mcp251xfd_tx_ring *tx_ring)
> > {
> > 	if (mcp251xfd_get_tx_free(tx_ring) > 0)
> > 		return false;
> > 
> > 	netif_stop_queue(priv->ndev);
> > 
> > 	/* Memory barrier before checking tx_free (head and tail) */
> > 	smp_mb();
> > 
> > 	if (mcp251xfd_get_tx_free(tx_ring) == 0) {
> 
> If you need at least 2 free slots, adjust this check.
> 
> > 		netdev_dbg(priv->ndev,
> > 			   "Stopping tx-queue (tx_head=0x%08x, tx_tail=0x%08x, len=%d).\n",
> > 			   tx_ring->head, tx_ring->tail,
> > 			   tx_ring->head - tx_ring->tail);
> > 
> > 		return true;
> > 	}
> > 
> > 	netif_start_queue(priv->ndev);
> > 
> > 	return false;
> > }
> > +
> > +	acc_dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
> > +	if (cf->can_id & CAN_RTR_FLAG)
> > +		acc_dlc |= ACC_CAN_RTR_FLAG;
> > +
> > +	if (cf->can_id & CAN_EFF_FLAG) {
> > +		acc_id = cf->can_id & CAN_EFF_MASK;
> > +		acc_id |= ACC_CAN_EFF_FLAG;
> > +	} else {
> > +		acc_id = cf->can_id & CAN_SFF_MASK;
> > +	}
> > +
> > +	can_put_echo_skb(skb, netdev, core->tx_fifo_head, 0);
> > +
> > +	tx_fifo_head++;
> > +	if (tx_fifo_head >= core->tx_fifo_size)
> > +		tx_fifo_head = 0U;
> > +	core->tx_fifo_head = tx_fifo_head;
> > +
> > +	acc_txq_put(core, acc_id, acc_dlc, cf->data);
> > +
> > +	return NETDEV_TX_OK;
> > +}
> > +
> > +int acc_get_berr_counter(const struct net_device *netdev,
> > +			 struct can_berr_counter *bec)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(netdev);
> > +	u32 core_status = acc_read32(priv->core, ACC_CORE_OF_STATUS);
> > +
> > +	bec->txerr = (core_status >> 8) & 0xff;
> > +	bec->rxerr = core_status & 0xff;
> > +
> > +	return 0;
> > +}
> > +
> > +int acc_set_mode(struct net_device *netdev, enum can_mode mode)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(netdev);
> > +
> > +	switch (mode) {
> > +	case CAN_MODE_START:
> > +		/* Paranoid FIFO index check. */
> > +		{
> > +			const u32 tx_fifo_status =
> > +				acc_read32(priv->core, ACC_CORE_OF_TXFIFO_STATUS);
> > +			const u8 hw_fifo_head = (u8)tx_fifo_status;
> 
> cast not needed

Removed

> > +
> > +			if (hw_fifo_head != priv->core->tx_fifo_head ||
> > +			    hw_fifo_head != priv->core->tx_fifo_tail) {
> > +				netdev_warn(netdev,
> > +					    "TX FIFO mismatch: T %2u H %2u; TFHW %#08x\n",
> > +					    priv->core->tx_fifo_tail,
> > +					    priv->core->tx_fifo_head,
> > +					    tx_fifo_status);
> > +			}
> > +		}
> > +		acc_resetmode_leave(priv->core);
> > +		/* To leave the bus-off state the esdACC controller begins
> > +		 * here a grace period where it counts 128 "idle conditions" (each
> > +		 * of 11 consecutive recessive bits) on the bus as required
> > +		 * by the CAN spec.
> > +		 *
> > +		 * During this time the TX FIFO may still contain already
> > +		 * aborted "zombie" frames that are only drained from the FIFO
> > +		 * at the end of the grace period.
> > +		 *
> > +		 * To not to interfere with this drain process we don't
> > +		 * call netif_wake_queue() here. When the controller reaches
> > +		 * the error-active state again, it informs us about that
> > +		 * with an acc_bmmsg_errstatechange message. Then
> > +		 * netif_wake_queue() is called from
> > +		 * handle_core_msg_errstatechange() instead.
> > +		 */
> > +		break;
> 
> Due 128 idle condition auto recovery it's best to shut down/reset the
> controller on BUS_OFF and re-start it here. It turned out to be less
> complex form the Linux driver point of view and the individual CAN cores
> feel much more consistent: Bus off means bus off and recovery is
> controlled by the kernel.

I don't understand your comment here. Isn't that happening here what you describe?	????

> > +
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int acc_set_bittiming(struct net_device *netdev)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(netdev);
> > +	const struct can_bittiming *bt = &priv->can.bittiming;
> > +	u32 brp = bt->brp - 1;
> > +	u32 btr;
> > +
> > +	if (priv->ov->features & ACC_OV_REG_FEAT_MASK_CANFD) {
> > +		u32 fbtr = 0;
> > +
> > +		netdev_dbg(priv->core->netdev,
> > +			   "bit timing: brp %u, prop %u, ph1 %u ph2 %u, sjw %u\n",
> > +			   bt->brp, bt->prop_seg,
> > +			   bt->phase_seg1, bt->phase_seg2, bt->sjw);
> > +
> > +		/* BRP: 8 bits @ bits 7..0 */
> > +		brp &= 0xff;
> > +
> > +		/* TSEG1: 8 bits @ bits 7..0 */
> > +		btr = (bt->phase_seg1 + bt->prop_seg - 1) & 0xff;
> > +		/* TSEG2: 7 bits @ bits 22..16 */
> > +		btr |= ((bt->phase_seg2 - 1) & 0x7f) << 16;
> > +		/* SJW: 7 bits @ bits 30..24 */
> > +		btr |= ((bt->sjw - 1) & 0x7f) << 24;
> 
> Please make use of FIELD_PREP() here.

Use now FIELD_PREP()

> > +
> > +		/* Keep order of accesses to ACC_CORE_OF_BRP and ACC_CORE_OF_BTR. */
> > +		acc_write32(priv->core, ACC_CORE_OF_BRP, brp);
> > +		acc_write32(priv->core, ACC_CORE_OF_BTR, btr);
> > +
> > +		netdev_info(priv->core->netdev,
> > +			    "ESDACC: BRP %u, NBTR 0x%08x, DBTR 0x%08x",
> > +			    brp, btr, fbtr);
> 
> please make this a netdev_dbg()

Changed it.

> > +	} else {
> > +		netdev_dbg(priv->core->netdev,
> > +			   "bit timing: brp %u, prop %u, ph1 %u ph2 %u, sjw %u\n",
> > +			   bt->brp, bt->prop_seg,
> > +			   bt->phase_seg1, bt->phase_seg2, bt->sjw);
> > +
> > +		/* BRP: 9 bits @ bits 8..0 */
> > +		brp &= 0x1ff;
> > +
> > +		/* TSEG1: 4 bits @ bits 3..0 */
> > +		btr = (bt->phase_seg1 + bt->prop_seg - 1) & 0xf;
> > +		/* TSEG2: 3 bits @ bits 18..16*/
> > +		btr |= ((bt->phase_seg2 - 1) & 0x7) << 16;
> > +		/* SJW: 2 bits @ bits 25..24 */
> > +		btr |= ((bt->sjw - 1) & 0x3) << 24;
> > +
> > +		/* Keep order of accesses to ACC_CORE_OF_BRP and ACC_CORE_OF_BTR. */
> > +		acc_write32(priv->core, ACC_CORE_OF_BRP, brp);
> > +		acc_write32(priv->core, ACC_CORE_OF_BTR, btr);
> > +
> > +		netdev_info(priv->core->netdev, "ESDACC: BRP %u, BTR 0x%08x",
> > +			    brp, btr);
> 
> same here

Changed it.

> 
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void handle_core_msg_rxtxdone(struct acc_core *core,
> > +				     const struct acc_bmmsg_rxtxdone *msg)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(core->netdev);
> > +	struct net_device_stats *stats = &core->netdev->stats;
> > +	struct sk_buff *skb;
> > +
> > +	if (msg->dlc.rxtx.len & ACC_BM_LENFLAG_TX) {
> > +		u8 tx_fifo_tail = core->tx_fifo_tail;
> > +
> > +		if (core->tx_fifo_head == tx_fifo_tail) {
> > +			netdev_warn(core->netdev,
> > +				    "TX interrupt, but queue is empty!?\n");
> > +			return;
> > +		}
> > +
> > +		/* Direct access echo skb to attach HW time stamp. */
> > +		skb = priv->can.echo_skb[tx_fifo_tail];
> > +		if (skb) {
> > +			skb_hwtstamps(skb)->hwtstamp =
> > +				acc_ts2ktime(priv->ov, msg->ts);
> > +		}
> > +
> > +		stats->tx_packets++;
> > +		stats->tx_bytes += can_get_echo_skb(core->netdev, tx_fifo_tail,
> > +						    NULL);
> > +
> > +		tx_fifo_tail++;
> > +		if (tx_fifo_tail >= core->tx_fifo_size)
> > +			tx_fifo_tail = 0U;
> > +		core->tx_fifo_tail = tx_fifo_tail;
> > +
> > +		netif_wake_queue(core->netdev);

I'll revisit this later.

But a side note: Every time we run through this code path there is space
available in any case because we're handling a successful transmit here.

> You only need to wake the queue if there is space available, and you
> need a barrier here, see mcp251xfd_handle_tefif():
> 
> > int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
> > {
> 
> [...]
> > 	if (mcp251xfd_get_tx_free(priv->tx)) {
> > 		/* Make sure that anybody stopping the queue after
> > 		 * this sees the new tx_ring->tail.
> > 		 */
> > 		smp_mb();
> > 		netif_wake_queue(priv->ndev);
> > 	}
> > 
> > 	return 0;
> > 
> > }
> > +
> > +	} else {
> > +		struct can_frame *cf;
> > +
> > +		skb = alloc_can_skb(core->netdev, &cf);
> > +		if (!skb) {
> > +			stats->rx_dropped++;
> > +			return;
> > +		}
> > +
> > +		cf->can_id = msg->id & CAN_EFF_MASK;
> > +		if (msg->id & ACC_CAN_EFF_FLAG)
> > +			cf->can_id |= CAN_EFF_FLAG;
> > +
> > +		can_frame_set_cc_len(cf, msg->dlc.rx.len & ACC_CAN_DLC_MASK,
> > +				     priv->can.ctrlmode);
> > +
> > +		if (msg->dlc.rx.len & ACC_CAN_RTR_FLAG)
> > +			cf->can_id |= CAN_RTR_FLAG;
> > +		else
> > +			memcpy(cf->data, msg->data, cf->len);
> > +
> > +		skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
> > +
> > +		stats->rx_packets++;
> > +		stats->rx_bytes += cf->len;
> > +		netif_rx(skb);
> 
> Consider moving the TX completion and RX handling into NAPI or make use
> of rx-offload, to avoid reordering of CAN frames in the RX path.

rx-offload sounds promising. Could you point me to a driver that is using rx-offload?

> 
> > +	}
> > +}
> > +
> > +static void handle_core_msg_txabort(struct acc_core *core,
> > +				    const struct acc_bmmsg_txabort *msg)
> > +{
> > +	struct net_device_stats *stats = &core->netdev->stats;
> > +	u8 tx_fifo_tail = core->tx_fifo_tail;
> > +	u32 abort_mask = msg->abort_mask;   /* u32 extend to avoid warnings later */
> > +
> > +	/* The abort_mask shows which frames were aborted in ESDACC's FIFO. */
> 
> You can directly iterate over all set bits using for_each_set_bit().

for_each_set_bit() / for_each_set_bit_from() start at bit 1 or a specified
bit but don't wrap around. That would make two loops necessary. Here a
single loop that wraps around till the end of the fifo is found or all
aborted frames have been found looks better to me because it keeps the
right order of the frames when removing them from the ring buffer.

> > +	while (tx_fifo_tail != core->tx_fifo_head && (abort_mask)) {
> > +		const u32 tail_mask = (1U << tx_fifo_tail);
> > +
> > +		if (!(abort_mask & tail_mask))
> > +			break;
> > +		abort_mask &= ~tail_mask;
> > +
> > +		can_free_echo_skb(core->netdev, tx_fifo_tail, NULL);
> > +		stats->tx_dropped++;
> > +		stats->tx_aborted_errors++;
> > +
> > +		tx_fifo_tail++;
> > +		if (tx_fifo_tail >= core->tx_fifo_size)
> > +			tx_fifo_tail = 0;
> > +	}
> > +	core->tx_fifo_tail = tx_fifo_tail;
> > +	if (abort_mask)
> > +		netdev_warn(core->netdev, "Unhandled aborted messages\n");
> > +
> > +	if (!acc_resetmode_entered(core))
> > +		netif_wake_queue(core->netdev);
> > +}
> > +
> > +static void handle_core_msg_overrun(struct acc_core *core,
> > +				    const struct acc_bmmsg_overrun *msg)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(core->netdev);
> > +	struct net_device_stats *stats = &core->netdev->stats;
> > +	struct can_frame *cf;
> > +	struct sk_buff *skb;
> > +
> > +	skb = alloc_can_err_skb(core->netdev, &cf);
> > +	if (!skb) {
> > +		stats->rx_dropped++;
> > +		return;
> > +	}
> 
> Please handle the stats, even if the driver fails to allocate and error
> skb.

Changed as needed.

> > +
> > +	/* lost_cnt may be 0 if not supported by ESDACC version */
> > +	if (msg->lost_cnt) {
> > +		stats->rx_errors += msg->lost_cnt;
> > +		stats->rx_over_errors += msg->lost_cnt;
> > +	} else {
> > +		stats->rx_errors++;
> > +		stats->rx_over_errors++;
> > +	}
> > +
> > +	cf->can_id |= CAN_ERR_CRTL;
> > +	cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
> > +
> > +	skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
> > +
> > +	stats->rx_packets++;
> > +	stats->rx_bytes += cf->len;
> > +	netif_rx(skb);
> > +}
> > +
> > +static void handle_core_msg_buserr(struct acc_core *core,
> > +				   const struct acc_bmmsg_buserr *msg)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(core->netdev);
> > +	struct net_device_stats *stats = &core->netdev->stats;
> > +	struct can_frame *cf;
> > +	struct sk_buff *skb;
> > +	const u32 reg_status = msg->reg_status;
> > +	const u8 rxerr = (u8)reg_status;
> > +	const u8 txerr = (u8)(reg_status >> 8);
> 
> casts not needed

Removed

> > +
> > +	priv->can.can_stats.bus_error++;
> > +
> > +	skb = alloc_can_err_skb(core->netdev, &cf);
> > +	if (!skb) {
> > +		stats->rx_dropped++;
> > +		return;
> > +	}
> 
> Please handle the stats, even if the driver fails to allocate and error
> skb.

Changed as needed.

> > +
> > +	cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
> > +
> > +	/* msg->ecc acts like SJA1000's ECC register */
> > +	switch (msg->ecc & ACC_ECC_MASK) {
> > +	case ACC_ECC_BIT:
> > +		cf->data[2] |= CAN_ERR_PROT_BIT;
> > +		break;
> > +	case ACC_ECC_FORM:
> > +		cf->data[2] |= CAN_ERR_PROT_FORM;
> > +		break;
> > +	case ACC_ECC_STUFF:
> > +		cf->data[2] |= CAN_ERR_PROT_STUFF;
> > +		break;
> > +	default:
> > +		cf->data[2] |= CAN_ERR_PROT_UNSPEC;
> > +		break;
> > +	}
> > +
> > +	/* Set error location */
> > +	cf->data[3] = msg->ecc & ACC_ECC_SEG;
> > +
> > +	/* Error occurred during transmission? */
> > +	if ((msg->ecc & ACC_ECC_DIR) == 0) {
> > +		cf->data[2] |= CAN_ERR_PROT_TX;
> > +		stats->tx_errors++;
> > +	} else {
> > +		stats->rx_errors++;
> > +	}
> > +	/* Insert CAN TX and RX error counters. */
> > +	cf->data[6] = txerr;
> > +	cf->data[7] = rxerr;
> > +
> > +	skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
> > +
> > +	stats->rx_packets++;
> > +	stats->rx_bytes += cf->len;
> > +	netif_rx(skb);
> > +}
> > +
> > +static void
> > +handle_core_msg_errstatechange(struct acc_core *core,
> > +			       const struct acc_bmmsg_errstatechange *msg)
> > +{
> > +	struct acc_net_priv *priv = netdev_priv(core->netdev);
> > +	struct net_device_stats *stats = &core->netdev->stats;
> > +	struct can_frame *cf = NULL;
> > +	struct sk_buff *skb;
> > +	const u32 reg_status = msg->reg_status;
> > +	const u8 rxerr = (u8)reg_status;
> > +	const u8 txerr = (u8)(reg_status >> 8);
> 
> cast not needed

Removed


> > +	enum can_state new_state;
> > +
> > +	if (reg_status & ACC_REG_STATUS_MASK_STATUS_BS) {
> > +		new_state = CAN_STATE_BUS_OFF;
> > +	} else if (reg_status & ACC_REG_STATUS_MASK_STATUS_EP) {
> > +		new_state = CAN_STATE_ERROR_PASSIVE;
> > +	} else if (reg_status & ACC_REG_STATUS_MASK_STATUS_ES) {
> > +		new_state = CAN_STATE_ERROR_WARNING;
> > +	} else {
> > +		new_state = CAN_STATE_ERROR_ACTIVE;
> > +		if (priv->can.state == CAN_STATE_BUS_OFF) {
> > +			/* See comment in acc_set_mode() for CAN_MODE_START */
> > +			netif_wake_queue(core->netdev);
> 
> See my other comment. Shut down the chip in case of bus off.

I don't get it. The esdACC is shut down, if it is in bus-off state.	????


> > +		}
> > +	}
> > +
> > +	skb = alloc_can_err_skb(core->netdev, &cf);
> > +
> > +	if (new_state != priv->can.state) {
> > +		enum can_state tx_state, rx_state;
> > +
> > +		tx_state = (txerr >= rxerr) ?
> > +			new_state : CAN_STATE_ERROR_ACTIVE;
> > +		rx_state = (rxerr >= txerr) ?
> > +			new_state : CAN_STATE_ERROR_ACTIVE;
> > +
> > +		/* Always call can_change_state() to update the state
> > +		 * even if alloc_can_err_skb() may have failed.
> > +		 * can_change_state() can cope with a NULL cf pointer.
> > +		 */
> > +		can_change_state(core->netdev, cf, tx_state, rx_state);
> > +	}
> > +
> > +	if (skb) {
> > +		cf->data[6] = txerr;
> > +		cf->data[7] = rxerr;
> > +
> > +		skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
> > +
> > +		stats->rx_packets++;
> > +		stats->rx_bytes += cf->len;
> > +		netif_rx(skb);
> > +	} else {
> > +		stats->rx_dropped++;
> > +	}
> > +
> > +	if (new_state == CAN_STATE_BUS_OFF) {
> > +		acc_write32(core, ACC_CORE_OF_TX_ABORT_MASK, 0xffff);
> > +		can_bus_off(core->netdev);
> > +	}
> > +}
> > +
> > +static void handle_core_interrupt(struct acc_core *core)
> > +{
> > +	u32 msg_fifo_head = core->bmfifo.local_irq_cnt & 0xff;
> > +
> > +	while (core->bmfifo.msg_fifo_tail != msg_fifo_head) {
> > +		const struct acc_bmmsg *msg =
> > +			&core->bmfifo.messages[core->bmfifo.msg_fifo_tail];
> > +
> > +		switch (msg->u.msg_id) {
> > +		case BM_MSG_ID_RXTXDONE:
> > +			handle_core_msg_rxtxdone(core, &msg->u.rxtxdone);
> > +			break;
> > +
> > +		case BM_MSG_ID_TXABORT:
> > +			handle_core_msg_txabort(core, &msg->u.txabort);
> > +			break;
> > +
> > +		case BM_MSG_ID_OVERRUN:
> > +			handle_core_msg_overrun(core, &msg->u.overrun);
> > +			break;
> > +
> > +		case BM_MSG_ID_BUSERR:
> > +			handle_core_msg_buserr(core, &msg->u.buserr);
> > +			break;
> > +
> > +		case BM_MSG_ID_ERRPASSIVE:
> > +		case BM_MSG_ID_ERRWARN:
> > +			handle_core_msg_errstatechange(core,
> > +						       &msg->u.errstatechange);
> > +			break;
> > +
> > +		default:
> > +			/* Ignore all other BM messages (like the CAN-FD messages) */
> > +			break;
> > +		}
> > +
> > +		core->bmfifo.msg_fifo_tail =
> > +				(core->bmfifo.msg_fifo_tail + 1) & 0xff;
> > +	}
> > +}
> > +


/** 
 * acc_card_interrupt() - handle the interrupts of an esdACC FPGA
 *
 * @ov: overview module structure
 * @cores: array of core structures
 *
 * This function handles all interrupts pending for the overview module and the
 * CAN cores of the esdACC FPGA.
 *
 * It examines for all cores (the overview module core and the CAN cores)
 * the bmfifo.irq_cnt and compares it with the previously saved
 * bmfifo.local_irq_cnt. An IRQ is pending if they differ. The esdACC FPGA
 * updates the bmfifo.irq_cnt values by DMA.
 *
 * The pending interrupts are masked by writing to the IRQ mask register at
 * ACC_OV_OF_BM_IRQ_MASK. This register has for each core a two bit command
 * field evaluated as follows:
 * 
 * Define,   bit pattern: meaning
 *                    00: no action
 * ACC_BM_IRQ_UNMASK, 01: unmask interrupt
 * ACC_BM_IRQ_MASK,   10: mask interrupt
 *                    11: no action
 *
 * For each CAN core with a pending IRQ handle_core_interrupt() handles all
 * busmaster messages from the message FIFO. The last handled message (FIFO
 * index) is written to the CAN core to acknowledge its handling.
 *
 * Last step is to unmask all interrupts in the FPGA using
 * ACC_BM_IRQ_UNMASK_ALL.
 */
> > +irqreturn_t acc_card_interrupt(struct acc_ov *ov, struct acc_core *cores)
> > +{
> > +	u32		irqmask;
> > +	int		i;
> 
> single space here

Changed

> > +
> > +	/* First we look for whom interrupts are pending, card/overview
> > +	 * or any of the cores. Two bits in irqmask are used for each;
> > +	 * set to ACC_BM_IRQ_MASK then:
> > +	 */
> 
> Please explain a bit more detailed how the interrupt handling works.

I added a doxygen like documentation comment to this function (see before).

> > +	irqmask = 0;
> > +	if (*ov->bmfifo.irq_cnt != ov->bmfifo.local_irq_cnt) {
> > +		irqmask |= ACC_BM_IRQ_MASK;
> > +		ov->bmfifo.local_irq_cnt = *ov->bmfifo.irq_cnt;
> > +	}
> > +
> > +	for (i = 0; i < ov->active_cores; i++) {
> > +		struct acc_core *core = &cores[i];
> > +
> > +		if (*core->bmfifo.irq_cnt != core->bmfifo.local_irq_cnt) {
> > +			irqmask |= (ACC_BM_IRQ_MASK << (2 * (i + 1)));
> > +			core->bmfifo.local_irq_cnt = *core->bmfifo.irq_cnt;
> > +		}
> > +	}
> > +
> > +	if (!irqmask)
> > +		return IRQ_NONE;
> > +
> > +	/* At second we tell the card we're working on them by writing irqmask,
> > +	 * call handle_{ov|core}_interrupt and then acknowledge the
> > +	 * interrupts by writing irq_cnt:
> > +	 */
> > +	acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_MASK, irqmask);
> > +
> > +	if (irqmask & ACC_BM_IRQ_MASK) {
> > +		/* handle_ov_interrupt(); - no use yet. */
> > +		acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_COUNTER,
> > +			       ov->bmfifo.local_irq_cnt);
> > +	}
> > +
> > +	for (i = 0; i < ov->active_cores; i++) {
> > +		struct acc_core *core = &cores[i];
> > +
> > +		if (irqmask & (ACC_BM_IRQ_MASK << (2 * (i + 1)))) {
> > +			handle_core_interrupt(core);
> > +			acc_write32(core, ACC_OV_OF_BM_IRQ_COUNTER,
> > +				    core->bmfifo.local_irq_cnt);
> > +		}
> > +	}
> > +
> > +	acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_MASK, ACC_BM_IRQ_UNMASK_ALL);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > diff --git a/drivers/net/can/esd/esdacc.h b/drivers/net/can/esd/esdacc.h
> > new file mode 100644
> > index 000000000000..3e865ececb3e
> > --- /dev/null
> > +++ b/drivers/net/can/esd/esdacc.h
> > @@ -0,0 +1,380 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/* Copyright (C) 2015 - 2016 Thomas Körper, esd electronic system design gmbh
> > + * Copyright (C) 2017 - 2021 Stefan Mätje, esd electronics gmbh
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/can/dev.h>
> > +
> > +#define ACC_CAN_EFF_FLAG			0x20000000
> > +#define ACC_CAN_RTR_FLAG			0x10
> > +#define ACC_CAN_DLC_MASK			0x0f
> > +
> > +#define ACC_OV_OF_PROBE				0x0000
> > +#define ACC_OV_OF_VERSION			0x0004
> > +#define ACC_OV_OF_INFO				0x0008
> > +#define ACC_OV_OF_CANCORE_FREQ			0x000c
> > +#define ACC_OV_OF_TS_FREQ_LO			0x0010
> > +#define ACC_OV_OF_TS_FREQ_HI			0x0014
> > +#define ACC_OV_OF_IRQ_STATUS_CORES		0x0018
> > +#define ACC_OV_OF_TS_CURR_LO			0x001c
> > +#define ACC_OV_OF_TS_CURR_HI			0x0020
> > +#define ACC_OV_OF_IRQ_STATUS			0x0028
> > +#define ACC_OV_OF_MODE				0x002c
> > +#define ACC_OV_OF_BM_IRQ_COUNTER		0x0070
> > +#define ACC_OV_OF_BM_IRQ_MASK			0x0074
> > +#define ACC_OV_OF_MSI_DATA			0x0080
> > +#define ACC_OV_OF_MSI_ADDRESSOFFSET		0x0084
> > +
> > +/* Feature flags are contained in the upper 16 bit of the version
> > + * register at ACC_OV_OF_VERSION but only used with these masks after
> > + * extraction into an extra variable => (xx - 16).
> > + */
> > +#define ACC_OV_REG_FEAT_IDX_CANFD		(27 - 16)
> > +#define ACC_OV_REG_FEAT_IDX_NEW_PSC		(28 - 16)
> > +#define ACC_OV_REG_FEAT_MASK_CANFD		BIT(ACC_OV_REG_FEAT_IDX_CANFD)
> > +#define ACC_OV_REG_FEAT_MASK_NEW_PSC		BIT(ACC_OV_REG_FEAT_IDX_NEW_PSC)
> > +
> > +#define ACC_OV_REG_MODE_MASK_ENDIAN_LITTLE	0x00000001
> > +#define ACC_OV_REG_MODE_MASK_BM_ENABLE		0x00000002
> > +#define ACC_OV_REG_MODE_MASK_MODE_LED		0x00000004
> > +#define ACC_OV_REG_MODE_MASK_TIMER		0x00000070
> > +#define ACC_OV_REG_MODE_MASK_TIMER_ENABLE	0x00000010
> > +#define ACC_OV_REG_MODE_MASK_TIMER_ONE_SHOT	0x00000020
> > +#define ACC_OV_REG_MODE_MASK_TIMER_ABSOLUTE	0x00000040
> > +#define ACC_OV_REG_MODE_MASK_TS_SRC		0x00000180
> > +#define ACC_OV_REG_MODE_MASK_I2C_ENABLE		0x00000800
> > +#define ACC_OV_REG_MODE_MASK_MSI_ENABLE		0x00004000
> > +#define ACC_OV_REG_MODE_MASK_NEW_PSC_ENABLE	0x00008000
> > +#define ACC_OV_REG_MODE_MASK_FPGA_RESET		0x80000000
> > +
> > +#define ACC_CORE_OF_CTRL_MODE			0x0000
> > +#define ACC_CORE_OF_STATUS_IRQ			0x0008
> > +#define ACC_CORE_OF_BRP				0x000c
> > +#define ACC_CORE_OF_BTR				0x0010
> > +#define ACC_CORE_OF_FBTR			0x0014
> > +#define ACC_CORE_OF_STATUS			0x0030
> > +#define ACC_CORE_OF_TXFIFO_CONFIG		0x0048
> > +#define ACC_CORE_OF_TXFIFO_STATUS		0x004c
> > +#define ACC_CORE_OF_TX_STATUS_IRQ		0x0050
> > +#define ACC_CORE_OF_TX_ABORT_MASK		0x0054
> > +#define ACC_CORE_OF_BM_IRQ_COUNTER		0x0070
> > +#define ACC_CORE_OF_TXFIFO_ID			0x00c0
> > +#define ACC_CORE_OF_TXFIFO_DLC			0x00c4
> > +#define ACC_CORE_OF_TXFIFO_DATA_0		0x00c8
> > +#define ACC_CORE_OF_TXFIFO_DATA_1		0x00cc
> > +
> > +#define ACC_REG_CONTROL_IDX_MODE_RESETMODE	0
> > +#define ACC_REG_CONTROL_IDX_MODE_LOM		1
> > +#define ACC_REG_CONTROL_IDX_MODE_STM		2
> > +#define ACC_REG_CONTROL_IDX_MODE_TRANSEN	5
> > +#define ACC_REG_CONTROL_IDX_MODE_TS		6
> > +#define ACC_REG_CONTROL_IDX_MODE_SCHEDULE	7
> > +#define ACC_REG_CONTROL_MASK_MODE_RESETMODE	\
> > +				BIT(ACC_REG_CONTROL_IDX_MODE_RESETMODE)
> > +#define ACC_REG_CONTROL_MASK_MODE_LOM		\
> > +				BIT(ACC_REG_CONTROL_IDX_MODE_LOM)
> > +#define ACC_REG_CONTROL_MASK_MODE_STM		\
> > +				BIT(ACC_REG_CONTROL_IDX_MODE_STM)
> > +#define ACC_REG_CONTROL_MASK_MODE_TRANSEN	\
> > +				BIT(ACC_REG_CONTROL_IDX_MODE_TRANSEN)
> > +#define ACC_REG_CONTROL_MASK_MODE_TS		\
> > +				BIT(ACC_REG_CONTROL_IDX_MODE_TS)
> > +#define ACC_REG_CONTROL_MASK_MODE_SCHEDULE	\
> > +				BIT(ACC_REG_CONTROL_IDX_MODE_SCHEDULE)
> > +
> > +#define ACC_REG_CONTROL_IDX_IE_RXTX	8
> > +#define ACC_REG_CONTROL_IDX_IE_TXERROR	9
> > +#define ACC_REG_CONTROL_IDX_IE_ERRWARN	10
> > +#define ACC_REG_CONTROL_IDX_IE_OVERRUN	11
> > +#define ACC_REG_CONTROL_IDX_IE_TSI	12
> > +#define ACC_REG_CONTROL_IDX_IE_ERRPASS	13
> > +#define ACC_REG_CONTROL_IDX_IE_BUSERR	15
> > +#define ACC_REG_CONTROL_MASK_IE_RXTX	BIT(ACC_REG_CONTROL_IDX_IE_RXTX)
> > +#define ACC_REG_CONTROL_MASK_IE_TXERROR BIT(ACC_REG_CONTROL_IDX_IE_TXERROR)
> > +#define ACC_REG_CONTROL_MASK_IE_ERRWARN BIT(ACC_REG_CONTROL_IDX_IE_ERRWARN)
> > +#define ACC_REG_CONTROL_MASK_IE_OVERRUN BIT(ACC_REG_CONTROL_IDX_IE_OVERRUN)
> > +#define ACC_REG_CONTROL_MASK_IE_TSI	BIT(ACC_REG_CONTROL_IDX_IE_TSI)
> > +#define ACC_REG_CONTROL_MASK_IE_ERRPASS BIT(ACC_REG_CONTROL_IDX_IE_ERRPASS)
> > +#define ACC_REG_CONTROL_MASK_IE_BUSERR	BIT(ACC_REG_CONTROL_IDX_IE_BUSERR)
> > +
> > +/* 256 BM_MSGs of 32 byte size */
> > +#define ACC_CORE_DMAMSG_SIZE		32U
> > +#define ACC_CORE_DMABUF_SIZE		(256U * ACC_CORE_DMAMSG_SIZE)
> > +
> > +enum acc_bmmsg_id {
> > +	BM_MSG_ID_RXTXDONE = 0x01,
> > +	BM_MSG_ID_TXABORT = 0x02,
> > +	BM_MSG_ID_OVERRUN = 0x03,
> > +	BM_MSG_ID_BUSERR = 0x04,
> > +	BM_MSG_ID_ERRPASSIVE = 0x05,
> > +	BM_MSG_ID_ERRWARN = 0x06,
> > +	BM_MSG_ID_TIMESLICE = 0x07,
> > +	BM_MSG_ID_HWTIMER = 0x08,
> > +	BM_MSG_ID_HOTPLUG = 0x09,
> > +};
> > +
> > +/* The struct acc_bmmsg* structure declarations that follow here provide
> > + * access to the ring buffer of bus master messages maintained by the FPGA
> > + * bus master engine. All bus master messages have the same size of
> > + * ACC_CORE_DMAMSG_SIZE and a minimum alignment of ACC_CORE_DMAMSG_SIZE in
> > + * memory.
> > + *
> > + * All structure members are natural aligned. Therefore we should not need
> > + * a __packed attribute. All struct acc_bmmsg* declarations have at least
> > + * reserved* members to fill the structure to the full ACC_CORE_DMAMSG_SIZE.
> > + *
> > + * A failure of this property due padding will be detected at compile time
> > + * by BUILD_BUG_ON(sizeof(struct acc_bmmsg) != ACC_CORE_DMAMSG_SIZE)
> > + */
> 
> You can use static_assert() directly unter the definition of the struct.

Have changed it to use static_assert().

> > +
> > +struct acc_bmmsg_rxtxdone {
> > +	u8 msg_id;
> > +	u8 txfifo_level;
> > +	u8 reserved1[2];
> > +	u8 txtsfifo_level;
> > +	u8 reserved2[3];
> > +	u32 id;
> > +	union {
> > +		struct {
> > +			u8 len;
> > +			u8 reserved0;
> > +			u8 bits;
> > +			u8 state;
> > +		} rxtx;
> > +		struct {
> > +			u8 len;
> > +			u8 msg_lost;
> > +			u8 bits;
> > +			u8 state;
> > +		} rx;
> > +		struct {
> > +			u8 len;
> > +			u8 txfifo_idx;
> > +			u8 bits;
> > +			u8 state;
> > +		} tx;
> > +	} dlc;
> > +	u8 data[8];
> > +	/* Time stamps in struct acc_ov::timestamp_frequency ticks. */
> > +	u64 ts;
> > +};
> > +
> > +struct acc_bmmsg_txabort {
> > +	u8 msg_id;
> > +	u8 txfifo_level;
> > +	u16 abort_mask;
> > +	u8 txtsfifo_level;
> > +	u8 reserved2[1];
> > +	u16 abort_mask_txts;
> > +	u64 ts;
> > +	u32 reserved3[4];
> > +};
> > +
> > +struct acc_bmmsg_overrun {
> > +	u8 msg_id;
> > +	u8 txfifo_level;
> > +	u8 lost_cnt;
> > +	u8 reserved1;
> > +	u8 txtsfifo_level;
> > +	u8 reserved2[3];
> > +	u64 ts;
> > +	u32 reserved3[4];
> > +};
> > +
> > +struct acc_bmmsg_buserr {
> > +	u8 msg_id;
> > +	u8 txfifo_level;
> > +	u8 ecc;
> > +	u8 reserved1;
> > +	u8 txtsfifo_level;
> > +	u8 reserved2[3];
> > +	u64 ts;
> > +	u32 reg_status;
> > +	u32 reg_btr;
> > +	u32 reserved3[2];
> > +};
> > +
> > +struct acc_bmmsg_errstatechange {
> > +	u8 msg_id;
> > +	u8 txfifo_level;
> > +	u8 reserved1[2];
> > +	u8 txtsfifo_level;
> > +	u8 reserved2[3];
> > +	u64 ts;
> > +	u32 reg_status;
> > +	u32 reserved3[3];
> > +};
> > +
> > +struct acc_bmmsg_timeslice {
> > +	u8 msg_id;
> > +	u8 txfifo_level;
> > +	u8 reserved1[2];
> > +	u8 txtsfifo_level;
> > +	u8 reserved2[3];
> > +	u64 ts;
> > +	u32 reserved3[4];
> > +};
> > +
> > +struct acc_bmmsg_hwtimer {
> > +	u8 msg_id;
> > +	u8 reserved1[3];
> > +	u32 reserved2[1];
> > +	u64 timer;
> > +	u32 reserved3[4];
> > +};
> > +
> > +struct acc_bmmsg_hotplug {
> > +	u8 msg_id;
> > +	u8 reserved1[3];
> > +	u32 reserved2[7];
> > +};
> > +
> > +struct acc_bmmsg {
> > +	union {
> > +		u8 msg_id;
> > +		struct acc_bmmsg_rxtxdone rxtxdone;
> > +		struct acc_bmmsg_txabort txabort;
> > +		struct acc_bmmsg_overrun overrun;
> > +		struct acc_bmmsg_buserr buserr;
> > +		struct acc_bmmsg_errstatechange errstatechange;
> > +		struct acc_bmmsg_timeslice timeslice;
> > +		struct acc_bmmsg_hwtimer hwtimer;
> > +	} u;
> > +};
> 
> Why don't you use the union directly instead of putting it into a struct?

Directly use the union is better and changed now.

> > +
> > +/* Regarding Documentation/process/volatile-considered-harmful.rst the
> > + * forth exception applies to the "irq_cnt" member of the structure
> > + * below. The u32 variable "irq_cnt" points to is updated by the ESDACC
> > + * FPGA via DMA.
> > + */
> > +struct acc_bmfifo {
> > +	const struct acc_bmmsg *messages;
> > +	/* Bits 0..7: bm_fifo head index */
> > +	volatile const u32 *irq_cnt;
> > +	u32 local_irq_cnt;
> > +	u32 msg_fifo_tail;
> > +};
> > +
> > +struct acc_core {
> > +	void __iomem *addr;
> > +	struct net_device *netdev;
> > +	struct acc_bmfifo bmfifo;
> > +	u8 tx_fifo_size;
> > +	u8 tx_fifo_head;
> > +	u8 tx_fifo_tail;
> 
> Is the tx_fifo_size a power of two? If so it's usually easier to use a
> unsigned int for the head and tail pointers and mask them to their real
> values. head and tail pointers only ever increase and eventually roll
> over. As both are unsigned there's no problem if head has rolled over,
> but the tail doesn't.
> 
> When you read tail pointer from HW you round_down() to
> core->tx_fifo_size, add the tail value from HW and add
> core->tx_fifo_size if it's lower than the old value. This is the only
> time where you have to take care of rollover.

I'll have a look at it later ...


> > +};
> > +
> > +struct acc_ov {
> > +	void __iomem *addr;
> > +	struct acc_bmfifo bmfifo;
> > +	u32 timestamp_frequency;
> > +	u32 ts2ns_numerator;
> > +	u32 ts2ns_denominator;
> > +	u32 core_frequency;
> > +	u16 version;
> > +	u16 features;
> > +	u8 total_cores;
> > +	u8 active_cores;
> > +};
> > +
> > +struct acc_net_priv {
> > +	struct can_priv can; /* must be the first member! */
> > +	struct acc_core *core;
> > +	struct acc_ov *ov;
> > +};
> > +
> > +static inline u32 acc_read32(struct acc_core *core, unsigned short offs)
> > +{
> > +	return ioread32be(core->addr + offs);
> > +}
> > +
> > +static inline void acc_write32(struct acc_core *core,
> > +			       unsigned short offs, u32 v)
> > +{
> > +	iowrite32be(v, core->addr + offs);
> > +}
> > +
> > +static inline void acc_write32_noswap(struct acc_core *core,
> > +				      unsigned short offs, u32 v)
> > +{
> > +	iowrite32(v, core->addr + offs);
> > +}
> > +
> > +static inline void acc_sset_bits(struct acc_core *core,
> > +				unsigned short offs, u32 mask)
> > +{
> > +	u32 v = acc_read32(core, offs);
> > +
> > +	v |= mask;
> > +	acc_write32(core, offs, v);
> > +}
> > +
> > +static inline void acc_clear_bits(struct acc_core *core,
> > +				  unsigned short offs, u32 mask)
> > +{
> > +	u32 v = acc_read32(core, offs);
> > +
> > +	v &= ~mask;
> > +	acc_write32(core, offs, v);
> > +}
> > +
> > +static inline int acc_resetmode_entered(struct acc_core *core)
> > +{
> > +	u32 ctrl = acc_read32(core, ACC_CORE_OF_CTRL_MODE);
> > +
> > +	return (ctrl & ACC_REG_CONTROL_MASK_MODE_RESETMODE) != 0;
> > +}
> > +
> > +static inline u32 acc_ov_read32(struct acc_ov *ov, unsigned short offs)
> > +{
> > +	return ioread32be(ov->addr + offs);
> > +}
> > +
> > +static inline void acc_ov_write32(struct acc_ov *ov,
> > +				  unsigned short offs, u32 v)
> > +{
> > +	iowrite32be(v, ov->addr + offs);
> > +}
> > +
> > +static inline void acc_ov_set_bits(struct acc_ov *ov,
> > +				   unsigned short offs, u32 b)
> > +{
> > +	u32 v = acc_ov_read32(ov, offs);
> > +
> > +	v |= b;
> > +	acc_ov_write32(ov, offs, v);
> > +}
> > +
> > +static inline void acc_ov_clear_bits(struct acc_ov *ov,
> > +				     unsigned short offs, u32 b)
> > +{
> > +	u32 v = acc_ov_read32(ov, offs);
> > +
> > +	v &= ~b;
> > +	acc_ov_write32(ov, offs, v);
> > +}
> > +
> > +static inline void acc_reset_fpga(struct acc_ov *ov)
> > +{
> > +	acc_ov_write32(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_FPGA_RESET);
> > +
> > +	/* Also reset I^2C, to re-detect card addons at every driver start: */
> > +	acc_ov_clear_bits(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_I2C_ENABLE);
> > +	mdelay(2);
> > +	acc_ov_set_bits(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_I2C_ENABLE);
> > +	mdelay(10);
> > +}
> > +
> > +void acc_init_ov(struct acc_ov *ov, struct device *dev);
> > +void acc_init_bm_ptr(struct acc_ov *ov, struct acc_core *cores,
> > +		     const void *mem);
> > +int acc_open(struct net_device *netdev);
> > +int acc_close(struct net_device *netdev);
> > +netdev_tx_t acc_start_xmit(struct sk_buff *skb, struct net_device *netdev);
> > +int acc_get_berr_counter(const struct net_device *netdev,
> > +			 struct can_berr_counter *bec);
> > +int acc_set_mode(struct net_device *netdev, enum can_mode mode);
> > +int acc_set_bittiming(struct net_device *netdev);
> > +irqreturn_t acc_card_interrupt(struct acc_ov *ov, struct acc_core *cores);


Stefan Mätje (2):
  MAINTAINERS: add Stefan Mätje as maintainer for the esd electronics
    GmbH PCIe/402 CAN drivers
  can: esd: add support for esd GmbH PCIe/402 CAN interface family

 MAINTAINERS                            |   7 +
 drivers/net/can/Kconfig                |   1 +
 drivers/net/can/Makefile               |   1 +
 drivers/net/can/esd/Kconfig            |  12 +
 drivers/net/can/esd/Makefile           |   7 +
 drivers/net/can/esd/esd_402_pci-core.c | 510 ++++++++++++++++
 drivers/net/can/esd/esdacc.c           | 771 +++++++++++++++++++++++++
 drivers/net/can/esd/esdacc.h           | 393 +++++++++++++
 8 files changed, 1702 insertions(+)
 create mode 100644 drivers/net/can/esd/Kconfig
 create mode 100644 drivers/net/can/esd/Makefile
 create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
 create mode 100644 drivers/net/can/esd/esdacc.c
 create mode 100644 drivers/net/can/esd/esdacc.h


base-commit: 63d9e12914840400e9f96c2ae9a51cd9702c2daf
-- 
2.25.1

