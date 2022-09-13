Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9D35B7CDD
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 00:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIMWEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 18:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiIMWEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 18:04:44 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3272AB48D
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 15:04:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q14-20020a6557ce000000b0041da9c3c244so6382639pgr.22
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 15:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=0/mpIJ2sZEnqGQU+eeGOiHwYV7wmza8JoOszk+ZskGw=;
        b=La2UwnxAwzAIGGTRGxRY2aTrW3UyWe1vYGqQwnejHW/RqXhDz1yh045Mn5/TmsTyFn
         PREzALzxxhe7wqsvV2a1r5msIKw6sh1z8ZWKRJ5DNUVYmntdMUA9YrYV6j06/m7A080i
         epGrr40YmEFv3o+fBQzzB1Fpr3Qy9Iky4VNXrVsFtYVHU3yNQpO1m5j53EiNBDM0dpz8
         nIxflgGMf6LG82a3G3gUhuBwzMrWb9jsiGf4tFbXP9duQ1vMSiKDLe8GBCuZ7atCjw+E
         Keh51/YMhMoHFIqCkDl8sZLYfh3Kt73sC5xg2D6iUPAyZJ9hbWyA3JmmMvVIsSfHi40e
         2WJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=0/mpIJ2sZEnqGQU+eeGOiHwYV7wmza8JoOszk+ZskGw=;
        b=6sEad95YD+jG87xHuwfli7o0PoreDIOrljylEJE4mZ1l5eQi0InyE6twsNYcM+d1Nm
         xyqakAIF2ZLEeGNAKNKB90QZqJnUx98fIUl+0er4SjcUk8rOd0CVvmJIxk4Eu69TVZvd
         r6+tOmGb/fYIMO+FEPZW1eCur05oMQJ1QfmOaMFGtgv5ChxDOyNPJnRVQ+YGmIQIFUij
         4sCo+6Ap/3EetPjI3+QH4YKRJcXbvk3nMQpuuvxvOW9B2C+ertYgGe2XOj8MQ+UWNDZU
         UDJAoLwBJn3s83U7OY3aEQ+Hb8InaUdVw5xKjv5/djwdJKSizp0J8FGFI/vQH3K+gNDn
         +nUg==
X-Gm-Message-State: ACrzQf2mBMSZ90n1UZbKvYmutYNkIc1GL28HnJOfzYLyqTFzL2t+EzLZ
        7vNMjO3Ut7cNPUFqo/Dsx6+oamuQT8TL
X-Google-Smtp-Source: AMsMyM67wH92vPtBbRZur6xn/xAJQLsTNPKQnIQuXSlrC9cCXreVggMRolS4xlStq9OL3cYYQ8CiMAMqWSAf
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a17:90b:1b12:b0:200:5dbd:adff with SMTP id
 nu18-20020a17090b1b1200b002005dbdadffmr1364786pjb.43.1663106682689; Tue, 13
 Sep 2022 15:04:42 -0700 (PDT)
Date:   Tue, 13 Sep 2022 15:04:33 -0700
In-Reply-To: <20220913220433.3308871-1-jiangzp@google.com>
Mime-Version: 1.0
References: <20220913220433.3308871-1-jiangzp@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220913150420.kernel.v1.1.I54824fdfb8de716a1d7d9eccecbbfb6e45b116a8@changeid>
Subject: [kernel PATCH v1 1/1] Bluetooth: hci_sync: allow advertising during
 active scan without privacy
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address resolution will be paused during active scan to allow any
advertising reports reach the host. If LL privacy is enabled,
advertising will rely on the controller to generate new RPA.

If host is not using RPA, there is no need to stop advertising during
active scan because there is no need to generate RPA in the controller.

Signed-off-by: Zhengping Jiang <jiangzp@google.com>
---

Changes in v1:
- Check privacy flag when disable advertising

 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 41b6d19c70b06..422f7c6911d9f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5351,7 +5351,7 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 	/* Pause advertising since active scanning disables address resolution
 	 * which advertising depend on in order to generate its RPAs.
 	 */
-	if (use_ll_privacy(hdev)) {
+	if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRIVACY)) {
 		err = hci_pause_advertising_sync(hdev);
 		if (err) {
 			bt_dev_err(hdev, "pause advertising failed: %d", err);
-- 
2.37.2.789.g6183377224-goog

