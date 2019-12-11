Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCE111BB57
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbfLKSP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:58 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42393 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731292AbfLKSPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:36 -0500
Received: by mail-yw1-f67.google.com with SMTP id w11so9297934ywj.9;
        Wed, 11 Dec 2019 10:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jVzqTcoV9ihUNXlm/a13Dm9aDWyETeZ13sWEGwD1aic=;
        b=NtNVRjryIU1yOz3tXrhTT6zcq3iqkIK1utZW9lxWZK6MPshWO4eNfVd9oYaOPjuJTu
         sCKJsFyfhOkOyVaI3KCVkpFQVq9cmkQlGsmB2uVS16iqO2Ikfs72Sd461n7QIcXszQ0b
         1tM25nlxRFPe0K2pek1xAqirJbv4buA8A3foLBGP3KvTrVO2sOY7Z2vpDxK5x8hu8JJn
         rlc1rpTr8o67clY1/XM+fzgZwzCwbSMFqAqa4h5hPaREdLHXH3lOiigwNCWhfwfodzJp
         gxDWpVpoAGzx9Ok0y4Z6pPtoZM/RYu3XPM8UhnqajU18E/NVtGa9pFYS+1OJ4EdBcupi
         Gvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jVzqTcoV9ihUNXlm/a13Dm9aDWyETeZ13sWEGwD1aic=;
        b=NviQQ453nFSVxh2RnW17ZwbXkz0gVIKUKGg0Cfb6onHmU9RbLe2VaZTpk+bhcd2/Rz
         pKwLLi4JIXGuDLSMgq8DagtULbqlaFpH0ydah18nwch4xwBEkwJF49VimC6n75MzG84I
         WKqwDgL/cgsXh24IQc1Aul8AIvkurZOp54/55ttEoz3nLe5Do633cfY1C509+SwAXNPQ
         OrBGHAAdnYdLM9xg8Z8MlfHPAiysXKmUD0S631+RUwaCqtT5UkQocJ8enS9cqWLKVRy7
         c8/x2JRXqdGMomF4R+qFIE8w/bicgEXGrRMsRpYZnh+Bjl6BDdJn/ouhlymGoV8mVFZo
         Ei2Q==
X-Gm-Message-State: APjAAAXD9GgoigeOMJxPerxm8LRnyRsX905FdWPYmheWOW/b37QMa/JO
        GnYVGxh9T2wxPS1al7Z7st4E0gY7SGdXsw==
X-Google-Smtp-Source: APXvYqzfB45c0sW3dCcvcx8Qka2iHzdUMjB5pZc/SOgr+k9z5AhMrOWtdBtRSNE077tosDfDPeUApg==
X-Received: by 2002:a0d:d84b:: with SMTP id a72mr856361ywe.33.1576088135104;
        Wed, 11 Dec 2019 10:15:35 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id b187sm1334218ywh.108.2019.12.11.10.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:34 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 20/23] staging: qlge: Fix CHECK: usleep_range is preferred over udelay
Date:   Wed, 11 Dec 2019 12:12:49 -0600
Message-Id: <a3f14b13d76102cd4e536152e09517a69ddbe9f9.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

chage udelay() to usleep_range()

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index e18aa335c899..9427386e4a1e 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -147,7 +147,7 @@ int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask)
 	do {
 		if (!ql_sem_trylock(qdev, sem_mask))
 			return 0;
-		udelay(100);
+		usleep_range(100, 200);
 	} while (--wait_count);
 	return -ETIMEDOUT;
 }
-- 
2.20.1

