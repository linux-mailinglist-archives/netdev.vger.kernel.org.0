Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05942B8895
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgKRXoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727292AbgKRXoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:44:06 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232DDC0613D6
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:44:06 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q10so2661816pfn.0
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YNVmomPsfoKndzhCgIIwvVulBDHSaUyYS9Lmo0Fh/4g=;
        b=nk0GhbdpNORnDl6nwa8uen7IN7R0ti5psYLfmNxsQms1GpbKULyrzSWIg0BePVl1Wo
         mCRcnyHsVEGxEhYU/M1dPxjBr+SvW5i0aY9SYkTMMS+uLIAzlpC1QNHxWOwitZ8sdJst
         URUi+ZmlnyPas/Jr3Sz6DnLgu4c+lfg8X2Bn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YNVmomPsfoKndzhCgIIwvVulBDHSaUyYS9Lmo0Fh/4g=;
        b=cIWGyTP9HQy7FsuIiGJ8BbGPNShsTDFglXBnbwh6xcuXRfPLDiOPPvGIxF6B+Q1+E2
         10+ryuLeSE36DhITpAC1BZdbn67aemfxV9lDwQfTs9nVmLWHFiBUAFNyTSGB+/V79nI6
         E2snA4f9fOhlwHn441IYne9uE1eZ1PWWHdOeBheIYpn+ho1SjB3jU2lI+i53WOQ/L8Rw
         qDiZYimCfX8JskLwUnTUv54vhDldzbhFwMHuiU8jJ/cNoQq1L5+kQ3a2cXSSMfvt2GhK
         qNoVE0Bsdf6itaOQSF3nPJdYQpWbtvRe6iYJThOQcNfgi5PZwkYxOhth7/ZLB/t390Nv
         35Sw==
X-Gm-Message-State: AOAM532V2VER0vDUB5BWEIVy2M2jZPQDn15q7r3jCBQtqH3rDfc9QhPt
        YNNRWfne2BuHsDuRNFc4/e99Aw==
X-Google-Smtp-Source: ABdhPJxfameOzBmMxAymwmfLvw5AeR08O20U7SIQojuZCeR4uL/urVzwO2QbUVUlo7uaDeS08eiGUQ==
X-Received: by 2002:aa7:8c16:0:b029:196:33d2:721f with SMTP id c22-20020aa78c160000b029019633d2721fmr6414397pfd.70.1605743045713;
        Wed, 18 Nov 2020 15:44:05 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id f6sm21437435pgi.70.2020.11.18.15.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 15:44:05 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, mcchou@chromium.org,
        danielwinkler@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/3] Bluetooth: Rename and move clean_up_hci_state
Date:   Wed, 18 Nov 2020 15:43:50 -0800
Message-Id: <20201118154349.1.I088e8a8c015ee9cc5fb5fc52c02ff4caf9a79031@changeid>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
In-Reply-To: <20201118234352.2138694-1-abhishekpandit@chromium.org>
References: <20201118234352.2138694-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename clean_up_hci_state and move to the core header so that we can
power down the controller from within the kernel rather than just via
mgmt commands.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Daniel Winkler <danielwinkler@google.com>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
---

 include/net/bluetooth/hci_core.h |  2 ++
 net/bluetooth/hci_core.c         | 45 +++++++++++++++++++++++++++++++
 net/bluetooth/mgmt.c             | 46 +-------------------------------
 3 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9873e1c8cd163b..ff32d5a856f17f 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1072,6 +1072,8 @@ void hci_conn_enter_active_mode(struct hci_conn *conn, __u8 force_active);
 
 void hci_le_conn_failed(struct hci_conn *conn, u8 status);
 
+int hci_clean_up_state(struct hci_dev *hdev);
+
 /*
  * hci_conn_get() and hci_conn_put() are used to control the life-time of an
  * "hci_conn" object. They do not guarantee that the hci_conn object is running,
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 502552d6e9aff3..8e90850d6d769e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2290,6 +2290,51 @@ static void hci_power_on(struct work_struct *work)
 	}
 }
 
+static void clean_up_hci_complete(struct hci_dev *hdev, u8 status, u16 opcode)
+{
+	BT_DBG("%s status 0x%02x", hdev->name, status);
+
+	if (hci_conn_count(hdev) == 0) {
+		cancel_delayed_work(&hdev->power_off);
+		queue_work(hdev->req_workqueue, &hdev->power_off.work);
+	}
+}
+
+/* This function requires the caller holds hdev->lock */
+int hci_clean_up_state(struct hci_dev *hdev)
+{
+	struct hci_request req;
+	struct hci_conn *conn;
+	bool discov_stopped;
+	int err;
+	u8 scan = 0x00;
+
+	hci_req_init(&req, hdev);
+
+	if (test_bit(HCI_ISCAN, &hdev->flags) ||
+	    test_bit(HCI_PSCAN, &hdev->flags)) {
+		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
+	}
+
+	hci_req_clear_adv_instance(hdev, NULL, NULL, 0x00, false);
+
+	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
+		__hci_req_disable_advertising(&req);
+
+	discov_stopped = hci_req_stop_discovery(&req);
+
+	list_for_each_entry(conn, &hdev->conn_hash.list, list) {
+		/* 0x15 == Terminated due to Power Off */
+		__hci_abort_conn(&req, conn, 0x15);
+	}
+
+	err = hci_req_run(&req, clean_up_hci_complete);
+	if (!err && discov_stopped)
+		hci_discovery_set_state(hdev, DISCOVERY_STOPPING);
+
+	return err;
+}
+
 static void hci_power_off(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev,
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 12d7b368b428e8..ea136a6b730f9a 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1122,16 +1122,6 @@ static int send_settings_rsp(struct sock *sk, u16 opcode, struct hci_dev *hdev)
 				 sizeof(settings));
 }
 
-static void clean_up_hci_complete(struct hci_dev *hdev, u8 status, u16 opcode)
-{
-	bt_dev_dbg(hdev, "status 0x%02x", status);
-
-	if (hci_conn_count(hdev) == 0) {
-		cancel_delayed_work(&hdev->power_off);
-		queue_work(hdev->req_workqueue, &hdev->power_off.work);
-	}
-}
-
 void mgmt_advertising_added(struct sock *sk, struct hci_dev *hdev, u8 instance)
 {
 	struct mgmt_ev_advertising_added ev;
@@ -1159,40 +1149,6 @@ static void cancel_adv_timeout(struct hci_dev *hdev)
 	}
 }
 
-static int clean_up_hci_state(struct hci_dev *hdev)
-{
-	struct hci_request req;
-	struct hci_conn *conn;
-	bool discov_stopped;
-	int err;
-
-	hci_req_init(&req, hdev);
-
-	if (test_bit(HCI_ISCAN, &hdev->flags) ||
-	    test_bit(HCI_PSCAN, &hdev->flags)) {
-		u8 scan = 0x00;
-		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
-	}
-
-	hci_req_clear_adv_instance(hdev, NULL, NULL, 0x00, false);
-
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
-		__hci_req_disable_advertising(&req);
-
-	discov_stopped = hci_req_stop_discovery(&req);
-
-	list_for_each_entry(conn, &hdev->conn_hash.list, list) {
-		/* 0x15 == Terminated due to Power Off */
-		__hci_abort_conn(&req, conn, 0x15);
-	}
-
-	err = hci_req_run(&req, clean_up_hci_complete);
-	if (!err && discov_stopped)
-		hci_discovery_set_state(hdev, DISCOVERY_STOPPING);
-
-	return err;
-}
-
 static int set_powered(struct sock *sk, struct hci_dev *hdev, void *data,
 		       u16 len)
 {
@@ -1230,7 +1186,7 @@ static int set_powered(struct sock *sk, struct hci_dev *hdev, void *data,
 		err = 0;
 	} else {
 		/* Disconnect connections, stop scans, etc */
-		err = clean_up_hci_state(hdev);
+		err = hci_clean_up_state(hdev);
 		if (!err)
 			queue_delayed_work(hdev->req_workqueue, &hdev->power_off,
 					   HCI_POWER_OFF_TIMEOUT);
-- 
2.29.2.299.gdc1121823c-goog

