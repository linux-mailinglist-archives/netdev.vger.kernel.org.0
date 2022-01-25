Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E3549ACD9
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376664AbiAYHEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S248974AbiAYEDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 23:03:12 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57387C0613A0;
        Mon, 24 Jan 2022 16:44:09 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c190-20020a1c9ac7000000b0035081bc722dso394796wme.5;
        Mon, 24 Jan 2022 16:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fLRx9U/2NmB44pdLfJwKGSap2HFuUnZgoHSikvYyf1Y=;
        b=Uri3ZygruRiJrNQhOePq8oZkEEomTzM8IcTOvseIjxw6EGnuo4ouml6ZToHiWPeeCF
         9BF6aHgCHSxQqRmJn7Fz6eP5ybedfIMEqA0Cgiw837k6VqVPzFOqaXSTG8ETZut+juGG
         FcayrugHrMuu0XpBzU8b8NYycxZCnABQ44ZPddny/6d9x0b/6uxVcw+9aXj4NX8cQ0V5
         hVWo8mWoszhMdoJfvKdGHcltZVpE8s6V/XuxPFDs+BKS+JCJiGmH/twVLqtt9H/Xeujt
         jmiCuB7fQQAvPPk92/TW/t+F3D34u1txrJ/3MjbVXFj2YwQDH2vOXwrhc5qp2s7yI1tN
         K5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fLRx9U/2NmB44pdLfJwKGSap2HFuUnZgoHSikvYyf1Y=;
        b=2Lte37nn0Z6fISVIL6YG8PDsDogdoDxhvVik9jvodOJKxnughvn4p6bKfXHst8aS9y
         /cYU0N/QquR9B5t3URzwgMmniOmevuCNxN8c3P14lvlc46n6VY2Il+zlwOYcAzAgKm1l
         kbITloPdtEYGNQqgxWe8PYfa/6D9AZziSmn7oWnAWfW0ago1GUIGj1PeMhgMIDJ9s/7J
         JeO72ju2sjAMAlREbBgEWcYLktM6m5me3x5JgdWLWRiuLUQOSGZOSRxNNALKLuK2nkpy
         pWGDO2oYJjhDcBCeGK5jRwUulk6LZAoqWPaXM6tBhy5Ja6t6XABcsyaz32aYuxudWhaa
         BnEw==
X-Gm-Message-State: AOAM532KdzkZF344hZY2sHtFvRUTd8HScjg/KZjXsAqjckXhntagC8/+
        aaIo58lDjDszQnjnRk1yKSI=
X-Google-Smtp-Source: ABdhPJz5o+URFYf4JkJc3R99+zOF/mY6qpbpL6hjRWY5PsvVBvKIC7+1cAsO8rmcqD0Yawnz5WqATA==
X-Received: by 2002:a05:600c:35d0:: with SMTP id r16mr642530wmq.195.1643071447836;
        Mon, 24 Jan 2022 16:44:07 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id g20sm925194wmq.9.2022.01.24.16.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 16:44:07 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stable@vger.kernel.org
Subject: [PATCH] carl9170: fix missing bit-wise or operator for tx_params
Date:   Tue, 25 Jan 2022 00:44:06 +0000
Message-Id: <20220125004406.344422-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tx_params is being re-assigned with a new value and the
previous setting IEEE80211_HT_MCS_TX_RX_DIFF is being overwritten.
The assignment operator is incorrect, the original intent was to
bit-wise or the value in. Fix this by replacing the = operator
with |= instead.

Kudos to Christian Lamparter for suggesting the correct fix.

Fixes: fe8ee9ad80b2 ("carl9170: mac80211 glue and command interface")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: <Stable@vger.kernel.org>

---

V2: change subject line to match the correct fix, add in the
    missing | operator
---
 drivers/net/wireless/ath/carl9170/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 49f7ee1c912b..2208ec800482 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1914,7 +1914,7 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 		WARN_ON(!(tx_streams >= 1 && tx_streams <=
 			IEEE80211_HT_MCS_TX_MAX_STREAMS));
 
-		tx_params = (tx_streams - 1) <<
+		tx_params |= (tx_streams - 1) <<
 			    IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 
 		carl9170_band_2GHz.ht_cap.mcs.tx_params |= tx_params;
-- 
2.33.1

