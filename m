Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF71835A892
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhDIWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbhDIWEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 18:04:24 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625E1C061763
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 15:04:11 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id gu11so1687452qvb.0
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 15:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fQE9PWS5vv/FTKpRLev+pHKn5IJsSHazWeniE3U08BM=;
        b=qTykMhwSGh7Sgg9lCvvpa4skHVXY2XMmc+6hEaMAPb6weE+iiSX4uLz31Y3sNWUEbo
         NyS4D9/GuCngK2YBTmvOaillXi/3YXjvv5oPsjvWiSNgPNUxRDfFVnLjA+Qf3ur1yPMV
         avM30Zq5iWJFNg/qay3yn6XNyBTMT9Jq/8B5LZx6LSxLklc4ZEGMN3icEhYZoyEq7uB0
         Seh1p/eSHmcS5iA9ad4EkZg5OqDceM+fn+FcKPBorfNGsOCimBOKCsY9DMG+wKyboEWH
         QHEBcoCgB6JnoMK8cU4Exv9LojNGijJCO5rhqoP5yQHwySm7l4/gFZJDBIdSqAdCiJQt
         P3xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fQE9PWS5vv/FTKpRLev+pHKn5IJsSHazWeniE3U08BM=;
        b=VO2YW0+QakI9bD1TlDgAQxBbyLjqsWijF6MRFr6Fv0ihlufLYM6wTWY7Ovx54jxdIr
         pe69YTGgsaS460Fc1BiMnH+OkxmaKBPHS+gN3tu06ADELZPeEN/vUWmvxJifxNgV6Ghq
         25N2rMi6qk4//IY4liajtnGoYcNtM0JXhrxlX0kLpB0qTOIA6848u3hD8Vp7wUNXOzEL
         WrHsf15yC5tumHeR7XuvE0+J+prYDYRylLAkG6m3EjBwLYyHmohmJlwPTUpK9gQU0vBU
         9/O99KbkZD0qorJDN+HmxilMrdp6Put2xeX+TGnagi5IQcpYqkahmai7fgK0VOqnW1cy
         X1XA==
X-Gm-Message-State: AOAM533i3nV7qKgwJXEQM0/agss2myMYu7ECu5ILC14oJeZc9/Wyp8qB
        2+XFRo1BFwb1MqFP9x6fDuOUhVxp89Wj
X-Google-Smtp-Source: ABdhPJwCK1Br/M9Rz5es79YqJJFGH7lvo8L4Z55POq0K9L7+Y25hlXweuY049BJ+XskGjOR54tUirubn6dXR
X-Received: from yudiliu.mtv.corp.google.com ([2620:15c:202:201:bce3:ed34:c9ac:28c1])
 (user=yudiliu job=sendgmr) by 2002:ad4:4f07:: with SMTP id
 fb7mr13699212qvb.30.1618005850489; Fri, 09 Apr 2021 15:04:10 -0700 (PDT)
Date:   Fri,  9 Apr 2021 15:04:06 -0700
Message-Id: <20210409150356.v2.1.Id5ee0a2edda8f0902498aaeb1b6c78d062579b75@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH v2] Bluetooth: Return whether a connection is outbound
From:   Yu Liu <yudiliu@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org
Cc:     Yu Liu <yudiliu@google.com>, Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an MGMT_EV_DEVICE_CONNECTED event is reported back to the user
space we will set the flags to tell if the established connection is
outbound or not. This is useful for the user space to log better metrics
and error messages.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Yu Liu <yudiliu@google.com>
---

Changes in v2:
- Defined the bit as MGMT_DEV_FOUND_INITIATED_CONN

Changes in v1:
- Initial change

 include/net/bluetooth/hci_core.h | 2 +-
 include/net/bluetooth/mgmt.h     | 1 +
 net/bluetooth/hci_event.c        | 8 ++++----
 net/bluetooth/l2cap_core.c       | 2 +-
 net/bluetooth/mgmt.c             | 6 +++++-
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ca4ac6603b9a..d2876b758770 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1756,7 +1756,7 @@ void __mgmt_power_off(struct hci_dev *hdev);
 void mgmt_new_link_key(struct hci_dev *hdev, struct link_key *key,
 		       bool persistent);
 void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
-			   u32 flags, u8 *name, u8 name_len);
+			   u8 *name, u8 name_len);
 void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			      u8 link_type, u8 addr_type, u8 reason,
 			      bool mgmt_connected);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a7cffb069565..a03c62b1dc2f 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -939,6 +939,7 @@ struct mgmt_ev_auth_failed {
 #define MGMT_DEV_FOUND_CONFIRM_NAME    0x01
 #define MGMT_DEV_FOUND_LEGACY_PAIRING  0x02
 #define MGMT_DEV_FOUND_NOT_CONNECTABLE 0x04
+#define MGMT_DEV_FOUND_INITIATED_CONN  0x08
 
 #define MGMT_EV_DEVICE_FOUND		0x0012
 struct mgmt_ev_device_found {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 593eafa282e3..35b1adb2287c 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2071,7 +2071,7 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
 	if (conn &&
 	    (conn->state == BT_CONFIG || conn->state == BT_CONNECTED) &&
 	    !test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags))
-		mgmt_device_connected(hdev, conn, 0, name, name_len);
+		mgmt_device_connected(hdev, conn, name, name_len);
 
 	if (discov->state == DISCOVERY_STOPPED)
 		return;
@@ -3258,7 +3258,7 @@ static void hci_remote_features_evt(struct hci_dev *hdev,
 		cp.pscan_rep_mode = 0x02;
 		hci_send_cmd(hdev, HCI_OP_REMOTE_NAME_REQ, sizeof(cp), &cp);
 	} else if (!test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags))
-		mgmt_device_connected(hdev, conn, 0, NULL, 0);
+		mgmt_device_connected(hdev, conn, NULL, 0);
 
 	if (!hci_outgoing_auth_needed(hdev, conn)) {
 		conn->state = BT_CONNECTED;
@@ -4332,7 +4332,7 @@ static void hci_remote_ext_features_evt(struct hci_dev *hdev,
 		cp.pscan_rep_mode = 0x02;
 		hci_send_cmd(hdev, HCI_OP_REMOTE_NAME_REQ, sizeof(cp), &cp);
 	} else if (!test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags))
-		mgmt_device_connected(hdev, conn, 0, NULL, 0);
+		mgmt_device_connected(hdev, conn, NULL, 0);
 
 	if (!hci_outgoing_auth_needed(hdev, conn)) {
 		conn->state = BT_CONNECTED;
@@ -5206,7 +5206,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	}
 
 	if (!test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags))
-		mgmt_device_connected(hdev, conn, 0, NULL, 0);
+		mgmt_device_connected(hdev, conn, NULL, 0);
 
 	conn->sec_level = BT_SECURITY_LOW;
 	conn->handle = handle;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 140669456b6f..821d46ba6e74 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4237,7 +4237,7 @@ static int l2cap_connect_req(struct l2cap_conn *conn,
 	hci_dev_lock(hdev);
 	if (hci_dev_test_flag(hdev, HCI_MGMT) &&
 	    !test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &hcon->flags))
-		mgmt_device_connected(hdev, hcon, 0, NULL, 0);
+		mgmt_device_connected(hdev, hcon, NULL, 0);
 	hci_dev_unlock(hdev);
 
 	l2cap_connect(conn, cmd, data, L2CAP_CONN_RSP, 0);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 09e099c419f2..c594e0c2dd23 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8765,15 +8765,19 @@ void mgmt_new_conn_param(struct hci_dev *hdev, bdaddr_t *bdaddr,
 }
 
 void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
-			   u32 flags, u8 *name, u8 name_len)
+			   u8 *name, u8 name_len)
 {
 	char buf[512];
 	struct mgmt_ev_device_connected *ev = (void *) buf;
 	u16 eir_len = 0;
+	u32 flags = 0;
 
 	bacpy(&ev->addr.bdaddr, &conn->dst);
 	ev->addr.type = link_to_bdaddr(conn->type, conn->dst_type);
 
+	if (conn->out)
+		flags |= MGMT_DEV_FOUND_INITIATED_CONN;
+
 	ev->flags = __cpu_to_le32(flags);
 
 	/* We must ensure that the EIR Data fields are ordered and
-- 
2.31.1.295.g9ea45b61b8-goog

