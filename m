Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B15249725
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgHSHZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbgHSHYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:24:53 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99ECC061365
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:23 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so20466792wrw.1
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hzv6Xq3ihFFQsayom2Qdg9Hzw3ojwjKD2yhS4tVSkyI=;
        b=nM+ypooSib+F0Ke3ylfbyi7Y4o8dDRKGmtHuMTj7uxHi1swHTkHFLPAWPGEcB9PRtq
         BrnsThl6hPmiHgHibuMziQ4oqW/PJ+LzMvlVGwAvI+XmX3TJnNNACWaaA56oJodBnpqQ
         qUJA4Mm6BVOB6wvF5Yl8WVV/2XR6CCMob2C+8g+d/Gj8OCsBXiSvnOElaAPV2bCVt46H
         Tnq/dTxQcpckeMc5ysqvIb1ekOBsnDSiBqXiUYPm2eZ143wB+kT5uVt07gCrID5Vt45A
         0o2ivfUYudi5uJtDO9staymBqbf++Fnnt8pWaObBNJ0cji5pPNaMfiaePjRALpKzznL9
         mpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hzv6Xq3ihFFQsayom2Qdg9Hzw3ojwjKD2yhS4tVSkyI=;
        b=StMzgWcsrlAH5ZzkGTkWKLwt0T7/E+nF2KHqRAp56bAULNYehAQcI15oMQ4SYQlKEt
         PPSKubT7OEjdqac27FlDn+S/6QvsQSegqRBZPg36B+mWEMlnWAcE7qIqgX3qRFvlCGzE
         inmRPlHqF9j53C7JqotqwhRoG4b4fHmgx6xhTwChi7bWi/hFZXNfW0f4jrtyJk4r21Ep
         /djWmXqp27oLNXgi/pBqI/VOBDfRx36SWfcrJsPxsyIb8moDPCqksncEE7uyj0rvd7sT
         DxcwzEAV9V53QJcQLsMgCUnYW5/mKBIghS4v+8TqXwHRNnrq6+HgAHkmJTExfm0G9+e8
         CIyg==
X-Gm-Message-State: AOAM530ebiGkkbHQfp5O2MGDwGiD9BXpVSnhqiCcHalu2L95U4NqFUUw
        yJuUOlHIKqX1HUqjHXjZXfdLEQ==
X-Google-Smtp-Source: ABdhPJwWppYkSDcF/4ZvGyCNz2QJ/Xpyz04bWKQclyPg0aI7E+e3saIIUN86GwwaXZYAsfmAgFy0Kw==
X-Received: by 2002:a5d:54c8:: with SMTP id x8mr2709963wrv.405.1597821862505;
        Wed, 19 Aug 2020 00:24:22 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        libertas-dev@lists.infradead.org
Subject: [PATCH 14/28] wireless: marvell: libertas: Fix 'timer_list' stored private data related dot-rot
Date:   Wed, 19 Aug 2020 08:23:48 +0100
Message-Id: <20200819072402.3085022-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/marvell/libertas/main.c:727: warning: Function parameter or member 't' not described in 'lbs_cmd_timeout_handler'
 drivers/net/wireless/marvell/libertas/main.c:727: warning: Excess function parameter 'data' description in 'lbs_cmd_timeout_handler'
 drivers/net/wireless/marvell/libertas/main.c:761: warning: Function parameter or member 't' not described in 'lbs_tx_lockup_handler'
 drivers/net/wireless/marvell/libertas/main.c:761: warning: Excess function parameter 'data' description in 'lbs_tx_lockup_handler'
 drivers/net/wireless/marvell/libertas/main.c:784: warning: Function parameter or member 't' not described in 'auto_deepsleep_timer_fn'
 drivers/net/wireless/marvell/libertas/main.c:784: warning: Excess function parameter 'data' description in 'auto_deepsleep_timer_fn'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/marvell/libertas/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index 2233b59cdf444..ee4cf3437e28a 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -721,7 +721,7 @@ EXPORT_SYMBOL_GPL(lbs_resume);
  * lbs_cmd_timeout_handler - handles the timeout of command sending.
  * It will re-send the same command again.
  *
- * @data: &struct lbs_private pointer
+ * @t: Context from which to retrieve a &struct lbs_private pointer
  */
 static void lbs_cmd_timeout_handler(struct timer_list *t)
 {
@@ -755,7 +755,7 @@ static void lbs_cmd_timeout_handler(struct timer_list *t)
  * to the hardware. This is known to frequently happen with SD8686 when
  * waking up after a Wake-on-WLAN-triggered resume.
  *
- * @data: &struct lbs_private pointer
+ * @t: Context from which to retrieve a &struct lbs_private pointer
  */
 static void lbs_tx_lockup_handler(struct timer_list *t)
 {
@@ -777,7 +777,7 @@ static void lbs_tx_lockup_handler(struct timer_list *t)
 /**
  * auto_deepsleep_timer_fn - put the device back to deep sleep mode when
  * timer expires and no activity (command, event, data etc.) is detected.
- * @data:	&struct lbs_private pointer
+ * @t: Context from which to retrieve a &struct lbs_private pointer
  * returns:	N/A
  */
 static void auto_deepsleep_timer_fn(struct timer_list *t)
-- 
2.25.1

