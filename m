Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6424F5686A0
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 13:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbiGFLSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 07:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiGFLSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 07:18:52 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0B827CC9;
        Wed,  6 Jul 2022 04:18:51 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h85so13699197iof.4;
        Wed, 06 Jul 2022 04:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YdXK1jK8c8JK2srQZ8sIWVLkb+7MN9opgC2hRcRTaT4=;
        b=nWkxCI/k0gDvr7oZrHkWCo9r1JpeN4/gxMjUlk3SwC+dMO4ARWv1irbXFYDpkp/eAR
         h7yrf00uUJJcQNUwDp3cbITl2wiZQeGiRrA4PgOEac7i/tlIXG3UUUy7WWiQ5g3JEXkA
         Xww/8awsvPNnvkqkU91T5+mcWYexfgXOrSPgkU6S4fIJqOV67r49pRwD1X8FTqojINSU
         cOAuIr19hhyMcDTBwC5DXqJuMAzwssq01aQxWK2orrOATFPAvH/+WnYYTCpOUlBvzLWe
         luhGvccPzI6G0Q8EwfrUhvUxzNjPcYtuXZn7p+IYwiUxT2fIWy7X3Va++LOg0y3Twx6Z
         /igA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YdXK1jK8c8JK2srQZ8sIWVLkb+7MN9opgC2hRcRTaT4=;
        b=zrjem1stJh/+G7xB2ovZzqv5XuT7uUO1ZhvNJjdZW/gixyaje1OTQoZ92JUuM1BP6u
         JMQ6FMK9IAKzXDjO/vc/L2wJyAFTUHRfiXkV9Q8/86O/WtGq3420o+RFc1bFdZXO7hJs
         2xXgUlunwvNNz64BRkPqphMO1SWMGLZ6l9zQD/JCs2MGz6JWmuPNs2j0Nsto1+H3Vx1O
         q/o+LlGPhIqLC8TEBs6lhtmMoCvzZzMqaR+tMjdETVBu3heLypnNzXTyztOm7GTTbBz6
         dqTTXnSYNAQaLb5KQ/ckcnd6HwDj+wL9LjYVtAot6X11RpngnkiSb/ACoZo0p7IMNZFP
         5HMQ==
X-Gm-Message-State: AJIora/4lcLvIy3yxgpFWNx5rS/7XWQjAWJBX200T75bsuh61a6pJlt9
        jlwecjq6BdPBcj2Bm7/fiqR+xWx6XB8JqA==
X-Google-Smtp-Source: AGRyM1uhWw4+wzUqCL+KdwojcloAAYRs5Qfcm7vB75vI4RpA+Tce05Mz6gGKSuCdxhcTyX1zE/nrbQ==
X-Received: by 2002:a05:6638:19c3:b0:33c:9d05:444a with SMTP id bi3-20020a05663819c300b0033c9d05444amr25095151jab.307.1657106330835;
        Wed, 06 Jul 2022 04:18:50 -0700 (PDT)
Received: from james-x399.localdomain (71-218-105-222.hlrn.qwest.net. [71.218.105.222])
        by smtp.gmail.com with ESMTPSA id b16-20020a02a590000000b0033f020640dasm812114jam.54.2022.07.06.04.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 04:18:50 -0700 (PDT)
From:   James Hilliard <james.hilliard1@gmail.com>
To:     bpf@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] libbpf: disable SEC pragma macro on GCC
Date:   Wed,  6 Jul 2022 05:18:38 -0600
Message-Id: <20220706111839.1247911-1-james.hilliard1@gmail.com>
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

It seems the gcc preprocessor breaks with pragmas when surrounding
__attribute__.

Disable these pragmas on GCC due to upstream bugs see:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=55578
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=90400

Fixes errors like:
error: expected identifier or '(' before '#pragma'
  106 | SEC("cgroup/bind6")
      | ^~~

error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
  114 | char _license[] SEC("license") = "GPL";
      | ^~~

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
Changes v3 -> v4:
  - disable SEC pragmas entirely on GCC
Changes v2 -> v3:
  - just fix SEC pragma
Changes v1 -> v2:
  - replace typeof with __typeof__ instead of changing pragma macros
---
 tools/lib/bpf/bpf_helpers.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index fb04eaf367f1..7349b16b8e2f 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -22,12 +22,25 @@
  * To allow use of SEC() with externs (e.g., for extern .maps declarations),
  * make sure __attribute__((unused)) doesn't trigger compilation warning.
  */
+#if __GNUC__ && !__clang__
+
+/*
+ * Pragma macros are broken on GCC
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=55578
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=90400
+ */
+#define SEC(name) __attribute__((section(name), used))
+
+#else
+
 #define SEC(name) \
 	_Pragma("GCC diagnostic push")					    \
 	_Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")	    \
 	__attribute__((section(name), used))				    \
 	_Pragma("GCC diagnostic pop")					    \
 
+#endif
+
 /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
 #undef __always_inline
 #define __always_inline inline __attribute__((always_inline))
-- 
2.34.1

