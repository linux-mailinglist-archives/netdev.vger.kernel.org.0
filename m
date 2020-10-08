Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D622878C2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgJHPz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730221AbgJHPzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F38C0613D6;
        Thu,  8 Oct 2020 08:55:40 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id i2so4653786pgh.7;
        Thu, 08 Oct 2020 08:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dhVE/Lj/xi74Wn+a0azowddS2BxEUWDrC74+SgE2hYU=;
        b=cbHyHl9nKAwTP5NUmpgTTsLxLkeKMwDIlLdXfAXSlyUJDM+ibPwRWOcvb/xOtfYXUq
         tfsLUw8bqsEkOsWlTeM/3NctPA3wZYQYElmTdOsYKjILjyh16YIdKA/wjx+d1RtLL2y6
         +aMhuoFgKGarlQHfuGBzsftIkq+H40+YqjR0+A+I2mJ7US2D75CO4WpG7pzsWD3l7KVc
         zFb1RQYDyro1FO4T76ZXjWrPRRAcJQMMN6B6XjRb6WIzOpr4y0ER4bhRa6MO0NhPL48/
         zkQ4yEEnyaBeYd2Pdd6Tr4A0tC5SoOS2PHRmRexfeRlLgty9R+xAfioiEH7Xx5lXRAAD
         vqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dhVE/Lj/xi74Wn+a0azowddS2BxEUWDrC74+SgE2hYU=;
        b=E8mFHlY5Hvdh+vvJNlGzJ8KWmTc6qUsZ0eoYxnRVgzJDtQ50xS0FEW3MCLpVosm5/H
         ST1FN26rt94jBG5Z4IbgdbIOO+IW5vNEZbX02pmHv3/Xwkh9eDreUfrcbo5SlLLrGNdq
         8Lp9wUMIkjo1n5YuB56O0tR2NxOHn5ppfIuJRmDcJRt95OJIr+6EpIMC1FUp9Le50TC8
         vF3Itjt+3be9bqlBwFOP7W/IemNc7bGxnfSjXqEwKPKFSbBsMUB+jyqVKn8bQbnCg7vZ
         3sfprqvWPuXAvH7bwAwVj3HVCrGiyICBRhaAzh9XYi4P2j2a+I6Vz0BlXMNKg6v6EegM
         wBOw==
X-Gm-Message-State: AOAM531blCY0RsOZsjQlyfqeA1jv1Lw+AzZr5lTVwdxWr6f6wSUbzr49
        TWfUh3yGh9UF8DFpGIWiMy0=
X-Google-Smtp-Source: ABdhPJzy+ZcAJdoZdcurBsueuM+Ir3R3xhR9uI/vF38bfT0Ai9oJPGjG+RUH1r/0o8A+pjEKQMitsg==
X-Received: by 2002:a17:90a:1704:: with SMTP id z4mr8761127pjd.7.1602172540291;
        Thu, 08 Oct 2020 08:55:40 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:39 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 064/117] ath11k: set fops_extd_tx_stats.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:16 +0000
Message-Id: <20201008155209.18025-64-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/ath11k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index 62a1aa0565a9..93461e840c87 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -685,7 +685,8 @@ static ssize_t ath11k_read_enable_extd_tx_stats(struct file *file,
 static const struct file_operations fops_extd_tx_stats = {
 	.read = ath11k_read_enable_extd_tx_stats,
 	.write = ath11k_write_enable_extd_tx_stats,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath11k_write_extd_rx_stats(struct file *file,
-- 
2.17.1

