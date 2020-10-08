Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CE9287965
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732043AbgJHP7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbgJHP4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:05 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EE0C0613D3;
        Thu,  8 Oct 2020 08:56:05 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n14so4340739pff.6;
        Thu, 08 Oct 2020 08:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FlgzzwQhLsz0EGcy/75rx94byNGmT84BU3741NOK9lA=;
        b=o7UVjtoO75382qNinTtDoeGkOTo8p6JeX+L9DU6HxXq2tEoQFKMHvb+nSjEdibLCjp
         RmFW+49AWITwYaeRhyb+uXAK15drGpw62XaV/GzLlp5LCCj/qQFxe3PDz+f/8xKOiMB0
         y/v7SSLg/CuWH856HHabtVGprqIh6Qlpgcxg/ZKWD3XzV9tBFUROHsAZEc62auqS47iZ
         aOQ2FMCrfWEB1fvHTPtne0sv0Gj3EH8URkLTm0Yu5FRhekxPQSStX0R3q4HzfmM6ef0q
         5c6O8HD+W+8s8IhhsMthHlnZWKvLjB2+2W6b5sKYsS++9TEy6jdTmFDuZ88zzUbQGJaF
         4i2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FlgzzwQhLsz0EGcy/75rx94byNGmT84BU3741NOK9lA=;
        b=dTxldNXFBfkk6aw9Dz+6wdRQlNKuqtjYoAZbsu/VOqginfdpCYqDue2hoOtBZ8enLw
         N2Pd/jKlmhV6h7CuO+zrWQlEes5bmkl4vvc2DxxTr3TjAHUUxc56YaFc1ATgDZL4IuNZ
         Q+kYK1kR1RbvuQaBdLWrbLe/fRIzZNcmoSmGtjAaZdMkn/rVzQLrayZo13+wjsKPStV9
         1XuPwDFsS4ypimCIOuE8ZQ7jk+cgNWhMMWYtXVUERtp7ZU0Xt+vImElrP/NWqjzqp6Oi
         QlFUdo69gwU2tZOj7Q5HWffUf1yGjoiyILsahOaAr6eladnvIfayczcGYiLtCXPiq9Dd
         qNjQ==
X-Gm-Message-State: AOAM531L+i8B1evenSd7/cY7Z/oGBqsYoXmTBo+hFoG5AchJmgwxITHz
        K11N9ZmzUnXH49BLWMmc2sVA8caOvic=
X-Google-Smtp-Source: ABdhPJwi5O1pcOcntjIf2ly387mP4XbpE4JDsxjZOr2hdb8fSfHAlS4UJHsljeOulyVafs84sXRLPQ==
X-Received: by 2002:a63:4e48:: with SMTP id o8mr7876119pgl.90.1602172565115;
        Thu, 08 Oct 2020 08:56:05 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:04 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 072/117] ath10k: set fops_peer_stats.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:24 +0000
Message-Id: <20201008155209.18025-72-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: cc61a1bbbc0e ("ath10k: enable debugfs provision to enable Peer Stats feature")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8829232e2b34..afde3d8048e8 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2167,7 +2167,8 @@ static ssize_t ath10k_read_peer_stats(struct file *file, char __user *ubuf,
 static const struct file_operations fops_peer_stats = {
 	.read = ath10k_read_peer_stats,
 	.write = ath10k_write_peer_stats,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_debug_fw_checksums_read(struct file *file,
-- 
2.17.1

