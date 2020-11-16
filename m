Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2EA2B3B79
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 03:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgKPCcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 21:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgKPCcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 21:32:17 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9343FC0613CF;
        Sun, 15 Nov 2020 18:32:17 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id i13so3554467oou.11;
        Sun, 15 Nov 2020 18:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aAYf/mSH8NjjlOSQgsUeCy8MchLu8n4Ad1F6VWZiQPg=;
        b=sCMXnEgVT+rPDz8VpU15G0pZ2pNHOibHppfZQdpQoqUw98PrYf3SHyus6ScF3qm4Qr
         yTmc0JUfUdPD63mK5F7YguPVC6u1M8kZsadei6QCQrCNQaOwwkfKK3A0KyWW049yAKjR
         UBb9afjIpaX6s86E2CdG6jpckHJgzilkdPQSJOIqsLBwHPi1SIIrHqpRZ+6/wXMWwDff
         JhYJ/pJ8XfJbTCC5kfK+aLx4msoFYGQB9K1A9+n/fUhbTF3Fib/6b0U3vhFaHn47fW3U
         z3Hn/18H4PbWTSM5UgeYmNGtvJ/OeLqCsKc39reuNTG5KNKh8cwNbczsY3Q4feMEIG2g
         f++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aAYf/mSH8NjjlOSQgsUeCy8MchLu8n4Ad1F6VWZiQPg=;
        b=aKrr/ac1K8U+m2+/uyFuHB7ky1jHWDOMwzt9pVjcwQXIP9MHIu1hCKD7JTh60YX1Ik
         RPzU4H4ZSzcmoJ85pz8mHfaqD4B9FaCKS1nvIoS4f1pAcgZZfP0/T2qbWGtwqZYUpeVx
         By11XS+l6jS713dWHE0tmUd/yCURVuZmyWiUOYxK101rVobTeyVDRW5F/JSGLdBOuZa1
         YQKEuY79gHcbawyCut7ZAAnUARBK4XfqbEMBK6YO0CtTCuYSF3s8Was/ejHryfOy/Bk+
         FmJ6LInbmZZChbvfAQUWPVttZolDuZSWi4dXr8tPFd+RgownuIbEAVxNSRnZ9Rf2J/CW
         8DGQ==
X-Gm-Message-State: AOAM530HzIi65bM34+lRTUz2oYaede4JSS5E1kNhLKi7wNdBpF4wMP0J
        DQH5fQFmNVMZHiPh5fFEIn0GH4PZr52VmQ==
X-Google-Smtp-Source: ABdhPJykWFdlitfTBl2PNx0gTwFcqspzv1if+gLUFJg1SmpzQUGsNLMX0DSysA55lWSrCkBwEyjJqw==
X-Received: by 2002:a4a:e5ce:: with SMTP id r14mr8966114oov.11.1605493936661;
        Sun, 15 Nov 2020 18:32:16 -0800 (PST)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id w18sm4156080otl.38.2020.11.15.18.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 18:32:14 -0800 (PST)
From:   Tom Seewald <tseewald@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Seewald <tseewald@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH] cxbgb4: Fix build failure when CHELSIO_TLS_DEVICE=n
Date:   Sun, 15 Nov 2020 20:31:40 -0600
Message-Id: <20201116023140.28975-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
building the kernel with CHELSIO_T4=y and CHELSIO_TLS_DEVICE=n results
in the following error:

ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in function
`cxgb_select_queue':
cxgb4_main.c:(.text+0x2dac): undefined reference to `tls_validate_xmit_skb'

This is caused by cxgb_select_queue() calling cxgb4_is_ktls_skb() without
checking if CHELSIO_TLS_DEVICE=y. Fix this by calling cxgb4_is_ktls_skb()
only when this config option is enabled.

Fixes: 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7fd264a6d085..8e8783afd6df 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1176,7 +1176,9 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
 		txq = netdev_pick_tx(dev, skb, sb_dev);
 		if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
 		    skb->encapsulation ||
-		    cxgb4_is_ktls_skb(skb) ||
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
+		cxgb4_is_ktls_skb(skb) ||
+#endif /* CHELSIO_TLS_DEVICE */
 		    (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
 			txq = txq % pi->nqsets;
 
-- 
2.20.1

