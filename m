Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0869F263CED
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgIJGEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgIJGEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:04:15 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D03C061756
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:04:14 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u9so388073plk.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vZWQw2MqezQSjPCg0Dku6/BdcAwBC3dDRSyH4V8pXAg=;
        b=SQZNXcqU0ZuZn0AJkjqfkWCEklXGWMXhKkzRoLq85tYAhNvLeQZSzS+KpCuZ4KpW72
         wwTVKXiK5Htjys+hkHZ4/YNhZ+CMji2am9sulpMpqCVjWq14byniLkA0VLeLPIRZJUKi
         4m85yH8ncqbDTCRcwW9Wx+9C7mtjIdGEjrx54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vZWQw2MqezQSjPCg0Dku6/BdcAwBC3dDRSyH4V8pXAg=;
        b=XiwJre+XQQBVBkt3RcxwK12NTpEfGgTadjq/EJLPulim0jhYwAbkQJFxXyYKioXByR
         cxWaw/lgO9xb9LarUDlG3w2yU8qpxHCYE5ysxV1XtQ+J5okvnT6rrKugZNz6nbZtLwsd
         DCpvArUtUAnwgzm7VqyGa6q6diP7uohs+eAn0S6Zr8KK5e7PkT5o8adNYE1NLjB0XDE4
         kzdtspgZ0KzcwcfDE2AmR22NlOQl2iury+GNMnt0CwP2FZKPsiA+ZXvKHYRr4nfKuTjw
         HcChZl/YNTuJCllK0DuNgItX6mi8ctCppTJysHwE13lMd/KCtLgtHQH6ddeyd+D9Wd+T
         NUgQ==
X-Gm-Message-State: AOAM533O9iVWWG0jvdH3RYso8JL6bX9BzGFhzt/zkDZanrF2RROswI6g
        q6rmFWMmEZ78Di7kCTfYcVUaug==
X-Google-Smtp-Source: ABdhPJyxgMEM0piakxuNRBDbU1TVf/izPnfSQ3fQIf5qgxZExhxTcQhq8L6R1tcELWl8gyxoUEj3Dg==
X-Received: by 2002:a17:90b:3105:: with SMTP id gc5mr3924629pjb.225.1599717854210;
        Wed, 09 Sep 2020 23:04:14 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:de4a:3eff:fe7d:ff5f])
        by smtp.gmail.com with ESMTPSA id j14sm893236pjz.21.2020.09.09.23.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:04:13 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 1/2] Bluetooth: btusb: define HCI packet sizes of USB Alts
Date:   Thu, 10 Sep 2020 14:04:01 +0800
Message-Id: <20200910140342.v3.1.I56de28ec171134cb9f97062e2c304a72822ca38b@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200910060403.144524-1-josephsih@chromium.org>
References: <20200910060403.144524-1-josephsih@chromium.org>
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

Changes in v3:
- Set hdev->sco_mtu to rp->sco_mtu if the latter is smaller.

Changes in v2:
- Used sco_mtu instead of a new sco_pkt_len member in hdev.
- Do not overwrite hdev->sco_mtu in hci_cc_read_buffer_size
  if it has been set in the USB interface.

 drivers/bluetooth/btusb.c | 45 +++++++++++++++++++++++++++++----------
 net/bluetooth/hci_event.c | 14 +++++++++++-
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fe80588c7bd3a8..651d5731a6c6cf 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -459,6 +459,24 @@ static const struct dmi_system_id btusb_needs_reset_resume_table[] = {
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
+ *   where suggested_max_packet_size is {9, 17, 25, 33, 49, 63}
+ *   for alt settings 1 - 6.
+ */
+static const int hci_packet_size_usb_alt[] = { 0, 24, 48, 72, 96, 144, 60 };
+
 struct btusb_data {
 	struct hci_dev       *hdev;
 	struct usb_device    *udev;
@@ -3959,6 +3977,15 @@ static int btusb_probe(struct usb_interface *intf,
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
@@ -4022,6 +4049,10 @@ static int btusb_probe(struct usb_interface *intf,
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
@@ -4063,15 +4094,6 @@ static int btusb_probe(struct usb_interface *intf,
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
@@ -4083,9 +4105,10 @@ static int btusb_probe(struct usb_interface *intf,
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
index 33d8458fdd4adc..1869dc7ebbb5ac 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -730,7 +730,19 @@ static void hci_cc_read_buffer_size(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 
 	hdev->acl_mtu  = __le16_to_cpu(rp->acl_mtu);
-	hdev->sco_mtu  = rp->sco_mtu;
+	/* If the host controller interface is USB, the hdev->sco_mtu is
+	 * set in btusb.c and is not expected to be larger than the max sco
+	 * buffer size returned from the controller in rp->sco_mtu.
+	 */
+	if (hdev->sco_mtu > 0) {
+		if (rp->sco_mtu < hdev->sco_mtu) {
+			BT_ERR("sco mtu %d changed to max sco buffer size %d",
+			       hdev->sco_mtu, rp->sco_mtu);
+			hdev->sco_mtu = rp->sco_mtu;
+		}
+	} else {
+		hdev->sco_mtu  = rp->sco_mtu;
+	}
 	hdev->acl_pkts = __le16_to_cpu(rp->acl_max_pkt);
 	hdev->sco_pkts = __le16_to_cpu(rp->sco_max_pkt);
 
-- 
2.28.0.618.gf4bc123cb7-goog

