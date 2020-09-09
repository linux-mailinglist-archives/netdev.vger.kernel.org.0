Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984DF262C3D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgIIJoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729802AbgIIJmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:42:36 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C43C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 02:42:35 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n14so1673534pff.6
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 02:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LM8k8PH144bWX32V81bl75ySx0lFv/PzcP9daHe+hWQ=;
        b=JcM5Yd/IXdWAIh4gsWrVP3HdA6WElnrDWDk5l4ya3I60zj+1HjARAK0+x6mzB0ujBd
         lX7ywlj0rd48abSwN9kOWF1w2Z1l5yjFya/frkXvJF+D66IK5ywe4hDGhR/nrv8JNi2D
         wz5Zi/uG2Hh1qKDsvgAPX2UxC+Eb+9O7tuRWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LM8k8PH144bWX32V81bl75ySx0lFv/PzcP9daHe+hWQ=;
        b=BUP/sJmvlzZ/hjtHrVk0ZanXN+NLUIRd+1mqIu7bCb0t6KeYR1F8xooOJfSHoY+czU
         KNrAGPgrRfjoMzL2plYzu/0PPlKVZ6chMn+7wCSC+i4qgvxuwLkzrGfGCxIwuu309xrd
         W2j8xlsno6HYqGF8WJBJLmJupUzyTtbuVBSGriCkpiYQWSlvndeYSZ6lPP0XGGzZdgfk
         VcX9Ik1bYvo2uMhJaN/YRVaMNEP4EwbCLIGb0vzyUYPN4Dneb2g5t/Kx5lOYbXnR6oVP
         x9jmkUGIblrUPPnhTSw4rBTyu8C9eYsGGxagIrpgolLPsnFuVR3Pt9vqXMZJKAP40NrO
         a8Eg==
X-Gm-Message-State: AOAM531Pe5TJDzoqGbXo4FC5Kc9/yFFocRIwxkr1jnK03AcH0+qH1aCr
        C1JTNC4M8PZj+k4d45L8vVdqMw==
X-Google-Smtp-Source: ABdhPJwYRo0TowgGsBXgHgPUfP4VvsQRLtOvXZKYp67wUUhQCuoYO8pkD40Xhy3cIVN1ajxD4VzqnA==
X-Received: by 2002:a63:4b47:: with SMTP id k7mr2365937pgl.437.1599644554905;
        Wed, 09 Sep 2020 02:42:34 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:de4a:3eff:fe7d:ff5f])
        by smtp.gmail.com with ESMTPSA id a23sm1692275pgv.86.2020.09.09.02.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 02:42:34 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 1/2] Bluetooth: btusb: define HCI packet sizes of USB Alts
Date:   Wed,  9 Sep 2020 17:42:01 +0800
Message-Id: <20200909174129.v2.1.I56de28ec171134cb9f97062e2c304a72822ca38b@changeid>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
In-Reply-To: <20200909094202.3863687-1-josephsih@chromium.org>
References: <20200909094202.3863687-1-josephsih@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is desirable to define the HCI packet payload sizes of
USB alternate settings so that they can be exposed to user
space.

Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Joseph Hwang <josephsih@chromium.org>
---

Changes in v2:
- 1/2: Used sco_mtu instead of a new sco_pkt_len member in hdev.
- 1/2: Do not overwrite hdev->sco_mtu in hci_cc_read_buffer_size
  if it has been set in the USB interface.
- 2/2: Used BT_SNDMTU/BT_RCVMTU instead of creating a new opt name.
- 2/2: Used the existing conn->mtu instead of creating a new member
       in struct sco_pinfo.
- 2/2: Noted that the old SCO_OPTIONS in sco_sock_getsockopt_old()
       would just work as it uses sco_pi(sk)->conn->mtu.

 drivers/bluetooth/btusb.c | 43 +++++++++++++++++++++++++++++----------
 net/bluetooth/hci_event.c |  7 ++++++-
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fe80588c7bd3a8..a710233382afff 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -459,6 +459,22 @@ static const struct dmi_system_id btusb_needs_reset_resume_table[] = {
 #define BTUSB_WAKEUP_DISABLE	14
 #define BTUSB_USE_ALT1_FOR_WBS	15
 
+/* Per core spec 5, vol 4, part B, table 2.1,
+ * list the hci packet payload sizes for various ALT settings.
+ * This is used to set the packet length for the wideband speech.
+ * If a controller does not probe its usb alt setting, the default
+ * value will be 0. Any clients at upper layers should interpret it
+ * as a default value and set a proper packet length accordingly.
+ *
+ * To calculate the HCI packet payload length:
+ *   for alternate settings 1 - 5:
+ *     hci_packet_size = suggested_max_packet_size * 3 (packets) -
+ *                       3 (HCI header octets)
+ *   for alternate setting 6:
+ *     hci_packet_size = suggested_max_packet_size - 3 (HCI header octets)
+ */
+static const int hci_packet_size_usb_alt[] = { 0, 24, 48, 72, 96, 144, 60 };
+
 struct btusb_data {
 	struct hci_dev       *hdev;
 	struct usb_device    *udev;
@@ -3959,6 +3975,15 @@ static int btusb_probe(struct usb_interface *intf,
 	hdev->notify = btusb_notify;
 	hdev->prevent_wake = btusb_prevent_wake;
 
+	if (id->driver_info & BTUSB_AMP) {
+		/* AMP controllers do not support SCO packets */
+		data->isoc = NULL;
+	} else {
+		/* Interface orders are hardcoded in the specification */
+		data->isoc = usb_ifnum_to_if(data->udev, ifnum_base + 1);
+		data->isoc_ifnum = ifnum_base + 1;
+	}
+
 #ifdef CONFIG_PM
 	err = btusb_config_oob_wake(hdev);
 	if (err)
@@ -4022,6 +4047,10 @@ static int btusb_probe(struct usb_interface *intf,
 		hdev->set_diag = btintel_set_diag;
 		hdev->set_bdaddr = btintel_set_bdaddr;
 		hdev->cmd_timeout = btusb_intel_cmd_timeout;
+
+		if (btusb_find_altsetting(data, 6))
+			hdev->sco_mtu = hci_packet_size_usb_alt[6];
+
 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 		set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
@@ -4063,15 +4092,6 @@ static int btusb_probe(struct usb_interface *intf,
 		btusb_check_needs_reset_resume(intf);
 	}
 
-	if (id->driver_info & BTUSB_AMP) {
-		/* AMP controllers do not support SCO packets */
-		data->isoc = NULL;
-	} else {
-		/* Interface orders are hardcoded in the specification */
-		data->isoc = usb_ifnum_to_if(data->udev, ifnum_base + 1);
-		data->isoc_ifnum = ifnum_base + 1;
-	}
-
 	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_RTL) &&
 	    (id->driver_info & BTUSB_REALTEK)) {
 		hdev->setup = btrtl_setup_realtek;
@@ -4083,9 +4103,10 @@ static int btusb_probe(struct usb_interface *intf,
 		 * (DEVICE_REMOTE_WAKEUP)
 		 */
 		set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
-		if (btusb_find_altsetting(data, 1))
+		if (btusb_find_altsetting(data, 1)) {
 			set_bit(BTUSB_USE_ALT1_FOR_WBS, &data->flags);
-		else
+			hdev->sco_mtu = hci_packet_size_usb_alt[1];
+		} else
 			bt_dev_err(hdev, "Device does not support ALT setting 1");
 	}
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 33d8458fdd4adc..b3e9247fdbcfa1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -730,7 +730,12 @@ static void hci_cc_read_buffer_size(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 
 	hdev->acl_mtu  = __le16_to_cpu(rp->acl_mtu);
-	hdev->sco_mtu  = rp->sco_mtu;
+	/* Set sco_mtu only when not yet.
+	 * The sco_mtu would be set in btusb.c
+	 * if the host controller interface is USB.
+	 */
+	if (hdev->sco_mtu == 0)
+		hdev->sco_mtu  = rp->sco_mtu;
 	hdev->acl_pkts = __le16_to_cpu(rp->acl_max_pkt);
 	hdev->sco_pkts = __le16_to_cpu(rp->sco_max_pkt);
 
-- 
2.28.0.526.ge36021eeef-goog

