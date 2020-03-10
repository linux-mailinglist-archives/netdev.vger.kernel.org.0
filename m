Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DE8180396
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgCJQcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:32:47 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:55896 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgCJQcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:32:46 -0400
Received: by mail-pf1-f201.google.com with SMTP id 78so6804395pfy.22
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=orSnkR0b0kEaczXYpxz6sH2e+X0g5twrn8pQx+WIZsU=;
        b=f9d7nMDELRVltXLuc+w/x0sA9qcoRpITVlGtCZMS3SIPIR4GcWsOQof7Ev82kZrUii
         yH3Z0EpkdC9MD2e2RMoP4DIxM/2rLW21qeBviJy2WyMN1ZrMJs0Bhjx49QLTzoJNBTgU
         4DMR+vHmZuhQ5UxOTBoN5opUtIVAkohIuqimV4s5pO8ct8XofVo/Jq4E51k5/JCWKCg/
         9Xdi9jFPKgNrJJHhPKJRGbDvxBibwI2RwjxjoxPElmsRuV+ytDt3a1OncyBBUIt6mv7u
         nnMwGE+x2qN37Zue0ZsnAEUNJ6aiIz2zNk6x/lDi8UuFo+udFUd6vGTP/HhRoUoJ4q9R
         XdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=orSnkR0b0kEaczXYpxz6sH2e+X0g5twrn8pQx+WIZsU=;
        b=FODk+bozcuyxNwe3IXNYLSmf0pKUK+aVT2Ofl4MIhB+1eSlj1kfOfkQdn5Vr3xeLw3
         9A/APoECIPTZP+0jfWTJy2HnosEfA/NInx3SdBQHAz05ov/n13buAcgWXcaPYopMCvzg
         9fVn/7IhrBf+ZgGBZiV5ZzJ4Pr0+UVRW6KXnuge0hgWx81CFYVkTfO5j74nZBGVTABV3
         4dh6yhzLQlyCoI/mWPQ8ePZ9X6sY7Zts4SnBPA1YwPMHzQ/BdFn3OsJQIspbVvNT83f6
         gszhFD5fvf5KtJXx0ebXsnbwS1GBu4U8teaJUNuGcnu4dmnFZ3hCfoBuT/Ee5XVoV4sS
         Di6w==
X-Gm-Message-State: ANhLgQ1ywpncqPS3tvLw0MCDfaOJzbEbmOJ/knlvAioemulH6giDf5O3
        TT1R0BivaBL6C3P3GFEp6nCvJEqRc5mkwQ==
X-Google-Smtp-Source: ADFU+vsk/MhKLnMEl6XXM0gmfMX/+yVoxQ1mlYcZ9OVXE+KVATINDkuf9BSlNbBWf92pBgHmMAtRTSSReTRc3A==
X-Received: by 2002:a17:90a:be0c:: with SMTP id a12mr2651608pjs.26.1583857963999;
 Tue, 10 Mar 2020 09:32:43 -0700 (PDT)
Date:   Tue, 10 Mar 2020 09:31:50 -0700
Message-Id: <20200310093101.1.Iaa45f22c4b2bb1828e88211b2d28c24d6ddd50a7@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH] Bluetooth: mgmt: add mgmt_cmd_status in add_advertising
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org
Cc:     Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        Miao-chen Chou <mcchou@chromium.org>,
        Joseph Hwang <josephsih@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joseph Hwang <josephsih@chromium.org>

From: Joseph Hwang <josephsih@chromium.org>

If an error occurs during request building in add_advertising(),
remember to send MGMT_STATUS_FAILED command status back to bluetoothd.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Signed-off-by: Manish Mandlik <mmandlik@google.com>
---

 net/bluetooth/mgmt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 1002c657768a0..2398f57b7dc3c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6747,8 +6747,11 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	if (!err)
 		err = hci_req_run(&req, add_advertising_complete);
 
-	if (err < 0)
+	if (err < 0) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
+				      MGMT_STATUS_FAILED);
 		mgmt_pending_remove(cmd);
+	}
 
 unlock:
 	hci_dev_unlock(hdev);
-- 
2.25.1.481.gfbce0eb801-goog

