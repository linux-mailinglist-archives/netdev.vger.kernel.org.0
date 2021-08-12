Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933F33E9D46
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 06:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhHLEXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 00:23:41 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:54056
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233659AbhHLEXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 00:23:39 -0400
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 11D883F078
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 04:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628742189;
        bh=+L442i3SxtCcWzJaUttW6ED4hZuYNad+jI36fQtKVDY=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=j6/qJiIPE2mUv/U1CK6fX8j71JttKgDDK2vP5ihW7dzzf9SF/iE3azn0UdYOpvX0g
         HB6tBu4bGsVgg1g4u5ffsoa47hIZiV7Pa/MDVZofYKzjnZsrLapfrPXSbyMs2qU8ba
         nKV0r0DtXOLgOumQDLqz10fG/+pVb5e3aNh+Rpt9LfhWY5icSk8l1jkGbfRsL+xLRC
         uzdRGkW3ctN1In3EpJaiq3/b/gsAWdQz6CyJRxtQnOuJebmfTBl7LBfTmbeBI2QOZZ
         NQznDUs7Gw/vVEqCfzK5/8qd8jo5cNI5UsYUWik0lRJpilC7FZyh+rAw3tZtuAw9TL
         U+mNLE7ZNn1aA==
Received: by mail-pj1-f69.google.com with SMTP id d35-20020a17090a6f26b0290178ab46154dso3311662pjk.3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 21:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+L442i3SxtCcWzJaUttW6ED4hZuYNad+jI36fQtKVDY=;
        b=Qk2cvRlvsbbp//yNToPrFE4YMd/uc1LcnH1/C2pR0Dclz4ZJ7xnx25fipVOR1jGMRs
         fp9CkRYA43q6ijN3vzI/5JpSsvviwdmZUM2xf1A3G16JM8fZpkYJG+mCynp8AFU9HFFk
         kxyc/vIvAnt7sjsezJ1roaJCwM+z9RYqUxoO6/QPj1+sIrgiVDuVjpmKP0B4ptDKTeK1
         LpdtxndVUEzi32af9k1Hgr5x+dVENcM5+WlPDwDuW7n8afjjRUQOVKVnazQOrVVXiUid
         x5cLevXRjqvZ69TZQjwZYyHEH1qnUFaXmnuhRZPJ+ywfzGh7T6YHjNKy/vpoDRBlBSYr
         CjEA==
X-Gm-Message-State: AOAM531nKAXH1QagdcM2fe8D+5idIbANHNKvkUdR8UGukfmihiouIts0
        q2OOwNR1Gy2K2EVrERiUYRM4tm8EX6K9A/ecArDbBUq7PLldjiiwewDJupVWQ/czcknxRSxORzZ
        2dvCKPyWh2bXXT2LgFkj7TuW7cU03cdlnlw==
X-Received: by 2002:a17:90a:d702:: with SMTP id y2mr2320614pju.127.1628742187455;
        Wed, 11 Aug 2021 21:23:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXjpzEwVLP/zQsF6dW6uJ5sYNGe1SPeFYLPOiehRNPqCxY0kzQvYXusthspuWxSYsiqLixyA==
X-Received: by 2002:a17:90a:d702:: with SMTP id y2mr2320591pju.127.1628742187163;
        Wed, 11 Aug 2021 21:23:07 -0700 (PDT)
Received: from canonical.com (61-220-137-34.HINET-IP.hinet.net. [61.220.137.34])
        by smtp.gmail.com with ESMTPSA id dw15sm1092861pjb.42.2021.08.11.21.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 21:23:06 -0700 (PDT)
From:   Koba Ko <koba.ko@canonical.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, apusaka@google.com
Subject: [PATCH] Bluetooth: msft: add a bluetooth parameter, msft_enable
Date:   Thu, 12 Aug 2021 12:23:05 +0800
Message-Id: <20210812042305.277642-1-koba.ko@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With Intel AC9560, follow this scenario and can't turn on bt since.
1. turn off BT
2. then suspend&resume multiple times
3. turn on BT

Get this error message after turn on bt.
[ 877.194032] Bluetooth: hci0: urb 0000000061b9a002 failed to resubmit (113)
[ 886.941327] Bluetooth: hci0: Failed to read MSFT supported features (-110)

Remove msft from compilation would be helpful.
Turn off msft would be also helpful.

Because msft is enabled as default and can't turn off without
compliation,
Introduce a bluetooth parameter, msft_enable, to control.

Signed-off-by: Koba Ko <koba.ko@canonical.com>
---
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 16 ++++++++++++++++
 net/bluetooth/msft.c             | 30 +++++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index a7d06d7da602..002753db936a 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1229,6 +1229,7 @@ static inline void *hci_get_priv(struct hci_dev *hdev)
 	return (char *)hdev + sizeof(*hdev);
 }
 
+void hci_set_msft(bool enable);
 struct hci_dev *hci_dev_get(int index);
 struct hci_dev *hci_get_route(bdaddr_t *dst, bdaddr_t *src, u8 src_type);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index cb2e9e513907..9e1bdaea20a8 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1045,6 +1045,22 @@ static int hci_linkpol_req(struct hci_request *req, unsigned long opt)
 	return 0;
 }
 
+void hci_set_msft(bool enable)
+{
+	struct hci_dev *hdev = NULL, *d;
+
+	read_lock(&hci_dev_list_lock);
+	list_for_each_entry(d, &hci_dev_list, list) {
+		hdev = hci_dev_hold(d);
+		if (enable)
+			msft_do_open(hdev);
+		else
+			msft_do_close(hdev);
+		hci_dev_put(hdev);
+	}
+	read_unlock(&hci_dev_list_lock);
+}
+
 /* Get HCI device by index.
  * Device is held on return. */
 struct hci_dev *hci_dev_get(int index)
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index b4bfae41e8a5..0bb50ee11bf8 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -97,6 +97,34 @@ struct msft_data {
 	__u8 filter_enabled;
 };
 
+static bool msft_enable = true;
+
+static int msft_set_enable(const char *s, const struct kernel_param *kp)
+{
+	bool do_enable;
+	int ret;
+
+	if (!s)
+		return 0;
+
+	ret = strtobool(s, &do_enable);
+	if (ret || msft_enable == do_enable)
+		return ret;
+
+	hci_set_msft(do_enable);
+
+	msft_enable = do_enable;
+
+	return ret;
+}
+
+static const struct kernel_param_ops msft_enable_ops = {
+	.set = msft_set_enable,
+	.get = param_get_bool,
+};
+
+module_param_cb(msft_enable, &msft_enable_ops, &msft_enable, 0644);
+
 static int __msft_add_monitor_pattern(struct hci_dev *hdev,
 				      struct adv_monitor *monitor);
 
@@ -186,7 +214,7 @@ void msft_do_open(struct hci_dev *hdev)
 {
 	struct msft_data *msft;
 
-	if (hdev->msft_opcode == HCI_OP_NOP)
+	if (!msft_enable || hdev->msft_opcode == HCI_OP_NOP)
 		return;
 
 	bt_dev_dbg(hdev, "Initialize MSFT extension");
-- 
2.25.1

