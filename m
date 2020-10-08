Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507022878F6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbgJHP5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbgJHP4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE72C061755;
        Thu,  8 Oct 2020 08:56:42 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x13so1722235pfa.9;
        Thu, 08 Oct 2020 08:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JPUPUulqw+1KRmv2hARS7plAOiS1LLD4ufAGHDZzNg8=;
        b=Y6VQp8v9UaRAjgvjOdVTzCyddM7Zz7g7QFXHMFyqAE9oMDec58a41MSR+qUpNM0gDc
         +aGXItmYnziBfubEKhYfOKdj/fgxJU7BQFykPsVsHRQvIOqHJCxBCAUaV0N768DYonHX
         B+TCMhPRfUs/irch6vSw/2XJ7BpEJ8qx/5qffI6sYsEFb2+tqC9YJU5+31eWNLUuzEnK
         +xPtgb3tGlvrs5OwK6n+Xf1bafu+QnAn7AdU952+cybJet4Wd5x9s+djkvB1CxUJAcg7
         pmqQxvnyq1PURJr6dlwt3M4zcRpPh1VY0TsZ4yqJ5bcp9QXth+69xpUI6oB6OWacHO0U
         5joQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JPUPUulqw+1KRmv2hARS7plAOiS1LLD4ufAGHDZzNg8=;
        b=l23ZEBSCKzce4ZZi9tgQjb+1mm736aWBBae8aiFJNtjLWpMien4Xs1EoDOt/d0XrtO
         YtdiyzrYGOhataOMgzdAr5BL9gtvI0wheH891vrB6JSs/TAm14dsa4vgx7WqzrKxnsFT
         eSUITpY9V5ypHj6I1HvCNwWSAUA4wLH4rOU7Y+VIKkqdW2pgR4ln9Pf+t0vTA1D/17GN
         FaaSRUlDnAUo0z9E5uZUP30TYgNd7JWABkPUuE2MOUiRnhxS5N9sfbrQnX+VDZJK5zLj
         SF24/7kRET2jRrg+n+rhWy2qGlzJMKERFf/jy5cWS/GCOwsyzb1Kp018pBhASe/hFYzv
         SWLA==
X-Gm-Message-State: AOAM530zZaiDiYuCdaSCD5zM5ICkFK7Jcz59mvD1A3pIxh9tCdagriOo
        NlxFbj2mn4AjW9j6m1klbtE=
X-Google-Smtp-Source: ABdhPJz8j02VFFqd9tOWpClGYW9OXp4mrcMOKuy3Y+3/hY4jWAnZ5G/AmJFs9l17TSKOvL4+yaJyxA==
X-Received: by 2002:a62:1d52:0:b029:152:3cf6:e2a8 with SMTP id d79-20020a621d520000b02901523cf6e2a8mr8101076pfd.46.1602172602214;
        Thu, 08 Oct 2020 08:56:42 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:41 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 084/117] wil6210: set fops_recovery.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:36 +0000
Message-Id: <20201008155209.18025-84-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c33407a8c504 ("wil6210: manual FW error recovery mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 6d9a1de2974c..e3ecdcb58392 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1567,6 +1567,7 @@ static const struct file_operations fops_recovery = {
 	.read = wil_read_file_recovery,
 	.write = wil_write_file_recovery,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /*---------Station matrix------------*/
-- 
2.17.1

