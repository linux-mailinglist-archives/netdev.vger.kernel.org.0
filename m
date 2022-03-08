Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45694D18D8
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347068AbiCHNMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347056AbiCHNM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:27 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4A448E53;
        Tue,  8 Mar 2022 05:11:24 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id e15so15706682pfv.11;
        Tue, 08 Mar 2022 05:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3y4pmtErmcUQqTEOzusAX2pzTuUiyQeDCSeMBuC6VMQ=;
        b=SiVmiDuO/2M2Xzol8AGb7jc3+OznGw2J3+JiAFGq0IgPtRBs+B5WCzg555zf8AFxw/
         SvYvYKlfzqYxdYqt6HLWTZDy8hkMR7VnTuVpC45UG+9hWjGQT82Z1lZGXZz5u5ZkI1Sb
         T8wWUD1Ign+8sEYvUjXqv3kCkXpo2pRUaADUOJC50otN7MQwMr6DhUs3+5lXu5EZyZlv
         2hNDqCxhpUMTgCqyUWHe6LD6wxoxG2PbB4oUB14AjukT5kPNQVRsOtgTr1FmYzxJeIYq
         pq7ceeU7QUXEBoLpCRr4f2m0Wt8L3ogseVrdawWE9L5U3W4JXEjIhDfPwNpqxZEx+Kkp
         TdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3y4pmtErmcUQqTEOzusAX2pzTuUiyQeDCSeMBuC6VMQ=;
        b=59WBCR/M7mUmLkcvVN2HJC+C5GXYhoXLbljRsebVoJh2k3FIhaoGRzoc4X2AwiqemQ
         N4k5qXzdb+cGJGhvJnhaArs1KWS4kRLDFSQAjSFFgX2nsGNPvlT8yFnBvYVfkojVa+eR
         tTU/og8wXCoXC+kgqpgL2GsZZlzdJqxjS9ihqQzg9JPTt7R8OcbHNhNVfLg44JKb0QkB
         xuFRXEdMltpfip4Z3swaneonms3U7TBqQlkarjLQyfJk6h16+63e4/PKs2jSfYCH+B4P
         R3jZSyUuYAJCUlvcA431qWYhzLOPZEqFJpfYy5lJmX+1ffLCzyBXaa/eN3ioaNzq7N4C
         DIcA==
X-Gm-Message-State: AOAM530PpzRgancpePRIeXmbUT2rO3gJLB0+DmgDLWjA1HJmDmZg08sH
        Sew2+ygnirwOVxw0wamQZtE=
X-Google-Smtp-Source: ABdhPJxozHq59VkUFv288fl2mix6RMNdONpReM8rlehkbq7w0YTK49AhZHAdBosK85EByFXP+tX5JQ==
X-Received: by 2002:a63:d253:0:b0:380:3aee:8437 with SMTP id t19-20020a63d253000000b003803aee8437mr9002618pgi.382.1646745084332;
        Tue, 08 Mar 2022 05:11:24 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:23 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 7/9] bpf: add BPF_MAP_RECHARGE syscall
Date:   Tue,  8 Mar 2022 13:10:54 +0000
Message-Id: <20220308131056.6732-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308131056.6732-1-laoar.shao@gmail.com>
References: <20220308131056.6732-1-laoar.shao@gmail.com>
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

This patch adds a new bpf syscall BPF_MAP_RECHARGE, which means to
recharge the allocated memory of a bpf map from an offline memcg to
the current memcg.

The recharge methord for each map will be implemented in the follow-up
patches.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h      |  2 ++
 include/uapi/linux/bpf.h |  9 +++++++++
 kernel/bpf/syscall.c     | 19 ++++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 88449fb..fca274e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -147,6 +147,8 @@ struct bpf_map_ops {
 				     bpf_callback_t callback_fn,
 				     void *callback_ctx, u64 flags);
 
+	bool (*map_recharge_memcg)(struct bpf_map *map);
+
 	/* BTF name and id of struct allocated by map_alloc */
 	const char * const map_btf_name;
 	int *map_btf_id;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a448b06..290ea67 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -821,6 +821,14 @@ struct bpf_cgroup_storage_key {
  *		Returns zero on success. On error, -1 is returned and *errno*
  *		is set appropriately.
  *
+ * BPF_MAP_RECHARGE
+ *  Description
+ *		Recharge bpf memory from an offline memcg
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
  * NOTES
  *	eBPF objects (maps and programs) can be shared between processes.
  *
@@ -875,6 +883,7 @@ enum bpf_cmd {
 	BPF_ITER_CREATE,
 	BPF_LINK_DETACH,
 	BPF_PROG_BIND_MAP,
+	BPF_MAP_RECHARGE,
 };
 
 enum bpf_map_type {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 68fea3b..85456f1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1128,7 +1128,6 @@ static int map_lookup_elem(union bpf_attr *attr)
 	return err;
 }
 
-
 #define BPF_MAP_UPDATE_ELEM_LAST_FIELD flags
 
 static int map_update_elem(union bpf_attr *attr, bpfptr_t uattr)
@@ -4621,6 +4620,21 @@ static int bpf_prog_bind_map(union bpf_attr *attr)
 	return ret;
 }
 
+static int map_recharge_elem(union bpf_attr *attr)
+{
+	int id = attr->map_id;
+	struct bpf_map *map;
+
+	map = bpf_map_idr_find(id);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	if (map->ops->map_recharge_memcg)
+		map->ops->map_recharge_memcg(map);
+
+	return 0;
+}
+
 static int __sys_bpf(int cmd, bpfptr_t uattr, unsigned int size)
 {
 	union bpf_attr attr;
@@ -4757,6 +4771,9 @@ static int __sys_bpf(int cmd, bpfptr_t uattr, unsigned int size)
 	case BPF_PROG_BIND_MAP:
 		err = bpf_prog_bind_map(&attr);
 		break;
+	case BPF_MAP_RECHARGE:
+		err = map_recharge_elem(&attr);
+		break;
 	default:
 		err = -EINVAL;
 		break;
-- 
1.8.3.1

