Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01D8515DEA
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbiD3N7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbiD3N7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:59:51 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05B92A27F
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 06:56:29 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id h1so9073550pfv.12
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 06:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WgufQaaLw4AGY3k9tFBTfBHY9WLWQiFUEx4BNaq+0YQ=;
        b=Ph/lydrtzigd6xxDuN2bza1D0YA3FXowcmLJxM+sBEr1xwRrECW2Kuh4jJ3QJEf7zn
         O0vHSThUNBDsFVoGOGtQj9HXpM6y8p8hbggTJzJW9j81cpR42xvCildKnN+gytwCkLOu
         mmybZ5QuAYbYweVZaUmBXErqYoDq9wKTom4lt6oc8cWriBGIr2aO79rGJPgO5Hn6skjX
         E+qtpkTnibxhs/71DChj5t9fDzM/WKEFgsNDeM/FZw8/UfxJXZ8ENyBv4d98ufpf+gEV
         tzoOsPwf3sMevDgiHCKMkwrx4UMJXFwrFHYzu2a3eT8ejmwXoORZ1JOOg3TgXfGek3QU
         1yTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WgufQaaLw4AGY3k9tFBTfBHY9WLWQiFUEx4BNaq+0YQ=;
        b=PAg9A5z8xxJxmR0/oSzTkKSJHTKHJgtydpda87q2ueq5NxH+RIJJrGgsmuXEQIR2bn
         tZ1WxLMZ/QHeGKFoHkK2M+3o7kkB5MBpdAaMjGO+6qTNUNuj0iAEUI+/uaf49VfRdpfW
         Ghvjlu54bQhJCHmSFdrqFBGfmwty+G+WgrrIYgCKGIzgO+T6gdT0xGjYX42x77vuhtOT
         GjE/vPjflwBrPcS3OMHirUmWJi08XvzC9Kvlo/K6MAeSqIYQYmnErF+iUVq7BBTujqq2
         cH/F7Xr7mLmq1t9Y5CgeBwt6tKoZ/r+BgKEHQoHNKYfCXQfG+TO+VEWr3yJhBmkINVSb
         BcQA==
X-Gm-Message-State: AOAM532iyD1MVQ8KNhASwS4eyToZ/tXpOd0epquBUn9xFWt6aH/xgCWV
        jAxDO6uJuFbmias1R/Z71sYL8A+108c7ow==
X-Google-Smtp-Source: ABdhPJzADS3IpEslCNN93Vi0xpamqrmb9gtn2aRFV9JxjB4pHPYEesV6Oio9JNgCs/OlEASmBpVMHw==
X-Received: by 2002:a63:1252:0:b0:39d:aa7a:c6e1 with SMTP id 18-20020a631252000000b0039daa7ac6e1mr3207747pgs.436.1651326989159;
        Sat, 30 Apr 2022 06:56:29 -0700 (PDT)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id y5-20020a1709027c8500b0015e8d4eb2absm1496612pll.245.2022.04.30.06.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 06:56:28 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [net-next PATCH] amt: Use BIT macros instead of open codes
Date:   Sat, 30 Apr 2022 13:56:22 +0000
Message-Id: <20220430135622.103683-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace open code related to bit operation with BIT macros, which kernel
provided. This patch provides no functional change.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 drivers/net/amt.c | 2 +-
 include/net/amt.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 10455c9b9da0..76c1969a03f5 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -959,7 +959,7 @@ static void amt_req_work(struct work_struct *work)
 	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
 	spin_lock_bh(&amt->lock);
 out:
-	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
+	exp = min_t(u32, (1 * BIT(amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
 	spin_unlock_bh(&amt->lock);
 }
diff --git a/include/net/amt.h b/include/net/amt.h
index 7a4db8b903ee..d2fd76b0a424 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -354,7 +354,7 @@ struct amt_dev {
 #define AMT_MAX_GROUP		32
 #define AMT_MAX_SOURCE		128
 #define AMT_HSIZE_SHIFT		8
-#define AMT_HSIZE		(1 << AMT_HSIZE_SHIFT)
+#define AMT_HSIZE		BIT(AMT_HSIZE_SHIFT)
 
 #define AMT_DISCOVERY_TIMEOUT	5000
 #define AMT_INIT_REQ_TIMEOUT	1
-- 
2.25.1

