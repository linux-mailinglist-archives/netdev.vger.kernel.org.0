Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3AD3290AE
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbhCAUMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237671AbhCAUJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 15:09:48 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032CDC0617A7
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 12:06:18 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id jx13so301986pjb.1
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 12:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U+yZn5oAcut/C/aebOJ16/bGakvc9MpdGSWik0h5VXc=;
        b=WoqBGSdMrcG7i8F+POoakKo8qZE6yUVQgoE3Y8qtfWvdLpMLOZCPTFFQKFSpR4E/L7
         0cYCUSTthhZ89M8yRs/gH4Gk6O/9YuTsqFPhhW+v3MNPl7ZKrHGLDN4HhlKScp2QTYX2
         gOIBafTn/FrYPZkfvWQBE7NlZk1pEUmwAWO2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U+yZn5oAcut/C/aebOJ16/bGakvc9MpdGSWik0h5VXc=;
        b=iDxdWUVHkwIVUNvtVOOhAyQHlqIu5fszoVuEgFqcWy4+rmmbKwAR8/tx4pMpwvqrtb
         7Q3INqZSlzhhSvP501qHX4brUcsaeYOsjHoLcb6bUluq5RZ7ajhlX980JqHcnhUuhf4d
         F2eL4cT2aYbBXqnOUzrzx0DznlyoX5uWrPJKzDwnAgFApKK0U4cbXZsswJwD3dztxQnu
         5rWwfHV/7u90DK9ZsobNXPbL/4EVCSiiC0klSNtR210M02rDK8mv8ip75Nr9XORnt7to
         Z3z7tj9ctJ8T/aBigLEg78BTJs7jrE46WRiBngSCjdO0diF7Y0RGMQwwkquhF0EtvoaO
         7bag==
X-Gm-Message-State: AOAM532lD6ARZlLXrebcySo4NGMxLYuovY00ahFcmqGNODEwB/UmC6mY
        3ifMV/8QIaJoJb3UXf1yBMm9yw==
X-Google-Smtp-Source: ABdhPJyNiWBUOGz2CemLY+WQB6z0EWQ7Xrcxm+QMYPJbcIFbDa2D/IXXStrtHhATfs0WLrfwaI2Xgg==
X-Received: by 2002:a17:90a:ba16:: with SMTP id s22mr646925pjr.88.1614629177608;
        Mon, 01 Mar 2021 12:06:17 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:d800:e660:6ed:356a])
        by smtp.gmail.com with ESMTPSA id t4sm238256pjs.12.2021.03.01.12.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 12:06:17 -0800 (PST)
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
Subject: [PATCH 2/2] Bluetooth: Remove unneeded commands for suspend
Date:   Mon,  1 Mar 2021 12:06:05 -0800
Message-Id: <20210301120602.2.Ifcac8bd85b5339135af8e08370bacecc518b1c35@changeid>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
In-Reply-To: <20210301200605.106607-1-abhishekpandit@chromium.org>
References: <20210301200605.106607-1-abhishekpandit@chromium.org>
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

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_event.c   | 31 ++++++++++++++++++++++++++
 net/bluetooth/hci_request.c | 44 +++++++++++++++++++++++--------------
 3 files changed, 59 insertions(+), 17 deletions(-)

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
index 67668be3461e93..17847e672b98cf 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -395,6 +395,33 @@ static void hci_cc_write_scan_enable(struct hci_dev *hdev, struct sk_buff *skb)
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
+	if (!sent)
+		return;
+
+	cp = (struct hci_cp_set_event_filter *)sent;
+
+	hci_dev_lock(hdev);
+
+	if (status)
+		goto done;
+
+	if (cp->flt_type == HCI_FLT_CLEAR_ALL)
+		hci_dev_clear_flag(hdev, HCI_EVENT_FILTER_CONFIGURED);
+	else
+		hci_dev_set_flag(hdev, HCI_EVENT_FILTER_CONFIGURED);
+done:
+	hci_dev_unlock(hdev);
+}
+
 static void hci_cc_read_class_of_dev(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_rp_read_class_of_dev *rp = (void *) skb->data;
@@ -3328,6 +3355,10 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
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

