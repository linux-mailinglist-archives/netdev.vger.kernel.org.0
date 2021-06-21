Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCF93AEA71
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhFUNxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhFUNxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:53:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF6EC061574;
        Mon, 21 Jun 2021 06:51:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c15so8513563pls.13;
        Mon, 21 Jun 2021 06:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ib+t9lVmRc47tm7LsElU1TV26Vqw/r1cOdCfq04ZSQE=;
        b=VEE7fjWiDkmeD1XofkTGTv9lFoFTZM+iHn5Kn4Xx6Xa4uUg4bU76o7Yr8jZPmE8ls7
         8/Y4uzvUSXiFJIWAQ3TsCwfOpDp+8G9YUzC5bXKzvt6KrX7TsYNxl5jvHMnJT/fPeDqa
         R6Dgw7rbVcalfIRhaO98vo/0ZeR8M3MKOPVR4Rt8DnmBQZgXrftqjElGiAqfYmoSmYYj
         LYtH9/3MG8WT0Wkixx6PAjvYikoPh3MlUVk2LhiMnLMoLhrLF60l4HYHdkLk077D8sGA
         reM8DPhCoH9yQUVtwAPPKsvN+kAj15yOz3AyqET0VlPozhF9xBqjqyESIvAiGw8gWQ69
         s/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ib+t9lVmRc47tm7LsElU1TV26Vqw/r1cOdCfq04ZSQE=;
        b=VO/gLR1JOOcte6hOWjvUXFnAgiNYy4VcPaKEdXy4gQpoi8xwP8T2N1InEDOX4y0lEe
         O0yHJ/qLR/1CU5KMAO5A8oREnCA30XloSSGo2S8oq7HaUn1if6snPz4yVbtaWIWfPsp9
         Nvrag6x7SWN9hmgHga5n+kEhCijfnNW24WYO+rd0kyutzQtmMIu8j8BQTNSJNJjiYdGC
         MI4gQzJCRILwr5Y51mPopGuV5vzLiJs6WkB0mbJ0rntufQaSJ9zc99s2jIvaa1GsHhiq
         8gDxiTfMPnRQ6Vi3cglzfNTwe9bi73mCzG+dUpVV9AZbrZWbxvODuaOamc/ATdk/WtjU
         eDPw==
X-Gm-Message-State: AOAM530ypli3tNFiNX13yOA+nAwaglXTdyxWUiVtjDL/aWzCQ9h35Gtk
        tp//awmGaLk02TW4K7RXRz8=
X-Google-Smtp-Source: ABdhPJyfyUFZ+vhs2TGIQqtoKDwOtSGbu0zMRWpP/QIjUMgrczLKyuRymwSAHSzj4qMzA746ctx9rg==
X-Received: by 2002:a17:90a:a108:: with SMTP id s8mr38186952pjp.85.1624283477944;
        Mon, 21 Jun 2021 06:51:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j10sm15995814pjb.36.2021.06.21.06.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:51:17 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 13/19] staging: qlge: rewrite do while loop as for loop in qlge_sem_spinlock
Date:   Mon, 21 Jun 2021 21:48:56 +0800
Message-Id: <20210621134902.83587-14-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since wait_count=30 > 0, the for loop is equivalent to do while
loop. This commit also replaces 100 with UDELAY_DELAY.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index c5e161595b1f..2d2405be38f5 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -140,12 +140,13 @@ static int qlge_sem_trylock(struct qlge_adapter *qdev, u32 sem_mask)
 int qlge_sem_spinlock(struct qlge_adapter *qdev, u32 sem_mask)
 {
 	unsigned int wait_count = 30;
+	int count;
 
-	do {
+	for (count = 0; count < wait_count; count++) {
 		if (!qlge_sem_trylock(qdev, sem_mask))
 			return 0;
-		udelay(100);
-	} while (--wait_count);
+		udelay(UDELAY_DELAY);
+	}
 	return -ETIMEDOUT;
 }
 
-- 
2.32.0

