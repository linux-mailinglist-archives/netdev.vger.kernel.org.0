Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D7651569C
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbiD2VT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236785AbiD2VTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:19:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3941852FA
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:16:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w133-20020a25c78b000000b0064847b10a22so8446566ybe.18
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eiu2YIIyTHgGm2i1kRjn8gm8itPffmqITP80/rCyvUw=;
        b=NgQAolTlZAJb7BZxWTMYx5RN9WfUNeglzf9/eQBuJxPQXXs/XxzLPfsff54RbDxYvB
         Tt8iMZMCeQFI/qw6v0dAeQVxMjxeu9I9Hs085rLnpnVgY2NjRhSE/84ecH2OtG0ha14f
         A0PSUFN57xw2HLGmXksGxPqsYTVX86NdtpNWa7zZ0rnsZMkmIKRwNa/ViqfakF84Rhhz
         aRgVWqh9aaYgFkeO1YRyI/+CVUgU1DjDF8aAMlq+AXSSFhh5ww/VlOoH1PaoCXsCApVh
         o6U/8jpA/mQqdN7NzYRmz1Xee4NfkHxiY+JlO6F6PuNAKkxNs9uqQ26FnHt1E2RSTRYg
         ZAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eiu2YIIyTHgGm2i1kRjn8gm8itPffmqITP80/rCyvUw=;
        b=GgP8AXLcLMKTykhLTmMiRb6/pQzvVMhz55DAmBD+wrHtHW5/L5q9GQiZMiYoLUuSWQ
         POE97tFR+v4H3QYeyo9kn9v9RrXbFKR047hxDRlOTciag5eC/0Xcj4856BIScEBDQMse
         IljKix1kD7cX+mJ+9+CpBunGoNoGOAYcCXeoFRbOkvKvKpPiKuD9zpB80YgJvKDIeB9p
         zlCGg1+3YtLWikavm8FF7zr8IsxxWcnBoqY/NKzMgptAEPbEeno8ql8XpfY5TAUUWwQq
         rPJf0/MYDnisyYHnBRitPINeT4OUMLR7RWdeIL/pMkou0H57sEH5Z/cTlG4S8O2Enjhx
         X89g==
X-Gm-Message-State: AOAM531sLSh9hOFhnCaUdhm1tJfuvnKy0LTJ/bGwFKEeV1QjZhKP2WmI
        a7O3Ge6UnhGBK/4ymLRsH1bqTr4Vb7riL3PZj0XnfIdnPVDcNQn4Cl9lx0xlO7IPbpV+1Aeg26V
        /nNAtypLLZowDQAlBN81w7ZKWTSxzz+xGtXcsCSUToiJ4i2NWZXsPTw==
X-Google-Smtp-Source: ABdhPJyf+9qxsGSJTk1QWYwvpvWypmaoI4105abggi3LMp4eZrO2y7AY+Dxh3b4vPU9WCCvSvekY+nQ=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b0cc:7605:1029:2d96])
 (user=sdf job=sendgmr) by 2002:a5b:50f:0:b0:629:5d05:aebf with SMTP id
 o15-20020a5b050f000000b006295d05aebfmr1414762ybp.618.1651266959612; Fri, 29
 Apr 2022 14:15:59 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:15:37 -0700
In-Reply-To: <20220429211540.715151-1-sdf@google.com>
Message-Id: <20220429211540.715151-8-sdf@google.com>
Mime-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH bpf-next v6 07/10] libbpf: add lsm_cgoup_sock type
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lsm_cgroup/ is the prefix for BPF_LSM_CGROUP.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 63c0f412266c..3177bf2fbf5e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8967,6 +8967,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("fmod_ret.s+",		TRACING, BPF_MODIFY_RETURN, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_trace),
 	SEC_DEF("fexit.s+",		TRACING, BPF_TRACE_FEXIT, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_trace),
 	SEC_DEF("freplace+",		EXT, 0, SEC_ATTACH_BTF, attach_trace),
+	SEC_DEF("lsm_cgroup+",		LSM, BPF_LSM_CGROUP, SEC_ATTACH_BTF),
 	SEC_DEF("lsm+",			LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
 	SEC_DEF("lsm.s+",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
 	SEC_DEF("iter+",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
@@ -9390,6 +9391,7 @@ void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
 		*kind = BTF_KIND_TYPEDEF;
 		break;
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP:
 		*prefix = BTF_LSM_PREFIX;
 		*kind = BTF_KIND_FUNC;
 		break;
-- 
2.36.0.464.gb9c8b46e94-goog

