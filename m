Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA4F2878E0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731829AbgJHP4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731801AbgJHP4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491F1C061755;
        Thu,  8 Oct 2020 08:56:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b19so2977038pld.0;
        Thu, 08 Oct 2020 08:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qbkarZQM53mxMl1JPcJCtuTCfkMkm2hQaoEbnziXsJs=;
        b=njBRjwT+ifM9fNClCVdoMvmlxXLODkTJyCgOS9MonDCmEW2Vq+PEWuVeaRGmJyNLH+
         UIi/PpyOnmAXScq406tV3TeqIJ8Sg1UxGEmHoRXaledUbz9RBsId+wiCk6D7I+aTF5j9
         h3kAJFpZ+y3W4i8LMGvRADrTBOx5iVZAghWUNOFunzygTVE94YwzFs7frdhK0u8oGdee
         hZNmIvTorxbKw4peBXZs2IlcVToACD98NsvR2wYl0LcFWxHJDocO77O9cp0HCEakrWna
         dy+lJCYZ7F44Nze5sXqp/ZIzjX9x5xp1yAeQCOAg2nWp3OYQYc1riTXV5wI//H0SNElj
         labg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qbkarZQM53mxMl1JPcJCtuTCfkMkm2hQaoEbnziXsJs=;
        b=GVIJcfPaE2AIMpZpSdxUa6AAKexemeM1ApRK/4BYzkvQYOSS55Egz/wXrhdF93ilZQ
         Rle0MgN8qGhwf+Qw72Yx9TcImVkyM0Hpm/nj/vBvvmyor3ApmK0kDQlI5pBNj9zWUyuB
         c1m2tWeeLO65HIKHgh3PRpY3B1XtW2t5PyJ/EmKetBN9fVyPjPovxre68wWnxCmsIuyD
         fJabuSEK1Vqh7MEdvL2rS7YrbjzUE7paUG+kolhDV1DwCAthi0PPPpyyttm2MKMYyVvz
         UvYRxZTv3g0bESpLgprr+RGITfI5/i/6fTKdHxMqMEDAKn5kfMkaOq99zp9UOmWigqtc
         TidA==
X-Gm-Message-State: AOAM530F5X3FsRObbw5pGVhg2qpXpBzvCuYRNFw5PkBPLNBFULzgHisJ
        W/yTF8NAHpG/ufROT82VqEk=
X-Google-Smtp-Source: ABdhPJxzYKVgqo6uHZe6L1BrifmIjew1sQPXgqfzkHrben7znLczHWiEe5sDOoP5f2RERIh+RK7wIA==
X-Received: by 2002:a17:902:9a8d:b029:d2:4ef:a1fb with SMTP id w13-20020a1709029a8db02900d204efa1fbmr8370220plp.4.1602172580839;
        Thu, 08 Oct 2020 08:56:20 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 077/117] wil6210: set fops_rbufcap.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:29 +0000
Message-Id: <20201008155209.18025-77-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c5b3a6582b1e ("wil6210: Add support for setting RBUFCAP configuration")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 914954cb9b0b..6c00d57e743a 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -769,6 +769,7 @@ static ssize_t wil_write_file_rbufcap(struct file *file,
 static const struct file_operations fops_rbufcap = {
 	.write = wil_write_file_rbufcap,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /* block ack control, write:
-- 
2.17.1

