Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50A81ED8DE
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 01:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgFCXDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 19:03:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45840 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCXDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 19:03:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id n23so2605994pgb.12
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 16:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SMKjPO0yxsKBw6WaCh5n1Xmlj31zLb02Q9MXdGn3Ze0=;
        b=RXaj8umFhhG77e1G0o5PsTSZeyKLdOhk40x2RCi2Ln9Cy3sUcUcRPpJasNJna+KFi/
         ragEizEIi39TWrfbX3gMMfGKqqIjyZrswzTbbzRNkkjc/AUzixnySmWKIQOd9hv5hbzV
         EPKAyjwNtx6/XLCFhdFkhZ/dKWtfQt9iBQt3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SMKjPO0yxsKBw6WaCh5n1Xmlj31zLb02Q9MXdGn3Ze0=;
        b=HD28QcqErHzMjkPfYitILARZYcBkEFflRWAox8GmUnfKrFsdMLJc4g3UTKeOePAj0h
         hvd2OHtGunOwFCWBM7bhBQB7CGiV26AUu53lvdZlT8O0A90zs290n0L33vuNvHpv3ypL
         So+DyqDyH5v2g/UTX2iyF6xpqwEu8DuoLhpCZTu6p3/NXPvqSWJJEKxhrVI3zh24uxFG
         uhFb+Fu3lMmm5sB8o6HlSlx3X+QnsMutKyAnhIlICjX7pskLjl2gB4q72hrucrju+oG+
         S/Id48qlxO4Hf+0VaSShEQy15WrzsGTUuLiVaMeVUpsej4bKOrumh13PY7ejJ40awBi2
         geww==
X-Gm-Message-State: AOAM532yPwmyBOYj0CG7pSOJkA9FtXR/79TZkrBvTJKTOqQzY7imf5Dk
        eb7MOdNQK71bXMpc7Nai4uFE3g==
X-Google-Smtp-Source: ABdhPJwsbgPFzkQaNLtmD4/tdIAgUcZYm9TuZxQdqYWnzToxP8aVHM3oVc0dtA316AHj8sgMm+4sxw==
X-Received: by 2002:a63:1207:: with SMTP id h7mr1568237pgl.241.1591225338558;
        Wed, 03 Jun 2020 16:02:18 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id b11sm2715999pfd.178.2020.06.03.16.02.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jun 2020 16:02:17 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Manish Mandlik <mmandlik@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 4/7] Bluetooth: Add handler of MGMT_OP_REMOVE_ADV_MONITOR
Date:   Wed,  3 Jun 2020 16:01:47 -0700
Message-Id: <20200603160058.v2.4.Ib4effd5813fb2f8585e2c7394735050c16a765eb@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200603160058.v2.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200603160058.v2.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the request handler of MGMT_OP_REMOVE_ADV_MONITOR command.
Note that the controller-based monitoring is not yet in place. This
removes the internal monitor(s) without sending HCI traffic, so the
request returns immediately.

The following test was performed.
- Issue btmgmt advmon-remove with valid and invalid handles.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v2: None

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 31 +++++++++++++++++++++++++++++++
 net/bluetooth/mgmt.c             | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 862d94f711bc0..78ac7fd282d77 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1242,6 +1242,7 @@ void hci_adv_instances_set_rpa_expired(struct hci_dev *hdev, bool rpa_expired);
 void hci_adv_monitors_clear(struct hci_dev *hdev);
 void hci_free_adv_monitor(struct adv_monitor *monitor);
 int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
+int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle);
 
 void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 93c16bfc6da15..1fcd0cc2dcc5b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3041,6 +3041,37 @@ int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 	return 0;
 }
 
+static int free_adv_monitor(int id, void *ptr, void *data)
+{
+	struct hci_dev *hdev = data;
+	struct adv_monitor *monitor = ptr;
+
+	idr_remove(&hdev->adv_monitors_idr, monitor->handle);
+	hci_free_adv_monitor(monitor);
+
+	return 0;
+}
+
+/* This function requires the caller holds hdev->lock */
+int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle)
+{
+	struct adv_monitor *monitor;
+
+	if (handle) {
+		monitor = idr_find(&hdev->adv_monitors_idr, handle);
+		if (!monitor)
+			return -ENOENT;
+
+		idr_remove(&hdev->adv_monitors_idr, monitor->handle);
+		hci_free_adv_monitor(monitor);
+	} else {
+		/* Remove all monitors if handle is 0. */
+		idr_for_each(&hdev->adv_monitors_idr, &free_adv_monitor, hdev);
+	}
+
+	return 0;
+}
+
 struct bdaddr_list *hci_bdaddr_list_lookup(struct list_head *bdaddr_list,
 					 bdaddr_t *bdaddr, u8 type)
 {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index e302f90fda9ce..a43a1e6d17cf9 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -114,6 +114,7 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_SET_EXP_FEATURE,
 	MGMT_OP_READ_ADV_MONITOR_FEATURES,
 	MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+	MGMT_OP_REMOVE_ADV_MONITOR,
 };
 
 static const u16 mgmt_events[] = {
@@ -3994,6 +3995,36 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
+static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
+			      void *data, u16 len)
+{
+	struct mgmt_cp_remove_adv_monitor *cp = data;
+	struct mgmt_rp_remove_adv_monitor rp;
+	int err;
+
+	BT_DBG("request for %s", hdev->name);
+
+	hci_dev_lock(hdev);
+
+	err = hci_remove_adv_monitor(hdev, cp->monitor_handle);
+	if (err == -ENOENT) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
+				      MGMT_STATUS_INVALID_INDEX);
+		goto unlock;
+	}
+
+	hci_dev_unlock(hdev);
+
+	rp.monitor_handle = cp->monitor_handle;
+
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
+				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
+
+unlock:
+	hci_dev_unlock(hdev);
+	return err;
+}
+
 static void read_local_oob_data_complete(struct hci_dev *hdev, u8 status,
 				         u16 opcode, struct sk_buff *skb)
 {
@@ -7445,6 +7476,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ read_adv_monitor_features, MGMT_READ_ADV_MONITOR_FEATURES_SIZE },
 	{ add_adv_patterns_monitor, MGMT_ADD_ADV_PATTERNS_MONITOR_SIZE,
 						HCI_MGMT_VAR_LEN },
+	{ remove_adv_monitor, MGMT_REMOVE_ADV_MONITOR_SIZE },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.26.2

