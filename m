Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6023741D04C
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347804AbhI3ABY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347762AbhI3ABR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:17 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F913C06161C;
        Wed, 29 Sep 2021 16:59:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k17so3349129pff.8;
        Wed, 29 Sep 2021 16:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IQ2xKdYcP9q4jQcFOkGGPy8l9c2JA81WJZphw/+FAi0=;
        b=M0Nv6Io6KyhaM4SmDdFgul5uZu4KQcRpN2G4zwZUshrqkBwRODKgs+DhY7meEoaPzs
         RliAa2iUDsziOugnTCzwOW5kKUcg91APqd62StSDFIo7jjNsRFoWcKrIqzzWofjJG9yZ
         fCpVvL6BPP7AY23ynIVIrCSUUqgRaJqXqWrVCZAmBFaleL3+7WIqPlxXsIwc1np6I1A1
         RfOtnq5aU9uiGYQBFn8EvdZLsnsPP06w4J3GQfTymNM+yodFT0YhYcEe3iKkBFkrpJ/g
         FPsDoKbveSVSSU7izw4LKBduMcnANMDuuCqkwqIrjXo3naE5oGUxZcsPgcug4a7Kdh58
         2y8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IQ2xKdYcP9q4jQcFOkGGPy8l9c2JA81WJZphw/+FAi0=;
        b=vpxrMCfessEBVQ5izvnSts84vgyz6zgmIoZ0gh4YuBiq0zP+uT3Kgw4pFqsVax9InQ
         8k1jKUSAOaKT0rqG3fNSfwcnfGXNVbpeL4UmxJxv3S1uLFdGWJZVngJxH2RC9gQE/Tcl
         G2/t+VoV2l9NFJlA2TusFYwMGPtQ9TVMLXXVqSEUJFUN3klzefLVKMco0MFbDiuHvsuT
         AoUDw/EAu6v7FxZUnvANo//br2wp8sX31DYGznIWWpnTmNtzNee5vx+qy9TwWOtpBie+
         4SbKLxve5KjXlB3zODhG65m+tH6OnCOw1S/Z4VPB0DEU6Ds2D3tWccLjWxMw8MnkNBp9
         AObA==
X-Gm-Message-State: AOAM532zuFynZiGPlFvbEwQeg4Bvv+I0z69F8UaT7yXUDP6nDwIDT8/F
        lLFchh8cSKWXaz4rSsqUDQ==
X-Google-Smtp-Source: ABdhPJxfibBjybFIb91QEkreYKIfX75YfgEvrKkpfIdzED7j6BRGQuM0ZuC4c+j/HU35Yb1Cp5+uug==
X-Received: by 2002:a63:ed4a:: with SMTP id m10mr2319773pgk.448.1632959975813;
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
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
Subject: [RFC PATCH v2 06/13] bpf: Add APIs to invoke tracing programs
Date:   Wed, 29 Sep 2021 23:59:03 +0000
Message-Id: <20210929235910.1765396-7-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

The macros BPF_TRACE_MAP_{K,KV} provide a convenient way to invoke
tracing programs. Maps will register themselves with a late_initcall()
then use these macros to invoke tracing programs.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 include/linux/bpf.h    | 13 +++++++++++++
 kernel/bpf/map_trace.c | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6f7aeeedca07..73f4524c1c29 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1532,6 +1532,16 @@ struct bpf_map_trace_progs {
 	struct mutex mutex; /* protects writes to progs, length */
 };
 
+struct bpf_map_trace_ctx__update_elem {
+	__bpf_md_ptr(void *, key);
+	__bpf_md_ptr(void *, value);
+	u64 flags;
+};
+
+struct bpf_map_trace_ctx__delete_elem {
+	__bpf_md_ptr(void *, key);
+};
+
 struct bpf_map_trace_reg {
 	const char *target;
 	enum bpf_map_trace_type trace_type;
@@ -1560,6 +1570,9 @@ int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info);
 int bpf_map_trace_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 			      struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr, struct bpf_prog *prog);
+void bpf_trace_map_update_elem(struct bpf_map *map, void *key, void *value,
+			       u64 flags);
+void bpf_trace_map_delete_elem(struct bpf_map *map, void *key);
 int bpf_iter_new_fd(struct bpf_link *link);
 bool bpf_link_is_iter(struct bpf_link *link);
 struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_stop);
diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
index ed0cbc941522..77a55f8cd119 100644
--- a/kernel/bpf/map_trace.c
+++ b/kernel/bpf/map_trace.c
@@ -295,3 +295,43 @@ int bpf_map_trace_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	return err;
 }
 
+static void bpf_map_trace_run_progs(struct bpf_map *map,
+				    enum bpf_map_trace_type trace_type,
+				    void *ctx)
+{
+	struct bpf_map_trace_prog *prog;
+
+	if (!map->trace_progs)
+		return;
+
+	rcu_read_lock();
+	migrate_disable();
+	list_for_each_entry_rcu(prog,
+				&map->trace_progs->progs[trace_type].list,
+				list) {
+		bpf_prog_run(prog->prog, ctx);  /* return code is ignored */
+	}
+	migrate_enable();
+	rcu_read_unlock();
+}
+
+void bpf_trace_map_update_elem(struct bpf_map *map,
+			       void *key, void *value, u64 flags)
+{
+	struct bpf_map_trace_ctx__update_elem ctx;
+
+	ctx.key = key;
+	ctx.value = value;
+	ctx.flags = flags;
+	bpf_map_trace_run_progs(map, BPF_MAP_TRACE_UPDATE_ELEM, &ctx);
+}
+
+void bpf_trace_map_delete_elem(struct bpf_map *map,
+			       void *key)
+{
+	struct bpf_map_trace_ctx__delete_elem ctx;
+
+	ctx.key = key;
+	bpf_map_trace_run_progs(map, BPF_MAP_TRACE_DELETE_ELEM, &ctx);
+}
+
-- 
2.33.0.685.g46640cef36-goog

