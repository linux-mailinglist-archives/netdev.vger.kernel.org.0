Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6334BC92A
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 16:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242596AbiBSP3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 10:29:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242562AbiBSP3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 10:29:44 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A001A5D642;
        Sat, 19 Feb 2022 07:29:23 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id y16so2899763pjt.0;
        Sat, 19 Feb 2022 07:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=47NPgrzp8pEwO3JsAuNGK/2TmTtZE2oK4TLe+eXt24k=;
        b=KeYxSrOe987fsRSERSCLS2pCJEfmxfA1hjiLW6F6vJjT5JHKBDfucKgOdoVB4d4tu1
         uyooDnUVCGKRNM8r1PNl8vv1Xp2yFXdu+/1dfsenW/IJbtsQGxGsNWVrKUTHywQgBPjG
         /je/SzpLqbszUEFF5tNH7COeD/ukvk/MSGbEv6mM5Ata6iG87syC9RDp9S65O7iWLl6/
         sSjzYZqc/Hzc1jdrzc1QS3Ip1nRZsp7nJv2ef52qHqp24/U1UDKQJtHuULXcExAcb2Qw
         wcme+Ws+OsvBL040g86218zfnOtpRw5l716pZ4U0lIwkyP0aS8k3Q9q5lTJUUWtZ2Wiw
         pGzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=47NPgrzp8pEwO3JsAuNGK/2TmTtZE2oK4TLe+eXt24k=;
        b=4/52kBYmpHmppVCT8x4ZYrurPR+aRbzBrNvxM196Z9keAOQb7fKg5CWPQH4sQmN7X8
         YhUJ+bEpLBbnPAJVWqn8xhgZ03lWpjAGP1z+LSw1zrIwn7A7S1LhJXkUyDPU1q8zbTmk
         69usXF0umgSBXI4fxoBOr0DU6JBFI0Q5n2s+hq81MK5Gol1hRR1rhpK632dQ+bRYvOfG
         XbSSd4CdkhoOKlfhUHvp9DMyoO0d/4DFZLQyAkoSY/UpVLr3WjSK8RGvPt1mAn9uwz7j
         Qz+lqnYnIHlYlmeF4XbArk+jqzUfBd+WFCoAPEW0/lsvG60noxK0GcSXr6HFdVDMP9iL
         rdBw==
X-Gm-Message-State: AOAM530dQ2hq4fDhMD1v7yAmk/9jriLCcTAi6N8JunaXUplSkeU5/7vT
        fqlsL5VuEnwetyEQUmhwL/k=
X-Google-Smtp-Source: ABdhPJzYu0ULlV89DL3+dcsS6J6zetu2gCBCzFnC5q8suSdnE3Nuud/LQanfZECxtBxjaAtYC+qhNw==
X-Received: by 2002:a17:902:ce83:b0:14f:2c78:3810 with SMTP id f3-20020a170902ce8300b0014f2c783810mr11668929plg.7.1645284563079;
        Sat, 19 Feb 2022 07:29:23 -0800 (PST)
Received: from localhost.localdomain ([2405:201:9005:88cd:46e0:823b:7e8c:4cf1])
        by smtp.gmail.com with ESMTPSA id g5sm6800354pfv.22.2022.02.19.07.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 07:29:22 -0800 (PST)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     loic.poulain@linaro.org, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        ryan.odonoghue@linaro.org
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev,
        "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] wcn36xx: Initialize channel to NULL inside wcn36xx_change_opchannel()
Date:   Sat, 19 Feb 2022 20:59:12 +0530
Message-Id: <20220219152912.93580-1-jrdr.linux@gmail.com>
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

From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>

Kernel test robot reported below warning ->
drivers/net/wireless/ath/wcn36xx/main.c:409:7: warning: Branch
condition evaluates to a garbage value
[clang-analyzer-core.uninitialized.Branch]

Also code walk indicates, if channel is not found in first band,
it will break the loop and instead of exit it will go ahead and
assign a garbage value in wcn->channel which looks like a bug.

Initialize channel with NULL should avoid this issue.

Fixes: 	d6f2746691cb ("wcn36xx: Track the band and channel we are tuned to")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 75661d449712..1a06eff07107 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -394,7 +394,7 @@ static void wcn36xx_change_opchannel(struct wcn36xx *wcn, int ch)
 	struct ieee80211_vif *vif = NULL;
 	struct wcn36xx_vif *tmp;
 	struct ieee80211_supported_band *band;
-	struct ieee80211_channel *channel;
+	struct ieee80211_channel *channel = NULL;
 	unsigned long flags;
 	int i, j;
 
-- 
2.25.1

