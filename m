Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADCA2AB1FE
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgKIH5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgKIH5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:57:39 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46CDC0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 23:57:39 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id m7so3573947pls.12
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 23:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=fZu+i/Tey4YuHE3nmf4R/J6pPaT130pHwxhtyujUvT8=;
        b=dCjzCsA1NNS5/KnUDsa0Jo9Dx9F/NoCnQ4fUtHSJ3jy8SfMB2iffkzAlNmiBxpzv93
         R8ZrvAVK+qwQRQUxZQRiK860r1KKiIKzQ+nptmBAeWZnER6ixDejzjWrxfsbWFpesO6q
         fB71JL3uHFwx0yIrjmqmv5VYlPmuW5aCek6SG27rcHvOFQV0j0WxgMXOrlUE+n1xTftI
         OHCOBgQEZVDC5lZb7tRT8yFBV/Gt3ZchznUFo3od037F1uwp66wZ75bXDf54oAqfj7yM
         N8xngeORkWvr2OYCBwvOLu+0y8745+A2Jt+u6PFMd1EFREprQq6wAtKOBt0tEHYPFgD+
         +gVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fZu+i/Tey4YuHE3nmf4R/J6pPaT130pHwxhtyujUvT8=;
        b=rHn2KGlLVTLtruPuWQOXuvX5D7U8Ub5wFrSmB+3xm9QcQrs4IcPIF3wtbpbD4i4z44
         fv1zXz3WSrQjTd4wSsq435YJpHPUFqF6zWRqfx1GXakH4DXpG+zVqZU/uMBV8t1GEenE
         G6wokvGNOBWYbK7DHHXCAhvKBhkuURiuiyryQN9uoudrqymmPKdqdOqRx5oAWwocW7rk
         JXj+9rDA4ap3pgBbfnXoYwIveId8i+6HunBhaebCAwavWkb7NkIaf0MHmlJpAN3KoWc2
         irRZd2MyA0LZQgaPkIH+bZGxAeKk8UEBlJnVvofcf9QkuKFw2oDOuS8/Y6WMxYmliowe
         pkZQ==
X-Gm-Message-State: AOAM531mZSqdcMReV7oPxyuIMNoDwBvHJMVaZhiCRlMc8gzQcATkYUGc
        AJh4mn3sgypikQkVx83EbOoDHBJeNQdWj7ZJmg==
X-Google-Smtp-Source: ABdhPJzvhFDG65ja4IDNja/+FMSLFMnHzO5O5WnBrF0c4Jy+9ZC4DC5CJtt2ggr4upsCUOF7GrFvI0b/S+/8uHHW3g==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a17:902:8e87:b029:d6:8dde:138b with
 SMTP id bg7-20020a1709028e87b02900d68dde138bmr11541206plb.83.1604908659272;
 Sun, 08 Nov 2020 23:57:39 -0800 (PST)
Date:   Mon,  9 Nov 2020 15:57:23 +0800
In-Reply-To: <20201109155659.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20201109155659.v7.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20201109155659.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH v7 2/5] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.org, alainm@chromium.org, mcchou@chromium.org,
        Howard Chung <howardchung@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds code to handle the system suspension during interleave
scan. The interleave scan will be canceled when the system is going to
sleep, and will be restarted after waking up.

Commit-changes 5:
- Remove the change in hci_req_config_le_suspend_scan

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
---

(no changes since v1)

 net/bluetooth/hci_request.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 70ea126f56282..b615b981be9d6 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1284,8 +1284,10 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
 
 		/* Disable LE passive scan if enabled */
-		if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
+		if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
+			cancel_interleave_scan(hdev);
 			hci_req_add_le_scan_disable(&req, false);
+		}
 
 		/* Mark task needing completion */
 		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
-- 
2.29.2.222.g5d2a92d10f8-goog

