Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B18B2878E1
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbgJHP4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730717AbgJHP4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDE6C061755;
        Thu,  8 Oct 2020 08:56:30 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id g10so4339526pfc.8;
        Thu, 08 Oct 2020 08:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jbcf6VzNSRswfVAJzhslqe74uX/sqqVaZwLWIej15ak=;
        b=rPxj8iluaV0EAE5rhYWzA5uzlF9PVAZElFeaHVLiibSflLlqDIaMLqTy4qEY4okIJd
         DdQeULYZrmAbI1LYwBcnrIL6FGU4whThrOZwpxwWCk5vntmoIs4TdpPPXod0tPfW+m9+
         Hzel/lVwkUzYMMVr2sFTMGD2YKGGnh9kLdlXYGf8TEa9uXjf3FvPTcAijRCqg5yopDee
         XfiINW+YqdX6eHW2DkpVAOFtnXhLwflm+A0Vnqv/ZgR2xpZ7Lvuz/kgUEOPCXu856zJd
         BSFTsj7AqwtrSGuoMOWC/gNvmq0HnOdHdlyxNLSGM9c1ggqbodmH8zVl3vzvMiNU1KFC
         P3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jbcf6VzNSRswfVAJzhslqe74uX/sqqVaZwLWIej15ak=;
        b=tvix5WecHgIhrr917xesTZhjlS/lm1bGOkUGDkcflkee6HRuSk62RBBaxUQ2vVxlWY
         iNinG8FYSS+OeTBGFshrjgqqhBl4M9RTfcalcg1ceJb8v2VmqaRhAuw1jTE4D8rJFbxy
         uI18vAcPYdh3KIAaXbR84VxjmRzN7xCtkMLyEKHa6bLMpPtJgJbznLV7HI33XURcxzeB
         Hc6Oe+ig/KKGQ2mExlUH5Z0wCwgMXltYpru3yICvQCpAP8VnKQhA039xRAHiS7fCD8oS
         ySco6MAUF7xpTJslhgSBv3QSTaTy/3Ug076jg/6AC5W2mplra3bVcqqhwxyBgz5lFXdd
         My5A==
X-Gm-Message-State: AOAM533DjoFgvnr8sKBXPYWT77sBxLKiy3bOjGVOa+4VHXo1at/LfoLO
        TWOD5k0v4Cdte8nY0SMpKtg=
X-Google-Smtp-Source: ABdhPJypOctbEADcE3zZtSwyj/9Abb3gTvDTBSqoSub+cq91icYWJNr1cEBHjTB7KMw1Hc5rHsfr5A==
X-Received: by 2002:a63:595d:: with SMTP id j29mr7390004pgm.402.1602172590030;
        Thu, 08 Oct 2020 08:56:30 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:29 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 080/117] wil6210: set fops_pmcdata.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:32 +0000
Message-Id: <20201008155209.18025-80-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: dc16427bbe65 ("wil6210: Add pmc debug mechanism memory management")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 8c37af09a84e..6f1603304d52 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -952,6 +952,7 @@ static const struct file_operations fops_pmcdata = {
 	.open		= simple_open,
 	.read		= wil_pmc_read,
 	.llseek		= wil_pmc_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int wil_pmcring_seq_open(struct inode *inode, struct file *file)
-- 
2.17.1

