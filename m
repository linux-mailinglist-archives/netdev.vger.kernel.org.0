Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAD928789C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbgJHPzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731665AbgJHPzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA37C061755;
        Thu,  8 Oct 2020 08:55:09 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id o9so2950405plx.10;
        Thu, 08 Oct 2020 08:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yxvteaVfPmUIKMHl8/yTuLWj7C+G9vgr+RlBb+7YRLA=;
        b=mxJ63GYmaJzEVMsDiyXY9N680q9UJ78csi4Ncu2o/0n8hs6mYdtBzwkTkhgAYRZjHq
         V0PxRn7rMKjCvF1zLj+Q900nHEh3hXl2irMQobrVw4YphwvQdRqAaTBDqrnRKPoUjMm0
         YGZpSyvFwVcdRgIQ5AhQ4VSkC354ELdAdwRnxA0pOg/6eQ3ZjmdqJ9YBD3s2u+bYaFDb
         6/VVF1cbiH47zBCtqR6DzE6TXuWw9SZOBMaj46qwLukAOLx0nFJlzF2ivVqDypr6V05v
         5xSQonYCQOsqQhtA14rdqa6yygDLA5z+WzYN7qA8QSaL+6rDpv9am6+YPpqZwy5CSctu
         RNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yxvteaVfPmUIKMHl8/yTuLWj7C+G9vgr+RlBb+7YRLA=;
        b=D1pqe08oCoeH5fAHc2nXcD8FhMUWPjBaILzpkeONqQmZ7eKA6qoD90DkMnV0ans43Y
         J7crNoK7VIcNtJMkSJXE7E2DxEB5XoLKmKB7f80V5nucLoHz0m77is7g2ZK6AHFHtQE1
         ExIxo1SnmuuilIKCphKhKhrRocZZad9NguaD8bH8AQOxbffZzGf2PVD9L6XNucUWfand
         M9VclI5ofaVDeKv8CRr29h3YLdlVrGZ0QQ8tE3TQ6pC+tgmXAAT0pRy8ARgjJUZI0Xa6
         12MwQgSHsqeEi0CDz/N1SQ2hjmMPcYBItBEHzF935UhSrWtkesdMc5teLq6MZjQRB2ep
         +Whw==
X-Gm-Message-State: AOAM532MRBMuoGqsNMFxg+aNH0LXgpsbKmOjh2rJeMl4QX5rIPpSNDRD
        yL1cuXTPW70GkOjzRDE+Uow=
X-Google-Smtp-Source: ABdhPJzHtpA+rRTBdU86C9ERm99wm8xkR5rwdpqzE6J5SFc7sgavsscMdch7IOF0f6zqBcU0ZaemUA==
X-Received: by 2002:a17:902:b946:b029:d2:8084:ea0 with SMTP id h6-20020a170902b946b02900d280840ea0mr8054247pls.25.1602172509318;
        Thu, 08 Oct 2020 08:55:09 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:08 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 054/117] iwlwifi: set DEBUGFS_READ_WRITE_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:06 +0000
Message-Id: <20201008155209.18025-54-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index 9813d4b507e5..fcf5fd3c7364 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -156,6 +156,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.read = il_dbgfs_##name##_read,				\
 	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
+	.owner = THIS_MODULE,					\
 };
 
 static const char *
-- 
2.17.1

