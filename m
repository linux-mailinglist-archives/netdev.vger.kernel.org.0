Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA74832B3B8
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449975AbhCCEFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581341AbhCBSum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 13:50:42 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CFDC0698C1
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 10:49:45 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id e9so2637941pjj.0
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 10:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u7W2UvT3BWsclOQ3yTE8be/4H7Rp18TFIX3NsdArnfs=;
        b=fdWtSvbArknoqc3tctztg3CfLtN6oa1RT2Ctuk6ZULuCcZAl60XEHp43+QQeHFFaAJ
         FFhPcZC8JpOoVCczGD3DsCoKg6l1WpMbxk7bUB8pdW776cFGLNKcC6QilLf3wMtjjWwT
         +bniJlp2NS043sM4XAolJTL7t9rc3TyzN2GCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u7W2UvT3BWsclOQ3yTE8be/4H7Rp18TFIX3NsdArnfs=;
        b=h9HHAnnxFkQdPhuedwiYpbQdSWyZmeDbfKqRGGMiAW6/X55XQk4T4VuObpDGGS+F34
         45YFzJmZYcbtD40gHX7hAaf6m+r0MKfq5fnCNK5F8u5qn6dosEaszfQkhsJqKeK1YPaO
         l59XkzgH5z4Cwg6PaVkGuIfTRi8Au3F6rKl/zzuXNX3fkRq9PQXXcwP6JuSTObCDA9xv
         gu/cFrsgvBKaYCwjZ3Iur4Q+YoY2JBXJ3K5l/3m7ja4Fud0PbvEJ4y7s7Plp2M9Nx0Hw
         IDttDCjlDLIVMZvmwNT4ZrA4lHG2qwV+yARMABwckUj5r1HiEg4la27h8ZlU3F0ydHrL
         vWCw==
X-Gm-Message-State: AOAM531J3Jejk3QCA55BScGPW6tMx7bxmvTstsqIWVajBV4dPK8RmybJ
        Wzy+tj1xtXbge+9Bi4b1zi4W+A==
X-Google-Smtp-Source: ABdhPJzWqsO37yRTPl4RLQZHFXevT+YiB6QEB9fGxBb2zPHJ+7Rft4IGQ9LfLwXJ/BHnBZaphA1rQw==
X-Received: by 2002:a17:90a:154e:: with SMTP id y14mr5831607pja.229.1614710985126;
        Tue, 02 Mar 2021 10:49:45 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:9c83:cccc:4c1:7b17])
        by smtp.gmail.com with ESMTPSA id 140sm21800839pfv.83.2021.03.02.10.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 10:49:44 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Hans de Goede <hdegoede@redhat.com>,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Subject: [PATCH v2 1/1] Bluetooth: Remove unneeded commands for suspend
Date:   Tue,  2 Mar 2021 10:49:36 -0800
Message-Id: <20210302104931.v2.1.Ifcac8bd85b5339135af8e08370bacecc518b1c35@changeid>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
In-Reply-To: <20210302184936.619740-1-abhishekpandit@chromium.org>
References: <20210302184936.619740-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During suspend, there are a few scan enable and set event filter
commands that don't need to be sent unless there are actual BR/EDR
devices capable of waking the system. Check the HCI_PSCAN bit before
writing scan enable and use a new dev flag, HCI_EVENT_FILTER_CONFIGURED
to control whether to clear the event filter.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

Changes in v2:
* Removed hci_dev_lock from hci_cc_set_event_filter since flags are
  set/cleared atomically

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_event.c   | 24 ++++++++++++++++++++
 net/bluetooth/hci_request.c | 44 +++++++++++++++++++++++--------------
 3 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index ba2f439bc04d34..ea4ae551c42687 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -320,6 +320,7 @@ enum {
 	HCI_BREDR_ENABLED,
 	HCI_LE_SCAN_INTERRUPTED,
 	HCI_WIDEBAND_SPEECH_ENABLED,
+	HCI_EVENT_FILTER_CONFIGURED,
 
 	HCI_DUT_MODE,
 	HCI_VENDOR_DIAG,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 67668be3461e93..6eadc999ea1474 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -395,6 +395,26 @@ static void hci_cc_write_scan_enable(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
+static void hci_cc_set_event_filter(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	__u8 status = *((__u8 *)skb->data);
+	struct hci_cp_set_event_filter *cp;
+	void *sent;
+
+	BT_DBG("%s status 0x%2.2x", hdev->name, status);
+
+	sent = hci_sent_cmd_data(hdev, HCI_OP_SET_EVENT_FLT);
+	if (!sent || status)
+		return;
+
+	cp = (struct hci_cp_set_event_filter *)sent;
+
+	if (cp->flt_type == HCI_FLT_CLEAR_ALL)
+		hci_dev_clear_flag(hdev, HCI_EVENT_FILTER_CONFIGURED);
+	else
+		hci_dev_set_flag(hdev, HCI_EVENT_FILTER_CONFIGURED);
+}
+
 static void hci_cc_read_class_of_dev(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_rp_read_class_of_dev *rp = (void *) skb->data;
@@ -3328,6 +3348,10 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		hci_cc_write_scan_enable(hdev, skb);
 		break;
 
+	case HCI_OP_SET_EVENT_FLT:
+		hci_cc_set_event_filter(hdev, skb);
+		break;
+
 	case HCI_OP_READ_CLASS_OF_DEV:
 		hci_cc_read_class_of_dev(hdev, skb);
 		break;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index e55976db4403e7..75a42178c82d9b 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1131,14 +1131,14 @@ static void hci_req_clear_event_filter(struct hci_request *req)
 {
 	struct hci_cp_set_event_filter f;
 
-	memset(&f, 0, sizeof(f));
-	f.flt_type = HCI_FLT_CLEAR_ALL;
-	hci_req_add(req, HCI_OP_SET_EVENT_FLT, 1, &f);
+	if (!hci_dev_test_flag(req->hdev, HCI_BREDR_ENABLED))
+		return;
 
-	/* Update page scan state (since we may have modified it when setting
-	 * the event filter).
-	 */
-	__hci_req_update_scan(req);
+	if (hci_dev_test_flag(req->hdev, HCI_EVENT_FILTER_CONFIGURED)) {
+		memset(&f, 0, sizeof(f));
+		f.flt_type = HCI_FLT_CLEAR_ALL;
+		hci_req_add(req, HCI_OP_SET_EVENT_FLT, 1, &f);
+	}
 }
 
 static void hci_req_set_event_filter(struct hci_request *req)
@@ -1147,6 +1147,10 @@ static void hci_req_set_event_filter(struct hci_request *req)
 	struct hci_cp_set_event_filter f;
 	struct hci_dev *hdev = req->hdev;
 	u8 scan = SCAN_DISABLED;
+	bool scanning = test_bit(HCI_PSCAN, &hdev->flags);
+
+	if (!hci_dev_test_flag(hdev, HCI_BREDR_ENABLED))
+		return;
 
 	/* Always clear event filter when starting */
 	hci_req_clear_event_filter(req);
@@ -1167,12 +1171,13 @@ static void hci_req_set_event_filter(struct hci_request *req)
 		scan = SCAN_PAGE;
 	}
 
-	if (scan)
+	if (scan && !scanning) {
 		set_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks);
-	else
+		hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
+	} else if (!scan && scanning) {
 		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
-
-	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
+		hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
+	}
 }
 
 static void cancel_adv_timeout(struct hci_dev *hdev)
@@ -1315,9 +1320,14 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 
 		hdev->advertising_paused = true;
 		hdev->advertising_old_state = old_state;
-		/* Disable page scan */
-		page_scan = SCAN_DISABLED;
-		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
+
+		/* Disable page scan if enabled */
+		if (test_bit(HCI_PSCAN, &hdev->flags)) {
+			page_scan = SCAN_DISABLED;
+			hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1,
+				    &page_scan);
+			set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
+		}
 
 		/* Disable LE passive scan if enabled */
 		if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
@@ -1328,9 +1338,6 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		/* Disable advertisement filters */
 		hci_req_add_set_adv_filter_enable(&req, false);
 
-		/* Mark task needing completion */
-		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
-
 		/* Prevent disconnects from causing scanning to be re-enabled */
 		hdev->scanning_paused = true;
 
@@ -1364,7 +1371,10 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		hdev->suspended = false;
 		hdev->scanning_paused = false;
 
+		/* Clear any event filters and restore scan state */
 		hci_req_clear_event_filter(&req);
+		__hci_req_update_scan(&req);
+
 		/* Reset passive/background scanning to normal */
 		__hci_update_background_scan(&req);
 		/* Enable all of the advertisement filters */
-- 
2.30.1.766.gb4fecdf3b7-goog

