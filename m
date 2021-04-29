Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436FC36EF07
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 19:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbhD2RjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 13:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhD2RjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 13:39:05 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB69C06138C
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 10:38:18 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id u16-20020ac86f700000b02901baa6e2dbfcso8836991qtv.20
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 10:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WpMEHPbds2Rhg3l6Bk0VFJZGn5ipo4apAqnWrKsE5c4=;
        b=UkLmhq21G9yc49Z2YWhYMcMJfpH4lMjNSOHTQ3p6SDiJI/yS+IxzvfHobHXQ9br85T
         Jx8T8/MJykCPgA5QYmKHmrktKQX5DECpwYJmhbyB4D/31LwoujpBkp3s2DTHPeC7Zm4Y
         OvW059QSWPjthG0jxddJIB7lpZi4iUxdDngi8UNzJGiis4K6Ww4tUvxB9nIi2PvUFeEv
         W4ufOBaZD8a7ysZbTWIb6mKx4fqMAyyZcPxPbo1090QhGw6l+ZtO2llLVUsVDNqmZKic
         9eL3NcNaU3I+SXFwxdQae/89tC6dowvLsyvDRgDmh5vAGSwzSHyQZsihkws/P3g+s15K
         FLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WpMEHPbds2Rhg3l6Bk0VFJZGn5ipo4apAqnWrKsE5c4=;
        b=kwRkRbxCaqwo2lEKxew9P8VHkEAVsB7lpYNP7BbgunO3vC+kqsR1N0UZQN+CJeGVtS
         wk5KKPpJpzorPn3JSkwpYlPa1UCdmvQhYtKNZdsDxezFsvD4jz3WfFL5e5dEdidLJ3p8
         WbofFFZrDXOgC9JlPEyDkmx0alTbPNDKRV4GSiE/n5XXQgl8xBOyKoKrAjAhc7wCVeR9
         Iv4XRx3fWGLt0OQqGPSPxs/CFmrAaJ2i/DeIpArR/KyXxQNiOs0zCYToOCs17wuW466y
         gkLi62N2LhEkBjeK0XtpnAtCgNskxFKxdEHmlaAx8E2/gHLIPdjHFgK+9v2J6wVoRPhy
         MQoQ==
X-Gm-Message-State: AOAM53362FSaOJUh9Zxx6mV30e4QVH17ch/QoR4UxWrtrcDW4GpMcuzs
        z9hf3UL+kK+EoI1aDZOcKvGJ43j9+SDN
X-Google-Smtp-Source: ABdhPJxTYICujkQPtJYJVsHuxV271Yk6KHakyDkdvkOIG4LlOoxWUwhIKhNzSjNgwQJLcqyM0F7JA9WNzcZJ
X-Received: from yudiliu.mtv.corp.google.com ([2620:15c:202:201:b87a:317b:6a3:155c])
 (user=yudiliu job=sendgmr) by 2002:a05:6214:2b0:: with SMTP id
 m16mr957921qvv.4.1619717897610; Thu, 29 Apr 2021 10:38:17 -0700 (PDT)
Date:   Thu, 29 Apr 2021 10:38:12 -0700
Message-Id: <20210429103751.v1.1.Ic231ad3cfa66df90373578777cf7cdc7f0e8f2ae@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v1] Bluetooth: Add a new MGMT error code for 0x3E HCI error
From:   Yu Liu <yudiliu@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org
Cc:     Yu Liu <yudiliu@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to enable us to retry the pairing in the user space if this
failure is encountered

Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

Signed-off-by: Yu Liu <yudiliu@google.com>
---

Changes in v1:
- Initial change

 include/net/bluetooth/mgmt.h | 1 +
 net/bluetooth/mgmt.c         | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a03c62b1dc2f..78b94577a7d8 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -45,6 +45,7 @@
 #define MGMT_STATUS_RFKILLED		0x12
 #define MGMT_STATUS_ALREADY_PAIRED	0x13
 #define MGMT_STATUS_PERMISSION_DENIED	0x14
+#define MGMT_STATUS_CONNECT_NOT_ESTD	0x15
 
 struct mgmt_hdr {
 	__le16	opcode;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b44e19c69c44..9e44c04d4212 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -271,7 +271,7 @@ static const u8 mgmt_status_table[] = {
 	MGMT_STATUS_INVALID_PARAMS,	/* Unsuitable Connection Interval */
 	MGMT_STATUS_TIMEOUT,		/* Directed Advertising Timeout */
 	MGMT_STATUS_AUTH_FAILED,	/* Terminated Due to MIC Failure */
-	MGMT_STATUS_CONNECT_FAILED,	/* Connection Establishment Failed */
+	MGMT_STATUS_CONNECT_NOT_ESTD,	/* Connection Establishment Failed */
 	MGMT_STATUS_CONNECT_FAILED,	/* MAC Connection Failed */
 };
 
-- 
2.31.1.527.g47e6f16901-goog

