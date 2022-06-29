Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE32560344
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiF2OkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiF2OkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:40:01 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85D635DE8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:00 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso10092284wma.2
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TLrPkusdF6S8ANrlYXvEODEomy1N8W6VIAloIscSP48=;
        b=3N0hZp0k/vyiRkSciRE4WBDSUjDLONA9tgG/qB0ba72j8GUtDVBPWaPZilH9h8GlOa
         qvQVzU825a8yLx3JKR/cWzayS8xrM/9/zWF1ljtBeieBZ6tu1BS/OIBUeHFtTNIlN46K
         +7OrktxKNRmcQlmoQTWWKLEian4hcFQyMh1l5obFozpiUqnrxph1CxDyERUqZ+HU2JRC
         g1KmjFEanjjMEv1IU2ogKVPUzsdivSzyYWTiog/XTh/NF+Tiunure7lWXpXb6JRmXQs7
         fKywp1OEd/CUyQBAvXbXaiAeaQsEt9IWzn8kWtS1YB4u2u42+mIkG0dTzlS5LUhNJ7MG
         NWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TLrPkusdF6S8ANrlYXvEODEomy1N8W6VIAloIscSP48=;
        b=rd4XAQ3cbjmTWI6Z4roW8baXUSDrcun6YVdvRFM2RW9oK4BN//0sCNwIEmyRHKxLye
         Vnp+/4bYjnzQpwyRp07uPE/oIlo/oUYYaM0bDzmVrdE6kQsvXzYcr3bd6aBMpxLrOLGX
         GFbfYAXYmFwSGLp5L+3H4fRk1teL8zHnI5X0zMo0r+I910k5JG5ly8HPe+XYHUbCj5vL
         JZR55zHyuw3pZpwqyvsy7QdqKksrWUommnmXO9S03d4aQ89FW192Ogqgx8Oi2tjC29jN
         HFdpkJzoJ+uJ5n1hO5UYQnV3lt5TsBclUyES9u+NRBZE2avK+t+bzwp2KSapK4hJWlE1
         YSew==
X-Gm-Message-State: AJIora/57D/NOlk69XhAMpEoPSP1OsmtioLx6f57O9lBBIlIDHN2Xg+Z
        pq9Lk91jAXWPEEE8Z8kmTzwinA==
X-Google-Smtp-Source: AGRyM1tCM3FUIejji20kM4qMoJqekJeV9fwVvaw1G6xvWKNP8aHkfsANNOmGe7adDHmLoSix8SG+dA==
X-Received: by 2002:a05:600c:2651:b0:3a0:4624:b781 with SMTP id 17-20020a05600c265100b003a04624b781mr5830317wmy.15.1656513599271;
        Wed, 29 Jun 2022 07:39:59 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id h3-20020adfe983000000b0021b97ffa2a9sm17459056wrm.46.2022.06.29.07.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 07:39:58 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] bpftool: Allow disabling features at compile time
Date:   Wed, 29 Jun 2022 15:39:51 +0100
Message-Id: <20220629143951.74851-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some dependencies for bpftool are optional, and the associated features
may be left aside at compilation time depending on the available
components on the system (libraries, BTF, clang version, etc.).
Sometimes, it is useful to explicitly leave some of those features aside
when compiling, even though the system would support them. For example,
this can be useful:

    - for testing bpftool's behaviour when the feature is not present,
    - for copmiling for a different system, where some libraries are
      missing,
    - for producing a lighter binary,
    - for disabling features that do not compile correctly on older
      systems - although this is not supposed to happen, this is
      currently the case for skeletons support on Linux < 5.15, where
      struct bpf_perf_link is not defined in kernel BTF.

For such cases, we introduce, in the Makefile, some environment
variables that can be used to disable those features: namely,
BPFTOOL_FEATURE_NO_LIBBFD, BPFTOOL_FEATURE_NO_LIBCAP, and
BPFTOOL_FEATURE_NO_SKELETONS.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index c19e0e4c41bd..b3dd6a1482f6 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -93,8 +93,24 @@ INSTALL ?= install
 RM ?= rm -f
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args zlib libcap \
-	clang-bpf-co-re
+FEATURE_TESTS := disassembler-four-args zlib
+
+# Disable libbfd (for disassembling JIT-compiled programs) by setting
+# BPFTOOL_FEATURE_NO_LIBBFD
+ifeq ($(BPFTOOL_FEATURE_NO_LIBBFD),)
+  FEATURE_TESTS += libbfd
+endif
+# Disable libcap (for probing features available to unprivileged users) by
+# setting BPFTOOL_FEATURE_NO_LIBCAP
+ifeq ($(BPFTOOL_FEATURE_NO_LIBCAP),)
+  FEATURE_TESTS += libcap
+endif
+# Disable skeletons (e.g. for profiling programs or showing PIDs of processes
+# associated to BPF objects) by setting BPFTOOL_FEATURE_NO_SKELETONS
+ifeq ($(BPFTOOL_FEATURE_NO_SKELETONS),)
+  FEATURE_TESTS += clang-bpf-co-re
+endif
+
 FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
 	clang-bpf-co-re
 
-- 
2.34.1

