Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9A25B5549
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiILHYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiILHXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:23:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2FD31378;
        Mon, 12 Sep 2022 00:21:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so11446066pjq.3;
        Mon, 12 Sep 2022 00:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=5dtqxG1adEwAkwxzFfPz2UY5hEcWjHXC1xnhnKsqtNs=;
        b=JSnp12K1bSNgmp+NodJK98vY0MXd9zjMqzUCEV/7Zu5q0JJ0rILUBjyL/aoNMrAJaX
         6u1lDGufSOlUsmGlMzXCAFa68Rj7DIbYyf6dg7m//EyWS4fJctDywqqiFg6Cp9fC8UN3
         ZkDqxQGojGtcxcMkQbvaf9XGbw7QdMrmnB6IFiU8/uQ7KDGw7CYgaUMSpABqegMOtB6X
         c8JB/NTggLS1oH/WDf6Yp/A75sXgzpLlTWWSY4g5L9vbUAXMcb8TrJ06GvqqkethJu/j
         IIusKxUI9lXTtWjsTPgRkLW7hYZjw6pwXY2pS7+9EkABea+8oZaQii67LC4LNYf+thPv
         9aTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=5dtqxG1adEwAkwxzFfPz2UY5hEcWjHXC1xnhnKsqtNs=;
        b=uyfXRbX8g2/kOYeMWkTaOWIHJK9ZmVUS5lg/BxS4lwD1USI7tGcdGhwXpKqxwfEKyC
         tfIGrvar/Ib+mnQ+BdusT2APwQMX9/mj5iYa3Iui6kIujWfakWa8WQCatpUy/EvBShpz
         4OxLFnr2gWufxoT6ziaSOcBLc9pfAKUsqYeiUZKse/xuMG2eBW3UmS7RkOdn2aSlrl+c
         m/YbfRrDXoeuUg1BGdVg+Enb7KXJ0jNrki/pAQqi6Bvs47PVV11Gqo155PKQq95qNpNZ
         1cCpq8stwEN5CVFbMsm7j/NxSfdVDoP8vEWHoT3RIPyntAtRDDAM6+Q0cCuC8aH8PQkk
         Njag==
X-Gm-Message-State: ACgBeo2OSfjUMpZCmK7wmqooclg0tE9qhuW70YuaBjEXTaZElTdzlYY8
        9xZrcYpQVRBVqjxCUyy9Un4=
X-Google-Smtp-Source: AA6agR5FspMLLkInv03H8vC7TD75fHHvT2tTEjaNRJ+OByX7F0HXR5R8r6lvUy/nc2yaFBgP66cTfw==
X-Received: by 2002:a17:90b:3ec2:b0:202:b123:29cc with SMTP id rm2-20020a17090b3ec200b00202b12329ccmr9744176pjb.167.1662967265366;
        Mon, 12 Sep 2022 00:21:05 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g6-20020a17090a4b0600b001eee8998f2esm4444442pjh.17.2022.09.12.00.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 00:21:04 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.panda@zte.com.cn
To:     varkabhadram@gmail.com
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xu Panda <xu.panda@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ieee802154: cc2520: remove the unneeded result variable
Date:   Mon, 12 Sep 2022 07:20:42 +0000
Message-Id: <20220912072041.16873-1-xu.panda@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

Return the value cc2520_write_register() directly instead of storing it in
another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
---
 drivers/net/ieee802154/cc2520.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index c69b87d3837d..abe331c795df 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -632,7 +632,6 @@ static int
 cc2520_set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 {
        struct cc2520_private *priv = hw->priv;
-       int ret;

        dev_dbg(&priv->spi->dev, "trying to set channel\n");

@@ -640,10 +639,8 @@ cc2520_set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
        WARN_ON(channel < CC2520_MINCHANNEL);
        WARN_ON(channel > CC2520_MAXCHANNEL);

-       ret = cc2520_write_register(priv, CC2520_FREQCTRL,
-                                   11 + 5 * (channel - 11));
-
-       return ret;
+       return cc2520_write_register(priv, CC2520_FREQCTRL,
+                                    11 + 5 * (channel - 11));
 }

 static int
-- 
2.15.2

