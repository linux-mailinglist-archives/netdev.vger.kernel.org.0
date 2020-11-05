Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934DF2A85F4
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732284AbgKESPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbgKESOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:14 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10707C0613D3
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:14 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id k1so2206909ilc.10
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nKaefqcI17QqdeWMZD8JeaTBQ5r2E/JmwfTxUS+fzKY=;
        b=RWxu2FrHFx9HVVRvn5cKxrxhaLaF+dvUm+TRM10PdiU0qZfsbucYAOkF3XHelELxrP
         CfFzjCrDFDmey8BX0R/6xKYbpEYGB41tJwwI0OWjQLqgWJSGh/p0NowPoNFJ+57/pHza
         5Vy4oUjw35Qx8dOJEtnVSDhvrFwLga+U/+AmtlI6BTGuEcu/SVzCK0n2qYreNr6NR7ib
         1rVSwtKv2RhubMOh5yv1t95ZP+gUJ43XW8WeYkcSsB4VYbKu8ntUoMPwoh1WW7hF3ks4
         y/HEnnbAQOs3+Opbp23lXmkApuSksdfGYGeaR0tHL2PZTjvkCDo0+y7FOkl3Z1PQt3KA
         QWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nKaefqcI17QqdeWMZD8JeaTBQ5r2E/JmwfTxUS+fzKY=;
        b=N+sXBj4GdfRRTAEyQSfEKavwTmc7cl73VmtWWHQvevFkBk9UbzkcqwLyL9ffzrycwj
         jbXphr6DcQ3EKfzwrN+gE+81/xjduHhxMM7947HMs/vhAwsBIjnAJoefGmwrLSJDFDx4
         aHEFe+mFBj3UT4FyG0lEz/BoiH3BSKt6S0X77gh43IgIOmsTzpGjOeTgeWbQ1JEwyWvv
         7opuvDfx7urF4goH/aHNioVD9U6/vbD/t4pUJ4u+UTeqicylItdCWhSdaPJXztxP63Sk
         hKpiR3wjgCEmHneSjhJ7sRJsXOFviYgtArFetLiO6KxK3TyECb6SnT4Du8Hmaof55gYu
         Ydrg==
X-Gm-Message-State: AOAM531LTq4kly0lpVRVYbDGM1pA2sIFsyTvjdsya/PRKpCiSYL5WTOJ
        E5J45y0uZG1ISu8FDVqz33CTXg==
X-Google-Smtp-Source: ABdhPJxphJZX4DAONNvzja8KmEVKpnehmrvQDjCC9RxUegGLEydFbBES8lZ9wcby8vN/iUhBgY/96w==
X-Received: by 2002:a92:6b08:: with SMTP id g8mr2703981ilc.32.1604600053360;
        Thu, 05 Nov 2020 10:14:13 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:12 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/13] net: ipa: refer to IPA versions, not GSI
Date:   Thu,  5 Nov 2020 12:13:55 -0600
Message-Id: <20201105181407.8006-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI code is now exposed to IPA version numbers, and we handle
version-specific behavior based on the IPA version.

Modify some comments that talk about GSI versions so they reference
IPA versions instead.  Correct version number errors in a couple of
these comments.

The (comment) mapping between IPA and GSI versions in the definition
of the ipa_version enumerated type remains.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_reg.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 8e0e9350c3831..9668797aa58ef 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -66,7 +66,7 @@
 #define CHTYPE_DIR_FMASK		GENMASK(3, 3)
 #define EE_FMASK			GENMASK(7, 4)
 #define CHID_FMASK			GENMASK(12, 8)
-/* The next field is present for GSI v2.0 and above */
+/* The next field is present for IPA v4.5 and above */
 #define CHTYPE_PROTOCOL_MSB_FMASK	GENMASK(13, 13)
 #define ERINDEX_FMASK			GENMASK(18, 14)
 #define CHSTATE_FMASK			GENMASK(23, 20)
@@ -95,7 +95,7 @@
 #define WRR_WEIGHT_FMASK		GENMASK(3, 0)
 #define MAX_PREFETCH_FMASK		GENMASK(8, 8)
 #define USE_DB_ENG_FMASK		GENMASK(9, 9)
-/* The next field is present for GSI v2.0 and above */
+/* The next field is only present for IPA v4.0, v4.1, and v4.2 */
 #define USE_ESCAPE_BUF_ONLY_FMASK	GENMASK(10, 10)
 
 #define GSI_CH_C_SCRATCH_0_OFFSET(ch) \
@@ -238,19 +238,19 @@
 #define IRAM_SIZE_FMASK			GENMASK(2, 0)
 #define IRAM_SIZE_ONE_KB_FVAL			0
 #define IRAM_SIZE_TWO_KB_FVAL			1
-/* The next two values are available for GSI v2.0 and above */
+/* The next two values are available for IPA v4.0 and above */
 #define IRAM_SIZE_TWO_N_HALF_KB_FVAL		2
 #define IRAM_SIZE_THREE_KB_FVAL			3
 #define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
 #define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
 #define GSI_CH_PEND_TRANSLATE_FMASK	GENMASK(13, 13)
 #define GSI_CH_FULL_LOGIC_FMASK		GENMASK(14, 14)
-/* Fields below are present for GSI v2.0 and above */
+/* Fields below are present for IPA v4.0 and above */
 #define GSI_USE_SDMA_FMASK		GENMASK(15, 15)
 #define GSI_SDMA_N_INT_FMASK		GENMASK(18, 16)
 #define GSI_SDMA_MAX_BURST_FMASK	GENMASK(26, 19)
 #define GSI_SDMA_N_IOVEC_FMASK		GENMASK(29, 27)
-/* Fields below are present for GSI v2.2 and above */
+/* Fields below are present for IPA v4.2 and above */
 #define GSI_USE_RD_WR_ENG_FMASK		GENMASK(30, 30)
 #define GSI_USE_INTER_EE_FMASK		GENMASK(31, 31)
 
-- 
2.20.1

