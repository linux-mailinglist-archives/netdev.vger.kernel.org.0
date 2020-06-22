Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E4202E45
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 04:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgFVCVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 22:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgFVCVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 22:21:25 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0DEC061794;
        Sun, 21 Jun 2020 19:21:24 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b4so14213549qkn.11;
        Sun, 21 Jun 2020 19:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2YE9gPP5bCoYsurMhSnWjNJyyw00QRCWcTkQq56FnVc=;
        b=MQSC7+8JsP0pBgEDfwg/fziotB/jhsLxre1enkWA/0pRx1zhCDstPx14yHBQaoXS8a
         oX0K1DudDD9np+Is9tU4KA26xyO7Y5jFqafTkc/cRIOHyVENPPqZlZMoDhAD+OVktIDJ
         umRMU8Y+mQW9Rs2j4HnYLXOWqvOX0tf5Que/4fqMXcrdL/rwzD3bgCkdXjxTUKHvomAo
         qsozYHUFh+xN96kL732IPPZ8cRUnWPWEMhGa8UWvgmBEPrrxFjdxz/mRoKDcT1U4BrON
         GduWUle3hJF9qP6h19pfXOVrol8Oxjz+J/hQ4WFMs+SEk/7NVnI85CKOnIL/ZuF4il5c
         fjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2YE9gPP5bCoYsurMhSnWjNJyyw00QRCWcTkQq56FnVc=;
        b=VBYTY9gvzBx2Wa72aOyo+NyjWn8km9Ym8ce0s+VbOJFiBLLg4K4ET28MJ8hHGK78LZ
         vWiG/+XbOQA2iKkCq2SbMUYCwK4tYXFjqqoc0zDQFsBTM2bSyzl1sDvd+WbGqsgG2NdO
         rUYxScxSJ8jClue0hNACRQ7EreHpKiO68M38mTLfPUxp6QcIXwBCKVZEsqtQeKfxBN2p
         IKK304p9r1WkRn1sN9mvE86FFFOhsRgNVIHXg/PLh8GFH4+nACDZIstzw7vCmROX8vZE
         MxZkAxhtC/jK1QnC2Qpsd2dYvmhHy/hnF2amiCNo0BBakVcX3rUdHOHu9jFfw+AAurdN
         vD5g==
X-Gm-Message-State: AOAM530RAKeOqsN1BxjJMOIPJcHXzJPpe/1M9X7CVpyV9tfz9tfBlwKd
        cuSxin+F+FoDZBf6WU35PX44SmzBEBI=
X-Google-Smtp-Source: ABdhPJwNHNw6nIS3omBcZml67Q873TZx3jnZ7lv3uMLIkAAIla8hsj7jyCAk0Fkt8jZtevE5u8fBlg==
X-Received: by 2002:a05:620a:a1b:: with SMTP id i27mr7017238qka.429.1592792483901;
        Sun, 21 Jun 2020 19:21:23 -0700 (PDT)
Received: from buszk-y710.fios-router.home (pool-108-54-206-188.nycmny.fios.verizon.net. [108.54.206.188])
        by smtp.googlemail.com with ESMTPSA id f54sm1435295qte.76.2020.06.21.19.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 19:21:23 -0700 (PDT)
From:   Zekun Shen <bruceshenzk@gmail.com>
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ath10k: santity check for ep connectivity
Date:   Sun, 21 Jun 2020 22:20:54 -0400
Message-Id: <20200622022055.16028-1-bruceshenzk@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function ep_rx_complete is being called without NULL checking
in ath10k_htc_rx_completion_handler. Without such check, mal-
formed packet is able to cause jump to NULL.

ep->service_id seems a good candidate for sanity check as it is
used in usb.c.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 31df6dd04..e00794d97 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -450,6 +450,11 @@ void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 
 	ep = &htc->endpoint[eid];
 
+	if (ep->service_id == 0) {
+		ath10k_warn(ar, "HTC Rx: ep %d is not connect\n", eid);
+		goto out;
+	}
+
 	payload_len = __le16_to_cpu(hdr->len);
 
 	if (payload_len + sizeof(*hdr) > ATH10K_HTC_MAX_LEN) {
-- 
2.17.1

