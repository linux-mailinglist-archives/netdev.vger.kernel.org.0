Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53ECC3BE271
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 07:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhGGFSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 01:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhGGFSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 01:18:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4829C061574;
        Tue,  6 Jul 2021 22:15:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p17-20020a17090b0111b02901723ab8d11fso885650pjz.1;
        Tue, 06 Jul 2021 22:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83YwZmpzU74w3ZtikD2xpG+/J4125b1wtmYj9moQPzM=;
        b=fSYqpLtVed1yQRIPwB5WcEwHUPZWf1LzMrj7B1Yi+zZ37scvt7vPA55KNSOUZL0cax
         IKRHR+aSJGkFTE4ZAjV31tOQA0OPFnRHvDpe24OH0LY2v+sQyebu6hW7QjoDWIDk9PX7
         Lfwi2t1t24Im5+QvYbbD40S1UfdSE8JJLPckHLvqnQMeKzpaz4XZXCwDPQovBRodHd5r
         /hO2pUDh1z22dQ7HmsHtvjxZWXAdJsUj7KZy09BuXVJwsb7BDv9sgB2W+C/jLVoJyuA1
         g17yeHbmDQtpoKCkHvg5BKyktm/FhWpiuLe+6hvCGNFEgjTKckvYAp3SgrcWj1jiext0
         cmKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83YwZmpzU74w3ZtikD2xpG+/J4125b1wtmYj9moQPzM=;
        b=k1AODNOA5iE1f5hyz1jz4ecXag57RgIipKMX+SulwXl7keqcMqaIjwM5sjnXVnKfXn
         l8ORUvxn8MOAke3jytFtCgAO7OQx09jvgJL/KjSe1GMq+upMohR2KuVJmoMsLTfFvVTF
         ELBRRbpdiPe/dOg+xMqi50b9Rut+EmDjQ1tS7rZPcEEBwiq/WLqWf7XPCgmRBOtWHg/c
         6RD0+Rl9FcWLmIoWZPxaJFjd/jAVHSwlW8LrYnKdKGSlOUGsqb9d87GsxupErsUuWuOQ
         fRatzggg66iLWcPQPS6Jbv2Tf80QCjpumLEUcWSSko+BogaoosTg5nr4mvFYLhyf1z2c
         O6vQ==
X-Gm-Message-State: AOAM5325rmXtNn31yitGPU+lqkK1BvhwyJMYxS6eZqcein1gQlC4hzbs
        DWPoHpJggjUlQXI+ygxU7H4=
X-Google-Smtp-Source: ABdhPJzg5u57dc9OH/vomv7zLdG6smSfPJ9ZFK8u/HTdnW7x4j7jYECbZ8/QkkOul6e/je12q30RSw==
X-Received: by 2002:a17:902:e2d3:b029:129:70aa:990 with SMTP id l19-20020a170902e2d3b029012970aa0990mr16662498plc.34.1625634932065;
        Tue, 06 Jul 2021 22:15:32 -0700 (PDT)
Received: from localhost.localdomain ([103.82.210.28])
        by smtp.googlemail.com with ESMTPSA id b3sm18740371pfi.179.2021.07.06.22.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 22:15:31 -0700 (PDT)
From:   SanjayKumar J <vjsanjay@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     SanjayKumar J <vjsanjay@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v2] tools/runqslower: use __state instead of state
Date:   Wed,  7 Jul 2021 10:42:40 +0530
Message-Id: <20210707051241.20565-1-vjsanjay@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2f064a59a11f: sched: Change task_struct::state
renamed task->state to task->__state in task_struct

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: SanjayKumar Jeyakumar <vjsanjay@gmail.com>
---
 tools/bpf/runqslower/runqslower.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
index 645530ca7e98..ab9353f2fd46 100644
--- a/tools/bpf/runqslower/runqslower.bpf.c
+++ b/tools/bpf/runqslower/runqslower.bpf.c
@@ -74,7 +74,7 @@ int handle__sched_switch(u64 *ctx)
 	u32 pid;
 
 	/* ivcsw: treat like an enqueue event and store timestamp */
-	if (prev->state == TASK_RUNNING)
+	if (prev->__state == TASK_RUNNING)
 		trace_enqueue(prev);
 
 	pid = next->pid;
-- 
2.32.0

