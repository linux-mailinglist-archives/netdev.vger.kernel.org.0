Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D1F58931
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfF0Rqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:46:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46552 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfF0Rqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:46:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so1329832pgr.13;
        Thu, 27 Jun 2019 10:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=37BMwxt5kwYAV/kb6ST+XvdcJZjJDKq8zOt7/ThJvGc=;
        b=jV/4ofJk4IW/IDJ0sBCoiOUI8/i/qpmoVX6XHyawXcQ9vlpMKRT6Cf4n8G9toWXOa/
         OX59islbrBgpLkHEST8EX59dsSnluFuUMnoc8GpLaIQZtTwlJccjy5uKAu3LFY5dqVNw
         s4mzVpiQAmq5wJ6BBkLhS1pJ7cf6tl3QHyRcaw2PLDPfcjAj2piizSNXT6U4q+9MsZjW
         IFsvNxcQ0UWL+A3Qn4meJL5Gj+mvRsoC07c2lgAONaUIOIxIzGQC30bpPpGXXDR6puZC
         3vNP1xfR0Lvfj1bcV1MvWjPW6nYokJRWCSKAuRpEIrf4UOzjxzBsde+dWZb4s5k1co+h
         wHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=37BMwxt5kwYAV/kb6ST+XvdcJZjJDKq8zOt7/ThJvGc=;
        b=fbQf4vTJWUw43FjtbURUyMMAFckHMfpbI6Bk/2CmCFUKVG4WJ9Wmy5P/ITUS9/4Gc2
         CrGRt58t0k/lA4Rjx8Gr5lGCgHwfMOe6pJdn6eP7v85kiTkuEV2Sn3NmCtFKNbo7BuDg
         lN40joLZgPavOzBoqivaL+ZIk9O89pfCqwLZd8vWIAbZiJNEO7YPEhb7198T0S5wfS46
         4U5sSVsISZYYW35cwyUjC/ukhZi6w9Wk690qphdjaiRFgetXibjWHyyHCbb8AcWe1OdU
         n5W1S9MpsAE2w83mIcAgBFg7fhGWHtgqDnGee/II3JwJpuSKqV8/A4Jl8tzrHjWn65Dl
         r9IQ==
X-Gm-Message-State: APjAAAWE6KyJ/zggKpSKX+pkGPO5pfM5SlJp2df7HMlmur+9lDy10Ph5
        ZNnJ/Fr3fRtLMGWn2J+pNEGpa+FihVb3ig==
X-Google-Smtp-Source: APXvYqy24jJzhy+BDGA8o9l6esxSc38xtCqWTUe7dKy5zeDW+4NIhz9Zx9ODQDScd+E1W7z0rUr1cw==
X-Received: by 2002:a65:6210:: with SMTP id d16mr4857854pgv.180.1561657598556;
        Thu, 27 Jun 2019 10:46:38 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id k6sm3496547pfi.12.2019.06.27.10.46.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:46:38 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 72/87] ethernet: chelsio: remove memset after kvzalloc
Date:   Fri, 28 Jun 2019 01:46:29 +0800
Message-Id: <20190627174629.6421-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kvzalloc already zeroes the memory.
memset is unneeded.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sched.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index ba6c153ee45c..60218dc676a8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -207,7 +207,6 @@ static int t4_sched_queue_bind(struct port_info *pi, struct ch_sched_queue *p)
 		goto out_err;
 
 	/* Bind queue to specified class */
-	memset(qe, 0, sizeof(*qe));
 	qe->cntxt_id = qid;
 	memcpy(&qe->param, p, sizeof(qe->param));
 
-- 
2.11.0

