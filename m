Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380D64F4564
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345114AbiDEO1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239511AbiDEOUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:20:53 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E17A5AA74;
        Tue,  5 Apr 2022 06:09:24 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n8so3872808plh.1;
        Tue, 05 Apr 2022 06:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e7h678A3Z9dtT+vLHepLvCuBNMaFE7eBOdemadD1GkA=;
        b=gL60ETTYwMSF9S6lSfB+riFJwONbr0gQ0XOOmbeDQ8MfDPDWgGAXDkRQkNnWQkHbrI
         GUc1Yx7KC51He/ojiI+iGoyfNlw9YJskqZNQBOtvJFnDHpXn6KSCiiS7G08NRIn4jJ47
         xM2StckvVGB6eTa4lUxyiag/BzPYRk7L5xGqL+UWc1+xubFKcBjHtuqqqi7M7HZglY6S
         RoTmlLYpfaiqTDLJLtuttWh0Ixj/7anxJqEFgp4qq0yqqCqKJZ/Ogy7D+8JwoExMOuDL
         VXn1aQTJciAk8uzu+rsRsfIgBSnzr6iFVR9FnVgXx0nYlgMMWB3H0BZgPirpMVW79EdR
         hLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e7h678A3Z9dtT+vLHepLvCuBNMaFE7eBOdemadD1GkA=;
        b=NQMbEcNfyk97XIaAfboLKgzRdSU3KfgRZ1+GTGnPfgh5Ea/Nl8petPUkpab4UzJq3d
         MwBeyF8sQ8EN/zk1V0Z623F2WFBuqP8w6hwDJzChRRyxRnjFS6LTxAFJ6+FqCTCKL+lB
         OGt0WPDxP59Km6g219VDug0oApEyOy+ZRJdSkWquqPNDKGuPleyQduXbdK+RZkpkKQvt
         VciEZt3OHbPTwTRfxQGQcmK7Cu94a/seYG/fUhPT9j+dQeWYil2dZRCxThBCJiI6t7Il
         V/o7qO0hM+6YamPquvwM7ijG0Ph2NZsCs+P5wFBp0XOfROEkpvWmdXK395ULu5StyxkT
         0bUw==
X-Gm-Message-State: AOAM531nNb5u11WuRds42DJ74rtltCljCMpv1xUm/NGfBrZWQ6xL5oSd
        WANNI2uV4CgJPHFwZ6NKy+w=
X-Google-Smtp-Source: ABdhPJz+VL0kHePQd8+gB9dHNyE2n0Xf9ckgX8e2hOjiCTRh3uvdCTSNR4hu7LF28GL3CJts4yoVMw==
X-Received: by 2002:a17:902:ba8c:b0:14f:d9b7:ab4 with SMTP id k12-20020a170902ba8c00b0014fd9b70ab4mr3372059pls.23.1649164163919;
        Tue, 05 Apr 2022 06:09:23 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:23 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 07/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in get_cgroup_id_user
Date:   Tue,  5 Apr 2022 13:08:38 +0000
Message-Id: <20220405130858.12165-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
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

Let's set libbpf 1.0 API mode explicitly, then we can get rid of the
included bpf_rlimit.h.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/test_dev_cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_dev_cgroup.c b/tools/testing/selftests/bpf/test_dev_cgroup.c
index c299d3452695..7886265846a0 100644
--- a/tools/testing/selftests/bpf/test_dev_cgroup.c
+++ b/tools/testing/selftests/bpf/test_dev_cgroup.c
@@ -15,7 +15,6 @@
 
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
-#include "bpf_rlimit.h"
 
 #define DEV_CGROUP_PROG "./dev_cgroup.o"
 
@@ -28,6 +27,9 @@ int main(int argc, char **argv)
 	int prog_fd, cgroup_fd;
 	__u32 prog_cnt;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (bpf_prog_test_load(DEV_CGROUP_PROG, BPF_PROG_TYPE_CGROUP_DEVICE,
 			  &obj, &prog_fd)) {
 		printf("Failed to load DEV_CGROUP program\n");
-- 
2.17.1

