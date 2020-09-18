Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E2726F430
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgIRDMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgIRDMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 23:12:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9198C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 20:12:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l67so4058540ybb.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 20:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=64ZOoFGaOH0m/cPAtUtUGXYMPXoup8s7otAhkDt2H3M=;
        b=UEW/Lh9lpl7cJQgrlAzxT3Ymbi9kik5IAj7EVI1GY2T6uE0YvsPwYWJedj5Yjddxb2
         Nf9za12XPUpgMNJbYMg3nxYfm7tIUa4E4ybFE5NmmN662fd1cbc8aIWNfJTGDeVCo9Wq
         1WJwF/8g5Ie4JkrEp9yIEza/HU17XBEhrMrcZRi+O9Jy9X/8DLPtjMbgX1ooTVXaYZ9G
         9BkQbDFFUO3xE+c8n671VgQ1E2yeVtyvKvMHC2aqjootukqzQUqvzZd7GwT9bLVII80l
         GbNwo30YIeEqvnUnUiLC8wEkHkGFP8RAbeLu0YLLKHJRU6RYHFMxIIgwCRY3z2vSxCxk
         iZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=64ZOoFGaOH0m/cPAtUtUGXYMPXoup8s7otAhkDt2H3M=;
        b=eUBV0FGEWuM+C/Z1WqxzSCyTZsBq7K6sOKa/KTp4SngHjlLjjiF3o60W+MPpbLpCKU
         eQIuYZeHIbrgK1olOit78vA7g5gMa0NWryNWO4Lb2NF8paGl430wNXguM5IXdkfLdQYA
         fGtseYWon5DDKy7h8wxNOx8QWHeZ6nWj1XpWtaSTaNuo6+oFma8ldiZDzcXSN1LXLOhU
         IqldWMISbJgUucnnk7Jdy9TukZppZpArm60M2R9baMWZPHopDURAawA0HWqfh0NIZvmf
         IIIfRIcMC+5wXXj2p3tpozCG/ZDG1DLC8eaArfl4imzf8S7RXvc/gY9CY9W3k9Wr0ckY
         dZBw==
X-Gm-Message-State: AOAM532umRFz1v52dExkDeWmQqfnfB72JWmGrJ78If1IHJyvHgX4aGhC
        3JHDvAUIRtFWgoWIJUgIaOQ4uX61ngDhYEq4Lw==
X-Google-Smtp-Source: ABdhPJxxoVj4sVwb3Pqb1zFKEUNanXR2/70HGloVVRNpSIBlL1Bw+Xd+ataxUCDEF5kqhDcJIjajKb/vuIQfOrUh9A==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:d408:: with SMTP id
 m8mr41594928ybf.204.1600398759153; Thu, 17 Sep 2020 20:12:39 -0700 (PDT)
Date:   Fri, 18 Sep 2020 11:11:53 +0800
In-Reply-To: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Message-Id: <20200918111110.v3.6.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 6/6] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     howardchung@google.com, luiz.dentz@gmail.com, marcel@holtmann.org,
        mcchou@chromium.org, mmandlik@chromium.org, alainm@chromium.org,
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

(no changes since v1)

 include/net/bluetooth/hci_core.h | 1 +
 net/bluetooth/hci_core.c         | 1 +
 net/bluetooth/hci_request.c      | 3 ++-
 net/bluetooth/mgmt_config.c      | 6 ++++++
 4 files changed, 10 insertions(+), 1 deletion(-)

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
index 6c8850149265a..4608715860cce 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3595,6 +3595,7 @@ struct hci_dev *hci_alloc_dev(void)
 	/* The default values will be chosen in the future */
 	hdev->advmon_allowlist_duration = 300;
 	hdev->advmon_no_filter_duration = 500;
+	hdev->enable_advmon_interleave_scan = 0x0001;	/* Default to enable */
 
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
index 1802f7023158c..b4198c33a1b72 100644
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
@@ -263,6 +265,10 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			hdev->advmon_no_filter_duration =
 							TLV_GET_LE16(buffer);
 			break;
+		case 0x0001f:
+			hdev->enable_advmon_interleave_scan =
+							TLV_GET_LE16(buffer);
+			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
-- 
2.28.0.681.g6f77f65b4e-goog

