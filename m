Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B052A291F
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgKBLZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbgKBLZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:25:10 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87367C061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:25:10 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id b3so8231934wrx.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=056QqikcWr/GU3mDhY6gijUgY/LGF79OsK2zfz8G1FY=;
        b=W37yfBK583pafCzRLg64VnRqB6KCXciKfUhwKFYq23i8cmA/2pECYpwCiRajDi/jAS
         vXqDdXiAsTFfIYGruSH4LNERNAhs5jOg4jf7aR0B0HB4l1av3e2szcKuU7RYhvsZfAI1
         +5KHQnHsTtMl7au8vZGQ2O0uyo6WHX4+ly8SaFGlPTyLhe8lSTJf7yvGgZTjBmeGpqPr
         NFsBB7Px4jpEwwbtu56UXv7PsqNKy7SZD6o7vdmUCHwCfMG/rBDG5b2MTMlMVNNSbNSV
         zghwHo/U9/D4llI7aghwzy6Ae7+glJVzil9EMuP1SBoJFQ21HwkMVTM1LhiLnCoT3P5n
         nsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=056QqikcWr/GU3mDhY6gijUgY/LGF79OsK2zfz8G1FY=;
        b=pPfWpsfTH4wqyVZgA0VkYkD2WmTaXT3S81oH20QZx4A8SDn3AQKLPWsc6MojswN12F
         gujfjdkMYRWoIRGtB7uJIgaadspJr6dsPAU3gCfN4wXMtroDp9L8iy0zTjhOAza0DOWi
         X7vNwJ1Ma0KEC8s932R9qC1HMtpX4tNqtXyX44Wu7N8DW6HuqIWRM5mu+0LnkUMKOXjh
         ENe8T0s988UHlmfN5ODlVvw9T/0aTXMi/SDXBt6Evbmf99Q37uYgtKijPbO+aN10OAPB
         VDTH7etZXUOL35ayUd2tAGUybChzn+Bo4cISvM1eEgp5ZY1937OiwsfFXDgv07/eJPR4
         hxhw==
X-Gm-Message-State: AOAM531mEj+/GoT6XNYWC/WYVagjLIY16tpMfE3h5tLxRY5ZpC/6Pt21
        ZBwpk/ixh4OEPo6S2VIlSCjs3A==
X-Google-Smtp-Source: ABdhPJxDupy0FMG3bX6UxJVIJ+cImXyT8UXoE5jQOggNYchuCsCtj+gHEPK7QXGccz59qmih4EY8Vg==
X-Received: by 2002:adf:82a7:: with SMTP id 36mr19859680wrc.1.1604316309328;
        Mon, 02 Nov 2020 03:25:09 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:25:08 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 39/41] ath9k: dynack: Demote non-compliant function header
Date:   Mon,  2 Nov 2020 11:24:08 +0000
Message-Id: <20201102112410.1049272-40-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath9k/dynack.c:52: warning: Function parameter or member 'old' not described in 'ath_dynack_ewma'
 drivers/net/wireless/ath/ath9k/dynack.c:52: warning: Function parameter or member 'new' not described in 'ath_dynack_ewma'

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/ath9k/dynack.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index fbeb4a739d321..3219715174a2f 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -44,9 +44,8 @@ static u32 ath_dynack_get_max_to(struct ath_hw *ah)
 	return 600;
 }
 
-/**
+/*
  * ath_dynack_ewma - EWMA (Exponentially Weighted Moving Average) calculation
- *
  */
 static inline int ath_dynack_ewma(int old, int new)
 {
-- 
2.25.1

