Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487C236A340
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 23:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbhDXVqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 17:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbhDXVqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 17:46:22 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3533DC061574;
        Sat, 24 Apr 2021 14:45:44 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id s5so44320135qkj.5;
        Sat, 24 Apr 2021 14:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3DUapBlFjGRDJpFp34wiWQN/kbUJN43b6f1p6IDIwe8=;
        b=ubMyMsSw/bkk5fpe7fBQkfcY28dNdEb4jW8dkath1uZutJ6pDYfr0lB5U7QzocwNxb
         h+Rtff+hPWJCEvPLvvh3B3RTPPWGDdmLTE1e+PvzZPqKRcONigMIRNMaVFcwSlD7+Jeb
         1tpSYvmBcpjOGBnk/gWl/rGgqRKIo+TWSzXjli54gg3bndlXI9qSZDxs1ABfTi/v5W0c
         V8h+axkWjEZSNJPN6Pm+zOxbsiOEHS2cX7rerH6QsI+XyLzrwjESCtEVmixmZi2bDTet
         e2di4Vdqjt/6Urwr2Td4vbW13j2gwt6gcoqxg8G9GWJeDHivwwoVG7D3+S3ODjqENLNj
         06fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3DUapBlFjGRDJpFp34wiWQN/kbUJN43b6f1p6IDIwe8=;
        b=jBiuHEAkBCnsLa/02Vf6cMV1VTjd0MVFeXMjODmrroxDyGCC3vtGuUGIOckdMSG1rc
         YOVXUQqvExiztxgae3Wmmf3nICwDBB4hf/2e7JPGI5FsoF95P43FpETi6mNw9L1bCh0R
         cJAhC4frpzurt8nP7c5ItNQWUexNMdbQOmrhVSRSnplhZ79wfS5U76dUHiUMZB/60IWw
         gfdBV0elTX8GWF/MNSyaOBvpTqqUiBNjDA3IAcyZYAQxYnBObU07kumB11wNaCQDhnwz
         yZ2L27Kcw1gturyrtDQl8mWpxzdhTcI/x6OM+EBblSvu2RStmEkcgX5HRztXTrVy6e+8
         Ywlg==
X-Gm-Message-State: AOAM530SQp4/r5WmlTwlVbH1FrpjJ/fueTBCOscV3ybrdr4r0I0Jne7e
        hQ5FAMq6m3PUftFtE/xWzYbH27O91/bOmuRd
X-Google-Smtp-Source: ABdhPJzqv2aTXXTpbqg9wlihBV8OWdKMJT+C379bHSgFzGX0fbH9zx+EGqtgm2w+PfQojzBGMzCwgg==
X-Received: by 2002:a37:ef0d:: with SMTP id j13mr10613087qkk.2.1619300743513;
        Sat, 24 Apr 2021 14:45:43 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id b17sm6638904qto.88.2021.04.24.14.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 14:45:41 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH bpf-next v5 1/2] bpf: add batched ops support for percpu array
Date:   Sat, 24 Apr 2021 18:45:09 -0300
Message-Id: <20210424214510.806627-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424214510.806627-1-pctammela@mojatatu.com>
References: <20210424214510.806627-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uses the already in-place infrastructure provided by the
'generic_map_*_batch' functions.

No tweak was needed as it transparently handles the percpu variant.

As arrays don't have delete operations, let it return a error to
user space (default behaviour).

Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 kernel/bpf/arraymap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 463d25e1e67e..3c4105603f9d 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -698,6 +698,8 @@ const struct bpf_map_ops percpu_array_map_ops = {
 	.map_delete_elem = array_map_delete_elem,
 	.map_seq_show_elem = percpu_array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_update_batch = generic_map_update_batch,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_array_elem,
 	.map_btf_name = "bpf_array",
-- 
2.25.1

