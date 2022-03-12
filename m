Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993C94D7009
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 17:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiCLQsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 11:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiCLQsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 11:48:53 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086D17A98D
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 08:47:46 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id i8so17451001wrr.8
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 08:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9w/6bA1aoDkuJHS9K/TSkBOWaS4khHnnBbWGRmad4GA=;
        b=kX8golIdtVAkBB6ZLCRB9mXOVYRu7qL+w+gaG/UC2GEXzB+k3ZzNYziZElwDT5HkFV
         KD3W5VxxuCyy64hmDiXUv7e4DAvLYv6q2hGxOHdRmUGDbXhMwfFdkHqnfYdSa3BMNmVc
         pUU4TinqRVEmwF3fpE3OnuBGO8m/VfnW8RpVxjJt71chm04YyjbQ+Ed/Ec6/T/RJNLGZ
         o2XH2qxT5YO0Ye2SWI9gZcyzI8xguptKee4X5xjzwhQMuBdYy8+KAGWvdt7rSot3rIOc
         vMC2D8a/XG8IvHDMJBTS+fh6cfizjyAa1B1O0D7t63cc9c01uzm0R2lnv+unShXC4dpG
         fm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9w/6bA1aoDkuJHS9K/TSkBOWaS4khHnnBbWGRmad4GA=;
        b=4vLKCX3GvsuF3bYNK8LtOGQVXJJo+RNjDWHgwXfalNyupdAi2m/wbBxGYF+VrS8G30
         LN6XTm6KAVMIvSYC6ZZGYC9BYiv/szQTmrNL0hR/z5m3Q6tf3NKYujcYLrOv5jgOu4OL
         NNV2z/fOi4WqrfwOvIwRZwe4rxzDyFPGlFZ1DhxBQTmFi04oa54Zf60PdG9YcMeHZ1ff
         2p/+5x5sosiZzO6fU234eojWkk1RYbEyAE7ztOM0AtaUoq7ftEcVfxnTwVRJcYk0x31W
         TZMy7CWQZ/mguh4rMc5Fg0Ag88LYEOshryJ0y1gLqGAw5p27wJOueG4BiX4BL6e3HLQz
         cXAw==
X-Gm-Message-State: AOAM5321/ogkLY4JWaFimmDAQC8MqLsHSlPWxbL12Rc/IXUXyYvboTPJ
        7a44C/VNYgDJNbjGahNqY2Lh7g==
X-Google-Smtp-Source: ABdhPJyA0kGFQ3L/J2KAMLzwTEX3mpb7NfSn4ieEi+P9Pmntd3uMjnsV0BEOouselFo9ecimO19RHw==
X-Received: by 2002:adf:d1c3:0:b0:203:8647:6fbe with SMTP id b3-20020adfd1c3000000b0020386476fbemr10323720wrd.65.1647103664396;
        Sat, 12 Mar 2022 08:47:44 -0800 (PST)
Received: from axion.fireburn.co.uk.fireburn.co.uk ([2a01:4b00:f40e:900::24e])
        by smtp.gmail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm12760833wmp.44.2022.03.12.08.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 08:47:43 -0800 (PST)
From:   Mike Lothian <mike@fireburn.co.uk>
Cc:     Mike Lothian <mike@fireburn.co.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: hci_event: Remove excessive bluetooth warning
Date:   Sat, 12 Mar 2022 16:45:51 +0000
Message-Id: <20220312164550.1810665-1-mike@fireburn.co.uk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 3e54c5890c87a ("Bluetooth: hci_event: Use of a function table to handle HCI events")
Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
---
 net/bluetooth/hci_event.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index fc30f4c03d29..aa57fccd2e47 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6818,14 +6818,6 @@ static void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
 		return;
 	}
 
-	/* Just warn if the length is over max_len size it still be
-	 * possible to partially parse the event so leave to callback to
-	 * decide if that is acceptable.
-	 */
-	if (skb->len > ev->max_len)
-		bt_dev_warn(hdev, "unexpected event 0x%2.2x length: %u > %u",
-			    event, skb->len, ev->max_len);
-
 	data = hci_ev_skb_pull(hdev, skb, event, ev->min_len);
 	if (!data)
 		return;
-- 
2.35.1

