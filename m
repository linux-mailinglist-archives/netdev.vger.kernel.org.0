Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C662878AC
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731761AbgJHPzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731347AbgJHPyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:32 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C87BC061755;
        Thu,  8 Oct 2020 08:54:32 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y14so4317643pfp.13;
        Thu, 08 Oct 2020 08:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DExARAXGsmC/sowbMvji+AgBeV6mNpbfki6DNDx9Xq8=;
        b=e95ojzE+MH60CEYnSqGQmrOhPGAK23oIUSOtjRzvbXkRKGG1qpXLfl1EA8Rif7S1dk
         W2bSdYZk7SPN0jt6ekOb2ycdeRjEDcTkMzbKwHUlqAUn0tfj/IE7C6TdQxs/Z0Wg1X8p
         wSHYf/jJPAd6Uw7kA3OtUCMVkQ6bVek9TTrAs/iXJlZWMy1vjNFZSd4ptDzkcyKMjUrX
         +2IYKkKQxrZKnKbJvGI7rrd1PywsoGqq6c2vi798ovCAWMlvb7uxiDneXZcjCPct6Afa
         OhpjMSw3VQgnuy1C/a0CZKov/KhP8So3kyG8ogLJAZ7zTuqO1Xnnj57K65oAmDCXQs26
         P2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DExARAXGsmC/sowbMvji+AgBeV6mNpbfki6DNDx9Xq8=;
        b=cPp9UpYhw0Q5q7lVEZLgFTyNrqPsHKhg2V3oeP0HCzbOPtVj7Fqaq8AGbf1uyShQuW
         0PqSmBuMSGLVEXVOcIKJvPGrZPkFsLRvGyguBRjqiHwdYAuKyP5H2lBJrDyv8kyMOUim
         8VuzsICanlF6KhEtcFSV+cELIaIDw0BzN7kgJPkQrcwg5FDuVWoOiXa4YCRENLdORBZ5
         ohsJARne0UEJa/RQJ407aXn8BvgH+i6EJDw+ERNMfN4JsYzJnTNslspViFoMFMMwhAqc
         pwu1VtiDJ8g6KZLm/G7tQBQ1ciIOJEgN4pURTz0L7PYHImtbGqsboKPizwe6a2IkSgjx
         YXQA==
X-Gm-Message-State: AOAM530E8TFGqUy+XWEoeEWhIChVArbx2laUqn/JRBUfrTSEO8E5MPpx
        oluo/Tn2d/79QvDy5af80D4=
X-Google-Smtp-Source: ABdhPJy8ySKJPlmfDjub0bPrRgBvI84Ef5KKeT0B/Z8mZFnH07DIwus8dleHcTYOOTpU348wUW4svA==
X-Received: by 2002:a17:90a:9904:: with SMTP id b4mr8156708pjp.223.1602172471913;
        Thu, 08 Oct 2020 08:54:31 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:31 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 042/117] iwlwifi: set DEBUGFS_WRITE_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:54 +0000
Message-Id: <20201008155209.18025-42-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 189a2b5942d6 ("iwlwifi: trigger event log from debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index ac65141f0b3b..41d969b46bae 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -42,6 +42,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 
-- 
2.17.1

