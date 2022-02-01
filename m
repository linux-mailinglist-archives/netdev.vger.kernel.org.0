Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615644A654E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbiBAUEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbiBAUD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:03:59 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4006FC06173E
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:03:59 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id s18so34121387wrv.7
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CtvsJlFbqfLsO5yxNiCSW8462wz3NLvD+3LUVcmaRSo=;
        b=KrAK0LqUBtRK2djoips1g3SIXIZxdEeQxU5BOLYi8h9c1+4j5aZERqXKbceeVUH6Ny
         lR3vWUcUEm/E/gZ4ITUR2coEL6DbKCe///jeOBWmKF1EFd8Kv4at9t2LwnSd5/1VvIB5
         GeKS+xoFAh+iThTUrk20YUKsM6rHRl6a6hlnMOMyKS0AWFibz8rIsh6xfiCEhrFCuWmM
         0XefwOvtPo+kBB2/CC14IFcBEpuzyKpjFnlKTEZgiTdlwfXVzBaSyYnSPGa2WabeXgic
         D8ihwYaFGM1vZcPME0Rts4SbXoV5NIWru1AntJ8hoaJ4yRPVLT5lC/AcASsaZvuQle1J
         n4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CtvsJlFbqfLsO5yxNiCSW8462wz3NLvD+3LUVcmaRSo=;
        b=WlcCXKnHiq1XtBOcexFXd5vq4zQOdO3Wldol55LLq1HXhqg5Su5A2Gg7dCZJOOHUSN
         67/TwymV6EXv6L4gChwX10ntAWiePeIL4DAHRW+feird1RRKoSHe391zPZkViV/Xdm9x
         /cKlThw15GKWkxgyzYz+0EstNNIlU+FMaPlPPSIXsfgCC9oiknJwhSQjjLHEj7/gjfTW
         AvpsApBsWCrSFygqxUTQN4ynfokd0iEUJz0tZFS3OLVaSZ28UMXXxwghu0gVEAXC6vyG
         fSYQ9O8887RVQthg3N6PMUAMc5wQbj4h/P9MYs0LhXirajp2t2iVfEGYofoQNh+ha9Cz
         tgOA==
X-Gm-Message-State: AOAM530GMrnq4AWwpKreyuPIh6fhAMfahNGO3qiMAoMst7XT4gNSFSiT
        pt/Z16IhU5m3BmQoZ7ws29E8TA==
X-Google-Smtp-Source: ABdhPJwzesRzh12lHSJ8wijI9YJ4wXIKFHVAn4HZudVDiZ2iWCzrf2nSH3Yq02EJp4VkN9PkZ64y2A==
X-Received: by 2002:adf:e4c4:: with SMTP id v4mr22488680wrm.332.1643745837666;
        Tue, 01 Feb 2022 12:03:57 -0800 (PST)
Received: from biernacki.c.googlers.com.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id m6sm3367280wmq.6.2022.02.01.12.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 12:03:56 -0800 (PST)
From:   Radoslaw Biernacki <rad@semihalf.com>
X-Google-Original-From: Radoslaw Biernacki <rad@semihalf.ocm>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        upstream@semihalf.com, Radoslaw Biernacki <rad@semihalf.com>,
        Angela Czubak <acz@semihalf.com>,
        Marek Maslanka <mm@semihalf.com>
Subject: [PATCH v2 1/2] Bluetooth: Fix skb allocation in mgmt_remote_name() & mgmt_device_connected()
Date:   Tue,  1 Feb 2022 20:03:52 +0000
Message-Id: <20220201200353.1331443-2-rad@semihalf.ocm>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220201200353.1331443-1-rad@semihalf.ocm>
References: <20220201200353.1331443-1-rad@semihalf.ocm>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Biernacki <rad@semihalf.com>

This patch fixes skb allocation, as lack of space for ev might push skb
tail beyond its end.
Also introduce eir_precalc_len() that can be used instead of magic
numbers for similar eir operations on skb.

Fixes: cf1bce1de7eeb ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_FOUND")
Fixes: e96741437ef0a ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_CONNECTED")
Signed-off-by: Angela Czubak <acz@semihalf.com>
Signed-off-by: Marek Maslanka <mm@semihalf.com>
Signed-off-by: Radoslaw Biernacki <rad@semihalf.com>
---
 net/bluetooth/eir.h  |  5 +++++
 net/bluetooth/mgmt.c | 18 ++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/eir.h b/net/bluetooth/eir.h
index 05e2e917fc25..e5876751f07e 100644
--- a/net/bluetooth/eir.h
+++ b/net/bluetooth/eir.h
@@ -15,6 +15,11 @@ u8 eir_create_scan_rsp(struct hci_dev *hdev, u8 instance, u8 *ptr);
 u8 eir_append_local_name(struct hci_dev *hdev, u8 *eir, u8 ad_len);
 u8 eir_append_appearance(struct hci_dev *hdev, u8 *ptr, u8 ad_len);
 
+static inline u16 eir_precalc_len(u8 data_len)
+{
+	return sizeof(u8) * 2 + data_len;
+}
+
 static inline u16 eir_append_data(u8 *eir, u16 eir_len, u8 type,
 				  u8 *data, u8 data_len)
 {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5dd684e0b259..43ca228104ce 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9061,12 +9061,14 @@ void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
 	u16 eir_len = 0;
 	u32 flags = 0;
 
+	/* allocate buff for LE or BR/EDR adv */
 	if (conn->le_adv_data_len > 0)
 		skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_CONNECTED,
-				     conn->le_adv_data_len);
+				     sizeof(*ev) + conn->le_adv_data_len);
 	else
 		skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_CONNECTED,
-				     2 + name_len + 5);
+				     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0) +
+				     eir_precalc_len(sizeof(conn->dev_class)));
 
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, &conn->dst);
@@ -9785,13 +9787,11 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 {
 	struct sk_buff *skb;
 	struct mgmt_ev_device_found *ev;
-	u16 eir_len;
-	u32 flags;
+	u16 eir_len = 0;
+	u32 flags = 0;
 
-	if (name_len)
-		skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, 2 + name_len);
-	else
-		skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, 0);
+	skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
+			     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0));
 
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, bdaddr);
@@ -9801,10 +9801,8 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	if (name) {
 		eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
 					  name_len);
-		flags = 0;
 		skb_put(skb, eir_len);
 	} else {
-		eir_len = 0;
 		flags = MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
 	}
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

