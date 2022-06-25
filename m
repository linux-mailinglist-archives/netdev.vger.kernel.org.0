Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31F055AB51
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiFYPe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 11:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiFYPez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 11:34:55 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B61DF48;
        Sat, 25 Jun 2022 08:34:54 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id i8-20020a17090aee8800b001ecc929d14dso7500432pjz.0;
        Sat, 25 Jun 2022 08:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FhikbhadDQ0rX9caD2bvCSuXqnUHt6OCEuRHo6pJkvA=;
        b=fIXNCPCRvCTu0lOgEh4HFQea67b2Jj2R1K+2555bdlcq4Ka1gXG9Jm8ynFsm7+ilLW
         XRUm8/pMJUAq9h1G2AjrCTsAKXczSJBlKoQRihOYSk60y4ipilOwcOA8R+cMf7+vXJby
         seMiyL9Xb/Wg8TfMkmI57kc2/ViJ7ka2ySl8cC/oANRIJZQLR5RiUSA0/ugDJ1K9ZYaA
         5MwLSOwOYR+RWZcTqro9aMki4SYkIbPMbBR0DUuiNtCSSKAbRGqXb4PhUcD32PIv7GWm
         BAM8+keXZKnzHNhwR9RjXm5gM/sRYjnH1Lhm+MhKIuRUi5YfCbdvxQol7MVlvtO+xvPv
         u+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FhikbhadDQ0rX9caD2bvCSuXqnUHt6OCEuRHo6pJkvA=;
        b=ryolrr/4RqZ4BQHn1qdT+dtiGRJx57o1PtQu7luHZUYFTFWWAMwvex9OdqEWJkYsl6
         gxG7NkywSmWBlgdwmEA1bNFIg8GbgP6pVpxToU8EKi4MNWha97qyV5QjiLbFAGrF+F6e
         Za3Ix5G/kKqCloLAJQW8wKjRdA5gzS0jRWSFkdSKL16Apq8mJBgxkULzbIZb1Yx8eBiT
         DGkMz9hKazMZqtoKk412d4UKgBIP8Gs/PtMU3IeezbYXVUcaMeWekO+H1gcBFIvgG7g/
         Q55UqefZukfJIJNJal5qqtbcust6wInZz27XQXwxyLyn8FdrMnGcsk/D3P1U8Cm+1TEv
         p82w==
X-Gm-Message-State: AJIora+L1dxsNvJfg1kGeTeLjU7l18no8/7cUCaD53Y8mH+2prk69t6v
        pt/FkkanWe96ZbYR2dQxF+wzNj05P6HriBvrNuI=
X-Google-Smtp-Source: AGRyM1tavCXlDm4hg0O97qPWPbGoHwIuq/p+xNf5aGqhFOas5qGzsQOJBxgxITW53VJY1WumlbstGQ==
X-Received: by 2002:a17:902:6946:b0:167:8ff3:1608 with SMTP id k6-20020a170902694600b001678ff31608mr5010136plt.116.1656171293921;
        Sat, 25 Jun 2022 08:34:53 -0700 (PDT)
Received: from computer.. ([111.43.251.41])
        by smtp.gmail.com with ESMTPSA id e17-20020a170902d39100b0016a3db5d608sm3852904pld.289.2022.06.25.08.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 08:34:53 -0700 (PDT)
From:   Zixuan Tan <tanzixuangg@gmail.com>
X-Google-Original-From: Zixuan Tan <tanzixuan.me@gmail.com>
To:     terrelln@fb.com
Cc:     Zixuan Tan <tanzixuan.me@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] perf build: Suppress openssl v3 deprecation warnings in libcrypto feature test
Date:   Sat, 25 Jun 2022 23:34:38 +0800
Message-Id: <20220625153439.513559-1-tanzixuan.me@gmail.com>
X-Mailer: git-send-email 2.34.1
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

With OpenSSL v3 installed, the libcrypto feature check fails as it use the
deprecated MD5_* API (and is compiled with -Werror). The error message is
as follows.

$ make tools/perf
```
Makefile.config:778: No libcrypto.h found, disables jitted code injection,
please install openssl-devel or libssl-dev

Auto-detecting system features:
...                         dwarf: [ on  ]
...            dwarf_getlocations: [ on  ]
...                         glibc: [ on  ]
...                        libbfd: [ on  ]
...                libbfd-buildid: [ on  ]
...                        libcap: [ on  ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...        numa_num_possible_cpus: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...                     libcrypto: [ OFF ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...                          zlib: [ on  ]
...                          lzma: [ on  ]
...                     get_cpuid: [ on  ]
...                           bpf: [ on  ]
...                        libaio: [ on  ]
...                       libzstd: [ on  ]
...        disassembler-four-args: [ on  ]
```

This is very confusing because the suggested library (on my Ubuntu 20.04
it is libssl-dev) is already installed. As the test only checks for the
presence of libcrypto, this commit suppresses the deprecation warning to
allow the test to pass.

Signed-off-by: Zixuan Tan <tanzixuan.me@gmail.com>
---
 tools/build/feature/test-libcrypto.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/build/feature/test-libcrypto.c b/tools/build/feature/test-libcrypto.c
index a98174e0569c..31afff093d0b 100644
--- a/tools/build/feature/test-libcrypto.c
+++ b/tools/build/feature/test-libcrypto.c
@@ -2,6 +2,12 @@
 #include <openssl/sha.h>
 #include <openssl/md5.h>
 
+/*
+ * The MD5_* API have been deprecated since OpenSSL 3.0, which causes the
+ * feature test to fail silently. This is a workaround.
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
 int main(void)
 {
 	MD5_CTX context;
-- 
2.34.1

