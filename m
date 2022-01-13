Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA948DA74
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbiAMPJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 10:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiAMPJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 10:09:03 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C380BC06161C
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 07:09:02 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l25so10610091wrb.13
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 07:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ql4EI1XSM0uXLPj22057boBbVTjDFxU3Ac7+ONvGaos=;
        b=dZ6QLVEiARHm99AsYDxNAadMtIE1VYZMXP7J3LMhIFqlLD+3KzY1dhoyY69kpmhV0K
         +xOT1a3dRNn2WyEFtdPscD/GHNFkJ75cn2F9Szr8pTxXzavuwm2d6VMzqxZTtRnaReGW
         LKOw5WvAnZ6UxP25/qeBcxk1rRHNRqNHkxTp4aR4efYxbfGLhtVQDw5eXFdoryw87vr5
         3R4E45LcfbXPFnE+DCCekqJpDEPvZ4ns6UizOly2rylJpCTrUQyW3bHAIYmEKduukNNn
         +oy+7mzzezdgjBYewUU2DTVxD/xa4BtqRp56wTa8g1G3L/mA/PvevwAOA6Z2mC/Aenla
         N2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ql4EI1XSM0uXLPj22057boBbVTjDFxU3Ac7+ONvGaos=;
        b=ZGMbewQIZRddx/cI/MFok9AiZa5F1Yyu4dvN2HylSPdSeaoEdrBB/wqOhO2EiOSPoC
         7oIxhPs1vqgYNt91+xQ900W/RmDEQjt0tucEtZWpo4SOq7/kMtLSmMbd2kvicjqZGoBl
         X2Fxyu86b1BiMFUrXBTMXFLRaWNIwtElOqsVXT8rXkvkslHlTSMzvJ0USna8EX2ufLIz
         JH39YplFNM370egTWXHi0qnPbG7rxj2Bx7yJ+3a3XZ2SU4Wp2QDXY1B40y5hq5mWcTP+
         6dgZFdM60x04LzfgFN2d+heMkhg9zXaxg6nbIeQK7VAUoha8+YIiUVmj0Cp0GTNCPBwx
         K1cw==
X-Gm-Message-State: AOAM532Jtsyepys4rAxjMGxCt3F7fnrh/nhJtOuXUdN/3NL0BjkZMiKu
        j21WTWI8qlcx52kxZwHErZSXrA==
X-Google-Smtp-Source: ABdhPJw3cDg0UjpHYSc2HIZ9VUjivIidWpuZYLj29b56lStR6I+gO3NMVqx/7T+1Agvu97DhFz78sA==
X-Received: by 2002:a5d:6884:: with SMTP id h4mr4417294wru.640.1642086541238;
        Thu, 13 Jan 2022 07:09:01 -0800 (PST)
Received: from biernacki.c.googlers.com.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id w12sm3269620wrm.36.2022.01.13.07.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 07:09:00 -0800 (PST)
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
Subject: [PATCH] Bluetooth: Fix skb allocation in mgmt_remote_name()
Date:   Thu, 13 Jan 2022 15:08:46 +0000
Message-Id: <20220113150846.1570738-1-rad@semihalf.ocm>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
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
Signed-off-by: Angela Czubak <acz@semihalf.com>
Signed-off-by: Marek Maslanka <mm@semihalf.com>
Signed-off-by: Radoslaw Biernacki <rad@semihalf.com>
---
 net/bluetooth/eir.h  |  5 +++++
 net/bluetooth/mgmt.c | 12 ++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

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
index 37087cf7dc5a..d517fd847730 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9680,13 +9680,11 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
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
@@ -9696,10 +9694,8 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
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
2.34.1.703.g22d0c6ccf7-goog

