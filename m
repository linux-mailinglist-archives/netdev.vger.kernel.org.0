Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011C850CB38
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbiDWOdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiDWOds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:33:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBE9289B4;
        Sat, 23 Apr 2022 07:30:50 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 15so1307100pgf.4;
        Sat, 23 Apr 2022 07:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IbYzjBMPd51boeHwhH3wuc9Vn0/S8H3iRbP4T06Ug/A=;
        b=e9kxM39mRig/k57Ub+oGcFMcpzV47OT4eNveol/LKX9UORSpHXh/KjtegfnWHITvlm
         jJp1c7Aa+U91Dy7KWeYRbNW5QH9l21dc9SkmTW2kR9kBVpP02GiiShVXYuvFGzpYALZj
         vBFGEmX7C80dxIYPi8X39MEmSiD95SJApig2bubiz3EiInmdAc6wJsm3Wk2eIhkH1K0D
         pLo1KbIf7XARqxRc/DLTwJuZb2jb6tR07DAiD5AKQbeodRyfTSD8e2ZG66HmJxG5Khy6
         5d5dEASAAbsHJKu4SCE6hf8c9dcBEF3g6n34w0o7xZIZXAbsxWPHssUjUQHb2Q8+qUnk
         /oHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IbYzjBMPd51boeHwhH3wuc9Vn0/S8H3iRbP4T06Ug/A=;
        b=lYEOY3KFolTAVX7rJhkt2hzbEaidFW02DJpjnqTDgp5lBNlh+C4yu1IcV1Necq68zr
         t0p+Frk4XNArr2EOuH1/+EQXUCZUz5AFaZPsLpn8PorkiG4YGnR0rtDvcJtk0QZMS68w
         mEe79qT7ackOjEQGr06p5W+vgoIdGy0PlKIuvi4kouIEwTrS5vRjS9fwHtMOO/++dTxZ
         6ih2inF3lj6DcG3tQX6nKOUVojZjwslCYHXO4Sc6tH1Hjxb/nYNwOXAvA58dUGYQljsO
         tJ7Sh2bwPaYaxC2HdgA3AzB3KZCcGiCjSh/hMK3OAkTlq2PP/ijdMoeN4/4bfg9jqAhy
         zuuQ==
X-Gm-Message-State: AOAM533HLmsKTismb9ljfSh0fbg9Ptp1DfF+G2Ym7oPJPV0zOzrh14jV
        EXumTgVIXbdUOsK8efbovAk=
X-Google-Smtp-Source: ABdhPJxhAIxDc9NmJoC5o4P8rTL4BbAzX+TMNG/y7XV9K86jlKj5vfeK3KWWsG1w0N86098N8ariGQ==
X-Received: by 2002:a63:fd04:0:b0:3aa:6473:1859 with SMTP id d4-20020a63fd04000000b003aa64731859mr8226012pgh.151.1650724249799;
        Sat, 23 Apr 2022 07:30:49 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id d8-20020aa78688000000b00505793566f7sm5778399pfo.211.2022.04.23.07.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:30:49 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix incorrect TRUNNER_BINARY name output
Date:   Sat, 23 Apr 2022 22:30:07 +0800
Message-Id: <20220423143007.423526-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.3
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

Currently, when we run 'make test_progs', the output is:

  CLNG-BPF [test_maps] atomic_bounds.o
  ...
  GEN-SKEL [test_progs] atomic_bounds.skel.h
  ...
  TEST-OBJ [test_progs] align.test.o
  ...
  TEST-HDR [test_progs] tests.h
  EXT-OBJ  [test_progs] test_progs.o
  ...
  BINARY   test_progs

As you can see, the TRUNNER_BINARY name in the CLNG-BPF part is test_maps,
which is incorrect.

Similarly, when we run 'make test_maps', the output is:

  CLNG-BPF [test_maps] atomic_bounds.o
  ...
  GEN-SKEL [test_progs] atomic_bounds.skel.h
  ...
  TEST-OBJ [test_maps] array_map_batch_ops.test.o
  ...
  TEST-HDR [test_maps] tests.h
  EXT-OBJ  [test_maps] test_maps.o
  ...
  BINARY   test_maps

At this time, the TRUNNER_BINARY name in the GEN-SKEL part is wrong.

Again, if we run 'make /full/path/to/selftests/bpf/test_vmlinux.skel.h',
the output is:

  CLNG-BPF [test_maps] test_vmlinux.o
  GEN-SKEL [test_progs] test_vmlinux.skel.h

Here, the TRUNNER_BINARY names are inappropriate and meaningless, they
should be removed.

This patch fixes these and all other similar issues.

With the patch applied, the output becomes:

  $ make test_progs

  CLNG-BPF [test_progs] atomic_bounds.o
  ...
  GEN-SKEL [test_progs] atomic_bounds.skel.h
  ...
  TEST-OBJ [test_progs] align.test.o
  ...
  TEST-HDR [test_progs] tests.h
  EXT-OBJ  [test_progs] test_progs.o
  ...
  BINARY   test_progs

  $ make test_maps

  CLNG-BPF [test_maps] atomic_bounds.o
  ...
  GEN-SKEL [test_maps] atomic_bounds.skel.h
  ...
  TEST-OBJ [test_maps] array_map_batch_ops.test.o
  ...
  TEST-HDR [test_maps] tests.h
  EXT-OBJ  [test_maps] test_maps.o
  ...
  BINARY   test_maps

  $ make /full/path/to/selftests/bpf/test_vmlinux.skel.h

  CLNG-BPF test_vmlinux.o
  GEN-SKEL test_vmlinux.skel.h

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/testing/selftests/bpf/Makefile | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index bafdc5373a13..3cf444cb20af 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -413,7 +413,7 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 					  $(TRUNNER_BPF_CFLAGS))
 
 $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
-	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
+	$$(call msg,GEN-SKEL,$$(TRUNNER_BINARY),$$@)
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
@@ -422,7 +422,7 @@ $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$(Q)$$(BPFTOOL) gen subskeleton $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$(@:.skel.h=.subskel.h)
 
 $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
-	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
+	$$(call msg,GEN-SKEL,$$(TRUNNER_BINARY),$$@)
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
@@ -430,12 +430,12 @@ $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=_lskel)) > $$@
 
 $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
-	$$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))
+	$$(call msg,LINK-BPF,$$(TRUNNER_BINARY),$$(@:.skel.h=.o))
 	$(Q)$$(BPFTOOL) gen object $$(@:.skel.h=.linked1.o) $$(addprefix $(TRUNNER_OUTPUT)/,$$($$(@F)-deps))
 	$(Q)$$(BPFTOOL) gen object $$(@:.skel.h=.linked2.o) $$(@:.skel.h=.linked1.o)
 	$(Q)$$(BPFTOOL) gen object $$(@:.skel.h=.linked3.o) $$(@:.skel.h=.linked2.o)
 	$(Q)diff $$(@:.skel.h=.linked2.o) $$(@:.skel.h=.linked3.o)
-	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
+	$$(call msg,GEN-SKEL,$$(TRUNNER_BINARY),$$@)
 	$(Q)$$(BPFTOOL) gen skeleton $$(@:.skel.h=.linked3.o) name $$(notdir $$(@:.skel.h=)) > $$@
 	$(Q)$$(BPFTOOL) gen subskeleton $$(@:.skel.h=.linked3.o) name $$(notdir $$(@:.skel.h=)) > $$(@:.skel.h=.subskel.h)
 endif
@@ -444,7 +444,7 @@ endif
 ifeq ($($(TRUNNER_TESTS_DIR)-tests-hdr),)
 $(TRUNNER_TESTS_DIR)-tests-hdr := y
 $(TRUNNER_TESTS_HDR): $(TRUNNER_TESTS_DIR)/*.c
-	$$(call msg,TEST-HDR,$(TRUNNER_BINARY),$$@)
+	$$(call msg,TEST-HDR,$$(TRUNNER_BINARY),$$@)
 	$$(shell (echo '/* Generated header, do not edit */';					\
 		  sed -n -E 's/^void (serial_)?test_([a-zA-Z0-9_]+)\((void)?\).*/DEFINE_TEST(\2)/p'	\
 			$(TRUNNER_TESTS_DIR)/*.c | sort ;	\
@@ -461,7 +461,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_BPF_LSKELS)				\
 		      $(TRUNNER_BPF_SKELS_LINKED)			\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
-	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
+	$$(call msg,TEST-OBJ,$$(TRUNNER_BINARY),$$@)
 	$(Q)cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
 
 $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
@@ -469,17 +469,19 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       $(TRUNNER_EXTRA_HDRS)				\
 		       $(TRUNNER_TESTS_HDR)				\
 		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
-	$$(call msg,EXT-OBJ,$(TRUNNER_BINARY),$$@)
+	$$(call msg,EXT-OBJ,$$(TRUNNER_BINARY),$$@)
 	$(Q)$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
 
 # non-flavored in-srctree builds receive special treatment, in particular, we
 # do not need to copy extra resources (see e.g. test_btf_dump_case())
 $(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
 ifneq ($2:$(OUTPUT),:$(shell pwd))
-	$$(call msg,EXT-COPY,$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
+	$$(call msg,EXT-COPY,$$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
 	$(Q)rsync -aq $$^ $(TRUNNER_OUTPUT)/
 endif
 
+$(OUTPUT)/$(TRUNNER_BINARY): TRUNNER_BINARY = $(TRUNNER_BINARY)
+
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
 			     $(RESOLVE_BTFIDS)				\
@@ -489,6 +491,8 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 	$(Q)$(RESOLVE_BTFIDS) --btf $(TRUNNER_OUTPUT)/btf_data.o $$@
 	$(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool $(if $2,$2/)bpftool
 
+TRUNNER_BINARY =
+
 endef
 
 # Define test_progs test runner.
-- 
2.35.3

