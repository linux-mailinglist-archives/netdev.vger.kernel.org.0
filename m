Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9929C5A12E3
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiHYOCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiHYOCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:02:46 -0400
X-Greylist: delayed 1003 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Aug 2022 07:02:43 PDT
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B6A25F8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:02:43 -0700 (PDT)
Received: from 104.47.12.51_.trendmicro.com (unknown [172.21.9.121])
        by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 4B9BD1066141E
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 13:46:01 +0000 (UTC)
Received: from 104.47.12.51_.trendmicro.com (unknown [172.21.183.236])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 5438810000C35;
        Thu, 25 Aug 2022 13:45:57 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1661435156.640000
X-TM-MAIL-UUID: 9ae76555-aa90-424a-9c75-0c131aae03be
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (unknown [104.47.12.51])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 9C7741000219A;
        Thu, 25 Aug 2022 13:45:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENsY4CzqwRpt8AqUWCfCyGyOohRu5Q6Rj6/kcZjUKhHtnHejcOP62+8nlubLGis6ClKfBNB55kQ0Yl6GS5E72UGUjFTXxiV2uChivh2Yf46hbM+ES4V3PmJMRhek9vFS5vcgd6pO6X6sCHQwu3UzUdEMXZTRRZgD3HtVbGt/szUDKejcZhjrq3r0sIqz5IOlmV8QA4d1PQduQD+s7i0xMnaXv5h8EyfiZ6otLAMdmx1xPhYbLhtamHqXXgGrqko/4gXAxsRQp6cL0U00vA/n4Rl5y6vyo5QQflPGDyKA6gSEE9yMBJEVsVsv8AZf4Yv/SMaATWLUl65Jl8MPjsU2DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JuIiHBmtbqTzXdTs1RRal738zs6vd0DHyZurQgKmtA=;
 b=Kx5mR7yZuJkmwtbWyWqnKsGJmV06JI7iZurqBgBAxJD2AGIbF30MdMn20aLqMs5DzXVxdQMu8wCeCDSdYdZOCJ0hQHt3KJhvNSYPCsg/49Qa9LMo+UjKJjXmlmKEOoD6LGtHCxY9JB7qb5O6Xx+7dxxq/bJGE/7SrasoIAbWIOuTxWzFarl82CO+zqAyAMR3zH9ckjetM6AOr6MAY6VnMqjz15k1n6ZL4y9EVn9CCm+KAhBq481j44DpFtemDS9OzJUMYfqu05+OG8YV1UHoKKoJU/k6nkOQO6vKtVkH0iM4DGijJBiJSwyOxPNMmv0Jsov16pJ4lJMA9cc8n1VGkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=davemloft.net smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=opensynergy.com;
 dkim=none (message not signed); arc=none
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From:   Harald Mommer <harald.mommer@opensynergy.com>
To:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        Harald Mommer <hmo@opensynergy.com>
Subject: [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
Date:   Thu, 25 Aug 2022 15:44:49 +0200
Message-Id: <20220825134449.18803-1-harald.mommer@opensynergy.com>
X-Mailer: git-send-email 2.17.1
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 1b987422-57d3-48b2-14ef-08da86a021a0
X-MS-TrafficTypeDiagnostic: AM0PR04MB6673:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DkorD7r+tx07rpdD4H9ytqhVAcYR6V/4xaRUDMttpVhbVZzfL1sVrGmMAmWCBoQCZnyE0IIoZ1sJNUASkihpzgHJz9pILziZMwwnfb2aWCJZJFGDcPtRbLmESBjI6cgKHBkik3sTOIraZnd6riUUSn+Z45wYO4wz2n3wvIWxqWKLJkYje0VNuuYuiL2Yrx+x6oeamx/l1yP+VOdji50NFxd2GPLr6ZUAMS8QcJ7GJolV9b+zFImr4/rbUs80Q1DGGXFjvfGuFL8BaK75UIs4i1pbrlTsYzU8D9CSNd7uJkBSMNA7NxOQcUspPJWqN/baiJye6KbDV0xk+W19pSHIIaEJ/7JTxTCoTITCm5XgBG7GnPZ+nGH84ffUFAufzBihdqMxG2VPra0vsuPsC7UvOoAjG8DMtP9e2CBTLpwsee0H7qND934z2pFaLcNrjaNDbvAvA4MctjUu6QkYP0FAYHbTRhNE03gIWK/mLglrPbeZW9Angj7pbeog89P5wlDev85T4DofkQaH+XULH1oUxQzQ3ozDkM2PW8Wzhw16J4ID/gNDWWGv9MeNKt+un11E2ufwWa0TLF5+6HlYSC56Zm8sCRD7hxOJm0dsbR7CxVCu4NXQwzB+6KmDkVNGNHXjG5/lPXQaZSUH4OblCJv1mZpkG/DvyK5LnUeXHdVkV5vpYZRBascCUCxEfEdm3kYY4zV0Yzrm9AutWPed72AiYXot9UGtGgNOpg1CoR0QMb0KUDHizf8JSQ0zHEkqsEyyxtZAQY0A1ZDZltQg174wIktGCpIm9ola0Jd6gUiecYA=
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(376002)(39840400004)(46966006)(36840700001)(26005)(36860700001)(81166007)(36756003)(2906002)(54906003)(42186006)(40480700001)(82310400005)(47076005)(966005)(70586007)(70206006)(8936002)(8676002)(107886003)(316002)(86362001)(83380400001)(4326008)(1076003)(478600001)(186003)(30864003)(44832011)(2616005)(7416002)(41300700001)(336012)(5660300002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 13:45:54.2437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b987422-57d3-48b2-14ef-08da86a021a0
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT047.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6673
X-TM-AS-ERS: 104.47.12.51-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27098.007
X-TMASE-Result: 10--19.534700-4.000000
X-TMASE-MatchedRID: TE4dHEVTEOu18qyeZp2wHNMJkd+MUUHPNYERielKfYU6FHRWx2FGsI3c
        eRXYSJoDIvrftAIhWmLy9zcRSkKatcE/2QXpIuHmAoNa2r+Edw0pA2ExuipmWrgbJOZ434Bsi8x
        T7YmZq8voDfn0bnZVemjNIVYeqOZjbTSwI/A2DvCsxn4GpC3Y2hSez4ASfuupJE2iPpG+hctTdk
        r+Aa37ot5jAWwTkllvEFau+y4bQbBPjpYFYxeO72nmCQLJ/HnwZUc2QJCkRg09wWQKVyZA2zNV+
        wj8Pzk/ZkkDxkeGE+g7GjPXjKw7EGJMhG6REeCrHWoavqxg5/+OVGny5q72huuLH9BII+4qEKQb
        F+m73nFgU7c431azlV6O+iQoiTGDBhTyjewDKrKqFx2c/3V5cZfau+Sc1iUTvDGpIrQZI9Fj8i9
        T/sSpPOg7BvzleG0wPfRUVBjvSwtHpOxedoYx1jfGaXJF0/xzlKvhkP88iXQQRik6+J7XSUqDRJ
        PHI5slq3Lbgio2EzSeiDAFW6UJG+u5zgIdn2KixrDvUMltogT5UnqVnIHSz0rC8QVifx/bgn7s5
        SFzY/bCJ49XrPlFamTLdwFqSualDvX2Sk47fs+RgPzABkqxIJKhhQs+egPO5jRFf5v2CacIpjLe
        k0l1pd7pZASN2XIjfGBLxHGSBcKtEJK5xzxTLAuw+MVcHJpK0r0ZIDuBCXr44PEIh5jzGwK24nU
        iWOmUCzehW+3cHAeNhtBTSJWUr0lT9lfH/Xsbv8fLAX0P50BReWnUUdhI9V1d55ms0luCTAjTyZ
        wDuCXkc1biowcbUXJab6LpNN5T/VylaRgWcUJ+yskgwrfsCyH5xd1Wn9PCmyiLZetSf8m2IeO/u
        lJw0egL5WVEeE7IKXwXi1XHLoALbigRnpKlKT4yqD4LKu3A
X-TMASE-XGENCLOUD: 0bd23fc1-cb45-4734-8006-e2e257d1f522-0-0-200-0
X-TM-Deliver-Signature: B52BE09C69F4298FB8A9DDC5DAB12BCA
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1661435157;
        bh=LWlVZhsYgHU4kRKSr+dYVkjmlQOv40/opSsKYA7y4Bw=; l=39303;
        h=From:To:Date;
        b=bBIkh9+L4aehScZyb3/jNxcLfzkvQ9AWsuk1ui7bbnT2yJYLx5w7NVkoPq6TcUfzU
         rjAZBZncHxRf5xTe8Pg6RWkOg7+edmAFzG/WxpLHHC0L5QlUcUjrkvp9s2d3e7plHV
         l4RSll/Xjwmhmz9wHKMbVNd+qxNR7v8Wd1vQxuKWnKz/GKjO2FRdvuM5WJm4amGyCp
         hMf6Py47akx/w1srfBXRzHZhIYtJHuwOqd2+4/IoFWe+0B5DzvQ/y9g5A5fW3KCsq+
         UPb9DFLKgAG5S0RMeAavLi6tFnH3ioNcOklfBuE6f8Wlf6HkCjONR00N2XzMBPFJCF
         jufh3al4UnO0A==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- CAN Control

  - "ip link set up can0" starts the virtual CAN controller,
  - "ip link set up can0" stops the virtual CAN controller

- CAN RX

  Receive CAN frames. CAN frames can be standard or extended, classic or
  CAN FD. Classic CAN RTR frames are supported.

- CAN TX

  Send CAN frames. CAN frames can be standard or extended, classic or
  CAN FD. Classic CAN RTR frames are supported.

- CAN Event indication (BusOff)

  The bus off handling is considered code complete but until now bus off
  handling is largely untested.

Signed-off-by: Harald Mommer <hmo@opensynergy.com>
---
 drivers/net/can/Kconfig                 |    1 +
 drivers/net/can/Makefile                |    1 +
 drivers/net/can/virtio_can/Kconfig      |   12 +
 drivers/net/can/virtio_can/Makefile     |    5 +
 drivers/net/can/virtio_can/virtio_can.c | 1176 +++++++++++++++++++++++
 include/uapi/linux/virtio_can.h         |   69 ++
 6 files changed, 1264 insertions(+)
 create mode 100644 drivers/net/can/virtio_can/Kconfig
 create mode 100644 drivers/net/can/virtio_can/Makefile
 create mode 100644 drivers/net/can/virtio_can/virtio_can.c
 create mode 100644 include/uapi/linux/virtio_can.h

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 3048ad77edb3..432f5f15baaf 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -218,6 +218,7 @@ source "drivers/net/can/sja1000/Kconfig"
 source "drivers/net/can/softing/Kconfig"
 source "drivers/net/can/spi/Kconfig"
 source "drivers/net/can/usb/Kconfig"
+source "drivers/net/can/virtio_can/Kconfig"
 
 endif #CAN_NETLINK
 
diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 61c75ce9d500..93cfd1b03a35 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -31,5 +31,6 @@ obj-$(CONFIG_CAN_SUN4I)		+= sun4i_can.o
 obj-$(CONFIG_CAN_TI_HECC)	+= ti_hecc.o
 obj-$(CONFIG_CAN_XILINXCAN)	+= xilinx_can.o
 obj-$(CONFIG_PCH_CAN)		+= pch_can.o
+obj-$(CONFIG_CAN_VIRTIO_CAN)	+= virtio_can/
 
 subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) += -DDEBUG
diff --git a/drivers/net/can/virtio_can/Kconfig b/drivers/net/can/virtio_can/Kconfig
new file mode 100644
index 000000000000..ef8228fcc73e
--- /dev/null
+++ b/drivers/net/can/virtio_can/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config CAN_VIRTIO_CAN
+	depends on VIRTIO
+	tristate "Virtio CAN device support"
+	default n
+	help
+	  Say Y here if you want to support for Virtio CAN.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called virtio-can.
+
+	  If unsure, say N.
diff --git a/drivers/net/can/virtio_can/Makefile b/drivers/net/can/virtio_can/Makefile
new file mode 100644
index 000000000000..c931e4b8c029
--- /dev/null
+++ b/drivers/net/can/virtio_can/Makefile
@@ -0,0 +1,5 @@
+#
+#  Makefile for the Virtio CAN controller driver.
+#
+
+obj-$(CONFIG_CAN_VIRTIO_CAN) += virtio_can.o
diff --git a/drivers/net/can/virtio_can/virtio_can.c b/drivers/net/can/virtio_can/virtio_can.c
new file mode 100644
index 000000000000..dafbe5a36511
--- /dev/null
+++ b/drivers/net/can/virtio_can/virtio_can.c
@@ -0,0 +1,1176 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * CAN bus driver for the Virtio CAN controller
+ * Copyright (C) 2021 OpenSynergy GmbH
+ */
+
+#include <asm/atomic.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/stddef.h>
+#include <linux/can/dev.h>
+#include <linux/virtio.h>
+#include <linux/virtio_ring.h>
+#include <linux/virtio_can.h>
+
+/* CAN device queues */
+#define VIRTIO_CAN_QUEUE_TX 0u /* Driver side view! The device receives here */
+#define VIRTIO_CAN_QUEUE_RX 1u /* Driver side view! The device transmits here */
+#define VIRTIO_CAN_QUEUE_CONTROL 2u
+#define VIRTIO_CAN_QUEUE_INDICATION 3u
+#define VIRTIO_CAN_QUEUE_COUNT 4u
+
+#define CAN_KNOWN_FLAGS \
+	(VIRTIO_CAN_FLAGS_EXTENDED |\
+	 VIRTIO_CAN_FLAGS_FD |\
+	 VIRTIO_CAN_FLAGS_RTR)
+
+/* napi related */
+#define VIRTIO_CAN_NAPI_WEIGHT	NAPI_POLL_WEIGHT
+
+/* CAN TX message priorities (0 = normal priority) */
+#define VIRTIO_CAN_PRIO_COUNT 1
+/* Max. nummber of in flight TX messages */
+#define VIRTIO_CAN_ECHO_SKB_MAX 128u
+
+struct virtio_can_tx {
+	struct list_head list;
+	int prio; /* Currently always 0 "normal priority" */
+	int putidx;
+	struct virtio_can_tx_out tx_out;
+	struct virtio_can_tx_in tx_in;
+};
+
+/* virtio_can private data structure */
+struct virtio_can_priv {
+	struct can_priv can;	/* must be the first member */
+	/* NAPI for RX messages */
+	struct napi_struct napi;
+	/* NAPI for TX messages */
+	struct napi_struct napi_tx;
+	/* The network device we're associated with */
+	struct net_device *dev;
+	/* The virtio device we're associated with */
+	struct virtio_device *vdev;
+	/* The virtqueues */
+	struct virtqueue *vqs[VIRTIO_CAN_QUEUE_COUNT];
+	/* I/O callback function pointers for the virtqueues */
+	vq_callback_t *io_callbacks[VIRTIO_CAN_QUEUE_COUNT];
+	/* Lock for TX operations */
+	spinlock_t tx_lock;
+	/* Control queue lock. Defensive programming, may be not needed */
+	struct mutex ctrl_lock;
+	/* List of virtio CAN TX message */
+	struct list_head tx_list;
+	/* Array of receive queue messages */
+	struct virtio_can_rx rpkt[128u];
+	/* Those control queue messages cannot live on the stack! */
+	struct virtio_can_control_out cpkt_out;
+	struct virtio_can_control_in cpkt_in;
+	/* Indication queue message */
+	struct virtio_can_event_ind ipkt[1u];
+	/* Data to get and maintain the putidx for local TX echo */
+	struct list_head tx_putidx_free;
+	struct list_head *tx_putidx_list;
+	/* In flight TX messages per prio */
+	atomic_t tx_inflight[VIRTIO_CAN_PRIO_COUNT];
+	/* Max. In flight TX messages per prio */
+	u16 tx_limit[VIRTIO_CAN_PRIO_COUNT];
+	/* BusOff pending. Reset after successful indication to upper layer */
+	bool busoff_pending;
+};
+
+#ifdef DEBUG
+static void __attribute__((unused))
+virtio_can_hexdump(const void *data, size_t length, size_t base)
+{
+#define VIRTIO_CAN_MAX_BYTES_PER_LINE 16u
+	const char *cdata = data;
+	char *bp;
+	size_t offset = 0u;
+	unsigned int per_line = VIRTIO_CAN_MAX_BYTES_PER_LINE;
+	unsigned int col;
+	int c;
+	char buf[32u + 4u * VIRTIO_CAN_MAX_BYTES_PER_LINE];
+
+	do {
+		bp = &buf[0];
+		bp += sprintf(bp, "%zX:", base + offset);
+		if (length > 0u) {
+			if (per_line > length)
+				per_line = (unsigned int)length;
+			for (col = 0u; col < per_line; col++) {
+				c = cdata[offset + col] & 0xff;
+				bp += sprintf(bp, " %02X", c);
+			}
+			bp += sprintf(bp, " ");
+			for (col = 0u; col < per_line; col++) {
+				c = cdata[offset + col] & 0xff;
+				if (c < 32 || c >=  127)
+					c = '.';
+				bp += sprintf(bp, "%c", c);
+			}
+
+			offset += per_line;
+			length -= per_line;
+		}
+		pr_debug("%s\n", buf);
+	} while (length > 0u);
+}
+#else
+#define virtio_can_hexdump(data, length, base)
+#endif
+
+/* Function copied from virtio_net.c */
+static void virtqueue_napi_schedule(struct napi_struct *napi,
+				    struct virtqueue *vq)
+{
+	if (napi_schedule_prep(napi)) {
+		virtqueue_disable_cb(vq);
+		__napi_schedule(napi);
+	}
+}
+
+/* Function copied from virtio_net.c */
+static void virtqueue_napi_complete(struct napi_struct *napi,
+				    struct virtqueue *vq, int processed)
+{
+	int opaque;
+
+	opaque = virtqueue_enable_cb_prepare(vq);
+	if (napi_complete_done(napi, processed)) {
+		if (unlikely(virtqueue_poll(vq, opaque)))
+			virtqueue_napi_schedule(napi, vq);
+	} else {
+		virtqueue_disable_cb(vq);
+	}
+}
+
+static void virtio_can_free_candev(struct net_device *ndev)
+{
+	struct virtio_can_priv *priv = netdev_priv(ndev);
+
+	kfree(priv->tx_putidx_list);
+	free_candev(ndev);
+}
+
+static int virtio_can_alloc_tx_idx(struct virtio_can_priv *priv, int prio)
+{
+	struct list_head *entry;
+
+	BUG_ON(prio != 0); /* Currently only 1 priority */
+	BUG_ON(atomic_read(&priv->tx_inflight[0]) >= priv->can.echo_skb_max);
+	atomic_add(1, &priv->tx_inflight[prio]);
+
+	if (list_empty(&priv->tx_putidx_free))
+		return -1; /* Not expected to happen */
+
+	entry = priv->tx_putidx_free.next;
+	list_del(entry);
+
+	return entry - priv->tx_putidx_list;
+}
+
+static void virtio_can_free_tx_idx(struct virtio_can_priv *priv, int prio,
+				   int idx)
+{
+	BUG_ON(prio >= VIRTIO_CAN_PRIO_COUNT);
+	BUG_ON(idx >= priv->can.echo_skb_max);
+	BUG_ON(atomic_read(&priv->tx_inflight[prio]) == 0);
+
+	list_add(&priv->tx_putidx_list[idx], &priv->tx_putidx_free);
+	atomic_sub(1, &priv->tx_inflight[prio]);
+}
+
+/*
+ * Create a scatter-gather list representing our input buffer and put
+ * it in the queue.
+ *
+ * Callers should take appropriate locks.
+ */
+static int virtio_can_add_inbuf(struct virtqueue *vq, void *buf,
+				unsigned int size)
+{
+	struct scatterlist sg[1];
+	int ret;
+
+	sg_init_one(sg, buf, size);
+
+	ret = virtqueue_add_inbuf(vq, sg, 1, buf, GFP_ATOMIC);
+	virtqueue_kick(vq);
+	if (ret == 0)
+		ret = vq->num_free;
+	return ret;
+}
+
+/*
+ * Send a control message with message type either
+ *
+ * - VIRTIO_CAN_SET_CTRL_MODE_START or
+ * - VIRTIO_CAN_SET_CTRL_MODE_STOP.
+ *
+ * Unlike AUTOSAR CAN Driver Can_SetControllerMode() there is no requirement
+ * for this Linux driver to have an asynchronous implementation of the mode
+ * setting function so in order to keep things simple the function is
+ * implemented as synchronous function. Design pattern is
+ * virtio_console.c/__send_control_msg() & virtio_net.c/virtnet_send_command().
+ */
+static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_type)
+{
+	struct virtio_can_priv *priv = netdev_priv(ndev);
+	struct device *dev = &priv->vdev->dev;
+	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
+	struct scatterlist sg_out[1u];
+	struct scatterlist sg_in[1u];
+	struct scatterlist *sgs[2u];
+	int err;
+	unsigned int len;
+
+	/*
+	 * The function may be serialized by rtnl lock. Not sure.
+	 * Better safe than sorry.
+	 */
+	mutex_lock(&priv->ctrl_lock);
+
+	priv->cpkt_out.msg_type = cpu_to_le16(msg_type);
+	sg_init_one(&sg_out[0], &priv->cpkt_out, sizeof(priv->cpkt_out));
+	sg_init_one(&sg_in[0], &priv->cpkt_in, sizeof(priv->cpkt_in));
+	sgs[0] = sg_out;
+	sgs[1] = sg_in;
+
+	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, priv, GFP_ATOMIC);
+	if (err != 0) {
+		/* Not expected to happen */
+		dev_err(dev, "%s(): virtqueue_add_sgs() failed\n", __func__);
+	}
+
+	if (!virtqueue_kick(vq)) {
+		/* Not expected to happen */
+		dev_err(dev, "%s(): Kick failed\n", __func__);
+	}
+
+	while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq))
+		cpu_relax();
+
+	mutex_unlock(&priv->ctrl_lock);
+
+	return priv->cpkt_in.result;
+}
+
+static void virtio_can_start(struct net_device *ndev)
+{
+	struct virtio_can_priv *priv = netdev_priv(ndev);
+	u8 result;
+
+	result = virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_MODE_START);
+	if (result != VIRTIO_CAN_RESULT_OK) {
+		/* Not expected to happen */
+		netdev_err(ndev, "CAN controller start failed\n");
+	}
+
+	priv->busoff_pending = false;
+	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+
+	/* Switch carrier on if device was not connected to the bus */
+	if (!netif_carrier_ok(ndev))
+		netif_carrier_on(ndev);
+}
+
+/*
+ * See also m_can.c/m_can_set_mode()
+ *
+ * It is interesting that not only the M-CAN implementation but also all other
+ * implementations I looked into only support CAN_MODE_START.
+ * That CAN_MODE_SLEEP is frequently not found to be supported anywhere did not
+ * come not as surprise but that CAN_MODE_STOP is also never supported was one.
+ * The function is accessible via the method pointer do_set_mode in
+ * struct can_priv. As ususal no documentation there.
+ * May not play any role as grepping through the code did not reveal any place
+ * from where the method is actually called.
+ */
+static int virtio_can_set_mode(struct net_device *dev, enum can_mode mode)
+{
+	switch (mode) {
+	case CAN_MODE_START:
+		virtio_can_start(dev);
+		netif_wake_queue(dev);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+/*
+ * Called by issuing "ip link set up can0"
+ */
+static int virtio_can_open(struct net_device *dev)
+{
+	/* start the virtio_can controller */
+	virtio_can_start(dev);
+
+	/* RX and TX napi were already enabled in virtio_can_probe() */
+	netif_start_queue(dev);
+
+	return 0;
+}
+
+static void virtio_can_stop(struct net_device *ndev)
+{
+	struct virtio_can_priv *priv = netdev_priv(ndev);
+	struct device *dev = &priv->vdev->dev;
+	u8 result;
+
+	result = virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_MODE_STOP);
+	if (result != VIRTIO_CAN_RESULT_OK)
+		dev_err(dev, "CAN controller stop failed\n");
+
+	priv->busoff_pending = false;
+	priv->can.state = CAN_STATE_STOPPED;
+
+	/* Switch carrier off if device was connected to the bus */
+	if (netif_carrier_ok(ndev))
+		netif_carrier_off(ndev);
+}
+
+static int virtio_can_close(struct net_device *dev)
+{
+	netif_stop_queue(dev);
+	/*
+	 * Keep RX napi active to allow dropping of pending RX CAN messages,
+	 * keep TX napi active to allow processing of cancelled CAN messages
+	 */
+	virtio_can_stop(dev);
+	close_candev(dev);
+
+	return 0;
+}
+
+static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	struct virtio_can_priv *priv = netdev_priv(dev);
+	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
+	struct virtio_can_tx *can_tx_msg;
+	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
+	struct scatterlist sg_out[1u];
+	struct scatterlist sg_in[1u];
+	struct scatterlist *sgs[2u];
+	unsigned long flags;
+	size_t len;
+	u32 can_flags;
+	int err;
+	const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
+
+	/* virtio_can_hexdump(cf, hdr_size + cf->len, 0u); */
+
+	if (can_dropped_invalid_skb(dev, skb))
+		return NETDEV_TX_OK; /* No way to return NET_XMIT_DROP here */
+
+	/* Virtio CAN does not support error message frames */
+	if ((cf->can_id & CAN_ERR_FLAG) != 0u) {
+		kfree_skb(skb);
+		dev->stats.tx_dropped++;
+		return NETDEV_TX_OK; /* No way to return NET_XMIT_DROP here */
+	}
+
+	/*
+	 * No local check for CAN_RTR_FLAG or FD frame against negotiated
+	 * features. The device will reject those anyway if not supported.
+	 */
+
+	can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
+	if (!can_tx_msg)
+		return NETDEV_TX_OK; /* No way to return NET_XMIT_DROP here */
+
+	can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
+	can_flags = 0u;
+	if ((cf->can_id & CAN_EFF_FLAG) != 0u)
+		can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
+	if ((cf->can_id & CAN_RTR_FLAG) != 0u)
+		can_flags |= VIRTIO_CAN_FLAGS_RTR;
+	if (can_is_canfd_skb(skb))
+		can_flags |= VIRTIO_CAN_FLAGS_FD;
+	can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
+	can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
+	len = cf->len;
+	if (len > sizeof(cf->data))
+		len = sizeof(cf->data);
+	if (len > sizeof(can_tx_msg->tx_out.sdu))
+		len = sizeof(can_tx_msg->tx_out.sdu);
+	if ((can_flags & VIRTIO_CAN_FLAGS_RTR) == 0u) {
+		/* Copy if no RTR frame. RTR frames have a DLC but no payload */
+		memcpy(can_tx_msg->tx_out.sdu, cf->data, len);
+	}
+
+	/* Prepare sending of virtio message */
+	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + len);
+	sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
+	sgs[0] = sg_out;
+	sgs[1] = sg_in;
+
+	/* Protect list and virtio queue operations */
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	/* Find free TX priority */
+	if (atomic_read(&priv->tx_inflight[0]) >= priv->tx_limit[0]) {
+		/*
+		 * May happen if
+		 * - tx_limit[0] > max # of TX queue messages
+		 */
+		netif_stop_queue(dev);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
+		kfree(can_tx_msg);
+		netdev_info(dev, "TX: Stop queue, all prios full\n");
+		return NETDEV_TX_BUSY;
+	}
+
+	can_tx_msg->prio = 0; /* Priority is always 0 "normal priority" */
+	can_tx_msg->putidx = virtio_can_alloc_tx_idx(priv, can_tx_msg->prio);
+	BUG_ON(can_tx_msg->putidx < 0);
+
+	/* Normal queue stop when no transmission slots are left */
+	if (atomic_read(&priv->tx_inflight[0]) >= priv->tx_limit[0]) {
+		netif_stop_queue(dev);
+		netdev_info(dev, "TX: Normal stop queue\n");
+	}
+
+	list_add_tail(&can_tx_msg->list, &priv->tx_list);
+
+	/* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
+	can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
+
+	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
+	if (err != 0) {
+		list_del(&can_tx_msg->list);
+		virtio_can_free_tx_idx(priv, can_tx_msg->prio,
+				       can_tx_msg->putidx);
+		netif_stop_queue(dev);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
+		kfree(can_tx_msg);
+		if (err == -ENOSPC)
+			netdev_info(dev, "TX: Stop queue, no space left\n");
+		else
+			netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
+		return NETDEV_TX_BUSY;
+	}
+
+	if (!virtqueue_kick(vq))
+		netdev_err(dev, "%s(): Kick failed\n", __func__);
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops virtio_can_netdev_ops = {
+	.ndo_open = virtio_can_open,
+	.ndo_stop = virtio_can_close,
+	.ndo_start_xmit = virtio_can_start_xmit,
+	.ndo_change_mtu = can_change_mtu,
+};
+
+static int register_virtio_can_dev(struct net_device *dev)
+{
+	dev->flags |= IFF_ECHO;	/* we support local echo */
+	dev->netdev_ops = &virtio_can_netdev_ops;
+
+	return register_candev(dev);
+}
+
+/* Compare with m_can.c/m_can_echo_tx_event() */
+static int virtio_can_read_tx_queue(struct virtqueue *vq)
+{
+	struct virtio_can_priv *can_priv = vq->vdev->priv;
+	struct net_device *dev = can_priv->dev;
+	struct net_device_stats *stats = &dev->stats;
+	struct virtio_can_tx *can_tx_msg;
+	unsigned long flags;
+	unsigned int len;
+	u8 result;
+
+	/* Protect list and virtio queue operations */
+	spin_lock_irqsave(&can_priv->tx_lock, flags);
+
+	can_tx_msg = virtqueue_get_buf(vq, &len);
+	if (!can_tx_msg) {
+		spin_unlock_irqrestore(&can_priv->tx_lock, flags);
+		return 0; /* No more data */
+	}
+
+	if (unlikely(len < sizeof(struct virtio_can_tx_in))) {
+		netdev_err(dev, "TX ACK: Device sent no result code\n");
+		result = VIRTIO_CAN_RESULT_NOT_OK; /* Keep things going */
+	} else {
+		result = can_tx_msg->tx_in.result;
+	}
+
+	if (can_priv->can.state < CAN_STATE_BUS_OFF) {
+		/*
+		 * Here also frames with result != VIRTIO_CAN_RESULT_OK are
+		 * echoed. Intentional to bring a waiting process in an upper
+		 * layer to an end.
+		 * TODO: Any better means to indicate a problem here?
+		 */
+		if (result != VIRTIO_CAN_RESULT_OK)
+			netdev_warn(dev, "TX ACK: Result = %u\n", result);
+
+		stats->tx_bytes += can_get_echo_skb(dev, can_tx_msg->putidx,
+						    NULL);
+		stats->tx_packets++;
+	} else {
+		netdev_dbg(dev, "TX ACK: Controller inactive, drop echo\n");
+		can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
+	}
+
+	list_del(&can_tx_msg->list);
+	virtio_can_free_tx_idx(can_priv, can_tx_msg->prio, can_tx_msg->putidx);
+
+	spin_unlock_irqrestore(&can_priv->tx_lock, flags);
+
+	kfree(can_tx_msg);
+
+	/* Flow control */
+	if (netif_queue_stopped(dev)) {
+		netdev_info(dev, "TX ACK: Wake up stopped queue\n");
+		netif_wake_queue(dev);
+	}
+
+	return 1; /* Queue was not emtpy so there may be more data */
+}
+
+/*
+ * Poll TX used queue for sent CAN messages
+ * See https://wiki.linuxfoundation.org/networking/napi function
+ * int (*poll)(struct napi_struct *napi, int budget);
+ */
+static int virtio_can_tx_poll(struct napi_struct *napi, int quota)
+{
+	struct net_device *dev = napi->dev;
+	struct virtio_can_priv *priv = netdev_priv(dev);
+	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
+	int work_done = 0;
+
+	while (work_done < quota && virtio_can_read_tx_queue(vq) != 0)
+		work_done++;
+
+	if (work_done < quota)
+		virtqueue_napi_complete(napi, vq, work_done);
+
+	return work_done;
+}
+
+static void virtio_can_tx_intr(struct virtqueue *vq)
+{
+	struct virtio_can_priv *can_priv = vq->vdev->priv;
+
+	virtqueue_disable_cb(vq);
+	napi_schedule(&can_priv->napi_tx);
+}
+
+/*
+ * This function is the NAPI RX poll function and NAPI guarantees that this
+ * function is not invoked simulataneously on multiply processors.
+ * Read a RX message from the used queue and sends it to the upper layer.
+ * (See also m_can.c / m_can_read_fifo()).
+ */
+static int virtio_can_read_rx_queue(struct virtqueue *vq)
+{
+	struct virtio_can_priv *priv = vq->vdev->priv;
+	struct net_device *dev = priv->dev;
+	struct net_device_stats *stats = &dev->stats;
+	struct virtio_can_rx *can_rx;
+	struct canfd_frame *cf;
+	struct sk_buff *skb;
+	unsigned int len;
+	const unsigned int header_size = offsetof(struct virtio_can_rx, sdu);
+	u16 msg_type;
+	u32 can_flags;
+	u32 can_id;
+
+	can_rx = virtqueue_get_buf(vq, &len);
+	if (!can_rx)
+		return 0; /* No more data */
+
+	BUG_ON(len < header_size);
+
+	/* virtio_can_hexdump(can_rx, len, 0u); */
+
+	if (priv->can.state >= CAN_STATE_ERROR_PASSIVE) {
+		netdev_dbg(dev, "%s(): Controller not active\n", __func__);
+		goto putback;
+	}
+
+	msg_type = le16_to_cpu(can_rx->msg_type);
+	if (msg_type != VIRTIO_CAN_RX) {
+		netdev_warn(dev, "RX: Got unknown msg_type %04x\n", msg_type);
+		goto putback;
+	}
+
+	len -= header_size; /* Payload only now */
+	can_flags = le32_to_cpu(can_rx->flags);
+	can_id = le32_to_cpu(can_rx->can_id);
+
+	if ((can_flags & ~CAN_KNOWN_FLAGS) != 0u) {
+		stats->rx_dropped++;
+		netdev_warn(dev, "RX: CAN Id 0x%08x: Invalid flags 0x%x\n",
+			    can_id, can_flags);
+		goto putback;
+	}
+
+	if ((can_flags & VIRTIO_CAN_FLAGS_EXTENDED) != 0u) {
+		if (can_id > CAN_EFF_MASK) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Ext Id 0x%08x too big\n",
+				    can_id);
+			goto putback;
+		}
+		can_id |= CAN_EFF_FLAG;
+	} else {
+		if (can_id > CAN_SFF_MASK) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Std Id 0x%08x too big\n",
+				    can_id);
+			goto putback;
+		}
+	}
+
+	if ((can_flags & VIRTIO_CAN_FLAGS_RTR) != 0u) {
+		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_RTR_FRAMES)) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR not negotiated\n",
+				    can_id);
+			goto putback;
+		}
+		if ((can_flags & VIRTIO_CAN_FLAGS_FD) != 0u) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with FD not possible\n",
+				    can_id);
+			goto putback;
+		}
+		if (len != 0u) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with len != 0\n",
+				    can_id);
+			goto putback;
+		}
+		can_id |= CAN_RTR_FLAG;
+	}
+
+	if ((can_flags & VIRTIO_CAN_FLAGS_FD) != 0u) {
+		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_FD)) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: FD not negotiated\n",
+				    can_id);
+			goto putback;
+		}
+
+		skb = alloc_canfd_skb(priv->dev, &cf);
+		if (len > CANFD_MAX_DLEN)
+			len = CANFD_MAX_DLEN;
+	} else {
+		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_CLASSIC)) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: classic not negotiated\n",
+				    can_id);
+			goto putback;
+		}
+
+		skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
+		if (len > CAN_MAX_DLEN)
+			len = CAN_MAX_DLEN;
+	}
+	if (!skb) {
+		stats->rx_dropped++;
+		netdev_warn(dev, "RX: No skb available\n");
+		goto putback;
+	}
+
+	cf->can_id = can_id;
+	cf->len = len;
+	if ((can_flags & VIRTIO_CAN_FLAGS_RTR) == 0u) {
+		/* Copy if no RTR frame. RTR frames have a DLC but no payload */
+		memcpy(cf->data, can_rx->sdu, len);
+	}
+
+	stats->rx_packets++;
+	stats->rx_bytes += cf->len;
+
+	/* Use netif_rx() for interrupt context */
+	(void)netif_receive_skb(skb);
+
+putback:
+	/* Put processed RX buffer back into avail queue */
+	(void)virtio_can_add_inbuf(vq, can_rx, sizeof(struct virtio_can_rx));
+
+	return 1; /* Queue was not emtpy so there may be more data */
+}
+
+/*
+ * See m_can_poll() / m_can_handle_state_errors() m_can_handle_state_change().
+ */
+static int virtio_can_handle_busoff(struct net_device *dev)
+{
+	struct virtio_can_priv *priv = netdev_priv(dev);
+	struct net_device_stats *stats = &dev->stats;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	u8 rx_bytes;
+
+	if (!priv->busoff_pending)
+		return 0;
+
+	if (priv->can.state < CAN_STATE_BUS_OFF) {
+		netdev_dbg(dev, "entered error bus off state\n");
+
+		/* bus-off state */
+		priv->can.state = CAN_STATE_BUS_OFF;
+		priv->can.can_stats.bus_off++;
+		can_bus_off(dev);
+	}
+
+	/* propagate the error condition to the CAN stack */
+	skb = alloc_can_err_skb(dev, &cf);
+	if (unlikely(!skb))
+		return 0;
+
+	/* bus-off state */
+	cf->can_id |= CAN_ERR_BUSOFF;
+	rx_bytes = cf->can_dlc;
+
+	/* Ensure that the BusOff indication does not get lost */
+	if (netif_receive_skb(skb) == NET_RX_SUCCESS)
+		priv->busoff_pending = false;
+
+	stats->rx_packets++;
+	stats->rx_bytes += rx_bytes;
+
+	return 1;
+}
+
+/*
+ * Poll RX used queue for received CAN messages
+ * See https://wiki.linuxfoundation.org/networking/napi function
+ * int (*poll)(struct napi_struct *napi, int budget);
+ * Important: "The networking subsystem promises that poll() will not be
+ * invoked simultaneously (for the same napi_struct) on multiple processors"
+ */
+static int virtio_can_rx_poll(struct napi_struct *napi, int quota)
+{
+	struct net_device *dev = napi->dev;
+	struct virtio_can_priv *priv = netdev_priv(dev);
+	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
+	int work_done = 0;
+
+	work_done += virtio_can_handle_busoff(dev);
+
+	while (work_done < quota && virtio_can_read_rx_queue(vq) != 0)
+		work_done++;
+
+	if (work_done < quota)
+		virtqueue_napi_complete(napi, vq, work_done);
+
+	return work_done;
+}
+
+static void virtio_can_rx_intr(struct virtqueue *vq)
+{
+	struct virtio_can_priv *can_priv = vq->vdev->priv;
+
+	virtqueue_disable_cb(vq);
+	napi_schedule(&can_priv->napi);
+}
+
+static void virtio_can_evind_intr(struct virtqueue *vq)
+{
+	struct virtio_can_priv *can_priv = vq->vdev->priv;
+	struct net_device *dev = can_priv->dev;
+	struct virtio_can_event_ind *evind;
+	unsigned int len;
+	u16 msg_type;
+
+	for (;;) {
+		/*
+		 * The interrupt function is not assumed to be interrupted by
+		 * itself so locks should not be needed for queue operations.
+		 */
+		evind = virtqueue_get_buf(vq, &len);
+		if (!evind)
+			return; /* No more messages */
+
+		BUG_ON(len < sizeof(struct virtio_can_event_ind));
+
+		msg_type = le16_to_cpu(evind->msg_type);
+		if (msg_type != VIRTIO_CAN_BUSOFF_IND) {
+			netdev_warn(dev, "Evind: Got unknown msg_type %04x\n",
+				    msg_type);
+			goto putback;
+		}
+
+		if (!can_priv->busoff_pending &&
+		    can_priv->can.state < CAN_STATE_BUS_OFF) {
+			can_priv->busoff_pending = true;
+			napi_schedule(&can_priv->napi);
+		}
+
+putback:
+		/* Put processed event ind uffer back into avail queue */
+		(void)virtio_can_add_inbuf(vq, evind,
+					   sizeof(struct virtio_can_event_ind));
+	}
+}
+
+static void virtio_can_populate_vqs(struct virtio_device *vdev)
+
+{
+	struct virtio_can_priv *priv = vdev->priv;
+	struct virtqueue *vq;
+	unsigned int idx;
+	int ret;
+
+	// TODO: Think again a moment if here locks already may be needed!
+
+	/* Fill RX queue */
+	vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
+	for (idx = 0u; idx < ARRAY_SIZE(priv->rpkt); idx++) {
+		ret = virtio_can_add_inbuf(vq, &priv->rpkt[idx],
+					   sizeof(struct virtio_can_rx));
+		if (ret < 0) {
+			dev_dbg(&vdev->dev, "rpkt fill: ret=%d, idx=%u\n",
+				ret, idx);
+			break;
+		}
+	}
+	dev_dbg(&vdev->dev, "%u rpkt added\n", idx);
+
+	/* Fill event indication queue */
+	vq = priv->vqs[VIRTIO_CAN_QUEUE_INDICATION];
+	for (idx = 0u; idx < ARRAY_SIZE(priv->ipkt); idx++) {
+		ret = virtio_can_add_inbuf(vq, &priv->ipkt[idx],
+					   sizeof(struct virtio_can_event_ind));
+		if (ret < 0) {
+			dev_dbg(&vdev->dev, "ipkt fill: ret=%d, idx=%u\n",
+				ret, idx);
+			break;
+		}
+	}
+	dev_dbg(&vdev->dev, "%u ipkt added\n", idx);
+}
+
+static int virtio_can_find_vqs(struct virtio_can_priv *priv)
+{
+	/*
+	 * The order of RX and TX is exactly the opposite as in console and
+	 * network. Does not play any role but is a bad trap.
+	 */
+	static const char * const io_names[VIRTIO_CAN_QUEUE_COUNT] = {
+		"can-tx",
+		"can-rx",
+		"can-state-ctrl",
+		"can-event-ind"
+	};
+
+	BUG_ON(!priv);
+	BUG_ON(!priv->vdev);
+
+	priv->io_callbacks[VIRTIO_CAN_QUEUE_TX] = virtio_can_tx_intr;
+	priv->io_callbacks[VIRTIO_CAN_QUEUE_RX] = virtio_can_rx_intr;
+	priv->io_callbacks[VIRTIO_CAN_QUEUE_CONTROL] = NULL;
+	priv->io_callbacks[VIRTIO_CAN_QUEUE_INDICATION] = virtio_can_evind_intr;
+
+	/* Find the queues. */
+	return virtio_find_vqs(priv->vdev, VIRTIO_CAN_QUEUE_COUNT, priv->vqs,
+			       priv->io_callbacks, io_names, NULL);
+}
+
+/* Function must not be called before virtio_can_find_vqs() has been run */
+static int virtio_can_del_vq(struct virtio_device *vdev)
+{
+	struct virtio_can_priv *priv = vdev->priv;
+	struct list_head *cursor, *next;
+	struct virtqueue *vq;
+
+	if (!priv)
+		return -EINVAL;
+
+	/* Reset the device */
+	if (vdev->config->reset)
+		vdev->config->reset(vdev);
+
+	/*
+	 * From here we have dead silence from the device side so no locks
+	 * are needed to protect against device side events.
+	 */
+
+	vq = priv->vqs[VIRTIO_CAN_QUEUE_INDICATION];
+	while (virtqueue_detach_unused_buf(vq))
+		; /* Do nothing, content allocated statically */
+
+	vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
+	while (virtqueue_detach_unused_buf(vq))
+		; /* Do nothing, content allocated statically */
+
+	vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
+	while (virtqueue_detach_unused_buf(vq))
+		; /* Do nothing, content allocated statically */
+
+	vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
+	while (virtqueue_detach_unused_buf(vq))
+		; /* Do nothing, content to be de-allocated separately */
+
+	/*
+	 * Is keeping track of allocated elements by an own linked list
+	 * really necessary or may this be optimized using only
+	 * virtqueue_detach_unused_buf()?
+	 */
+	list_for_each_safe(cursor, next, &priv->tx_list) {
+		struct virtio_can_tx *can_tx;
+
+		can_tx = list_entry(cursor, struct virtio_can_tx, list);
+		list_del(cursor);
+		kfree(can_tx);
+	}
+
+	if (vdev->config->del_vqs)
+		vdev->config->del_vqs(vdev);
+
+	return 0;
+}
+
+/* See virtio_net.c/virtnet_remove() and also m_can.c/m_can_plat_remove() */
+static void virtio_can_remove(struct virtio_device *vdev)
+{
+	struct virtio_can_priv *priv = vdev->priv;
+	struct net_device *dev = priv->dev;
+
+	unregister_candev(dev);
+
+	/* No calls of netif_napi_del() needed as free_candev() will do this */
+
+	(void)virtio_can_del_vq(vdev);
+
+	virtio_can_free_candev(dev);
+}
+
+static int virtio_can_validate(struct virtio_device *vdev)
+{
+	BUG_ON(!vdev);
+
+	/*
+	 * CAN needs always access to the config space.
+	 * Check that the driver can access the config space
+	 */
+	if (!vdev->config->get) {
+		dev_err(&vdev->dev, "%s failure: config access disabled\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
+		dev_err(&vdev->dev,
+			"device does not comply with spec version 1.x\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int virtio_can_probe(struct virtio_device *vdev)
+{
+	struct net_device *dev;
+	struct virtio_can_priv *priv;
+	int err;
+	unsigned int echo_skb_max;
+	unsigned int idx;
+	u16 lo_tx = VIRTIO_CAN_ECHO_SKB_MAX;
+
+	BUG_ON(!vdev);
+
+	echo_skb_max = lo_tx;
+	dev = alloc_candev(sizeof(struct virtio_can_priv), echo_skb_max);
+	if (!dev)
+		return -ENOMEM;
+
+	priv = netdev_priv(dev);
+
+	dev_info(&vdev->dev, "echo_skb_max = %u\n", priv->can.echo_skb_max);
+	priv->tx_putidx_list =
+		kcalloc(echo_skb_max, sizeof(struct list_head), GFP_KERNEL);
+	if (!priv->tx_putidx_list) {
+		free_candev(dev);
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&priv->tx_putidx_free);
+	for (idx = 0u; idx < echo_skb_max; idx++)
+		list_add_tail(&priv->tx_putidx_list[idx],
+			      &priv->tx_putidx_free);
+
+	netif_napi_add(dev, &priv->napi, virtio_can_rx_poll,
+		       VIRTIO_CAN_NAPI_WEIGHT);
+	netif_napi_add(dev, &priv->napi_tx, virtio_can_tx_poll,
+		       VIRTIO_CAN_NAPI_WEIGHT);
+
+	SET_NETDEV_DEV(dev, &vdev->dev);
+
+	priv->dev = dev;
+	priv->vdev = vdev;
+	vdev->priv = priv;
+
+	priv->can.do_set_mode = virtio_can_set_mode;
+	priv->can.state = CAN_STATE_STOPPED;
+	/* Set Virtio CAN supported operations */
+	priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
+	if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
+		dev_info(&vdev->dev, "CAN FD is supported\n");
+		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD);
+		if (err != 0)
+			goto on_failure;
+	} else {
+		dev_info(&vdev->dev, "CAN FD not supported\n");
+	}
+
+	register_virtio_can_dev(dev);
+
+	/* Initialize virtqueues */
+	err = virtio_can_find_vqs(priv);
+	if (err != 0)
+		goto on_failure;
+
+	/*
+	 * It is possible to consider the number of TX queue places to
+	 * introduce a stricter TX flow control. Question is if this should
+	 * be done permanently this way in the Linux virtio CAN driver.
+	 */
+	if (true) {
+		struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
+		unsigned int tx_slots = vq->num_free;
+
+		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
+			tx_slots >>= 1;
+		if (lo_tx > tx_slots)
+			lo_tx = tx_slots;
+	}
+
+	dev_info(&vdev->dev, "tx_limit[0] = %u\n", lo_tx);
+	priv->tx_limit[0] = lo_tx;
+
+	INIT_LIST_HEAD(&priv->tx_list);
+
+	spin_lock_init(&priv->tx_lock);
+	mutex_init(&priv->ctrl_lock);
+
+	virtio_can_populate_vqs(vdev);
+
+	napi_enable(&priv->napi);
+	napi_enable(&priv->napi_tx);
+
+	/* Request device going live */
+	virtio_device_ready(vdev); /* Optionally done by virtio_dev_probe() */
+	dev_info(&vdev->dev, "Device live!\n");
+
+	return 0;
+
+on_failure:
+	unregister_candev(dev);
+	virtio_can_free_candev(dev);
+	return err;
+}
+
+#ifdef CONFIG_PM_SLEEP
+/*
+ * Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
+ * virtio_card.c/virtsnd_freeze()
+ */
+static int virtio_can_freeze(struct virtio_device *vdev)
+{
+	struct virtio_can_priv *priv = vdev->priv;
+	struct net_device *ndev = priv->dev;
+
+	napi_disable(&priv->napi);
+	napi_disable(&priv->napi_tx);
+
+	if (netif_running(ndev)) {
+		netif_stop_queue(ndev);
+		netif_device_detach(ndev);
+		virtio_can_stop(ndev);
+	}
+
+	priv->can.state = CAN_STATE_SLEEPING;
+
+	(void)virtio_can_del_vq(vdev);
+
+	return 0;
+}
+
+/*
+ * Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
+ * virtio_card.c/virtsnd_restore()
+ */
+static int virtio_can_restore(struct virtio_device *vdev)
+{
+	struct virtio_can_priv *priv = vdev->priv;
+	struct net_device *ndev = priv->dev;
+	int err;
+
+	err = virtio_can_find_vqs(priv);
+	if (err != 0)
+		return err;
+	virtio_can_populate_vqs(vdev);
+
+	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+
+	if (netif_running(ndev)) {
+		virtio_can_start(ndev);
+		netif_device_attach(ndev);
+		netif_start_queue(ndev);
+	}
+
+	napi_enable(&priv->napi);
+	napi_enable(&priv->napi_tx);
+
+	return 0;
+}
+#endif /* #ifdef CONFIG_PM_SLEEP */
+
+static struct virtio_device_id virtio_can_id_table[] = {
+	{ VIRTIO_ID_CAN, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static unsigned int features[] = {
+	VIRTIO_CAN_F_CAN_CLASSIC,
+	VIRTIO_CAN_F_CAN_FD,
+	VIRTIO_CAN_F_LATE_TX_ACK,
+	VIRTIO_CAN_F_RTR_FRAMES,
+};
+
+static struct virtio_driver virtio_can_driver = {
+	.feature_table = features,
+	.feature_table_size = ARRAY_SIZE(features),
+	.feature_table_legacy = NULL,
+	.feature_table_size_legacy = 0u,
+	.driver.name =	KBUILD_MODNAME,
+	.driver.owner =	THIS_MODULE,
+	.id_table =	virtio_can_id_table,
+	.validate =	virtio_can_validate,
+	.probe =	virtio_can_probe,
+	.remove =	virtio_can_remove,
+	.config_changed = NULL,
+#ifdef CONFIG_PM_SLEEP
+	.freeze =	virtio_can_freeze,
+	.restore =	virtio_can_restore,
+#endif
+};
+
+module_virtio_driver(virtio_can_driver);
+MODULE_DEVICE_TABLE(virtio, virtio_can_id_table);
+
+MODULE_AUTHOR("OpenSynergy GmbH");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CAN bus driver for Virtio CAN controller");
diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
new file mode 100644
index 000000000000..0ca75c7a98ee
--- /dev/null
+++ b/include/uapi/linux/virtio_can.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/*
+ * Copyright (C) 2021 OpenSynergy GmbH
+ */
+#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
+#define _LINUX_VIRTIO_VIRTIO_CAN_H
+
+#include <linux/types.h>
+#include <linux/virtio_types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+/* Feature bit numbers */
+#define VIRTIO_CAN_F_CAN_CLASSIC        0u
+#define VIRTIO_CAN_F_CAN_FD             1u
+#define VIRTIO_CAN_F_LATE_TX_ACK        2u
+#define VIRTIO_CAN_F_RTR_FRAMES         3u
+
+/* CAN Result Types */
+#define VIRTIO_CAN_RESULT_OK            0u
+#define VIRTIO_CAN_RESULT_NOT_OK        1u
+
+/* CAN flags to determine type of CAN Id */
+#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000u
+#define VIRTIO_CAN_FLAGS_FD             0x4000u
+#define VIRTIO_CAN_FLAGS_RTR            0x2000u
+
+/* TX queue message types */
+struct virtio_can_tx_out {
+#define VIRTIO_CAN_TX                   0x0001u
+	__le16 msg_type;
+	__le16 reserved;
+	__le32 flags;
+	__le32 can_id;
+	__u8 sdu[64u];
+};
+
+struct virtio_can_tx_in {
+	__u8 result;
+};
+
+/* RX queue message types */
+struct virtio_can_rx {
+#define VIRTIO_CAN_RX                   0x0101u
+	__le16 msg_type;
+	__le16 reserved;
+	__le32 flags;
+	__le32 can_id;
+	__u8 sdu[64u];
+};
+
+/* Control queue message types */
+struct virtio_can_control_out {
+#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201u
+#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202u
+	__le16 msg_type;
+};
+
+struct virtio_can_control_in {
+	__u8 result;
+};
+
+/* Indication queue message types */
+struct virtio_can_event_ind {
+#define VIRTIO_CAN_BUSOFF_IND           0x0301u
+	__le16 msg_type;
+};
+
+#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */
-- 
2.17.1

