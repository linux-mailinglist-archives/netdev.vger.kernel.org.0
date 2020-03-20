Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8AF18C4EB
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 02:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgCTBuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 21:50:00 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46056 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgCTBt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 21:49:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id m15so2248566pgv.12
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 18:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6QLaOkw0qL1wPTVBV/NhMql+CDMGWPnkMDm6IsgeElU=;
        b=OULc9rPlk2rUQzIDcIrf58PV9+9wgXPLPQ6+yzpj1XqvMhf1y3VqVMvf09vzGVLKx3
         CISOnH+R6lbyR5raETRXNjtqzrRPA8AihLQqzftMUzmlN0bfE/Ak5q4u+1qKgaL2rT/d
         M7wfPpBaDVSzNUNgl3/QSqQfSKiCCNE0qlGUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6QLaOkw0qL1wPTVBV/NhMql+CDMGWPnkMDm6IsgeElU=;
        b=gcdeor0HURnrKdu267XM4WnfOkY+StXsjyYFTuFL0bcsxkkVpP2PPN7zAOHcYmddM4
         SviS5SSpYz9fKU+cfn7he1UvJsKhQkCP01veQz8kuKPp5A1Lek9uJWBx0jwHvBt+F1ni
         0lJIjgLfNL/x9VWX05ehfsNjDgkfsmb8bIKQscZccMxoOW+1CeJTpEElfmAceVIDxa1V
         IWNbAnx5niwlTYT39+wegdGwaHBwZcWrCIDKU3Tu3UfLiqszn3/wwjh4EF2GRwUyCXCY
         xNZzxOnB3LaCbPpZGi6KjNsAE/Uei8n5uLubdCDEE8TrDZprJ9QpSrLHwgApE68Lzaa1
         yuIQ==
X-Gm-Message-State: ANhLgQ0D6erWo0j6KbQYbnxi1c4yAtC5Gn9tpFVEX51GnRnAh4BDswGJ
        Y7fHQ0lmprhTn3Z2q+QmDUVbbg==
X-Google-Smtp-Source: ADFU+vuoTqkL9jVYXdk5dtCMX6E69hGo5tascQrKBeEwatu0Y9WND0HIhZq9ZviX8oqzCN2ewNF4HA==
X-Received: by 2002:a63:67c5:: with SMTP id b188mr6178221pgc.111.1584668998355;
        Thu, 19 Mar 2020 18:49:58 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id y9sm3450235pgo.80.2020.03.19.18.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 18:49:58 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 1/1] Bluetooth: Update add_device to accept flags
Date:   Thu, 19 Mar 2020 18:49:49 -0700
Message-Id: <20200319184913.RFC.1.I4657d5566e8562d9813915e16a1a38a27195671d@changeid>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
In-Reply-To: <20200320014950.85018-1-abhishekpandit@chromium.org>
References: <20200320014950.85018-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the capability to set flags on devices being added via add_device.
The first flag being used is the wakeable flag which allows the device
to wake the system from suspend.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 include/net/bluetooth/mgmt.h |  5 ++++-
 net/bluetooth/mgmt.c         | 42 +++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index f41cd87550dc..e9db9b1a4436 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -445,8 +445,11 @@ struct mgmt_rp_get_clock_info {
 struct mgmt_cp_add_device {
 	struct mgmt_addr_info addr;
 	__u8	action;
+	__u8	flags_mask;
+	__u8	flags_value;
 } __packed;
-#define MGMT_ADD_DEVICE_SIZE		(MGMT_ADDR_INFO_SIZE + 1)
+#define MGMT_ADD_DEVICE_SIZE		(MGMT_ADDR_INFO_SIZE + 3)
+#define DEVICE_FLAG_WAKEABLE		(1 << 0)
 
 #define MGMT_OP_REMOVE_DEVICE		0x0034
 struct mgmt_cp_remove_device {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 6552003a170e..ae241f541713 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5759,6 +5759,25 @@ static int hci_conn_params_set(struct hci_dev *hdev, bdaddr_t *addr,
 	return 0;
 }
 
+static int hci_conn_params_set_flags(struct hci_dev *hdev, bdaddr_t *addr,
+				     u8 addr_type, u8 flags_mask,
+				     u8 flags_value)
+{
+	struct hci_conn_params *params =
+		hci_conn_params_add(hdev, addr, addr_type);
+
+	if (!params)
+		return -EIO;
+
+	if (flags_mask & DEVICE_FLAG_WAKEABLE)
+		params->wakeable = flags_mask & DEVICE_FLAG_WAKEABLE;
+
+	bt_dev_dbg(hdev, "addr %pMR (type %u) flag mask %u, values %u", addr,
+		   addr_type, flags_mask, flags_value);
+
+	return 0;
+}
+
 static void device_added(struct sock *sk, struct hci_dev *hdev,
 			 bdaddr_t *bdaddr, u8 type, u8 action)
 {
@@ -5805,11 +5824,23 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 
 		err = hci_bdaddr_list_add(&hdev->whitelist, &cp->addr.bdaddr,
 					  cp->addr.type);
-		if (err)
+		if (err && err != -EEXIST)
 			goto unlock;
 
 		hci_req_update_scan(hdev);
 
+		/* Modify wake capable property if set. */
+		if (cp->flags_mask & DEVICE_FLAG_WAKEABLE) {
+			if (cp->flags_value & DEVICE_FLAG_WAKEABLE)
+				hci_bdaddr_list_add(&hdev->wakeable,
+						    &cp->addr.bdaddr,
+						    cp->addr.type);
+			else
+				hci_bdaddr_list_del(&hdev->wakeable,
+						    &cp->addr.bdaddr,
+						    cp->addr.type);
+		}
+
 		goto added;
 	}
 
@@ -5845,6 +5876,15 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	/* Set or clear flags that were configured for this device */
+	if (hci_conn_params_set_flags(hdev, &cp->addr.bdaddr, addr_type,
+				      cp->flags_mask, cp->flags_value)) {
+		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_DEVICE,
+					MGMT_STATUS_FAILED, &cp->addr,
+					sizeof(cp->addr));
+		goto unlock;
+	}
+
 	hci_update_background_scan(hdev);
 
 added:
-- 
2.25.1.696.g5e7596f4ac-goog

