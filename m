Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E329E398E8
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbfFGWhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:37:47 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33947 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731576AbfFGWhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:37:46 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so1348867plt.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8sTKn+NeNGftSNd5KJGe8Yb4ykjEmhycPSYA44kfjJY=;
        b=Ucg5J6CS84kZYZtbBhATrQIknzmFCKsyZ7LYk+YHEeYL4wOxQCtCRSkS3wIsUeuHkJ
         /LQxRvlY2IWw8HHiKuSX9ALH8ZzfyZEB4BNOJKcdMs2xn7gjThq+DFjBPyJ8y52VaHrx
         2MH6k6VP9dROiEtG//1pGg4RL1jTW6bsCQPgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sTKn+NeNGftSNd5KJGe8Yb4ykjEmhycPSYA44kfjJY=;
        b=Y7BcoD/u+VlJpeYLpTaR95/jOrW4VdFPMMleB7RpcUIOIElmZzDtLjm+FwJ7PUkDR5
         LwLjuHBIosYy02q86Rnt7nVgzVFaIwWNPwjuoqaJgKd2r78d22Jl98DddfAExUqMLUB2
         7R7EA+PTJpGfv85bi4zekzJulJSKBef72A9XfS7c3HaQWzwKRQHHwV/9W5mghH68k5uG
         ZCEbH8+Tlyy2ejgnsvbayowkBgo4AkdRAjn0lSWkQtTjsLUcuzT2YEM+Lu5tTHTlo71f
         tXNaoTnxpYWTTXNhxdJQRFvJ2BWjxy358ROMmMnklqR1nJlmRJDvZitTX3Lcae52hMx2
         8VmQ==
X-Gm-Message-State: APjAAAWF13BULw5ushIvlJk5XaLODem3TQ8Pmk3XQVcC4hmSZlM+bxZv
        WIlYDbJS5zxT2KLWIOLtfaaXVQ==
X-Google-Smtp-Source: APXvYqw1I/ZttnUQ8QkMd/Js4RpLH7dJjGMdXXIuPwxR4ePJkKWsj+UjjyQqqvZzmUs8Y7lbo3jcBw==
X-Received: by 2002:a17:902:d88e:: with SMTP id b14mr7328462plz.153.1559947065437;
        Fri, 07 Jun 2019 15:37:45 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id j23sm4185193pgb.63.2019.06.07.15.37.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 15:37:44 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Douglas Anderson <dianders@chromium.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Pan Bian <bianpan2016@163.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Mathieu Malaterre <malat@debian.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v3 4/5] mmc: core: Export mmc_retune_hold_now() mmc_retune_release()
Date:   Fri,  7 Jun 2019 15:37:15 -0700
Message-Id: <20190607223716.119277-5-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <20190607223716.119277-1-dianders@chromium.org>
References: <20190607223716.119277-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want SDIO drivers to be able to temporarily stop retuning when the
driver knows that the SDIO card is not in a state where retuning will
work (maybe because the card is asleep).  We'll move the relevant
functions to a place where drivers can call them.

NOTE: We'll leave the calls with a mmc_ prefix following the lead of
the API call mmc_hw_reset(), which is also expected to be called
directly by SDIO cards.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

Changes in v3:
- ("mmc: core: Export mmc_retune_hold_now() mmc_retune_release()") new for v3.

Changes in v2: None

 drivers/mmc/core/host.c  | 7 +++++++
 drivers/mmc/core/host.h  | 7 -------
 include/linux/mmc/core.h | 2 ++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 6a51f7a06ce7..361f4d151d20 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -111,6 +111,13 @@ void mmc_retune_hold(struct mmc_host *host)
 	host->hold_retune += 1;
 }
 
+void mmc_retune_hold_now(struct mmc_host *host)
+{
+	host->retune_now = 0;
+	host->hold_retune += 1;
+}
+EXPORT_SYMBOL(mmc_retune_hold_now);
+
 void mmc_retune_release(struct mmc_host *host)
 {
 	if (host->hold_retune)
diff --git a/drivers/mmc/core/host.h b/drivers/mmc/core/host.h
index 4805438c02ff..3212afc6c9fe 100644
--- a/drivers/mmc/core/host.h
+++ b/drivers/mmc/core/host.h
@@ -19,17 +19,10 @@ void mmc_unregister_host_class(void);
 void mmc_retune_enable(struct mmc_host *host);
 void mmc_retune_disable(struct mmc_host *host);
 void mmc_retune_hold(struct mmc_host *host);
-void mmc_retune_release(struct mmc_host *host);
 int mmc_retune(struct mmc_host *host);
 void mmc_retune_pause(struct mmc_host *host);
 void mmc_retune_unpause(struct mmc_host *host);
 
-static inline void mmc_retune_hold_now(struct mmc_host *host)
-{
-	host->retune_now = 0;
-	host->hold_retune += 1;
-}
-
 static inline void mmc_retune_recheck(struct mmc_host *host)
 {
 	if (host->hold_retune <= 1)
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 02a13abf0cda..53085245383c 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -181,5 +181,7 @@ int mmc_sw_reset(struct mmc_host *host);
 void mmc_expect_errors_begin(struct mmc_host *host);
 void mmc_expect_errors_end(struct mmc_host *host);
 void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card);
+void mmc_retune_release(struct mmc_host *host);
+void mmc_retune_hold_now(struct mmc_host *host);
 
 #endif /* LINUX_MMC_CORE_H */
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

