Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574184DD20A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 01:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiCRAvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 20:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiCRAvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 20:51:45 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCED13DB61;
        Thu, 17 Mar 2022 17:50:27 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so5898455wme.5;
        Thu, 17 Mar 2022 17:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pMEbKBsMpapDd8TCjE4RHFawECGaW/7eNS3lLK39RM=;
        b=nurmfdO1iMIrBTlsO7SIBEuIZr5DueNEiSytzbs9NuL2KOS/DHR/ihWYxPNIKIvIos
         qE2q38W5m0BtJEBxcRlYheiXOLooMSQf3rokqWtNO0i6qVOpzfADGXKZBGPZySVHe3xP
         Os+26lqEw08MMVC4YINaAGUl0uGzucz7Wv1/MCy7vztqDnrqsPSVcHjEeVNpZoXZosEE
         JO4gQ2RBB9Y+gIvpzQkIhFQ9T1ar5IgFM1rwDrPwR7PUE2cmGK91R6rK/Z3DNR4i0eLn
         mmlgroZmqLPbYTueAZnwLINL5LYxYwTYE94eBxiT7Vz1fP6DMhAwsxFirkXj8IrsEHaR
         zLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pMEbKBsMpapDd8TCjE4RHFawECGaW/7eNS3lLK39RM=;
        b=35mzEG0vRlI1VCFqPJu6Y1Qfn4fWmyUV1bUOWXVuQ9hzON9UctFBAeHpo2cZTStc8X
         FI0OoFGhodLf2bOaz6MieEHvVaNU9eKAG6DUsI3wDg5mtO2r160uOUgTy3B69UKL+zGf
         JSJD+Wpdmxf8l/FDU0n1vR7bh3DStrV/zeeWJWLaVzlI1llAQp7QtvWwutIqVJ61piLw
         B4XqgkD2cKpqPyEOdaD7kqZ9GTj9XJnK7tkxX16aJmIe2oHfjINdaHjSdDugJgJEgq88
         6zP1KRK73wiGmFZt7XYF7xzEV5/mxL146irTn0c49bg19jNS/i3wO/x+jgH+5/JE9wt8
         Gktg==
X-Gm-Message-State: AOAM533j8J2h2RA3i9iGHwgN8eWJ+A3GuqOj/KcD8w1aRZAmYfcI9ko2
        IscVGG7DYxgdHxNlveiUbJY=
X-Google-Smtp-Source: ABdhPJxlOL4MExEm3h26Y4McVA9a+lQbSOcpch5+/PntdcTOqCOFkKirk/UG1u3K3uaNw444o89q6g==
X-Received: by 2002:a05:600c:a4b:b0:37b:ea2b:5583 with SMTP id c11-20020a05600c0a4b00b0037bea2b5583mr14211291wmq.139.1647564625886;
        Thu, 17 Mar 2022 17:50:25 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n65-20020a1c2744000000b003862bfb509bsm9483720wmn.46.2022.03.17.17.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 17:50:25 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Chris Snook <chris.snook@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gatis Peisenieks <gatis@mikrotik.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] atl1c: remove redundant assignment to variable size
Date:   Fri, 18 Mar 2022 00:50:21 +0000
Message-Id: <20220318005021.82073-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable sie is being assigned a value that is never read. The
The assignment is redundant and can be removed.

Cleans up clang scan build warning:
drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1054:22: warning:
Although the value stored to 'size' is used in the enclosing
expression, the value is never actually read from 'size'
[deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index f50604f3e541..49459397993e 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1051,7 +1051,7 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 	 * each ring/block may need up to 8 bytes for alignment, hence the
 	 * additional bytes tacked onto the end.
 	 */
-	ring_header->size = size =
+	ring_header->size =
 		sizeof(struct atl1c_tpd_desc) * tpd_ring->count * tqc +
 		sizeof(struct atl1c_rx_free_desc) * rfd_ring->count * rqc +
 		sizeof(struct atl1c_recv_ret_status) * rfd_ring->count * rqc +
-- 
2.35.1

