Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9748256782A
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiGEUFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiGEUFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:05:03 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE7C167FB
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 13:05:00 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso10376437wma.2
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 13:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W+9ND9gGDdv03MueNmUboLKE7fp+u4ZOtfMBglb+qFM=;
        b=MSjFFclrhQB6GcyXKubNcqzLwyOc83+SKMLlqYJnE2Ki2a7LHlP6I7OkFEWusLaXls
         95mLE2/hkX1bODVhwxAylRgMoIiZ9KHTRC+1QO6CeGa8P3y4Y3KzuD2k8A9191sAuUAq
         rdqJRLr1jcX/ufMOcWTtlvfjhHazK8Ps+k+qAvP+drnP/P1/51GA80g3cHr3VkSwJUr+
         J6zLY+2JAJuFcYSP9n9nwhFBoM5x+t14o0BQKzZCKuolmwyxpFZc3+BxH6WgbzSs8Q2N
         LAZDpjWosmRI6x9JPWkjlEPiGRu1e0Ko9cmrflBA2sgqEbaW2WJmVmAZwYiqmjPc/Lqp
         m2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W+9ND9gGDdv03MueNmUboLKE7fp+u4ZOtfMBglb+qFM=;
        b=3Jn1rdo7qc1OSOLlly8ilu61ezUzWHXukHwvAYjiGQ5lY1TAheFajFxrD8+i5cGfJg
         sVbscJ6NTrzPzNLEprMOshoOpuM3VFPU9ZnrAwYI/3mpYfIWGUAmxuXTLG6gh4mw6J3C
         amXFGkCsD2WgsV/795QVya7tmZpxddNGpasU9ebZavQYty6xRtm6VjXAGf7QWZudxkIr
         rt6XPN5yqzbUyQp8331bazzikrydnJHyBcP2ieScsHs5gOttMs5dF9f0EIwuxn5DWbBX
         vfGzYJyI26mnfavNL5OBVuM/sFGYHOqCBAVMPJc1omitX+KmCioSEsg8NEjwXxiPLhYq
         c9UA==
X-Gm-Message-State: AJIora81/JqA2Ddpd7kWiWkInalQe0nTnV8hA0XWXau7TPLiWoAyRjCG
        lbofuEBR/bj+vsnr03ryvkP2MA==
X-Google-Smtp-Source: AGRyM1sTO0BLYQsF5GZRzZkMwHEe/+p1FooN2FbYJgy1KdEvaM53Gf77cf2KD6EYaT/HMNc2uaM9mw==
X-Received: by 2002:a05:600c:1d94:b0:3a0:4e09:122f with SMTP id p20-20020a05600c1d9400b003a04e09122fmr40462903wms.190.1657051499044;
        Tue, 05 Jul 2022 13:04:59 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id az38-20020a05600c602600b003a0323463absm23552144wmb.45.2022.07.05.13.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 13:04:58 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] bpftool: Remove zlib feature test from Makefile
Date:   Tue,  5 Jul 2022 21:04:56 +0100
Message-Id: <20220705200456.285943-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The feature test to detect the availability of zlib in bpftool's
Makefile does not bring much. The library is not optional: it may or may
not be required along libbfd for disassembling instructions, but in any
case it is necessary to build feature.o or even libbpf, on which bpftool
depends.

If we remove the feature test, we lose the nicely formatted error
message, but we get a compiler error about "zlib.h: No such file or
directory", which is equally informative. Let's get rid of the test.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index c19e0e4c41bd..e64b81e1c1ba 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -93,9 +93,9 @@ INSTALL ?= install
 RM ?= rm -f
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args zlib libcap \
+FEATURE_TESTS = libbfd disassembler-four-args libcap \
 	clang-bpf-co-re
-FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
+FEATURE_DISPLAY = libbfd disassembler-four-args libcap \
 	clang-bpf-co-re
 
 check_feat := 1
@@ -204,11 +204,6 @@ $(BOOTSTRAP_OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 	$(QUIET_CC)$(CC) $(CFLAGS) -c -MMD $< -o $@
 
-$(OUTPUT)feature.o:
-ifneq ($(feature-zlib), 1)
-	$(error "No zlib found")
-endif
-
 $(BPFTOOL_BOOTSTRAP): $(BOOTSTRAP_OBJS) $(LIBBPF_BOOTSTRAP)
 	$(QUIET_LINK)$(HOSTCC) $(HOST_CFLAGS) $(LDFLAGS) $(BOOTSTRAP_OBJS) $(LIBS_BOOTSTRAP) -o $@
 
-- 
2.34.1

