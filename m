Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470DC2878E5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbgJHP4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731854AbgJHP4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F321DC061755;
        Thu,  8 Oct 2020 08:56:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y20so2950757pll.12;
        Thu, 08 Oct 2020 08:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4bfP6LXabSr7jA9LzOT0tBNan1JAkleaaatfC9KHj3A=;
        b=gCxhRtXT9J4HF9L/DrjBiN345zbb5NtDyUOGoSIyGbrR3BWdeoDosbaIm3dZHKEaEA
         LXmen1SafQkLj55NDeMm3JAKkB+Gt2mop4UYVBx7MgwT6pNw5XQZ1G/qJF6BGhOZcFH8
         aaSlOxughLGCg52Rs+J0JMRBow6Zw0Xr+eneaH5qbYLQy3Mmysr7xXDToyHJOQruIieY
         q/88C71F4hsNlZRlH2ubhYp0yr0mp76VxJ4JIQDwJvvA4I1VWGLpdDa/qPEKVK2DDEmq
         YDJibEGeTT2aok+0/Cq5irYcrt24O2WBnYCWI+9jr4a8eMo9skXix/Cu2Y8yKBFfvlSc
         Kf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4bfP6LXabSr7jA9LzOT0tBNan1JAkleaaatfC9KHj3A=;
        b=UcPMRpWeBNlxGZ3vHHbh3fBEtuBrTAe8GpSvMLDNOaGg1UDft3qtu5LdySTjt1eWBy
         4c25RcgV/NBnMfR1I62Jnu/8cF9bW7c3EHcmzA4zZodfxQmEr32NQJBTV4rjgNKMYdZw
         cDb3OQG1h+Sg1iiRz5umkuFPDFwanrev8pCy+Z793LQcgs7MPKwKJvlirLN6w8mxXoys
         BCm1y/J+jHtH+6flfAyXtvMwtWeqbFkWy9HNnGrvBdbw3Z1EjrEuWwJk38ABvLFpIH18
         jd8mLRYs6BOlgv7oMnRIn4ibZOpHFqsJJ4xjkf6+ejnjN6xqp4wuPMFH7X0MTFbRZ8Ii
         VyVw==
X-Gm-Message-State: AOAM530Jssk+4T6B9Clbo1aPlhZ0O14Y07Dx4rMSl0oxWKRjTaiq04/f
        BUOu3ANf98yeryS8jiTcJBA=
X-Google-Smtp-Source: ABdhPJwykv7W7MUJnB0ASEDvlJ28J8I+YFQOWJa1WlzFgq6tFOPyb4oh3yA1TmQnP0HYMbNH40OP7Q==
X-Received: by 2002:a17:902:59d8:b029:d3:d115:66d9 with SMTP id d24-20020a17090259d8b02900d3d11566d9mr7769230plj.84.1602172608363;
        Thu, 08 Oct 2020 08:56:48 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:47 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 086/117] wil6210: set fops_link_stats.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:38 +0000
Message-Id: <20201008155209.18025-86-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 0c936b3c9633 ("wil6210: add support for link statistics")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 67b2248e6b36..a2dce1ed9d0d 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2010,6 +2010,7 @@ static const struct file_operations fops_link_stats = {
 	.read		= seq_read,
 	.write		= wil_link_stats_write,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 static int
-- 
2.17.1

