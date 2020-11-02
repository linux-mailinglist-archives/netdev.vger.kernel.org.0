Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50CE2A2971
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgKBLY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgKBLYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:25 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10166C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:23 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p22so9018234wmg.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A1fMIMjw6i89f8UX70P4Kw6NDXaWlqTcl97Lfk1WFz4=;
        b=uzU+59hH5565Hurqo3QSpw5jMldLf2h0/QVjPsls6qykE/ceDqX8W3w0QjvF+RNNxK
         ob6ZesURS0nG0LpVVGD+PwwYIhIHQrSUrIpP7lqfbSIo5noKVOS41mw6mSFPjdiP8fKO
         WSvbAPpu0pV97tymA9dcJBDRm4I0NbViB7JiTYZ6Q8IA+r2vOB66zBRdbnHzsu9QXQ4/
         x5Zwv0aLPwnsdrvXPv7kRMaRWinwnjWBTOuYWVX1uBCK4WYpR+maFieGrFymLLeQQEnr
         U120OvXsajcfXIoNbeUAGMe0qbTaJxVJ1L9AFDzjUY6q4SNmSyGkXmHhy8wXc5pKKT5U
         vGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A1fMIMjw6i89f8UX70P4Kw6NDXaWlqTcl97Lfk1WFz4=;
        b=gLna9vR4wa0gg6OcsAp2Sjia0X/LSYhRsRoK+R76bYAE3Yt13XLMf4wrRL2ViHIAZV
         Bn5ETcpx759IBLlHsm+HaaEtVNJetTsB7xU7iO1i3uHVTMR/3hZOaYA8tXubkkLY9cyJ
         zG7PZFBrTCmWYwQcyYrOH1sYrhThTEluT9zs5ALK/i5gK+7xBosumimGiU/1805nQmWS
         d1/s5yZyz4FC23hBqIOh7ifCNHRmiW0bJek1Ar04Lc+Q0wrbLLKO5ZtVknLpxjO5paIc
         3esczmO3r10EkapdP4WZ7Mz6NXms89ghlwczsV5xqZbKoXER9ipnsv6ogc1+zzjIg7oI
         C4aQ==
X-Gm-Message-State: AOAM530Cl8XQq9RLmwJVri4BayC420675mx7o8Z2sGNzhIDWHCz/uizG
        SWSCDHsUBnA2hmj5pJukbe3Xdw==
X-Google-Smtp-Source: ABdhPJxOMcmp/5oX7Gq5iCjpMjclVgcK49IJ9lE6t5E9al45QFOH+Lc6yhmlA8ZPv4GomW4lGTZDIg==
X-Received: by 2002:a1c:790b:: with SMTP id l11mr16053038wme.53.1604316261773;
        Mon, 02 Nov 2020 03:24:21 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:21 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 03/41] rtl8192cu: mac: Fix some missing/ill-documented function parameters
Date:   Mon,  2 Nov 2020 11:23:32 +0000
Message-Id: <20201102112410.1049272-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:124: warning: Function parameter or member 'hw' not described in 'rtl92c_llt_write'
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:124: warning: Excess function parameter 'io' description in 'rtl92c_llt_write'
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:155: warning: Function parameter or member 'hw' not described in 'rtl92c_init_llt_table'
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:155: warning: Excess function parameter 'io' description in 'rtl92c_init_llt_table'

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index 2890a495a23ec..8d2c6d8d32d93 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
@@ -113,7 +113,7 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
 
 /**
  * writeLLT - LLT table write access
- * @io: io callback
+ * @hw: Pointer to the ieee80211_hw structure.
  * @address: LLT logical address.
  * @data: LLT data content
  *
@@ -145,11 +145,10 @@ bool rtl92c_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 
 /**
  * rtl92c_init_LLT_table - Init LLT table
- * @io: io callback
- * @boundary:
+ * @hw: Pointer to the ieee80211_hw structure.
+ * @boundary: Page boundary.
  *
  * Realtek hardware access function.
- *
  */
 bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u32 boundary)
 {
-- 
2.25.1

