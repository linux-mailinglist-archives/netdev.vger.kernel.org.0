Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859454DE9A0
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbiCSRc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243386AbiCSRcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:20 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D594578A;
        Sat, 19 Mar 2022 10:30:50 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mm17-20020a17090b359100b001c6da62a559so1303235pjb.3;
        Sat, 19 Mar 2022 10:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cDbZmnyIct7dh5oDHwzWtZU+1KNpHzcJsMgS0/FqC04=;
        b=qSUGKlq9jr+L42BLcgqJwPR3lzz7NGXgeJc3Ei2E1+bUYjo0YyU+vCBYGWCPEhjQZC
         VvMCBJMqT/taNLtjl93gvIrB1/F7XpPn2Zb1inz+Lm+jQXUHszDGKJHFo4CfzE/i+22I
         cEXJVHx9YcusE6ibDBjce99Df8IAw19ABmTNMKjX0u3iNaDmjW2WdWmVAxYx9nY42pZZ
         jHVT3wqvwOn/+fdvWV1z+drzYTj/5QmjJbwIBVjymZA8B/iz7Z2TW8NpHoP8ZKsmq7D1
         s80vFs2WJQB8qg/6iNqif2OKYOm1tBmGisy7CEaXUnqQFK8DDSiBo/UKnLRzvVdV9uzz
         EPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cDbZmnyIct7dh5oDHwzWtZU+1KNpHzcJsMgS0/FqC04=;
        b=hxGOmfQpwgkSJ83rsr10ijvu+BqRc/cuLjRzFyPCr96iER4Hux4nWbUF4DY65rNMxZ
         IM5W9fypPVV7a0uQTTny8ZpxPDfuTi9N8hYwVo5MEby+b0cObuUfsFVvaU1aAUClxrFS
         xhwMqx4wWQAGW2iLSOcO7wiCx8Zg0ZdhG4aMo5aNtUJwGokEQUGOfLepHWQneTdK8Kc1
         QcnMcyA7gY3RwXbHjLLum+rFzYkPeS6Hn31pCeTRu7DYgn7Pt0ca1YHKcaVir1iifayt
         6FOkW4r7J+s7JvwGPQj1fcsyy6wZ+vyKompXUWhvMrGk8mstHHsCM9+ypVOdOlbdxHOi
         e5LQ==
X-Gm-Message-State: AOAM532i/yRK2W61/81o3i2NiVaeqgqZ3aIHyG507ZS/32U6WHGt1pyA
        gmOXopbkNXgqUHWjzLERQwU=
X-Google-Smtp-Source: ABdhPJzfqmK2Zh6x7voOpbJTgq3UTIo40u8y9v1MPFqLp/68HUc5AdKYX5mafm02kCF7iYc3MKftCg==
X-Received: by 2002:a17:90b:3b43:b0:1c6:f878:ea52 with SMTP id ot3-20020a17090b3b4300b001c6f878ea52mr459431pjb.68.1647711049850;
        Sat, 19 Mar 2022 10:30:49 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:49 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 08/14] bpf: Aggregate flags for BPF_PROG_LOAD command
Date:   Sat, 19 Mar 2022 17:30:30 +0000
Message-Id: <20220319173036.23352-9-laoar.shao@gmail.com>
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

It will be easy to read if we aggregate the flags for BPF_PROG_LOAD into

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/uapi/linux/bpf.h       | 15 +++++++++------
 tools/include/uapi/linux/bpf.h | 15 +++++++++------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e2dba6cdd88d..93ee04fb8c62 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1065,12 +1065,14 @@ enum bpf_link_type {
 #define BPF_F_ALLOW_MULTI	(1U << 1)
 #define BPF_F_REPLACE		(1U << 2)
 
+/* flags for BPF_PROG_LOAD command */
+enum {
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
  * verifier will perform strict alignment checking as if the kernel
  * has been built with CONFIG_EFFICIENT_UNALIGNED_ACCESS not set,
  * and NET_IP_ALIGN defined to 2.
  */
-#define BPF_F_STRICT_ALIGNMENT	(1U << 0)
+	BPF_F_STRICT_ALIGNMENT	= (1U << 0),
 
 /* If BPF_F_ANY_ALIGNMENT is used in BPF_PROF_LOAD command, the
  * verifier will allow any alignment whatsoever.  On platforms
@@ -1084,7 +1086,7 @@ enum bpf_link_type {
  * of an unaligned access the alignment check would trigger before
  * the one we are interested in.
  */
-#define BPF_F_ANY_ALIGNMENT	(1U << 1)
+	BPF_F_ANY_ALIGNMENT		= (1U << 1),
 
 /* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
  * Verifier does sub-register def/use analysis and identifies instructions whose
@@ -1102,10 +1104,10 @@ enum bpf_link_type {
  * Then, if verifier is not doing correct analysis, such randomization will
  * regress tests to expose bugs.
  */
-#define BPF_F_TEST_RND_HI32	(1U << 2)
+	BPF_F_TEST_RND_HI32		= (1U << 2),
 
 /* The verifier internal test flag. Behavior is undefined */
-#define BPF_F_TEST_STATE_FREQ	(1U << 3)
+	BPF_F_TEST_STATE_FREQ	= (1U << 3),
 
 /* If BPF_F_SLEEPABLE is used in BPF_PROG_LOAD command, the verifier will
  * restrict map and helper usage for such programs. Sleepable BPF programs can
@@ -1113,12 +1115,13 @@ enum bpf_link_type {
  * Such programs are allowed to use helpers that may sleep like
  * bpf_copy_from_user().
  */
-#define BPF_F_SLEEPABLE		(1U << 4)
+	BPF_F_SLEEPABLE			= (1U << 4),
 
 /* If BPF_F_XDP_HAS_FRAGS is used in BPF_PROG_LOAD command, the loaded program
  * fully support xdp frags.
  */
-#define BPF_F_XDP_HAS_FRAGS	(1U << 5)
+	BPF_F_XDP_HAS_FRAGS		= (1U << 5),
+};
 
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
  * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e2dba6cdd88d..71a4d8fdc880 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1065,12 +1065,14 @@ enum bpf_link_type {
 #define BPF_F_ALLOW_MULTI	(1U << 1)
 #define BPF_F_REPLACE		(1U << 2)
 
+/* flags for BPF_PROG_LOAD */
+enum {
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
  * verifier will perform strict alignment checking as if the kernel
  * has been built with CONFIG_EFFICIENT_UNALIGNED_ACCESS not set,
  * and NET_IP_ALIGN defined to 2.
  */
-#define BPF_F_STRICT_ALIGNMENT	(1U << 0)
+	BPF_F_STRICT_ALIGNMENT	= (1U << 0),
 
 /* If BPF_F_ANY_ALIGNMENT is used in BPF_PROF_LOAD command, the
  * verifier will allow any alignment whatsoever.  On platforms
@@ -1084,7 +1086,7 @@ enum bpf_link_type {
  * of an unaligned access the alignment check would trigger before
  * the one we are interested in.
  */
-#define BPF_F_ANY_ALIGNMENT	(1U << 1)
+	BPF_F_ANY_ALIGNMENT		= (1U << 1),
 
 /* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
  * Verifier does sub-register def/use analysis and identifies instructions whose
@@ -1102,10 +1104,10 @@ enum bpf_link_type {
  * Then, if verifier is not doing correct analysis, such randomization will
  * regress tests to expose bugs.
  */
-#define BPF_F_TEST_RND_HI32	(1U << 2)
+	BPF_F_TEST_RND_HI32		= (1U << 2),
 
 /* The verifier internal test flag. Behavior is undefined */
-#define BPF_F_TEST_STATE_FREQ	(1U << 3)
+	BPF_F_TEST_STATE_FREQ	= (1U << 3),
 
 /* If BPF_F_SLEEPABLE is used in BPF_PROG_LOAD command, the verifier will
  * restrict map and helper usage for such programs. Sleepable BPF programs can
@@ -1113,12 +1115,13 @@ enum bpf_link_type {
  * Such programs are allowed to use helpers that may sleep like
  * bpf_copy_from_user().
  */
-#define BPF_F_SLEEPABLE		(1U << 4)
+	BPF_F_SLEEPABLE			= (1U << 4),
 
 /* If BPF_F_XDP_HAS_FRAGS is used in BPF_PROG_LOAD command, the loaded program
  * fully support xdp frags.
  */
-#define BPF_F_XDP_HAS_FRAGS	(1U << 5)
+	BPF_F_XDP_HAS_FRAGS		= (1U << 5),
+};
 
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
  * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
-- 
2.17.1

