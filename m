Return-Path: <netdev+bounces-4068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F336B70A6F9
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 11:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70D581C20A97
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 09:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC783D81;
	Sat, 20 May 2023 09:56:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDF1624;
	Sat, 20 May 2023 09:56:53 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219B2B8;
	Sat, 20 May 2023 02:56:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d3fbb8c1cso1209468b3a.3;
        Sat, 20 May 2023 02:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684576611; x=1687168611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nvQucCrYnD9qDZgDIXzYYSTjdKfzVHDZRdsJ/zonNo=;
        b=m6QzIjMyqr2ArCl+HPojqTYwNMmfA6u7dUniZztX6LJ7kURSDjb2d0gmzZUVu6y1ah
         3Y3on1FvvA+kIC/WJ123bZzdVy+PoJDKxUu/BUSiaBBxWUKswWFgIPusmg0oVf2SeDZE
         TsOxkq6ho4OES5ELwOvhA367mZYYex+o6v+vKr7KwQlzJL242EwV9iN40AZEj+W9VOb4
         Wrmwv3od43MPMkXiQcHZ1LhD8HwI3hgtpklNakKnX5Hfi8wCb8pYRl8xXY0sAD5uETxq
         l8G10vOoaHFw/c9yXUSehbFSdJbmgb/qGYfYljbBW8xzA82OKwpwA5SP6L3Bu4iX3a2q
         4eJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684576611; x=1687168611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nvQucCrYnD9qDZgDIXzYYSTjdKfzVHDZRdsJ/zonNo=;
        b=EwWLTVGEeJIv199TbONWgydaPu1jsoONor20P5MeIQxuG4xg3f1gx6f4ZDPRQBAfcp
         m7m0QbvU1e7Vb43wRH1ltSNrALpYLNIajGPaNd3mK8CEInEfWOHZ5iIOmAaKWITSDD6s
         s9ius0dM4Sc7sW0/vm7i8i+PBIdKmbIStUu277rYvr56DaQekKzkcJ7OnEO9BHzmzbtx
         SugsLw9eozi9Q2Ek7um0d+S5M4lriTzafeV4r42EhaXjV1E9Qs3hYndslXvTe5dTrO+m
         Ed/cDdNKD8mCWU6mAL5BOY6y25qkQmDz+x9dC5YRQeu7Iq7OtmJ10NHWh9dPa1R8Vin+
         sV5Q==
X-Gm-Message-State: AC+VfDxi2UnatTIaeE8TllQvC0G/YevNWF0CVT1i1DmVzGUt/fL9xvva
	jEqHrvkvs8abmJp7/Xeq/Vs=
X-Google-Smtp-Source: ACHHUZ68FRvELNasJW+XPAaN83BXINRQEvnpbspnmfbuSYFZBKx83WNNydh2f217lJQCJX4xYWv8iw==
X-Received: by 2002:a05:6a00:a21:b0:64d:2da5:4d2d with SMTP id p33-20020a056a000a2100b0064d2da54d2dmr6609122pfh.25.1684576611243;
        Sat, 20 May 2023 02:56:51 -0700 (PDT)
Received: from localhost.localdomain ([43.132.98.101])
        by smtp.googlemail.com with ESMTPSA id x22-20020aa793b6000000b006439df7ed5fsm981255pff.6.2023.05.20.02.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 May 2023 02:56:50 -0700 (PDT)
From: Ze Gao <zegao2021@gmail.com>
X-Google-Original-From: Ze Gao <zegao@tencent.com>
To: jolsa@kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hao Luo <haoluo@google.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Yonghong Song <yhs@fb.com>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kafai@fb.com,
	kpsingh@chromium.org,
	netdev@vger.kernel.org,
	paulmck@kernel.org,
	songliubraving@fb.com,
	Ze Gao <zegao@tencent.com>
Subject: 
Date: Sat, 20 May 2023 17:47:24 +0800
Message-Id: <20230520094722.5393-1-zegao@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20220515203653.4039075-1-jolsa@kernel.org>
References: <20220515203653.4039075-1-jolsa@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Hi Jiri,

Would you like to consider to add rcu_is_watching check in
to solve this from the viewpoint of kprobe_multi_link_prog_run
itself? And accounting of missed runs can be added as well
to imporve observability.

Regards,
Ze


-----------------
From 29fd3cd713e65461325c2703cf5246a6fae5d4fe Mon Sep 17 00:00:00 2001
From: Ze Gao <zegao@tencent.com>
Date: Sat, 20 May 2023 17:32:05 +0800
Subject: [PATCH] bpf: kprobe_multi runs bpf progs only when rcu_is_watching

From the perspective of kprobe_multi_link_prog_run, any traceable
functions can be attached while bpf progs need specical care and
ought to be under rcu protection. To solve the likely rcu lockdep
warns once for good, when (future) functions in idle path were
attached accidentally, we better paying some cost to check at least
in kernel-side, and return when rcu is not watching, which helps
to avoid any unpredictable results.

Signed-off-by: Ze Gao <zegao@tencent.com>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9a050e36dc6c..3e6ea7274765 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2622,7 +2622,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
-	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
+	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1 || !rcu_is_watching())) {
 		err = 0;
 		goto out;
 	}
-- 
2.40.1


