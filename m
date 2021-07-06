Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FE53BDD08
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 20:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhGFSUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 14:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhGFSUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 14:20:47 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9D0C061574;
        Tue,  6 Jul 2021 11:18:08 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d12so20255355pfj.2;
        Tue, 06 Jul 2021 11:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qx6QiP+4kuEbxagrlaWL9/eZ/enyZLHEV5v5WGI0cjI=;
        b=UowYyArobY7mNsjbc5ZSJZCLfZES3EZLEgbfyJ6/CAWhFmdsOYckZbHcR6mcg3e4V1
         WjkJSZZ6ELmBPa+uULQwRFxrGmBE2a7G6AJ2mZQ6UlRmEjIkHQHS8h3hO8DzWbYoD/vt
         NBbe430F3pxZ8uWz2CSZde2g7YO8uIX5l/UoUMRXSzrNFmnJzRxh3Ps6qc4eCbqqyUnm
         Y6QO7QoiJKTBSYjS7anfIC0SDg4AhMKgM7w9IF4wTcDoetiHtUpML3dLdfWy0R84W3G9
         y9sTQBKiJBn4jLGu6wZcdE+rK5NuUL3WQ9bpAYrDaDHGghqH5tcxLfCe6iHKFCX7uXgZ
         PeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qx6QiP+4kuEbxagrlaWL9/eZ/enyZLHEV5v5WGI0cjI=;
        b=mtdlARp9P/NvK/mOU3PmNFj1PhrPmVhkpuv+NnsGiB+0UbIpO8XrwZtD44i57/rSOM
         MeobFDvk5DXemxV6vp1Xm4xaDYXWR3YOXHyCTEMN+rX8mSwe8I5PMVzUW/gSYy8X7h8/
         hMBjC2ZultUq55/5CI8ZdwRRjlFkXKib9uhL/78xN/7PZy7dx5Qtvd9tilN67RhJ/wPg
         T/wiCbIBPDvO9JBTgUc0RKWU4FJz7yaDTTdjWQzoe4DfIMIj3lhz1pT0aZtFYrPinQA+
         iI9rzwAlPIUkY1s6n+nfteIa92MChcdCdvgn4r4IZHJkYhb9djoQff/IMmyiFtJLHBun
         +c+w==
X-Gm-Message-State: AOAM532KxGb47yp0O2aShRU37cQS+YPF8DabHpJ6eWXQmSf4fowA+aMW
        oJ72GIFVyyDEauAZdkNtbQQ=
X-Google-Smtp-Source: ABdhPJys2kVTdNWEHyNRcwosW4og2PsTt0vl4HYbWJpOSqyokmEVKbDvoBcaPY5pnvOvOQZGCwpEOg==
X-Received: by 2002:aa7:9407:0:b029:31c:c870:4b05 with SMTP id x7-20020aa794070000b029031cc8704b05mr15092714pfo.23.1625595487790;
        Tue, 06 Jul 2021 11:18:07 -0700 (PDT)
Received: from localhost.localdomain ([103.82.210.28])
        by smtp.googlemail.com with ESMTPSA id em8sm3586496pjb.39.2021.07.06.11.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 11:18:07 -0700 (PDT)
From:   SanjayKumar J <vjsanjay@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     SanjayKumar J <vjsanjay@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v2] tools/runqslower: use __state  instead of state
Date:   Tue,  6 Jul 2021 23:44:55 +0530
Message-Id: <20210706181456.17321-1-vjsanjay@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	task->state is renamed to task->__state in task_struct

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

