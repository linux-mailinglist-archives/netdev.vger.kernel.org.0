Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8491E29D97A
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389790AbgJ1Wz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731840AbgJ1WyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:54:02 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4117C0613CF;
        Wed, 28 Oct 2020 15:54:01 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z24so745632pgk.3;
        Wed, 28 Oct 2020 15:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qmvrLB7IH1tGEinPOUC68sap5ydLolJODJfXOc7ByPA=;
        b=RvRQWDXRKqXfWV1Qf7Fg/btqgFdO6+cXld3893h/BP0HWY/1WVErVSqo7pbWRTd9uW
         BcCM2LMn4SMYPMMhw0Mf8/X6yjlG2KT47LD9Me3eDW5ggVIq0SUvGrO1VDADfSDh9DTc
         QWFOWQNxO86T5rgzitA0pLdEDzIXGXc8eBuVmk1/n5KIIyeClJC5o2YT3zobf8H/+zKZ
         13v8qIJNPdAz/R36oUoJG4mRgCiilam6iyzbkZI8v4v2OYpSu2CQy/zPcXs57oYa4Akt
         cDZizE+XsfoG0y2skqlWJADlevw+dYlVxZOk3JsZmCQRCGQ30DQUkESKAA3E6K5r2ZkU
         5Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qmvrLB7IH1tGEinPOUC68sap5ydLolJODJfXOc7ByPA=;
        b=OH5M+ac17Lh7CHQS+0gY18nPTqU0HdbHGnUxx4ndsQCQ3nAFd+UK1kGMGLYubqpOgW
         eCFsVeifjkmRzcVSJqiZjQhLBJZo0t4L7p+psW4KtwvDG3Tkg3E8ee990f6XyHSj0phs
         ThoAJtskITyS/ydI2jlcu3WsP8QzC7nI2qO3P0uwZbwwgdjDtlN0GPwTIYxWtRhM5RJ2
         K6rEetVAzqoDKi5ZoP0OVpWzf4qzEUVFkQlOKPKlDxHMABHd/6C/FT0LwR7vyJehANXx
         SRoCG9NKc4ikIOMZ8XKK94TyV3f7zXjG591JTnPmOLxFEn58RlGcNIPZw1fIl14AAPnn
         1fMw==
X-Gm-Message-State: AOAM531WE3VAvDmTvbW7mbIhaL0lF0x6D4nY8GtgbK13ka1Rk1IlbGQJ
        D72U+DGtuyuLqi6Y1PQyC9hkDuwCIJq5lFr/
X-Google-Smtp-Source: ABdhPJzTvSsMLNIAWrdEQ/goV55Jb501WYhs5rz8KEKsREYW9U+fmj5apKNge3gsIDMfJRlUVEgtpQ==
X-Received: by 2002:a17:902:c086:b029:d3:deab:e812 with SMTP id j6-20020a170902c086b02900d3deabe812mr7546840pld.51.1603894968621;
        Wed, 28 Oct 2020 07:22:48 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id c12sm6293543pgi.14.2020.10.28.07.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:22:48 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [PATCH 2/2] mwifiex: update comment for shutdown_sw()/reinit_sw() to reflect current state
Date:   Wed, 28 Oct 2020 23:21:10 +0900
Message-Id: <20201028142110.18144-3-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201028142110.18144-1-kitakar@gmail.com>
References: <20201028142110.18144-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions mwifiex_shutdown_sw() and mwifiex_reinit_sw() can be used
for more general purposes than the PCIe function level reset. Also, these
are even not PCIe-specific.

So, let's update the comments at the top of each function accordingly.

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 6283df5aaaf8b..ee52fb839ef77 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1455,7 +1455,7 @@ static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function gets called during PCIe function level reset.
+ * This function can be used for shutting down the adapter SW.
  */
 int mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 {
@@ -1483,7 +1483,7 @@ int mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 }
 EXPORT_SYMBOL_GPL(mwifiex_shutdown_sw);
 
-/* This function gets called during PCIe function level reset. Required
+/* This function can be used for reinitting the adapter SW. Required
  * code is extracted from mwifiex_add_card()
  */
 int
-- 
2.29.1

