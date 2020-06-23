Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A498205653
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733032AbgFWPwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731870AbgFWPwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:52:04 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF485C061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 08:52:02 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f139so2363269wmf.5
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 08:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yxmcfIOE7dhhF4zAwl3j/L17uwzHuScL84R3y8ffPus=;
        b=2BZNSEglDW3VkozxnIlIyqjYvTqCxV4pfO9TmPcJeWIszqyctWLYMVQ+3bPxeexYCv
         hL62apnqoqDUHUbG9j44oceHZeItLAF1FOnb/ule9Ll4eYd+SQdzUYWTK4XJXMkRmD8+
         nd2tcSlGlq4dAJGJAqI+QQZjrQrci4TiTtdSEDX2c/KcDCOP0fzcynUrcrasbR3lTjgU
         2YaruNDBdiWoIGxvxP5Hkfs1Ny0Q4zst34VPiVBBHes80qoXPnzyIEliLPEwqqh++IsK
         DtCDUQ7XjHO4Y5WDOm8BvqXEPU90gb7oEDlS88uP8BxZ0JAaPb29sNnEYkUfyzl80WQh
         m/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yxmcfIOE7dhhF4zAwl3j/L17uwzHuScL84R3y8ffPus=;
        b=V6v4lbBsCNZ/ynoXxE8moY91ttm9S+YmLHhU8jYiGr7JoDZZqX5sHWE3mpESPkt+u+
         Lm8cK4+RM2eYt5yN67aD5YJvqdTdelLaLmT+IXPaDcKUt/4FZxMaHWXBBTitPjhnyigd
         d+nJrgO8b7TZXOqNxSlF8kgbT7ecpxo0X/51j/WwEbwc2FHiNrxYar4fCa2G5Utul/Fh
         MQozvmBq7Ls1Xmxmt/JGAFddHPXlehnXVUsTCfGRdSsJR0sdPsllBy3LvxNDXDdsll2B
         OW9AA0WtaaYKL83/lW9hOjPWopAW/LQgNYoIGHzvKr1Qevfm1nimeaV4Pe75OyqQI2bH
         RhAQ==
X-Gm-Message-State: AOAM533PSsvU9GyNS80MJUok0qgJ81Gjd6/a67fElWGuBZ5I0KkpNESc
        0V6ks4g32APcVtohTC6dKh1ilAKH7fN7cw==
X-Google-Smtp-Source: ABdhPJyo5LLG9ZwvmfoFZ6oIbA0BVX03atnMtQ8w8+VbnX8ImmBB43aQwPQNlBimYV11NA+lBHs+xQ==
X-Received: by 2002:a05:600c:c1:: with SMTP id u1mr10330291wmm.48.1592927521531;
        Tue, 23 Jun 2020 08:52:01 -0700 (PDT)
Received: from localhost.localdomain ([194.53.184.63])
        by smtp.gmail.com with ESMTPSA id x18sm11844282wrq.13.2020.06.23.08.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:52:01 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] tools: bpftool: do not pass json_wtr to emit_obj_refs_json()
Date:   Tue, 23 Jun 2020 16:51:57 +0100
Message-Id: <20200623155157.13082-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building bpftool yields the following complaint:

    pids.c: In function ‘emit_obj_refs_json’:
    pids.c:175:80: warning: declaration of ‘json_wtr’ shadows a global declaration [-Wshadow]
      175 | void emit_obj_refs_json(struct obj_refs_table *table, __u32 id, json_writer_t *json_wtr)
          |                                                                 ~~~~~~~~~~~~~~~^~~~~~~~
    In file included from pids.c:11:
    main.h:141:23: note: shadowed declaration is here
      141 | extern json_writer_t *json_wtr;
          |                       ^~~~~~~~

json_wtr being exposed in main.h (included in pids.c) as an extern, it
is directly available and there is no need to pass it through the
function. Let's simply use the global variable.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/btf.c  | 2 +-
 tools/bpf/bpftool/link.c | 2 +-
 tools/bpf/bpftool/main.h | 3 +--
 tools/bpf/bpftool/map.c  | 2 +-
 tools/bpf/bpftool/pids.c | 2 +-
 tools/bpf/bpftool/prog.c | 2 +-
 6 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index fc9bc7a23db6..81a1c301ccf4 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -843,7 +843,7 @@ show_btf_json(struct bpf_btf_info *info, int fd,
 	}
 	jsonw_end_array(json_wtr);	/* map_ids */
 
-	emit_obj_refs_json(&refs_table, info->id, json_wtr); /* pids */
+	emit_obj_refs_json(&refs_table, info->id); /* pids */
 
 	jsonw_end_object(json_wtr);	/* btf object */
 }
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 7329f3134283..ac39b1f80838 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -144,7 +144,7 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
 		jsonw_end_array(json_wtr);
 	}
 
-	emit_obj_refs_json(&refs_table, info->id, json_wtr);
+	emit_obj_refs_json(&refs_table, info->id);
 
 	jsonw_end_object(json_wtr);
 
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index ce26271e5f0c..ad5a67bf6cf1 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -197,8 +197,7 @@ void delete_pinned_obj_table(struct pinned_obj_table *tab);
 __weak int build_obj_refs_table(struct obj_refs_table *table,
 				enum bpf_obj_type type);
 __weak void delete_obj_refs_table(struct obj_refs_table *table);
-__weak void emit_obj_refs_json(struct obj_refs_table *table, __u32 id,
-			       json_writer_t *json_wtr);
+__weak void emit_obj_refs_json(struct obj_refs_table *table, __u32 id);
 __weak void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id,
 				const char *prefix);
 void print_dev_plain(__u32 ifindex, __u64 ns_dev, __u64 ns_inode);
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 0a6a5d82d380..0f88f1de1500 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -509,7 +509,7 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 		jsonw_end_array(json_wtr);
 	}
 
-	emit_obj_refs_json(&refs_table, info->id, json_wtr);
+	emit_obj_refs_json(&refs_table, info->id);
 
 	jsonw_end_object(json_wtr);
 
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 3474a91743ff..d5dc55641230 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -172,7 +172,7 @@ void delete_obj_refs_table(struct obj_refs_table *table)
 	}
 }
 
-void emit_obj_refs_json(struct obj_refs_table *table, __u32 id, json_writer_t *json_wtr)
+void emit_obj_refs_json(struct obj_refs_table *table, __u32 id)
 {
 	struct obj_refs *refs;
 	struct obj_ref *ref;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index e21fa8ad2efa..0095fb3faa17 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -190,7 +190,7 @@ static void print_prog_json(struct bpf_prog_info *info, int fd)
 		jsonw_end_array(json_wtr);
 	}
 
-	emit_obj_refs_json(&refs_table, info->id, json_wtr);
+	emit_obj_refs_json(&refs_table, info->id);
 
 	jsonw_end_object(json_wtr);
 }
-- 
2.25.1

