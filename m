Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650D43BDE7C
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 22:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhGFUmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 16:42:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhGFUmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 16:42:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625604010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ujhLmOadg6wO3s9h7GHVfN4DbhqxzkAvQM9k3l8CkBg=;
        b=JBv6qQX0P72RQtLb80J6suUl+7Rl8ARTX8tkmd6y8FcWShZQRJ+QMDEZX5PJFwDhhq8D2/
        Mn4SIiSiQ36kOENDY5S4OIu4Tp6HR1Te3/mCjy2OrFGxpvT+fHsSgabZ0QZFgnQi6Tdf5W
        k/YMFM9odLPY/m44J8Sg1oqofJtJ0F0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-68RGEZk4OHOhLYNPdy5RHA-1; Tue, 06 Jul 2021 16:40:08 -0400
X-MC-Unique: 68RGEZk4OHOhLYNPdy5RHA-1
Received: by mail-wm1-f69.google.com with SMTP id l3-20020a05600c1d03b029021076e2b2f6so1244227wms.4
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 13:40:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujhLmOadg6wO3s9h7GHVfN4DbhqxzkAvQM9k3l8CkBg=;
        b=SxYo8KqXrSCyhTK3Ehdj1SpK5rteUf2P/LosOkwnHcOIZWhvdARIPr0LCbJrJg8bXT
         jJSF4rsejVA/ADsUjPZMqroTvF2j/EKjg1xy6Lcgg9x3Q76zOKWa1Ezzb8MYRtgm0Kbf
         UfwIC72sibC1Zz6JqJmDgoOFYjJ++b47RoM6cZhkYcToGKn4RfUMCyZICqcAa6tNI5wL
         KbV6OYFpQBCOSDXcMkHshL6CKXF4GyWmGNTjpvaKTbIycUCktBDIY8WExZwpLhoV6t2i
         vZZPUlAmtJuFMr2Ob4vxXv9uulVvSRJwiDIYNbRRA4tousiAhMcu6PHKZUxzD3/6jkVz
         rVpA==
X-Gm-Message-State: AOAM5317A8Ga8xgBnt++NCyW9N2d8cximNuRwnq7z7PwNlP/ID5P02v9
        BctZsJxfuKDNMh1i9FUkVvroxWU6/Lyhf+/7mXKVQdgWrPNAfWdwS6Qjo2MhrggscU91RMuRNcR
        hM6fLlmk2t3BcmzAP
X-Received: by 2002:adf:ec8b:: with SMTP id z11mr23948632wrn.408.1625604007618;
        Tue, 06 Jul 2021 13:40:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJwEylQpa+BTPO79eJ4kmX1c2XDvH8LmhE7iiVch/SjPxwsFe7HRlgV0fu3/zkZMI+8qY9kw==
X-Received: by 2002:adf:ec8b:: with SMTP id z11mr23948614wrn.408.1625604007444;
        Tue, 06 Jul 2021 13:40:07 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id b11sm18069833wrf.43.2021.07.06.13.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 13:40:07 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] tools/runqslower: Change state to __state
Date:   Tue,  6 Jul 2021 22:40:05 +0200
Message-Id: <20210706204005.92541-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The task_struct state got renamed to __state, causing
compile fail:

  runqslower.bpf.c:77:12: error: no member named 'state' in 'struct task_struct'
        if (prev->state == TASK_RUNNING)

As this is tracing prog, I think we don't need to use
READ_ONCE to access __state.

Fixes: 2f064a59a11f ("sched: Change task_struct::state")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
2.31.1

