Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8D4354E5
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 23:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhJTVHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 17:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTVHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 17:07:08 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851DFC06161C;
        Wed, 20 Oct 2021 14:04:53 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id p4so4452981qki.3;
        Wed, 20 Oct 2021 14:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NBtZyaRcZuY+f7pBAJrmHFQe7Ae2gn9Yyc4rNBSzPg8=;
        b=K6wWgyIvsbdjp+1GOBGO7qayM0t0sE9TAMdanybqAOSvQz9Q1aowhth2U8NrpS7+LK
         htHdlNW3rAtwdz48l+P4UCi7t1dAuSVu6KGU5oTK6HVHSzTJBCsoSsQYqu6b8nOT25Pz
         N4Hyp/gscSjcjkaFTRqk7yZ5jE7zTQC7hMDTeETIArbQM6jGY2xYqv99qggNyz8QcyXG
         9Ejg0MUNCfkbiXAw6HJBy86PKZGtzFNfizS3Wf1ofVtS8UXcWI+cFbYoEt7c9GSZ8PNr
         4wZxO4w1P37Er1+DodNyTNwV1YDTNs1aLyHXeEzh7lrjD9KjGqgoSr6OFFiC8mAREq3/
         jihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NBtZyaRcZuY+f7pBAJrmHFQe7Ae2gn9Yyc4rNBSzPg8=;
        b=puFnGFH5NMoaYeEqrwDIYR4YXar0RvWyALG5oRxF1G1IFBR2Nu6yVuB3rinhMlVBTD
         J7BI6vYgUMsE+PAfxJL3smbFZF/VoXEwXo5I+QvOPYxU3c8kdets5tNIMOk412yBbMiM
         Mjpt3wikDjc70mSUgFO96Fwv0zEKec+yK1VHzAd7hrsqXuBkOzk+fSwPynNu69HjoPGz
         Qxzpw3OfhjHPG/4Lr8JwnywZYqSp5zbDUbxScBjsnrFCq7whU8CoV9/wRbxOT7X1pCBR
         slDo2zk+Zz/gKBn+fnrEgnsmSbrKSc2zpPYG/qDGQO0rHwoueF4ilcwFKd7OklJA8CDv
         gRIg==
X-Gm-Message-State: AOAM532g44AGfaZADNNkeqsJCTj7dihqQ7kWeQGBMvq0JdEI1TOTPRnN
        5fAKyK59SLjdzoCkH7gus7eH0NSy758=
X-Google-Smtp-Source: ABdhPJyO+dcON8cy/qhZWT3UkXgew/TKd5zF1ERes2sq1jyxsvrBe1wInQ5sNDsC0tm4TUqHv3U8sQ==
X-Received: by 2002:a37:d202:: with SMTP id f2mr1188139qkj.317.1634763892325;
        Wed, 20 Oct 2021 14:04:52 -0700 (PDT)
Received: from nyarly.rlyeh.local ([179.233.244.167])
        by smtp.gmail.com with ESMTPSA id h20sm1575267qtx.10.2021.10.20.14.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:04:51 -0700 (PDT)
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     linux-nfs@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thiago Rafael Becker <trbecker@gmail.com>
Subject: [PATCH] sunrpc: remove unnecessary test in rpc_task_set_client()
Date:   Wed, 20 Oct 2021 18:04:28 -0300
Message-Id: <20211020210428.567364-1-trbecker@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rpc_task_set_client(), testing for a NULL clnt is not necessary, as
clnt should always be a valid pointer to a rpc_client.

Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
---
 net/sunrpc/clnt.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f056ff931444..a312ea2bc440 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1076,24 +1076,21 @@ void rpc_task_set_transport(struct rpc_task *task, struct rpc_clnt *clnt)
 static
 void rpc_task_set_client(struct rpc_task *task, struct rpc_clnt *clnt)
 {
-
-	if (clnt != NULL) {
-		rpc_task_set_transport(task, clnt);
-		task->tk_client = clnt;
-		refcount_inc(&clnt->cl_count);
-		if (clnt->cl_softrtry)
-			task->tk_flags |= RPC_TASK_SOFT;
-		if (clnt->cl_softerr)
-			task->tk_flags |= RPC_TASK_TIMEOUT;
-		if (clnt->cl_noretranstimeo)
-			task->tk_flags |= RPC_TASK_NO_RETRANS_TIMEOUT;
-		if (atomic_read(&clnt->cl_swapper))
-			task->tk_flags |= RPC_TASK_SWAPPER;
-		/* Add to the client's list of all tasks */
-		spin_lock(&clnt->cl_lock);
-		list_add_tail(&task->tk_task, &clnt->cl_tasks);
-		spin_unlock(&clnt->cl_lock);
-	}
+	rpc_task_set_transport(task, clnt);
+	task->tk_client = clnt;
+	refcount_inc(&clnt->cl_count);
+	if (clnt->cl_softrtry)
+		task->tk_flags |= RPC_TASK_SOFT;
+	if (clnt->cl_softerr)
+		task->tk_flags |= RPC_TASK_TIMEOUT;
+	if (clnt->cl_noretranstimeo)
+		task->tk_flags |= RPC_TASK_NO_RETRANS_TIMEOUT;
+	if (atomic_read(&clnt->cl_swapper))
+		task->tk_flags |= RPC_TASK_SWAPPER;
+	/* Add to the client's list of all tasks */
+	spin_lock(&clnt->cl_lock);
+	list_add_tail(&task->tk_task, &clnt->cl_tasks);
+	spin_unlock(&clnt->cl_lock);
 }
 
 static void
-- 
2.31.1

