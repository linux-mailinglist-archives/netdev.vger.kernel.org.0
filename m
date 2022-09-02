Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311E95AA5E8
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbiIBCbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbiIBCbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:31:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E544E85A;
        Thu,  1 Sep 2022 19:30:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t5so771532pjs.0;
        Thu, 01 Sep 2022 19:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=eAg0PZWl4zJUTIoBr/3Gv3urgLIcQ4VDCzv1IFZNeuY=;
        b=Gy+cv6XxxiYO3hr3Muw+hBZMy0efagnoQa+lkQO0z4mGYIW5CA1XBEpuraxfeAkfxK
         G8jIecWEoNFtvzfvGj7MUoaQaJt6vAiOKaeeaE0MPYK18/zDhN7V4FvEnghuG12f7i8k
         Wygblna21VTeaQ1/2AbJRacHSL9o97+r1sF9tnGeMEcckZfF2mRzApylow2eQjSffdB/
         hmzgT9VOAVh2e1R9frgjc8IuTH7PdBnGqPgwVc5a7Y0hMwIth/hwYmEVonEu1nG6Pnij
         zqNPwiEXu0QWL90ZfnVnEaOkufmAIS5nPaMLhxm/P9a6FaAONxHMU+n2OSgyMVpdr9Sa
         6ayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=eAg0PZWl4zJUTIoBr/3Gv3urgLIcQ4VDCzv1IFZNeuY=;
        b=xp9e6/I6n7dbfh1UHDdeMdd/D8FREr6xMkQi1Gs4cLRuyVUTFefilSTX5QM1Ujf5GH
         dFckr3h5hyUwTD4DP9clUwohVM3vbJpQlYhNMORHxHp1Fo1gr1VwohbzmvPHOJxhuwYg
         ivh7mrG+mzlaS2MjQib4BIdM92uLuTzFLZ9ZispBWe73JDatZ61RAfiKveDMM3D5vAN6
         4XMPoSOpxaLTg7NSM7eNdna3llDzDrrPAXYKwMIs+eN1qW/FL0cCYzUQ3mPun5AWHnQg
         vPRUGGJ5i5QebJaF+LFYYTJt7Kl6YXkZ78T1rITbLSdkJjbnx+5L8x0JunZxxE5u8nGj
         fw+A==
X-Gm-Message-State: ACgBeo2WxbyDOouPjEuk9v9nEcVVDCMs6R+YuIHykdrNhMrG3l7XD30x
        rTvxsustQ1N+jErlE9fj1JVd0IFZw9o9s8oPz/o=
X-Google-Smtp-Source: AA6agR4DsBfz/UK1tZcnfi/DCBBeE+JJsSZfcGsqqa8xiOuQfkFBNrN6XShqRSgVYStdq2UPWrbWLQ==
X-Received: by 2002:a17:903:2284:b0:174:8681:3f6e with SMTP id b4-20020a170903228400b0017486813f6emr25252605plh.5.1662085834206;
        Thu, 01 Sep 2022 19:30:34 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:33 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com
Cc:     cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 11/13] mm, memcg: Add new helper task_under_memcg_hierarchy
Date:   Fri,  2 Sep 2022 02:30:01 +0000
Message-Id: <20220902023003.47124-12-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902023003.47124-1-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper to check if a task belongs to a specific memcg.
It is similar to mm_match_cgroup() except that the new helper is checked
against a task rather than a mm struct. So with this new helper we can
check a task directly.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7a7f252..3b8a8dd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -887,6 +887,20 @@ static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
 	return cgroup_is_descendant(memcg->css.cgroup, root->css.cgroup);
 }
 
+static inline bool task_under_memcg_hierarchy(struct task_struct *p,
+					      struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *task_memcg;
+	bool match = false;
+
+	rcu_read_lock();
+	task_memcg = mem_cgroup_from_task(p);
+	if (task_memcg)
+		match = mem_cgroup_is_descendant(task_memcg, memcg);
+	rcu_read_unlock();
+	return match;
+}
+
 static inline bool mm_match_cgroup(struct mm_struct *mm,
 				   struct mem_cgroup *memcg)
 {
-- 
1.8.3.1

