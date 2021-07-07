Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A49D3BE29F
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 07:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhGGFfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 01:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhGGFe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 01:34:59 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9EBC061574;
        Tue,  6 Jul 2021 22:32:20 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m15so424914plx.7;
        Tue, 06 Jul 2021 22:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83YwZmpzU74w3ZtikD2xpG+/J4125b1wtmYj9moQPzM=;
        b=klebjjaAoAAz1lf+GXGQOtVnKnXruBHZldHkLsoIBo4eXaDKckXVlpYvUCO56hmZi/
         +Vd/CCeG64DtdXnti8yX8eIsx/VBz3XxhcFszreiW3iq617NnWxaKNUSVFfuwyC1Nomz
         PXFCdPvjC4BIoBR4/VOlNha1YO61CNJ7HxjAzaDQFP8fUVRhy9sQxyNQfl8pf5ypYXvk
         yufBL8oU5vuUPrs03RQas4r2rTIGHG5/MVia2jBzCgFWfyC5vjJeqe932Nv4mwo6iu1G
         QT5PgR1xvsm2d4/S7FomPV6IQhxUjt1yZwEV3K04pkCtGvi+hvAVa8EAR3Ou9iHVbXno
         j5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83YwZmpzU74w3ZtikD2xpG+/J4125b1wtmYj9moQPzM=;
        b=McEK8zaxwfncEeGngLnbgPwwZa8dalVljFZgjIuqTFMmNs/Qo6lDDe/Ald9pauxgFw
         621EGTL98nHs1kDCqYmwYRhFt+dLJJ//FdIPnE9nqL6nTy2Y/wjZPBbq4NjI6fNoYgxr
         zCB3Kcz0D76SLRD6BpxUknk05EhDXt71Bd8/QRylnpPEA0dBl9Kbhd5nHt7/vEwKOIVk
         LLJZNw/lV/ZdisHzbyMBJ9nKS86pAhF0vkrj4w6yrgaeoORvp5rEz3PNCTKX6WeWLqSR
         oFn2FDw82t5LZIZnXP9YEOUtjKlbmlm54aYSeumbXBk4Fu8UdA3n+6vD0LLK0uu81vf9
         3tuw==
X-Gm-Message-State: AOAM533hjp4qcUvsgH+/+VfXcop/Mp/dxuV5w1o1ur2xB/mnwtGnBPQq
        V0ISjm7c/n5/bjytQXLU8rU=
X-Google-Smtp-Source: ABdhPJzX9qx/yrzjLVdj0ag6ntNC+so2JgAwNPQpeQ7LPnuOI4B6UpzaGn8I67v7XuZa2EnRQGyn2w==
X-Received: by 2002:a17:90a:3c8d:: with SMTP id g13mr4227265pjc.229.1625635939826;
        Tue, 06 Jul 2021 22:32:19 -0700 (PDT)
Received: from localhost.localdomain ([103.82.210.28])
        by smtp.googlemail.com with ESMTPSA id a124sm8933384pfd.60.2021.07.06.22.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 22:32:19 -0700 (PDT)
From:   SanjayKumar Jeyakumar <vjsanjay@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     SanjayKumar Jeyakumar <vjsanjay@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v4] tools/runqslower: use __state instead of state
Date:   Wed,  7 Jul 2021 10:59:14 +0530
Message-Id: <20210707052914.21473-1-vjsanjay@gmail.com>
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

