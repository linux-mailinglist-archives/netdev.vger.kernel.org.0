Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA564287984
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgJHQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730125AbgJHPz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E818C0613D2;
        Thu,  8 Oct 2020 08:55:28 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r21so1299503pgj.5;
        Thu, 08 Oct 2020 08:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TfUnXUG3PUhqApMy8jE53GYrD9Oex4/RdhP1/16gmfE=;
        b=ZYImLG5+5+C1sfUKZSkazV3+y+TpfPnGsKOmRDNNMJCn1SuZzBkNk8FdksTjWjlJpv
         esb8Q0QPIatYGQJoMuO1QhzrfakKyviobX1WzGvMHd+WNAp+SzB23doIsa8NyrzEJtt8
         stu9KdURk3dH6ROBHWmZDRPRhPUWTi8a3B0rrYRuD0tgjNqpb8iTsorC5tJwHbRWQRmC
         WhEarGHjR7CqiwUL7/A8LRpmT1VrH8apDJeotPtld/hQBfHA3RBFUKGFMEUUjzvWP2q2
         n687GDhetGqMeYhzND82pc1rMRmqtgwKqpV2709F9Z48QO4NisIsufdp/KBV8HtpGibG
         KlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TfUnXUG3PUhqApMy8jE53GYrD9Oex4/RdhP1/16gmfE=;
        b=DmGj4t6pb8x8OrVcnvc9l5D+TO7yv+7fL2LS+JaI7r4RmeyE439wIkvpoiB0jetCsd
         byR/ZF9DPRKcEvi1CFTDnWqcIWr+kbP6fpez0mfKwTT5UlWTyLTyh0mrLpBP9nTx7WX8
         dmXRQHt+cCvfIPt03/Vhu+mR6bOxf9PlIuBwC/xlnzAru3NaFyamNBOvy/IcgIRYnW08
         +IcmjjzDs4nf8PUQyww6gZJJsnFKwnXqY3VCrB4WAw3VCdy9b1LxoaH8T0VWn0bFCJG5
         FKyS2leJ3YXx4ZyV+i6VxincorJXAf9UGiwD8FDkZ30PUa74CzcT1TiO6+TQTK1w6aSm
         Dmcg==
X-Gm-Message-State: AOAM5313k+Q0/WdfEljxfcDVpCzQeXMOzOKCdZy8iHT9oCXKh7LfZRXI
        oQRe0n/g0v3+rFm4EULpD20=
X-Google-Smtp-Source: ABdhPJzfraFxam50Tb9VcChkEHqtGSPNoRLUQQQGwpU5125vLkBSAtQn7yBwy9SxYFZZMB2rnb9isA==
X-Received: by 2002:a63:5fcb:: with SMTP id t194mr3817538pgb.119.1602172527701;
        Thu, 08 Oct 2020 08:55:27 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 060/117] iwlagn: set DEBUGFS_READ_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:12 +0000
Message-Id: <20201008155209.18025-60-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 87e5666c0722 ("iwlagn: transport handler can register debugfs entries")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e5160d620868..e408a381c82b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2505,6 +2505,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_WRITE_FILE_OPS(name)                                    \
-- 
2.17.1

