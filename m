Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA81B67AF47
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbjAYKE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbjAYKEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:04:55 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4F312F38;
        Wed, 25 Jan 2023 02:04:52 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i65so13083472pfc.0;
        Wed, 25 Jan 2023 02:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JwzqINKHCVROHxyUeM7gAg9VP3mqXT4x5vbM4VvtkuE=;
        b=L/bq7vAfQEmvURcKZ+hAnGqb1ZIfXrTmJAmc0c/k8uPbliRDyHQ2JQepuEBDXqSjCA
         +T9NA+4whuV6mAZgZYdNES7OB8wdh43LHdmAplureUm9trPO4mHWzTHRdM1mK9cYoTi/
         OaUN7FuvKOP3Q8QUogWXuH7dFX1Cu5a7RGGqNRfYB65L/FALCGp/49n7dPcBpLziU8Ct
         ybgTnaZtqNNAg2TmORc1iCinbrj6wdtDO9SukzgdHlyfpn6bRZExjsURpTRlrlVeHmH0
         q6u4GQiB/XmbT0UmQqA/u7eqg2bAn+Tcl9MJJNGECRTwfsyu6HNvb84mO9NW2tX3z2Ff
         GQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JwzqINKHCVROHxyUeM7gAg9VP3mqXT4x5vbM4VvtkuE=;
        b=6ANq7eodJ9nDLU443uPgzU1UJ/N5Dvsk0LyAIldyOE7aP9GYCBnOhY71GqC2VKvUyg
         QPuLzBPrQkKTOvI6FwVTE2aHic8iZRlhW4bx04LOKysoQRcLTFhnj3coU+vTEufmE/S4
         zQ9RHgU1YprxWYgt4pw8dOuKDIi9Y9hrB9p8G8zcdfziUXqut/9MoRdLkM8jrOxVTWsb
         DiOzTaqIBdFsgBXUIMSPhCIV88S1hBl2nhqGZon8jMfaZbPtrX1osD6EMSEyCFMRhM6m
         FlEONGKIG9EmzKqfdC1SnBn8wgm7qrZzyQ36TxUg+Bqqm2+tOMXvU0BE7U9wkjzTD4ey
         kPzA==
X-Gm-Message-State: AFqh2krOHVQjwAdUkRoptBasc2mBIUS5c5WgagxM2zPjVGYq5xqv3MIw
        jI/N/A3TgY6+If1Hq805bA==
X-Google-Smtp-Source: AMrXdXtggbBx++LlOvDs7f+HPSpGdXM2uIoQ1INBv4LsX+ScqQIe/UdMVM5+6ORVsEiDrPbi/5lEow==
X-Received: by 2002:aa7:9e0c:0:b0:58d:ae6d:14d5 with SMTP id y12-20020aa79e0c000000b0058dae6d14d5mr32492938pfq.27.1674641091344;
        Wed, 25 Jan 2023 02:04:51 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a00078c00b0058837da69edsm3171723pfu.128.2023.01.25.02.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 02:04:50 -0800 (PST)
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
Subject: [bpf-next v2] selftests/bpf: fix vmtest static compilation error
Date:   Wed, 25 Jan 2023 19:04:40 +0900
Message-Id: <20230125100440.21734-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
Changes in V2:
 - Add extra filter-out logic to LDLIBS
---
 tools/testing/selftests/bpf/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c22c43bbee19..2323a2b98b81 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -181,14 +181,15 @@ endif
 # do not fail. Static builds leave urandom_read relying on system-wide shared libraries.
 $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
 	$(call msg,LIB,,$@)
-	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $^ $(LDLIBS)   \
+	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS))   \
+		     $^ $(filter-out -static,$(LDLIBS))	     \
 		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
 		     -fPIC -shared -o $@
 
 $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
 	$(call msg,BINARY,,$@)
 	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^) \
-		     liburandom_read.so $(LDLIBS)			       \
+		     liburandom_read.so $(filter-out -static,$(LDLIBS))	     \
 		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
 		     -Wl,-rpath=. -o $@
 
-- 
2.34.1

