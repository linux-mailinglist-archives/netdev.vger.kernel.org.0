Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE71E277D08
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgIYAk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgIYAkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:40:24 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36AFC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:40:23 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id l5so652695qtu.20
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Z8efH0VT0gu9mhE3Qe4fVs6J3IFKx4DbBtzU2cWSOyc=;
        b=RRNSN2v/SyaYP2fZsZh2mG7mDOWv4UWpwlF4ah5Ah7pxNRp4gjq5SRIjmzOqEvtuNg
         o2sZIvQXtBPsbhmZxlSWBHeRJtBCSS/DQpLgpUmZKrrP9dyXTU0506LL192MiSvzY4l2
         P55P5nHR+wxjI1Gs0ydUIf0fyYUrBmK8XHfyFu/oVSqqsdXZLjYLyGdtBus6B1Plui3C
         CSJdObmJswm4v5Y8kYvKlCq08vWHXbwA4lohzsyPJ5WcMX8mnTYWlvKJlxpb0vkoSfEY
         6ovwP5H3ioE2gnIgIBVtS4T5+9afRYesMgJ5C5MXE8gLn+NyaeMfENu8SJHiHwrYMxdj
         4idQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Z8efH0VT0gu9mhE3Qe4fVs6J3IFKx4DbBtzU2cWSOyc=;
        b=sVs+ry3ehMKuDX1wOPrp00c/pLZfLVOKSKEjWBrL4VV5vWEZUOW1vPouVMhsBSiJTR
         jAkgUhglYMVrCKBHfP/l0TnDunyctJY1Sh3Xe8RSJC4D945JV3De2fgdn7VZhKOkB6TO
         44j5iHKwKalQKoEXbmcfbrM7uSKIz8iHCq/pD9NtWouJK/dmqW0oMirnsxcNw0H2AaGu
         aQPDsMc/d9jcAzx3C43fj0aC+SBPd/9wZ3v0k7vr2nD95BlOxSL9XiV348FKsDO4cVjJ
         CXeRlAqxZ0jBuwK5WAlClgClQU5Uu9HKdOgJQs4/RHilynjld5xMZMGQMghPmMtK1BMP
         jHKg==
X-Gm-Message-State: AOAM532SHvPZcD0KAU0YVIeDjPv5SlVNHSm9eZwUm0OU6CaBBTUn/mG2
        dXr9RZncF35+roeYBQ5+MrEopxA6MRGMdteI2GT+
X-Google-Smtp-Source: ABdhPJyV/rAxfDsY0L/wJmbvjNXMni1QAb7QYZR3zx5lVh17Q9z49dofhpNr8cuz5voKcmUTwrMX5BPRRI2y94zqSYmw
Sender: "danielwinkler via sendgmr" 
        <danielwinkler@danielwinkler-linux.mtv.corp.google.com>
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:ad4:4f30:: with SMTP id
 fc16mr1922865qvb.6.1600994422858; Thu, 24 Sep 2020 17:40:22 -0700 (PDT)
Date:   Thu, 24 Sep 2020 17:40:03 -0700
In-Reply-To: <20200925004007.2378410-1-danielwinkler@google.com>
Message-Id: <20200924173752.v3.1.I5f4fa6a76fe81f977f78f06b7e68ff1c76c6bddf@changeid>
Mime-Version: 1.0
References: <20200925004007.2378410-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v3 1/5] Bluetooth: Add helper to set adv data
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Daniel Winkler <danielwinkler@google.com>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We wish to handle advertising data separately from advertising
parameters in our new MGMT requests. This change adds a helper that
allows the advertising data and scan response to be updated for an
existing advertising instance.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

Changes in v3: None
Changes in v2: None

 include/net/bluetooth/hci_core.h |  3 +++
 net/bluetooth/hci_core.c         | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9873e1c8cd163b..300b3572d479e1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1291,6 +1291,9 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 			 u16 adv_data_len, u8 *adv_data,
 			 u16 scan_rsp_len, u8 *scan_rsp_data,
 			 u16 timeout, u16 duration);
+int hci_set_adv_instance_data(struct hci_dev *hdev, u8 instance,
+			 u16 adv_data_len, u8 *adv_data,
+			 u16 scan_rsp_len, u8 *scan_rsp_data);
 int hci_remove_adv_instance(struct hci_dev *hdev, u8 instance);
 void hci_adv_instances_set_rpa_expired(struct hci_dev *hdev, bool rpa_expired);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8a2645a8330137..3f73f147826409 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3005,6 +3005,37 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 	return 0;
 }
 
+/* This function requires the caller holds hdev->lock */
+int hci_set_adv_instance_data(struct hci_dev *hdev, u8 instance,
+			      u16 adv_data_len, u8 *adv_data,
+			      u16 scan_rsp_len, u8 *scan_rsp_data)
+{
+	struct adv_info *adv_instance;
+
+	adv_instance = hci_find_adv_instance(hdev, instance);
+
+	/* If advertisement doesn't exist, we can't modify its data */
+	if (!adv_instance)
+		return -ENOENT;
+
+	if (adv_data_len) {
+		memset(adv_instance->adv_data, 0,
+		       sizeof(adv_instance->adv_data));
+		memcpy(adv_instance->adv_data, adv_data, adv_data_len);
+		adv_instance->adv_data_len = adv_data_len;
+	}
+
+	if (scan_rsp_len) {
+		memset(adv_instance->scan_rsp_data, 0,
+		       sizeof(adv_instance->scan_rsp_data));
+		memcpy(adv_instance->scan_rsp_data,
+		       scan_rsp_data, scan_rsp_len);
+		adv_instance->scan_rsp_len = scan_rsp_len;
+	}
+
+	return 0;
+}
+
 /* This function requires the caller holds hdev->lock */
 void hci_adv_monitors_clear(struct hci_dev *hdev)
 {
-- 
2.28.0.709.gb0816b6eb0-goog

