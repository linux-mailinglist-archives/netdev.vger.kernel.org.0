Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC5126CAE0
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgIPURk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728328AbgIPUQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:16:46 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9CC061221
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:23 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id r22so7135330qtc.9
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=mV/LFuTshHzotksH3grmXFg7Xs0h6PleCimRLiw3IeY=;
        b=EQRl+RIO/iMmVWfKcZ8ED17Om52TeR9DzT0HzQt62GI8XYzbTx4iSE/e53TWLeRrC4
         SinrfVtyjrg8237Bs3Z5Y6SWftmvQrUM2sPw4RnMoJ5vk10M2ZWGgSsoXIBGfqPA3DZW
         dRiCE4KtBUMZZNXBlXikUyz/9lx9HSLDr/p1IjtZnwFCNbEYGhOtEnek7cUlCDGJ81RW
         byBJJkGtNWPwky/MpFaZ8fHoDZpF4odneqa6wytQFAdaoV5xhvHMH8Nm5kYI/J+BiSyH
         BThka3ZSKn46911pMjZGg8Q+1xXtdHCnJDIMl/URjQcO3oXG6Fpo6hfqmf9FQwAApsZL
         mGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mV/LFuTshHzotksH3grmXFg7Xs0h6PleCimRLiw3IeY=;
        b=V/3aAsR/nRBA1P0gRol2bVS6AJTt2PY1y7RRylgrzeFKKZa+9gLFb9zezqV1YsZ/Yz
         Cq146OesljvB+2N1no+kiboizxOPsH3zCVpMNUIOrMIsBp9GvVAD90XsIrXMXVDJkHTI
         UkKl/rIyw+cuZbBsUHAT4vavD9cQWsVzD5i7Uoq7BhapRIMdUmXw8obSeLz4Mx94aoFa
         oPrnh8yVLsqzIctKSWECUkDqk8nFpayANTd6+UAPb7yxO6kpI4kgVZFnoaT+uQOJkLoK
         UrWSKM3dODKCMTZzFzjX88VfmcQeUKyR+9i0O856OMVx4A2xXr5fiGf8z/V7CHDzBtwy
         g6AA==
X-Gm-Message-State: AOAM531FTrPE2GWZsoUZO2+Z5e+6gp3K2eUuW2j4eCYQCQ7u6gArhgNE
        bDLsBgOtTtoWUuhmKueNzlrY1igia16qBmjZwA5W
X-Google-Smtp-Source: ABdhPJx9rr/wInvexTzLGszPhP52de+s7E+VegnMknnOC50bFToSeEmk3oEZlbiKA9jVdE7FHbXQXJRUfSF8TKP5DSid
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a0c:c244:: with SMTP id
 w4mr25344793qvh.12.1600287382444; Wed, 16 Sep 2020 13:16:22 -0700 (PDT)
Date:   Wed, 16 Sep 2020 13:16:02 -0700
In-Reply-To: <20200916201602.1223002-1-danielwinkler@google.com>
Message-Id: <20200916131430.6.I5068c01cae3cea674a96e103a0cf4d8c81425a4f@changeid>
Mime-Version: 1.0
References: <20200916201602.1223002-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH 6/6] Bluetooth: Add MGMT command for controller capabilities
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For advertising, we wish to know the LE tx power capabilities of the
controller in userspace, so this patch adds a new MGMT command to query
controller capabilities. The data returned is in TLV format, so it can
be easily used to convey any data determined to be useful in the future,
but for now it simply contains LE min and max tx power.

The change was tested by manually verifying that the new MGMT command
returns the tx power range as expected in userspace.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

 include/net/bluetooth/mgmt.h |  9 +++++++++
 net/bluetooth/mgmt.c         | 39 ++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index db64cf4747554c..9aa792e5efc8d0 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -815,6 +815,15 @@ struct mgmt_rp_add_ext_adv_data {
 	__u8	instance;
 } __packed;
 
+#define MGMT_CAP_LE_TX_PWR_MIN	0x0000
+#define MGMT_CAP_LE_TX_PWR_MAX	0x0001
+
+#define MGMT_OP_READ_CONTROLLER_CAP	0x0056
+#define MGMT_OP_READ_CONTROLLER_CAP_SIZE	0
+struct mgmt_rp_read_controller_cap {
+	__u8     capabilities[0];
+} __packed;
+
 #define MGMT_EV_CMD_COMPLETE		0x0001
 struct mgmt_ev_cmd_complete {
 	__le16	opcode;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b9347ff1a1e961..d2e5bc4b3ddb8f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -124,6 +124,7 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_REMOVE_ADV_MONITOR,
 	MGMT_OP_ADD_EXT_ADV_PARAMS,
 	MGMT_OP_ADD_EXT_ADV_DATA,
+	MGMT_OP_READ_CONTROLLER_CAP,
 };
 
 static const u16 mgmt_events[] = {
@@ -181,6 +182,7 @@ static const u16 mgmt_untrusted_commands[] = {
 	MGMT_OP_READ_EXP_FEATURES_INFO,
 	MGMT_OP_READ_DEF_SYSTEM_CONFIG,
 	MGMT_OP_READ_DEF_RUNTIME_CONFIG,
+	MGMT_OP_READ_CONTROLLER_CAP,
 };
 
 static const u16 mgmt_untrusted_events[] = {
@@ -4356,6 +4358,42 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
+static int read_controller_cap(struct sock *sk, struct hci_dev *hdev,
+			       void *data, u16 len)
+{
+	u8 i = 0;
+
+	/* This command will return its data in TVL format. Currently we only
+	 * wish to include LE tx power parameters, so this struct can be given
+	 * a fixed size as data types are not changing.
+	 */
+	struct {
+		struct mgmt_tlv entry;
+		__s8 value;
+	} __packed cap[2];
+
+	BT_DBG("request for %s", hdev->name);
+	memset(cap, 0, sizeof(cap));
+
+	hci_dev_lock(hdev);
+
+	/* Append LE tx power bounds */
+	cap[i].entry.type = MGMT_CAP_LE_TX_PWR_MIN;
+	cap[i].entry.length = sizeof(__s8);
+	cap[i].value = hdev->min_le_tx_power;
+	i++;
+
+	cap[i].entry.type = MGMT_CAP_LE_TX_PWR_MAX;
+	cap[i].entry.length = sizeof(__s8);
+	cap[i].value = hdev->max_le_tx_power;
+	i++;
+
+	hci_dev_unlock(hdev);
+
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_READ_CONTROLLER_CAP,
+				 MGMT_STATUS_SUCCESS, cap, sizeof(cap));
+}
+
 static void read_local_oob_data_complete(struct hci_dev *hdev, u8 status,
 				         u16 opcode, struct sk_buff *skb)
 {
@@ -8208,6 +8246,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 						HCI_MGMT_VAR_LEN },
 	{ add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
 						HCI_MGMT_VAR_LEN },
+	{ read_controller_cap,     MGMT_OP_READ_CONTROLLER_CAP_SIZE },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.28.0.618.gf4bc123cb7-goog

