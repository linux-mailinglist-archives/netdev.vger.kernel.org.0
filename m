Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EBC2878BD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbgJHPz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731532AbgJHPzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36952C0613D3;
        Thu,  8 Oct 2020 08:55:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r21so1300413pgj.5;
        Thu, 08 Oct 2020 08:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JSF8K2opzz/7M9BIA+8wAiC8MpeJj32nxl3r6KtkwTg=;
        b=uoeTcKmjrno1IuQAO/cQYHsGNHYsQTuqWlAmMjEAjjwD5SpfkmkWGcVgDqjPFF4EFz
         nC5HGL6pw0arXbww+splPQwvSWE6QxBtdgBZdB6eCopbDIdedXhMi5ccdilee7LrfhMj
         +UNgr/pb5yspUjKRKYiW5mgj240SdQZwWgXfyoopXWYD//SKQ6ckV4aQvnNB4S4f/MrL
         m4AFYl7vGq1DirMn+IU/7HVZ2gd5GL30V9qTgRPcBoFTv+SvspfgX9b9Q1B09+wMV5w2
         e8pRmCAIvv2DcCSo8ja6R1RtWLZilOwdTDB/UcIBeACjxQBx55BeaCC7uKoSszKOoZW7
         1J3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JSF8K2opzz/7M9BIA+8wAiC8MpeJj32nxl3r6KtkwTg=;
        b=p9yRdtKY/F3diJ1ZhbPAQgvNIQjSi09AZxZtQoLqN+r/VI7WRhtP1ZjCzryR5YlLTX
         OCuDGlb2n50OET9s57Tpx5+yJhfEV5aLyg+Ik9ydAQXpEFpS9lNtxL1pS86NLFl+jOUw
         JS1ziCvtskxtsVNGVz8eJJgDR1tFgcMonTL1/e6T8cDhGBxTuvCR2u3cTFUFGI8mrFeN
         h0daCtyLtQxfd8/C7errbg4CcgbjZOxGgEXWXiQPwJrF/HAE2jGuSl/pDmTzNZQx2f0n
         aOaB5r3RHn+OepbJ2CeiQWsDokd8V68zdLb3z5PuTzDqDkH97CCqccu0Dnf7XSvDRWZl
         q4TA==
X-Gm-Message-State: AOAM533fkTwj4c0vmXybUf8VJO5jSeAVIKTnjV8LvhhN6GTG+EHMnF4Z
        xMTVnR8OdKPruQz8qc8ptww=
X-Google-Smtp-Source: ABdhPJykB8ARC6cBw22YGej66zmq/QyNPYapKB7oinjiEy8/vw6xKWvJvmppJZBvW8vw2d3KrDRWXA==
X-Received: by 2002:a17:90a:9415:: with SMTP id r21mr8952164pjo.180.1602172549783;
        Thu, 08 Oct 2020 08:55:49 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:49 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 067/117] ath11k: set fops_simulate_radar.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:19 +0000
Message-Id: <20201008155209.18025-67-ap420073@gmail.com>
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
index da085c0a01ed..c3475ece2720 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -1143,7 +1143,8 @@ static ssize_t ath11k_write_simulate_radar(struct file *file,
 
 static const struct file_operations fops_simulate_radar = {
 	.write = ath11k_write_simulate_radar,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 int ath11k_debug_register(struct ath11k *ar)
-- 
2.17.1

