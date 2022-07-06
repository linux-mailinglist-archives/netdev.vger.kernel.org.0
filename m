Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E815690AB
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 19:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiGFR2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 13:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiGFR2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 13:28:48 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180BACE0;
        Wed,  6 Jul 2022 10:28:48 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id b1so3967960ilf.8;
        Wed, 06 Jul 2022 10:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SvZOe8XGimmd2B/XmPBDNVyQJG1w2f9kGtZbnw1y9g=;
        b=C1U+SHIxHxWhiekO9kh98IJYIjI+Eem12bW0ADxIbdWf49EAqp+dimTsU1zPU5IDkG
         s6gxB6v1qKEb46gzLsO7bx8dTVgENfF/3+xN0C+qYLf67qCJH5+uw0fRZnOHVhBKurc2
         qPIlBKPUs2yagQwPnTw9WBMtg74QF99/YpvxBBDQatX2HWjyGo+FX0kgsYi9fbp6jJ7i
         e9b98XA/GCV1/dbS2VM20HnqSODqepAbYIWi1T9TioewQh4znr502vsyMdKAAAch4k+G
         vp7l0Pwc6vl6KLjZJ6RND0LaVAV596Ma3KH1Jjzmvre5ZVWRzHwGgTagXO3n52aOnD5X
         QVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SvZOe8XGimmd2B/XmPBDNVyQJG1w2f9kGtZbnw1y9g=;
        b=Wc377Kws28W9ndMlDp1xQFhgzVsOqCbk8XqR5d0DarvIH5Y6YovLQqQXR6ku35sSNo
         SZ5OXOmivNW8dXhYgjfIDr2h0JgHjlZi/jNfjBjrq+p1r4BHFMnjg30/XSV0TSxsBzs+
         hvzGhbFlztcYd5S0zjr9/vkDkkb5d2eEOOz5YFGpVccjrWoGilSeZttZY4PNUHiWFTpZ
         ddciXreoqzUA3fXRBe18X1LNLeKAmNqLjna+EOgbI6WWYoa7iJwVXxV54yPC5g7QqOqn
         j8/Yz/AIVGjwpLrFHmKvvA/anMYQ4QSHX0G7AALau5r7twY4mmANZDeXXPnujPQMa66s
         znMw==
X-Gm-Message-State: AJIora9Q/QvAzWNbjinDGxpeuvWxFJVkcvZzW1CIG7lgxl8u3SdvAxDP
        9OB33TlBErbuErpTfSurKm59sj3Tf4f/hA==
X-Google-Smtp-Source: AGRyM1v8eYaNRA6KEPBq56q/Zktf2USJ50ThRchPK9Gb1M/ToV8z7dPm2TpdpT0GBWG1Xe5dSEZ5vQ==
X-Received: by 2002:a05:6e02:158a:b0:2d5:12f0:4dce with SMTP id m10-20020a056e02158a00b002d512f04dcemr24622483ilu.159.1657128527235;
        Wed, 06 Jul 2022 10:28:47 -0700 (PDT)
Received: from james-x399.localdomain (71-218-105-222.hlrn.qwest.net. [71.218.105.222])
        by smtp.gmail.com with ESMTPSA id u2-20020a92d1c2000000b002dc0c1b8edbsm3099278ilg.83.2022.07.06.10.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 10:28:46 -0700 (PDT)
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
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
Date:   Wed,  6 Jul 2022 11:28:13 -0600
Message-Id: <20220706172814.169274-1-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The current bpf_helper_defs.h helpers are llvm specific and don't work
correctly with gcc.

GCC appears to required kernel helper funcs to have the following
attribute set: __attribute__((kernel_helper(NUM)))

Generate gcc compatible headers based on the format in bpf-helpers.h.

This adds conditional blocks for GCC while leaving clang codepaths
unchanged, for example:
	#if __GNUC__ && !__clang__
	void *bpf_map_lookup_elem(void *map, const void *key) __attribute__((kernel_helper(1)));
	#else
	static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
	#endif

	#if __GNUC__ && !__clang__
	long bpf_map_update_elem(void *map, const void *key, const void *value, __u64 flags) __attribute__((kernel_helper(2)));
	#else
	static long (*bpf_map_update_elem)(void *map, const void *key, const void *value, __u64 flags) = (void *) 2;
	#endif

See:
https://github.com/gcc-mirror/gcc/blob/releases/gcc-12.1.0/gcc/config/bpf/bpf-helpers.h#L24-L27

This fixes the following build error:
error: indirect call in function, which are not supported by eBPF

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
Changes v1 -> v2:
  - more details in commit log
---
 scripts/bpf_doc.py | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index a0ec321469bd..36fb400a5731 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -739,6 +739,24 @@ class PrinterHelpers(Printer):
 
     seen_helpers = set()
 
+    def print_args(self, proto):
+        comma = ''
+        for i, a in enumerate(proto['args']):
+            t = a['type']
+            n = a['name']
+            if proto['name'] in self.overloaded_helpers and i == 0:
+                    t = 'void'
+                    n = 'ctx'
+            one_arg = '{}{}'.format(comma, self.map_type(t))
+            if n:
+                if a['star']:
+                    one_arg += ' {}'.format(a['star'])
+                else:
+                    one_arg += ' '
+                one_arg += '{}'.format(n)
+            comma = ', '
+            print(one_arg, end='')
+
     def print_one(self, helper):
         proto = helper.proto_break_down()
 
@@ -762,26 +780,17 @@ class PrinterHelpers(Printer):
                 print(' *{}{}'.format(' \t' if line else '', line))
 
         print(' */')
+        print('#if __GNUC__ && !__clang__')
+        print('%s %s%s(' % (self.map_type(proto['ret_type']),
+                                      proto['ret_star'], proto['name']), end='')
+        self.print_args(proto)
+        print(') __attribute__((kernel_helper(%d)));' % len(self.seen_helpers))
+        print('#else')
         print('static %s %s(*%s)(' % (self.map_type(proto['ret_type']),
                                       proto['ret_star'], proto['name']), end='')
-        comma = ''
-        for i, a in enumerate(proto['args']):
-            t = a['type']
-            n = a['name']
-            if proto['name'] in self.overloaded_helpers and i == 0:
-                    t = 'void'
-                    n = 'ctx'
-            one_arg = '{}{}'.format(comma, self.map_type(t))
-            if n:
-                if a['star']:
-                    one_arg += ' {}'.format(a['star'])
-                else:
-                    one_arg += ' '
-                one_arg += '{}'.format(n)
-            comma = ', '
-            print(one_arg, end='')
-
+        self.print_args(proto)
         print(') = (void *) %d;' % len(self.seen_helpers))
+        print('#endif')
         print('')
 
 ###############################################################################
-- 
2.34.1

