Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F5A265003
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgIJT6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:58:45 -0400
Received: from mail-eopbgr60110.outbound.protection.outlook.com ([40.107.6.110]:16487
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730655AbgIJPCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:02:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOxX0Wp97XHb/MKkEGX+wLnIg1yZdEoUZ2QGaawx3s5ao9qy8CUzzthJvI9hPDSJz+Pn7PMlJTBMekx+foGAYpFuz7ZW4lrZIg0OIGbYSv6umNq2rNewG6chxrnH/Eq4XRa5Syoy8zYX28d+QAk/Rz3PSIEKVq1zK+y2GBRdyzG1VixDe0y6CCx0wXtg4szb20wrg4FPD0Yez0gKaOCX/sVQubtE5PnzFXPubjel0XJ/ntRTKFTlZR7LMrmOO+PN8wzI0W3+6po9e86U4Y0Tfgh5FftlV5kc8/R4/DB0klhFZLOpwlmQ4Utti6Q6V8oolWmIEooQM41bAKNipxNguw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lwz1qZ3uUqx148WqzUfJaqb+cCT8zDwWOB6hqRreea8=;
 b=YE83ZWCRWNkMUZMB5OOG7SAJIKw9k5C2vLqKg2Za7OBwtzmd5FqKYIVX6mLfJY9yAhQfvj0PK4lRDsOBhoFTacxx4x4w+p28jLsYFo/jbjBfzOd5fLx2a52TbhZHLGZN5f0LUYdzzEP6QJ3lPR0g9l1V/pPZ8W3PAsjWi6iGSZ1Vd9+2QfnJQdOxZ+mA+XMsZan9QQPBK07PBWAnmKLgNQV+w7JS8AaN/N7HD9NUihkpLghpCEo+H2ogV1z6KlYJ8E/f2aCxJaS4DfoceHKeGy8UVmfPYubsWPh74HwouwOZhpuQYY1UB0h38vsqAH3eHze5L2WalgdOFvZGooZ5OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lwz1qZ3uUqx148WqzUfJaqb+cCT8zDwWOB6hqRreea8=;
 b=yN3V6SiHu1SD5/ezFQV8keMX+53YyBPPtOUVi338vNFVjCHi5e6fU2cuYP2gRv+tvA5SAIMcH7Esq0qxm0ouM19JGrA6rN+exbiZ0+8CdNES2Z0skHtPNw783go2GmZ3+luCg1TXaefGAClSA6wGn7CctkPlQ6cKGIQhYz9M748=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.19; Thu, 10 Sep 2020 15:01:22 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 15:01:22 +0000
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
Subject: [net-next v8 2/6] net: marvell: prestera: Add PCI interface support
Date:   Thu, 10 Sep 2020 18:00:51 +0300
Message-Id: <20200910150055.15598-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910150055.15598-1-vadym.kochan@plvision.eu>
References: <20200910150055.15598-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::19) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.10 via Frontend Transport; Thu, 10 Sep 2020 15:01:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54dc9ffb-5d98-4556-1a9d-08d8559a5fb0
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB045982101B743155A8DE1F5495270@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:356;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9mbuimXLyegPA7FCC7m/0oTYsKLO2/dLi9jAj4gzbe4oNQ6w2/Jsl8Rz1Hn6K16DMc5cPBAdoUJ2s+FJ/BH3s9Xp/A/k2jRRoWHEK85FQzyfI3wGFGa13MFZSd1RgS2Ydb6Dqy8gVmcxawhrBRr9hIkB79frEXp06DDgcPb7ma90LWS9GfJz7pTNRsIdxghgeajVbU9wrXw+f8xB1ky5mxbTyI1XGR9lNxhrdoaVqVubQvtNyErnWzB5sI/GKOIf1FtJfgPGNccl4qeCwVZEg9MenwQnXhsRgRRdPm/w8+ep1ccFGpFyBYK/rBddZCQqdQmsqGiJTuThmZdHHQXuOahyeHetGy9G+n9pIaJQRBvmWnxmzwDxydnfRgcR4SHc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(366004)(376002)(26005)(2906002)(8936002)(110136005)(186003)(16526019)(8676002)(2616005)(83380400001)(44832011)(4326008)(66556008)(66946007)(54906003)(66476007)(30864003)(1076003)(6506007)(5660300002)(6666004)(107886003)(956004)(6486002)(478600001)(86362001)(316002)(6512007)(36756003)(52116002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: I6F/lKQeVVMPQ6f1LySjMdS0+7B8Le0/quRf+gGZr1tW/G+GnTza8kNTYUzYAB7xpUaez5JrFt7crr4PXleGNt+RnHKWcKiU22M5TDlMW/qdiMrPJfDVWPMTP1d/UJUKmaZY2siOQR3sA2S31dPVDp5RiFFRrW1GwMUvnrwW6mvnREMfSmeupG9Qg30azr0GB3Nw72QoaAXcIgCqbRcQsPFpUNLZhxfH76LUi52K04C/elWfqokvPvRHzKEkrQJOcE0nlT7zl3phT4Z6KP67LPZ2yidT2Vj/lAMrqvv+LY0NVN1WHJfyXWtaWtfTpGOATfAvDn5PoocIjqDXeh0chvEXOAkTQj7bgbEyQEdh8pgaXXXueMxFFJ/4qZZf/9B2/9eqD9fh3UPSqZPr1kesMOCy8HH8qXhCox9zwAWjx8FUy0PilWP/L7NIRkNjhnoq0AL2LFaYyH7FLHWr7Rb0TQbfeLqujyz+G1oGHlat78Wx8oU2obxrsbmwLC5cH6HGYTnIugZRecaOwAWXA5bxQp6fGWRBrx1ttgIJBBJRRMPXMzD/IZ3X+pJ5ZA+JgXVOgAefi4tG96VwxWcdrKqB/lRYCJctzYsJMhS7w/0h/qjzQzx6K4geKey61OBvNwkbwo8DVcK/vdVPEY3pwp9CXw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 54dc9ffb-5d98-4556-1a9d-08d8559a5fb0
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 15:01:19.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kS1g5d1Mp5bYTnm4RURlqb0kNYcPEnXPRaMpnPPsy6LSP7SAZ0QWP8Alu/mGSiDOF7Vb3/uzHIaFEooFIgeJaNYGS0bdYY7/0t29wR8huPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PCI interface driver for Prestera Switch ASICs family devices, which
provides:

    - Firmware loading mechanism
    - Requests & events handling to/from the firmware
    - Access to the firmware on the bus level

The firmware has to be loaded each time the device is reset. The driver
is loading it from:

    /lib/firmware/mrvl/prestera/mvsw_prestera_fw-v{MAJOR}.{MINOR}.img

The full firmware image version is located within the internal header
and consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
hard-coded minimum supported firmware version which it can work with:

    MAJOR - reflects the support on ABI level between driver and loaded
            firmware, this number should be the same for driver and loaded
            firmware.

    MINOR - this is the minimum supported version between driver and the
            firmware.

    PATCH - indicates only fixes, firmware ABI is not changed.

Firmware image file name contains only MAJOR and MINOR numbers to make
driver be compatible with any PATCH version.

Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
PATCH v8:
    1) Sort includes.

    2) Add missing comma for last enum member

    3) Return original error code from last called func
       in places where instead other error code was used.

    4) Use MSEC_PER_SEC instead of hard-coded 1000.

    5) Remove 'if (status != PRESTERA_LDR_STATUS_START_FW)' by passing the 'state'
       through the 'switch (state)' block.

    6) Use common 'out_release' goto label for release_firmware().

PATCH v5:
    1) Remove not-needed packed & aligned attributes

    2) Convert 'u8 *' to 'void *' on path when handling/calling send_req/recv_msg
       callback. This allows to remove not-needed 'u8 *' casting.

    3) Use USEC_PER_MSEC as multiplier when converting ms -> usec on calling
       readl_poll_timeout.

    4) Removed pci_dev member from prestera_fw, there is already 'struct
       prestera_dev' which holds pointer to 'struct device'.

    5) Replace pci_err (added in the previous patch) by dev_err.

PATCH v4:
    1) Get rid of "packed" attribute for the fw image header, it is
       already aligned.

    2) Cleanup not needed initialization of variables which are used in
       readl_poll_timeout() helpers.

    3) Replace #define's of prestera_{fw,ldr}_{read,write} to static funcs.

    4) Use pcim_ helpers for resource allocation

    5) Use devm_zalloc() for struct prestera_fw instance allocation.

    6) Use module_pci_driver(prestera_pci_driver) instead of module_{init,exit}.

    7) Use _MS prefix for timeout #define's.

    8) Use snprintf for firmware image path generation instead of using
       macrosses.

    9) Use memcpy_xxxio helpers for IO memory copying.

   10) By default use same build type ('m' or 'y') for
       CONFIG_PRESTERA_PCI which is used by CONFIG_PRESTERA.

 drivers/net/ethernet/marvell/prestera/Kconfig |  11 +
 .../net/ethernet/marvell/prestera/Makefile    |   2 +
 .../ethernet/marvell/prestera/prestera_pci.c  | 769 ++++++++++++++++++
 3 files changed, 782 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c

diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
index 76b68613ea7a..2a5945c455cc 100644
--- a/drivers/net/ethernet/marvell/prestera/Kconfig
+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
@@ -11,3 +11,14 @@ config PRESTERA
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called prestera.
+
+config PRESTERA_PCI
+	tristate "PCI interface driver for Marvell Prestera Switch ASICs family"
+	depends on PCI && HAS_IOMEM && PRESTERA
+	default PRESTERA
+	help
+	  This is implementation of PCI interface support for Marvell Prestera
+	  Switch ASICs family.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called prestera_pci.
diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 610d75032b78..2146714eab21 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -2,3 +2,5 @@
 obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
 			   prestera_rxtx.o
+
+obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
new file mode 100644
index 000000000000..1b97adae542e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -0,0 +1,769 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/circ_buf.h>
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "prestera.h"
+
+#define PRESTERA_MSG_MAX_SIZE 1500
+
+#define PRESTERA_SUPP_FW_MAJ_VER	2
+#define PRESTERA_SUPP_FW_MIN_VER	0
+
+#define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
+
+#define PRESTERA_FW_HDR_MAGIC		0x351D9D06
+#define PRESTERA_FW_DL_TIMEOUT_MS	50000
+#define PRESTERA_FW_BLK_SZ		1024
+
+#define PRESTERA_FW_VER_MAJ_MUL 1000000
+#define PRESTERA_FW_VER_MIN_MUL 1000
+
+#define PRESTERA_FW_VER_MAJ(v)	((v) / PRESTERA_FW_VER_MAJ_MUL)
+
+#define PRESTERA_FW_VER_MIN(v) \
+	(((v) - (PRESTERA_FW_VER_MAJ(v) * PRESTERA_FW_VER_MAJ_MUL)) / \
+			PRESTERA_FW_VER_MIN_MUL)
+
+#define PRESTERA_FW_VER_PATCH(v) \
+	((v) - (PRESTERA_FW_VER_MAJ(v) * PRESTERA_FW_VER_MAJ_MUL) - \
+			(PRESTERA_FW_VER_MIN(v) * PRESTERA_FW_VER_MIN_MUL))
+
+enum prestera_pci_bar_t {
+	PRESTERA_PCI_BAR_FW = 2,
+	PRESTERA_PCI_BAR_PP = 4,
+};
+
+struct prestera_fw_header {
+	__be32 magic_number;
+	__be32 version_value;
+	u8 reserved[8];
+};
+
+struct prestera_ldr_regs {
+	u32 ldr_ready;
+	u32 pad1;
+
+	u32 ldr_img_size;
+	u32 ldr_ctl_flags;
+
+	u32 ldr_buf_offs;
+	u32 ldr_buf_size;
+
+	u32 ldr_buf_rd;
+	u32 pad2;
+	u32 ldr_buf_wr;
+
+	u32 ldr_status;
+};
+
+#define PRESTERA_LDR_REG_OFFSET(f)	offsetof(struct prestera_ldr_regs, f)
+
+#define PRESTERA_LDR_READY_MAGIC	0xf00dfeed
+
+#define PRESTERA_LDR_STATUS_IMG_DL	BIT(0)
+#define PRESTERA_LDR_STATUS_START_FW	BIT(1)
+#define PRESTERA_LDR_STATUS_INVALID_IMG	BIT(2)
+#define PRESTERA_LDR_STATUS_NOMEM	BIT(3)
+
+#define PRESTERA_LDR_REG_BASE(fw)	((fw)->ldr_regs)
+#define PRESTERA_LDR_REG_ADDR(fw, reg)	(PRESTERA_LDR_REG_BASE(fw) + (reg))
+
+/* fw loader registers */
+#define PRESTERA_LDR_READY_REG		PRESTERA_LDR_REG_OFFSET(ldr_ready)
+#define PRESTERA_LDR_IMG_SIZE_REG	PRESTERA_LDR_REG_OFFSET(ldr_img_size)
+#define PRESTERA_LDR_CTL_REG		PRESTERA_LDR_REG_OFFSET(ldr_ctl_flags)
+#define PRESTERA_LDR_BUF_SIZE_REG	PRESTERA_LDR_REG_OFFSET(ldr_buf_size)
+#define PRESTERA_LDR_BUF_OFFS_REG	PRESTERA_LDR_REG_OFFSET(ldr_buf_offs)
+#define PRESTERA_LDR_BUF_RD_REG		PRESTERA_LDR_REG_OFFSET(ldr_buf_rd)
+#define PRESTERA_LDR_BUF_WR_REG		PRESTERA_LDR_REG_OFFSET(ldr_buf_wr)
+#define PRESTERA_LDR_STATUS_REG		PRESTERA_LDR_REG_OFFSET(ldr_status)
+
+#define PRESTERA_LDR_CTL_DL_START	BIT(0)
+
+#define PRESTERA_EVT_QNUM_MAX	4
+
+struct prestera_fw_evtq_regs {
+	u32 rd_idx;
+	u32 pad1;
+	u32 wr_idx;
+	u32 pad2;
+	u32 offs;
+	u32 len;
+};
+
+struct prestera_fw_regs {
+	u32 fw_ready;
+	u32 pad;
+	u32 cmd_offs;
+	u32 cmd_len;
+	u32 evt_offs;
+	u32 evt_qnum;
+
+	u32 cmd_req_ctl;
+	u32 cmd_req_len;
+	u32 cmd_rcv_ctl;
+	u32 cmd_rcv_len;
+
+	u32 fw_status;
+	u32 rx_status;
+
+	struct prestera_fw_evtq_regs evtq_list[PRESTERA_EVT_QNUM_MAX];
+};
+
+#define PRESTERA_FW_REG_OFFSET(f)	offsetof(struct prestera_fw_regs, f)
+
+#define PRESTERA_FW_READY_MAGIC		0xcafebabe
+
+/* fw registers */
+#define PRESTERA_FW_READY_REG		PRESTERA_FW_REG_OFFSET(fw_ready)
+
+#define PRESTERA_CMD_BUF_OFFS_REG	PRESTERA_FW_REG_OFFSET(cmd_offs)
+#define PRESTERA_CMD_BUF_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_len)
+#define PRESTERA_EVT_BUF_OFFS_REG	PRESTERA_FW_REG_OFFSET(evt_offs)
+#define PRESTERA_EVT_QNUM_REG		PRESTERA_FW_REG_OFFSET(evt_qnum)
+
+#define PRESTERA_CMD_REQ_CTL_REG	PRESTERA_FW_REG_OFFSET(cmd_req_ctl)
+#define PRESTERA_CMD_REQ_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_req_len)
+
+#define PRESTERA_CMD_RCV_CTL_REG	PRESTERA_FW_REG_OFFSET(cmd_rcv_ctl)
+#define PRESTERA_CMD_RCV_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_rcv_len)
+#define PRESTERA_FW_STATUS_REG		PRESTERA_FW_REG_OFFSET(fw_status)
+#define PRESTERA_RX_STATUS_REG		PRESTERA_FW_REG_OFFSET(rx_status)
+
+/* PRESTERA_CMD_REQ_CTL_REG flags */
+#define PRESTERA_CMD_F_REQ_SENT		BIT(0)
+#define PRESTERA_CMD_F_REPL_RCVD	BIT(1)
+
+/* PRESTERA_CMD_RCV_CTL_REG flags */
+#define PRESTERA_CMD_F_REPL_SENT	BIT(0)
+
+#define PRESTERA_EVTQ_REG_OFFSET(q, f)			\
+	(PRESTERA_FW_REG_OFFSET(evtq_list) +		\
+	 (q) * sizeof(struct prestera_fw_evtq_regs) +	\
+	 offsetof(struct prestera_fw_evtq_regs, f))
+
+#define PRESTERA_EVTQ_RD_IDX_REG(q)	PRESTERA_EVTQ_REG_OFFSET(q, rd_idx)
+#define PRESTERA_EVTQ_WR_IDX_REG(q)	PRESTERA_EVTQ_REG_OFFSET(q, wr_idx)
+#define PRESTERA_EVTQ_OFFS_REG(q)	PRESTERA_EVTQ_REG_OFFSET(q, offs)
+#define PRESTERA_EVTQ_LEN_REG(q)	PRESTERA_EVTQ_REG_OFFSET(q, len)
+
+#define PRESTERA_FW_REG_BASE(fw)	((fw)->dev.ctl_regs)
+#define PRESTERA_FW_REG_ADDR(fw, reg)	PRESTERA_FW_REG_BASE((fw)) + (reg)
+
+#define PRESTERA_FW_CMD_DEFAULT_WAIT_MS	30000
+#define PRESTERA_FW_READY_WAIT_MS	20000
+
+struct prestera_fw_evtq {
+	u8 __iomem *addr;
+	size_t len;
+};
+
+struct prestera_fw {
+	struct workqueue_struct *wq;
+	struct prestera_device dev;
+	u8 __iomem *ldr_regs;
+	u8 __iomem *ldr_ring_buf;
+	u32 ldr_buf_len;
+	u32 ldr_wr_idx;
+	struct mutex cmd_mtx; /* serialize access to dev->send_req */
+	size_t cmd_mbox_len;
+	u8 __iomem *cmd_mbox;
+	struct prestera_fw_evtq evt_queue[PRESTERA_EVT_QNUM_MAX];
+	u8 evt_qnum;
+	struct work_struct evt_work;
+	u8 __iomem *evt_buf;
+	u8 *evt_msg;
+};
+
+static int prestera_fw_load(struct prestera_fw *fw);
+
+static void prestera_fw_write(struct prestera_fw *fw, u32 reg, u32 val)
+{
+	writel(val, PRESTERA_FW_REG_ADDR(fw, reg));
+}
+
+static u32 prestera_fw_read(struct prestera_fw *fw, u32 reg)
+{
+	return readl(PRESTERA_FW_REG_ADDR(fw, reg));
+}
+
+static u32 prestera_fw_evtq_len(struct prestera_fw *fw, u8 qid)
+{
+	return fw->evt_queue[qid].len;
+}
+
+static u32 prestera_fw_evtq_avail(struct prestera_fw *fw, u8 qid)
+{
+	u32 wr_idx = prestera_fw_read(fw, PRESTERA_EVTQ_WR_IDX_REG(qid));
+	u32 rd_idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
+
+	return CIRC_CNT(wr_idx, rd_idx, prestera_fw_evtq_len(fw, qid));
+}
+
+static void prestera_fw_evtq_rd_set(struct prestera_fw *fw,
+				    u8 qid, u32 idx)
+{
+	u32 rd_idx = idx & (prestera_fw_evtq_len(fw, qid) - 1);
+
+	prestera_fw_write(fw, PRESTERA_EVTQ_RD_IDX_REG(qid), rd_idx);
+}
+
+static u8 __iomem *prestera_fw_evtq_buf(struct prestera_fw *fw, u8 qid)
+{
+	return fw->evt_queue[qid].addr;
+}
+
+static u32 prestera_fw_evtq_read32(struct prestera_fw *fw, u8 qid)
+{
+	u32 rd_idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
+	u32 val;
+
+	val = readl(prestera_fw_evtq_buf(fw, qid) + rd_idx);
+	prestera_fw_evtq_rd_set(fw, qid, rd_idx + 4);
+	return val;
+}
+
+static ssize_t prestera_fw_evtq_read_buf(struct prestera_fw *fw,
+					 u8 qid, void *buf, size_t len)
+{
+	u32 idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
+	u8 __iomem *evtq_addr = prestera_fw_evtq_buf(fw, qid);
+	u32 *buf32 = buf;
+	int i;
+
+	for (i = 0; i < len / 4; buf32++, i++) {
+		*buf32 = readl_relaxed(evtq_addr + idx);
+		idx = (idx + 4) & (prestera_fw_evtq_len(fw, qid) - 1);
+	}
+
+	prestera_fw_evtq_rd_set(fw, qid, idx);
+
+	return i;
+}
+
+static u8 prestera_fw_evtq_pick(struct prestera_fw *fw)
+{
+	int qid;
+
+	for (qid = 0; qid < fw->evt_qnum; qid++) {
+		if (prestera_fw_evtq_avail(fw, qid) >= 4)
+			return qid;
+	}
+
+	return PRESTERA_EVT_QNUM_MAX;
+}
+
+static void prestera_fw_evt_work_fn(struct work_struct *work)
+{
+	struct prestera_fw *fw;
+	void *msg;
+	u8 qid;
+
+	fw = container_of(work, struct prestera_fw, evt_work);
+	msg = fw->evt_msg;
+
+	while ((qid = prestera_fw_evtq_pick(fw)) < PRESTERA_EVT_QNUM_MAX) {
+		u32 idx;
+		u32 len;
+
+		len = prestera_fw_evtq_read32(fw, qid);
+		idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
+
+		WARN_ON(prestera_fw_evtq_avail(fw, qid) < len);
+
+		if (WARN_ON(len > PRESTERA_MSG_MAX_SIZE)) {
+			prestera_fw_evtq_rd_set(fw, qid, idx + len);
+			continue;
+		}
+
+		prestera_fw_evtq_read_buf(fw, qid, msg, len);
+
+		if (fw->dev.recv_msg)
+			fw->dev.recv_msg(&fw->dev, msg, len);
+	}
+}
+
+static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
+				  unsigned int waitms)
+{
+	u8 __iomem *addr = PRESTERA_FW_REG_ADDR(fw, reg);
+	u32 val;
+
+	return readl_poll_timeout(addr, val, cmp == val,
+				  1 * USEC_PER_MSEC, waitms * USEC_PER_MSEC);
+}
+
+static int prestera_fw_cmd_send(struct prestera_fw *fw,
+				void *in_msg, size_t in_size,
+				void *out_msg, size_t out_size,
+				unsigned int waitms)
+{
+	u32 ret_size;
+	int err;
+
+	if (!waitms)
+		waitms = PRESTERA_FW_CMD_DEFAULT_WAIT_MS;
+
+	if (ALIGN(in_size, 4) > fw->cmd_mbox_len)
+		return -EMSGSIZE;
+
+	/* wait for finish previous reply from FW */
+	err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG, 0, 30);
+	if (err) {
+		dev_err(fw->dev.dev, "finish reply from FW is timed out\n");
+		return err;
+	}
+
+	prestera_fw_write(fw, PRESTERA_CMD_REQ_LEN_REG, in_size);
+	memcpy_toio(fw->cmd_mbox, in_msg, in_size);
+
+	prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REQ_SENT);
+
+	/* wait for reply from FW */
+	err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG,
+				     PRESTERA_CMD_F_REPL_SENT, waitms);
+	if (err) {
+		dev_err(fw->dev.dev, "reply from FW is timed out\n");
+		goto cmd_exit;
+	}
+
+	ret_size = prestera_fw_read(fw, PRESTERA_CMD_RCV_LEN_REG);
+	if (ret_size > out_size) {
+		dev_err(fw->dev.dev, "ret_size (%u) > out_len(%zu)\n",
+			ret_size, out_size);
+		err = -EMSGSIZE;
+		goto cmd_exit;
+	}
+
+	memcpy_fromio(out_msg, fw->cmd_mbox + in_size, ret_size);
+
+cmd_exit:
+	prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REPL_RCVD);
+	return err;
+}
+
+static int prestera_fw_send_req(struct prestera_device *dev,
+				void *in_msg, size_t in_size, void *out_msg,
+				size_t out_size, unsigned int waitms)
+{
+	struct prestera_fw *fw;
+	ssize_t ret;
+
+	fw = container_of(dev, struct prestera_fw, dev);
+
+	mutex_lock(&fw->cmd_mtx);
+	ret = prestera_fw_cmd_send(fw, in_msg, in_size, out_msg, out_size, waitms);
+	mutex_unlock(&fw->cmd_mtx);
+
+	return ret;
+}
+
+static int prestera_fw_init(struct prestera_fw *fw)
+{
+	u8 __iomem *base;
+	int err;
+	u8 qid;
+
+	fw->dev.send_req = prestera_fw_send_req;
+	fw->ldr_regs = fw->dev.ctl_regs;
+
+	err = prestera_fw_load(fw);
+	if (err)
+		return err;
+
+	err = prestera_fw_wait_reg32(fw, PRESTERA_FW_READY_REG,
+				     PRESTERA_FW_READY_MAGIC,
+				     PRESTERA_FW_READY_WAIT_MS);
+	if (err) {
+		dev_err(fw->dev.dev, "FW failed to start\n");
+		return err;
+	}
+
+	base = fw->dev.ctl_regs;
+
+	fw->cmd_mbox = base + prestera_fw_read(fw, PRESTERA_CMD_BUF_OFFS_REG);
+	fw->cmd_mbox_len = prestera_fw_read(fw, PRESTERA_CMD_BUF_LEN_REG);
+	mutex_init(&fw->cmd_mtx);
+
+	fw->evt_buf = base + prestera_fw_read(fw, PRESTERA_EVT_BUF_OFFS_REG);
+	fw->evt_qnum = prestera_fw_read(fw, PRESTERA_EVT_QNUM_REG);
+	fw->evt_msg = kmalloc(PRESTERA_MSG_MAX_SIZE, GFP_KERNEL);
+	if (!fw->evt_msg)
+		return -ENOMEM;
+
+	for (qid = 0; qid < fw->evt_qnum; qid++) {
+		u32 offs = prestera_fw_read(fw, PRESTERA_EVTQ_OFFS_REG(qid));
+		struct prestera_fw_evtq *evtq = &fw->evt_queue[qid];
+
+		evtq->len = prestera_fw_read(fw, PRESTERA_EVTQ_LEN_REG(qid));
+		evtq->addr = fw->evt_buf + offs;
+	}
+
+	return 0;
+}
+
+static void prestera_fw_uninit(struct prestera_fw *fw)
+{
+	kfree(fw->evt_msg);
+}
+
+static irqreturn_t prestera_pci_irq_handler(int irq, void *dev_id)
+{
+	struct prestera_fw *fw = dev_id;
+
+	if (prestera_fw_read(fw, PRESTERA_RX_STATUS_REG)) {
+		prestera_fw_write(fw, PRESTERA_RX_STATUS_REG, 0);
+
+		if (fw->dev.recv_pkt)
+			fw->dev.recv_pkt(&fw->dev);
+	}
+
+	queue_work(fw->wq, &fw->evt_work);
+
+	return IRQ_HANDLED;
+}
+
+static void prestera_ldr_write(struct prestera_fw *fw, u32 reg, u32 val)
+{
+	writel(val, PRESTERA_LDR_REG_ADDR(fw, reg));
+}
+
+static u32 prestera_ldr_read(struct prestera_fw *fw, u32 reg)
+{
+	return readl(PRESTERA_LDR_REG_ADDR(fw, reg));
+}
+
+static int prestera_ldr_wait_reg32(struct prestera_fw *fw,
+				   u32 reg, u32 cmp, unsigned int waitms)
+{
+	u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, reg);
+	u32 val;
+
+	return readl_poll_timeout(addr, val, cmp == val,
+				  10 * USEC_PER_MSEC, waitms * USEC_PER_MSEC);
+}
+
+static u32 prestera_ldr_wait_buf(struct prestera_fw *fw, size_t len)
+{
+	u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, PRESTERA_LDR_BUF_RD_REG);
+	u32 buf_len = fw->ldr_buf_len;
+	u32 wr_idx = fw->ldr_wr_idx;
+	u32 rd_idx;
+
+	return readl_poll_timeout(addr, rd_idx,
+				 CIRC_SPACE(wr_idx, rd_idx, buf_len) >= len,
+				 1 * USEC_PER_MSEC, 100 * USEC_PER_MSEC);
+}
+
+static int prestera_ldr_wait_dl_finish(struct prestera_fw *fw)
+{
+	u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, PRESTERA_LDR_STATUS_REG);
+	unsigned long mask = ~(PRESTERA_LDR_STATUS_IMG_DL);
+	u32 val;
+	int err;
+
+	err = readl_poll_timeout(addr, val, val & mask, 10 * USEC_PER_MSEC,
+				 PRESTERA_FW_DL_TIMEOUT_MS * USEC_PER_MSEC);
+	if (err) {
+		dev_err(fw->dev.dev, "Timeout to load FW img [state=%d]",
+			prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG));
+		return err;
+	}
+
+	return 0;
+}
+
+static void prestera_ldr_wr_idx_move(struct prestera_fw *fw, unsigned int n)
+{
+	fw->ldr_wr_idx = (fw->ldr_wr_idx + (n)) & (fw->ldr_buf_len - 1);
+}
+
+static void prestera_ldr_wr_idx_commit(struct prestera_fw *fw)
+{
+	prestera_ldr_write(fw, PRESTERA_LDR_BUF_WR_REG, fw->ldr_wr_idx);
+}
+
+static u8 __iomem *prestera_ldr_wr_ptr(struct prestera_fw *fw)
+{
+	return fw->ldr_ring_buf + fw->ldr_wr_idx;
+}
+
+static int prestera_ldr_send(struct prestera_fw *fw, const u8 *buf, size_t len)
+{
+	int err;
+	int i;
+
+	err = prestera_ldr_wait_buf(fw, len);
+	if (err) {
+		dev_err(fw->dev.dev, "failed wait for sending firmware\n");
+		return err;
+	}
+
+	for (i = 0; i < len; i += 4) {
+		writel_relaxed(*(u32 *)(buf + i), prestera_ldr_wr_ptr(fw));
+		prestera_ldr_wr_idx_move(fw, 4);
+	}
+
+	prestera_ldr_wr_idx_commit(fw);
+	return 0;
+}
+
+static int prestera_ldr_fw_send(struct prestera_fw *fw,
+				const char *img, u32 fw_size)
+{
+	u32 status;
+	u32 pos;
+	int err;
+
+	err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_STATUS_REG,
+				      PRESTERA_LDR_STATUS_IMG_DL,
+				      5 * MSEC_PER_SEC);
+	if (err) {
+		dev_err(fw->dev.dev, "Loader is not ready to load image\n");
+		return err;
+	}
+
+	for (pos = 0; pos < fw_size; pos += PRESTERA_FW_BLK_SZ) {
+		if (pos + PRESTERA_FW_BLK_SZ > fw_size)
+			break;
+
+		err = prestera_ldr_send(fw, img + pos, PRESTERA_FW_BLK_SZ);
+		if (err)
+			return err;
+	}
+
+	if (pos < fw_size) {
+		err = prestera_ldr_send(fw, img + pos, fw_size - pos);
+		if (err)
+			return err;
+	}
+
+	err = prestera_ldr_wait_dl_finish(fw);
+	if (err)
+		return err;
+
+	status = prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG);
+
+	switch (status) {
+	case PRESTERA_LDR_STATUS_INVALID_IMG:
+		dev_err(fw->dev.dev, "FW img has bad CRC\n");
+		return -EINVAL;
+	case PRESTERA_LDR_STATUS_NOMEM:
+		dev_err(fw->dev.dev, "Loader has no enough mem\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void prestera_fw_rev_parse(const struct prestera_fw_header *hdr,
+				  struct prestera_fw_rev *rev)
+{
+	u32 version = be32_to_cpu(hdr->version_value);
+
+	rev->maj = PRESTERA_FW_VER_MAJ(version);
+	rev->min = PRESTERA_FW_VER_MIN(version);
+	rev->sub = PRESTERA_FW_VER_PATCH(version);
+}
+
+static int prestera_fw_rev_check(struct prestera_fw *fw)
+{
+	struct prestera_fw_rev *rev = &fw->dev.fw_rev;
+	u16 maj_supp = PRESTERA_SUPP_FW_MAJ_VER;
+	u16 min_supp = PRESTERA_SUPP_FW_MIN_VER;
+
+	if (rev->maj == maj_supp && rev->min >= min_supp)
+		return 0;
+
+	dev_err(fw->dev.dev, "Driver supports FW version only '%u.%u.x'",
+		PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
+
+	return -EINVAL;
+}
+
+static int prestera_fw_hdr_parse(struct prestera_fw *fw,
+				 const struct firmware *img)
+{
+	struct prestera_fw_header *hdr = (struct prestera_fw_header *)img->data;
+	struct prestera_fw_rev *rev = &fw->dev.fw_rev;
+	u32 magic;
+
+	magic = be32_to_cpu(hdr->magic_number);
+	if (magic != PRESTERA_FW_HDR_MAGIC) {
+		dev_err(fw->dev.dev, "FW img hdr magic is invalid");
+		return -EINVAL;
+	}
+
+	prestera_fw_rev_parse(hdr, rev);
+
+	dev_info(fw->dev.dev, "FW version '%u.%u.%u'\n",
+		 rev->maj, rev->min, rev->sub);
+
+	return prestera_fw_rev_check(fw);
+}
+
+static int prestera_fw_load(struct prestera_fw *fw)
+{
+	size_t hlen = sizeof(struct prestera_fw_header);
+	const struct firmware *f;
+	char fw_path[128];
+	int err;
+
+	err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_READY_REG,
+				      PRESTERA_LDR_READY_MAGIC,
+				      5 * MSEC_PER_SEC);
+	if (err) {
+		dev_err(fw->dev.dev, "waiting for FW loader is timed out");
+		return err;
+	}
+
+	fw->ldr_ring_buf = fw->ldr_regs +
+		prestera_ldr_read(fw, PRESTERA_LDR_BUF_OFFS_REG);
+
+	fw->ldr_buf_len =
+		prestera_ldr_read(fw, PRESTERA_LDR_BUF_SIZE_REG);
+
+	fw->ldr_wr_idx = 0;
+
+	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
+		 PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
+
+	err = request_firmware_direct(&f, fw_path, fw->dev.dev);
+	if (err) {
+		dev_err(fw->dev.dev, "failed to request firmware file\n");
+		return err;
+	}
+
+	err = prestera_fw_hdr_parse(fw, f);
+	if (err) {
+		dev_err(fw->dev.dev, "FW image header is invalid\n");
+		goto out_release;
+	}
+
+	prestera_ldr_write(fw, PRESTERA_LDR_IMG_SIZE_REG, f->size - hlen);
+	prestera_ldr_write(fw, PRESTERA_LDR_CTL_REG, PRESTERA_LDR_CTL_DL_START);
+
+	dev_info(fw->dev.dev, "Loading %s ...", fw_path);
+
+	err = prestera_ldr_fw_send(fw, f->data + hlen, f->size - hlen);
+
+out_release:
+	release_firmware(f);
+	return err;
+}
+
+static int prestera_pci_probe(struct pci_dev *pdev,
+			      const struct pci_device_id *id)
+{
+	const char *driver_name = pdev->driver->name;
+	struct prestera_fw *fw;
+	int err;
+
+	err = pcim_enable_device(pdev);
+	if (err)
+		return err;
+
+	err = pcim_iomap_regions(pdev, BIT(PRESTERA_PCI_BAR_FW) |
+				 BIT(PRESTERA_PCI_BAR_PP),
+				 pci_name(pdev));
+	if (err)
+		return err;
+
+	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30))) {
+		dev_err(&pdev->dev, "fail to set DMA mask\n");
+		goto err_dma_mask;
+	}
+
+	pci_set_master(pdev);
+
+	fw = devm_kzalloc(&pdev->dev, sizeof(*fw), GFP_KERNEL);
+	if (!fw) {
+		err = -ENOMEM;
+		goto err_pci_dev_alloc;
+	}
+
+	fw->dev.ctl_regs = pcim_iomap_table(pdev)[PRESTERA_PCI_BAR_FW];
+	fw->dev.pp_regs = pcim_iomap_table(pdev)[PRESTERA_PCI_BAR_PP];
+	fw->dev.dev = &pdev->dev;
+
+	pci_set_drvdata(pdev, fw);
+
+	err = prestera_fw_init(fw);
+	if (err)
+		goto err_prestera_fw_init;
+
+	dev_info(fw->dev.dev, "Prestera FW is ready\n");
+
+	fw->wq = alloc_workqueue("prestera_fw_wq", WQ_HIGHPRI, 1);
+	if (!fw->wq)
+		goto err_wq_alloc;
+
+	INIT_WORK(&fw->evt_work, prestera_fw_evt_work_fn);
+
+	err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
+	if (err < 0) {
+		dev_err(&pdev->dev, "MSI IRQ init failed\n");
+		goto err_irq_alloc;
+	}
+
+	err = request_irq(pci_irq_vector(pdev, 0), prestera_pci_irq_handler,
+			  0, driver_name, fw);
+	if (err) {
+		dev_err(&pdev->dev, "fail to request IRQ\n");
+		goto err_request_irq;
+	}
+
+	err = prestera_device_register(&fw->dev);
+	if (err)
+		goto err_prestera_dev_register;
+
+	return 0;
+
+err_prestera_dev_register:
+	free_irq(pci_irq_vector(pdev, 0), fw);
+err_request_irq:
+	pci_free_irq_vectors(pdev);
+err_irq_alloc:
+	destroy_workqueue(fw->wq);
+err_wq_alloc:
+	prestera_fw_uninit(fw);
+err_prestera_fw_init:
+err_pci_dev_alloc:
+err_dma_mask:
+	return err;
+}
+
+static void prestera_pci_remove(struct pci_dev *pdev)
+{
+	struct prestera_fw *fw = pci_get_drvdata(pdev);
+
+	prestera_device_unregister(&fw->dev);
+	free_irq(pci_irq_vector(pdev, 0), fw);
+	pci_free_irq_vectors(pdev);
+	destroy_workqueue(fw->wq);
+	prestera_fw_uninit(fw);
+}
+
+static const struct pci_device_id prestera_pci_devices[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
+
+static struct pci_driver prestera_pci_driver = {
+	.name     = "Prestera DX",
+	.id_table = prestera_pci_devices,
+	.probe    = prestera_pci_probe,
+	.remove   = prestera_pci_remove,
+};
+module_pci_driver(prestera_pci_driver);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
-- 
2.17.1

