Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009E64A6550
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbiBAUEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbiBAUEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:04:00 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2F1C061744
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:03:59 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a13so34173460wrh.9
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/QTYMxwWed/jQIivtJaGb3o5ZDyC8gqB+NImkJjoA+M=;
        b=R2s/WYxqrkrLqzzep4rDEqMSd1N/6u42Y0fF6kR/9+RQCyhZVXbJaJN/ugywk8HMnn
         NcoM405UM/+ErO67Cclrqd2Lx1QAebg5/WSP+C1S2RslP3RTYbCghiAXZECfuOMxriu6
         JwaIOtSQSL+JtYd/FG4MRGbDtX+f0lU7jtRjk679xtxiWKG3zrFAdXLyKjIvvJxnlG/s
         RxKL6S1HJwJrhIXCghSnn8DciIt22mQXtBX1X8YEztUhR6v93wntQ/2RYqo9xBDqWVqR
         U3WV+cb/YXe8g0kF2u1s9e2T++GBKgpdo05cVeDztvC1YmEnsYEGUVFztViQ143Nj+mk
         dUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/QTYMxwWed/jQIivtJaGb3o5ZDyC8gqB+NImkJjoA+M=;
        b=Clitf02OVZSOxT72cLpTNydzLZ3IxxgKn6xOXypRQoQCI5l86cfNxyIpRY4GqykVpK
         vgJTLDKwH6oSv/fLYBddeMZ9Ji069SYDxJGWln35zuj1Hphnx1HxH1P9SEmXdXuGd/9e
         JAfG8fKjpHbNwig1m28lJOld3YQJc7SQL9fBgKZ19RqGX6VV0jhu0+y4T4NPxkpkXheX
         Bzj0A9Y0blqJQkSlOI9XRblZFCPIhSY0VPsXLOC+tZoxdzIz90/QzvE7t4WKrntPMNPi
         Dly3DoYKqOCH0vSlt7tAWAfBRyWMFF6wOWj70CHSHow1Aod36umyBDZ3e++Aqn/2YXyx
         L0nA==
X-Gm-Message-State: AOAM531GiLtQKlPeU351O9rr07fl4gHKbP0xnAEOmujzv2xmGWLSuZ7O
        BEgxqE1TsCiNZl7FT+oDX6Ij9w==
X-Google-Smtp-Source: ABdhPJzT3HKHqtPMW9cTL9T3Oucv9FsNyNAOAgRt+aPsXnc9SKS9op/aFyZ8pV1AsXBrsH+bLvd1KQ==
X-Received: by 2002:a5d:500c:: with SMTP id e12mr23426786wrt.187.1643745838279;
        Tue, 01 Feb 2022 12:03:58 -0800 (PST)
Received: from biernacki.c.googlers.com.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id m6sm3367280wmq.6.2022.02.01.12.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 12:03:57 -0800 (PST)
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
        Marek Maslanka <mm@semihalf.com>,
        Radoslaw Biernacki <rad@semihalf.ocm>
Subject: [PATCH v2 2/2] Bluetooth: Improve skb handling in mgmt_device_connected()
Date:   Tue,  1 Feb 2022 20:03:53 +0000
Message-Id: <20220201200353.1331443-3-rad@semihalf.ocm>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220201200353.1331443-1-rad@semihalf.ocm>
References: <20220201200353.1331443-1-rad@semihalf.ocm>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduce eir_skb_put_data() that can be used to simplify
operations on eir in goal of eliminating the necessity of intermediary
buffers.
eir_skb_put_data() is in pair to what eir_append_data() does with help of
eir_len, but without awkwardness when passing return value to skb_put() (as
it returns updated offset not size).

Signed-off-by: Radoslaw Biernacki <rad@semihalf.com>
---
 net/bluetooth/eir.h  | 15 +++++++++++++++
 net/bluetooth/mgmt.c | 25 ++++++++-----------------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/net/bluetooth/eir.h b/net/bluetooth/eir.h
index e5876751f07e..43f1945bffc5 100644
--- a/net/bluetooth/eir.h
+++ b/net/bluetooth/eir.h
@@ -41,6 +41,21 @@ static inline u16 eir_append_le16(u8 *eir, u16 eir_len, u8 type, u16 data)
 	return eir_len;
 }
 
+static inline u16 eir_skb_put_data(struct sk_buff *skb, u8 type, u8 *data, u8 data_len)
+{
+	u8 *eir;
+	u16 eir_len;
+
+	eir_len	= eir_precalc_len(data_len);
+	eir = skb_put(skb, eir_len);
+	WARN_ON(sizeof(type) + data_len > U8_MAX);
+	eir[0] = sizeof(type) + data_len;
+	eir[1] = type;
+	memcpy(&eir[2], data, data_len);
+
+	return eir_len;
+}
+
 static inline void *eir_get_data(u8 *eir, size_t eir_len, u8 type,
 				 size_t *data_len)
 {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 43ca228104ce..4a24159f7dd6 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9087,18 +9087,12 @@ void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
 		skb_put_data(skb, conn->le_adv_data, conn->le_adv_data_len);
 		eir_len = conn->le_adv_data_len;
 	} else {
-		if (name_len > 0) {
-			eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE,
-						  name, name_len);
-			skb_put(skb, eir_len);
-		}
+		if (name)
+			eir_len += eir_skb_put_data(skb, EIR_NAME_COMPLETE, name, name_len);
 
-		if (memcmp(conn->dev_class, "\0\0\0", 3) != 0) {
-			eir_len = eir_append_data(ev->eir, eir_len,
-						  EIR_CLASS_OF_DEV,
-						  conn->dev_class, 3);
-			skb_put(skb, 5);
-		}
+		if (memcmp(conn->dev_class, "\0\0\0", sizeof(conn->dev_class)))
+			eir_len += eir_skb_put_data(skb, EIR_CLASS_OF_DEV,
+						    conn->dev_class, sizeof(conn->dev_class));
 	}
 
 	ev->eir_len = cpu_to_le16(eir_len);
@@ -9798,13 +9792,10 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	ev->addr.type = link_to_bdaddr(link_type, addr_type);
 	ev->rssi = rssi;
 
-	if (name) {
-		eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
-					  name_len);
-		skb_put(skb, eir_len);
-	} else {
+	if (name)
+		eir_len += eir_skb_put_data(skb, EIR_NAME_COMPLETE, name, name_len);
+	else
 		flags = MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
-	}
 
 	ev->eir_len = cpu_to_le16(eir_len);
 	ev->flags = cpu_to_le32(flags);
-- 
2.35.0.rc2.247.g8bbb082509-goog

