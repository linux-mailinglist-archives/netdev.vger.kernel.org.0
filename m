Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F02658CE3
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 13:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiL2Muv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 07:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbiL2MtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 07:49:17 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AF81277B;
        Thu, 29 Dec 2022 04:49:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id i15so26623811edf.2;
        Thu, 29 Dec 2022 04:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fg+vEqAErRjfJQS0/hInbwE16nRV7CNR4R99NQ21R+I=;
        b=LBTmQnMTbFUzmaX6mkw/x7IQVw3oGfTZGmV0KiQBv+9K0pNEwGXourydtFnItjyO9j
         o2USVnnOnMCN9JoM2ToKWa3BJrgDEbK/UzbBpsTWiYOK3efI05X5hAWOjgaijd4qEK0T
         M8Jsp1+6G3FwqXKFBSjJnN5M3KGT8MLq40/UKWTT2qoTKqXhfJBwxfgftZLfs8jv0orT
         Gec1nnqXfDKCF+RropCNwT7tTuzGkiEURVlbG1xdqRKw4+kbc0EBufjQ9YHWK3Svzv+A
         Mw0sHLmX/41ubzwZB17jrtlSX8dZ155SS/0TGdixS+6p8yN2TTx13m2Wb5CZCCzx+B6d
         TxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fg+vEqAErRjfJQS0/hInbwE16nRV7CNR4R99NQ21R+I=;
        b=vIMfFYYI1kndJ1qQaEKBysNyNSl5DJ0foQkv4mD9rGjeS9q6IulcKO0LaTKzIoqWLt
         3AUT4pKr1WaTDLvdM9y6LLwqCR5tX4gKL44aiq9T48Na5YXI8JZIgVqAy0F+bWCkm01n
         Rno3YcV40YIb4TJd6FWxm1oAjpVYdjl4yOOLu9qP1/7ISZR0pr5nVl9TEHtjuOCzEk9g
         bEOklNK4fapGSrYe7lFSIUIUt5ajoKQVM8mdUWgPS/6G5eDQuSouSDnfB2j6/nSAjBtB
         /PTPid1I5jXwwybxnoyw1urD5MCi7bSpNWzrp2HILXhEyh8CR3TV1hVNd+J+nCt2DWOa
         tnwQ==
X-Gm-Message-State: AFqh2koM7ij6gyExYkb9r8NsKK+C2SSRWqkV2RTbYUFI9muMJr0LNd0r
        OCMRGZefFiSlnNnjcTtbDvPGTpo/qPU=
X-Google-Smtp-Source: AMrXdXtIhIFj/fgwd5upKntEX0RHdhfJsgS2SRg/x+Ome4DVhMn3tycHMd0Ti92sQJks3pKNFZ4XZw==
X-Received: by 2002:a05:6402:3807:b0:47e:eb84:c598 with SMTP id es7-20020a056402380700b0047eeb84c598mr22161141edb.30.1672318154404;
        Thu, 29 Dec 2022 04:49:14 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7789-6e00-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7789:6e00::e63])
        by smtp.googlemail.com with ESMTPSA id b12-20020aa7dc0c000000b0046892e493dcsm8166299edu.26.2022.12.29.04.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 04:49:14 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 3/4] rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
Date:   Thu, 29 Dec 2022 13:48:44 +0100
Message-Id: <20221229124845.1155429-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
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

USB and (upcoming) SDIO support may sleep in the read/write handlers.
Make rtw_watch_dog_work() use rtw_iterate_vifs() to prevent "scheduling
while atomic" or "Voluntary context switch within RCU read-side
critical section!" warnings when accessing the registers using an SDIO
card (which is where this issue has been spotted in the real world but
it also affects USB cards).

Fixes: 78d5bf925f30 ("wifi: rtw88: iterate over vif/sta list non-atomically")
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 888427cf3bdf..b2e78737bd5d 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -241,8 +241,10 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	rtw_phy_dynamic_mechanism(rtwdev);
 
 	data.rtwdev = rtwdev;
-	/* use atomic version to avoid taking local->iflist_mtx mutex */
-	rtw_iterate_vifs_atomic(rtwdev, rtw_vif_watch_dog_iter, &data);
+	/* rtw_iterate_vifs internally uses an atomic iterator which is needed
+	 * to avoid taking local->iflist_mtx mutex
+	 */
+	rtw_iterate_vifs(rtwdev, rtw_vif_watch_dog_iter, &data);
 
 	/* fw supports only one station associated to enter lps, if there are
 	 * more than two stations associated to the AP, then we can not enter
-- 
2.39.0

