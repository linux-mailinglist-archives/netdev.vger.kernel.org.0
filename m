Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBD158EFEA
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiHJQBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 12:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiHJQAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:00:52 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368B75509B
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:00:49 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s18-20020a170902ea1200b0016f11bfefe4so9959743plg.14
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=omD71/mWuHcmvXqFNoQH+zpxWKOXy1lhx22UtZsa2do=;
        b=JQVt0HE5PgvZcmFjXOPPKhW3kcIK0Xs9JcKK/LxtZ/WwwjRmZa3cyzAXLzpAoHyRo3
         KXilnj2X33tsB5j3UQjA+3deVvYXiag1kkJVdC1DJKDnRoi7OFrRHB+20m3RqPegFl72
         An93KYfnjBtCPOSU+MPPlHBAMt6AsiKjco16tWZ/Q2ovbC6MZ+K3Y3hw1PpbPJNCMM7P
         U+mhz8HX1A5pu7LuWDY3gG71awEaHlG2yNWwlfWBC/4Qy+ZGK61hBKv6Q5p74DfzE6iQ
         Dq22V7pboDx1BCBE1Qc7nxbDZrmqFecPlJUzJ3QK3rnQZPdu8QA0D0CIdhz9YrSHFf2D
         rsUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=omD71/mWuHcmvXqFNoQH+zpxWKOXy1lhx22UtZsa2do=;
        b=txlF32UEDb8rKcmqb2CnpKR0dE4elJj3DHQdsCIlgRjKZemlHS8RNfo6HrR6lF1vjL
         3tU0BsMOHyTfniHvrqZkTPQndlWRpBZGkHQlDhDGdrwTTMmydxQTyZxN0WEFF+rVyGVO
         BiIykzCgjFetcjN+oJ2/4AhXR8Wcd3/zhnoviTr5/Hyc3qwF5PeELjaV/g0CsL/vEdGm
         6TpGlKE0vz8aL1lFzwOCSiV6zYVmN4XzF/aaNVt96jOlvKJnWb7iQf+8Q5FlwF0Z25DX
         WKlVLo21uYpGMoIzKPdbg8fUgVvNu8GP64gaKOztjm2HiBJu/jZgG1qPyHgVuJafqDUa
         yjAQ==
X-Gm-Message-State: ACgBeo3iwAAUGfxOkXscwhCyP8FbnjTbaQSvSBtAM7g4jyRmYlmNCSzZ
        BwhMDvzEhW8mUTd57gFelk6+DRDQKFnijg==
X-Google-Smtp-Source: AA6agR4E2pU8ZFkn/A2uMaQnODaX+m6Vu2M3GibS7vw+mGUqiSJcTbbcmQemRFGROGuLWPtt355TJAx1SHNxCQ==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:1e7:803:63a4:33])
 (user=mmandlik job=sendgmr) by 2002:a17:90b:3b8d:b0:1f7:2b01:b97a with SMTP
 id pc13-20020a17090b3b8d00b001f72b01b97amr4331548pjb.209.1660147248590; Wed,
 10 Aug 2022 09:00:48 -0700 (PDT)
Date:   Wed, 10 Aug 2022 09:00:36 -0700
In-Reply-To: <20220810085753.v5.1.I5622b2a92dca4d2703a0f747e24f3ef19303e6df@changeid>
Message-Id: <20220810085753.v5.3.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
Mime-Version: 1.0
References: <20220810085753.v5.1.I5622b2a92dca4d2703a0f747e24f3ef19303e6df@changeid>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v5 3/5] Bluetooth: Add support for hci devcoredump
From:   Manish Mandlik <mmandlik@google.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Signed-off-by : Manish Mandlik" <mmandlik@google.com>,
        linux-bluetooth@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        Won Chung <wonchung@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

Add devcoredump APIs to hci core so that drivers only have to provide
the dump skbs instead of managing the synchronization and timeouts.

The devcoredump APIs should be used in the following manner:
 - hci_devcoredump_init is called to allocate the dump.
 - hci_devcoredump_append is called to append any skbs with dump data
   OR hci_devcoredump_append_pattern is called to insert a pattern.
 - hci_devcoredump_complete is called when all dump packets have been
   sent OR hci_devcoredump_abort is called to indicate an error and
   cancel an ongoing dump collection.

The high level APIs just prepare some skbs with the appropriate data and
queue it for the dump to process. Packets part of the crashdump can be
intercepted in the driver in interrupt context and forwarded directly to
the devcoredump APIs.

Internally, there are 5 states for the dump: idle, active, complete,
abort and timeout. A devcoredump will only be in active state after it
has been initialized. Once active, it accepts data to be appended,
patterns to be inserted (i.e. memset) and a completion event or an abort
event to generate a devcoredump. The timeout is initialized at the same
time the dump is initialized (defaulting to 10s) and will be cleared
either when the timeout occurs or the dump is complete or aborted.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

(no changes since v4)

Changes in v4:
- Add .enabled() and .coredump() to hci_devcoredump struct

Changes in v3:
- Add attribute to enable/disable and set default state to disabled

Changes in v2:
- Move hci devcoredump implementation to new files
- Move dump queue and dump work to hci_devcoredump struct
- Add CONFIG_DEV_COREDUMP conditional compile

 include/net/bluetooth/coredump.h | 119 +++++++
 include/net/bluetooth/hci_core.h |   5 +
 net/bluetooth/Makefile           |   2 +
 net/bluetooth/coredump.c         | 524 +++++++++++++++++++++++++++++++
 net/bluetooth/hci_core.c         |   9 +
 net/bluetooth/hci_sync.c         |   2 +
 6 files changed, 661 insertions(+)
 create mode 100644 include/net/bluetooth/coredump.h
 create mode 100644 net/bluetooth/coredump.c

diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/coredump.h
new file mode 100644
index 000000000000..be09290927c0
--- /dev/null
+++ b/include/net/bluetooth/coredump.h
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Google Corporation
+ */
+
+#ifndef __COREDUMP_H
+#define __COREDUMP_H
+
+#define DEVCOREDUMP_TIMEOUT	msecs_to_jiffies(10000)	/* 10 sec */
+
+typedef bool (*coredump_enabled_t)(struct hci_dev *hdev);
+typedef void (*coredump_t)(struct hci_dev *hdev);
+typedef int  (*dmp_hdr_t)(struct hci_dev *hdev, char *buf, size_t size);
+typedef void (*notify_change_t)(struct hci_dev *hdev, int state);
+
+/* struct hci_devcoredump - Devcoredump state
+ *
+ * @supported: Indicates if FW dump collection is supported by driver
+ * @state: Current state of dump collection
+ * @alloc_size: Total size of the dump
+ * @head: Start of the dump
+ * @tail: Pointer to current end of dump
+ * @end: head + alloc_size for easy comparisons
+ *
+ * @dump_q: Dump queue for state machine to process
+ * @dump_rx: Devcoredump state machine work
+ * @dump_timeout: Devcoredump timeout work
+ *
+ * @enabled: Checks if the devcoredump is enabled for the device
+ *
+ * @coredump: Called from the driver's .coredump() function.
+ * @dmp_hdr: Create a dump header to identify controller/fw/driver info
+ * @notify_change: Notify driver when devcoredump state has changed
+ */
+struct hci_devcoredump {
+	bool		supported;
+
+	enum devcoredump_state {
+		HCI_DEVCOREDUMP_IDLE,
+		HCI_DEVCOREDUMP_ACTIVE,
+		HCI_DEVCOREDUMP_DONE,
+		HCI_DEVCOREDUMP_ABORT,
+		HCI_DEVCOREDUMP_TIMEOUT
+	} state;
+
+	size_t		alloc_size;
+	char		*head;
+	char		*tail;
+	char		*end;
+
+	struct sk_buff_head	dump_q;
+	struct work_struct	dump_rx;
+	struct delayed_work	dump_timeout;
+
+	coredump_enabled_t	enabled;
+
+	coredump_t		coredump;
+	dmp_hdr_t		dmp_hdr;
+	notify_change_t		notify_change;
+};
+
+#ifdef CONFIG_DEV_COREDUMP
+
+void hci_devcoredump_reset(struct hci_dev *hdev);
+void hci_devcoredump_rx(struct work_struct *work);
+void hci_devcoredump_timeout(struct work_struct *work);
+
+int hci_devcoredump_register(struct hci_dev *hdev, coredump_t coredump,
+			     dmp_hdr_t dmp_hdr, notify_change_t notify_change);
+int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size);
+int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb);
+int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len);
+int hci_devcoredump_complete(struct hci_dev *hdev);
+int hci_devcoredump_abort(struct hci_dev *hdev);
+
+#else
+
+static inline void hci_devcoredump_reset(struct hci_dev *hdev) {}
+static inline void hci_devcoredump_rx(struct work_struct *work) {}
+static inline void hci_devcoredump_timeout(struct work_struct *work) {}
+
+static inline int hci_devcoredump_register(struct hci_dev *hdev,
+					   coredump_t coredump,
+					   dmp_hdr_t dmp_hdr,
+					   notify_change_t notify_change)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_append(struct hci_dev *hdev,
+					 struct sk_buff *skb)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_append_pattern(struct hci_dev *hdev,
+						 u8 pattern, u32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_complete(struct hci_dev *hdev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_abort(struct hci_dev *hdev)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_DEV_COREDUMP */
+
+#endif /* __COREDUMP_H */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index e7862903187d..fb5ef1c6dd10 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -32,6 +32,7 @@
 #include <net/bluetooth/hci.h>
 #include <net/bluetooth/hci_sync.h>
 #include <net/bluetooth/hci_sock.h>
+#include <net/bluetooth/coredump.h>
 
 /* HCI priority */
 #define HCI_PRIO_MAX	7
@@ -585,6 +586,10 @@ struct hci_dev {
 	const char		*fw_info;
 	struct dentry		*debugfs;
 
+#ifdef CONFIG_DEV_COREDUMP
+	struct hci_devcoredump	dump;
+#endif
+
 	struct device		dev;
 
 	struct rfkill		*rfkill;
diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
index 0e7b7db42750..141ac1fda0bf 100644
--- a/net/bluetooth/Makefile
+++ b/net/bluetooth/Makefile
@@ -17,6 +17,8 @@ bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
 	ecdh_helper.o hci_request.o mgmt_util.o mgmt_config.o hci_codec.o \
 	eir.o hci_sync.o
 
+bluetooth-$(CONFIG_DEV_COREDUMP) += coredump.o
+
 bluetooth-$(CONFIG_BT_BREDR) += sco.o
 bluetooth-$(CONFIG_BT_LE) += iso.o
 bluetooth-$(CONFIG_BT_HS) += a2mp.o amp.o
diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
new file mode 100644
index 000000000000..b412056457c8
--- /dev/null
+++ b/net/bluetooth/coredump.c
@@ -0,0 +1,524 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Google Corporation
+ */
+
+#include <linux/devcoredump.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+
+enum hci_devcoredump_pkt_type {
+	HCI_DEVCOREDUMP_PKT_INIT,
+	HCI_DEVCOREDUMP_PKT_SKB,
+	HCI_DEVCOREDUMP_PKT_PATTERN,
+	HCI_DEVCOREDUMP_PKT_COMPLETE,
+	HCI_DEVCOREDUMP_PKT_ABORT,
+};
+
+struct hci_devcoredump_skb_cb {
+	u16 pkt_type;
+};
+
+struct hci_devcoredump_skb_pattern {
+	u8 pattern;
+	u32 len;
+} __packed;
+
+#define hci_dmp_cb(skb)	((struct hci_devcoredump_skb_cb *)((skb)->cb))
+
+#define MAX_DEVCOREDUMP_HDR_SIZE	512	/* bytes */
+
+static int hci_devcoredump_update_hdr_state(char *buf, size_t size, int state)
+{
+	if (!buf)
+		return 0;
+
+	return snprintf(buf, size, "Bluetooth devcoredump\nState: %d\n", state);
+}
+
+/* Call with hci_dev_lock only. */
+static int hci_devcoredump_update_state(struct hci_dev *hdev, int state)
+{
+	hdev->dump.state = state;
+
+	return hci_devcoredump_update_hdr_state(hdev->dump.head,
+						hdev->dump.alloc_size, state);
+}
+
+static int hci_devcoredump_mkheader(struct hci_dev *hdev, char *buf,
+				    size_t buf_size)
+{
+	char *ptr = buf;
+	size_t rem = buf_size;
+	size_t read = 0;
+
+	read = hci_devcoredump_update_hdr_state(ptr, rem, HCI_DEVCOREDUMP_IDLE);
+	read += 1; /* update_hdr_state adds \0 at the end upon state rewrite */
+	rem -= read;
+	ptr += read;
+
+	if (hdev->dump.dmp_hdr) {
+		/* dmp_hdr() should return number of bytes written */
+		read = hdev->dump.dmp_hdr(hdev, ptr, rem);
+		rem -= read;
+		ptr += read;
+	}
+
+	read = snprintf(ptr, rem, "--- Start dump ---\n");
+	rem -= read;
+	ptr += read;
+
+	return buf_size - rem;
+}
+
+/* Do not call with hci_dev_lock since this calls driver code. */
+static void hci_devcoredump_notify(struct hci_dev *hdev, int state)
+{
+	if (hdev->dump.notify_change)
+		hdev->dump.notify_change(hdev, state);
+}
+
+/* Call with hci_dev_lock only. */
+void hci_devcoredump_reset(struct hci_dev *hdev)
+{
+	hdev->dump.head = NULL;
+	hdev->dump.tail = NULL;
+	hdev->dump.alloc_size = 0;
+
+	hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
+
+	cancel_delayed_work(&hdev->dump.dump_timeout);
+	skb_queue_purge(&hdev->dump.dump_q);
+}
+
+/* Call with hci_dev_lock only. */
+static void hci_devcoredump_free(struct hci_dev *hdev)
+{
+	if (hdev->dump.head)
+		vfree(hdev->dump.head);
+
+	hci_devcoredump_reset(hdev);
+}
+
+/* Call with hci_dev_lock only. */
+static int hci_devcoredump_alloc(struct hci_dev *hdev, u32 size)
+{
+	hdev->dump.head = vmalloc(size);
+	if (!hdev->dump.head)
+		return -ENOMEM;
+
+	hdev->dump.alloc_size = size;
+	hdev->dump.tail = hdev->dump.head;
+	hdev->dump.end = hdev->dump.head + size;
+
+	hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
+
+	return 0;
+}
+
+/* Call with hci_dev_lock only. */
+static bool hci_devcoredump_copy(struct hci_dev *hdev, char *buf, u32 size)
+{
+	if (hdev->dump.tail + size > hdev->dump.end)
+		return false;
+
+	memcpy(hdev->dump.tail, buf, size);
+	hdev->dump.tail += size;
+
+	return true;
+}
+
+/* Call with hci_dev_lock only. */
+static bool hci_devcoredump_memset(struct hci_dev *hdev, u8 pattern, u32 len)
+{
+	if (hdev->dump.tail + len > hdev->dump.end)
+		return false;
+
+	memset(hdev->dump.tail, pattern, len);
+	hdev->dump.tail += len;
+
+	return true;
+}
+
+/* Call with hci_dev_lock only. */
+static int hci_devcoredump_prepare(struct hci_dev *hdev, u32 dump_size)
+{
+	char *dump_hdr;
+	int dump_hdr_size;
+	u32 size;
+	int err = 0;
+
+	dump_hdr = vmalloc(MAX_DEVCOREDUMP_HDR_SIZE);
+	if (!dump_hdr) {
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+	dump_hdr_size = hci_devcoredump_mkheader(hdev, dump_hdr,
+						 MAX_DEVCOREDUMP_HDR_SIZE);
+	size = dump_hdr_size + dump_size;
+
+	if (hci_devcoredump_alloc(hdev, size)) {
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+	/* Insert the device header */
+	if (!hci_devcoredump_copy(hdev, dump_hdr, dump_hdr_size)) {
+		bt_dev_err(hdev, "Failed to insert header");
+		hci_devcoredump_free(hdev);
+
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+hdr_free:
+	if (dump_hdr)
+		vfree(dump_hdr);
+
+	return err;
+}
+
+/* Bluetooth devcoredump state machine.
+ *
+ * Devcoredump states:
+ *
+ *      HCI_DEVCOREDUMP_IDLE: The default state.
+ *
+ *      HCI_DEVCOREDUMP_ACTIVE: A devcoredump will be in this state once it has
+ *              been initialized using hci_devcoredump_init(). Once active, the
+ *              driver can append data using hci_devcoredump_append() or insert
+ *              a pattern using hci_devcoredump_append_pattern().
+ *
+ *      HCI_DEVCOREDUMP_DONE: Once the dump collection is complete, the drive
+ *              can signal the completion using hci_devcoredump_complete(). A
+ *              devcoredump is generated indicating the completion event and
+ *              then the state machine is reset to the default state.
+ *
+ *      HCI_DEVCOREDUMP_ABORT: The driver can cancel ongoing dump collection in
+ *              case of any error using hci_devcoredump_abort(). A devcoredump
+ *              is still generated with the available data indicating the abort
+ *              event and then the state machine is reset to the default state.
+ *
+ *      HCI_DEVCOREDUMP_TIMEOUT: A timeout timer for HCI_DEVCOREDUMP_TIMEOUT sec
+ *              is started during devcoredump initialization. Once the timeout
+ *              occurs, the driver is notified, a devcoredump is generated with
+ *              the available data indicating the timeout event and then the
+ *              state machine is reset to the default state.
+ *
+ * The driver must register using hci_devcoredump_register() before using the
+ * hci devcoredump APIs.
+ */
+void hci_devcoredump_rx(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev, dump.dump_rx);
+	struct sk_buff *skb;
+	struct hci_devcoredump_skb_pattern *pattern;
+	u32 dump_size;
+	int start_state;
+
+#define DBG_UNEXPECTED_STATE() \
+		bt_dev_dbg(hdev, \
+			   "Unexpected packet (%d) for state (%d). ", \
+			   hci_dmp_cb(skb)->pkt_type, hdev->dump.state)
+
+	while ((skb = skb_dequeue(&hdev->dump.dump_q))) {
+		hci_dev_lock(hdev);
+		start_state = hdev->dump.state;
+
+		switch (hci_dmp_cb(skb)->pkt_type) {
+		case HCI_DEVCOREDUMP_PKT_INIT:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			if (skb->len != sizeof(dump_size)) {
+				bt_dev_dbg(hdev, "Invalid dump init pkt");
+				goto loop_continue;
+			}
+
+			dump_size = *((u32 *)skb->data);
+			if (!dump_size) {
+				bt_dev_err(hdev, "Zero size dump init pkt");
+				goto loop_continue;
+			}
+
+			if (hci_devcoredump_prepare(hdev, dump_size)) {
+				bt_dev_err(hdev, "Failed to prepare for dump");
+				goto loop_continue;
+			}
+
+			hci_devcoredump_update_state(hdev,
+						     HCI_DEVCOREDUMP_ACTIVE);
+			queue_delayed_work(hdev->workqueue,
+					   &hdev->dump.dump_timeout,
+					   DEVCOREDUMP_TIMEOUT);
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_SKB:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			if (!hci_devcoredump_copy(hdev, skb->data, skb->len))
+				bt_dev_dbg(hdev, "Failed to insert skb");
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_PATTERN:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			if (skb->len != sizeof(*pattern)) {
+				bt_dev_dbg(hdev, "Invalid pattern skb");
+				goto loop_continue;
+			}
+
+			pattern = (void *)skb->data;
+
+			if (!hci_devcoredump_memset(hdev, pattern->pattern,
+						    pattern->len))
+				bt_dev_dbg(hdev, "Failed to set pattern");
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_COMPLETE:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			hci_devcoredump_update_state(hdev,
+						     HCI_DEVCOREDUMP_DONE);
+			dump_size = hdev->dump.tail - hdev->dump.head;
+
+			bt_dev_info(hdev,
+				    "Devcoredump complete with size %u "
+				    "(expect %u)",
+				    dump_size, hdev->dump.alloc_size);
+
+			dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
+				      GFP_KERNEL);
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_ABORT:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			hci_devcoredump_update_state(hdev,
+						     HCI_DEVCOREDUMP_ABORT);
+			dump_size = hdev->dump.tail - hdev->dump.head;
+
+			bt_dev_info(hdev,
+				    "Devcoredump aborted with size %u "
+				    "(expect %u)",
+				    dump_size, hdev->dump.alloc_size);
+
+			/* Emit a devcoredump with the available data */
+			dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
+				      GFP_KERNEL);
+			break;
+
+		default:
+			bt_dev_dbg(hdev,
+				   "Unknown packet (%d) for state (%d). ",
+				   hci_dmp_cb(skb)->pkt_type, hdev->dump.state);
+			break;
+		}
+
+loop_continue:
+		kfree_skb(skb);
+		hci_dev_unlock(hdev);
+
+		if (start_state != hdev->dump.state)
+			hci_devcoredump_notify(hdev, hdev->dump.state);
+
+		hci_dev_lock(hdev);
+		if (hdev->dump.state == HCI_DEVCOREDUMP_DONE ||
+		    hdev->dump.state == HCI_DEVCOREDUMP_ABORT)
+			hci_devcoredump_reset(hdev);
+		hci_dev_unlock(hdev);
+	}
+}
+EXPORT_SYMBOL(hci_devcoredump_rx);
+
+void hci_devcoredump_timeout(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev,
+					    dump.dump_timeout.work);
+	u32 dump_size;
+
+	hci_devcoredump_notify(hdev, HCI_DEVCOREDUMP_TIMEOUT);
+
+	hci_dev_lock(hdev);
+
+	cancel_work_sync(&hdev->dump.dump_rx);
+
+	hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_TIMEOUT);
+	dump_size = hdev->dump.tail - hdev->dump.head;
+	bt_dev_info(hdev, "Devcoredump timeout with size %u (expect %u)",
+		    dump_size, hdev->dump.alloc_size);
+
+	/* Emit a devcoredump with the available data */
+	dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL);
+
+	hci_devcoredump_reset(hdev);
+
+	hci_dev_unlock(hdev);
+}
+EXPORT_SYMBOL(hci_devcoredump_timeout);
+
+int hci_devcoredump_register(struct hci_dev *hdev, coredump_t coredump,
+			     dmp_hdr_t dmp_hdr, notify_change_t notify_change)
+{
+	/* Driver must implement coredump() and dmp_hdr() functions for
+	 * bluetooth devcoredump. The coredump() should trigger a coredump
+	 * event on the controller when the device's coredump sysfs entry is
+	 * written to. The dmp_hdr() should create a dump header to identify
+	 * the controller/fw/driver info.
+	 */
+	if (!coredump || !dmp_hdr)
+		return -EINVAL;
+
+	hci_dev_lock(hdev);
+	hdev->dump.coredump = coredump;
+	hdev->dump.dmp_hdr = dmp_hdr;
+	hdev->dump.notify_change = notify_change;
+	hdev->dump.supported = true;
+	hci_dev_unlock(hdev);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_register);
+
+static inline bool hci_devcoredump_enabled(struct hci_dev *hdev)
+{
+	/* The 'supported' flag is true when the driver registers with the HCI
+	 * devcoredump API, whereas, the 'enabled' is controlled via a sysfs
+	 * entry. For drivers like btusb which supports multiple vendor drivers,
+	 * it is possible that the vendor driver does not support but the
+	 * interface is provided by the base btusb driver. So, check both.
+	 */
+	if (hdev->dump.supported && hdev->dump.enabled)
+		return hdev->dump.enabled(hdev);
+
+	return false;
+}
+
+int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hci_devcoredump_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(sizeof(dmp_size), GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump init");
+		return -ENOMEM;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_INIT;
+	skb_put_data(skb, &dmp_size, sizeof(dmp_size));
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_init);
+
+int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	if (!skb)
+		return -ENOMEM;
+
+	if (!hci_devcoredump_enabled(hdev)) {
+		kfree_skb(skb);
+		return -EOPNOTSUPP;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_SKB;
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_append);
+
+int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len)
+{
+	struct hci_devcoredump_skb_pattern p;
+	struct sk_buff *skb = NULL;
+
+	if (!hci_devcoredump_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(sizeof(p), GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump pattern");
+		return -ENOMEM;
+	}
+
+	p.pattern = pattern;
+	p.len = len;
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_PATTERN;
+	skb_put_data(skb, &p, sizeof(p));
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_append_pattern);
+
+int hci_devcoredump_complete(struct hci_dev *hdev)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hci_devcoredump_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump complete");
+		return -ENOMEM;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_COMPLETE;
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_complete);
+
+int hci_devcoredump_abort(struct hci_dev *hdev)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hci_devcoredump_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump abort");
+		return -ENOMEM;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_ABORT;
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_abort);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b3a5a3cc9372..9a697190c7a8 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2510,14 +2510,23 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 	INIT_WORK(&hdev->tx_work, hci_tx_work);
 	INIT_WORK(&hdev->power_on, hci_power_on);
 	INIT_WORK(&hdev->error_reset, hci_error_reset);
+#ifdef CONFIG_DEV_COREDUMP
+	INIT_WORK(&hdev->dump.dump_rx, hci_devcoredump_rx);
+#endif
 
 	hci_cmd_sync_init(hdev);
 
 	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
+#ifdef CONFIG_DEV_COREDUMP
+	INIT_DELAYED_WORK(&hdev->dump.dump_timeout, hci_devcoredump_timeout);
+#endif
 
 	skb_queue_head_init(&hdev->rx_q);
 	skb_queue_head_init(&hdev->cmd_q);
 	skb_queue_head_init(&hdev->raw_q);
+#ifdef CONFIG_DEV_COREDUMP
+	skb_queue_head_init(&hdev->dump.dump_q);
+#endif
 
 	init_waitqueue_head(&hdev->req_wait_q);
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index e6d804b82b67..09d74ae2b81c 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4337,6 +4337,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		goto done;
 	}
 
+	hci_devcoredump_reset(hdev);
+
 	set_bit(HCI_RUNNING, &hdev->flags);
 	hci_sock_dev_event(hdev, HCI_DEV_OPEN);
 
-- 
2.37.1.559.g78731f0fdb-goog

