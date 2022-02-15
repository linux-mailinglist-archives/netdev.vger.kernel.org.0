Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2524F4B610B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 03:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiBOCcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 21:32:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiBOCcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 21:32:09 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D47B8229;
        Mon, 14 Feb 2022 18:32:00 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d187so32409000pfa.10;
        Mon, 14 Feb 2022 18:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j4cq8WbSXfddJgMANZwH/nJ8kmsADNbRNdzdz+vwvKY=;
        b=ZldomoZy8FmnREhMA+/Vxs6Hs7iLv5tIKGkjFHMd/48FKgoP1/A0VZWzhTGFD2LReA
         YOiMb3UF7cTjhORKA1e1ipV5Xp3cCr6ufdMAxHrtdAXXQ1OsmFwR1w2QTr1WVAx9gQnU
         DaRvl4b6Yz6q86OCYQ7tjj6YbFXNkbwiJNQF3tvJSCN9r+LK9FOYGCjrntElWB4OQtW+
         1Mn5KEMWkdc2kD0KvJkMqRIAmDbwYrNaOG93gs8bH3bIDm8wP9Bw7vfHU1EeIweyEEWQ
         9assBsCEZggiTrNLlLOOW8CjGUP3y+5Js/+/z4hCrQ3cmL8m93JWIpK8unLJ6eZnrYTt
         6hCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j4cq8WbSXfddJgMANZwH/nJ8kmsADNbRNdzdz+vwvKY=;
        b=YGRa2IlNndBiNuNU2b6KLO0YVE7716jnnqAHzuJJ26VaTuPl8T/HTximx0R+kw4PaK
         23BpDtWC029mRRYQumplgH/vRQHqJIoqqyzw2vAD0PYfmxfcXJOv4ybGvQdl+l+DkFAE
         aTNI4cET8rldRopHkxU8439b7uMBMYJpp0pbf1JSzsa9adlhwSRrUM9UQxPxorTInChv
         0JAcuvw7hUYo2VifdlYPhz7HEj9oCfzGzyQLy6JXCcy8+TYgcTk3v/eboBAeoc1iPEwV
         mFzhiBVOTP/3oLdCAR6IMbrfviHy9g9y8z0WW43qXZQ72+E8hMQ9MFTWw7e3+TDdw2wT
         A2aw==
X-Gm-Message-State: AOAM532D/e/JxuPzdikGtkKbYKhNlF4taWibsPZSEIMgVRbBGEPJtSLo
        c0A8B8YZGD1RM+NMJ1mnGi+VyVKfmBo=
X-Google-Smtp-Source: ABdhPJwam5vl9VxuRX0bnoQiBzazVvQFOp4eGbhYEETvjbBaljd0YSVg+eE+GGLzCe18dT7lTGdQWg==
X-Received: by 2002:a63:4650:: with SMTP id v16mr1748838pgk.155.1644892319958;
        Mon, 14 Feb 2022 18:31:59 -0800 (PST)
Received: from localhost.localdomain (192.243.120.247.16clouds.com. [192.243.120.247])
        by smtp.gmail.com with ESMTPSA id 16sm734606pgz.76.2022.02.14.18.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 18:31:59 -0800 (PST)
From:   davidcomponentone@gmail.com
To:     jirislaby@kernel.org
Cc:     davidcomponentone@gmail.com, mickflemm@gmail.com,
        mcgrof@kernel.org, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v2] ath5k: use swap() to make code cleaner
Date:   Tue, 15 Feb 2022 10:31:34 +0800
Message-Id: <b6931732c22b074413e63151b93cfcf3f70fcaa5.1644891799.git.yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
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

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
---
Changes from v1->v2:
- Fix the typo "sort" to "swap"

---
 drivers/net/wireless/ath/ath5k/phy.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 00f9e347d414..08dc12611f8d 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1562,16 +1562,13 @@ static s16
 ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
 {
 	s16 sort[ATH5K_NF_CAL_HIST_MAX];
-	s16 tmp;
 	int i, j;
 
 	memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
 	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
 		for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
 			if (sort[j] > sort[j - 1]) {
-				tmp = sort[j];
-				sort[j] = sort[j - 1];
-				sort[j - 1] = tmp;
+				swap(sort[j], sort[j - 1]);
 			}
 		}
 	}
-- 
2.30.2

