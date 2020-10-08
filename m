Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7152878EC
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgJHP4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731050AbgJHP4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:39 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BD7C0613D4;
        Thu,  8 Oct 2020 08:56:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x16so4673183pgj.3;
        Thu, 08 Oct 2020 08:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hCNE5of9x+/yzAhpW7gQG59+p9682+iHQk4Hm2UU2Yw=;
        b=MTarcBSOzm9kbG7XN85PHpxOqwO2cqjjz1gw7ePZ1bhvzwwIdr9FTLUwhPcB0C1QvE
         0UBFl8TZLUZk/VmRoIzKWaweWlDCkn9foFaSl1smc0ulcxnrJd8d4vvFtJaQWFvSQam2
         8oBq4vJMqOzeiwMu8ZkrhKVe3oWQgnQXX0fLrc7J+wSP/v1qtSqDkbq+XvUdcCQ7nMa0
         hu7JLWeJzJiVvAiLdQQejC4rLU6OLK8kEwt29d5LGgWhYwZVrCmwUERz3QsoXpbrCYWh
         GKqXfQkckBMhzRLP5+As2Xs5vqwcykbFtgG9jB/a5Ghm6TP68n+wb1qFglTayngA4DOz
         HVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hCNE5of9x+/yzAhpW7gQG59+p9682+iHQk4Hm2UU2Yw=;
        b=bgUkN9bdWrlHbRyuML/gF6at/bk9nxSCseCNTey+HD/0dG0iCnwL/duTjmGiJiQmSj
         6nCrUD9tMIQrh7aHc4P8AWXyPLg3qhvbIn2YsD0lq1Gx9BJQPphc71q2VYZZY4jyceWX
         X8sg8mhW/pE04YEJ3QplroNFLlQH4GtPvCKgk5fPVAQqdSqiDnlxul3fywazM94abHZP
         SzrAXoIzQVSojP/BxX2BjIxbxyK93nImJoCJ9BxO1gloEa7GKpV3N3uxO99bgME0TzUj
         qz2pmzO7f3IPJEzAZoBOPTd5XhvM4S695gOzEi17xASE/4xE5j7CI2dA8eljEB9qwGWL
         yQQQ==
X-Gm-Message-State: AOAM532OP1XXTJJo1AxXIbVKvScyXl5nw0bwEp1smriDdPhi5J3omFwH
        JS1nqR6/7yTsb95sOW81jfw=
X-Google-Smtp-Source: ABdhPJyb3kfL3KCcutwYDbWBzG0W+CoNb0RRWorsUtluptdnWJiOyik5sTWZ303Wvzvb2ksjN7yiZA==
X-Received: by 2002:a17:90a:6444:: with SMTP id y4mr3859628pjm.203.1602172599157;
        Thu, 08 Oct 2020 08:56:39 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:38 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 083/117] wil6210: set fops_wmi.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:35 +0000
Message-Id: <20201008155209.18025-83-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: ff974e408334 ("wil6210: debugfs interface to send raw WMI command")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 182185a34071..6d9a1de2974c 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1047,6 +1047,7 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 static const struct file_operations fops_wmi = {
 	.write = wil_write_file_wmi,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static void wil_seq_print_skb(struct seq_file *s, struct sk_buff *skb)
-- 
2.17.1

