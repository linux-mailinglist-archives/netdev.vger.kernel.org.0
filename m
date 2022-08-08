Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4DE58CD47
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242955AbiHHSEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiHHSEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:04:11 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A2CBBD
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 11:04:10 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q193-20020a632aca000000b0041d95d7ee81so1047959pgq.3
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 11:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=i/p7LGLfjb+nLpq/nY6wn3Xfq2spkFdKAOyq1M30HPc=;
        b=ZePU11aNtEEMiBoUF9W/z+JGVZO6mwi/aizbI8sd6c1J58oZkOlAo3suFI0mVCnQ9k
         hjWl4ZExNENtkZTZX5SnA5qdpKHh5OOSrnW9yBZ6ztbaGJqdyCk+LuJeFz1zENt1KLYi
         ScdrmvGS0GM3EtNdZd6Y4LB+VM4aXJGgWxKmSej+RXR+0QT/drtLPChAmpGLsf7tObFC
         E+PMUj8BygBsd+Aj4Qd6NTRdGq/UJJ0Rf+k4wRLAdZjA/2qmccJP9S/j5BHfETcI0dV5
         dK9QWK6eZjRf3CLXI5/GgMnlyMzSuhxFJqy+PMcfqn9JpVPIHxzNfZAehDGo4/VPOzgf
         3Ctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=i/p7LGLfjb+nLpq/nY6wn3Xfq2spkFdKAOyq1M30HPc=;
        b=4mDeMadJTMZE5k+Iig1ac3dTdoHjNNQMm157jp5afuorkQRKUVlkdsOvtWy3pHDncm
         VaRmWC4YhhB5QKxiR9GQrIQq70nwO2v+4MYVp87srH2UvdzbGqG3M0jukwmZUoV95zyU
         xZJyjFhOqgMGm2jeMXjWHOgHkJsqVX4YuZh+dr4tsGr52RpJPBekXuE01OB6NEdnmgMJ
         nJUqmLFLp9vpQTS3b9XJVnKps/5EtrDm8FVdwGym2uRd3Mg6TCOnzN9LBN1GaW7X+S7v
         uKiks8VH14b/1S+dwQRqnOzlYRxnlonATYG4e6rFq71BZcFzM/Xk70KpFXdWB8dPTnfP
         hU6g==
X-Gm-Message-State: ACgBeo0x30YcL3siQfcnRV0BCEfZBDnKX9ZEU4A7OYA/PLNfVhwq+Ejo
        qQhMZloIYwT46DatbDbOfDctd7jaLgZ2l16MQrPYUA==
X-Google-Smtp-Source: AA6agR5iJrO+qq8IjTPD5752SDkNL9Rx73THRZnPZLbLwyEIdeGXcwSprgWYBk8V6hjBJX7BSXVzUOFSJ0JVOXOKcfjNJQ==
X-Received: from abps.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:9b4])
 (user=abhishekpandit job=sendgmr) by 2002:a17:90b:33c4:b0:1f5:8428:beb9 with
 SMTP id lk4-20020a17090b33c400b001f58428beb9mr18689282pjb.95.1659981850316;
 Mon, 08 Aug 2022 11:04:10 -0700 (PDT)
Date:   Mon,  8 Aug 2022 11:04:05 -0700
Message-Id: <20220808110315.1.I5a39052e33f6f3c7406f53b0304a32ccf9f340fa@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH] Bluetooth: Ignore cmd_timeout with HCI_USER_CHANNEL
From:   Abhishek Pandit-Subedi <abhishekpandit@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

When using HCI_USER_CHANNEL, hci traffic is expected to be handled by
userspace entirely. However, it is still possible (and sometimes
desirable) to be able to send commands to the controller directly. In
such cases, the kernel command timeout shouldn't do any error handling.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
This was tested by running a userchannel stack and sending commands via
hcitool cmd on an Intel AX200 controller. Without this change, each
command sent via hcitool would result in hci_cmd_timeout being called
and after 5 commands, the controller would reset.

Hcitool continues working here because it marks the socket as
promiscuous and gets a copy of all traffic while the socket is open (and
does filtering in userspace).

Tested on Chromebook with 5.4 kernel with patch (and applied cleanly on
bluetooth-next).

 net/bluetooth/hci_core.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b3a5a3cc9372..c9a15f6633f7 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1481,17 +1481,25 @@ static void hci_cmd_timeout(struct work_struct *work)
 	struct hci_dev *hdev = container_of(work, struct hci_dev,
 					    cmd_timer.work);
 
-	if (hdev->sent_cmd) {
-		struct hci_command_hdr *sent = (void *) hdev->sent_cmd->data;
-		u16 opcode = __le16_to_cpu(sent->opcode);
+	/* Don't trigger the timeout behavior if it happens while we're in
+	 * userchannel mode. Userspace is responsible for handling any command
+	 * timeouts.
+	 */
+	if (!(hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	      test_bit(HCI_UP, &hdev->flags))) {
+		if (hdev->sent_cmd) {
+			struct hci_command_hdr *sent =
+				(void *)hdev->sent_cmd->data;
+			u16 opcode = __le16_to_cpu(sent->opcode);
 
-		bt_dev_err(hdev, "command 0x%4.4x tx timeout", opcode);
-	} else {
-		bt_dev_err(hdev, "command tx timeout");
-	}
+			bt_dev_err(hdev, "command 0x%4.4x tx timeout", opcode);
+		} else {
+			bt_dev_err(hdev, "command tx timeout");
+		}
 
-	if (hdev->cmd_timeout)
-		hdev->cmd_timeout(hdev);
+		if (hdev->cmd_timeout)
+			hdev->cmd_timeout(hdev);
+	}
 
 	atomic_set(&hdev->cmd_cnt, 1);
 	queue_work(hdev->workqueue, &hdev->cmd_work);
-- 
2.37.1.559.g78731f0fdb-goog

