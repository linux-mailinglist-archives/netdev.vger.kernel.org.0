Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BF828783A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbgJHPxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730244AbgJHPxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:02 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1B1C061755;
        Thu,  8 Oct 2020 08:53:02 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so4343918pfk.2;
        Thu, 08 Oct 2020 08:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JACHm6oKXj4X805YMJCH36b46IaUgQQqgzNkmYNvOgM=;
        b=WoOrMpBWzaUaUTxQR0JEyrIKZxlGcIOZfYHA7+rf0Q76HEjIFAGDXa2ZxcQj96xNqX
         hi26NuzvEN7mDBh2KIgfU0fq5Hin8PgCzaAX3kw5VEahTcZGHrTB+OJiO+tTxpFWcV8J
         RCyveWW517PsQAp6qiKONhALSpX7mB6/J1Pp2uv4lXeMG8Odoo8ztXa4QIolvNxOB7Dc
         CdKQvFgLl9jP/JYNQMBrLpATyYRDpY43+c5Q16Qnis28v3ydyPuAtMhAnMmogcgbZd3z
         12fhOqpIg/MwIUvCc4RHBv4fGHohgy8M1UtUiqhtr3WR2fyXfd3GcMRDpT/qm1ci32rv
         jXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JACHm6oKXj4X805YMJCH36b46IaUgQQqgzNkmYNvOgM=;
        b=TPhVOD8XJJdErpGr9zHDiUg+EoHrzZbeT7Z/hsItw7NTC7WaIF4N7ILbo56zbpFRD0
         eFI0X5YuCSr9ni0T+Ehld2NJ9kGIEte1iOfUGOkfi3pjdQg/tyowVXGTEj7QVVDz5opf
         RnejbclWq6oHgInp1ycNdXeNjAo1BatoDe9vzdE08bjy5ArokRK1gCU+l7mFd8qEpQBF
         7njo3ysl/Ol+QBE/Qbt6nnZrxVPb67vjxj1kwEyHjyIBRuoMxhPFGIGzYMyCpaEceRPS
         TCg5pdpTW0pQikF04zMiUslMz+u8Je+hwgTkmR0t1ivIPQFlZmcbu5wTAy3xlb26T3jG
         rq/A==
X-Gm-Message-State: AOAM5310ZL8ntF5PK8sw6dFxaBGLxnkhesvzKw/IqSOKHg9oMk06YuGL
        FoZX8knqnrpA87FhElKpgFBVAoq0CPM=
X-Google-Smtp-Source: ABdhPJzac6JfS6brawVZo1jUEJyMHa8jIGDCvhxgZNpBj6qqDAlOpgXyOVFEou+GUEaqdqlJIaJqsQ==
X-Received: by 2002:a17:90a:4f0f:: with SMTP id p15mr9126273pjh.10.1602172381666;
        Thu, 08 Oct 2020 08:53:01 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:00 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 013/117] mac80211: set aql_txq_limit_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:25 +0000
Message-Id: <20201008155209.18025-13-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 3ace10f5b5ad ("mac80211: Implement Airtime-based Queue Limit (AQL)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 794892fe6622..ff690feb56a4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -285,6 +285,7 @@ static const struct file_operations aql_txq_limit_ops = {
 	.read = aql_txq_limit_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t force_tx_status_read(struct file *file,
-- 
2.17.1

