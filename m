Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB10374EB2
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 06:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhEFEuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 00:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbhEFEuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 00:50:10 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE04C061574;
        Wed,  5 May 2021 21:48:46 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s22so3876583pgk.6;
        Wed, 05 May 2021 21:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Bfc9JP5zoXMM7gbLhdJYwBT8oU4E4OBgrsMN4XIwE7U=;
        b=Q5wFMoN+uHBxx4y4Qy716ssNmfDuvM99TKZlEafjz1vsYaCu7+ukOtxsLsEVt0xrqR
         bMBxtL+P/2DHsbb6YdXJODtL6yNpGPh2fbv8LXQivpEogNr9Epb760yE2MglhJKtkJ3w
         96y0xlEgMMLjmdqDd/6BHpll2nCNsPPUEyDalxj7EeDpSsN6C0U7+BXw5cIb/OFsOvqP
         +Cf8ZSZ8CIQn9JBjULLKTtixIpdSvFemX64GwojmKi8HNQgTWGAydnKWI+PxfCjoDOKP
         eTRfTj7xuKMueNlEjHU6EF/Wk+dU6Pi8El4nPLKt/gfCEKAIBIeL1Ei8+5GmxTO+4sXj
         SP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Bfc9JP5zoXMM7gbLhdJYwBT8oU4E4OBgrsMN4XIwE7U=;
        b=FfE0LX+wA7UyOdehOe7zBZjjXcxELcXY8e/hRlYxOn1DESuzROAiHVkd+LZaQvchln
         4BF8WwVdQWbxMpNncKG7/bWmYYDJ2Kv3WbqeP4q93fawxNZfbM+A2Hyrc561/k8FyBqW
         Q4A7hSJpN5ASqNTuxtXwEYAF6rS3s1Iy5daLxrDUFyhb1xu3hk2ruLxto6bd0iROLcGV
         av3A9nPG4lanfcejCkUsIfP5g7PBd8o7akzgBooALYmK5F9l3jUeTtMwmLQuKnoCssSa
         Q32hCt6VCLxlsU2a2279Pz4CnBLJguLah3BH0dB1YOa6S/i1uvRcH/2yIMF+anCpSRBm
         EkLA==
X-Gm-Message-State: AOAM532JrViGMq4AQfH3lAU3zPEnGgrxS5uuOuG/ykknqY3/mlKZcmm1
        jXXbFLQcO+diWJdvIjtaD9E=
X-Google-Smtp-Source: ABdhPJxtrsrNO5e8qBSzoGHk46K1H0Gcx/Co/EiJYV4JvL62L0WLruvhcTcoD6PG18eJ+v5/mq+1SA==
X-Received: by 2002:a65:5a4d:: with SMTP id z13mr2402077pgs.4.1620276525792;
        Wed, 05 May 2021 21:48:45 -0700 (PDT)
Received: from user ([2001:4490:4409:27b0:f9dc:322b:84de:6680])
        by smtp.gmail.com with ESMTPSA id ch14sm765269pjb.55.2021.05.05.21.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 21:48:45 -0700 (PDT)
Date:   Thu, 6 May 2021 10:18:38 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     dsd@gentoo.org, kune@deine-taler.de, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] net: wireless: zydas: Prefer pr_err over printk error msg
Message-ID: <20210506044838.GA7260@user>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In zd_usb.c usb_init we can prefer pr_err() over printk KERN_ERR
log level.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 5c4cd0e1adeb..a7ceef10bf6a 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1544,14 +1544,14 @@ static int __init usb_init(void)

 	zd_workqueue = create_singlethread_workqueue(driver.name);
 	if (zd_workqueue == NULL) {
-		printk(KERN_ERR "%s couldn't create workqueue\n", driver.name);
+		pr_err("%s couldn't create workqueue\n", driver.name);
 		return -ENOMEM;
 	}

 	r = usb_register(&driver);
 	if (r) {
 		destroy_workqueue(zd_workqueue);
-		printk(KERN_ERR "%s usb_register() failed. Error number %d\n",
+		pr_err("%s usb_register() failed. Error number %d\n",
 		       driver.name, r);
 		return r;
 	}
--
2.25.1

