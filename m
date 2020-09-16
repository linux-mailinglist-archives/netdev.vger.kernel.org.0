Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1747126CD1D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgIPUxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:53:49 -0400
Received: from mail-db8eur05on2115.outbound.protection.outlook.com ([40.107.20.115]:42592
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbgIPQyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 12:54:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfaY5TisbHDEDv1NXzo82PKg4JFq81oMeVouXzthYrkhLVUZ/GBbkYbEbb61YCvo9qkew5hjReKc2Wvus7buHldtwCqoMiecACMEVsfTaOC5lrr0vfdK4zcdRkb4yti5g6keOwB6KJlgjmYYKMzAw3guJJnnp/uvt3WK5unRNEIN2Eki4jgpPZjfTNEHrHAFHQoqvFKI2BA58cp8lkeAJn6O/kBUr2bSDiycMBsfEyD9kvoxThUIuVOEns2cWsWK433z/Z3uJq6a0rFAldDE4G3RFJOHLSJAUjndZVD3+rLuIqAJhgj0GRV8rgqdcdtVCcAkFhSREso7k7iRI6yHew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0A5/Ap+thL3wDVSwyrQ/gjBmz0mX5m5sShM93EV+ePU=;
 b=URZ/fVVPVEKWIJv2f3wak3GEvhH3LeRm1yc92/ypRw7s0obo0KqoFW3MjSCH7NioYTm03EcjRLv8KphyquHHpDZS8j4OuA/yWF/upTApydnZ54OODV/sSk2Yi78cLtdj6g2qtx7CjDMrGU6BBVzFOThnZaXwaHbQyZ7d9WzM380oVg8n84uN1tmGOIJB2AyNDu9cEl0kyQiJOP2d4lRK1g0JLdkALdzvGYnsjjBcg6WMPBd/jK16OzXof5rb2fge/E0ofKW6tHQ3S7qskSsfZAuDhBt0v4ckSmLA79BK8neY89jbxnqxxrDX3DwXIatfn6AizkthARtB0dXsntWpwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0A5/Ap+thL3wDVSwyrQ/gjBmz0mX5m5sShM93EV+ePU=;
 b=pLDhPTkFkOb3cuMiXlHHc55WhKl4ieuh+ardAJ3y2CjmlpvfkJe5TcUR7cXK22FeTtLGko3ACNATd3B1y3Xm97BstWcy8EVx4JG8l+aVac70gDDYi6XloiPiA18kdf/xFK3KuWd+li3d1Q2FtLEja+bnf+FmRBAMKFsigrfIwso=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0332.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.19; Wed, 16 Sep 2020 16:31:31 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 16:31:31 +0000
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
Subject: [PATCH net-next v9 1/6] net: marvell: prestera: Add driver for Prestera family ASIC devices
Date:   Wed, 16 Sep 2020 19:30:57 +0300
Message-Id: <20200916163102.3408-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916163102.3408-1-vadym.kochan@plvision.eu>
References: <20200916163102.3408-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0202CA0070.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::47) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR0202CA0070.eurprd02.prod.outlook.com (2603:10a6:20b:3a::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 16:31:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13dad967-7ee3-4ac3-1b98-08d85a5df7d8
X-MS-TrafficTypeDiagnostic: HE1P190MB0332:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0332761DD29735530284714595210@HE1P190MB0332.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HU9h1nVAKUS1syHAHbUNQ24zoZrmlnv3OrRa3fx/AC8dBnK2u/wo9rRwOni0rfHvJ5UDIqPzKHidZ4nPFju7rtnNW/u+Co96X+SsRRU/i514bHYGZtbjWZ2SyLWlY7B6ZRo+zyH/wcYLa3sn+ohVvDPrA+br4LaNmoS1EVPAZ+F1Lwk2A2whv6Ngbua77fXJdps+MNHsAOGfls3+D/MjzqcYc4A7Pnzx3k9eZyF9ruiPLREGuQ+u8x8bHU/rIx/1qbgjlMXDZ8N6g++ksqdEeTTmgv0zMlSFykY92AaBHDrz8+O+G8beZsXSR0sMMjgwjLxeAwXer8++hew0NI+f5nHw0UMbI6hR/Y4yerJlTYqkbc0OZPcypwLrsR+2a37ikU27wvPVxnBuhzeO9DjK1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39830400003)(396003)(110136005)(478600001)(66556008)(66946007)(8936002)(4326008)(66476007)(30864003)(8676002)(6666004)(6486002)(1076003)(86362001)(5660300002)(6512007)(36756003)(44832011)(83380400001)(2906002)(54906003)(6506007)(316002)(52116002)(26005)(107886003)(16526019)(186003)(2616005)(956004)(921003)(21314003)(559001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +eiF6DIcOUP+SrC6zBsFf1cEge+Ae6pTx7V6CNjVPKfCQJFp9yjlAFrIbiT7L1FyqlELeh8Iit5UgNTHGm6Cq81aqJfORBp6W/I+BpdEtA0DHNrklVxFMc8haVTIrBfV2Mv/DMrRh64GoGMhMS9lj/lNF33V2I/xjeAkEA4ezMLttgneAlTFRkNutUaOZysQrGUUEadN48NdqFJDhyAN30fwCjYMwkM73IEZ8A3iOGpg3hOuRIi8KtpxkSGNLesaj1GznHIuQk2y3TkJ4BvTWsCAoA2WN42G/ECRKVUy69p/D/Cjxy1gyeD5QH3uI+9v6GZBS8CKC+JLPiQz6anHQjMpGTiTaliN4RaUT7XPnSrOhujralIRi/R8ASel4f/zOB9FegKJUu4Q4XddKgohQWObFaLIF5jELhhUIK+K9VR9y12Ax0vz2N1eoWYys1/ywPiTbeUqWIEKZHNt9proA9/rT0Pkkkt4F+9FlQsEV6czzfiKRkqPQbQDMK8isTSx0IkTXEy/23rlVKF/ukkgCZfYnNVJgj/HAIevgOTTjeZeNfpfgq1Tj9R+//mNLEZgRaIbD9iL194uxHjiiOVD9Q+keq3s1avVa/QjZXaAP0GBiMhWdE31umPdvJt9fmCoNTF8zzhGeqsUBXhK0qUKwg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 13dad967-7ee3-4ac3-1b98-08d85a5df7d8
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 16:31:31.3716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PqUNXw+17yrU/ZA/fyywPwR8gnaNLgX52ZVizEt9NmqUuXC5+NZ3VYMHI15RPy+h8seSmJGp5kvKdxZ4mWYp1IpHy8aIsmvaOezCPgerAJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0332
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
wireless SMB deployment.

The current implementation supports only boards designed for the Marvell
Switchdev solution and requires special firmware.

The core Prestera switching logic is implemented in prestera_main.c,
there is an intermediate hw layer between core logic and firmware. It is
implemented in prestera_hw.c, the purpose of it is to encapsulate hw
related logic, in future there is a plan to support more devices with
different HW related configurations.

This patch contains only basic switch initialization and RX/TX support
over SDMA mechanism.

Currently supported devices have DMA access range <= 32bit and require
ZONE_DMA to be enabled, for such cases SDMA driver checks if the skb
allocated in proper range supported by the Prestera device.

Also meanwhile there is no TX interrupt support in current firmware
version so recycling work is scheduled on each xmit.

Port's mac address is generated from the switch base mac which may be
provided via device-tree (static one or as nvme cell), or randomly
generated. This is required by the firmware.

Co-developed-by: Andrii Savka <andrii.savka@plvision.eu>
Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Co-developed-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Co-developed-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
PATCH v9:
    1) Replace read_poll_timeout_atomic() by original 'do {} while()' loop
       because it works much better than read_poll_timeout_atomic()
       considering the TX rate. Also it fixes warning reported on v8.

    2) Use ENOENT instead of EEXIST when item is not found in few
       places - prestera_hw.c and prestera_rxtx.c

PATCH v8:
    1) Put license in one line.

    2) Sort includes.

    3) Add missing comma for last enum member

    4) Use PRESTERA_DSA_ as macro prefix in prestera_dsa.c

    5) Return original error code from last called func
       in places where instead other error code was used.

    6) Add comma for last member in initialized struct in prestera_hw.c

    7) Split prestera_port_state_set() func body into prestera_port_open()
       and prestera_port_close().

    8) Do not initialize 'int err = 0' where it is not needed.

    9) Simplify device-tree "marvell,prestera" node parsing by removing not
       needed checking on 'np == NULL'.

    10) Remove extra () in PRESTERA_SDMA_RX_DESC_IS_RCVD macro in prestera_rxtx.c

    11) Use u32p_replace_bits() instead of open-coded ((word & ~mask) | val)

    12) Use dev_warn_ratelimited() instead of pr_warn_ratelimited to indicate the device
        instance in prestera_rxtx.c

    13) Simplify circular buffer list creation in prestera_sdma_{rx,tx}_init() by using
        do { } while (prev != tail) construction.

    14) Use read_poll_timeout_atomic() instead of custom spinning 'while' logic in
        prestera_rxtx.c:prestera_sdma_tx_wait()

    15) Remove "prestera.h" inclusion but use force declaration for
        struct prestera_port and struct prestera_switch.

PATCH v7:
    1) Use ether_addr_copy() in prestera_main.c:prestera_port_set_mac_address()
       instead of memcpy().

    2) Removed not needed device's DMA address range check on
       dma_pool_alloc() in prestera_rxtx.c:prestera_sdma_buf_init(),
       this should be handled by dma_xxx() API considerig device's DMA mask.

    3) Removed not needed device's DMA address range check on
       dma_map_single() in prestera_rxtx.c:prestera_sdma_rx_skb_alloc(),
       this should be handled by dma_xxx() API considerig device's DMA mask.

    4) Add comment about port mac address limitation in the code where
       it is used and checked - prestera_main.c:

           - prestera_is_valid_mac_addr()
           - prestera_port_create()

 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/Makefile         |   1 +
 drivers/net/ethernet/marvell/prestera/Kconfig |  13 +
 .../net/ethernet/marvell/prestera/Makefile    |   4 +
 .../net/ethernet/marvell/prestera/prestera.h  | 168 ++++
 .../ethernet/marvell/prestera/prestera_dsa.c  | 104 +++
 .../ethernet/marvell/prestera/prestera_dsa.h  |  35 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 625 +++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  69 ++
 .../ethernet/marvell/prestera/prestera_main.c | 521 +++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.c | 820 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_rxtx.h |  19 +
 12 files changed, 2380 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index ef4f35ba077d..892e5c8ff096 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -172,5 +172,6 @@ config SKY2_DEBUG
 
 
 source "drivers/net/ethernet/marvell/octeontx2/Kconfig"
+source "drivers/net/ethernet/marvell/prestera/Kconfig"
 
 endif # NET_VENDOR_MARVELL
diff --git a/drivers/net/ethernet/marvell/Makefile b/drivers/net/ethernet/marvell/Makefile
index 89dea7284d5b..9f88fe822555 100644
--- a/drivers/net/ethernet/marvell/Makefile
+++ b/drivers/net/ethernet/marvell/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_PXA168_ETH) += pxa168_eth.o
 obj-$(CONFIG_SKGE) += skge.o
 obj-$(CONFIG_SKY2) += sky2.o
 obj-y		+= octeontx2/
+obj-y		+= prestera/
diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
new file mode 100644
index 000000000000..76b68613ea7a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Marvell Prestera drivers configuration
+#
+
+config PRESTERA
+	tristate "Marvell Prestera Switch ASICs support"
+	depends on NET_SWITCHDEV && VLAN_8021Q
+	help
+	  This driver supports Marvell Prestera Switch ASICs family.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called prestera.
diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
new file mode 100644
index 000000000000..610d75032b78
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_PRESTERA)	+= prestera.o
+prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
+			   prestera_rxtx.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
new file mode 100644
index 000000000000..c5bf0fe8d59e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -0,0 +1,168 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_H_
+#define _PRESTERA_H_
+
+#include <linux/notifier.h>
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
+#include <uapi/linux/if_ether.h>
+
+struct prestera_fw_rev {
+	u16 maj;
+	u16 min;
+	u16 sub;
+};
+
+struct prestera_port_stats {
+	u64 good_octets_received;
+	u64 bad_octets_received;
+	u64 mac_trans_error;
+	u64 broadcast_frames_received;
+	u64 multicast_frames_received;
+	u64 frames_64_octets;
+	u64 frames_65_to_127_octets;
+	u64 frames_128_to_255_octets;
+	u64 frames_256_to_511_octets;
+	u64 frames_512_to_1023_octets;
+	u64 frames_1024_to_max_octets;
+	u64 excessive_collision;
+	u64 multicast_frames_sent;
+	u64 broadcast_frames_sent;
+	u64 fc_sent;
+	u64 fc_received;
+	u64 buffer_overrun;
+	u64 undersize;
+	u64 fragments;
+	u64 oversize;
+	u64 jabber;
+	u64 rx_error_frame_received;
+	u64 bad_crc;
+	u64 collisions;
+	u64 late_collision;
+	u64 unicast_frames_received;
+	u64 unicast_frames_sent;
+	u64 sent_multiple;
+	u64 sent_deferred;
+	u64 good_octets_sent;
+};
+
+struct prestera_port_caps {
+	u64 supp_link_modes;
+	u8 supp_fec;
+	u8 type;
+	u8 transceiver;
+};
+
+struct prestera_port {
+	struct net_device *dev;
+	struct prestera_switch *sw;
+	u32 id;
+	u32 hw_id;
+	u32 dev_id;
+	u16 fp_id;
+	bool autoneg;
+	u64 adver_link_modes;
+	u8 adver_fec;
+	struct prestera_port_caps caps;
+	struct list_head list;
+	struct {
+		struct prestera_port_stats stats;
+		struct delayed_work caching_dw;
+	} cached_hw_stats;
+};
+
+struct prestera_device {
+	struct device *dev;
+	u8 __iomem *ctl_regs;
+	u8 __iomem *pp_regs;
+	struct prestera_fw_rev fw_rev;
+	void *priv;
+
+	/* called by device driver to handle received packets */
+	void (*recv_pkt)(struct prestera_device *dev);
+
+	/* called by device driver to pass event up to the higher layer */
+	int (*recv_msg)(struct prestera_device *dev, void *msg, size_t size);
+
+	/* called by higher layer to send request to the firmware */
+	int (*send_req)(struct prestera_device *dev, void *in_msg,
+			size_t in_size, void *out_msg, size_t out_size,
+			unsigned int wait);
+};
+
+enum prestera_event_type {
+	PRESTERA_EVENT_TYPE_UNSPEC,
+
+	PRESTERA_EVENT_TYPE_PORT,
+	PRESTERA_EVENT_TYPE_RXTX,
+
+	PRESTERA_EVENT_TYPE_MAX
+};
+
+enum prestera_rxtx_event_id {
+	PRESTERA_RXTX_EVENT_UNSPEC,
+	PRESTERA_RXTX_EVENT_RCV_PKT,
+};
+
+enum prestera_port_event_id {
+	PRESTERA_PORT_EVENT_UNSPEC,
+	PRESTERA_PORT_EVENT_STATE_CHANGED,
+};
+
+struct prestera_port_event {
+	u32 port_id;
+	union {
+		u32 oper_state;
+	} data;
+};
+
+struct prestera_event {
+	u16 id;
+	union {
+		struct prestera_port_event port_evt;
+	};
+};
+
+struct prestera_rxtx;
+
+struct prestera_switch {
+	struct prestera_device *dev;
+	struct prestera_rxtx *rxtx;
+	struct list_head event_handlers;
+	char base_mac[ETH_ALEN];
+	struct list_head port_list;
+	rwlock_t port_list_lock;
+	u32 port_count;
+	u32 mtu_min;
+	u32 mtu_max;
+	u8 id;
+};
+
+struct prestera_rxtx_params {
+	bool use_sdma;
+	u32 map_addr;
+};
+
+#define prestera_dev(sw)		((sw)->dev->dev)
+
+static inline void prestera_write(const struct prestera_switch *sw,
+				  unsigned int reg, u32 val)
+{
+	writel(val, sw->dev->pp_regs + reg);
+}
+
+static inline u32 prestera_read(const struct prestera_switch *sw,
+				unsigned int reg)
+{
+	return readl(sw->dev->pp_regs + reg);
+}
+
+int prestera_device_register(struct prestera_device *dev);
+void prestera_device_unregister(struct prestera_device *dev);
+
+struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
+						 u32 dev_id, u32 hw_id);
+
+#endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.c b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
new file mode 100644
index 000000000000..a5e01c7a307b
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/bitfield.h>
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+
+#include "prestera_dsa.h"
+
+#define PRESTERA_DSA_W0_CMD		GENMASK(31, 30)
+#define PRESTERA_DSA_W0_IS_TAGGED	BIT(29)
+#define PRESTERA_DSA_W0_DEV_NUM		GENMASK(28, 24)
+#define PRESTERA_DSA_W0_PORT_NUM	GENMASK(23, 19)
+#define PRESTERA_DSA_W0_VPT		GENMASK(15, 13)
+#define PRESTERA_DSA_W0_EXT_BIT		BIT(12)
+#define PRESTERA_DSA_W0_VID		GENMASK(11, 0)
+
+#define PRESTERA_DSA_W1_EXT_BIT		BIT(31)
+#define PRESTERA_DSA_W1_CFI_BIT		BIT(30)
+#define PRESTERA_DSA_W1_PORT_NUM	GENMASK(11, 10)
+
+#define PRESTERA_DSA_W2_EXT_BIT		BIT(31)
+#define PRESTERA_DSA_W2_PORT_NUM	BIT(20)
+
+#define PRESTERA_DSA_W3_VID		GENMASK(30, 27)
+#define PRESTERA_DSA_W3_DST_EPORT	GENMASK(23, 7)
+#define PRESTERA_DSA_W3_DEV_NUM		GENMASK(6, 0)
+
+#define PRESTERA_DSA_VID		GENMASK(15, 12)
+#define PRESTERA_DSA_DEV_NUM		GENMASK(11, 5)
+
+int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf)
+{
+	__be32 *dsa_words = (__be32 *)dsa_buf;
+	enum prestera_dsa_cmd cmd;
+	u32 words[4];
+	u32 field;
+
+	words[0] = ntohl(dsa_words[0]);
+	words[1] = ntohl(dsa_words[1]);
+	words[2] = ntohl(dsa_words[2]);
+	words[3] = ntohl(dsa_words[3]);
+
+	/* set the common parameters */
+	cmd = (enum prestera_dsa_cmd)FIELD_GET(PRESTERA_DSA_W0_CMD, words[0]);
+
+	/* only to CPU is supported */
+	if (unlikely(cmd != PRESTERA_DSA_CMD_TO_CPU))
+		return -EINVAL;
+
+	if (FIELD_GET(PRESTERA_DSA_W0_EXT_BIT, words[0]) == 0)
+		return -EINVAL;
+	if (FIELD_GET(PRESTERA_DSA_W1_EXT_BIT, words[1]) == 0)
+		return -EINVAL;
+	if (FIELD_GET(PRESTERA_DSA_W2_EXT_BIT, words[2]) == 0)
+		return -EINVAL;
+
+	field = FIELD_GET(PRESTERA_DSA_W3_VID, words[3]);
+
+	dsa->vlan.is_tagged = FIELD_GET(PRESTERA_DSA_W0_IS_TAGGED, words[0]);
+	dsa->vlan.cfi_bit = FIELD_GET(PRESTERA_DSA_W1_CFI_BIT, words[1]);
+	dsa->vlan.vpt = FIELD_GET(PRESTERA_DSA_W0_VPT, words[0]);
+	dsa->vlan.vid = FIELD_GET(PRESTERA_DSA_W0_VID, words[0]);
+	dsa->vlan.vid &= ~PRESTERA_DSA_VID;
+	dsa->vlan.vid |= FIELD_PREP(PRESTERA_DSA_VID, field);
+
+	field = FIELD_GET(PRESTERA_DSA_W3_DEV_NUM, words[3]);
+
+	dsa->hw_dev_num = FIELD_GET(PRESTERA_DSA_W0_DEV_NUM, words[0]);
+	dsa->hw_dev_num |= FIELD_PREP(PRESTERA_DSA_DEV_NUM, field);
+
+	dsa->port_num = (FIELD_GET(PRESTERA_DSA_W0_PORT_NUM, words[0]) << 0) |
+			(FIELD_GET(PRESTERA_DSA_W1_PORT_NUM, words[1]) << 5) |
+			(FIELD_GET(PRESTERA_DSA_W2_PORT_NUM, words[2]) << 7);
+
+	return 0;
+}
+
+int prestera_dsa_build(const struct prestera_dsa *dsa, u8 *dsa_buf)
+{
+	__be32 *dsa_words = (__be32 *)dsa_buf;
+	u32 dev_num = dsa->hw_dev_num;
+	u32 words[4] = { 0 };
+
+	words[0] |= FIELD_PREP(PRESTERA_DSA_W0_CMD, PRESTERA_DSA_CMD_FROM_CPU);
+
+	words[0] |= FIELD_PREP(PRESTERA_DSA_W0_DEV_NUM, dev_num);
+	dev_num = FIELD_GET(PRESTERA_DSA_DEV_NUM, dev_num);
+	words[3] |= FIELD_PREP(PRESTERA_DSA_W3_DEV_NUM, dev_num);
+
+	words[3] |= FIELD_PREP(PRESTERA_DSA_W3_DST_EPORT, dsa->port_num);
+
+	words[0] |= FIELD_PREP(PRESTERA_DSA_W0_EXT_BIT, 1);
+	words[1] |= FIELD_PREP(PRESTERA_DSA_W1_EXT_BIT, 1);
+	words[2] |= FIELD_PREP(PRESTERA_DSA_W2_EXT_BIT, 1);
+
+	dsa_words[0] = htonl(words[0]);
+	dsa_words[1] = htonl(words[1]);
+	dsa_words[2] = htonl(words[2]);
+	dsa_words[3] = htonl(words[3]);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.h b/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
new file mode 100644
index 000000000000..67018629bdd2
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef __PRESTERA_DSA_H_
+#define __PRESTERA_DSA_H_
+
+#include <linux/types.h>
+
+#define PRESTERA_DSA_HLEN	16
+
+enum prestera_dsa_cmd {
+	/* DSA command is "To CPU" */
+	PRESTERA_DSA_CMD_TO_CPU = 0,
+
+	/* DSA command is "From CPU" */
+	PRESTERA_DSA_CMD_FROM_CPU,
+};
+
+struct prestera_dsa_vlan {
+	u16 vid;
+	u8 vpt;
+	u8 cfi_bit;
+	bool is_tagged;
+};
+
+struct prestera_dsa {
+	struct prestera_dsa_vlan vlan;
+	u32 hw_dev_num;
+	u32 port_num;
+};
+
+int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf);
+int prestera_dsa_build(const struct prestera_dsa *dsa, u8 *dsa_buf);
+
+#endif /* _PRESTERA_DSA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
new file mode 100644
index 000000000000..9f1e222024ef
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -0,0 +1,625 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/list.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+
+#define PRESTERA_SWITCH_INIT_TIMEOUT_MS (30 * 1000)
+
+#define PRESTERA_MIN_MTU 64
+
+enum prestera_cmd_type_t {
+	PRESTERA_CMD_TYPE_SWITCH_INIT = 0x1,
+	PRESTERA_CMD_TYPE_SWITCH_ATTR_SET = 0x2,
+
+	PRESTERA_CMD_TYPE_PORT_ATTR_SET = 0x100,
+	PRESTERA_CMD_TYPE_PORT_ATTR_GET = 0x101,
+	PRESTERA_CMD_TYPE_PORT_INFO_GET = 0x110,
+
+	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
+	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
+
+	PRESTERA_CMD_TYPE_ACK = 0x10000,
+	PRESTERA_CMD_TYPE_MAX
+};
+
+enum {
+	PRESTERA_CMD_PORT_ATTR_ADMIN_STATE = 1,
+	PRESTERA_CMD_PORT_ATTR_MTU = 3,
+	PRESTERA_CMD_PORT_ATTR_MAC = 4,
+	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
+	PRESTERA_CMD_PORT_ATTR_AUTONEG = 15,
+	PRESTERA_CMD_PORT_ATTR_STATS = 17,
+};
+
+enum {
+	PRESTERA_CMD_SWITCH_ATTR_MAC = 1,
+};
+
+enum {
+	PRESTERA_CMD_ACK_OK,
+	PRESTERA_CMD_ACK_FAILED,
+
+	PRESTERA_CMD_ACK_MAX
+};
+
+enum {
+	PRESTERA_PORT_GOOD_OCTETS_RCV_CNT,
+	PRESTERA_PORT_BAD_OCTETS_RCV_CNT,
+	PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT,
+	PRESTERA_PORT_BRDC_PKTS_RCV_CNT,
+	PRESTERA_PORT_MC_PKTS_RCV_CNT,
+	PRESTERA_PORT_PKTS_64L_CNT,
+	PRESTERA_PORT_PKTS_65TO127L_CNT,
+	PRESTERA_PORT_PKTS_128TO255L_CNT,
+	PRESTERA_PORT_PKTS_256TO511L_CNT,
+	PRESTERA_PORT_PKTS_512TO1023L_CNT,
+	PRESTERA_PORT_PKTS_1024TOMAXL_CNT,
+	PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT,
+	PRESTERA_PORT_MC_PKTS_SENT_CNT,
+	PRESTERA_PORT_BRDC_PKTS_SENT_CNT,
+	PRESTERA_PORT_FC_SENT_CNT,
+	PRESTERA_PORT_GOOD_FC_RCV_CNT,
+	PRESTERA_PORT_DROP_EVENTS_CNT,
+	PRESTERA_PORT_UNDERSIZE_PKTS_CNT,
+	PRESTERA_PORT_FRAGMENTS_PKTS_CNT,
+	PRESTERA_PORT_OVERSIZE_PKTS_CNT,
+	PRESTERA_PORT_JABBER_PKTS_CNT,
+	PRESTERA_PORT_MAC_RCV_ERROR_CNT,
+	PRESTERA_PORT_BAD_CRC_CNT,
+	PRESTERA_PORT_COLLISIONS_CNT,
+	PRESTERA_PORT_LATE_COLLISIONS_CNT,
+	PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT,
+	PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT,
+	PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT,
+	PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT,
+	PRESTERA_PORT_GOOD_OCTETS_SENT_CNT,
+
+	PRESTERA_PORT_CNT_MAX
+};
+
+struct prestera_fw_event_handler {
+	struct list_head list;
+	struct rcu_head rcu;
+	enum prestera_event_type type;
+	prestera_event_cb_t func;
+	void *arg;
+};
+
+struct prestera_msg_cmd {
+	u32 type;
+};
+
+struct prestera_msg_ret {
+	struct prestera_msg_cmd cmd;
+	u32 status;
+};
+
+struct prestera_msg_common_req {
+	struct prestera_msg_cmd cmd;
+};
+
+struct prestera_msg_common_resp {
+	struct prestera_msg_ret ret;
+};
+
+union prestera_msg_switch_param {
+	u8 mac[ETH_ALEN];
+};
+
+struct prestera_msg_switch_attr_req {
+	struct prestera_msg_cmd cmd;
+	u32 attr;
+	union prestera_msg_switch_param param;
+};
+
+struct prestera_msg_switch_init_resp {
+	struct prestera_msg_ret ret;
+	u32 port_count;
+	u32 mtu_max;
+	u8  switch_id;
+};
+
+struct prestera_msg_port_autoneg_param {
+	u64 link_mode;
+	u8  enable;
+	u8  fec;
+};
+
+struct prestera_msg_port_cap_param {
+	u64 link_mode;
+	u8  type;
+	u8  fec;
+	u8  transceiver;
+};
+
+union prestera_msg_port_param {
+	u8  admin_state;
+	u8  oper_state;
+	u32 mtu;
+	u8  mac[ETH_ALEN];
+	struct prestera_msg_port_autoneg_param autoneg;
+	struct prestera_msg_port_cap_param cap;
+};
+
+struct prestera_msg_port_attr_req {
+	struct prestera_msg_cmd cmd;
+	u32 attr;
+	u32 port;
+	u32 dev;
+	union prestera_msg_port_param param;
+};
+
+struct prestera_msg_port_attr_resp {
+	struct prestera_msg_ret ret;
+	union prestera_msg_port_param param;
+};
+
+struct prestera_msg_port_stats_resp {
+	struct prestera_msg_ret ret;
+	u64 stats[PRESTERA_PORT_CNT_MAX];
+};
+
+struct prestera_msg_port_info_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+};
+
+struct prestera_msg_port_info_resp {
+	struct prestera_msg_ret ret;
+	u32 hw_id;
+	u32 dev_id;
+	u16 fp_id;
+};
+
+struct prestera_msg_rxtx_req {
+	struct prestera_msg_cmd cmd;
+	u8 use_sdma;
+};
+
+struct prestera_msg_rxtx_resp {
+	struct prestera_msg_ret ret;
+	u32 map_addr;
+};
+
+struct prestera_msg_rxtx_port_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+};
+
+struct prestera_msg_event {
+	u16 type;
+	u16 id;
+};
+
+union prestera_msg_event_port_param {
+	u32 oper_state;
+};
+
+struct prestera_msg_event_port {
+	struct prestera_msg_event id;
+	u32 port_id;
+	union prestera_msg_event_port_param param;
+};
+
+static int __prestera_cmd_ret(struct prestera_switch *sw,
+			      enum prestera_cmd_type_t type,
+			      struct prestera_msg_cmd *cmd, size_t clen,
+			      struct prestera_msg_ret *ret, size_t rlen,
+			      int waitms)
+{
+	struct prestera_device *dev = sw->dev;
+	int err;
+
+	cmd->type = type;
+
+	err = dev->send_req(dev, cmd, clen, ret, rlen, waitms);
+	if (err)
+		return err;
+
+	if (ret->cmd.type != PRESTERA_CMD_TYPE_ACK)
+		return -EBADE;
+	if (ret->status != PRESTERA_CMD_ACK_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int prestera_cmd_ret(struct prestera_switch *sw,
+			    enum prestera_cmd_type_t type,
+			    struct prestera_msg_cmd *cmd, size_t clen,
+			    struct prestera_msg_ret *ret, size_t rlen)
+{
+	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, 0);
+}
+
+static int prestera_cmd_ret_wait(struct prestera_switch *sw,
+				 enum prestera_cmd_type_t type,
+				 struct prestera_msg_cmd *cmd, size_t clen,
+				 struct prestera_msg_ret *ret, size_t rlen,
+				 int waitms)
+{
+	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, waitms);
+}
+
+static int prestera_cmd(struct prestera_switch *sw,
+			enum prestera_cmd_type_t type,
+			struct prestera_msg_cmd *cmd, size_t clen)
+{
+	struct prestera_msg_common_resp resp;
+
+	return prestera_cmd_ret(sw, type, cmd, clen, &resp.ret, sizeof(resp));
+}
+
+static int prestera_fw_parse_port_evt(void *msg, struct prestera_event *evt)
+{
+	struct prestera_msg_event_port *hw_evt = msg;
+
+	if (evt->id != PRESTERA_PORT_EVENT_STATE_CHANGED)
+		return -EINVAL;
+
+	evt->port_evt.data.oper_state = hw_evt->param.oper_state;
+	evt->port_evt.port_id = hw_evt->port_id;
+
+	return 0;
+}
+
+static struct prestera_fw_evt_parser {
+	int (*func)(void *msg, struct prestera_event *evt);
+} fw_event_parsers[PRESTERA_EVENT_TYPE_MAX] = {
+	[PRESTERA_EVENT_TYPE_PORT] = { .func = prestera_fw_parse_port_evt },
+};
+
+static struct prestera_fw_event_handler *
+__find_event_handler(const struct prestera_switch *sw,
+		     enum prestera_event_type type)
+{
+	struct prestera_fw_event_handler *eh;
+
+	list_for_each_entry_rcu(eh, &sw->event_handlers, list) {
+		if (eh->type == type)
+			return eh;
+	}
+
+	return NULL;
+}
+
+static int prestera_find_event_handler(const struct prestera_switch *sw,
+				       enum prestera_event_type type,
+				       struct prestera_fw_event_handler *eh)
+{
+	struct prestera_fw_event_handler *tmp;
+	int err = 0;
+
+	rcu_read_lock();
+	tmp = __find_event_handler(sw, type);
+	if (tmp)
+		*eh = *tmp;
+	else
+		err = -ENOENT;
+	rcu_read_unlock();
+
+	return err;
+}
+
+static int prestera_evt_recv(struct prestera_device *dev, void *buf, size_t size)
+{
+	struct prestera_switch *sw = dev->priv;
+	struct prestera_msg_event *msg = buf;
+	struct prestera_fw_event_handler eh;
+	struct prestera_event evt;
+	int err;
+
+	if (msg->type >= PRESTERA_EVENT_TYPE_MAX)
+		return -EINVAL;
+	if (!fw_event_parsers[msg->type].func)
+		return -ENOENT;
+
+	err = prestera_find_event_handler(sw, msg->type, &eh);
+	if (err)
+		return err;
+
+	evt.id = msg->id;
+
+	err = fw_event_parsers[msg->type].func(buf, &evt);
+	if (err)
+		return err;
+
+	eh.func(sw, &evt, eh.arg);
+
+	return 0;
+}
+
+static void prestera_pkt_recv(struct prestera_device *dev)
+{
+	struct prestera_switch *sw = dev->priv;
+	struct prestera_fw_event_handler eh;
+	struct prestera_event ev;
+	int err;
+
+	ev.id = PRESTERA_RXTX_EVENT_RCV_PKT;
+
+	err = prestera_find_event_handler(sw, PRESTERA_EVENT_TYPE_RXTX, &eh);
+	if (err)
+		return;
+
+	eh.func(sw, &ev, eh.arg);
+}
+
+int prestera_hw_port_info_get(const struct prestera_port *port,
+			      u32 *dev_id, u32 *hw_id, u16 *fp_id)
+{
+	struct prestera_msg_port_info_req req = {
+		.port = port->id,
+	};
+	struct prestera_msg_port_info_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_INFO_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*dev_id = resp.dev_id;
+	*hw_id = resp.hw_id;
+	*fp_id = resp.fp_id;
+
+	return 0;
+}
+
+int prestera_hw_switch_mac_set(struct prestera_switch *sw, const char *mac)
+{
+	struct prestera_msg_switch_attr_req req = {
+		.attr = PRESTERA_CMD_SWITCH_ATTR_MAC,
+	};
+
+	ether_addr_copy(req.param.mac, mac);
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SWITCH_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_switch_init(struct prestera_switch *sw)
+{
+	struct prestera_msg_switch_init_resp resp;
+	struct prestera_msg_common_req req;
+	int err;
+
+	INIT_LIST_HEAD(&sw->event_handlers);
+
+	err = prestera_cmd_ret_wait(sw, PRESTERA_CMD_TYPE_SWITCH_INIT,
+				    &req.cmd, sizeof(req),
+				    &resp.ret, sizeof(resp),
+				    PRESTERA_SWITCH_INIT_TIMEOUT_MS);
+	if (err)
+		return err;
+
+	sw->dev->recv_msg = prestera_evt_recv;
+	sw->dev->recv_pkt = prestera_pkt_recv;
+	sw->port_count = resp.port_count;
+	sw->mtu_min = PRESTERA_MIN_MTU;
+	sw->mtu_max = resp.mtu_max;
+	sw->id = resp.switch_id;
+
+	return 0;
+}
+
+void prestera_hw_switch_fini(struct prestera_switch *sw)
+{
+	WARN_ON(!list_empty(&sw->event_handlers));
+}
+
+int prestera_hw_port_state_set(const struct prestera_port *port,
+			       bool admin_state)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_ADMIN_STATE,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.admin_state = admin_state,
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_MTU,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.mtu = mtu,
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_mac_set(const struct prestera_port *port, const char *mac)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_MAC,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+
+	ether_addr_copy(req.param.mac, mac);
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_cap_get(const struct prestera_port *port,
+			     struct prestera_port_caps *caps)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_attr_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	caps->supp_link_modes = resp.param.cap.link_mode;
+	caps->transceiver = resp.param.cap.transceiver;
+	caps->supp_fec = resp.param.cap.fec;
+	caps->type = resp.param.cap.type;
+
+	return err;
+}
+
+int prestera_hw_port_autoneg_set(const struct prestera_port *port,
+				 bool autoneg, u64 link_modes, u8 fec)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.autoneg = {
+				.link_mode = link_modes,
+				.enable = autoneg,
+				.fec = fec,
+			}
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_stats_get(const struct prestera_port *port,
+			       struct prestera_port_stats *st)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_STATS,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	struct prestera_msg_port_stats_resp resp;
+	u64 *hw = resp.stats;
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	st->good_octets_received = hw[PRESTERA_PORT_GOOD_OCTETS_RCV_CNT];
+	st->bad_octets_received = hw[PRESTERA_PORT_BAD_OCTETS_RCV_CNT];
+	st->mac_trans_error = hw[PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT];
+	st->broadcast_frames_received = hw[PRESTERA_PORT_BRDC_PKTS_RCV_CNT];
+	st->multicast_frames_received = hw[PRESTERA_PORT_MC_PKTS_RCV_CNT];
+	st->frames_64_octets = hw[PRESTERA_PORT_PKTS_64L_CNT];
+	st->frames_65_to_127_octets = hw[PRESTERA_PORT_PKTS_65TO127L_CNT];
+	st->frames_128_to_255_octets = hw[PRESTERA_PORT_PKTS_128TO255L_CNT];
+	st->frames_256_to_511_octets = hw[PRESTERA_PORT_PKTS_256TO511L_CNT];
+	st->frames_512_to_1023_octets = hw[PRESTERA_PORT_PKTS_512TO1023L_CNT];
+	st->frames_1024_to_max_octets = hw[PRESTERA_PORT_PKTS_1024TOMAXL_CNT];
+	st->excessive_collision = hw[PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT];
+	st->multicast_frames_sent = hw[PRESTERA_PORT_MC_PKTS_SENT_CNT];
+	st->broadcast_frames_sent = hw[PRESTERA_PORT_BRDC_PKTS_SENT_CNT];
+	st->fc_sent = hw[PRESTERA_PORT_FC_SENT_CNT];
+	st->fc_received = hw[PRESTERA_PORT_GOOD_FC_RCV_CNT];
+	st->buffer_overrun = hw[PRESTERA_PORT_DROP_EVENTS_CNT];
+	st->undersize = hw[PRESTERA_PORT_UNDERSIZE_PKTS_CNT];
+	st->fragments = hw[PRESTERA_PORT_FRAGMENTS_PKTS_CNT];
+	st->oversize = hw[PRESTERA_PORT_OVERSIZE_PKTS_CNT];
+	st->jabber = hw[PRESTERA_PORT_JABBER_PKTS_CNT];
+	st->rx_error_frame_received = hw[PRESTERA_PORT_MAC_RCV_ERROR_CNT];
+	st->bad_crc = hw[PRESTERA_PORT_BAD_CRC_CNT];
+	st->collisions = hw[PRESTERA_PORT_COLLISIONS_CNT];
+	st->late_collision = hw[PRESTERA_PORT_LATE_COLLISIONS_CNT];
+	st->unicast_frames_received = hw[PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT];
+	st->unicast_frames_sent = hw[PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT];
+	st->sent_multiple = hw[PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT];
+	st->sent_deferred = hw[PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT];
+	st->good_octets_sent = hw[PRESTERA_PORT_GOOD_OCTETS_SENT_CNT];
+
+	return 0;
+}
+
+int prestera_hw_rxtx_init(struct prestera_switch *sw,
+			  struct prestera_rxtx_params *params)
+{
+	struct prestera_msg_rxtx_resp resp;
+	struct prestera_msg_rxtx_req req;
+	int err;
+
+	req.use_sdma = params->use_sdma;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_RXTX_INIT,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	params->map_addr = resp.map_addr;
+
+	return 0;
+}
+
+int prestera_hw_rxtx_port_init(struct prestera_port *port)
+{
+	struct prestera_msg_rxtx_port_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_RXTX_PORT_INIT,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_event_handler_register(struct prestera_switch *sw,
+				       enum prestera_event_type type,
+				       prestera_event_cb_t fn,
+				       void *arg)
+{
+	struct prestera_fw_event_handler *eh;
+
+	eh = __find_event_handler(sw, type);
+	if (eh)
+		return -EEXIST;
+
+	eh = kmalloc(sizeof(*eh), GFP_KERNEL);
+	if (!eh)
+		return -ENOMEM;
+
+	eh->type = type;
+	eh->func = fn;
+	eh->arg = arg;
+
+	INIT_LIST_HEAD(&eh->list);
+
+	list_add_rcu(&eh->list, &sw->event_handlers);
+
+	return 0;
+}
+
+void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
+					  enum prestera_event_type type,
+					  prestera_event_cb_t fn)
+{
+	struct prestera_fw_event_handler *eh;
+
+	eh = __find_event_handler(sw, type);
+	if (!eh)
+		return;
+
+	list_del_rcu(&eh->list);
+	kfree_rcu(eh, rcu);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
new file mode 100644
index 000000000000..5fc923cbb6a5
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_HW_H_
+#define _PRESTERA_HW_H_
+
+#include <linux/types.h>
+
+enum {
+	PRESTERA_PORT_TYPE_NONE,
+	PRESTERA_PORT_TYPE_TP,
+
+	PRESTERA_PORT_TYPE_MAX
+};
+
+enum {
+	PRESTERA_PORT_FEC_OFF,
+
+	PRESTERA_PORT_FEC_MAX
+};
+
+struct prestera_switch;
+struct prestera_port;
+struct prestera_port_stats;
+struct prestera_port_caps;
+enum prestera_event_type;
+struct prestera_event;
+
+typedef void (*prestera_event_cb_t)
+	(struct prestera_switch *sw, struct prestera_event *evt, void *arg);
+
+struct prestera_rxtx_params;
+
+/* Switch API */
+int prestera_hw_switch_init(struct prestera_switch *sw);
+void prestera_hw_switch_fini(struct prestera_switch *sw);
+int prestera_hw_switch_mac_set(struct prestera_switch *sw, const char *mac);
+
+/* Port API */
+int prestera_hw_port_info_get(const struct prestera_port *port,
+			      u32 *dev_id, u32 *hw_id, u16 *fp_id);
+int prestera_hw_port_state_set(const struct prestera_port *port,
+			       bool admin_state);
+int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu);
+int prestera_hw_port_mtu_get(const struct prestera_port *port, u32 *mtu);
+int prestera_hw_port_mac_set(const struct prestera_port *port, const char *mac);
+int prestera_hw_port_mac_get(const struct prestera_port *port, char *mac);
+int prestera_hw_port_cap_get(const struct prestera_port *port,
+			     struct prestera_port_caps *caps);
+int prestera_hw_port_autoneg_set(const struct prestera_port *port,
+				 bool autoneg, u64 link_modes, u8 fec);
+int prestera_hw_port_stats_get(const struct prestera_port *port,
+			       struct prestera_port_stats *stats);
+
+/* Event handlers */
+int prestera_hw_event_handler_register(struct prestera_switch *sw,
+				       enum prestera_event_type type,
+				       prestera_event_cb_t fn,
+				       void *arg);
+void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
+					  enum prestera_event_type type,
+					  prestera_event_cb_t fn);
+
+/* RX/TX */
+int prestera_hw_rxtx_init(struct prestera_switch *sw,
+			  struct prestera_rxtx_params *params);
+int prestera_hw_rxtx_port_init(struct prestera_port *port);
+
+#endif /* _PRESTERA_HW_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
new file mode 100644
index 000000000000..eb695e2ebda3
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -0,0 +1,521 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/etherdevice.h>
+#include <linux/jiffies.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/netdev_features.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_rxtx.h"
+
+#define PRESTERA_MTU_DEFAULT	1536
+
+#define PRESTERA_STATS_DELAY_MS	1000
+
+#define PRESTERA_MAC_ADDR_NUM_MAX	255
+
+static struct workqueue_struct *prestera_wq;
+
+struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
+						 u32 dev_id, u32 hw_id)
+{
+	struct prestera_port *port = NULL;
+
+	read_lock(&sw->port_list_lock);
+	list_for_each_entry(port, &sw->port_list, list) {
+		if (port->dev_id == dev_id && port->hw_id == hw_id)
+			break;
+	}
+	read_unlock(&sw->port_list_lock);
+
+	return port;
+}
+
+static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
+						u32 id)
+{
+	struct prestera_port *port = NULL;
+
+	read_lock(&sw->port_list_lock);
+	list_for_each_entry(port, &sw->port_list, list) {
+		if (port->id == id)
+			break;
+	}
+	read_unlock(&sw->port_list_lock);
+
+	return port;
+}
+
+static int prestera_port_open(struct net_device *dev)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	int err;
+
+	err = prestera_hw_port_state_set(port, true);
+	if (err)
+		return err;
+
+	netif_start_queue(dev);
+
+	return 0;
+}
+
+static int prestera_port_close(struct net_device *dev)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	int err;
+
+	netif_stop_queue(dev);
+
+	err = prestera_hw_port_state_set(port, false);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	return prestera_rxtx_xmit(netdev_priv(dev), skb);
+}
+
+static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
+{
+	if (!is_valid_ether_addr(addr))
+		return -EADDRNOTAVAIL;
+
+	/* firmware requires that port's MAC address contains first 5 bytes
+	 * of the base MAC address
+	 */
+	if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int prestera_port_set_mac_address(struct net_device *dev, void *p)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct sockaddr *addr = p;
+	int err;
+
+	err = prestera_is_valid_mac_addr(port, addr->sa_data);
+	if (err)
+		return err;
+
+	err = prestera_hw_port_mac_set(port, addr->sa_data);
+	if (err)
+		return err;
+
+	ether_addr_copy(dev->dev_addr, addr->sa_data);
+
+	return 0;
+}
+
+static int prestera_port_change_mtu(struct net_device *dev, int mtu)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	int err;
+
+	err = prestera_hw_port_mtu_set(port, mtu);
+	if (err)
+		return err;
+
+	dev->mtu = mtu;
+
+	return 0;
+}
+
+static void prestera_port_get_stats64(struct net_device *dev,
+				      struct rtnl_link_stats64 *stats)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_port_stats *port_stats = &port->cached_hw_stats.stats;
+
+	stats->rx_packets = port_stats->broadcast_frames_received +
+				port_stats->multicast_frames_received +
+				port_stats->unicast_frames_received;
+
+	stats->tx_packets = port_stats->broadcast_frames_sent +
+				port_stats->multicast_frames_sent +
+				port_stats->unicast_frames_sent;
+
+	stats->rx_bytes = port_stats->good_octets_received;
+
+	stats->tx_bytes = port_stats->good_octets_sent;
+
+	stats->rx_errors = port_stats->rx_error_frame_received;
+	stats->tx_errors = port_stats->mac_trans_error;
+
+	stats->rx_dropped = port_stats->buffer_overrun;
+	stats->tx_dropped = 0;
+
+	stats->multicast = port_stats->multicast_frames_received;
+	stats->collisions = port_stats->excessive_collision;
+
+	stats->rx_crc_errors = port_stats->bad_crc;
+}
+
+static void prestera_port_get_hw_stats(struct prestera_port *port)
+{
+	prestera_hw_port_stats_get(port, &port->cached_hw_stats.stats);
+}
+
+static void prestera_port_stats_update(struct work_struct *work)
+{
+	struct prestera_port *port =
+		container_of(work, struct prestera_port,
+			     cached_hw_stats.caching_dw.work);
+
+	prestera_port_get_hw_stats(port);
+
+	queue_delayed_work(prestera_wq, &port->cached_hw_stats.caching_dw,
+			   msecs_to_jiffies(PRESTERA_STATS_DELAY_MS));
+}
+
+static const struct net_device_ops prestera_netdev_ops = {
+	.ndo_open = prestera_port_open,
+	.ndo_stop = prestera_port_close,
+	.ndo_start_xmit = prestera_port_xmit,
+	.ndo_change_mtu = prestera_port_change_mtu,
+	.ndo_get_stats64 = prestera_port_get_stats64,
+	.ndo_set_mac_address = prestera_port_set_mac_address,
+};
+
+static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
+				     u64 link_modes, u8 fec)
+{
+	bool refresh = false;
+	int err;
+
+	if (port->caps.type != PRESTERA_PORT_TYPE_TP)
+		return enable ? -EINVAL : 0;
+
+	if (port->adver_link_modes != link_modes || port->adver_fec != fec) {
+		port->adver_fec = fec ?: BIT(PRESTERA_PORT_FEC_OFF);
+		port->adver_link_modes = link_modes;
+		refresh = true;
+	}
+
+	if (port->autoneg == enable && !(port->autoneg && refresh))
+		return 0;
+
+	err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
+					   port->adver_fec);
+	if (err)
+		return err;
+
+	port->autoneg = enable;
+
+	return 0;
+}
+
+static void prestera_port_list_add(struct prestera_port *port)
+{
+	write_lock(&port->sw->port_list_lock);
+	list_add(&port->list, &port->sw->port_list);
+	write_unlock(&port->sw->port_list_lock);
+}
+
+static void prestera_port_list_del(struct prestera_port *port)
+{
+	write_lock(&port->sw->port_list_lock);
+	list_del(&port->list);
+	write_unlock(&port->sw->port_list_lock);
+}
+
+static int prestera_port_create(struct prestera_switch *sw, u32 id)
+{
+	struct prestera_port *port;
+	struct net_device *dev;
+	int err;
+
+	dev = alloc_etherdev(sizeof(*port));
+	if (!dev)
+		return -ENOMEM;
+
+	port = netdev_priv(dev);
+
+	port->dev = dev;
+	port->id = id;
+	port->sw = sw;
+
+	err = prestera_hw_port_info_get(port, &port->dev_id, &port->hw_id,
+					&port->fp_id);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
+		goto err_port_init;
+	}
+
+	dev->features |= NETIF_F_NETNS_LOCAL;
+	dev->netdev_ops = &prestera_netdev_ops;
+
+	netif_carrier_off(dev);
+
+	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
+	dev->min_mtu = sw->mtu_min;
+	dev->max_mtu = sw->mtu_max;
+
+	err = prestera_hw_port_mtu_set(port, dev->mtu);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to set port(%u) mtu(%d)\n",
+			id, dev->mtu);
+		goto err_port_init;
+	}
+
+	if (port->fp_id >= PRESTERA_MAC_ADDR_NUM_MAX)
+		goto err_port_init;
+
+	/* firmware requires that port's MAC address consist of the first
+	 * 5 bytes of the base MAC address
+	 */
+	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
+	dev->dev_addr[dev->addr_len - 1] = port->fp_id;
+
+	err = prestera_hw_port_mac_set(port, dev->dev_addr);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to set port(%u) mac addr\n", id);
+		goto err_port_init;
+	}
+
+	err = prestera_hw_port_cap_get(port, &port->caps);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to get port(%u) caps\n", id);
+		goto err_port_init;
+	}
+
+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
+	prestera_port_autoneg_set(port, true, port->caps.supp_link_modes,
+				  port->caps.supp_fec);
+
+	err = prestera_hw_port_state_set(port, false);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to set port(%u) down\n", id);
+		goto err_port_init;
+	}
+
+	err = prestera_rxtx_port_init(port);
+	if (err)
+		goto err_port_init;
+
+	INIT_DELAYED_WORK(&port->cached_hw_stats.caching_dw,
+			  &prestera_port_stats_update);
+
+	prestera_port_list_add(port);
+
+	err = register_netdev(dev);
+	if (err)
+		goto err_register_netdev;
+
+	return 0;
+
+err_register_netdev:
+	prestera_port_list_del(port);
+err_port_init:
+	free_netdev(dev);
+	return err;
+}
+
+static void prestera_port_destroy(struct prestera_port *port)
+{
+	struct net_device *dev = port->dev;
+
+	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
+	unregister_netdev(dev);
+	prestera_port_list_del(port);
+	free_netdev(dev);
+}
+
+static void prestera_destroy_ports(struct prestera_switch *sw)
+{
+	struct prestera_port *port, *tmp;
+
+	list_for_each_entry_safe(port, tmp, &sw->port_list, list)
+		prestera_port_destroy(port);
+}
+
+static int prestera_create_ports(struct prestera_switch *sw)
+{
+	struct prestera_port *port, *tmp;
+	u32 port_idx;
+	int err;
+
+	for (port_idx = 0; port_idx < sw->port_count; port_idx++) {
+		err = prestera_port_create(sw, port_idx);
+		if (err)
+			goto err_port_create;
+	}
+
+	return 0;
+
+err_port_create:
+	list_for_each_entry_safe(port, tmp, &sw->port_list, list)
+		prestera_port_destroy(port);
+
+	return err;
+}
+
+static void prestera_port_handle_event(struct prestera_switch *sw,
+				       struct prestera_event *evt, void *arg)
+{
+	struct delayed_work *caching_dw;
+	struct prestera_port *port;
+
+	port = prestera_find_port(sw, evt->port_evt.port_id);
+	if (!port || !port->dev)
+		return;
+
+	caching_dw = &port->cached_hw_stats.caching_dw;
+
+	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED) {
+		if (evt->port_evt.data.oper_state) {
+			netif_carrier_on(port->dev);
+			if (!delayed_work_pending(caching_dw))
+				queue_delayed_work(prestera_wq, caching_dw, 0);
+		} else {
+			netif_carrier_off(port->dev);
+			if (delayed_work_pending(caching_dw))
+				cancel_delayed_work(caching_dw);
+		}
+	}
+}
+
+static int prestera_event_handlers_register(struct prestera_switch *sw)
+{
+	return prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_PORT,
+						  prestera_port_handle_event,
+						  NULL);
+}
+
+static void prestera_event_handlers_unregister(struct prestera_switch *sw)
+{
+	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_PORT,
+					     prestera_port_handle_event);
+}
+
+static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
+{
+	struct device_node *base_mac_np;
+	struct device_node *np;
+	const char *base_mac;
+
+	np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
+	base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
+
+	base_mac = of_get_mac_address(base_mac_np);
+	of_node_put(base_mac_np);
+	if (!IS_ERR(base_mac))
+		ether_addr_copy(sw->base_mac, base_mac);
+
+	if (!is_valid_ether_addr(sw->base_mac)) {
+		eth_random_addr(sw->base_mac);
+		dev_info(prestera_dev(sw), "using random base mac address\n");
+	}
+
+	return prestera_hw_switch_mac_set(sw, sw->base_mac);
+}
+
+static int prestera_switch_init(struct prestera_switch *sw)
+{
+	int err;
+
+	err = prestera_hw_switch_init(sw);
+	if (err) {
+		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
+		return err;
+	}
+
+	rwlock_init(&sw->port_list_lock);
+	INIT_LIST_HEAD(&sw->port_list);
+
+	err = prestera_switch_set_base_mac_addr(sw);
+	if (err)
+		return err;
+
+	err = prestera_rxtx_switch_init(sw);
+	if (err)
+		return err;
+
+	err = prestera_event_handlers_register(sw);
+	if (err)
+		goto err_handlers_register;
+
+	err = prestera_create_ports(sw);
+	if (err)
+		goto err_ports_create;
+
+	return 0;
+
+err_ports_create:
+	prestera_event_handlers_unregister(sw);
+err_handlers_register:
+	prestera_rxtx_switch_fini(sw);
+	prestera_hw_switch_fini(sw);
+
+	return err;
+}
+
+static void prestera_switch_fini(struct prestera_switch *sw)
+{
+	prestera_destroy_ports(sw);
+	prestera_event_handlers_unregister(sw);
+	prestera_rxtx_switch_fini(sw);
+	prestera_hw_switch_fini(sw);
+}
+
+int prestera_device_register(struct prestera_device *dev)
+{
+	struct prestera_switch *sw;
+	int err;
+
+	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	if (!sw)
+		return -ENOMEM;
+
+	dev->priv = sw;
+	sw->dev = dev;
+
+	err = prestera_switch_init(sw);
+	if (err) {
+		kfree(sw);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(prestera_device_register);
+
+void prestera_device_unregister(struct prestera_device *dev)
+{
+	struct prestera_switch *sw = dev->priv;
+
+	prestera_switch_fini(sw);
+	kfree(sw);
+}
+EXPORT_SYMBOL(prestera_device_unregister);
+
+static int __init prestera_module_init(void)
+{
+	prestera_wq = alloc_workqueue("prestera", 0, 0);
+	if (!prestera_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit prestera_module_exit(void)
+{
+	destroy_workqueue(prestera_wq);
+}
+
+module_init(prestera_module_init);
+module_exit(prestera_module_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("Marvell Prestera switch driver");
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
new file mode 100644
index 000000000000..2a13c318048c
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -0,0 +1,820 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/bitfield.h>
+#include <linux/dmapool.h>
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "prestera_dsa.h"
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_rxtx.h"
+
+#define PRESTERA_SDMA_WAIT_MUL		10
+
+struct prestera_sdma_desc {
+	__le32 word1;
+	__le32 word2;
+	__le32 buff;
+	__le32 next;
+} __packed __aligned(16);
+
+#define PRESTERA_SDMA_BUFF_SIZE_MAX	1544
+
+#define PRESTERA_SDMA_RX_DESC_PKT_LEN(desc) \
+	((le32_to_cpu((desc)->word2) >> 16) & GENMASK(13, 0))
+
+#define PRESTERA_SDMA_RX_DESC_OWNER(desc) \
+	((le32_to_cpu((desc)->word1) & BIT(31)) >> 31)
+
+#define PRESTERA_SDMA_RX_DESC_IS_RCVD(desc) \
+	(PRESTERA_SDMA_RX_DESC_OWNER(desc) == PRESTERA_SDMA_RX_DESC_CPU_OWN)
+
+#define PRESTERA_SDMA_RX_DESC_CPU_OWN	0
+#define PRESTERA_SDMA_RX_DESC_DMA_OWN	1
+
+#define PRESTERA_SDMA_RX_QUEUE_NUM	8
+
+#define PRESTERA_SDMA_RX_DESC_PER_Q	1000
+
+#define PRESTERA_SDMA_TX_DESC_PER_Q	1000
+#define PRESTERA_SDMA_TX_MAX_BURST	64
+
+#define PRESTERA_SDMA_TX_DESC_OWNER(desc) \
+	((le32_to_cpu((desc)->word1) & BIT(31)) >> 31)
+
+#define PRESTERA_SDMA_TX_DESC_CPU_OWN	0
+#define PRESTERA_SDMA_TX_DESC_DMA_OWN	1U
+
+#define PRESTERA_SDMA_TX_DESC_IS_SENT(desc) \
+	(PRESTERA_SDMA_TX_DESC_OWNER(desc) == PRESTERA_SDMA_TX_DESC_CPU_OWN)
+
+#define PRESTERA_SDMA_TX_DESC_LAST	BIT(20)
+#define PRESTERA_SDMA_TX_DESC_FIRST	BIT(21)
+#define PRESTERA_SDMA_TX_DESC_CALC_CRC	BIT(12)
+
+#define PRESTERA_SDMA_TX_DESC_SINGLE	\
+	(PRESTERA_SDMA_TX_DESC_FIRST | PRESTERA_SDMA_TX_DESC_LAST)
+
+#define PRESTERA_SDMA_TX_DESC_INIT	\
+	(PRESTERA_SDMA_TX_DESC_SINGLE | PRESTERA_SDMA_TX_DESC_CALC_CRC)
+
+#define PRESTERA_SDMA_RX_INTR_MASK_REG		0x2814
+#define PRESTERA_SDMA_RX_QUEUE_STATUS_REG	0x2680
+#define PRESTERA_SDMA_RX_QUEUE_DESC_REG(n)	(0x260C + (n) * 16)
+
+#define PRESTERA_SDMA_TX_QUEUE_DESC_REG		0x26C0
+#define PRESTERA_SDMA_TX_QUEUE_START_REG	0x2868
+
+struct prestera_sdma_buf {
+	struct prestera_sdma_desc *desc;
+	dma_addr_t desc_dma;
+	struct sk_buff *skb;
+	dma_addr_t buf_dma;
+	bool is_used;
+};
+
+struct prestera_rx_ring {
+	struct prestera_sdma_buf *bufs;
+	int next_rx;
+};
+
+struct prestera_tx_ring {
+	struct prestera_sdma_buf *bufs;
+	int next_tx;
+	int max_burst;
+	int burst;
+};
+
+struct prestera_sdma {
+	struct prestera_rx_ring rx_ring[PRESTERA_SDMA_RX_QUEUE_NUM];
+	struct prestera_tx_ring tx_ring;
+	struct prestera_switch *sw;
+	struct dma_pool *desc_pool;
+	struct work_struct tx_work;
+	struct napi_struct rx_napi;
+	struct net_device napi_dev;
+	u32 map_addr;
+	u64 dma_mask;
+	/* protect SDMA with concurrrent access from multiple CPUs */
+	spinlock_t tx_lock;
+};
+
+struct prestera_rxtx {
+	struct prestera_sdma sdma;
+};
+
+static int prestera_sdma_buf_init(struct prestera_sdma *sdma,
+				  struct prestera_sdma_buf *buf)
+{
+	struct prestera_sdma_desc *desc;
+	dma_addr_t dma;
+
+	desc = dma_pool_alloc(sdma->desc_pool, GFP_DMA | GFP_KERNEL, &dma);
+	if (!desc)
+		return -ENOMEM;
+
+	buf->buf_dma = DMA_MAPPING_ERROR;
+	buf->desc_dma = dma;
+	buf->desc = desc;
+	buf->skb = NULL;
+
+	return 0;
+}
+
+static u32 prestera_sdma_map(struct prestera_sdma *sdma, dma_addr_t pa)
+{
+	return sdma->map_addr + pa;
+}
+
+static void prestera_sdma_rx_desc_init(struct prestera_sdma *sdma,
+				       struct prestera_sdma_desc *desc,
+				       dma_addr_t buf)
+{
+	u32 word = le32_to_cpu(desc->word2);
+
+	u32p_replace_bits(&word, PRESTERA_SDMA_BUFF_SIZE_MAX, GENMASK(15, 0));
+	desc->word2 = cpu_to_le32(word);
+
+	desc->buff = cpu_to_le32(prestera_sdma_map(sdma, buf));
+
+	/* make sure buffer is set before reset the descriptor */
+	wmb();
+
+	desc->word1 = cpu_to_le32(0xA0000000);
+}
+
+static void prestera_sdma_rx_desc_set_next(struct prestera_sdma *sdma,
+					   struct prestera_sdma_desc *desc,
+					   dma_addr_t next)
+{
+	desc->next = cpu_to_le32(prestera_sdma_map(sdma, next));
+}
+
+static int prestera_sdma_rx_skb_alloc(struct prestera_sdma *sdma,
+				      struct prestera_sdma_buf *buf)
+{
+	struct device *dev = sdma->sw->dev->dev;
+	struct sk_buff *skb;
+	dma_addr_t dma;
+
+	skb = alloc_skb(PRESTERA_SDMA_BUFF_SIZE_MAX, GFP_DMA | GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	dma = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, dma))
+		goto err_dma_map;
+
+	if (buf->skb)
+		dma_unmap_single(dev, buf->buf_dma, buf->skb->len,
+				 DMA_FROM_DEVICE);
+
+	buf->buf_dma = dma;
+	buf->skb = skb;
+
+	return 0;
+
+err_dma_map:
+	kfree_skb(skb);
+
+	return -ENOMEM;
+}
+
+static struct sk_buff *prestera_sdma_rx_skb_get(struct prestera_sdma *sdma,
+						struct prestera_sdma_buf *buf)
+{
+	dma_addr_t buf_dma = buf->buf_dma;
+	struct sk_buff *skb = buf->skb;
+	u32 len = skb->len;
+	int err;
+
+	err = prestera_sdma_rx_skb_alloc(sdma, buf);
+	if (err) {
+		buf->buf_dma = buf_dma;
+		buf->skb = skb;
+
+		skb = alloc_skb(skb->len, GFP_ATOMIC);
+		if (skb) {
+			skb_put(skb, len);
+			skb_copy_from_linear_data(buf->skb, skb->data, len);
+		}
+	}
+
+	prestera_sdma_rx_desc_init(sdma, buf->desc, buf->buf_dma);
+
+	return skb;
+}
+
+static int prestera_rxtx_process_skb(struct prestera_sdma *sdma,
+				     struct sk_buff *skb)
+{
+	const struct prestera_port *port;
+	struct prestera_dsa dsa;
+	u32 hw_port, dev_id;
+	int err;
+
+	skb_pull(skb, ETH_HLEN);
+
+	/* ethertype field is part of the dsa header */
+	err = prestera_dsa_parse(&dsa, skb->data - ETH_TLEN);
+	if (err)
+		return err;
+
+	dev_id = dsa.hw_dev_num;
+	hw_port = dsa.port_num;
+
+	port = prestera_port_find_by_hwid(sdma->sw, dev_id, hw_port);
+	if (unlikely(!port)) {
+		dev_warn_ratelimited(prestera_dev(sdma->sw), "received pkt for non-existent port(%u, %u)\n",
+				     dev_id, hw_port);
+		return -ENOENT;
+	}
+
+	if (unlikely(!pskb_may_pull(skb, PRESTERA_DSA_HLEN)))
+		return -EINVAL;
+
+	/* remove DSA tag and update checksum */
+	skb_pull_rcsum(skb, PRESTERA_DSA_HLEN);
+
+	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - PRESTERA_DSA_HLEN,
+		ETH_ALEN * 2);
+
+	skb_push(skb, ETH_HLEN);
+
+	skb->protocol = eth_type_trans(skb, port->dev);
+
+	if (dsa.vlan.is_tagged) {
+		u16 tci = dsa.vlan.vid & VLAN_VID_MASK;
+
+		tci |= dsa.vlan.vpt << VLAN_PRIO_SHIFT;
+		if (dsa.vlan.cfi_bit)
+			tci |= VLAN_CFI_MASK;
+
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tci);
+	}
+
+	return 0;
+}
+
+static int prestera_sdma_next_rx_buf_idx(int buf_idx)
+{
+	return (buf_idx + 1) % PRESTERA_SDMA_RX_DESC_PER_Q;
+}
+
+static int prestera_sdma_rx_poll(struct napi_struct *napi, int budget)
+{
+	int qnum = PRESTERA_SDMA_RX_QUEUE_NUM;
+	unsigned int rxq_done_map = 0;
+	struct prestera_sdma *sdma;
+	struct list_head rx_list;
+	unsigned int qmask;
+	int pkts_done = 0;
+	int q;
+
+	qnum = PRESTERA_SDMA_RX_QUEUE_NUM;
+	qmask = GENMASK(qnum - 1, 0);
+
+	INIT_LIST_HEAD(&rx_list);
+
+	sdma = container_of(napi, struct prestera_sdma, rx_napi);
+
+	while (pkts_done < budget && rxq_done_map != qmask) {
+		for (q = 0; q < qnum && pkts_done < budget; q++) {
+			struct prestera_rx_ring *ring = &sdma->rx_ring[q];
+			struct prestera_sdma_desc *desc;
+			struct prestera_sdma_buf *buf;
+			int buf_idx = ring->next_rx;
+			struct sk_buff *skb;
+
+			buf = &ring->bufs[buf_idx];
+			desc = buf->desc;
+
+			if (PRESTERA_SDMA_RX_DESC_IS_RCVD(desc)) {
+				rxq_done_map &= ~BIT(q);
+			} else {
+				rxq_done_map |= BIT(q);
+				continue;
+			}
+
+			pkts_done++;
+
+			__skb_trim(buf->skb, PRESTERA_SDMA_RX_DESC_PKT_LEN(desc));
+
+			skb = prestera_sdma_rx_skb_get(sdma, buf);
+			if (!skb)
+				goto rx_next_buf;
+
+			if (unlikely(prestera_rxtx_process_skb(sdma, skb)))
+				goto rx_next_buf;
+
+			list_add_tail(&skb->list, &rx_list);
+rx_next_buf:
+			ring->next_rx = prestera_sdma_next_rx_buf_idx(buf_idx);
+		}
+	}
+
+	if (pkts_done < budget && napi_complete_done(napi, pkts_done))
+		prestera_write(sdma->sw, PRESTERA_SDMA_RX_INTR_MASK_REG,
+			       GENMASK(9, 2));
+
+	netif_receive_skb_list(&rx_list);
+
+	return pkts_done;
+}
+
+static void prestera_sdma_rx_fini(struct prestera_sdma *sdma)
+{
+	int qnum = PRESTERA_SDMA_RX_QUEUE_NUM;
+	int q, b;
+
+	/* disable all rx queues */
+	prestera_write(sdma->sw, PRESTERA_SDMA_RX_QUEUE_STATUS_REG,
+		       GENMASK(15, 8));
+
+	for (q = 0; q < qnum; q++) {
+		struct prestera_rx_ring *ring = &sdma->rx_ring[q];
+
+		if (!ring->bufs)
+			break;
+
+		for (b = 0; b < PRESTERA_SDMA_RX_DESC_PER_Q; b++) {
+			struct prestera_sdma_buf *buf = &ring->bufs[b];
+
+			if (buf->desc_dma)
+				dma_pool_free(sdma->desc_pool, buf->desc,
+					      buf->desc_dma);
+
+			if (!buf->skb)
+				continue;
+
+			if (buf->buf_dma != DMA_MAPPING_ERROR)
+				dma_unmap_single(sdma->sw->dev->dev,
+						 buf->buf_dma, buf->skb->len,
+						 DMA_FROM_DEVICE);
+			kfree_skb(buf->skb);
+		}
+	}
+}
+
+static int prestera_sdma_rx_init(struct prestera_sdma *sdma)
+{
+	int bnum = PRESTERA_SDMA_RX_DESC_PER_Q;
+	int qnum = PRESTERA_SDMA_RX_QUEUE_NUM;
+	int err;
+	int q;
+
+	/* disable all rx queues */
+	prestera_write(sdma->sw, PRESTERA_SDMA_RX_QUEUE_STATUS_REG,
+		       GENMASK(15, 8));
+
+	for (q = 0; q < qnum; q++) {
+		struct prestera_sdma_buf *head, *tail, *next, *prev;
+		struct prestera_rx_ring *ring = &sdma->rx_ring[q];
+
+		ring->bufs = kmalloc_array(bnum, sizeof(*head), GFP_KERNEL);
+		if (!ring->bufs)
+			return -ENOMEM;
+
+		ring->next_rx = 0;
+
+		tail = &ring->bufs[bnum - 1];
+		head = &ring->bufs[0];
+		next = head;
+		prev = next;
+
+		do {
+			err = prestera_sdma_buf_init(sdma, next);
+			if (err)
+				return err;
+
+			err = prestera_sdma_rx_skb_alloc(sdma, next);
+			if (err)
+				return err;
+
+			prestera_sdma_rx_desc_init(sdma, next->desc,
+						   next->buf_dma);
+
+			prestera_sdma_rx_desc_set_next(sdma, prev->desc,
+						       next->desc_dma);
+
+			prev = next;
+			next++;
+		} while (prev != tail);
+
+		/* join tail with head to make a circular list */
+		prestera_sdma_rx_desc_set_next(sdma, tail->desc, head->desc_dma);
+
+		prestera_write(sdma->sw, PRESTERA_SDMA_RX_QUEUE_DESC_REG(q),
+			       prestera_sdma_map(sdma, head->desc_dma));
+	}
+
+	/* make sure all rx descs are filled before enabling all rx queues */
+	wmb();
+
+	prestera_write(sdma->sw, PRESTERA_SDMA_RX_QUEUE_STATUS_REG,
+		       GENMASK(7, 0));
+
+	return 0;
+}
+
+static void prestera_sdma_tx_desc_init(struct prestera_sdma *sdma,
+				       struct prestera_sdma_desc *desc)
+{
+	desc->word1 = cpu_to_le32(PRESTERA_SDMA_TX_DESC_INIT);
+	desc->word2 = 0;
+}
+
+static void prestera_sdma_tx_desc_set_next(struct prestera_sdma *sdma,
+					   struct prestera_sdma_desc *desc,
+					   dma_addr_t next)
+{
+	desc->next = cpu_to_le32(prestera_sdma_map(sdma, next));
+}
+
+static void prestera_sdma_tx_desc_set_buf(struct prestera_sdma *sdma,
+					  struct prestera_sdma_desc *desc,
+					  dma_addr_t buf, size_t len)
+{
+	u32 word = le32_to_cpu(desc->word2);
+
+	u32p_replace_bits(&word, len + ETH_FCS_LEN, GENMASK(30, 16));
+
+	desc->buff = cpu_to_le32(prestera_sdma_map(sdma, buf));
+	desc->word2 = cpu_to_le32(word);
+}
+
+static void prestera_sdma_tx_desc_xmit(struct prestera_sdma_desc *desc)
+{
+	u32 word = le32_to_cpu(desc->word1);
+
+	word |= PRESTERA_SDMA_TX_DESC_DMA_OWN << 31;
+
+	/* make sure everything is written before enable xmit */
+	wmb();
+
+	desc->word1 = cpu_to_le32(word);
+}
+
+static int prestera_sdma_tx_buf_map(struct prestera_sdma *sdma,
+				    struct prestera_sdma_buf *buf,
+				    struct sk_buff *skb)
+{
+	struct device *dma_dev = sdma->sw->dev->dev;
+	dma_addr_t dma;
+
+	dma = dma_map_single(dma_dev, skb->data, skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dma_dev, dma))
+		return -ENOMEM;
+
+	buf->buf_dma = dma;
+	buf->skb = skb;
+
+	return 0;
+}
+
+static void prestera_sdma_tx_buf_unmap(struct prestera_sdma *sdma,
+				       struct prestera_sdma_buf *buf)
+{
+	struct device *dma_dev = sdma->sw->dev->dev;
+
+	dma_unmap_single(dma_dev, buf->buf_dma, buf->skb->len, DMA_TO_DEVICE);
+}
+
+static void prestera_sdma_tx_recycle_work_fn(struct work_struct *work)
+{
+	int bnum = PRESTERA_SDMA_TX_DESC_PER_Q;
+	struct prestera_tx_ring *tx_ring;
+	struct prestera_sdma *sdma;
+	int b;
+
+	sdma = container_of(work, struct prestera_sdma, tx_work);
+
+	tx_ring = &sdma->tx_ring;
+
+	for (b = 0; b < bnum; b++) {
+		struct prestera_sdma_buf *buf = &tx_ring->bufs[b];
+
+		if (!buf->is_used)
+			continue;
+
+		if (!PRESTERA_SDMA_TX_DESC_IS_SENT(buf->desc))
+			continue;
+
+		prestera_sdma_tx_buf_unmap(sdma, buf);
+		dev_consume_skb_any(buf->skb);
+		buf->skb = NULL;
+
+		/* make sure everything is cleaned up */
+		wmb();
+
+		buf->is_used = false;
+	}
+}
+
+static int prestera_sdma_tx_init(struct prestera_sdma *sdma)
+{
+	struct prestera_sdma_buf *head, *tail, *next, *prev;
+	struct prestera_tx_ring *tx_ring = &sdma->tx_ring;
+	int bnum = PRESTERA_SDMA_TX_DESC_PER_Q;
+	int err;
+
+	INIT_WORK(&sdma->tx_work, prestera_sdma_tx_recycle_work_fn);
+	spin_lock_init(&sdma->tx_lock);
+
+	tx_ring->bufs = kmalloc_array(bnum, sizeof(*head), GFP_KERNEL);
+	if (!tx_ring->bufs)
+		return -ENOMEM;
+
+	tail = &tx_ring->bufs[bnum - 1];
+	head = &tx_ring->bufs[0];
+	next = head;
+	prev = next;
+
+	tx_ring->max_burst = PRESTERA_SDMA_TX_MAX_BURST;
+	tx_ring->burst = tx_ring->max_burst;
+	tx_ring->next_tx = 0;
+
+	do {
+		err = prestera_sdma_buf_init(sdma, next);
+		if (err)
+			return err;
+
+		next->is_used = false;
+
+		prestera_sdma_tx_desc_init(sdma, next->desc);
+
+		prestera_sdma_tx_desc_set_next(sdma, prev->desc,
+					       next->desc_dma);
+
+		prev = next;
+		next++;
+	} while (prev != tail);
+
+	/* join tail with head to make a circular list */
+	prestera_sdma_tx_desc_set_next(sdma, tail->desc, head->desc_dma);
+
+	/* make sure descriptors are written */
+	wmb();
+
+	prestera_write(sdma->sw, PRESTERA_SDMA_TX_QUEUE_DESC_REG,
+		       prestera_sdma_map(sdma, head->desc_dma));
+
+	return 0;
+}
+
+static void prestera_sdma_tx_fini(struct prestera_sdma *sdma)
+{
+	struct prestera_tx_ring *ring = &sdma->tx_ring;
+	int bnum = PRESTERA_SDMA_TX_DESC_PER_Q;
+	int b;
+
+	cancel_work_sync(&sdma->tx_work);
+
+	if (!ring->bufs)
+		return;
+
+	for (b = 0; b < bnum; b++) {
+		struct prestera_sdma_buf *buf = &ring->bufs[b];
+
+		if (buf->desc)
+			dma_pool_free(sdma->desc_pool, buf->desc,
+				      buf->desc_dma);
+
+		if (!buf->skb)
+			continue;
+
+		dma_unmap_single(sdma->sw->dev->dev, buf->buf_dma,
+				 buf->skb->len, DMA_TO_DEVICE);
+
+		dev_consume_skb_any(buf->skb);
+	}
+}
+
+static void prestera_rxtx_handle_event(struct prestera_switch *sw,
+				       struct prestera_event *evt,
+				       void *arg)
+{
+	struct prestera_sdma *sdma = arg;
+
+	if (evt->id != PRESTERA_RXTX_EVENT_RCV_PKT)
+		return;
+
+	prestera_write(sdma->sw, PRESTERA_SDMA_RX_INTR_MASK_REG, 0);
+	napi_schedule(&sdma->rx_napi);
+}
+
+static int prestera_sdma_switch_init(struct prestera_switch *sw)
+{
+	struct prestera_sdma *sdma = &sw->rxtx->sdma;
+	struct device *dev = sw->dev->dev;
+	struct prestera_rxtx_params p;
+	int err;
+
+	p.use_sdma = true;
+
+	err = prestera_hw_rxtx_init(sw, &p);
+	if (err) {
+		dev_err(dev, "failed to init rxtx by hw\n");
+		return err;
+	}
+
+	sdma->dma_mask = dma_get_mask(dev);
+	sdma->map_addr = p.map_addr;
+	sdma->sw = sw;
+
+	sdma->desc_pool = dma_pool_create("desc_pool", dev,
+					  sizeof(struct prestera_sdma_desc),
+					  16, 0);
+	if (!sdma->desc_pool)
+		return -ENOMEM;
+
+	err = prestera_sdma_rx_init(sdma);
+	if (err) {
+		dev_err(dev, "failed to init rx ring\n");
+		goto err_rx_init;
+	}
+
+	err = prestera_sdma_tx_init(sdma);
+	if (err) {
+		dev_err(dev, "failed to init tx ring\n");
+		goto err_tx_init;
+	}
+
+	err = prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_RXTX,
+						 prestera_rxtx_handle_event,
+						 sdma);
+	if (err)
+		goto err_evt_register;
+
+	init_dummy_netdev(&sdma->napi_dev);
+
+	netif_napi_add(&sdma->napi_dev, &sdma->rx_napi, prestera_sdma_rx_poll, 64);
+	napi_enable(&sdma->rx_napi);
+
+	return 0;
+
+err_evt_register:
+err_tx_init:
+	prestera_sdma_tx_fini(sdma);
+err_rx_init:
+	prestera_sdma_rx_fini(sdma);
+
+	dma_pool_destroy(sdma->desc_pool);
+	return err;
+}
+
+static void prestera_sdma_switch_fini(struct prestera_switch *sw)
+{
+	struct prestera_sdma *sdma = &sw->rxtx->sdma;
+
+	napi_disable(&sdma->rx_napi);
+	netif_napi_del(&sdma->rx_napi);
+	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_RXTX,
+					     prestera_rxtx_handle_event);
+	prestera_sdma_tx_fini(sdma);
+	prestera_sdma_rx_fini(sdma);
+	dma_pool_destroy(sdma->desc_pool);
+}
+
+static bool prestera_sdma_is_ready(struct prestera_sdma *sdma)
+{
+	return !(prestera_read(sdma->sw, PRESTERA_SDMA_TX_QUEUE_START_REG) & 1);
+}
+
+static int prestera_sdma_tx_wait(struct prestera_sdma *sdma,
+				 struct prestera_tx_ring *tx_ring)
+{
+	int tx_wait_num = PRESTERA_SDMA_WAIT_MUL * tx_ring->max_burst;
+
+	do {
+		if (prestera_sdma_is_ready(sdma))
+			return 0;
+
+		udelay(1);
+	} while (--tx_wait_num);
+
+	return -EBUSY;
+}
+
+static void prestera_sdma_tx_start(struct prestera_sdma *sdma)
+{
+	prestera_write(sdma->sw, PRESTERA_SDMA_TX_QUEUE_START_REG, 1);
+	schedule_work(&sdma->tx_work);
+}
+
+static netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma,
+				      struct sk_buff *skb)
+{
+	struct device *dma_dev = sdma->sw->dev->dev;
+	struct net_device *dev = skb->dev;
+	struct prestera_tx_ring *tx_ring;
+	struct prestera_sdma_buf *buf;
+	int err;
+
+	spin_lock(&sdma->tx_lock);
+
+	tx_ring = &sdma->tx_ring;
+
+	buf = &tx_ring->bufs[tx_ring->next_tx];
+	if (buf->is_used) {
+		schedule_work(&sdma->tx_work);
+		goto drop_skb;
+	}
+
+	if (unlikely(eth_skb_pad(skb)))
+		goto drop_skb_nofree;
+
+	err = prestera_sdma_tx_buf_map(sdma, buf, skb);
+	if (err)
+		goto drop_skb;
+
+	prestera_sdma_tx_desc_set_buf(sdma, buf->desc, buf->buf_dma, skb->len);
+
+	dma_sync_single_for_device(dma_dev, buf->buf_dma, skb->len,
+				   DMA_TO_DEVICE);
+
+	if (tx_ring->burst) {
+		tx_ring->burst--;
+	} else {
+		tx_ring->burst = tx_ring->max_burst;
+
+		err = prestera_sdma_tx_wait(sdma, tx_ring);
+		if (err)
+			goto drop_skb_unmap;
+	}
+
+	tx_ring->next_tx = (tx_ring->next_tx + 1) % PRESTERA_SDMA_TX_DESC_PER_Q;
+	prestera_sdma_tx_desc_xmit(buf->desc);
+	buf->is_used = true;
+
+	prestera_sdma_tx_start(sdma);
+
+	goto tx_done;
+
+drop_skb_unmap:
+	prestera_sdma_tx_buf_unmap(sdma, buf);
+drop_skb:
+	dev_consume_skb_any(skb);
+drop_skb_nofree:
+	dev->stats.tx_dropped++;
+tx_done:
+	spin_unlock(&sdma->tx_lock);
+	return NETDEV_TX_OK;
+}
+
+int prestera_rxtx_switch_init(struct prestera_switch *sw)
+{
+	struct prestera_rxtx *rxtx;
+
+	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
+	if (!rxtx)
+		return -ENOMEM;
+
+	sw->rxtx = rxtx;
+
+	return prestera_sdma_switch_init(sw);
+}
+
+void prestera_rxtx_switch_fini(struct prestera_switch *sw)
+{
+	prestera_sdma_switch_fini(sw);
+	kfree(sw->rxtx);
+}
+
+int prestera_rxtx_port_init(struct prestera_port *port)
+{
+	int err;
+
+	err = prestera_hw_rxtx_port_init(port);
+	if (err)
+		return err;
+
+	port->dev->needed_headroom = PRESTERA_DSA_HLEN;
+
+	return 0;
+}
+
+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)
+{
+	struct prestera_dsa dsa;
+
+	dsa.hw_dev_num = port->dev_id;
+	dsa.port_num = port->hw_id;
+
+	if (skb_cow_head(skb, PRESTERA_DSA_HLEN) < 0)
+		return NET_XMIT_DROP;
+
+	skb_push(skb, PRESTERA_DSA_HLEN);
+	memmove(skb->data, skb->data + PRESTERA_DSA_HLEN, 2 * ETH_ALEN);
+
+	if (prestera_dsa_build(&dsa, skb->data + 2 * ETH_ALEN) != 0)
+		return NET_XMIT_DROP;
+
+	return prestera_sdma_xmit(&port->sw->rxtx->sdma, skb);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
new file mode 100644
index 000000000000..882a1225c323
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_RXTX_H_
+#define _PRESTERA_RXTX_H_
+
+#include <linux/netdevice.h>
+
+struct prestera_switch;
+struct prestera_port;
+
+int prestera_rxtx_switch_init(struct prestera_switch *sw);
+void prestera_rxtx_switch_fini(struct prestera_switch *sw);
+
+int prestera_rxtx_port_init(struct prestera_port *port);
+
+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);
+
+#endif /* _PRESTERA_RXTX_H_ */
-- 
2.17.1

