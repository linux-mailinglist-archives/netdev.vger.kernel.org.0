Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB87441D045
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347794AbhI3ABV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347432AbhI3ABQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:16 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AE9C061768;
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w19so3325346pfn.12;
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4PTpmgAFg0UNVhldJ9dMxFSqlVavgp/QBbigaN5B9RA=;
        b=MzAN2uZwoXZcwDu3CiYsf/yNtPZ6SuqO9MQo61gdPkJG6F/3qJigIN4NEcdawCsNVG
         LcjlHStG2fwmrmDeR4yWx4bQyYUtFxhG+Jd/7V3hA7EU9WZ8hbcP1ugzIUg4gtJyaJBV
         nWaJqfUK1bY+qSMUjFMR7NQfbMuk24jVB3dCNbUTuYuvacqZOt769oWbUHfbUj8g8jCP
         TDvHTqXByeLWJBgK0Y0ytROd3yHU1kRALhzE/35MaKkHVamkKhpPWidaFqygWOLICBFt
         bA4i9ylx473ySQKQoTf6n3nMqNiaWs/8WK6I9RUbVKFRpq6qJbvt4GvoIgXjDU9CFCu7
         wERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4PTpmgAFg0UNVhldJ9dMxFSqlVavgp/QBbigaN5B9RA=;
        b=4oRuOrYpVbF3EOyB0Hok/MhvVnTbovMWa9w4A5voOpyRxY03aVp5n+EPRkuC6kuLVu
         oh1EOsWwnVuKMVjN5S4yvykZnt6e34I84QWAP4qj69jAyh5aaI+4TzHz1vY9ol2wtH7v
         Nvfhrj96ocwgUc9ha34cTU4PBG5l0+D/skdCdu0yvLYl2TiwRtJKd3WSqvHBniBoCooH
         0TjeMEuL4YTeo8PnG+d4SYVqvlk/Dbj5WbfQ6OpomDTzp4DAJkjK47ZMKL2woHQbhJ7k
         ySisWXSwzy0Mho9LD2vRoo9jASCGFiU6LWqfF9NJqPodDJBStr3OyH/JmSZCAct/u1bA
         PB2w==
X-Gm-Message-State: AOAM5315ArS5poB9l0QyNoIM1gZki8tYiJVRCaoYSdgndcAMZ9oDTSzj
        MMYwxjRlmi5eZJuA1n1Zzw==
X-Google-Smtp-Source: ABdhPJyEQBvrbMdmyp3fW9T9eYrul/7Ph2LJfeRoQLNHvFaYaYkEF8sCPbJZVY5Bw4vGyBmkUZRhbg==
X-Received: by 2002:a65:4008:: with SMTP id f8mr2233626pgp.310.1632959974848;
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 04/13] bpf: Define a few bpf_link_ops for BPF_TRACE_MAP
Date:   Wed, 29 Sep 2021 23:59:01 +0000
Message-Id: <20210929235910.1765396-5-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Define release, dealloc, and update_prog for the new tracing programs.
Updates are protected by a single global mutex.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 kernel/bpf/map_trace.c | 71 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
index 7776b8ccfe88..35906d59ba3c 100644
--- a/kernel/bpf/map_trace.c
+++ b/kernel/bpf/map_trace.c
@@ -14,6 +14,14 @@ struct bpf_map_trace_target_info {
 static struct list_head targets = LIST_HEAD_INIT(targets);
 static DEFINE_MUTEX(targets_mutex);
 
+struct bpf_map_trace_link {
+	struct bpf_link link;
+	struct bpf_map *map;
+	struct bpf_map_trace_target_info *tinfo;
+};
+
+static DEFINE_MUTEX(link_mutex);
+
 int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info)
 {
 	struct bpf_map_trace_target_info *tinfo;
@@ -77,3 +85,66 @@ int bpf_map_initialize_trace_progs(struct bpf_map *map)
 	return 0;
 }
 
+static void bpf_map_trace_link_release(struct bpf_link *link)
+{
+	struct bpf_map_trace_link *map_trace_link =
+			container_of(link, struct bpf_map_trace_link, link);
+	enum bpf_map_trace_type trace_type =
+			map_trace_link->tinfo->reg_info->trace_type;
+	struct bpf_map_trace_prog *cur_prog;
+	struct bpf_map_trace_progs *progs;
+
+	progs = map_trace_link->map->trace_progs;
+	mutex_lock(&progs->mutex);
+	list_for_each_entry(cur_prog, &progs->progs[trace_type].list, list) {
+		if (cur_prog->prog == link->prog) {
+			progs->length[trace_type] -= 1;
+			list_del_rcu(&cur_prog->list);
+			kfree_rcu(cur_prog, rcu);
+		}
+	}
+	mutex_unlock(&progs->mutex);
+	bpf_map_put_with_uref(map_trace_link->map);
+}
+
+static void bpf_map_trace_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_map_trace_link *map_trace_link =
+			container_of(link, struct bpf_map_trace_link, link);
+
+	kfree(map_trace_link);
+}
+
+static int bpf_map_trace_link_replace(struct bpf_link *link,
+				      struct bpf_prog *new_prog,
+				      struct bpf_prog *old_prog)
+{
+	int ret = 0;
+
+	mutex_lock(&link_mutex);
+	if (old_prog && link->prog != old_prog) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
+	if (link->prog->type != new_prog->type ||
+	    link->prog->expected_attach_type != new_prog->expected_attach_type ||
+	    link->prog->aux->attach_btf_id != new_prog->aux->attach_btf_id) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	old_prog = xchg(&link->prog, new_prog);
+	bpf_prog_put(old_prog);
+
+out_unlock:
+	mutex_unlock(&link_mutex);
+	return ret;
+}
+
+static const struct bpf_link_ops bpf_map_trace_link_ops = {
+	.release = bpf_map_trace_link_release,
+	.dealloc = bpf_map_trace_link_dealloc,
+	.update_prog = bpf_map_trace_link_replace,
+};
+
-- 
2.33.0.685.g46640cef36-goog

