Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B81455A2E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343928AbhKRL3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:29:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47313 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343912AbhKRL23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:28:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FziBM/Abk38ZsIcsX8WUe178lP8av41CXsWZwffEWF4=;
        b=dp87VThlV8r38SECUmklwAN0ziYusydSUGvtDFJO2XkUQkujqk3WC6C38LFfiH1jlyLHlY
        HnYBxNyBYa+ZW8nfgPT93fLtGOCV0+AA1EI6utX2dJc39jHoOAMTKbo15gc8A4loBZlYPC
        ZB6iZiNl6CqpNP84ZBeJc19qus2ldO4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-123-mcBNma4UNfS3-AbA-yujPA-1; Thu, 18 Nov 2021 06:25:28 -0500
X-MC-Unique: mcBNma4UNfS3-AbA-yujPA-1
Received: by mail-ed1-f70.google.com with SMTP id m8-20020a056402510800b003e29de5badbso4961891edd.18
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:25:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FziBM/Abk38ZsIcsX8WUe178lP8av41CXsWZwffEWF4=;
        b=fAzKGXMToJWPt/h7Val3nmJpjZ6Mzuhy6LZer0YsoUKxBxsU93ctAm/3gnSoy8H8mE
         e/irjGvQZJ072jbCLBxu8hrBFuaV5r5l7kP9XWjFS36ReslGOmO0iuoWKXzC2X4oWzYB
         0iXIwlMJyW3Ly3AxgC240B/WJm07bSCzPRXyuKW40NGQOTE8OnAvW4CoikPA+sBpjc6i
         Ho5VZNipZU7jqM5ARDkWodYBKygyU9mOdfbxizoqxCVcGcuhUIn66uJ88KjDdGUrMyaR
         LMSKJZkjb3hgm1MkMi66KOMx6HWgeEbBjsJakmv226jn5rQKJtVq9uPuKnrMpgy0bJ4t
         zwkA==
X-Gm-Message-State: AOAM532FsetFvMA2xtBZ8yWbt26CSxj44zxF0Vje1hsI6zbI3kes0uMd
        Q6TCCiuUTnTlJXTl9p46R166Y3YJmC5GoG1FRt5IXjq6l0QuckmqEIClHsMxwC93QJd51c/wPMN
        H6u5NWgVp9OrS+IK/
X-Received: by 2002:a50:ef02:: with SMTP id m2mr10171533eds.172.1637234727230;
        Thu, 18 Nov 2021 03:25:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwibvICcLQ2tYVo+N7H3O2OA40ycE0Lvf9i8jybkUJAsfZom/RYr7fy5OAjx+XkJ8L5+N/sOw==
X-Received: by 2002:a50:ef02:: with SMTP id m2mr10171509eds.172.1637234727119;
        Thu, 18 Nov 2021 03:25:27 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id d3sm1443289edx.79.2021.11.18.03.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:25:26 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 05/29] bpf: Add bpf_check_attach_model function
Date:   Thu, 18 Nov 2021 12:24:31 +0100
Message-Id: <20211118112455.475349-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_check_attach_model function that returns
model for function specified by btf_id. It will be
used in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf_verifier.h |  4 ++++
 kernel/bpf/verifier.c        | 29 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index c8a78e830fca..b561c0b08e68 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -527,6 +527,10 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    const struct bpf_prog *tgt_prog,
 			    u32 btf_id,
 			    struct bpf_attach_target_info *tgt_info);
+int bpf_check_attach_model(const struct bpf_prog *prog,
+			   const struct bpf_prog *tgt_prog,
+			   u32 btf_id,
+			   struct btf_func_model *fmodel);
 void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab);
 
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cbbbf47e1832..fac0c3518add 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13749,6 +13749,35 @@ static int __bpf_check_attach_target(struct bpf_verifier_log *log,
 	return 0;
 }
 
+int bpf_check_attach_model(const struct bpf_prog *prog,
+			   const struct bpf_prog *tgt_prog,
+			   u32 btf_id,
+			   struct btf_func_model *fmodel)
+{
+	struct attach_target target = { };
+	int ret;
+
+	ret = __bpf_check_attach_target(NULL, prog, tgt_prog, btf_id, &target);
+	if (ret)
+		return ret;
+
+	switch (prog->expected_attach_type) {
+	case BPF_TRACE_RAW_TP:
+		break;
+	case BPF_TRACE_ITER:
+		ret = btf_distill_func_proto(NULL, target.btf, target.t, target.tname, fmodel);
+		break;
+	default:
+	case BPF_MODIFY_RETURN:
+	case BPF_LSM_MAC:
+	case BPF_TRACE_FENTRY:
+	case BPF_TRACE_FEXIT:
+		ret = btf_distill_func_proto(NULL, target.btf, target.t, target.tname, fmodel);
+	}
+
+	return ret;
+}
+
 int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    const struct bpf_prog *prog,
 			    const struct bpf_prog *tgt_prog,
-- 
2.31.1

