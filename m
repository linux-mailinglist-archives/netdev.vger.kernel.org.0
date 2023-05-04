Return-Path: <netdev+bounces-240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB676F6335
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 05:15:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BBCE1C210CF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 03:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F78EC0;
	Thu,  4 May 2023 03:15:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A607C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 03:15:35 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FD02690
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 20:15:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1ab01bf474aso31151885ad.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 20:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683170133; x=1685762133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4couG4BvY3JielUUZmpwOAXPZt7eiYYa/cnyqJtYMcY=;
        b=RdIpHuXrIdZdrLZD5GQY5cDg6P+FgWa4EpLYMB+eMiwXeySE3PqhoXIEbj9y1HswHy
         FdZb8DebR9Ai3PUYWSWIfBQEbv4DIt3NpKTPNECZWgrNWKx1lnbcg7fCbOyhrqjXxWw9
         St42hO8jXLTQzCsp479eSYDbAeu0RmqscYkFgEUasmQeV8N4t4pGq4RrWm9AAnrwQ23a
         KQbah8ecHaW31WzSFNFNT7cSMeV3J7hlftVN/TR07lQXMrTzO0TUbI+LGcHQzeUMWKZ8
         efaSbI+l43x5sZvhbMzMOBUK+XJV7SOQ8GSkA/KtqVuZ/HIscRkB8O2MAhUNNDDMfYP0
         BiIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683170133; x=1685762133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4couG4BvY3JielUUZmpwOAXPZt7eiYYa/cnyqJtYMcY=;
        b=YuvwHaKaZGvZds5PrFP8gwehBDu2tSfrPXM1T5X7arkW8f8u4h0bMZkX5NhsDnwft+
         /C65Gijk7bM9p8at+NXfjiyRb2BTOlR5uBpKX9Ke/eKY/jPeqGbcGcXlydbtBzdxaRgL
         /Wh8vV2wQjNhed+qLOM/pOddKSY3drT2x5ffygEjPVCAuFAKJdRb86keIGmeGeq07kj7
         2qtXyX4/Ld+41RXWwuILuemrb6Zvpq1u47yEp448n1jnbPhyAT3u71RMzl5KZs+597zf
         ni3WH0htKv1NDhtaLUgbPEjl/KrxJyNJunLEDHBmvmv7kge7y+AVt9tCvsIOoqdQkf+r
         /Mzw==
X-Gm-Message-State: AC+VfDy/vqkFGesseEASDiilEFnQlkFgeTYacNV1kg0fOtOZZqc6KUj4
	m451AAU1m+JAcSYJK2hhDTU4nQ==
X-Google-Smtp-Source: ACHHUZ6AjhdkvWkT8w6Mj92ZHNvWQaJQGVrTeNa+kPUUJwxK5WvIueleFWkG5v9xszzcYw/nCiJ2Wg==
X-Received: by 2002:a17:902:7444:b0:1ab:ab1:f8aa with SMTP id e4-20020a170902744400b001ab0ab1f8aamr2135234plt.17.1683170133183;
        Wed, 03 May 2023 20:15:33 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001aaecc15d66sm7146121plb.289.2023.05.03.20.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 20:15:32 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 1/2] bpf: Add bpf_task_under_cgroup() kfunc
Date: Thu,  4 May 2023 11:15:11 +0800
Message-Id: <20230504031513.13749-2-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230504031513.13749-1-zhoufeng.zf@bytedance.com>
References: <20230504031513.13749-1-zhoufeng.zf@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add a kfunc that's similar to the bpf_current_task_under_cgroup.
The difference is that it is a designated task.

When hook sched related functions, sometimes it is necessary to
specify a task instead of the current task.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
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


