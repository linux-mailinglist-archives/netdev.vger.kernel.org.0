Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F4228797D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732063AbgJHQAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730843AbgJHPz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:59 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6793DC061755;
        Thu,  8 Oct 2020 08:55:59 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b26so4349085pff.3;
        Thu, 08 Oct 2020 08:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FEsMF5rTN2yDtTQSXVQ9G9SgxRThZwfhT1vI5VStmZk=;
        b=AXIfH/n5nHLhvpqBNvB1kVQg8+mejpXHXLE8WeJgvAfm9/QBOsDiC6i33wUxdhBv2S
         wcOh4yzNnRX28Mk5QFR7GJG1FdPDeBNZE2PZzBRSA4WsnN6XVOmT0G61S667smH4D+rV
         Zz7zjNAcn7rKhyXd1C6X0NwT5sc0P+xUxJRWQ04IqNvkQ0nDB253gEtx9Q9DrAsNLk8K
         rj52PRwStC/OeRuMHUo1OcmiVs7aj94qFjXpSp40bqKWB05FDck5+dlShYZNOxhTkSBL
         9RGFh5yIQauKmZpAmsRl07AECKrR9T3pfce1Y5ckC3g8ngaTXPji9HE9EN1GCSeYTEXR
         km0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FEsMF5rTN2yDtTQSXVQ9G9SgxRThZwfhT1vI5VStmZk=;
        b=ta6BsTkXWhpJTn5R60fMt8VWU+mL1zvqYQowjxh689mZYgmfUgQe5VU/WmRszUkxAC
         dlUZj9D+1BxItoZFAvuuyxvLMZlvN7Ozb4lilqY7z4pBjixEY7WU622zd5FQ/eyz3ZP5
         FyTYpFCcWXCYd0XSUlA8xkTL+Hmnr5WQNSJYFdTZynqkRXDtIdImobNNoKjf2/adlpEa
         +YzQRsnSoRruTxS6Io8PjsHBwfNGuywldpqlz9ndA95BmsFoDxRJaSXFs1Hzr7PemwHV
         I2/Mr34HgN2p0g3sAGTbuDo6WXNOUa1lZblJ7sPML55jX3pwOT2wlIoa8BHEsW3z3mxm
         L9ig==
X-Gm-Message-State: AOAM530uHKwK4qs/3++1sBT056rjb87TPjdu+ivT36wJIdFOPZKc+5Ew
        OZDt9wSm6DPt3+TEm278gR0=
X-Google-Smtp-Source: ABdhPJyGq5iUC4jQ4EIlM5oj2J9lEyWkLCej77pSpfaniCR8P6eGJcYYSEjE4JfZD0TX/ChrYXzFNQ==
X-Received: by 2002:a17:90a:46c2:: with SMTP id x2mr9019845pjg.60.1602172558950;
        Thu, 08 Oct 2020 08:55:58 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:58 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 070/117] ath10k: set fops_btcoex.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:22 +0000
Message-Id: <20201008155209.18025-70-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 844fa5722712 ("ath10k: debugfs file to enable Bluetooth coexistence feature")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 9789ef98d25b..d1f8cf0d5604 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2041,7 +2041,8 @@ static ssize_t ath10k_read_btcoex(struct file *file, char __user *ubuf,
 static const struct file_operations fops_btcoex = {
 	.read = ath10k_read_btcoex,
 	.write = ath10k_write_btcoex,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_write_enable_extd_tx_stats(struct file *file,
-- 
2.17.1

