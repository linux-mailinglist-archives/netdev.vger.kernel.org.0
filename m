Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0116976DB
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjBOHAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbjBOG71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 01:59:27 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4701DDBFF;
        Tue, 14 Feb 2023 22:58:39 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id bt4-20020a17090af00400b002341621377cso1173734pjb.2;
        Tue, 14 Feb 2023 22:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cw3/EfBuwTrSjbNBCeLzC+B32hPzmMgYrzTGmtXxuo8=;
        b=DpCz9mhO5+896qDYTs/fk00gd7A8McjNWhWnSes0Q/PDOhc7iXHYdBB7abi1F+GAEC
         oVzR5b8lr6Arys1fRnw+NYe3OBqbknm7kKutbtR7q/wfKmyX960CP1ewMj0w+5jUxLIH
         KP/8HGJnVVDotamvv3giP6wuD2X1OxnjOZLZno9P4REHI1GLXk0QGFq7pIKl7q/2UHT2
         vJCNIRNgG7WCvp8FpQZcC+K7SECSzC+zH6M/mPA99CTtqIzrM4/GtYmYh33PYE1yNu5F
         xKMiZeHryqkY4wYPmWO/AmptdSUekH75M9YnwP6pLs/00iXuBkWsKftnXbPTxjXF/7tA
         lKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cw3/EfBuwTrSjbNBCeLzC+B32hPzmMgYrzTGmtXxuo8=;
        b=fBW1J6mNEVIpoRdVsvEGunfqB01QEXjxB/2/gE3zHaYj/gGuhY4AK2c3elDBxWiNOv
         AQEL63uxT1urMonFwyO+DpO9P9oxi0da0DhQ1hD+q8ZCu3fGQtUKZwPDCr/ePODshEnX
         4QJwhWPxPH5tZOgPRd/85feWM2dyIK0ogZk1eS3GVhHRyXgjnhiaTMizxl1/5cHa4hOw
         IHPszEZCJgmGnEjhKGsvaWQgJCmi6auBqO8pRSeg8b+cpiQCd7Uz8y9hvvwQj98s0LgX
         vF12Ot+8VnqgIKlifop10qzSPwoljHXhC/vx+Mhs4Meb/qumaBJ1BC7c2tUlr3LqPjdh
         ZZVA==
X-Gm-Message-State: AO0yUKU4xqE6qZTwOoH/h55y1z1enKrHcaSBhqQn5FhA2m+s8tCUkmka
        4rOZb8J0vJ9jm+Oh+AR7ToM=
X-Google-Smtp-Source: AK7set8yS9f2Abxgh8bld/qvREPc9GQvrX5uMfseGJgV0azs4oNtVNktDKCMzb6f3B1Jib0Z2FPbzg==
X-Received: by 2002:a17:902:c641:b0:19a:9434:af30 with SMTP id s1-20020a170902c64100b0019a9434af30mr1168342pls.18.1676444312269;
        Tue, 14 Feb 2023 22:58:32 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:d0de])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902c15300b0019a9751096asm5956868plj.305.2023.02.14.22.58.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Feb 2023 22:58:31 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 4/4] selftests/bpf: Tweak cgroup kfunc test.
Date:   Tue, 14 Feb 2023 22:58:12 -0800
Message-Id: <20230215065812.7551-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
References: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
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
 tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c | 9 ++++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

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
index 0c23ea32df9f..0ce9cb00dad2 100644
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
 
@@ -80,6 +80,13 @@ int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
 		return 0;
 	}
 
+	kptr = v->cgrp;
+	if (!kptr)
+		return 0;
+	cg = bpf_cgroup_ancestor(kptr, 1);
+	if (cg)
+		bpf_cgroup_release(cg);
+
 	kptr = bpf_kptr_xchg(&v->cgrp, NULL);
 	if (!kptr) {
 		err = 3;
-- 
2.30.2

