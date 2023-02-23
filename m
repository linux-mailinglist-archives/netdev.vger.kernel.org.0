Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C796A0171
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 04:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbjBWDID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 22:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbjBWDHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 22:07:44 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F89457D7;
        Wed, 22 Feb 2023 19:07:38 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id k21-20020a17090aaa1500b002376652e160so90491pjq.0;
        Wed, 22 Feb 2023 19:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p74sWJ64A1OPekYdfYFXpkbCTSqVdh7YcPKAPUNXdBE=;
        b=L9bXZ1MqwWFXg/8ifi6nCJQmxb3ZDId0XHfXhdr2wzYowNNF3PQRIhEY+vClfMSOG7
         KXX0siBPKJ21Nj5TYklTSwZafmdM1Kzs/RBOHzLQRoRKTnbAyYwWLzLUMSqjsCbAqQg/
         GJOl+mqw4elmxoYRdwDve0/q6LNga59fjf6rPKYeg8RM4cbgjYoGmPM7a5Popw43gmgo
         1D3RNEhVquC/hNHudHPFXuNZScBuqqQMrMlyhCmVAwd/ONsKQiouaieE6pDW6LBZC0sv
         x4ydOl7aZvI7NlTFe5HNYV4teRzJ4JrjhNvRMIi1MARBmsdnxhkQnkxZqfpyVY8Af5XQ
         wRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p74sWJ64A1OPekYdfYFXpkbCTSqVdh7YcPKAPUNXdBE=;
        b=TlgkX8rowEoQZ/ZR2YOYietbaFCFslpfF0vu6bSzVFvSxtHlnFPSwoCf1DQvKJ/Vhx
         4VV43pJUFqpZjTbkOvH+DijgqC27oMdm/g1Ao4rZYZbvnLhCy3OZv+svk4B7q8sz4RJp
         K5+GqMcKzK6KnUYd80EtyiBqM9lQSXX9WIrHIQlmXNlOilhKFfyPkUZqtxfUQ94eJRo2
         V0v7x/L2f1T93bJqKE2RG20zh1lZ9Qed00Q6oz1+vWU3g8ZDRSHbMV24AG+DhxcqwL5m
         I1eYFUN0NyXaD00c8On0ckyM7d2WjVNsn8fUWO+jliq5PSfZ3/ba3Bj4m4gLmyEnBfrH
         6X/w==
X-Gm-Message-State: AO0yUKVliwZ2iXw/0kskqzILi4EXDmfVJp+5LKt8co0Eru0O5NEYg+Uc
        1uHlI/97IeAH42ijVcPAZVA=
X-Google-Smtp-Source: AK7set9WXKBfz0PFRawtp3BSTK031umHnNN/jmZC/jwPlzD/pYRgxRd4JhlzOkWq9axpLFR7e114AQ==
X-Received: by 2002:a17:903:2444:b0:19a:627f:fb73 with SMTP id l4-20020a170903244400b0019a627ffb73mr12283176pls.57.1677121657910;
        Wed, 22 Feb 2023 19:07:37 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:9cb3])
        by smtp.gmail.com with ESMTPSA id p2-20020a1709026b8200b0019c61616f82sm7057184plk.230.2023.02.22.19.07.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Feb 2023 19:07:37 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: Tweak cgroup kfunc test.
Date:   Wed, 22 Feb 2023 19:07:17 -0800
Message-Id: <20230223030717.58668-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230223030717.58668-1-alexei.starovoitov@gmail.com>
References: <20230223030717.58668-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Adjust cgroup kfunc test to dereference RCU protected cgroup pointer
as PTR_TRUSTED and pass into KF_TRUSTED_ARGS kfunc.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h  | 2 +-
 tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c | 2 +-
 tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c | 7 ++++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
index 50d8660ffa26..eb5bf3125816 100644
--- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
+++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
@@ -10,7 +10,7 @@
 #include <bpf/bpf_tracing.h>
 
 struct __cgrps_kfunc_map_value {
-	struct cgroup __kptr * cgrp;
+	struct cgroup __kptr_rcu * cgrp;
 };
 
 struct hash_map {
diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
index 4ad7fe24966d..d5a53b5e708f 100644
--- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
+++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
@@ -205,7 +205,7 @@ int BPF_PROG(cgrp_kfunc_get_unreleased, struct cgroup *cgrp, const char *path)
 }
 
 SEC("tp_btf/cgroup_mkdir")
-__failure __msg("arg#0 is untrusted_ptr_or_null_ expected ptr_ or socket")
+__failure __msg("bpf_cgroup_release expects refcounted")
 int BPF_PROG(cgrp_kfunc_release_untrusted, struct cgroup *cgrp, const char *path)
 {
 	struct __cgrps_kfunc_map_value *v;
diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
index 0c23ea32df9f..37ed73186fba 100644
--- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
+++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
@@ -61,7 +61,7 @@ int BPF_PROG(test_cgrp_acquire_leave_in_map, struct cgroup *cgrp, const char *pa
 SEC("tp_btf/cgroup_mkdir")
 int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
 {
-	struct cgroup *kptr;
+	struct cgroup *kptr, *cg;
 	struct __cgrps_kfunc_map_value *v;
 	long status;
 
@@ -80,6 +80,11 @@ int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
 		return 0;
 	}
 
+	kptr = v->cgrp;
+	cg = bpf_cgroup_ancestor(kptr, 1);
+	if (cg)
+		bpf_cgroup_release(cg);
+
 	kptr = bpf_kptr_xchg(&v->cgrp, NULL);
 	if (!kptr) {
 		err = 3;
-- 
2.30.2

