Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D968A389069
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354337AbhESORL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353955AbhESOPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:53 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28C5C061350;
        Wed, 19 May 2021 07:14:13 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j14so12459671wrq.5;
        Wed, 19 May 2021 07:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B1YRk/MN/N6oLVTe294bueKKNcMA5klQT+cH/wkOgww=;
        b=FZljZuNTvTkGGeqGsgnBYac0iEIJXuo3oF86e9uVrqPP1pheEtHjr04bmJlwwddajN
         q4ymq3KmjuYIcy/H/BIoybv6jSPehHp6uRrgHHc5BjFfuLiU9WukTDc8fNEYvW4OedpY
         vgEti+c821R2gzt70s8E+EKZPwEww0zkCGShwWVWJHR/rCsHlNdGJCvVediJoKeuhcgn
         y5d3PRV6jmGKZgqjn/MJARQxZNX9Zv6NV+r/egMRKPMJpFAxygiYHJIrC1NDDSM/a7s8
         VZTrU1pSnAxN+frx/Nrvaolw1e9RT/f2+iTv3vRJpy/rJLsFpGm0VOPsljf4SzAYGs9f
         uTGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B1YRk/MN/N6oLVTe294bueKKNcMA5klQT+cH/wkOgww=;
        b=PdK4CeeQ/l+7oi912f1qKd3ol/UMHYCSYYoc30NqqgWzgFIQRP4ypTczc2qBoEHxmF
         nUwFDvOgCx65OBhk3i8MyWPIwZVHuYv2L/ci29niA4H3Y3UxK+/YknW1IABSyvRvojjx
         3XZDXRr362/UUSCx4Z6Xg+v2rPyxC21Ok4GNbH5C3MI5U6SqyChXmkzH+DKHDFWo56jk
         LLro8d5mlKE2Tu3PCLtRGbNpN6j59dWE4FHcWWLe3hcZHv78bofYgcpqtLpEBxRcM/si
         VY1BTdAEjCMNAFOKMOZ9i8G8w+NorUjHKIYXHq9+BXmIKlnSwkwIrWAwnHcCOVcdLQkt
         7Nig==
X-Gm-Message-State: AOAM532E5xUEgFvrpAfGDYHE6aQVSN9ElRAIS6oiq2Lp7qt25gWmKG8V
        C5eEKv7Uu/PReSLLh4AyMIJ2piyenDZ6c9h1
X-Google-Smtp-Source: ABdhPJxVSmlBSXELqxGfzGMozBFO7YPHqorL8KOB1RsWOa3aaj8bv72eqAUXVIGru4vWyFTVqoL5mw==
X-Received: by 2002:adf:e38c:: with SMTP id e12mr14705083wrm.128.1621433652284;
        Wed, 19 May 2021 07:14:12 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [PATCH 18/23] libbpf: support io_uring
Date:   Wed, 19 May 2021 15:13:29 +0100
Message-Id: <94134844a6f4be2e0da2c518cb0e2e9ebb1d71b0.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/lib/bpf/libbpf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4181d178ee7b..de5d1508f58e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13,6 +13,10 @@
 #ifndef _GNU_SOURCE
 #define _GNU_SOURCE
 #endif
+
+/* hack, use local headers instead of system-wide */
+#include "../../../include/uapi/linux/bpf.h"
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdarg.h>
@@ -8630,6 +8634,9 @@ static const struct bpf_sec_def section_defs[] = {
 	BPF_PROG_SEC("struct_ops",		BPF_PROG_TYPE_STRUCT_OPS),
 	BPF_EAPROG_SEC("sk_lookup/",		BPF_PROG_TYPE_SK_LOOKUP,
 						BPF_SK_LOOKUP),
+	SEC_DEF("iouring/",			IOURING),
+	SEC_DEF("iouring.s/",			IOURING,
+		.is_sleepable = true),
 };
 
 #undef BPF_PROG_SEC_IMPL
-- 
2.31.1

