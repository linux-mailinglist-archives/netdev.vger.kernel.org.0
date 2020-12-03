Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9C42CDF8B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbgLCUOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731250AbgLCUOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:14:42 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99201C094240
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 12:13:16 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id i2so2648213qvb.2
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=WF6DBRyA1nnkp0z+SQ9Etyfy61zs6qETUpirV+BAF1o=;
        b=i40/Qcl+Vhg3BL6xViK7rLAIziJwMDPiPNIvat0cxD7O2joCbKmZFO6SeLTVOioVQs
         vTvsLivLwktKPZU3ZwyJuLwTdUYIstpcY4srN0XsygfEnB1llojAkrg62k+jE8QlLN9c
         FaX4GUEu4nho81pzm+dGoBlURBTtoX/sVK5/HkDIYLAjvSQ4v9NZiwLR4NjBZeL94b3w
         NexCwg9P0nASGW8BhRkFF8Kgq2mi3v+6NLPiR7daE25ek5EmUeVFXw6o50VKNyMbjp/u
         0gZYOq6DYW5V/Cs8G8oaKIQ8/g4xCDXPKxLUZEt7dLP4tKWJpZY3MtcUtFrYputGogVY
         r/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WF6DBRyA1nnkp0z+SQ9Etyfy61zs6qETUpirV+BAF1o=;
        b=MowQ/oq0sCZ5XrdIdNjYvKVufcNl0wnmotyVvREtcVeF45tcfO1tkZKL5N51C4B+7e
         Kzfn9xkUtgqoVgz6doxSPd7yq9P3gxBr+p1m2JiZoiV8CzWaWTYr99Ci/PD4qnd5aWRE
         BqovBZqUzqzejTTaUTyTXZA3ze3ZdH9i0ANE/S5vIWYL42a2zR5Md2dwsIsqFJzi/nRF
         t3XxaO+JHDDCEp7b9UqBvF0oNCpIFxwTqnp+H6WuCLs2UwTZkIWAXDFljBGgDf9Tt7Mg
         ouL8TIs8BFELRYL8PqIH2h6hlhG3JRo2PGfUMbJW34zy1Ro+to3TuuNvTUAiPTYv66w2
         yUfA==
X-Gm-Message-State: AOAM5328sNsJTOj8U92xqTT5j9HfUdvxY/pMBDwUZomYxSqbF1spNsU2
        ANpsa85yY2d2gzvjRrDJpDTHvp/4nOw2d4GhNIPg
X-Google-Smtp-Source: ABdhPJymPiNuPuxQWhhq50s/Vukzmmvb/gJcJKlFT7YlC7yqG1ktHbbN5p8+yqNVse3E3PUMhZm5sGxIJZpwRFsCFWvM
Sender: "danielwinkler via sendgmr" 
        <danielwinkler@danielwinkler-linux.mtv.corp.google.com>
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a0c:fa4f:: with SMTP id
 k15mr749911qvo.62.1607026395813; Thu, 03 Dec 2020 12:13:15 -0800 (PST)
Date:   Thu,  3 Dec 2020 12:12:52 -0800
In-Reply-To: <20201203201252.807616-1-danielwinkler@google.com>
Message-Id: <20201203121154.v7.5.I5068c01cae3cea674a96e103a0cf4d8c81425a4f@changeid>
Mime-Version: 1.0
References: <20201203201252.807616-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v7 5/5] Bluetooth: Change MGMT security info CMD to be more generic
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
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

For advertising, we wish to know the LE tx power capabilities of the
controller in userspace, so this patch edits the Security Info MGMT
command to be more generic, such that other various controller
capabilities can be included in the EIR data. This change also includes
the LE min and max tx power into this newly-named command.

The change was tested by manually verifying that the MGMT command
returns the tx power range as expected in userspace.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

Changes in v7:
- Rebase onto bluetooth-next/master

Changes in v6:
- Only populate LE tx power range if controller reports it

Changes in v5: None
Changes in v4:
- Combine LE tx range into a single EIR field for MGMT capabilities cmd

Changes in v3:
- Re-using security info MGMT command to carry controller capabilities

Changes in v2:
- Fixed sparse error in Capabilities MGMT command

 include/net/bluetooth/mgmt.h | 15 ++++++++-----
 net/bluetooth/mgmt.c         | 43 ++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 2e18e4173e2fa5..f9a6638e20b3c6 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -686,11 +686,16 @@ struct mgmt_cp_set_blocked_keys {
 
 #define MGMT_OP_SET_WIDEBAND_SPEECH	0x0047
 
-#define MGMT_OP_READ_SECURITY_INFO	0x0048
-#define MGMT_READ_SECURITY_INFO_SIZE	0
-struct mgmt_rp_read_security_info {
-	__le16   sec_len;
-	__u8     sec[];
+#define MGMT_CAP_SEC_FLAGS		0x01
+#define MGMT_CAP_MAX_ENC_KEY_SIZE	0x02
+#define MGMT_CAP_SMP_MAX_ENC_KEY_SIZE	0x03
+#define MGMT_CAP_LE_TX_PWR		0x04
+
+#define MGMT_OP_READ_CONTROLLER_CAP	0x0048
+#define MGMT_READ_CONTROLLER_CAP_SIZE	0
+struct mgmt_rp_read_controller_cap {
+	__le16   cap_len;
+	__u8     cap[0];
 } __packed;
 
 #define MGMT_OP_READ_EXP_FEATURES_INFO	0x0049
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 668a62c8181eb1..754489e4e0655c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -110,7 +110,7 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_SET_APPEARANCE,
 	MGMT_OP_SET_BLOCKED_KEYS,
 	MGMT_OP_SET_WIDEBAND_SPEECH,
-	MGMT_OP_READ_SECURITY_INFO,
+	MGMT_OP_READ_CONTROLLER_CAP,
 	MGMT_OP_READ_EXP_FEATURES_INFO,
 	MGMT_OP_SET_EXP_FEATURE,
 	MGMT_OP_READ_DEF_SYSTEM_CONFIG,
@@ -176,7 +176,7 @@ static const u16 mgmt_untrusted_commands[] = {
 	MGMT_OP_READ_CONFIG_INFO,
 	MGMT_OP_READ_EXT_INDEX_LIST,
 	MGMT_OP_READ_EXT_INFO,
-	MGMT_OP_READ_SECURITY_INFO,
+	MGMT_OP_READ_CONTROLLER_CAP,
 	MGMT_OP_READ_EXP_FEATURES_INFO,
 	MGMT_OP_READ_DEF_SYSTEM_CONFIG,
 	MGMT_OP_READ_DEF_RUNTIME_CONFIG,
@@ -3710,13 +3710,14 @@ static int set_wideband_speech(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
-static int read_security_info(struct sock *sk, struct hci_dev *hdev,
-			      void *data, u16 data_len)
+static int read_controller_cap(struct sock *sk, struct hci_dev *hdev,
+			       void *data, u16 data_len)
 {
-	char buf[16];
-	struct mgmt_rp_read_security_info *rp = (void *)buf;
-	u16 sec_len = 0;
+	char buf[20];
+	struct mgmt_rp_read_controller_cap *rp = (void *)buf;
+	u16 cap_len = 0;
 	u8 flags = 0;
+	u8 tx_power_range[2];
 
 	bt_dev_dbg(hdev, "sock %p", sk);
 
@@ -3740,23 +3741,37 @@ static int read_security_info(struct sock *sk, struct hci_dev *hdev,
 
 	flags |= 0x08;		/* Encryption key size enforcement (LE) */
 
-	sec_len = eir_append_data(rp->sec, sec_len, 0x01, &flags, 1);
+	cap_len = eir_append_data(rp->cap, cap_len, MGMT_CAP_SEC_FLAGS,
+				  &flags, 1);
 
 	/* When the Read Simple Pairing Options command is supported, then
 	 * also max encryption key size information is provided.
 	 */
 	if (hdev->commands[41] & 0x08)
-		sec_len = eir_append_le16(rp->sec, sec_len, 0x02,
+		cap_len = eir_append_le16(rp->cap, cap_len,
+					  MGMT_CAP_MAX_ENC_KEY_SIZE,
 					  hdev->max_enc_key_size);
 
-	sec_len = eir_append_le16(rp->sec, sec_len, 0x03, SMP_MAX_ENC_KEY_SIZE);
+	cap_len = eir_append_le16(rp->cap, cap_len,
+				  MGMT_CAP_SMP_MAX_ENC_KEY_SIZE,
+				  SMP_MAX_ENC_KEY_SIZE);
+
+	/* Append the min/max LE tx power parameters if we were able to fetch
+	 * it from the controller
+	 */
+	if (hdev->commands[38] & 0x80) {
+		memcpy(&tx_power_range[0], &hdev->min_le_tx_power, 1);
+		memcpy(&tx_power_range[1], &hdev->max_le_tx_power, 1);
+		cap_len = eir_append_data(rp->cap, cap_len, MGMT_CAP_LE_TX_PWR,
+					  tx_power_range, 2);
+	}
 
-	rp->sec_len = cpu_to_le16(sec_len);
+	rp->cap_len = cpu_to_le16(cap_len);
 
 	hci_dev_unlock(hdev);
 
-	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_READ_SECURITY_INFO, 0,
-				 rp, sizeof(*rp) + sec_len);
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_READ_CONTROLLER_CAP, 0,
+				 rp, sizeof(*rp) + cap_len);
 }
 
 #ifdef CONFIG_BT_FEATURE_DEBUG
@@ -8193,7 +8208,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ set_blocked_keys,	   MGMT_OP_SET_BLOCKED_KEYS_SIZE,
 						HCI_MGMT_VAR_LEN },
 	{ set_wideband_speech,	   MGMT_SETTING_SIZE },
-	{ read_security_info,      MGMT_READ_SECURITY_INFO_SIZE,
+	{ read_controller_cap,     MGMT_READ_CONTROLLER_CAP_SIZE,
 						HCI_MGMT_UNTRUSTED },
 	{ read_exp_features_info,  MGMT_READ_EXP_FEATURES_INFO_SIZE,
 						HCI_MGMT_UNTRUSTED |
-- 
2.29.2.576.ga3fc446d84-goog

