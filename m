Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00022211E92
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgGBIXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:23:07 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:34528 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728508AbgGBIXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:23:03 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628MrUY017271;
        Thu, 2 Jul 2020 03:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678173;
        bh=YsmvRj9z3gDFXuXNfVPm9r+zKmA28FIRtmnlRZD7Iho=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=aQhF8M4YLxWDJO7BAd979sAKCntR8LcDEH/T8ayhukRGiDPHrETsOhRPjcrluzmWm
         KncENH+ifMKjs11GVKalH0lButeSiGxFUJyiNNV9fvafOI5iZ1jGjbKg7KOkbRRHjM
         mJ+xggI6dPyPAAFTcCkOs6J/9X1eeV4X56HdqQ9Q=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628MruT086357;
        Thu, 2 Jul 2020 03:22:53 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:52 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:52 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYN006145;
        Thu, 2 Jul 2020 03:22:47 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 11/22] rpmsg: virtio_rpmsg_bus: Move generic rpmsg structure to rpmsg_internal.h
Date:   Thu, 2 Jul 2020 13:51:32 +0530
Message-ID: <20200702082143.25259-12-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change intended. Move generic rpmsg structures like
"struct rpmsg_hdr", "struct rpmsg_ns_msg" and "struct rpmsg_as_msg",
its associated flags and generic macros to rpmsg_internal.h. This is
in preparation to add VHOST based vhost_rpmsg_bus.c which will use
the same structures and macros.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/rpmsg/rpmsg_internal.h   | 120 +++++++++++++++++++++++++++++++
 drivers/rpmsg/virtio_rpmsg_bus.c | 120 -------------------------------
 2 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/drivers/rpmsg/rpmsg_internal.h b/drivers/rpmsg/rpmsg_internal.h
index 39b3a5caf242..69d9c9579b50 100644
--- a/drivers/rpmsg/rpmsg_internal.h
+++ b/drivers/rpmsg/rpmsg_internal.h
@@ -15,6 +15,126 @@
 #include <linux/rpmsg.h>
 #include <linux/poll.h>
 
+/* The feature bitmap for virtio rpmsg */
+#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
+#define VIRTIO_RPMSG_F_AS	1 /* RP supports address service notifications */
+
+/**
+ * struct rpmsg_hdr - common header for all rpmsg messages
+ * @src: source address
+ * @dst: destination address
+ * @reserved: reserved for future use
+ * @len: length of payload (in bytes)
+ * @flags: message flags
+ * @data: @len bytes of message payload data
+ *
+ * Every message sent(/received) on the rpmsg bus begins with this header.
+ */
+struct rpmsg_hdr {
+	u32 src;
+	u32 dst;
+	u32 reserved;
+	u16 len;
+	u16 flags;
+	u8 data[0];
+} __packed;
+
+/**
+ * struct rpmsg_ns_msg - dynamic name service announcement message
+ * @name: name of remote service that is published
+ * @addr: address of remote service that is published
+ * @flags: indicates whether service is created or destroyed
+ *
+ * This message is sent across to publish a new service, or announce
+ * about its removal. When we receive these messages, an appropriate
+ * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
+ * or ->remove() handler of the appropriate rpmsg driver will be invoked
+ * (if/as-soon-as one is registered).
+ */
+struct rpmsg_ns_msg {
+	char name[RPMSG_NAME_SIZE];
+	u32 addr;
+	u32 flags;
+} __packed;
+
+/**
+ * struct rpmsg_as_msg - dynamic address service announcement message
+ * @name: name of the created channel
+ * @dst: destination address to be used by the backend rpdev
+ * @src: source address of the backend rpdev (the one that sent name service
+ * announcement message)
+ * @flags: indicates whether service is created or destroyed
+ *
+ * This message is sent (by virtio_rpmsg_bus) when a new channel is created
+ * in response to name service announcement message by backend rpdev to create
+ * a new channel. This sends the allocated source address for the channel
+ * (destination address for the backend rpdev) to the backend rpdev.
+ */
+struct rpmsg_as_msg {
+	char name[RPMSG_NAME_SIZE];
+	u32 dst;
+	u32 src;
+	u32 flags;
+} __packed;
+
+/**
+ * enum rpmsg_ns_flags - dynamic name service announcement flags
+ *
+ * @RPMSG_NS_CREATE: a new remote service was just created
+ * @RPMSG_NS_DESTROY: a known remote service was just destroyed
+ */
+enum rpmsg_ns_flags {
+	RPMSG_NS_CREATE		= 0,
+	RPMSG_NS_DESTROY	= 1,
+	RPMSG_AS_ANNOUNCE	= 2,
+};
+
+/**
+ * enum rpmsg_as_flags - dynamic address service announcement flags
+ *
+ * @RPMSG_AS_ASSIGN: address has been assigned to the newly created channel
+ * @RPMSG_AS_FREE: assigned address is freed from the channel and no longer can
+ * be used
+ */
+enum rpmsg_as_flags {
+	RPMSG_AS_ASSIGN		= 1,
+	RPMSG_AS_FREE		= 2,
+};
+
+/*
+ * We're allocating buffers of 512 bytes each for communications. The
+ * number of buffers will be computed from the number of buffers supported
+ * by the vring, upto a maximum of 512 buffers (256 in each direction).
+ *
+ * Each buffer will have 16 bytes for the msg header and 496 bytes for
+ * the payload.
+ *
+ * This will utilize a maximum total space of 256KB for the buffers.
+ *
+ * We might also want to add support for user-provided buffers in time.
+ * This will allow bigger buffer size flexibility, and can also be used
+ * to achieve zero-copy messaging.
+ *
+ * Note that these numbers are purely a decision of this driver - we
+ * can change this without changing anything in the firmware of the remote
+ * processor.
+ */
+#define MAX_RPMSG_NUM_BUFS	(512)
+#define MAX_RPMSG_BUF_SIZE	(512)
+
+/*
+ * Local addresses are dynamically allocated on-demand.
+ * We do not dynamically assign addresses from the low 1024 range,
+ * in order to reserve that address range for predefined services.
+ */
+#define RPMSG_RESERVED_ADDRESSES	(1024)
+
+/* Address 53 is reserved for advertising remote services */
+#define RPMSG_NS_ADDR			(53)
+
+/* Address 54 is reserved for advertising address services */
+#define RPMSG_AS_ADDR			(54)
+
 #define to_rpmsg_device(d) container_of(d, struct rpmsg_device, dev)
 #define to_rpmsg_driver(d) container_of(d, struct rpmsg_driver, drv)
 
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 19d930c9fc2c..f91143b25af7 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -69,92 +69,6 @@ struct virtproc_info {
 	struct rpmsg_endpoint *ns_ept;
 };
 
-/* The feature bitmap for virtio rpmsg */
-#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
-#define VIRTIO_RPMSG_F_AS	1 /* RP supports address service notifications */
-
-/**
- * struct rpmsg_hdr - common header for all rpmsg messages
- * @src: source address
- * @dst: destination address
- * @reserved: reserved for future use
- * @len: length of payload (in bytes)
- * @flags: message flags
- * @data: @len bytes of message payload data
- *
- * Every message sent(/received) on the rpmsg bus begins with this header.
- */
-struct rpmsg_hdr {
-	u32 src;
-	u32 dst;
-	u32 reserved;
-	u16 len;
-	u16 flags;
-	u8 data[0];
-} __packed;
-
-/**
- * struct rpmsg_ns_msg - dynamic name service announcement message
- * @name: name of remote service that is published
- * @addr: address of remote service that is published
- * @flags: indicates whether service is created or destroyed
- *
- * This message is sent across to publish a new service, or announce
- * about its removal. When we receive these messages, an appropriate
- * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
- * or ->remove() handler of the appropriate rpmsg driver will be invoked
- * (if/as-soon-as one is registered).
- */
-struct rpmsg_ns_msg {
-	char name[RPMSG_NAME_SIZE];
-	u32 addr;
-	u32 flags;
-} __packed;
-
-/**
- * struct rpmsg_as_msg - dynamic address service announcement message
- * @name: name of the created channel
- * @dst: destination address to be used by the backend rpdev
- * @src: source address of the backend rpdev (the one that sent name service
- * announcement message)
- * @flags: indicates whether service is created or destroyed
- *
- * This message is sent (by virtio_rpmsg_bus) when a new channel is created
- * in response to name service announcement message by backend rpdev to create
- * a new channel. This sends the allocated source address for the channel
- * (destination address for the backend rpdev) to the backend rpdev.
- */
-struct rpmsg_as_msg {
-	char name[RPMSG_NAME_SIZE];
-	u32 dst;
-	u32 src;
-	u32 flags;
-} __packed;
-
-/**
- * enum rpmsg_ns_flags - dynamic name service announcement flags
- *
- * @RPMSG_NS_CREATE: a new remote service was just created
- * @RPMSG_NS_DESTROY: a known remote service was just destroyed
- */
-enum rpmsg_ns_flags {
-	RPMSG_NS_CREATE		= 0,
-	RPMSG_NS_DESTROY	= 1,
-	RPMSG_AS_ANNOUNCE	= 2,
-};
-
-/**
- * enum rpmsg_as_flags - dynamic address service announcement flags
- *
- * @RPMSG_AS_ASSIGN: address has been assigned to the newly created channel
- * @RPMSG_AS_FREE: assigned address is freed from the channel and no longer can
- * be used
- */
-enum rpmsg_as_flags {
-	RPMSG_AS_ASSIGN		= 1,
-	RPMSG_AS_FREE		= 2,
-};
-
 /**
  * @vrp: the remote processor this channel belongs to
  */
@@ -167,40 +81,6 @@ struct virtio_rpmsg_channel {
 #define to_virtio_rpmsg_channel(_rpdev) \
 	container_of(_rpdev, struct virtio_rpmsg_channel, rpdev)
 
-/*
- * We're allocating buffers of 512 bytes each for communications. The
- * number of buffers will be computed from the number of buffers supported
- * by the vring, upto a maximum of 512 buffers (256 in each direction).
- *
- * Each buffer will have 16 bytes for the msg header and 496 bytes for
- * the payload.
- *
- * This will utilize a maximum total space of 256KB for the buffers.
- *
- * We might also want to add support for user-provided buffers in time.
- * This will allow bigger buffer size flexibility, and can also be used
- * to achieve zero-copy messaging.
- *
- * Note that these numbers are purely a decision of this driver - we
- * can change this without changing anything in the firmware of the remote
- * processor.
- */
-#define MAX_RPMSG_NUM_BUFS	(512)
-#define MAX_RPMSG_BUF_SIZE	(512)
-
-/*
- * Local addresses are dynamically allocated on-demand.
- * We do not dynamically assign addresses from the low 1024 range,
- * in order to reserve that address range for predefined services.
- */
-#define RPMSG_RESERVED_ADDRESSES	(1024)
-
-/* Address 53 is reserved for advertising remote services */
-#define RPMSG_NS_ADDR			(53)
-
-/* Address 54 is reserved for advertising address services */
-#define RPMSG_AS_ADDR			(54)
-
 static void virtio_rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
 static int virtio_rpmsg_send(struct rpmsg_endpoint *ept, void *data, int len);
 static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
-- 
2.17.1

