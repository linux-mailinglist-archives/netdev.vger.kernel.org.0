Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5EC46DC49
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbhLHTgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:36:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229596AbhLHTgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638991983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xfqpItyomI+dtyHvU+6aTJqTVDXGGgAkWkumRRvbZyA=;
        b=O518/tH6XaZM/8U1qxYCOS5VNQI1783AkbdQftHqTERWpkBA4hwRSr3UFW3imBa08iquy1
        ftHMggtBgjJLvsMNaVQfjEiGEZfSvnsDt6eU0fYclHalZ+QZEk5sQyhjqU2uo4n73BfAGu
        af30w6zyr4RvHiAqcclNVFo80lRE90M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-WKmg-COLM-G2SHveoXT85g-1; Wed, 08 Dec 2021 14:33:01 -0500
X-MC-Unique: WKmg-COLM-G2SHveoXT85g-1
Received: by mail-wm1-f70.google.com with SMTP id 144-20020a1c0496000000b003305ac0e03aso3497964wme.8
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 11:33:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xfqpItyomI+dtyHvU+6aTJqTVDXGGgAkWkumRRvbZyA=;
        b=FHCy3cF/ZTegF2XRbbNVtln/zWlQP64oL2JqIj0LHH0lFbHmTg+KQWghVJMLOprJDm
         LURnJL9OJpssiRmMCFpZKQ/TRUw2Jiga+vpKlFDvxXtV1SywDQcf+w0RyjAl1idRCLk0
         /RV0eOF1PvWZAd4TyhvbhpGX86zaYnCt9nM1frDEsgd/oHecTQHTXi/8v+2iTehelxp4
         mLa/LPB1C9Ba5zsVcsnqKVpb66qbf1P6Ee3/c5GP+27rDL48LaM94GjJn6SjdK2MM9qA
         OON3tY0btOGXtmTFyKXUik3I3Z86hjidX0mNpZwhYgyPF3ma41eaFZ2M1UFSK70I6UXy
         VbQA==
X-Gm-Message-State: AOAM532oAv0xiuR9NUeuYBl3eM4OfT/nWYoaXuwD/qDiFzrKRAcdJsS6
        RNcp/T48a/cO16cI+QkgA+XBRe/VLFDk8iolQe4H0dIaAlBJBhj/jKrfv/dDatfBO4X0d7u8nhN
        BXm/lzsqhgDayd1+0
X-Received: by 2002:a5d:464c:: with SMTP id j12mr800141wrs.150.1638991980624;
        Wed, 08 Dec 2021 11:33:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5IsXY/f0H2nXLi7o/OKZGN3lrtAfbpaKvcdnoxc58VS16OwBy9wF0WvldUD4loH89qQ7JnA==
X-Received: by 2002:a5d:464c:: with SMTP id j12mr800119wrs.150.1638991980427;
        Wed, 08 Dec 2021 11:33:00 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id t127sm6704194wma.9.2021.12.08.11.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:33:00 -0800 (PST)
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
Subject: [PATCHv2 bpf-next 2/5] selftests/bpf: Add test to access int ptr argument in tracing program
Date:   Wed,  8 Dec 2021 20:32:42 +0100
Message-Id: <20211208193245.172141-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211208193245.172141-1-jolsa@kernel.org>
References: <20211208193245.172141-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding verifier test for accessing int pointer argument in
tracing programs.

The test program loads 2nd argument of bpf_modify_return_test
function which is int pointer and checks that verifier allows
that.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../testing/selftests/bpf/verifier/btf_ctx_access.c  | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/btf_ctx_access.c

diff --git a/tools/testing/selftests/bpf/verifier/btf_ctx_access.c b/tools/testing/selftests/bpf/verifier/btf_ctx_access.c
new file mode 100644
index 000000000000..6340db6b46dc
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/btf_ctx_access.c
@@ -0,0 +1,12 @@
+{
+	"btf_ctx_access accept",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 8),	/* load 2nd argument value (int pointer) */
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACING,
+	.expected_attach_type = BPF_TRACE_FENTRY,
+	.kfunc = "bpf_modify_return_test",
+},
-- 
2.33.1

