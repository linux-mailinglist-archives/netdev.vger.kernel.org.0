Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42DA3E1840
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 17:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242256AbhHEPju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 11:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241840AbhHEPjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 11:39:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED049C061765;
        Thu,  5 Aug 2021 08:39:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so15722209pjb.3;
        Thu, 05 Aug 2021 08:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5vBIrdt8B8CVa9oETvI/wFhOCaIABa5EmEBz4zWZ01I=;
        b=Gg6667v/ufxR+ZJaa1GECyIPiUAgnOnIHtmOWBZkrSlCb/f29ngyB/Y5YYjDO1b3zN
         vOr0+vQUEhKQw3YDnTttWdS7WkkIV2K2ggxxOp0g0HAMXB6DTpqDBm7Rd8xIvEq8z1Vr
         +nL45S2Q9gt3ZsnBXUroCx1LZm4/OmcfXAjuBc1WsU9hYUBsh/KuowOhuoDouAozO23Q
         bNJxQir0bF8ekbmMGDXMxFoy3XU3K6mmPms56dKPNOQq2q6OAEFdTuYOTn53X1YnpSO+
         Ic7LyGTKafpb4w9Gx8nLuXoW4FwpguvakzmZg5HiI/9hWi0OMNpbL7ZBen57OhmY6wte
         0Pyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5vBIrdt8B8CVa9oETvI/wFhOCaIABa5EmEBz4zWZ01I=;
        b=rupzMTPg4wTGstpifztfR2ScxRk2M1Ii/Y9gys3jnhviKyVpW7IJp2gJwQEC15n//q
         iecM4yu4KWaXZNxdLP6ncMBCepqPACgmAOLjA+mnk3FeVwaHZW/GpBB9rTYbi+sXQtWG
         2mYGpUZY7wjqdI+Va6rVvyt+3mAkixb8s5CBHQbPtV2nMg3qWnZfiVk8YxYUt96vkOU1
         JzdgQCmqCbzM5B9hlbDjOGLT6TQOf/xLwIg5gaWyFLs6hbLzE+5UOC8X1Q56DhmWUKDm
         EosP577l4V7PRM993TMIJPM4ho/bVwpU8QhPcKNrIxT4FW84VPoD52BXuiHawQyuFz+J
         yHDw==
X-Gm-Message-State: AOAM532D0eYnGO7Ewn3woPJvh0hgnY87SI8+O4v0xaIhyVqNosExL0ha
        iVOG6kRC6NvA71Bt8XvF3fs=
X-Google-Smtp-Source: ABdhPJzf3lTIGiMS4P/exM38/Nyj0q06ZBOyeQapWim+xLd79Q9eNN7cBIDMLwGU0eieDdUMrsVbNw==
X-Received: by 2002:a62:bd15:0:b029:31c:a584:5f97 with SMTP id a21-20020a62bd150000b029031ca5845f97mr5935776pff.33.1628177966550;
        Thu, 05 Aug 2021 08:39:26 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.81])
        by smtp.gmail.com with ESMTPSA id p53sm7222242pfw.143.2021.08.05.08.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 08:39:26 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()
Date:   Thu,  5 Aug 2021 08:38:53 -0700
Message-Id: <20210805153854.154066-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kzalloc() is used to allocate memory for cd->detectors, and if it fails,
channel_detector_exit() behind the label fail will be called:
  channel_detector_exit(dpd, cd);

In channel_detector_exit(), cd->detectors is dereferenced through:
  struct pri_detector *de = cd->detectors[i];

To fix this possible null-pointer dereference, check cd->detectors before 
the for loop to dereference cd->detectors. 

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 80390495ea25..75cb53a3ec15 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -183,10 +183,12 @@ static void channel_detector_exit(struct dfs_pattern_detector *dpd,
 	if (cd == NULL)
 		return;
 	list_del(&cd->head);
-	for (i = 0; i < dpd->num_radar_types; i++) {
-		struct pri_detector *de = cd->detectors[i];
-		if (de != NULL)
-			de->exit(de);
+	if (cd->detectors) {
+		for (i = 0; i < dpd->num_radar_types; i++) {
+			struct pri_detector *de = cd->detectors[i];
+			if (de != NULL)
+				de->exit(de);
+		}
 	}
 	kfree(cd->detectors);
 	kfree(cd);
-- 
2.25.1

