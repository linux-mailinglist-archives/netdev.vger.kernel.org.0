Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956294DE9AB
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243784AbiCSRcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243702AbiCSRcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:22 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AC646B04;
        Sat, 19 Mar 2022 10:30:58 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mz9-20020a17090b378900b001c657559290so10657015pjb.2;
        Sat, 19 Mar 2022 10:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gNHwzX1XXzyuZEkRQLK5ljL7FKM2KTEIhvt/+nJ9w5k=;
        b=cWsSBz1wcJLbkEhvadWb1z178lDBINSMILOr0KYVKwhDbun9djaH9TCmc3V/X47pym
         DuDLtLZW9Mw1cTrnsjsKmlH7ZvuFPFkJ4rsarGoModU082cK1VA+dDJ+GNIc5CwoKx34
         wvQQTZSYyrSVI7T6FfY1aefOUuwaZmC5wiCWxKZqWxV9RepJVsKZh34D2LgSsyFjKZuK
         BUthR6o8mnnz61PINJHyIrwp2uDJw5Xecw1vVn5dz30SLOTpiWnp0p0ojMl2ldLivLyo
         awA5jMvuzOhSmBdGifSsHR9p9ndyhKd83qk3MlNvtLjcTPqaODL9fz9n1vXPSd4moFCf
         +X/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gNHwzX1XXzyuZEkRQLK5ljL7FKM2KTEIhvt/+nJ9w5k=;
        b=XfqoWp/LEYVCUwVdRZ2WhIQ+Oe72Bao3Y5nw/uWn9wt5DQg37rXBw4HCYoiwAXQbeJ
         BdjOFxOaVUMdu+HvTOVe+YYbrKHX1umguWqnKcbzgJIiSeR7eGWkfE02SH3qdv97fbso
         yhcWy9uBR5/A3srgOvB2HvaKAFhW5Qi8KhvaQHZwhlUPCaRCzvKrxIxLdFQTVh5ulBsu
         x3FGU9WUOpuUy/HtDg/0wbAPLKuLSEgyyJawO8HM2oBWCpaaEJ8DSqibsxgFfdinHQAO
         /kdno53tPsg0EomsNp+0HDearF+h/eFraJH3BCfLHtS62FN2bH65P9V55df+o7qXTx17
         cE3Q==
X-Gm-Message-State: AOAM532GiV0mk9FaiBL1V2+9fnUIB8tBHshL6wI/ohMViHWoL5P5Q6VF
        RUHtTYgPhR5Y0KFSIj1jfS8=
X-Google-Smtp-Source: ABdhPJx0WWiyXY4tSlfUjYz1EUtkAZiBSBQOTjQ9TIbe9waIxqXbbGnwv+SSon9nwqQjPI9mhc08Og==
X-Received: by 2002:a17:90a:7305:b0:1bd:6972:faf5 with SMTP id m5-20020a17090a730500b001bd6972faf5mr17517556pjk.131.1647711058332;
        Sat, 19 Mar 2022 10:30:58 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:57 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 14/14] bpf: selftests: Add test case for BPF_F_PROG_NO_CHARGE
Date:   Sat, 19 Mar 2022 17:30:36 +0000
Message-Id: <20220319173036.23352-15-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test case to check if BPF_F_PROG_NO_CHARGE valid.
The result as follows,
 $ ./test_progs
 ...
 #103 no_charge:OK
 ...

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/no_charge.c      | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/no_charge.c

diff --git a/tools/testing/selftests/bpf/prog_tests/no_charge.c b/tools/testing/selftests/bpf/prog_tests/no_charge.c
new file mode 100644
index 000000000000..85fbd2ccbc71
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/no_charge.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <sys/syscall.h>
+
+#include "test_progs.h"
+
+#define BPF_ALU64_IMM(OP, DST, IMM)					\
+	((struct bpf_insn) {							\
+		.code  = BPF_ALU64 | BPF_OP(OP) | BPF_K,	\
+		.dst_reg = DST,								\
+		.src_reg = 0,								\
+		.off   = 0,									\
+		.imm   = IMM })
+
+#define BPF_EXIT_INSN()					\
+	((struct bpf_insn) {				\
+		.code  = BPF_JMP | BPF_EXIT,	\
+		.dst_reg = 0,					\
+		.src_reg = 0,					\
+		.off   = 0,						\
+		.imm   = 0 })
+
+void test_no_charge(void)
+{
+	struct bpf_insn prog[] = {
+		BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	union bpf_attr attr;
+	int duration = 0;
+	int fd;
+
+	bzero(&attr, sizeof(attr));
+	attr.prog_type = BPF_PROG_TYPE_SCHED_CLS;
+	attr.insn_cnt = 2;
+	attr.insns = (__u64)prog;
+	attr.license = (__u64)("GPL");
+	attr.prog_flags |= BPF_F_PROG_NO_CHARGE;
+
+	fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, sizeof(attr));
+	CHECK(fd < 0 && fd != -EPERM, "no_charge", "error: %s\n",
+			strerror(errno));
+
+	if (fd > 0)
+		close(fd);
+}
-- 
2.17.1

