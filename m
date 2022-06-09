Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE585443C1
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238042AbiFIGY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiFIGY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:24:26 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FF0CFB;
        Wed,  8 Jun 2022 23:24:25 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id y16so18113822ili.13;
        Wed, 08 Jun 2022 23:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1ri1ukx6Vx1NLRGSHD+ge+wUstRc/ldJH0iFpmi8aQ=;
        b=qtphDcKPhwp7KUD1fEGpVgrLnv3May6lb30MGRe+WwoLQDLO7iPWrKR0mp91M0TmOE
         uRr9SBwuYW/BjRK8ds9dYvi2xiQgeYI9kLm4WLDbLohIj3yF/dOmTJ5EU0J8x3++ZfYE
         D1fhdvajqzEiPFnEKFQFJ772HwMF8kuGjpLZK61NKR6Ldwciu/xJKC5vaAdynt885qT+
         XCY/kJ7qQtA08oMeMSF6VTK24R1QOULZb/vgTBqCOXK8B2uiCzD41Mq3BORf416EmKsK
         wqTOzdNT6V4Z11u3p7FZRAql9qOEjQ1V5Oo5lKkomUb0EAKloIghG5mcCDPCAjlJHJny
         sNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E1ri1ukx6Vx1NLRGSHD+ge+wUstRc/ldJH0iFpmi8aQ=;
        b=kxVqE/ihoja9mjgNTTLlD2WYGBouyRA3nJMD88+6vR1AFldeuwJ5Be48fKVk/qp8sr
         dsp+JTdJB/0aOj7maufiTUuSbe3vGCi14nzDyk6889c/4nLspGww8P1pfjY8rxRTyp2J
         RdpEVw1Km4YU2tccaE9dex9TFIi2nXkSL6haLzNvPGmqRjRiNmExZNnz4GbtFvQ2V7E/
         RS1YU17up7vSXz0SeTeWTXFFGKuvMLpqbv5gOCGxHKZzsUBPTPe2lNEtvlrGnnU8ux0Z
         OL0KJEyvMSCky173Ee+Y0Cp65TXgocGPp4x/SmUoTRkgx1xjDdI7ZrAgnCQpVkQTecbr
         csww==
X-Gm-Message-State: AOAM532gxabR8z3oGklj3rmQzSpw24lb98lJYOxAveMUYbYbizF9lguS
        goLZ4vFtl1aXsurTPLs7v0nmdXscsza3bg==
X-Google-Smtp-Source: ABdhPJzann7q2v4VRXdd6L5Dd9xNN1YlJXeZmQw6qtlrYo9Yk4qyv83+Q7LRi97txWonQ8t9pC4V+A==
X-Received: by 2002:a05:6e02:1aa8:b0:2d3:d69a:6d88 with SMTP id l8-20020a056e021aa800b002d3d69a6d88mr22181153ilv.243.1654755864241;
        Wed, 08 Jun 2022 23:24:24 -0700 (PDT)
Received: from james-x399.localdomain (71-218-113-86.hlrn.qwest.net. [71.218.113.86])
        by smtp.gmail.com with ESMTPSA id a125-20020a021683000000b0032b7fb6c33asm9057481jaa.84.2022.06.08.23.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:24:23 -0700 (PDT)
From:   James Hilliard <james.hilliard1@gmail.com>
To:     bpf@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/1] libbpf: fix broken gcc SEC pragma macro
Date:   Thu,  9 Jun 2022 00:24:12 -0600
Message-Id: <20220609062412.3950380-1-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems the gcc preprocessor breaks unless pragmas are wrapped
individually inside macros when surrounding __attribute__.

Fixes errors like:
error: expected identifier or '(' before '#pragma'
  106 | SEC("cgroup/bind6")
      | ^~~

error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
  114 | char _license[] SEC("license") = "GPL";
      | ^~~

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
Changes v2 -> v3:
  - just fix SEC pragma
Changes v1 -> v2:
  - replace typeof with __typeof__ instead of changing pragma macros
---
 tools/lib/bpf/bpf_helpers.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index fb04eaf367f1..66d23c47c206 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -22,11 +22,12 @@
  * To allow use of SEC() with externs (e.g., for extern .maps declarations),
  * make sure __attribute__((unused)) doesn't trigger compilation warning.
  */
+#define DO_PRAGMA(x) _Pragma(#x)
 #define SEC(name) \
-	_Pragma("GCC diagnostic push")					    \
-	_Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")	    \
+	DO_PRAGMA("GCC diagnostic push")				    \
+	DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attributes\"")	    \
 	__attribute__((section(name), used))				    \
-	_Pragma("GCC diagnostic pop")					    \
+	DO_PRAGMA("GCC diagnostic pop")					    \
 
 /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
 #undef __always_inline
-- 
2.25.1

