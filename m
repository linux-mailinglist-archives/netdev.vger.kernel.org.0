Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03873BDC7B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 19:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhGFRty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 13:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhGFRtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 13:49:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67B5C061574;
        Tue,  6 Jul 2021 10:47:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso2376706pjp.2;
        Tue, 06 Jul 2021 10:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6erUwCFFnTaWWqM4rwP7Ztpm31odO2WRQErzKFvC28Q=;
        b=flxeE2Y1rlYOh4W5bZd4TclIXmrvc6Jbkoji6hfqe5j9QVhp6rwHQJ6gPbL6qKZ+d+
         WkkSRHWPE3Xf6V3lcEIp2+xGyKXM3d3NrfFgta7vAZXFVWILjjnqa6/VebnOUp9xDQwg
         IeQt/ztE1lRrQP+5aIQFEXbxgQV+4i5/yZRv9yrxoKeXsGo5O6Dk+olz7V9wdTHoaJ/T
         WaOHUatcLjgOItYiL8qAaHlLZe1Vl5fK7RlY7qmWnolVlpE5OgVk0gSEV3tyubMECD+U
         uSZbFl22bcciVBva1f/3/m9mMw3XKxv51kifTovJVtyscHiwU+5v95WgnR1kXrVIUyQi
         gToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6erUwCFFnTaWWqM4rwP7Ztpm31odO2WRQErzKFvC28Q=;
        b=CBrUqq4BZ9OSVANUCDss4EalA5JGidsPwVA01vvJsc8PNApo36fDPv3L68Fpw1gT0n
         MVGiNHFBNTTO0ThkS6Yt/GEMhpYfhQiYptARaLA2NNnyLAkHQ+Zfq4KclmgohI5uGy1A
         6KmeGg8oZz4ocvt2diOnicmENBfJFyjUY8aM6KW7gB4c7rb4xgWUAqD++lE1Ax4iIfrC
         9b9dD0Rki/vzRa6uhLWAx0wTFPLSZSbLmAxkXYhloHLgSFY9zyeHJzkJOetczkcSdFiI
         +FkQPWOl5wkGZCwQsAdjl6qHXbLECVnD8X2DAM4rLWGgNKoa78YGDU3KD/c26kfu1xMD
         RWtw==
X-Gm-Message-State: AOAM5303g26RPFtiDGMGGvOK1xv1tKPcFSeUuWIoq9iiZdBc9fs8NkoS
        7gxKa+aEi5hUwKni6v2m3N4=
X-Google-Smtp-Source: ABdhPJxfduBeRwX56V9xhTrOZE8af4Xe9jGUs19+X8yJctbhtuH7L3N0bEE9GOPHjk0ul0BuV1wvSw==
X-Received: by 2002:a17:90a:8c87:: with SMTP id b7mr1605883pjo.230.1625593634222;
        Tue, 06 Jul 2021 10:47:14 -0700 (PDT)
Received: from localhost.localdomain ([103.82.210.28])
        by smtp.googlemail.com with ESMTPSA id x3sm17438440pfq.161.2021.07.06.10.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 10:47:13 -0700 (PDT)
From:   SanjayKumar J <vjsanjay@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     SanjayKumar J <vjsanjay@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] tools/runqslower: use __state  instead of state
Date:   Tue,  6 Jul 2021 23:14:09 +0530
Message-Id: <20210706174409.15001-1-vjsanjay@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	task->state is renamed to task->__state in task_struct

	Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>

Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
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

