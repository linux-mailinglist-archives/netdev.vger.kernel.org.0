Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8988F676437
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 07:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjAUGlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 01:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUGlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 01:41:36 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0E13AB1;
        Fri, 20 Jan 2023 22:41:35 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id lp10so4081638pjb.4;
        Fri, 20 Jan 2023 22:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5lJdT3XmVD9a30DczQsD+DGtS0S+cFChQv3H+jSyRBQ=;
        b=V5ZJzsOLaF5tZnLuyhpBjy0Ow/UxrssmrfVxJoVZw6KxUujCWXgu2VdzcEl4WmJtG+
         bQpV5Ex2kG/2qQrDs3xRWXzBWWh2dioeQyEfaXcgQbeEQu7F7gMAVS6aU5k7qJ1wSIpn
         XjMdbzRhmRCCzDrWZQoYqExI451TeDdlBLZPT1CaUAJT2sWcyiTOjJxcIjytdnkCG0tZ
         qNabAGgjvAtlgDOazwA9MMdqBmO+oWIM+cK1q0ld1A09/OTQ7VFads/U2NL5QcCDQPB+
         EMmetei6SbWCjB4St4Wcjf9Jh1R0AJzaTPA1HjONGbxq1R44qWjy8H3IQOC9PeM1PQvr
         oQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5lJdT3XmVD9a30DczQsD+DGtS0S+cFChQv3H+jSyRBQ=;
        b=hMm/QBER6bVQukPkX2W6KAoqK+LzVPrfadliHwJ+euNIKY3wicGpOq9hlIShtZAQZm
         zXxc2Tj0kKWHW43QlTWMWUB/SXLT82ZDyGYr5g08N5zsxExzRj9Do3wcGoXo2qWDItvg
         k1dYoyt5vAJVrIWGD2oTMIbNgslvyIGLQBW3v6/Rrt0nqS3cbWfgC1p7/NYaH1jeZks8
         LYsb3a0bAANqBMcuBZfoem/0QFthaxN7kfQ9Imq2znb1BxEkcxAUjnUc1q3f40kN1nsx
         5OaZcnKc5TkMiUgqFjdVkEzl8N1Z7qAUlnsJ/da5VLh98vojC1FfJSLUbpuVHw/ka8W1
         qvKA==
X-Gm-Message-State: AFqh2koVnpYN3WJNX6sAn6qsQxBCLiW4jBL5MmuGxsPQDfVGKttS//Uf
        sGe9i7rA69qUVPoPp4IxXNW9HQhRVZZ7
X-Google-Smtp-Source: AMrXdXt+zxIeLRtBASO7UiMkws7DJxIpHI5LZ6lSjnc5zm7osqhRM80gZ+qbaDNBdNHu0TktBr4MaA==
X-Received: by 2002:a05:6a20:6d19:b0:b8:4978:cde8 with SMTP id fv25-20020a056a206d1900b000b84978cde8mr17618855pzb.18.1674283295064;
        Fri, 20 Jan 2023 22:41:35 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902710300b0019269969d14sm13203689pll.282.2023.01.20.22.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 22:41:34 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH] selftests/bpf: fix vmtest static compilation error
Date:   Sat, 21 Jan 2023 15:41:28 +0900
Message-Id: <20230121064128.67914-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in README.rst, in order to resolve errors with linker errors,
'LDLIBS=-static' should be used. Most problems will be solved by this
option, but in the case of urandom_read, this won't fix the problem. So
the Makefile is currently implemented to strip the 'static' option when
compiling the urandom_read. However, stripping this static option isn't
configured properly on $(LDLIBS) correctly, which is now causing errors
on static compilation.

    # LDLIBS=-static ./vmtest.sh
    ld.lld: error: attempted static link of dynamic object liburandom_read.so
    clang: error: linker command failed with exit code 1 (use -v to see invocation)
    make: *** [Makefile:190: /linux/tools/testing/selftests/bpf/urandom_read] Error 1
    make: *** Waiting for unfinished jobs....

This commit fixes this problem by configuring the strip with $(LDLIBS).

Fixes: 68084a136420 ("selftests/bpf: Fix building bpf selftests statically")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 22533a18705e..7bd1ce9c8d87 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -188,7 +188,7 @@ $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
 $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
 	$(call msg,BINARY,,$@)
 	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^) \
-		     liburandom_read.so $(LDLIBS)			       \
+		     liburandom_read.so $(filter-out -static,$(LDLIBS))	     \
 		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
 		     -Wl,-rpath=. -o $@
 
-- 
2.34.1

