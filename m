Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3E64B5F94
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiBOAxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:53:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiBOAw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:52:57 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454921480E6;
        Mon, 14 Feb 2022 16:52:07 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so699989pjh.3;
        Mon, 14 Feb 2022 16:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=01bC56qFJsVjURx/Tr2ye7FUvsx5sNM11LYNcVEw1gg=;
        b=XbPqRUYQjAUeiafOCx8XqdIZ0wtuqlQq7b0xaVb3Jh6Fygnj/LhGTzpO+zqXPb7Stb
         gRD6EI+a0hEJlAyTA9bdh1K0Ta9+IdbHegNvQXHUjW4ajraBu/mCMBNOl1BPRYtJFvTd
         TSvcyP7AAvPwi2laSIzAeuMQbvnl6OxMBlbe5rhHW1yFyDwmF9nSTsbcqYoPq220mdUk
         +UVMZo2L+uRCBuPDvbn4TtD8PCuvfENEAHBpKK2BP7dnkvyDUR4v4DqV8HtbJCYb8Xh7
         SsqhFApB1FfZtNDnOldy64QZ+Os+/PxgQelYLUJzeyr2kWX4OjNS8/dzhB+0rLU15jgA
         3R1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=01bC56qFJsVjURx/Tr2ye7FUvsx5sNM11LYNcVEw1gg=;
        b=NzrpAILy4Hp8gzm/sG5PVxY/AgxElhx2c42CfWSwRIDWOBhmQRTDi87mnVbp0LR94q
         Lc2Exau39JF4Jwb+7gHUPQfW421uwEwJrjURkMl17xx/dBx9t9QLAfCwhs/dp2RBWWDy
         tgNRLVT3uzvb4Ogdj6veKAkq6xchGYAQRm7tvWhhnOtBj1Eb34GBCy8Iq+P0e2OswvMD
         Xn1Mze/vRoUaSYUh5gw6eg2fT//tVkXKFCjAcFSNEri03GRi8ZG3OpEhZZgNUXiPWn30
         MJxQ1bwxC9XZVwep+eFMjzhL0bB45VjEHzjZHpnOnmYeN70FGgrbaNRWC9ecZabVIkcZ
         gv5Q==
X-Gm-Message-State: AOAM530n88TXd+wuTk2JFYlZb+q7HtX7GT5fn9cmgygiau2xcIg8Wj2P
        0N535kUKfoq71Qu7tanIczg=
X-Google-Smtp-Source: ABdhPJxctVE50fzyuBBKrfEMvIU7JAkzjHnNlGLyc1PdN1IK/dKLQySOggUkOtaMKT9U01p7GnJoPg==
X-Received: by 2002:a17:90a:760d:b0:1b5:5b63:d052 with SMTP id s13-20020a17090a760d00b001b55b63d052mr1649776pjk.24.1644886324794;
        Mon, 14 Feb 2022 16:52:04 -0800 (PST)
Received: from localhost.localdomain (192.243.120.247.16clouds.com. [192.243.120.247])
        by smtp.gmail.com with ESMTPSA id l12sm15003070pjq.57.2022.02.14.16.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 16:52:04 -0800 (PST)
From:   davidcomponentone@gmail.com
To:     jirislaby@kernel.org
Cc:     davidcomponentone@gmail.com, mickflemm@gmail.com,
        mcgrof@kernel.org, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ath5k: use swap() to make code cleaner
Date:   Tue, 15 Feb 2022 08:51:50 +0800
Message-Id: <2f993da5cb5d9fee93cedef852ca6eb2f9683ef0.1644839011.git.yang.guang5@zte.com.cn>
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
 drivers/net/wireless/ath/ath5k/phy.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 00f9e347d414..7fa7ba4952db 100644
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
+				sort(sort[j], sort[j - 1]);
 			}
 		}
 	}
-- 
2.30.2

