Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8F45B795C
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiIMS0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiIMSZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:25:39 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EBA659EA
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 10:42:28 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id az24-20020a05600c601800b003a842e4983cso10031932wmb.0
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 10:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=XWi3vvHiUqJXCMHut9LqX+J95oZ0olTscmO96FreQ4s=;
        b=rkXRdO9ONLQfsImq6bcaY+BN48zK9Kb5jsxoYd3cf0w50EhOd32X7+REX9bHy0/Ult
         wdB374vMMX7Hv/IAaL5aowszLiQ5mGn4hD3j1Tcw8ZXHinXY8qp3wAUOK3vdgWtErc5w
         hDSOiGPNuxO5nMsM3tUBYsy3LizfPd6hnCvREt3SZk3kd5moNt80b5aIEPHgksKFsRhE
         PueSHFHYsHLMjieGRaMv83g660OOkscrOa0yO3iCZjD/5Ox6J0+Fmc6yPX65gewT+osq
         GGI0EEr1jyt0CoDCfZlBWPMLNgkTAvM3waMmEZcTb1po7ObU46YtjcpxMfrG1/C0mRUI
         zaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=XWi3vvHiUqJXCMHut9LqX+J95oZ0olTscmO96FreQ4s=;
        b=pSijfAmMSn3Nih3zXeAZTDO6thXEDt4EpEWn90NwLeMHsiUV586fOeM+a+7vtJddH2
         4L131ebcEfCuhX5VeFqG6MaAA8UfRs4Z57g6rhA1GPMALnGr0xVRKaTBkhPArHC2YDhd
         dWOP14mDjelwPQraVUMEP5zEK3WQ5dit5XSXIDWyckxwrTXrsirpE/8+ZsoBp96Kgq2g
         +BtmuOFg12VIrRuRlcUuHffQRW8Gm6VzO9pBFPu6WRqplLvcg0eMdLpVzHWXoVsSdyTE
         iyBnDl7B+zvq7dMfNNljkH4ubGNBpy6NlHcM8DXgID0rT2vR0vM72PTDb+ecA8JkNCQK
         adwg==
X-Gm-Message-State: ACgBeo3baAjkgDR+ykmH5zl7czA6564VD95Fr+GXBAs8qbNkf+jGyUnn
        nfQ25MUvHme3BBKE8R5dzlHoLFIP1JJpAw==
X-Google-Smtp-Source: AA6agR7QMHbPQzJLbUoPypG9Ka4uZg6nA1r9gxBcXI1yj0J/2GKQQdEligpb+PQWilrxFZ8f04Oc0g==
X-Received: by 2002:a05:600c:3b2a:b0:3b4:8300:593 with SMTP id m42-20020a05600c3b2a00b003b483000593mr294252wms.129.1663090946592;
        Tue, 13 Sep 2022 10:42:26 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id t6-20020a5d6906000000b00225239d9265sm11044572wru.74.2022.09.13.10.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 10:42:26 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     loic.poulain@linaro.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, bryan.odonoghue@linaro.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] wcn36xx: Add RX frame SNR as a source of system entropy
Date:   Tue, 13 Sep 2022 18:42:24 +0100
Message-Id: <20220913174224.1399480-1-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The signal-to-noise-ratio of a received frame is a representation of noise
in a given received frame.

RSSI - received signal strength indication can appear pretty static
frame-to-frame but noise will "bounce around" more depending on the EM
environment, temperature or placement of obstacles between the transmitter
and receiver.

Other WiFi drivers offer up the noise component of the FFT as an entropy
source for the random pool i.e.

Commit: 2aa56cca3571 ("ath9k: Mix the received FFT bins to the random pool")

I attended Jason's talk on sources of randomness at Plumbers and it occured
to me that SNR is a reasonable candidate to add.

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 8da3955995b6e..f3b77d7ffebe4 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -16,6 +16,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/random.h>
 #include "txrx.h"
 
 static inline int get_rssi0(struct wcn36xx_rx_bd *bd)
@@ -297,6 +298,8 @@ static void wcn36xx_update_survey(struct wcn36xx *wcn, int rssi, int snr,
 	wcn->chan_survey[idx].rssi = rssi;
 	wcn->chan_survey[idx].snr = snr;
 	spin_unlock(&wcn->survey_lock);
+
+	add_device_randomness(&snr, sizeof(int));
 }
 
 int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
-- 
2.37.3

