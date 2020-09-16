Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9890326C58B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgIPRFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 13:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgIPRD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:03:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AA9C025266;
        Wed, 16 Sep 2020 09:59:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a17so7671605wrn.6;
        Wed, 16 Sep 2020 09:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zuDfgEoZuBS30U/qqcPskrweiytOsrp9+LzlvUTV6AI=;
        b=e+KWNj6SHmuBq3BSL+qt3D6fhSFFzr/deE+ZSnbxvXRInB13Yb4CrMYEHuYZEezRLS
         altf9ECg8xUR5AiWnH8yDPgit6kOXeBV2g7Km5jNq2dJgu6dcp5m3KgkJ0lljJw1UIBN
         cnV6OYQxN2+vQrsIdLl+aaq747FTCHsTFgvM+OANBr2H9I9jMrdLCjpLOJ2JyyVkqAi8
         blc0lu/7lE5GredQggAQyw06iTxyDSQqtitb8GLrYZpGdiigHpec7G1zYUXtsUz1H/jV
         jIZGXv7/4sXgvVwvW7IMrLbk/24eoO8eiPRC5WXjm1EOpYj+2+EDsNRZqEtIdhMGB4z8
         TpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zuDfgEoZuBS30U/qqcPskrweiytOsrp9+LzlvUTV6AI=;
        b=lBcM/hqRjnwpMTsTJzGKccG0zaUTwH87t0kjuzi957GdYVxQChVCbw9lYik+7lFPT3
         z77X6c6/JmLgcNd1JHwwv0FvnQmm1ha+lMayMetT7gk6HeR2lP6syveDpL1XlcxirD0m
         qOsEsf5+VoIVQB5kLGVJoYU1Wl1QV2W82sQvzzCh3fOinZLEdqsIhGOvsnlO+taOCqAd
         wzmj9+rdUw4NMiNtNIq0nmxWTtCRc/XN2MY7GKLmS0nTUzBA+kmxbkAsNKezulHV9qyO
         /m4BX/IKpZ43+ZT9uxwxFh4M3FF2oRN5civumJFOBByGbY64p5vPx5C6YI72QP6qFizK
         OIIw==
X-Gm-Message-State: AOAM532YxFGlUtmbKTXcdFW2gNM93YSGg22w20lPF4vWucOB6rpglKpf
        BfpTMRZHUPmw91T9XELuW4k=
X-Google-Smtp-Source: ABdhPJw6gOPk33k8iaAOP74REJ4QomG2u3G+8mRYr0/W/BvTPcNtre4cpC/zNon9IAMNdzUQnWz/wQ==
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr26306527wrw.98.1600275559519;
        Wed, 16 Sep 2020 09:59:19 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id x24sm33266130wrd.53.2020.09.16.09.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 09:59:19 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ath10k: sdio: remove redundant check in for loop
Date:   Wed, 16 Sep 2020 17:57:49 +0100
Message-Id: <20200916165748.20927-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com>
References: <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The for loop checks whether cur_section is NULL on every iteration, but
we know it can never be NULL as there is another check towards the
bottom of the loop body. Refactor to avoid this unnecessary check.

Also, increment the variable i inline for clarity

Addresses-Coverity: 1496984 ("Null pointer dereferences)
Suggested-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
v2: refactor in the manner suggested by Saeed

 drivers/net/wireless/ath/ath10k/sdio.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 81ddaafb6721..486886c74e6a 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2307,8 +2307,8 @@ static int ath10k_sdio_dump_memory_section(struct ath10k *ar,
 	}
 
 	count = 0;
-
-	for (i = 0; cur_section; i++) {
+	i = 0;
+	for (; cur_section; cur_section = next_section) {
 		section_size = cur_section->end - cur_section->start;
 
 		if (section_size <= 0) {
@@ -2318,7 +2318,7 @@ static int ath10k_sdio_dump_memory_section(struct ath10k *ar,
 			break;
 		}
 
-		if ((i + 1) == mem_region->section_table.size) {
+		if (++i == mem_region->section_table.size) {
 			/* last section */
 			next_section = NULL;
 			skip_size = 0;
@@ -2361,12 +2361,6 @@ static int ath10k_sdio_dump_memory_section(struct ath10k *ar,
 		}
 
 		count += skip_size;
-
-		if (!next_section)
-			/* this was the last section */
-			break;
-
-		cur_section = next_section;
 	}
 
 	return count;
-- 
2.28.0

