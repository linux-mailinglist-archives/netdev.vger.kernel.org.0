Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B870A3F255A
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 05:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbhHTDbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 23:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237933AbhHTDbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 23:31:51 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994A2C061575;
        Thu, 19 Aug 2021 20:31:14 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id t66so9624497qkb.0;
        Thu, 19 Aug 2021 20:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o71P6Ra+Zi7C6O03ccvneZzNal5clWO5NdzPrype27A=;
        b=p0xG8PkSTCBoEQMuhsRmO+NkOvz21M9ONlm+0sP4280qmyXFg8uESSQ1cqmyaIdikY
         OyldHtq6mileVjvMeuRJUtrHhEZyedWkPmc80S4U4U28WP06OAmK2ll2ffTkh3Xed261
         mDoD3Ubfy3T7tnREsmaEBeoRHvziD/TjDw8Exp+LKLMwe2OpTefyXRG59gJV8EGUemwn
         TK5m45hgnXO4srgJuQgsNF8jTRrIVuugFUFWqoHI9KtNiCWrbEwlswqlVjlqCTUFX6tF
         CBZkoAad+x4kVMmQyt/I3mHKVYMgL0AYxt9VXRpepppJf1l1W6GuFoHMHPzSL18zCQFA
         XeQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o71P6Ra+Zi7C6O03ccvneZzNal5clWO5NdzPrype27A=;
        b=C+OPzX5r2wgvCNx6GY4IVyYDLE+jfKP6P64XqFl+GeM2E1NMck8NwAx9YCRl8sWFNq
         ZYIFtmF21WjXmTkC/Hz4l4jWnlRjM8gRq5jUaExVB0Lee6ZU570TN1p59wm8lg321KJI
         BQMTLV/tyEL9i/OREXlvMQr5ndQhLnDUb1t/cdweLc6dksTMX2Y+4G0v6Z3ui/hoMkn4
         X91AZz+N5R9CFd+Q1aoluf621Wydlb/g8IImUW4kdVsqH3rH1Hwp6CeH1bGeosI0Eg17
         ixLofFdD5dwcMFl4st8LiIftYzwwF/sfWDUfP8y57Np4J+T0VfTSLXPxACfBkq1AMjP1
         e+4Q==
X-Gm-Message-State: AOAM531rWsPac/ySFSBg80V0dXzV8wwM9Y7NIhmwFrOX23iFWHyYtequ
        HNxM/3tMD39ituOviC1uTzg=
X-Google-Smtp-Source: ABdhPJzE4RKGFzyux0S+iKMw4H1k9x+N/4CRw7n8C5pMAXXQrT4/RjeUmvcJwL81kcuONsHkZ0de7w==
X-Received: by 2002:a05:620a:1671:: with SMTP id d17mr6880822qko.191.1629430273893;
        Thu, 19 Aug 2021 20:31:13 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p188sm2628878qka.114.2021.08.19.20.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 20:31:13 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <jing.yangyang@zte.com.cn>
To:     Shuah Khan <shuah@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrei Matei <andreimatei1@gmail.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] tools: fix warning comparing pointer to 0
Date:   Thu, 19 Aug 2021 20:30:57 -0700
Message-Id: <20210820033057.13063-1-jing.yangyang@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jing yangyang <jing.yangyang@zte.com.cn>

Fix the following coccicheck warning:
./tools/testing/selftests/bpf/progs/profiler.inc.h:364:18-22:WARNING
comparing pointer to 0
./tools/testing/selftests/bpf/progs/profiler.inc.h:537:23-27:WARNING
comparing pointer to 0
./tools/testing/selftests/bpf/progs/profiler.inc.h:544:21-25:WARNING
comparing pointer to 0
./tools/testing/selftests/bpf/progs/profiler.inc.h:770:13-17:WARNING
comparing pointer to 0

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
---
 tools/testing/selftests/bpf/progs/profiler.inc.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
index 4896fdf..5c0bdab 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -361,7 +361,7 @@ static INLINE void* populate_var_metadata(struct var_metadata_t* metadata,
 	int zero = 0;
 	struct var_kill_data_t* kill_data = bpf_map_lookup_elem(&data_heap, &zero);
 
-	if (kill_data == NULL)
+	if (!kill_dat)
 		return NULL;
 	struct task_struct* task = (struct task_struct*)bpf_get_current_task();
 
@@ -534,14 +534,14 @@ static INLINE bool is_dentry_allowed_for_filemod(struct dentry* file_dentry,
 	*device_id = dev_id;
 	bool* allowed_device = bpf_map_lookup_elem(&allowed_devices, &dev_id);
 
-	if (allowed_device == NULL)
+	if (!allowed_device)
 		return false;
 
 	u64 ino = BPF_CORE_READ(file_dentry, d_inode, i_ino);
 	*file_ino = ino;
 	bool* allowed_file = bpf_map_lookup_elem(&allowed_file_inodes, &ino);
 
-	if (allowed_file == NULL)
+	if (!allowed_fil)
 		if (!is_ancestor_in_allowed_inodes(BPF_CORE_READ(file_dentry, d_parent)))
 			return false;
 	return true;
@@ -689,7 +689,7 @@ int raw_tracepoint__sched_process_exec(struct bpf_raw_tracepoint_args* ctx)
 	u64 inode = BPF_CORE_READ(bprm, file, f_inode, i_ino);
 
 	bool* should_filter_binprm = bpf_map_lookup_elem(&disallowed_exec_inodes, &inode);
-	if (should_filter_binprm != NULL)
+	if (should_filter_binprm)
 		goto out;
 
 	int zero = 0;
-- 
1.8.3.1


