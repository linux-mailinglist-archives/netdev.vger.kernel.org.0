Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DECA6EADE7
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjDUPTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjDUPTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:19:21 -0400
X-Greylist: delayed 1299 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Apr 2023 08:19:15 PDT
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFFE270A
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:19:15 -0700 (PDT)
Received: from 104.47.7.172_.trendmicro.com (unknown [172.21.9.104])
        by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id D34271069DF6A
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:57:36 +0000 (UTC)
Received: from 104.47.7.172_.trendmicro.com (unknown [172.21.174.129])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id B7A89100014F9;
        Fri, 21 Apr 2023 14:57:33 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1682089051.604000
X-TM-MAIL-UUID: 8d4d4255-5976-445c-92b3-32c9dedc05bb
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.172])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 939C210000825;
        Fri, 21 Apr 2023 14:57:31 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TyhPPgMHw3dScqLikRwj4SibDRSdTJ/iavlo8IiIXr0lJnuj3Rnz4bweqzvTYnh8oMlPebkbv1lwCtTJZqw6jOcyOnAp+jxG+7Jx2tN9MGGJHgQukQZHr/jbHulfRm0lRTJNw4hpPvsPrg3Kl5hTE0XXBmFzoe2/wJ842HFXCggphjS5dMvOEOUfCqQw40oCUubxjvBDVndDFEALlOzCOwOY6EPMQ0do6lysU3E/lfykr9f2uFew1cd25R7BSwkBHB4RTx4j+U6MKm/VHN1WlyLaIuZHK+o53HC3c5bpoB4bVusqiBo8YCk3Wi+LBFHTvQs8FcAX0B3QVWMyxc3leA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LIdv1cyLsZz7KQ2lJ50I7yT9j+iSCCHfgEA1xXNSHsg=;
 b=mWJmlXNprYx7hnbVCUxAd6gk05le7xQzEVVf7NqDuPHHxPFypZJf7QFOpRr04Y5EHHBDx6gjXW0RhCYMYOfgET4bmCfWCI2C/ONnyfNBMJk4H3GXUZjC8JApoU4DhSgQ09QHWwYL9DACYjfPVMCvIXuBh2W5muqJC2dFSL4R406nmCRNH3LYJH2scWC0K339nfPPQcSQssAAsEzmrRz4WsVYK7xspAAQ+TjFFxJ/xIvjYOn4Y/bndoW1idn9GFxF7W6COEmtrKDfY+TokmW2jmo9XZuwThjLReeBCvgHqYXs0aHkw8h+CEV9XTq1Sgw+nBiR2zvyZzHqdo0AZsOs4Q==
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
From:   Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
To:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        Harald Mommer <Harald.Mommer@opensynergy.com>,
        Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
Subject: [RFC PATCH v2] can: virtio: Initial virtio CAN driver.
Date:   Fri, 21 Apr 2023 16:56:53 +0200
Message-Id: <20230421145653.12811-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6EUR05FT020:EE_|FR2P281MB2491:EE_
X-MS-Office365-Filtering-Correlation-Id: 6494c8ec-3642-4826-385a-08db4278ba48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W73xpqsxd6QibafO16QJ7cUZzQR4DN9q0yyeH3WflW1oaQVXZENDvIuMtI4drTgQpRWuDE9owm4QRNPlK9UqR4b4CsUh9L9dSZ+LSokQrxFV9+1hoqK91w9TZf6aSwRbvHvDqkpUgWMHSJunRLOgf6grDoNo0YjnOjWKWxx7+ejYEJ+eJp7fyUHfru5rkeKnzSx7zOM3OemgMn3+lQhnT1hI/eaDs/b4lSbfSryjz7nGG/73ziuQS9ND0gTXd5G9iZqAP98xGBlOtcW3qLV69CqOoctaEj54fUEW4Y6xZfuSX+ZQDEpx6AS2DagKlkVG3DnBxg4M/dT7RGnjoYsHLihocWjXe4X+DU4Q2HYSXINFX9uirozK6HDPlqhm3pZe2YPcLwexvFwwPxYIqES/M8k2+/H4Dvs/FyfIhIQeCj9JOqyZlCJfT4q42PUvpwaaT1XeJnPWYHCusSXD8A2uhoq3WhCowgclxYLCxRk4FZ6prnCFZnHpod+aWcfVie5yJpivcI/A6Sh/DqGdYL/6KOkhR1qh3mO6dRrpIgyUmaGij1ilzcYWZm+giEmfT3maEY5/MvZ7KQZlN8oZlFWi/ExCxO8YycZHmhzuJhTHNZuZxvNOVArWz99X0qKyLQJYufBPv3Yc6f60UMZHP/TS5AY8f+3CiVeCKTBM4uJIiz1+Eb5pISf79OW4IkqJeQHK
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(346002)(396003)(39830400003)(376002)(136003)(451199021)(36840700001)(46966006)(478600001)(54906003)(42186006)(83380400001)(40480700001)(36860700001)(47076005)(2616005)(1076003)(107886003)(36756003)(336012)(26005)(186003)(86362001)(81166007)(82310400005)(966005)(316002)(8936002)(7416002)(8676002)(30864003)(41300700001)(4326008)(70586007)(70206006)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:57:29.1079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6494c8ec-3642-4826-385a-08db4278ba48
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT020.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB2491
X-TM-AS-ERS: 104.47.7.172-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27580.000
X-TMASE-Result: 10--21.634700-4.000000
X-TMASE-MatchedRID: jqlPWUYVHrV12vpl9TLJ5TQmrIfRqtAkfOaYwP8dcX7cAmu1xqeetrw6
        DyKtlkT+jOQ6n33pAxaQ8jX9l2qhLcYL8l78KeYrr4JCzA6K3s9SAphtkUXoaO4bNKpeEy8nEd+
        K6O5Nt53o2lRNg6L0iCmmK7MHAYU+/4Qw6v18mZkv+0FNnM7lDQPZZctd3P4B9LMB0hXFSeglzg
        +7nCkWyCZle49VkKqHhcxbgA1cw6CFClSci0DxS31PaVvCiNKvCtzGvPCy/m5SuvtBzlaEqFH3r
        kvzbWPMeVs0skyEaS09ATl1LvME3lJXW5+4Qv25LT4SwCkKtFGuW2+UBGEpHR6OXxdRGLx8QcU8
        dj0/qVE4zubZisoWTH4n+j7L37FS158YqQqQFFYSfYh4fgAsVYknvYO5kHSctOtXYgbXjdfT0wy
        7YI+J8KeBffPJGMutgGzqIeUiWyXBJDTteZHLtmJHJG/db0P+lRdhw/BBzacXivwflisSrLwxqS
        K0GSPRY/IvU/7EqTy0EnyDrPv1ndVYdIVrd76fq6H6eyKIRsPyKt/vA0HdKJzTESO2R27LxuXV3
        UE49jgtiAi8BOx+ly3gBCo25X5UDoqXgfIicDk1t42aLIqJRjCIlN/eSPB9WmOfr3aLpwiZtziF
        Un+D+SASGlv27YgtaDUcRNDN4u5ynoTP8fAVKsPp6CwcoGE4SHCU59h5KrEyhLY8urUHvgm+8vb
        PF0rkmBQvLjMBsUEwrllcYotxWv4/Z15iV7wGZt4OLrKo15Q4hD0Y/Y/a76VHZD7QW55u9cax+Z
        Civ67/rbbb+DqTH5LDa/+keL1rveeIAECAQ/JKb6w7iSI/H311ZumDuRp7fS0Ip2eEHnwUyRS/O
        CD9xZfQufW2jppOgZB+r3vA38kyz6YzwcKDH90H8LFZNFG7JQhrLH5KSJ0=
X-TMASE-XGENCLOUD: b1e5f389-8d89-41e0-bcce-6f79bd4f2215-0-0-200-0
X-TM-Deliver-Signature: 42FF7AA7CBA2A8359A06D99B1ADB925A
X-TM-Addin-Auth: PQHRXxNtfc483lSeMroaEuy2KJA23FkwyFaY3ZE25exP99a+934IHxZ6+mn
        z1Xd7FdNEA+lI91Z+nyS5FiexR2LQT29aaY6LkQvSYov6TeK3gdejCq0VWgHVnJuWA3X0E8umJ1
        dCAOq0cQ8p4twoIRZu/7a2upsamtLFWVIeK1koF2TC8Xrt/00XUuvpyqtcv9FnQH/71Z6zf+xsB
        RC+OETSA/IEWiwc3ECxZkHgedrpqevDdkG2mPXiEcr0RRTqT5E76RlhTP7jh7dJwFNK2yanmvqw
        XsUvvM1N5TbT01EZGiNlyr50MOJ7n7tM364t.2P7B+65t/OH6gXW9nSBmAK7CSHAqtV9l5mscO3
        pyF6VJIF5fyb7MB7hF4FgYJjbvwb31F7lZl8o8UfZujAHcNpnrprN9EGTcE9o8tdXy7TY9XgztV
        xLJGtl7KHztJRnh22/p1EzufE+AIEWfpwRUEVoihd8Yd7vqJ6TiD820XHAPUKZwMqerRjD7CRzZ
        Qjsr0cCNU2pH58OaIsxW1t0MyR3Q94WgL5rtW2pASdmIAFAsYSkLKfgejlx2VTKrWjC6Bw8i73B
        85reLHQMZLJUAXjW0BbRAEIEbTWcCE0GNh3yLGva7tj6+Q9gOTVQGe4pt2cojKFQPd2FgZgqcl6
        UMiw==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1682089053;
        bh=SGZH9eHYPtp+ZA3IXKiMyAzi0wLWKaVQ2Jcgv7fiMDU=; l=36601;
        h=From:To:Date;
        b=mItHAIyBMFiGvNronuCTmRWUxXvGJkppIARxjxljY9wqAf+qpqyTddXZKFymtiUTm
         O/AkK97PJV3oNOBfKcenzBH3h9miHELDF7yCN6NSUzQDJmCTuJZObopuuiaHe3RnGs
         CyzlUQAbb4j/RfnoMOAhKH7D6fLgINERi5TUR22iZtcj1zmHKDZU488IdJjqkdUZMr
         8G9aU87uy0o9X+zNmJurF+SzQcv6vs5f5B0fEUTnU9ffWYHbv4pa+r2r2ifkO/QGSz
         CDtzkShAsEEbdD55a7yfRf1CYd5lTk5b5Vu2EXrj6gZWKsUuE98rzUU+YRZhKqOlk1
         HdUTR4792NBIw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harald Mommer <harald.mommer@opensynergy.com>

- CAN Control

  - "ip link set up can0" starts the virtual CAN controller,
  - "ip link set up can0" stops the virtual CAN controller

- CAN RX

  Receive CAN frames. CAN frames can be standard or extended, classic or
  CAN FD. Classic CAN RTR frames are supported.

- CAN TX

  Send CAN frames. CAN frames can be standard or extended, classic or
  CAN FD. Classic CAN RTR frames are supported.

- CAN BusOff indication

  CAN BusOff is handled now by a bit in the configuration space.

This is version 3 of the driver after having gotten review comments.

Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
Signed-off-by: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
---

V2:
* Remove the event indication queue and use the config space instead, to
  indicate a bus off condition
* Rework RX and TX messages having a length field and some more fields for CAN
  EXT
* Fix CAN_EFF_MASK comparison
* Remove MISRA style code (e.g. '! = 0u')
* Remove priorities leftovers
* Remove BUGONs
* Based on virtio can spec RFCv3
* Tested with https://github.com/OpenSynergy/qemu/tree/virtio-can-spec-rfc-v3

 MAINTAINERS                     |    7 +
 drivers/net/can/Kconfig         |   12 +
 drivers/net/can/Makefile        |    1 +
 drivers/net/can/virtio_can.c    | 1060 +++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_can.h |   71 +++
 5 files changed, 1151 insertions(+)
 create mode 100644 drivers/net/can/virtio_can.c
 create mode 100644 include/uapi/linux/virtio_can.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e64787aace8..a8b118b344a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22053,6 +22053,13 @@ F:	drivers/vhost/scsi.c
 F:	include/uapi/linux/virtio_blk.h
 F:	include/uapi/linux/virtio_scsi.h
 
+VIRTIO CAN DRIVER
+M:	"Harald Mommer" <Harald.Mommer@opensynergy.com>
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	drivers/net/can/virtio_can.c
+F:	include/uapi/linux/virtio_can.h
+
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit@kernel.org>
 L:	virtualization@lists.linux-foundation.org
diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index cd34e8dc9394..832621f5893f 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -198,6 +198,18 @@ config CAN_XILINXCAN
 	  Xilinx CAN driver. This driver supports both soft AXI CAN IP and
 	  Zynq CANPS IP.
 
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
+
 source "drivers/net/can/c_can/Kconfig"
 source "drivers/net/can/cc770/Kconfig"
 source "drivers/net/can/ctucanfd/Kconfig"
diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 52b0f6e10668..d31949052acf 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -30,5 +30,6 @@ obj-$(CONFIG_CAN_SJA1000)	+= sja1000/
 obj-$(CONFIG_CAN_SUN4I)		+= sun4i_can.o
 obj-$(CONFIG_CAN_TI_HECC)	+= ti_hecc.o
 obj-$(CONFIG_CAN_XILINXCAN)	+= xilinx_can.o
+obj-$(CONFIG_CAN_VIRTIO_CAN)	+= virtio_can.o
 
 subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) += -DDEBUG
diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
new file mode 100644
index 000000000000..23f9c1b6446d
--- /dev/null
+++ b/drivers/net/can/virtio_can.c
@@ -0,0 +1,1060 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * CAN bus driver for the Virtio CAN controller
+ * Copyright (C) 2021-2023 OpenSynergy GmbH
+ */
+
+#include <linux/atomic.h>
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
+#define VIRTIO_CAN_QUEUE_TX 0 /* Driver side view! The device receives here */
+#define VIRTIO_CAN_QUEUE_RX 1 /* Driver side view! The device transmits here */
+#define VIRTIO_CAN_QUEUE_CONTROL 2
+#define VIRTIO_CAN_QUEUE_COUNT 3
+
+#define CAN_KNOWN_FLAGS \
+	(VIRTIO_CAN_FLAGS_EXTENDED |\
+	 VIRTIO_CAN_FLAGS_FD |\
+	 VIRTIO_CAN_FLAGS_RTR)
+
+/* Max. number of in flight TX messages */
+#define VIRTIO_CAN_ECHO_SKB_MAX 128
+
+struct virtio_can_tx {
+	struct list_head list;
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
+	/* Wait for control queue processing without polling */
+	struct completion ctrl_done;
+	/* List of virtio CAN TX message */
+	struct list_head tx_list;
+	/* Array of receive queue messages */
+	struct virtio_can_rx rpkt[128];
+	/* Those control queue messages cannot live on the stack! */
+	struct virtio_can_control_out cpkt_out;
+	struct virtio_can_control_in cpkt_in;
+	/* Data to get and maintain the putidx for local TX echo */
+	struct list_head tx_putidx_free;
+	struct list_head *tx_putidx_list;
+	/* In flight TX messages */
+	atomic_t tx_inflight;
+	/* Max. In flight TX messages */
+	u16 tx_limit;
+	/* BusOff pending. Reset after successful indication to upper layer */
+	bool busoff_pending;
+};
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
+static int virtio_can_alloc_tx_idx(struct virtio_can_priv *priv)
+{
+	struct list_head *entry;
+
+	if (atomic_read(&priv->tx_inflight) >= priv->can.echo_skb_max)
+		return -1; /* Not expected to happen */
+
+	atomic_add(1, &priv->tx_inflight);
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
+static void virtio_can_free_tx_idx(struct virtio_can_priv *priv, int idx)
+{
+	if (idx >= priv->can.echo_skb_max) {
+		WARN_ON(true); /* Not expected to happen */
+		return;
+	}
+	if (atomic_read(&priv->tx_inflight) == 0) {
+		WARN_ON(true); /* Not expected to happen */
+		return;
+	}
+
+	list_add(&priv->tx_putidx_list[idx], &priv->tx_putidx_free);
+	atomic_sub(1, &priv->tx_inflight);
+}
+
+/* Create a scatter-gather list representing our input buffer and put
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
+/* Send a control message with message type either
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
+	struct scatterlist sg_out[1];
+	struct scatterlist sg_in[1];
+	struct scatterlist *sgs[2];
+	int err;
+	unsigned int len;
+
+	/* The function may be serialized by rtnl lock. Not sure.
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
+		wait_for_completion(&priv->ctrl_done);
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
+/* See also m_can.c/m_can_set_mode()
+ *
+ * It is interesting that not only the M-CAN implementation but also all other
+ * implementations I looked into only support CAN_MODE_START.
+ * That CAN_MODE_SLEEP is frequently not found to be supported anywhere did not
+ * come not as surprise but that CAN_MODE_STOP is also never supported was one.
+ * The function is accessible via the method pointer do_set_mode in
+ * struct can_priv. As usual no documentation there.
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
+/* Called by issuing "ip link set up can0" */
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
+	/* Keep RX napi active to allow dropping of pending RX CAN messages,
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
+	struct scatterlist sg_out[1];
+	struct scatterlist sg_in[1];
+	struct scatterlist *sgs[2];
+	unsigned long flags;
+	size_t len;
+	u32 can_flags;
+	int err;
+	netdev_tx_t xmit_ret = NETDEV_TX_OK;
+	const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
+
+	if (can_dropped_invalid_skb(dev, skb))
+		goto kick; /* No way to return NET_XMIT_DROP here */
+
+	/* Virtio CAN does not support error message frames */
+	if (cf->can_id & CAN_ERR_FLAG) {
+		kfree_skb(skb);
+		dev->stats.tx_dropped++;
+		goto kick; /* No way to return NET_XMIT_DROP here */
+	}
+
+	/* No local check for CAN_RTR_FLAG or FD frame against negotiated
+	 * features. The device will reject those anyway if not supported.
+	 */
+
+	can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
+	if (!can_tx_msg)
+		goto kick; /* No way to return NET_XMIT_DROP here */
+
+	can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
+	can_flags = 0;
+	if (cf->can_id & CAN_EFF_FLAG)
+		can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
+	if (cf->can_id & CAN_RTR_FLAG)
+		can_flags |= VIRTIO_CAN_FLAGS_RTR;
+	if (can_is_canfd_skb(skb))
+		can_flags |= VIRTIO_CAN_FLAGS_FD;
+	can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
+	can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
+	len = cf->len;
+	can_tx_msg->tx_out.length = len;
+	if (len > sizeof(cf->data))
+		len = sizeof(cf->data);
+	if (len > sizeof(can_tx_msg->tx_out.sdu))
+		len = sizeof(can_tx_msg->tx_out.sdu);
+	if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
+		/* Copy if not a RTR frame. RTR frames have a DLC but no payload */
+		memcpy(can_tx_msg->tx_out.sdu, cf->data, len);
+	}
+
+	/* Prepare sending of virtio message */
+	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + len);
+	sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
+	sgs[0] = sg_out;
+	sgs[1] = sg_in;
+
+	if (atomic_read(&priv->tx_inflight) >= priv->tx_limit) {
+		netif_stop_queue(dev);
+		kfree(can_tx_msg);
+		netdev_dbg(dev, "TX: Stop queue, tx_inflight >= tx_limit\n");
+		xmit_ret = NETDEV_TX_BUSY;
+		goto kick;
+	}
+
+	/* Normal queue stop when no transmission slots are left */
+	if (atomic_read(&priv->tx_inflight) >= priv->tx_limit) {
+		netif_stop_queue(dev);
+		netdev_dbg(dev, "TX: Normal stop queue\n");
+	}
+
+	/* Protect list operations */
+	spin_lock_irqsave(&priv->tx_lock, flags);
+	can_tx_msg->putidx = virtio_can_alloc_tx_idx(priv);
+	list_add_tail(&can_tx_msg->list, &priv->tx_list);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	if (unlikely(can_tx_msg->putidx < 0)) {
+		WARN_ON(true); /* Not expected to happen */
+		list_del(&can_tx_msg->list);
+		kfree(can_tx_msg);
+		xmit_ret = NETDEV_TX_OK;
+		goto kick;
+	}
+
+	/* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
+	can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
+
+	/* Protect queue and list operations */
+	spin_lock_irqsave(&priv->tx_lock, flags);
+	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
+	if (err != 0) {
+		list_del(&can_tx_msg->list);
+		virtio_can_free_tx_idx(priv, can_tx_msg->putidx);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
+		netif_stop_queue(dev);
+		kfree(can_tx_msg);
+		if (err == -ENOSPC)
+			netdev_dbg(dev, "TX: Stop queue, no space left\n");
+		else
+			netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
+		xmit_ret = NETDEV_TX_BUSY;
+		goto kick;
+	}
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+kick:
+	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
+		if (!virtqueue_kick(vq))
+			netdev_err(dev, "%s(): Kick failed\n", __func__);
+	}
+
+	return xmit_ret;
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
+		/* Here also frames with result != VIRTIO_CAN_RESULT_OK are
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
+	virtio_can_free_tx_idx(can_priv, can_tx_msg->putidx);
+
+	spin_unlock_irqrestore(&can_priv->tx_lock, flags);
+
+	kfree(can_tx_msg);
+
+	/* Flow control */
+	if (netif_queue_stopped(dev)) {
+		netdev_dbg(dev, "TX ACK: Wake up stopped queue\n");
+		netif_wake_queue(dev);
+	}
+
+	return 1; /* Queue was not empty so there may be more data */
+}
+
+/* Poll TX used queue for sent CAN messages
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
+/* This function is the NAPI RX poll function and NAPI guarantees that this
+ * function is not invoked simultaneously on multiple processors.
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
+	unsigned int transport_len;
+	unsigned int len;
+	const unsigned int header_size = offsetof(struct virtio_can_rx, sdu);
+	u16 msg_type;
+	u32 can_flags;
+	u32 can_id;
+
+	can_rx = virtqueue_get_buf(vq, &transport_len);
+	if (!can_rx)
+		return 0; /* No more data */
+
+	if (transport_len < header_size) {
+		netdev_warn(dev, "RX: Message too small\n");
+		goto putback;
+	}
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
+	len = le16_to_cpu(can_rx->length);
+	can_flags = le32_to_cpu(can_rx->flags);
+	can_id = le32_to_cpu(can_rx->can_id);
+
+	if (can_flags & ~CAN_KNOWN_FLAGS) {
+		stats->rx_dropped++;
+		netdev_warn(dev, "RX: CAN Id 0x%08x: Invalid flags 0x%x\n",
+			    can_id, can_flags);
+		goto putback;
+	}
+
+	if (can_flags & VIRTIO_CAN_FLAGS_EXTENDED) {
+		can_id &= CAN_EFF_MASK;
+		can_id |= CAN_EFF_FLAG;
+	} else {
+		can_id &= CAN_SFF_MASK;
+	}
+
+	if (can_flags & VIRTIO_CAN_FLAGS_RTR) {
+		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_RTR_FRAMES)) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR not negotiated\n",
+				    can_id);
+			goto putback;
+		}
+		if (can_flags & VIRTIO_CAN_FLAGS_FD) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with FD not possible\n",
+				    can_id);
+			goto putback;
+		}
+
+		if (len > 0xF) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with DLC > 0xF\n",
+				    can_id);
+			goto putback;
+		}
+
+		if (len > 0x8)
+			len = 0x8;
+
+		can_id |= CAN_RTR_FLAG;
+	}
+
+	if (transport_len < header_size + len) {
+		netdev_warn(dev, "RX: Message too small for payload\n");
+		goto putback;
+	}
+
+	if (can_flags & VIRTIO_CAN_FLAGS_FD) {
+		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_FD)) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: FD not negotiated\n",
+				    can_id);
+			goto putback;
+		}
+
+		if (len > CANFD_MAX_DLEN)
+			len = CANFD_MAX_DLEN;
+
+		skb = alloc_canfd_skb(priv->dev, &cf);
+	} else {
+		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_CLASSIC)) {
+			stats->rx_dropped++;
+			netdev_warn(dev, "RX: CAN Id 0x%08x: classic not negotiated\n",
+				    can_id);
+			goto putback;
+		}
+
+		if (len > CAN_MAX_DLEN)
+			len = CAN_MAX_DLEN;
+
+		skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
+	}
+	if (!skb) {
+		stats->rx_dropped++;
+		netdev_warn(dev, "RX: No skb available\n");
+		goto putback;
+	}
+
+	cf->can_id = can_id;
+	cf->len = len;
+	if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
+		/* RTR frames have a DLC but no payload */
+		memcpy(cf->data, can_rx->sdu, len);
+	}
+
+	if (netif_receive_skb(skb) == NET_RX_SUCCESS) {
+		stats->rx_packets++;
+		if (!(can_flags & VIRTIO_CAN_FLAGS_RTR))
+			stats->rx_bytes += cf->len;
+	}
+
+putback:
+	/* Put processed RX buffer back into avail queue */
+	virtio_can_add_inbuf(vq, can_rx, sizeof(struct virtio_can_rx));
+
+	return 1; /* Queue was not empty so there may be more data */
+}
+
+/* See m_can_poll() / m_can_handle_state_errors() m_can_handle_state_change() */
+static int virtio_can_handle_busoff(struct net_device *dev)
+{
+	struct virtio_can_priv *priv = netdev_priv(dev);
+	struct can_frame *cf;
+	struct sk_buff *skb;
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
+
+	/* Ensure that the BusOff indication does not get lost */
+	if (netif_receive_skb(skb) == NET_RX_SUCCESS)
+		priv->busoff_pending = false;
+
+	return 1;
+}
+
+/* Poll RX used queue for received CAN messages
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
+static void virtio_can_control_intr(struct virtqueue *vq)
+{
+	struct virtio_can_priv *can_priv = vq->vdev->priv;
+
+	complete(&can_priv->ctrl_done);
+}
+
+static void virtio_can_config_changed(struct virtio_device *vdev)
+{
+	struct virtio_can_priv *can_priv = vdev->priv;
+	u16 status;
+
+	status = virtio_cread16(vdev, offsetof(struct virtio_can_config,
+					       status));
+
+	if (!(status & VIRTIO_CAN_S_CTRL_BUSOFF))
+		return;
+
+	if (!can_priv->busoff_pending &&
+	    can_priv->can.state < CAN_STATE_BUS_OFF) {
+		can_priv->busoff_pending = true;
+		napi_schedule(&can_priv->napi);
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
+	/* Fill RX queue */
+	vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
+	for (idx = 0; idx < ARRAY_SIZE(priv->rpkt); idx++) {
+		ret = virtio_can_add_inbuf(vq, &priv->rpkt[idx],
+					   sizeof(struct virtio_can_rx));
+		if (ret < 0) {
+			dev_dbg(&vdev->dev, "rpkt fill: ret=%d, idx=%u\n",
+				ret, idx);
+			break;
+		}
+	}
+	dev_dbg(&vdev->dev, "%u rpkt added\n", idx);
+}
+
+static int virtio_can_find_vqs(struct virtio_can_priv *priv)
+{
+	/* The order of RX and TX is exactly the opposite as in console and
+	 * network. Does not play any role but is a bad trap.
+	 */
+	static const char * const io_names[VIRTIO_CAN_QUEUE_COUNT] = {
+		"can-tx",
+		"can-rx",
+		"can-state-ctrl"
+	};
+
+	priv->io_callbacks[VIRTIO_CAN_QUEUE_TX] = virtio_can_tx_intr;
+	priv->io_callbacks[VIRTIO_CAN_QUEUE_RX] = virtio_can_rx_intr;
+	priv->io_callbacks[VIRTIO_CAN_QUEUE_CONTROL] = virtio_can_control_intr;
+
+	/* Find the queues. */
+	return virtio_find_vqs(priv->vdev, VIRTIO_CAN_QUEUE_COUNT, priv->vqs,
+			       priv->io_callbacks, io_names, NULL);
+}
+
+/* Function must not be called before virtio_can_find_vqs() has been run */
+static void virtio_can_del_vq(struct virtio_device *vdev)
+{
+	struct virtio_can_priv *priv = vdev->priv;
+	struct list_head *cursor, *next;
+	struct virtqueue *vq;
+
+	/* Reset the device */
+	if (vdev->config->reset)
+		vdev->config->reset(vdev);
+
+	/* From here we have dead silence from the device side so no locks
+	 * are needed to protect against device side events.
+	 */
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
+	/* Is keeping track of allocated elements by an own linked list
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
+	virtio_can_del_vq(vdev);
+
+	virtio_can_free_candev(dev);
+}
+
+static int virtio_can_validate(struct virtio_device *vdev)
+{
+	/* CAN needs always access to the config space.
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
+	echo_skb_max = lo_tx;
+	dev = alloc_candev(sizeof(struct virtio_can_priv), echo_skb_max);
+	if (!dev)
+		return -ENOMEM;
+
+	priv = netdev_priv(dev);
+
+	priv->tx_putidx_list =
+		kcalloc(echo_skb_max, sizeof(struct list_head), GFP_KERNEL);
+	if (!priv->tx_putidx_list) {
+		free_candev(dev);
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&priv->tx_putidx_free);
+	for (idx = 0; idx < echo_skb_max; idx++)
+		list_add_tail(&priv->tx_putidx_list[idx],
+			      &priv->tx_putidx_free);
+
+	netif_napi_add(dev, &priv->napi, virtio_can_rx_poll);
+	netif_napi_add(dev, &priv->napi_tx, virtio_can_tx_poll);
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
+		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD);
+		if (err != 0)
+			goto on_failure;
+	}
+
+	/* Initialize virtqueues */
+	err = virtio_can_find_vqs(priv);
+	if (err != 0)
+		goto on_failure;
+
+	/* It is possible to consider the number of TX queue places to
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
+	priv->tx_limit = lo_tx;
+
+	INIT_LIST_HEAD(&priv->tx_list);
+
+	spin_lock_init(&priv->tx_lock);
+	mutex_init(&priv->ctrl_lock);
+
+	init_completion(&priv->ctrl_done);
+
+	virtio_can_populate_vqs(vdev);
+
+	register_virtio_can_dev(dev);
+
+	napi_enable(&priv->napi);
+	napi_enable(&priv->napi_tx);
+
+	/* Request device going live */
+	virtio_device_ready(vdev); /* Optionally done by virtio_dev_probe() */
+
+	return 0;
+
+on_failure:
+	virtio_can_free_candev(dev);
+	return err;
+}
+
+#ifdef CONFIG_PM_SLEEP
+/* Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
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
+	virtio_can_del_vq(vdev);
+
+	return 0;
+}
+
+/* Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
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
+	.feature_table_size_legacy = 0,
+	.driver.name =	KBUILD_MODNAME,
+	.driver.owner =	THIS_MODULE,
+	.id_table =	virtio_can_id_table,
+	.validate =	virtio_can_validate,
+	.probe =	virtio_can_probe,
+	.remove =	virtio_can_remove,
+	.config_changed = virtio_can_config_changed,
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
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("CAN bus driver for Virtio CAN controller");
diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
new file mode 100644
index 000000000000..de85918aa7dc
--- /dev/null
+++ b/include/uapi/linux/virtio_can.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/*
+ * Copyright (C) 2021-2023 OpenSynergy GmbH
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
+#define VIRTIO_CAN_F_CAN_CLASSIC        0
+#define VIRTIO_CAN_F_CAN_FD             1
+#define VIRTIO_CAN_F_LATE_TX_ACK        2
+#define VIRTIO_CAN_F_RTR_FRAMES         3
+
+/* CAN Result Types */
+#define VIRTIO_CAN_RESULT_OK            0
+#define VIRTIO_CAN_RESULT_NOT_OK        1
+
+/* CAN flags to determine type of CAN Id */
+#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000
+#define VIRTIO_CAN_FLAGS_FD             0x4000
+#define VIRTIO_CAN_FLAGS_RTR            0x2000
+
+struct virtio_can_config {
+#define VIRTIO_CAN_S_CTRL_BUSOFF (1u << 0) /* Controller BusOff */
+	/* CAN controller status */
+	__le16 status;
+};
+
+/* TX queue message types */
+struct virtio_can_tx_out {
+#define VIRTIO_CAN_TX                   0x0001
+	__le16 msg_type;
+	__le16 length; /* 0..8 CC, 0..64 CAN­FD, 0..2048 CAN­XL, 12 bits */
+	__le32 reserved; /* May be needed in part for CAN XL priority */
+	__le32 flags;
+	__le32 can_id;
+	__u8 sdu[64];
+};
+
+struct virtio_can_tx_in {
+	__u8 result;
+};
+
+/* RX queue message types */
+struct virtio_can_rx {
+#define VIRTIO_CAN_RX                   0x0101
+	__le16 msg_type;
+	__le16 length; /* 0..8 CC, 0..64 CAN­FD, 0..2048 CAN­XL, 12 bits */
+	__le32 reserved; /* May be needed in part for CAN XL priority */
+	__le32 flags;
+	__le32 can_id;
+	__u8 sdu[64];
+};
+
+/* Control queue message types */
+struct virtio_can_control_out {
+#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201
+#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202
+	__le16 msg_type;
+};
+
+struct virtio_can_control_in {
+	__u8 result;
+};
+
+#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */
-- 
2.34.1

