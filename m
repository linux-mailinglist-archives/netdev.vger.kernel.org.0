Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB12719DA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 06:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIUEXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 00:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgIUEXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 00:23:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94599C0613CE
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 21:23:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k3so11846906ybk.16
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 21:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=epV5Kf267asYL9EhY6AdeHNontynwjSLiF3gUn0z2B0=;
        b=NrHx8f/+pxqzILxbiJcQa7zh9LcPo1bS/hZTFXyHHyuFKJAfummZGCmO7UjcYW7Bto
         oHJLUrOYH1a7HSTXqwKXU9FC5QxUAmPvT3Qb/TmMQk6AZSF2VGXAqP2cM3Qq0kbCLiw0
         cOkhpOmk0BAYqZ4FMN7Vl2NS1Mc+KoLZuQxCU/RFmmN1E9NfghqIjT/0ryHWFkIILjXA
         eDCRz4+v/A2KJ7hRgz7b6JDh8Ayv3JkM2V4+ipR3XxXW+0wA5xEn0qxFohle890HJjof
         4kksU0m3A2OD5gtFthYOQKE9hNaK7FFDEchwk8CgprAXx7DkSV3vKICyyEWFYKVaV8Q9
         YZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=epV5Kf267asYL9EhY6AdeHNontynwjSLiF3gUn0z2B0=;
        b=andI8i72JDBk64byrptfsSDyVDPjdT1NbdAwK8RNIF/4guLg/q+bBp3vLbMOqAFXYo
         e4LcxjcGtels3ei/UX0CDR5l0g/7vugxUNtuh4NxIc5Psv9XVppfYQWxVfyMpDCiTHsk
         ZjWSZwUVoiDChzLKzYsHth1FZMRKFMO6ZJR39Zvl6AM1nHGxgMweaI35AWssy6dtm4/t
         BW/Qzl7j7rrNsJWrZZViuoDxILzrz4rNYUzqNzkpHFobVeEBu7KCikQiarMlBG9cq1Y6
         nLuKQALj2SMw5iCS6kZnxbDLrGpNqKVixxfRLkcKMCmqfHqoz0Zp72cy0cRBlGtwwGdw
         5OBw==
X-Gm-Message-State: AOAM533ewwyLTeIP6TbTgZTXU4SeVFrtqOpddAl5tUk2e07I3Rp3pq0v
        GHNGtaCfevXk1GY1As4qR79Il9JP7Is6BHA2IQ==
X-Google-Smtp-Source: ABdhPJyyCNP9bHpy8nwOUFwlrx6vXZ/QBNe3dSUwlLKUeoogRqulu5Xd8SJnXa/GaEVHDNG3YZwzCLtP4OeTaMsvBQ==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:e83:: with SMTP id
 125mr65805362ybo.376.1600662211746; Sun, 20 Sep 2020 21:23:31 -0700 (PDT)
Date:   Mon, 21 Sep 2020 12:23:08 +0800
In-Reply-To: <20200921122216.v4.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200921122216.v4.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20200921122216.v4.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v4 4/4] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.orgi,
        Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a configurable parameter to switch off the interleave
scan feature.

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---
Changes in v4:
- Set EnableAdvMonInterleaveScan default to Disable
- Fix 80 chars limit in mgmt_config.c

 include/net/bluetooth/hci_core.h | 1 +
 net/bluetooth/hci_core.c         | 1 +
 net/bluetooth/hci_request.c      | 3 ++-
 net/bluetooth/mgmt_config.c      | 5 +++++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 179350f869fdb..c3253f1cac0c2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -363,6 +363,7 @@ struct hci_dev {
 	__u32		clock;
 	__u16		advmon_allowlist_duration;
 	__u16		advmon_no_filter_duration;
+	__u16		enable_advmon_interleave_scan;
 
 	__u16		devid_source;
 	__u16		devid_vendor;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6c8850149265a..d5769ae682893 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3595,6 +3595,7 @@ struct hci_dev *hci_alloc_dev(void)
 	/* The default values will be chosen in the future */
 	hdev->advmon_allowlist_duration = 300;
 	hdev->advmon_no_filter_duration = 500;
+	hdev->enable_advmon_interleave_scan = 0x0000;	/* Default to disable */
 
 	hdev->sniff_max_interval = 800;
 	hdev->sniff_min_interval = 80;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 1fcf6736811e4..bb38e1dead68f 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -500,7 +500,8 @@ static void __hci_update_background_scan(struct hci_request *req)
 		if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
 			hci_req_add_le_scan_disable(req, false);
 
-		if (!update_adv_monitor_scan_state(hdev)) {
+		if (!hdev->enable_advmon_interleave_scan ||
+		    !update_adv_monitor_scan_state(hdev)) {
 			hci_req_add_le_passive_scan(req);
 			bt_dev_dbg(hdev, "%s starting background scanning",
 				   hdev->name);
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index 2d3ad288c78ac..34585ab4680b5 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -69,6 +69,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 						def_le_autoconnect_timeout),
 		HDEV_PARAM_U16(0x001d, advmon_allowlist_duration),
 		HDEV_PARAM_U16(0x001e, advmon_no_filter_duration),
+		HDEV_PARAM_U16(0x001f, enable_advmon_interleave_scan),
 	};
 	struct mgmt_rp_read_def_system_config *rp = (void *)params;
 
@@ -142,6 +143,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x001b:
 		case 0x001d:
 		case 0x001e:
+		case 0x001f:
 			if (len != sizeof(u16)) {
 				bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
 					    len, sizeof(u16), type);
@@ -261,6 +263,9 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x0001e:
 			hdev->advmon_no_filter_duration = TLV_GET_LE16(buffer);
 			break;
+		case 0x0001f:
+			hdev->enable_advmon_interleave_scan = TLV_GET_LE16(buffer);
+			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
-- 
2.28.0.681.g6f77f65b4e-goog

