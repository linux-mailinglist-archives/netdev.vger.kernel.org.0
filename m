Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F423EE03D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhHPXM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhHPXM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 19:12:26 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB877C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 16:11:53 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id c24so37576322lfi.11
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 16:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3wqbKr4UPEvs0QNhhWbq71AvFRB1aC289caQoG/Bnjo=;
        b=jpqGEcDW5jGEVmSGjTSc35pfV2R+d1h01rxbmcwlxHVrH9Pi+z1P6uMdRNkH68jBLO
         UeQptzeDVo/CGGjmFlrrMHKlmHyKz6K+ifzdMfJVHbjOPhPEQl2gcuBbWIwkAk/NxhVt
         zXqVSvhEn7s9/t0Yugl27RhWgT7F0Rhq+T3boNB8BPbTGr54NL/KQBmOrsjAf2+QtOdu
         N34Ku5ZpbQPBTVVBryTOvP9AWrERqv0uK/gtYCWZsGQ2tqvoAjApqWiULiSwfUkFdKND
         HDHhSjeT9v7I/QR3wORRYsAJLTJStz9C6OaSjo1JxRQwshfEjC+/4+oPC/4h1dHm3PXF
         G6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3wqbKr4UPEvs0QNhhWbq71AvFRB1aC289caQoG/Bnjo=;
        b=atNOBLbSUGdPyDcZ+4SVkQHGu5gU+iEIc8xTJESA+xLtpLx9iH7/YpKVSZW57CI/m8
         VTxoyRjGhI3zHinaHRS3iqYc/ToH109X3ByY9ZTewbe4+HPD26t+525XhxhAYP8iL2wg
         K2PyWT2lN0c84F+SwVXJsqv1yh05ihl+L26Mcn8C3ZUM8XjlqCz2W5+wOqorpovK1w5r
         0hF36mG+CM5JOeV/0SLtgBPUbtlo9G+znLHrrqCA2XToiIFP+HuOlBY5kAAjaR9qQlqS
         puF4PrFn2gc6RS3FT8PlfPMMd0snzBWNDMjiyk6j87sgDypODBVgi7tITul7yViEesyF
         dfmA==
X-Gm-Message-State: AOAM531Hv0nDkXx8/4PGREC6ot1R4p/jM4tbJLG2GbtC7qAFYz1oIyig
        LFTonmDjxP7IIR1xbMAUV6eTqg==
X-Google-Smtp-Source: ABdhPJzbDsfSQetG4UjSDTJh3jUjVfR+h44KLI4y4am7dtT9DGR3iv0jqQORzJDcfuRbDIVLJEpZsg==
X-Received: by 2002:a19:6b02:: with SMTP id d2mr149660lfa.522.1629155512033;
        Mon, 16 Aug 2021 16:11:52 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id e6sm22846lfr.257.2021.08.16.16.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 16:11:51 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH] Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
Date:   Tue, 17 Aug 2021 02:11:50 +0300
Message-Id: <20210816231150.1478727-1-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0ea9fd001a14ebc294f112b0361a4e601551d508. It moved
calling shutdown callback after flushing the queues. In doing so it
disabled calling the shutdown hook completely: shutdown condition
tests for HCI_UP in hdev->flags, which gets cleared now before checking
this condition (see test_and_clear_bit(HCI_UP, ...) call). Thus shutdown
hook was never called.

This would not be a problem itself and could fixed with just removing
the HCI_UP condition (since if we are this point, we already know that
the HCI device was up before calling hci_dev_do_close(). However the
fact that shutdown hook was not called hid the fact that it is not
proper to call shutdown hook so late in the sequence. The hook would
usually call __hci_cmd_sync()/__hci_cmd_sync_ev(), which would timeout
without running queues.

Thus I think it is more proper at this moment to revert the commit and
look for a better solution.

Fixes: 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues are flushed or cancelled")
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 net/bluetooth/hci_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e1a545c8a69f..677d880068a4 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1721,6 +1721,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	cancel_delayed_work(&hdev->power_off);
 	cancel_delayed_work(&hdev->ncmd_timer);
 
@@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 		clear_bit(HCI_INIT, &hdev->flags);
 	}
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			hdev->shutdown(hdev);
-	}
-
 	/* flush cmd  work */
 	flush_work(&hdev->cmd_work);
 
-- 
2.30.2

