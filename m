Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243E6287880
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbgJHPyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731377AbgJHPyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:35 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7BBC0613D2;
        Thu,  8 Oct 2020 08:54:35 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y14so4317753pfp.13;
        Thu, 08 Oct 2020 08:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OcfMun4v8oKxnyIXnfWE0XkQqSd4uJRZqO9scpwaSqs=;
        b=QVTXdnYT44U4kQSJnt6E7JvMjNnZTRkOwQC56/XjOt2Avv3fzpSwI+Wbri9MYxM45j
         YlzaOPWHUHButlY9hbyERN2VbBlhIxihQwYQ264rZR/idtzH9Xx5Wq4Fa8zykVcpjT4k
         Zjy0XO5b3hRsGGUYA+06L5uIjtrVs0j7RdcjV3XcRGso81bewfJG4Em5lB8kgmvpnZj9
         zAzom5macZ8gXq74GZcD7z3n9WU8KfWgWWGV7P7H6wKRUefwlnO+Suo/fNTYKwOrrIIc
         rlDHo4xpHyBBlbQ0seca7rE0p3RC0iWpHHuprqneIEC4VsppL0Todec7HIxnzwEVx/Ex
         lYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OcfMun4v8oKxnyIXnfWE0XkQqSd4uJRZqO9scpwaSqs=;
        b=mTXh02ifSM7CMLI09fG89XDP12NBsvgODIRiDpLEBc9F1eo+4e05bnUO1YLMayLCLg
         GBJUlTEckqybluIBYpzKN4gzKT7gj6X9KkNV8YL2QfrhcNTWhE5TbcgcLQ6XmcOCQV7U
         xnUJ2mWmj8rXoqmzhNAnGeBxiMrpjvv3EbxZYAZqJeXGx0S1SYA1C7oxmGyJRxIfanZD
         lJcJRGZX/82LAqOtIB2WNXjuyM71G/p5tZ2YXvoG2cl97Fy+0mI/TnQKA1ettRkhCctK
         k9xCtjQ4mwMhOYa4dPSGG621IeXcfG/A/nnnGKA0pejk3jJCBQZ0yc28G21LLef5exW3
         kJEQ==
X-Gm-Message-State: AOAM530u/R6TC/ASjXv4CYI7CWI0SuPMaV3nWvEruDCaZR4n28lJFjCs
        WLwUYO6BcEyAMhmCd5EZBdo=
X-Google-Smtp-Source: ABdhPJw85+yNtSabfjgwkvFbJDIRthpzw0WSDu6VqLH7zm9AqoDDg1bM3GWjJDCo1Z1NucRl9r0mzw==
X-Received: by 2002:a17:90b:3882:: with SMTP id mu2mr9227352pjb.29.1602172475033;
        Thu, 08 Oct 2020 08:54:35 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:34 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 043/117] iwlwifi: set DEBUGFS_READ_WRITE_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:55 +0000
Message-Id: <20201008155209.18025-43-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 712b6cf57a53 ("iwlwifi: Add debugfs to iwl core")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 41d969b46bae..a1022987eccf 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -52,6 +52,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.read = iwl_dbgfs_##name##_read,                                \
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 static ssize_t iwl_dbgfs_sram_read(struct file *file,
-- 
2.17.1

