Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08A26619CD
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 22:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbjAHVOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 16:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbjAHVNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 16:13:37 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F4C6561;
        Sun,  8 Jan 2023 13:13:36 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id fy8so15549775ejc.13;
        Sun, 08 Jan 2023 13:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+ySspNK+qn7cGndVAzvLNa0iYoPa0lwfvSj5/ykqfE=;
        b=aL57deV61/F3g3uWw0izEm1oYWQVgQWiv/vyY4wQMGCcRmid3omVIVbY59xnzsVoDH
         oNI04p4s9XzIeCTcl6HEArKH6IduQvJITp0QsRm02joAOSEP8vZeV6uhUHrjWc4tUv/O
         FMtTU2DUgOTYK+hIc7uRnoWQ7N4K4F2uZqBaOQvSM6EyZu9NLqCx2Ivv+Lj874arFBTe
         n4Au4U0xtXpLabNKDdrq6q95fNHDYJfGSSaU1JZ7mEy1sZfRR1ZYfcvtNMZxYgbSU6L2
         Ghl7kWbSBExC3x2UpKRp8d5SknFp3L3YtMcbBUj4Sc1Edz+pDA5m/kedvSjn6o0Kvxzk
         VDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g+ySspNK+qn7cGndVAzvLNa0iYoPa0lwfvSj5/ykqfE=;
        b=wECyGPrhfQhxANR//DK4C97UUQMVIn6gkUG62ytQZU6Ycnz2fJD+qv5hEBBFvUGXxu
         GvB92lTrbtoW0HazMwlikk5k1wJBurT9UICEeNPGzssF66MmhayD4O+BE2TT7uLZeoTO
         YZ2EzZqgcOJgMed6SRlRi9eK6F6a8IkqdNQRzvmUuWyMz4Gnab7nzUa6Ldu5YmLVd5dM
         0/oPGNEiXY7aKElkQ5KiPvKKnJpcgode0TzGokZ//2zX8ZUL+/P8qdeFqZjcM6JD4UG/
         avD9tCWe9+pHfFNju5IM8rbWDmJ3XhBWKnpknoOdKlwSTI8ffB/GU/3I6LkaF5fzPxmQ
         Lu7w==
X-Gm-Message-State: AFqh2koiejhBO0pWQnbghf3L/m9HrebytizSyBSlBeElRN5cRlmaOB89
        iJUXxlTT65cnKW4zd/9E5vxkYIAWzn0=
X-Google-Smtp-Source: AMrXdXvBO3XwDFEFP4aiabThnEvPyilT+MavJrQn1g/XNUjnHinI+8H+5i6icO8X00OXk8r6ftT1TA==
X-Received: by 2002:a17:907:8b90:b0:84d:207d:c00c with SMTP id tb16-20020a1709078b9000b0084d207dc00cmr8882916ejc.25.1673212414365;
        Sun, 08 Jan 2023 13:13:34 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c485-2500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c485:2500::e63])
        by smtp.googlemail.com with ESMTPSA id x25-20020a170906b09900b0080345493023sm2847997ejy.167.2023.01.08.13.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 13:13:33 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 2/3] wifi: rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
Date:   Sun,  8 Jan 2023 22:13:23 +0100
Message-Id: <20230108211324.442823-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
References: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
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
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
v1 -> v2:
- no change

v2 -> v3:
- Added Ping-Ke's Reviewed-by (thank you!)
- Added Sascha's Tested-by (thank you!)
- added "wifi" prefix to the subject and reworded the title accordingly


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

