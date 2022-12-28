Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5CD657743
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 14:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiL1NhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 08:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiL1Ngo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 08:36:44 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B24DF5BE;
        Wed, 28 Dec 2022 05:36:43 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jo4so38419452ejb.7;
        Wed, 28 Dec 2022 05:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y+w5TwnAIJB6W6RWk0dufhbGDA9p9yyE6P/ljgdLyic=;
        b=bF8RnDFPQVshmuFhqMhkAfBhRcl50G89tS2g1VRrHnk9cCuh4C3GM/DWXDr+KRFOPP
         znqswxkZ6CPT2fxdj1jAXmJ9AwT7orPvGcqFgl8qKWbcKwhq2N0USl1iInZSb/3IXS/C
         vlu9RJdTvH3Bu8JVt2j0jtOXmRR4h6S20hVY61AspZ2aH/rZKaLgsAJa5Vpy6W9u9z7q
         pNt/a59rv3foMZM3XxQ6A/SOh8pPV5o5jQCqLLaNlQTfvYCiZ3TcNJUptLoS2BxBRyey
         PBxqbV+lgTzo3zV8qTQzCwVpA2aSXzrYBg6bkoZjsagQT1jSODjH4X15bulsVxflb6Uu
         KQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y+w5TwnAIJB6W6RWk0dufhbGDA9p9yyE6P/ljgdLyic=;
        b=Dcn/ZlScDuLs725MkHCcfXXy1+u37zYjdMSTuOqzsC1PwVXEmINeAZzrRYZ+h0tWpn
         y2RcfPrP01+zyxrE9teYbvWz4jojA3WKniJQUjuKVtYbocOTqwm39jlQKlRj1I6e3/Ih
         Q36oSrmTj0wmVtOAy6CcLZUhm039MVgS4CS6CxniNXoiRG6bF7MHwl/n1tvYkPIAY/Ba
         vyMk2YryUUYDFnIo+0K1QPEJ9wsq/PXGtl3a2fgOnEkByyRI10Wo3tpZRsLkzV8tVbOE
         y74afSfVgfS5V6Vr69R/aFl7Voq63yDzVPTOmUQX8lYWIdJH7tftS7bVBE7zF/zZTttL
         A55Q==
X-Gm-Message-State: AFqh2krhisBquHHMDKxuaIACR8SlTr3X02wmXZodTvb92wS3IRO08NnA
        JVCQIhSgri6M++9K1p53zqDHSGQF2ck=
X-Google-Smtp-Source: AMrXdXuwHz14OTEMBZHkRZBLykO9NhRXqbTRM9y5xCwgQjo5mXQva77u1S5UlDGNX+3FRgTW9hRNMQ==
X-Received: by 2002:a17:906:c0ce:b0:7ad:d7a4:4346 with SMTP id bn14-20020a170906c0ce00b007add7a44346mr27381367ejb.66.1672234601607;
        Wed, 28 Dec 2022 05:36:41 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b830-5100-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:b830:5100:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id g3-20020a170906538300b0082535e2da13sm7450475ejo.6.2022.12.28.05.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 05:36:41 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        tehuang@realtek.com, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 3/4] rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
Date:   Wed, 28 Dec 2022 14:35:46 +0100
Message-Id: <20221228133547.633797-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
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

