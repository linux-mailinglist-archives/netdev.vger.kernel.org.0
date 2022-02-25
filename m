Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331934C4A54
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242731AbiBYQP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242720AbiBYQP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:15:57 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A200F211322;
        Fri, 25 Feb 2022 08:15:24 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 75so5057799pgb.4;
        Fri, 25 Feb 2022 08:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sQMqEnEHCWXRJgwh1MyI+jkYXf/Rsu4bDyFVbGp4W1w=;
        b=AgkgmM1ek9aT15PnElgRBHwrw0YR+AHcsI4fXEzeAVDMLvvUgujg68skhzyj5KXgAj
         LHUVJB39SsZib1tLvw1x5uxbh/VaHMhzmE9nKdAwK39QR1tmStJkLX+HIlAzFrGEta8Y
         EtjPk4Uu9pbXe16PxsGKGAkVz3yJ186ufvbJD4d2a0wJYGnR1mNcDhdUv+r6XVlzdSSL
         rTC4xwDAf8+oJJuhcyUrPAoclXReAKuNP+vLk00l724GALLLhQg2uMGxkiif/xgQ6135
         AXmC1VZiLbEFZ+ZolygiyDdzsGsrKhAKzdAPFj5fEF74UmAPIVUPv8EC/I9iHChlj77C
         qZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sQMqEnEHCWXRJgwh1MyI+jkYXf/Rsu4bDyFVbGp4W1w=;
        b=UhHBW7hx2AMsZHRSaU9xN+6zCVTTLk8sp/1WMKx2+WfZi6xv37tmbY42Ql2YzXsXKY
         jL0w/Qd6E7sh2yHOMLknEkGUT0k80IDrhAuaYstsW5TTFArNsgjPznV6hC6mJfa6jnse
         tnM8uzKKjasb9FxVBlhCq+M9laLGspHQF0vBK/NSEMOkEi18i3t+jyWXSR+mBRkkh2jj
         kw7WQ5HPGjVxHByWXwIEn3p1GBoqJzxfX6uchwQTLSOvLr2MQ3ns5doj9Vu5/18Me670
         ZjQ9XUjiaOb3jKBEjHUWqh0conGkmbu/xTErEOrxJWGTi7gl4B6rImvwA2AqIOqVXhNI
         3CdA==
X-Gm-Message-State: AOAM531GVmWsonmrnO1mcBEtZPkoWP/k568Eu98KbEnx8LzirEhYn+z3
        ZFcMHtloTLmlxKfkO1OSmQs69bzfNq+cKzBM
X-Google-Smtp-Source: ABdhPJxAnto5p+Z6sj3uNKtXaeoGO3DOtFA0nRzh5+Ld4ge/jdTadyimosqcOZzafmxAfSiBq+hhvQ==
X-Received: by 2002:a63:3ecc:0:b0:36c:63a3:1be with SMTP id l195-20020a633ecc000000b0036c63a301bemr6682175pga.353.1645805723859;
        Fri, 25 Feb 2022 08:15:23 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id z13-20020a63e10d000000b003733d6c90e4sm2958121pgh.82.2022.02.25.08.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 08:15:23 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] bpftool: Remove redundant slashes
Date:   Sat, 26 Feb 2022 00:15:07 +0800
Message-Id: <20220225161507.470763-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the _OUTPUT variable holds a value ending with a trailing slash,
there is no need to add another one when defining BOOTSTRAP_OUTPUT and
LIBBPF_OUTPUT variables.

When defining LIBBPF_INCLUDE and LIBBPF_BOOTSTRAP_INCLUDE, we shouldn't
add an extra slash either for the same reason.

When building libbpf, the value of the DESTDIR argument should also not
end with a trailing slash.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/bpf/bpftool/Makefile | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index ba647aede0d6..9800f966fd51 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -18,19 +18,19 @@ BPF_DIR = $(srctree)/tools/lib/bpf
 ifneq ($(OUTPUT),)
   _OUTPUT := $(OUTPUT)
 else
-  _OUTPUT := $(CURDIR)
+  _OUTPUT := $(CURDIR)/
 endif
-BOOTSTRAP_OUTPUT := $(_OUTPUT)/bootstrap/
+BOOTSTRAP_OUTPUT := $(_OUTPUT)bootstrap/
 
-LIBBPF_OUTPUT := $(_OUTPUT)/libbpf/
+LIBBPF_OUTPUT := $(_OUTPUT)libbpf/
 LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
-LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
+LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)include
 LIBBPF_HDRS_DIR := $(LIBBPF_INCLUDE)/bpf
 LIBBPF := $(LIBBPF_OUTPUT)libbpf.a
 
 LIBBPF_BOOTSTRAP_OUTPUT := $(BOOTSTRAP_OUTPUT)libbpf/
 LIBBPF_BOOTSTRAP_DESTDIR := $(LIBBPF_BOOTSTRAP_OUTPUT)
-LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)/include
+LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)include
 LIBBPF_BOOTSTRAP_HDRS_DIR := $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
 LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
 
@@ -44,7 +44,7 @@ $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DI
 
 $(LIBBPF): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
-		DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
+		DESTDIR=$(LIBBPF_DESTDIR:/=) prefix= $(LIBBPF) install_headers
 
 $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_DIR)
 	$(call QUIET_INSTALL, $@)
@@ -52,7 +52,7 @@ $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_
 
 $(LIBBPF_BOOTSTRAP): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
-		DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR) prefix= \
+		DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR:/=) prefix= \
 		ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) $@ install_headers
 
 $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS): $(LIBBPF_BOOTSTRAP_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_BOOTSTRAP_HDRS_DIR)
-- 
2.35.1

