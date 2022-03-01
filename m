Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD004C805E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 02:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiCABdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 20:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiCABdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 20:33:35 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0860F245AF;
        Mon, 28 Feb 2022 17:32:55 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id z66so11879205qke.10;
        Mon, 28 Feb 2022 17:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9JEn06hcww2L6NS4S3p4jO39Ct9x9lpXynd0qsWDBiA=;
        b=ooLMJfc6fgqPxZvdt2P1iN6fDeJda7eqKYC88DNkDtigehLPK04vGLcKYaIEcNWnol
         1z/ZNyUr+FHs/Jf1Nqru9j1ugBzU2M+kuZ3RxxdzKw+ZaE8lfOApbt+dSfM44nBWtqlF
         bS7DApyT+OfSYITA1ftjd9QnyR4S0fY9yBlbHdRdouLIadZfFGkKqqPEw3oZCOFGJe5N
         PDLA1hRe8DQVmdOqBv+j1MI5i/VnovsR9VsR53vCpHovS0gWK2QdSGFr+obDTZIRk9r+
         0iUGYqi9lyPIx2DR6zh3OoA4zWGYgUcu2qd2hOzwmJpu1CePifEq0lVA3EiZ6OwlpPH3
         YDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9JEn06hcww2L6NS4S3p4jO39Ct9x9lpXynd0qsWDBiA=;
        b=GKsXB9qjDqgp1X7co5aBrEAWXh+4LUyz1n9b7PbMDMRyvEoLky0jg92U1Xb1mVjCcn
         +7x2lijvEOR7vEr2b/QHurJmJpPqSWltQIYz3INiDFdAYTEQkt2GArXJpP5lb8XwCfXG
         gXmoKEXxUiStZ5UifRaErcK8to8FMG1csAdmLSStxDkiSBtYXQ6DksYRQ6hE0vid2TEr
         SYjXR+FsyqH4lGK1zbtnNmlHNOedH4SmcH7yCN5m5ybN9xuWtC2ubk+K7tp4ow2RDoPw
         44aLrfz1TL7LWg5Yqm/EYtpmPM8eleRLcbfw5lqIclfdyz5ftvgHC4XOYAgedBNAvWEN
         bYiw==
X-Gm-Message-State: AOAM533st4jJ3l5xfCUC1Em7dPNPYHzBROSDMuapZCea95woi+rsE3hR
        qCZ5qd52U7YTV8r5+SdQ3pk=
X-Google-Smtp-Source: ABdhPJzo0tWiorMvWcE9Vcd9FqDf7fgvFbLMLlJtG/G2wXt9rlQP2Mw+EG2A3+Gk1V8rJH1HWcjz2A==
X-Received: by 2002:a37:2791:0:b0:60d:d5a2:965e with SMTP id n139-20020a372791000000b0060dd5a2965emr12712941qkn.701.1646098374149;
        Mon, 28 Feb 2022 17:32:54 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y16-20020a05622a121000b002deaa0af9e2sm7937286qtx.49.2022.02.28.17.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 17:32:53 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lv Ruyi (CGEL ZTE)" <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ath11k: remove unneeded flush_workqueue
Date:   Tue,  1 Mar 2022 01:32:46 +0000
Message-Id: <20220301013246.2052570-1-lv.ruyi@zte.com.cn>
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

From: "Lv Ruyi (CGEL ZTE)" <lv.ruyi@zte.com.cn>

All work currently pending will be done first by calling destroy_workqueue,
so there is no need to flush it explicitly.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi (CGEL ZTE) <lv.ruyi@zte.com.cn>
---
 drivers/net/wireless/ath/ath11k/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 5d570a2cc2a5..71eb7d04c3bf 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1417,7 +1417,6 @@ EXPORT_SYMBOL(ath11k_core_deinit);
 
 void ath11k_core_free(struct ath11k_base *ab)
 {
-	flush_workqueue(ab->workqueue);
 	destroy_workqueue(ab->workqueue);
 
 	kfree(ab);
-- 
2.25.1

