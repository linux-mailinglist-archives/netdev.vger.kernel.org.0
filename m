Return-Path: <netdev+bounces-494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E60716F7CC8
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72F1B280F6C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 06:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7A61C33;
	Fri,  5 May 2023 06:08:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8F9156E6
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:08:40 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDE5156AC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 23:08:38 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-643a6f993a7so50496b3a.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 23:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683266918; x=1685858918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7C20rBcEh3cAfso5jQu1QmHL5lObnDPQWRkOZKxQqE8=;
        b=aCjs3eokidHRDOJ65bGqvCTp6GXK85bI3258yAC6sRba6/MNWI0XC1U4nmwkdoo8EM
         tHE4IiNGDGUI9q1WlaBMawMPx+NKD+NnfPcKRViMQ1schl8MsvM2qX2INUuf+wWi4IaV
         rux/bHLR+hVYinq2hCtS+6dEW7Xcs5Zi7vJtKgSivKXanPHU5ii+I0wqq9igViIVwWRg
         4POocdwymwlnxK7bY+yLGi5+vLYb4EHKGTefpQAbIbNPe/Gm9f278INbRfctAG+lKKwB
         ozxIDApYZcrsb4VGJP2tW5LNuDDDrubtlnR5ObzZR0Clm/jthJx0twM2lyIabUqPszx3
         eCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683266918; x=1685858918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7C20rBcEh3cAfso5jQu1QmHL5lObnDPQWRkOZKxQqE8=;
        b=a6mfj9Q1pz9zfxV7BRk+uxzX742GwsOf5uy0sVdZ+Gw5xnyWu0TQyRR3t2gCUeoPG8
         glYLpc5+1tXYGGiCm8veB1BUYSTtcnvhhtqVfcfjbZ7z+jXCARRJ/HigUbdukLt0s/CC
         36jWtuo7YA7B8Z89eyD0TxfGPIjW9nC8hAw4ukiivSu9qXJYV8LB3heIaytMTLan8+pY
         CQNCjk0VPmTUoA9EYV7a7jxOxaDNbo/LT7zSChqWeoY1Kzcq3oLRMUniJ3ZUDNSJKP1j
         p8W2G0qan7UkI/kuYURISMB9x9f61enkwsyWBTtSc2oL/qZJqJU9zYNst3cj26PTvrf1
         d39g==
X-Gm-Message-State: AC+VfDxI8SbrADT7UdxqcxDNBKkPYBQoeAVeEmqG4/FV0N2GZE1Tr3Mt
	Ycn3NhYeIgsCPhfQp/6U4JSNgA==
X-Google-Smtp-Source: ACHHUZ5gtaO5JTYYfNXFyw54OTQwvEYNc9PZKU25GXUmk9h/DvCCtYm6bZI1ghpCcxMK81zCaSU1Xg==
X-Received: by 2002:a05:6a20:e611:b0:ef:957f:5a2b with SMTP id my17-20020a056a20e61100b000ef957f5a2bmr398112pzb.48.1683266918042;
        Thu, 04 May 2023 23:08:38 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id a15-20020aa780cf000000b0063799398eb9sm762160pfn.58.2023.05.04.23.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 23:08:37 -0700 (PDT)
From: Feng zhou <zhoufeng.zf@bytedance.com>
To: martin.lau@linux.dev,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	song@kernel.org,
	yhs@fb.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mykolal@fb.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	yangzhenze@bytedance.com,
	wangdongdong.6@bytedance.com,
	zhoufeng.zf@bytedance.com
Subject: [PATCH bpf-next v6 1/2] bpf: Add bpf_task_under_cgroup() kfunc
Date: Fri,  5 May 2023 14:08:17 +0800
Message-Id: <20230505060818.60037-2-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230505060818.60037-1-zhoufeng.zf@bytedance.com>
References: <20230505060818.60037-1-zhoufeng.zf@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add a kfunc that's similar to the bpf_current_task_under_cgroup.
The difference is that it is a designated task.

When hook sched related functions, sometimes it is necessary to
specify a task instead of the current task.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/helpers.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index bb6b4637ebf2..453cbd312366 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2149,6 +2149,25 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
 		return NULL;
 	return cgrp;
 }
+
+/**
+ * bpf_task_under_cgroup - wrap task_under_cgroup_hierarchy() as a kfunc, test
+ * task's membership of cgroup ancestry.
+ * @task: the task to be tested
+ * @ancestor: possible ancestor of @task's cgroup
+ *
+ * Tests whether @task's default cgroup hierarchy is a descendant of @ancestor.
+ * It follows all the same rules as cgroup_is_descendant, and only applies
+ * to the default hierarchy.
+ */
+__bpf_kfunc long bpf_task_under_cgroup(struct task_struct *task,
+				       struct cgroup *ancestor)
+{
+	if (unlikely(!ancestor || !task))
+		return -EINVAL;
+
+	return task_under_cgroup_hierarchy(task, ancestor);
+}
 #endif /* CONFIG_CGROUPS */
 
 /**
@@ -2400,6 +2419,7 @@ BTF_ID_FLAGS(func, bpf_cgroup_acquire, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_task_under_cgroup, KF_RCU)
 #endif
 BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
 BTF_SET8_END(generic_btf_ids)
-- 
2.20.1


