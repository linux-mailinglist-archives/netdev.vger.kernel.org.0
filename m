Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8D627545E
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgIWJW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgIWJWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:22:49 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130D3C0613D1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:22:49 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id c3so3714399pgj.5
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=u7Z83DLDrasY402Nxfc9qjNLJvZzmNwdhFfCA3B0FJM=;
        b=QSLk/unrtSuMTNkb4x94DkM1UH5ttzeHlXRiV3zLnLMp0xuP9FNwce/+58fN+WhPHZ
         vy0OdIcIbOa3b1s4ji9mfMm1oXHfZOFtu8WJjbhPYwScPv6zVGiv0gDTrwU01iNkDzKd
         3uzEN2hB9x+OYMJOolUs20QkRqOpqZTXBYiaMEVNxMu95FG8qkxQBO9a/gkCtp5YL7/S
         aUsRMwxqW/lyQU+rF/LC2vTzXDbuiDUy3uDKvdBof2KZqY2SiFsGUalNYeEDegURlbMM
         +xTXWwdi7cOX0dqk9ILPaM4s/XlojQeJuUvuU4zciteOa31sXKlTJAqls2f2Vw4qRjUh
         cbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u7Z83DLDrasY402Nxfc9qjNLJvZzmNwdhFfCA3B0FJM=;
        b=LShKuu27Lv1QWR2Y0Zs+OVSOHjgT1XbQkBCtma4mVzvWdDToyyNm2twk1e3lsk7hR+
         FVZAG3ChpYi8DA+PLLl/pCaOaCdDD8Go/EXzHqUH06kddoad9foaWmu2GxgjAAu7FOHB
         WeiRUVrtNoyFXsb8z0EGWmx4ITgpqpUjNDMQZgr25XU4xlRp6K+fj08d0NBSyVFv1rko
         QsTk9DEb9jp5BTCBrwvqUogWxgfg7GhsQj/HGVGVNrCMcqMupes1Emu0OIX2r8iE08nq
         eEV4FtFncjrSPyosbc9cVSBNjj2zhrUQekTRgU/WMmL4wgRElRyiQAgi/Bq1j2cZOHRM
         jjew==
X-Gm-Message-State: AOAM531RaEYwI8bDwev7FTGlgDWxbjEV5fHjAT8tV9xb1pXZkMalAt8K
        5sPUOAZ2gbKwu0Ya0ZT+mzy9C/UPfQatfJ/czQ==
X-Google-Smtp-Source: ABdhPJy/dWhO3vnXwvNo0D+dQKNFhW0lwByxTvX6ctgRDLo0I+9tg61Cop7KCcLEcHJGCu+H4H3bkWftl7yG9DLGwg==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a17:902:bd90:b029:d2:439c:385a with
 SMTP id q16-20020a170902bd90b02900d2439c385amr5997037pls.35.1600852968539;
 Wed, 23 Sep 2020 02:22:48 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:22:32 +0800
In-Reply-To: <20200923172129.v5.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200923172129.v5.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20200923172129.v5.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v5 4/4] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.orgi, mcchou@chromium.org, alainm@chromium.org,
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

(no changes since v4)

Changes in v4:
- Set EnableAdvMonInterleaveScan default to Disable
- Fix 80 chars limit in mgmt_config.c

 include/net/bluetooth/hci_core.h | 1 +
 net/bluetooth/hci_core.c         | 1 +
 net/bluetooth/hci_request.c      | 3 ++-
 net/bluetooth/mgmt_config.c      | 5 +++++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index cfede18709d8f..b0225b80152cc 100644
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
index 4048c82d4257f..23381f263678b 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1057,7 +1057,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 				      &own_addr_type))
 		return;
 
-	if (__hci_update_interleaved_scan(hdev))
+	if (hdev->enable_advmon_interleave_scan &&
+	    __hci_update_interleaved_scan(hdev))
 		return;
 
 	/* Adding or removing entries from the white list must
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

