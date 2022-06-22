Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D858B5550BE
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376593AbiFVQEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376385AbiFVQEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:04:10 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1334833364
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:04:01 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x123-20020a626381000000b005254d5e6a0fso416430pfb.5
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=r0Lj6PtlHqrSuvZYIBihZTa4s3/QqaHCC+51XLBQesU=;
        b=dBhpu92abKzO7KIKqwO4gSNKF6LQbKmuTy/8vw52x+et0yOUxkv+3aatVXI0qJVA1k
         jZ51L/sV17bf8vjd4fD/edu97sOGQgQUq/kwDDFqsaZQB+nM8xHYA/QKO4zzbLpieNbc
         13cEOJykniWNT5AXK67TpS5cl8wFdmAJfKaBcFOHo6u5LSmxoC6hFYHT5XUDMU4keidW
         HZRQQFgDNlr2GvBXU8wJpvx8REftJ3bCqZsqM5hTcjCLa8dMFxt881DMHGL4k4d13npo
         EoONVvrcTO58ZnQw7RcxJaeC1ir6QD+NxSJNU1sFCe3bfNMF6GbUeWODeQBV2pm8E7Z4
         PgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r0Lj6PtlHqrSuvZYIBihZTa4s3/QqaHCC+51XLBQesU=;
        b=L0sMa7cz5tYVeAQEUbGxTYNItkG8DgNY7raoHPtTyAT5lpeYTmW9ByLoWkfaN1xIq8
         Z+V6nvj5NXcD1375kQibI/oz8h9G55StxbAo35ZNUqRiO9hihyCM1rF9fybZmo5qKan3
         yfdWp+k1Dag+8XvMQCiFoOhdDc9mYbcnrVtCB/nd0Sgf+VCfwGCofGGEd1V31IcsbD8j
         seyJDIHo8wt78ESTXZC1Cn9V/wTi+pZYzanZrVMgNOd3ZomRjwnOUQ8gEBtGSd/kGCiU
         YzvTELvz5m5R/hWgqVsh9Ixl3rVbVYuZIIbX9ulj/ed6ysY4UzFKjsCOiW0LaZvUcXxi
         vB4Q==
X-Gm-Message-State: AJIora+kIb+SMYV0+7GyuCtpDHb0WpA10VhGBgAyNgLjNnEN1o8GZHoV
        AEtIsD9wKErtNnphxxUhOB5hXztzbYOXnmCod43H9xMuetgV16spYnVSYkSRWau1B/kUOuoQ88C
        pwnFCnnvY9MGLpAOPew+sNqycQW/i6ybXd6HSXaqZ54/uvBuRzDWujg==
X-Google-Smtp-Source: AGRyM1vrS/3nrnPBc6pbKgfJHcN0fPfmqmine9GonsORm5PuwsPNubQlFOSD55Lxn4YfWM3cjGL7JAs=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:f602:b0:16a:178a:7b0b with SMTP id
 n2-20020a170902f60200b0016a178a7b0bmr20423267plg.20.1655913841348; Wed, 22
 Jun 2022 09:04:01 -0700 (PDT)
Date:   Wed, 22 Jun 2022 09:03:42 -0700
In-Reply-To: <20220622160346.967594-1-sdf@google.com>
Message-Id: <20220622160346.967594-8-sdf@google.com>
Mime-Version: 1.0
References: <20220622160346.967594-1-sdf@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH bpf-next v10 07/11] tools/bpf: Sync btf_ids.h to tools
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Has been slowly getting out of sync, let's update it.

resolve_btfids usage has been updated to match the header changes.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/linux/btf_ids.h                 | 35 +++++++++++++++----
 .../selftests/bpf/prog_tests/resolve_btfids.c |  2 +-
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
index 57890b357f85..71e54b1e3796 100644
--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -73,7 +73,7 @@ asm(							\
 __BTF_ID_LIST(name, local)				\
 extern u32 name[];
 
-#define BTF_ID_LIST_GLOBAL(name)			\
+#define BTF_ID_LIST_GLOBAL(name, n)			\
 __BTF_ID_LIST(name, globl)
 
 /* The BTF_ID_LIST_SINGLE macro defines a BTF_ID_LIST with
@@ -82,6 +82,9 @@ __BTF_ID_LIST(name, globl)
 #define BTF_ID_LIST_SINGLE(name, prefix, typename)	\
 	BTF_ID_LIST(name) \
 	BTF_ID(prefix, typename)
+#define BTF_ID_LIST_GLOBAL_SINGLE(name, prefix, typename) \
+	BTF_ID_LIST_GLOBAL(name, 1)			  \
+	BTF_ID(prefix, typename)
 
 /*
  * The BTF_ID_UNUSED macro defines 4 zero bytes.
@@ -143,13 +146,14 @@ extern struct btf_id_set name;
 
 #else
 
-#define BTF_ID_LIST(name) static u32 name[5];
+#define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
 #define BTF_ID(prefix, name)
 #define BTF_ID_UNUSED
-#define BTF_ID_LIST_GLOBAL(name) u32 name[1];
-#define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 name[1];
-#define BTF_SET_START(name) static struct btf_id_set name = { 0 };
-#define BTF_SET_START_GLOBAL(name) static struct btf_id_set name = { 0 };
+#define BTF_ID_LIST_GLOBAL(name, n) u32 __maybe_unused name[n];
+#define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 __maybe_unused name[1];
+#define BTF_ID_LIST_GLOBAL_SINGLE(name, prefix, typename) u32 __maybe_unused name[1];
+#define BTF_SET_START(name) static struct btf_id_set __maybe_unused name = { 0 };
+#define BTF_SET_START_GLOBAL(name) static struct btf_id_set __maybe_unused name = { 0 };
 #define BTF_SET_END(name)
 
 #endif /* CONFIG_DEBUG_INFO_BTF */
@@ -172,7 +176,10 @@ extern struct btf_id_set name;
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_MPTCP, mptcp_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCKET, socket)
 
 enum {
 #define BTF_SOCK_TYPE(name, str) name,
@@ -184,4 +191,18 @@ MAX_BTF_SOCK_TYPE,
 extern u32 btf_sock_ids[];
 #endif
 
+#define BTF_TRACING_TYPE_xxx	\
+	BTF_TRACING_TYPE(BTF_TRACING_TYPE_TASK, task_struct)	\
+	BTF_TRACING_TYPE(BTF_TRACING_TYPE_FILE, file)		\
+	BTF_TRACING_TYPE(BTF_TRACING_TYPE_VMA, vm_area_struct)
+
+enum {
+#define BTF_TRACING_TYPE(name, type) name,
+BTF_TRACING_TYPE_xxx
+#undef BTF_TRACING_TYPE
+MAX_BTF_TRACING_TYPE,
+};
+
+extern u32 btf_tracing_ids[];
+
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
index f4a13d9dd5c8..c197261d02e2 100644
--- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -44,7 +44,7 @@ BTF_ID(union,   U)
 BTF_ID(func,    func)
 
 extern __u32 test_list_global[];
-BTF_ID_LIST_GLOBAL(test_list_global)
+BTF_ID_LIST_GLOBAL(test_list_global, 1)
 BTF_ID_UNUSED
 BTF_ID(typedef, S)
 BTF_ID(typedef, T)
-- 
2.37.0.rc0.104.g0611611a94-goog

