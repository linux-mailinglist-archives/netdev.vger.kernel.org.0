Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8200D2D1ED5
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgLHAOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgLHAOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 19:14:41 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C5AC06138C
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 16:13:17 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id i3so8500904pfd.6
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 16:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OZPKJ8iyX4JiTuKS52IveePlvykbl+yKfx0dWwq1kK8=;
        b=lmsv5Gu9va9hMa7bt7nSxlp+wA8AgcilngVtUiJdSp58LhtJNevUH3Ef6fRHF6qQUD
         b48sd+v3vN4yKTbINTv4QVGxnf0dDzYTRGTaMOUPzqt6WJLnmAwT5WqnQl394pj+jCRb
         s9XL0FalTQHLIB/+xsUt2QR50a2TM+xUfX4Dc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OZPKJ8iyX4JiTuKS52IveePlvykbl+yKfx0dWwq1kK8=;
        b=Jp0K2DyJPtb9YEFqAjdtp/DgMjCT3zylLG4xQrcAJfsNWMaF8mfoM7NVEjn9W1IrKI
         ZxfA9rYhNqpCBmUT+iIgSS2ESl357BFdYMzh8q8hEIVvB3lI4jDJXsIqn314bg21EOcC
         C13fM7nReG+luRUnSQ+RZ69yF8Os+Da+zu0/Tuga3H47FV3CvC5iIWfq6GPlIzcV/F2m
         dZvjp3uvgpVYjiwdbHvTiIU8Cq6rMh5yx+dXaiQmVYsWq+KwOT/BxCrYdKi/AzRuiUJD
         9CUxY+MSBTpbC+XZtQVejvO1hHqcNAZ8KVVMaD89fceFnVviSjej3uQGMRZczqcISYoK
         MTnQ==
X-Gm-Message-State: AOAM53121683BeticwzGxZfeZHIbJOs24u6Aic/jgNEOZFMQ9tjA/FeT
        xmnYFyncuiYyYHNU6cQMWthvCA==
X-Google-Smtp-Source: ABdhPJzKxGhKehwPyGf5t01jU+bp7iiEJId5HG1oskHUVVXBkgWabjQT/SXwRWyy3sVtY8oJ+A8LDQ==
X-Received: by 2002:a17:90a:6a48:: with SMTP id d8mr1247629pjm.130.1607386396602;
        Mon, 07 Dec 2020 16:13:16 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id v8sm514214pjk.39.2020.12.07.16.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:13:16 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        netdev@vger.kernel.org, Howard Chung <howardchung@google.com>
Subject: [PATCH 1/1] Bluetooth: Remove hci_req_le_suspend_config
Date:   Mon,  7 Dec 2020 16:12:54 -0800
Message-Id: <20201207161221.1.I94feef9a75a69b0d0c7038d975239ef3b1b93ee6@changeid>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201208001254.575890-1-abhishekpandit@chromium.org>
References: <20201208001254.575890-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a missing SUSPEND_SCAN_ENABLE in passive scan, remove the separate
function for configuring le scan during suspend and update the request
complete function to clear both enable and disable tasks.

Fixes: dce0a4be8054 ("Bluetooth: Set missing suspend task bits")
Reviewed-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 net/bluetooth/hci_request.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 71bffd745472043..5aa7bd5030a218c 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1087,6 +1087,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 	if (hdev->suspended) {
 		window = hdev->le_scan_window_suspend;
 		interval = hdev->le_scan_int_suspend;
+
+		set_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks);
 	} else if (hci_is_le_conn_scanning(hdev)) {
 		window = hdev->le_scan_window_connect;
 		interval = hdev->le_scan_int_connect;
@@ -1170,19 +1172,6 @@ static void hci_req_set_event_filter(struct hci_request *req)
 	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
 }
 
-static void hci_req_config_le_suspend_scan(struct hci_request *req)
-{
-	/* Before changing params disable scan if enabled */
-	if (hci_dev_test_flag(req->hdev, HCI_LE_SCAN))
-		hci_req_add_le_scan_disable(req, false);
-
-	/* Configure params and enable scanning */
-	hci_req_add_le_passive_scan(req);
-
-	/* Block suspend notifier on response */
-	set_bit(SUSPEND_SCAN_ENABLE, req->hdev->suspend_tasks);
-}
-
 static void cancel_adv_timeout(struct hci_dev *hdev)
 {
 	if (hdev->adv_instance_timeout) {
@@ -1245,8 +1234,10 @@ static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 {
 	bt_dev_dbg(hdev, "Request complete opcode=0x%x, status=0x%x", opcode,
 		   status);
-	if (test_and_clear_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks) ||
-	    test_and_clear_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks)) {
+	if (test_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks) ||
+	    test_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks)) {
+		clear_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks);
+		clear_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
 		wake_up(&hdev->suspend_wait_q);
 	}
 }
@@ -1336,7 +1327,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		/* Enable event filter for paired devices */
 		hci_req_set_event_filter(&req);
 		/* Enable passive scan at lower duty cycle */
-		hci_req_config_le_suspend_scan(&req);
+		__hci_update_background_scan(&req);
 		/* Pause scan changes again. */
 		hdev->scanning_paused = true;
 		hci_req_run(&req, suspend_req_complete);
@@ -1346,7 +1337,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 
 		hci_req_clear_event_filter(&req);
 		/* Reset passive/background scanning to normal */
-		hci_req_config_le_suspend_scan(&req);
+		__hci_update_background_scan(&req);
 
 		/* Unpause directed advertising */
 		hdev->advertising_paused = false;
-- 
2.29.2.576.ga3fc446d84-goog

