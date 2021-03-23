Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1135D346830
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhCWSz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbhCWSzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:55:08 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56792C061764
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 11:55:06 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id u17so2201501qvq.23
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 11:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RYIeg+FAZo3N58AkdDKWG73SSjjPsdnT5WfpGKmyRWc=;
        b=MenOAbW8u/FEj1QE4zVvDCRZ3GxvMYxHAqW/vQq1Otd/70qUmEd+Epa4Fr/Dul15+M
         EdpQqtmL3TaqapOrXmNEUDv2bxPuNniHwyodHkRl05h94uYjYIaMz/gpUfzCS5XEXqKo
         Is1CoCpXx0H11blhGVhdIAxQLJPMsPvgB47eKtnzVFguZPC3aHgC9VgEko/q96AEzF+A
         IvfQ6Af5wUoN5ctwn+F3LrI4Map1O26i3DAwxU6GazWtPDMp3mhMlMIEm4xJxQDYZ+02
         JAMtyR3mz9fAi0rz7ALfg6YGlcP7RtmATbMU5wSgpg+TW1ISXRWUSa7y7qqBEiyx8dIs
         BCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RYIeg+FAZo3N58AkdDKWG73SSjjPsdnT5WfpGKmyRWc=;
        b=cy5ATvcM5AO3AYbrDUBkB/MeURwNC4jFtrL8A68fKoe6SdZ3AR36JLMvN4kKEvPWJI
         eDC12mnD6xMZO8+eo1jQwdlD12Zo66WSFO86PmblOE6/uao1x7/QQzvEmWHak4HIf8zu
         Lr4hs364VI1v+C87qLFjqdNIfs5Za5kFdrkD3E+HmidY9f1bD/N8aQcjxYBSuQKxecfP
         U2RzvoANtXlyUe0x1yzXU3E4jUIGKjqD2386WaxoAKZG87AXVQobbq6RMhi0dXS9lqd6
         eI0mv+X6hQTyFwUizcL6rf16h3VehrAkWZ3gLVoarJCDFKWb0/BNBKVLTIlImQNh+6Sp
         mK7w==
X-Gm-Message-State: AOAM5317jJccJ7VBKMm64tpaZnsQRh12UpMZzCv8e6KA8+/PZ1NU8ELv
        nFY1ivr7RPnGYNNv1KmrZ/v90LD8Gz1j
X-Google-Smtp-Source: ABdhPJydufRLpAYUkWP7OAc5HCE53zn6a0Riy08NSpBqvYAYyUrCb2Y2cjgPOPoQcWq1/INhwREoRisU0Zt4
X-Received: from yudiliu.mtv.corp.google.com ([2620:15c:202:201:a916:b584:a08a:3fcd])
 (user=yudiliu job=sendgmr) by 2002:a05:6214:12a1:: with SMTP id
 w1mr6227626qvu.57.1616525705227; Tue, 23 Mar 2021 11:55:05 -0700 (PDT)
Date:   Tue, 23 Mar 2021 11:55:01 -0700
Message-Id: <20210323115459.v1.1.I3f19b22d6eaaa182123e373a9fa1fa85105aba07@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v1] Bluetooth: Return whether a connection is outbound
From:   Yu Liu <yudiliu@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org
Cc:     Yu Liu <yudiliu@google.com>, Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an MGMT_EV_DEVICE_CONNECTED event is reported back to the user
space we will set the flags to tell if the established connection is
outbound or not. This is useful for the user space to log better metrics
and error messages.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>

Signed-off-by: Yu Liu <yudiliu@google.com>
---

Changes in v1:
- Initial change

 include/net/bluetooth/mgmt.h | 2 ++
 net/bluetooth/mgmt.c         | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a7cffb069565..d66bc6938b58 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -885,6 +885,8 @@ struct mgmt_ev_new_long_term_key {
 	struct mgmt_ltk_info key;
 } __packed;
 
+#define MGMT_DEV_CONN_DIRECTION_OUT	0x01
+
 #define MGMT_EV_DEVICE_CONNECTED	0x000B
 struct mgmt_ev_device_connected {
 	struct mgmt_addr_info addr;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 90334ac4a135..fc0ff6dc7ebf 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8772,6 +8772,11 @@ void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
 	bacpy(&ev->addr.bdaddr, &conn->dst);
 	ev->addr.type = link_to_bdaddr(conn->type, conn->dst_type);
 
+	if (conn->out)
+		flags |= MGMT_DEV_CONN_DIRECTION_OUT;
+	else
+		flags &= ~MGMT_DEV_CONN_DIRECTION_OUT;
+
 	ev->flags = __cpu_to_le32(flags);
 
 	/* We must ensure that the EIR Data fields are ordered and
-- 
2.31.0.291.g576ba9dcdaf-goog

