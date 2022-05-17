Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96521529E70
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245333AbiEQJro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343723AbiEQJqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:46:38 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E82A2D1FC
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:45:49 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id e6-20020adfef06000000b0020d08e465e2so1041362wro.3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PbU163V9NpaquO6SCuL2TEI60d26RkRN2W+vaRvIf2Q=;
        b=M5AaXstrZzKNEqxjubE0h4I7oP3Lc1dBo2zOqZmvFVoUhzFHGdkruDmgg7usMdo2J4
         AAoUaZ5QzBw9c8N/l8xi7RCa1aBMuREC2x1dBIQ2nVB/cr4dOPRMDKEN2IF6700d4ZzP
         8+hMYI0g9N+R39QOj21DGGb6rW8Z4QrUJVWePh6bP2VXHnIbNsVDkOiNcsDS9GiuxeQD
         bytUmq12CSWcjpm/LPmZ/XzOXTzZyk6weuCk7s4GFHjv1xgrKZ7dYBWmlb1FCRbQY9jY
         3w/NSf8cC4DAQBuqCljdtnHQFSBY0qYx2A1nQWTJ00VdDXtPa4KyBfNA2VUvUnEH74az
         Fy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PbU163V9NpaquO6SCuL2TEI60d26RkRN2W+vaRvIf2Q=;
        b=oTXC5sDY9jhwUxObDIZr3prdI8XyhC3ayRUVwgx4Eh5yHUyVcnq+IEvfusnvBwEyA+
         XmjWmJigoWvijJ121THDPx+UztBH8yxCddJM0UzsmmTp4I33tWWDcrAkW7OxqZCDlnwq
         nvniDIqkX928sUSQDvRm0iKz9YNroKRFDQipgSsJB7GXstGhzakMtzMj4789ViRmKB7u
         26l4uPio5Qx/XPIGCW9ICJxD59TKDgkLCexVrYwcDMEPpjweTPfUWVy7nOmUC9xqDYCt
         RcHn4prBqxturgR68Cwswi1RJUOOS1H/I/KRtH0fN1LmklC9Nuy9IoMxPNlHiX9BugcR
         F8hQ==
X-Gm-Message-State: AOAM5304o0QOBQthUNLqIykX0qH27/2CFl5nYJzgxRhevv/k4sFI+sPp
        +TyknbjJ2AifPcWhoWef85sXOWA4OFc=
X-Google-Smtp-Source: ABdhPJyduSrbVAvYxKEvK1sdYPUr1HXYq+Qu5FwsYmEM8CISkPzjSnRc1an8drEgN9+zFIeKi/8dL5vLv7A=
X-Received: from rax.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2a98])
 (user=poprdi job=sendgmr) by 2002:a05:600c:1e17:b0:394:547c:e5a6 with SMTP id
 ay23-20020a05600c1e1700b00394547ce5a6mr20628734wmb.203.1652780747377; Tue, 17
 May 2022 02:45:47 -0700 (PDT)
Date:   Tue, 17 May 2022 09:45:32 +0000
Message-Id: <20220517094532.2729049-1-poprdi@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH] Bluetooth: Collect kcov coverage from hci_rx_work
From:   Tamas Koczka <poprdi@google.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     theflow@google.com, Tamas Koczka <poprdi@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_stop()
calls, so remote KCOV coverage is collected while processing the rx_q
queue which is the main incoming Bluetooth packet queue.

Coverage is associated with the thread which created the packet skb.

Signed-off-by: Tamas Koczka <poprdi@google.com>
---
 net/bluetooth/hci_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 45c2dd2e1590..703722031b8d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -29,6 +29,7 @@
 #include <linux/rfkill.h>
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
+#include <linux/kcov.h>
 #include <linux/property.h>
 #include <linux/suspend.h>
 #include <linux/wait.h>
@@ -3780,7 +3781,9 @@ static void hci_rx_work(struct work_struct *work)
 
 	BT_DBG("%s", hdev->name);
 
-	while ((skb = skb_dequeue(&hdev->rx_q))) {
+	for (; (skb = skb_dequeue(&hdev->rx_q)); kcov_remote_stop()) {
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
+
 		/* Send copy to monitor */
 		hci_send_to_monitor(hdev, skb);
 
-- 
2.36.0.550.gb090851708-goog

