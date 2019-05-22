Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1788326A36
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfEVS4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:56:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36925 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbfEVSz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:55:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so3294593wmo.2
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DX8u14woMWB0/T1N/svKd1Gm9eJRtJGFELY8NQbCyRY=;
        b=Mz7ysbNmLaE5gXN/Po+j5Ryh+3M1HCEftgGzCvxwZKFPUdCHAk/lkQzfKqDf/m4R95
         PGynSLOuCH3N/kiowCR6PVWvl08QXWvgQMVlYmmv8ZNeglq4QqDIkrMHCiK9v6bjBwlf
         JQCz0/vq6UvFk78DIHDJvPg4KovxNQZ8mzA6In2bjxe2NLJzix1hAUeTqY5hP71dLfEo
         2acX/Cj/SYIJvKyPl67x0s1PqsdfxGNArNBl2xjs/F9K7Chm8Zm/eJGU28IZRXwgakY/
         nZJ1K1y2gf7Z587FAkK5QLd+KvG10qCZVHgr8vAffv+Z6zruohEckDHXCg/Gk5HAHbYM
         pbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DX8u14woMWB0/T1N/svKd1Gm9eJRtJGFELY8NQbCyRY=;
        b=aEGwEinWt39MpjgmGRD5hOeM/RCo7f0g0UyBnEdlBaDiuwrWDFEkXCgK27OWaBTLNB
         a3vcU8OyaLy4L9qshE+qzso+qzuoMpVxllJ4ofvrcrqPH+sk9tTOBKrwnE1MOSndvDuJ
         llNiCNSDjHWdKCcJTyS3e2m7LXMHE+R+QnV//1R2ON6bxkqIiWceAlZ3nF0sDa6Qlym1
         j2rfA9jZBghm537R1oHD3kztOjDrpl4xBFE7KAzNjMC19iH7DSYE3DdOe2rD7gZijf3J
         3qi9/kMAPp3kxyxt6Zwvmng5iH/uCfHknyh4fhAqnmzJhAbXS8oHcGSGKaL4rDdZfDDP
         QCjA==
X-Gm-Message-State: APjAAAVUMZUJN1tKl5iSJIAeYAA81BzTsLwLI+OA5TgBVL3rPBMnGqxV
        eVtj7D5pirCzZI0GqU32AxI10Q==
X-Google-Smtp-Source: APXvYqx+Q4YYoHPEBaixzN8UXhyR6bv0r+b41ChEEjMTzEYLzWFAvcxECeHrTyDklxvdJpTtj1qGmw==
X-Received: by 2002:a1c:9d0f:: with SMTP id g15mr8580188wme.97.1558551354525;
        Wed, 22 May 2019 11:55:54 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.55.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:55:53 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 05/16] bpf: introduce new bpf prog load flags "BPF_F_TEST_RND_HI32"
Date:   Wed, 22 May 2019 19:55:01 +0100
Message-Id: <1558551312-17081-6-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

x86_64 and AArch64 perhaps are two arches that running bpf testsuite
frequently, however the zero extension insertion pass is not enabled for
them because of their hardware support.

It is critical to guarantee the pass correction as it is supposed to be
enabled at default for a couple of other arches, for example PowerPC,
SPARC, arm, NFP etc. Therefore, it would be very useful if there is a way
to test this pass on for example x86_64.

The test methodology employed by this set is "poisoning" useless bits. High
32-bit of a definition is randomized if it is identified as not used by any
later insn. Such randomization is only enabled under testing mode which is
gated by the new bpf prog load flags "BPF_F_TEST_RND_HI32".

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/uapi/linux/bpf.h       | 18 ++++++++++++++++++
 kernel/bpf/syscall.c           |  4 +++-
 tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 63e0cf6..daac8df 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -260,6 +260,24 @@ enum bpf_attach_type {
  */
 #define BPF_F_ANY_ALIGNMENT	(1U << 1)
 
+/* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
+ * Verifier does sub-register def/use analysis and identifies instructions whose
+ * def only matters for low 32-bit, high 32-bit is never referenced later
+ * through implicit zero extension. Therefore verifier notifies JIT back-ends
+ * that it is safe to ignore clearing high 32-bit for these instructions. This
+ * saves some back-ends a lot of code-gen. However such optimization is not
+ * necessary on some arches, for example x86_64, arm64 etc, whose JIT back-ends
+ * hence hasn't used verifier's analysis result. But, we really want to have a
+ * way to be able to verify the correctness of the described optimization on
+ * x86_64 on which testsuites are frequently exercised.
+ *
+ * So, this flag is introduced. Once it is set, verifier will randomize high
+ * 32-bit for those instructions who has been identified as safe to ignore them.
+ * Then, if verifier is not doing correct analysis, such randomization will
+ * regress tests to expose bugs.
+ */
+#define BPF_F_TEST_RND_HI32	(1U << 2)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cb5440b..3d546b6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1604,7 +1604,9 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (CHECK_ATTR(BPF_PROG_LOAD))
 		return -EINVAL;
 
-	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT | BPF_F_ANY_ALIGNMENT))
+	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
+				 BPF_F_ANY_ALIGNMENT |
+				 BPF_F_TEST_RND_HI32))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 63e0cf6..daac8df 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -260,6 +260,24 @@ enum bpf_attach_type {
  */
 #define BPF_F_ANY_ALIGNMENT	(1U << 1)
 
+/* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
+ * Verifier does sub-register def/use analysis and identifies instructions whose
+ * def only matters for low 32-bit, high 32-bit is never referenced later
+ * through implicit zero extension. Therefore verifier notifies JIT back-ends
+ * that it is safe to ignore clearing high 32-bit for these instructions. This
+ * saves some back-ends a lot of code-gen. However such optimization is not
+ * necessary on some arches, for example x86_64, arm64 etc, whose JIT back-ends
+ * hence hasn't used verifier's analysis result. But, we really want to have a
+ * way to be able to verify the correctness of the described optimization on
+ * x86_64 on which testsuites are frequently exercised.
+ *
+ * So, this flag is introduced. Once it is set, verifier will randomize high
+ * 32-bit for those instructions who has been identified as safe to ignore them.
+ * Then, if verifier is not doing correct analysis, such randomization will
+ * regress tests to expose bugs.
+ */
+#define BPF_F_TEST_RND_HI32	(1U << 2)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
-- 
2.7.4

