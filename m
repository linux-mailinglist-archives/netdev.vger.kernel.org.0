Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C0F4C56D8
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 17:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiBZQjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 11:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiBZQjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 11:39:00 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F8326CCFF;
        Sat, 26 Feb 2022 08:38:26 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so7616591pjb.0;
        Sat, 26 Feb 2022 08:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CUVRXEQjDfoKEnIhwgTgR29LkrM8Q5Udo+mcuXgqxmY=;
        b=grgm2wFbK239cNsLuzTSkhY1fzbLdc1+OWLlurJMgls83pSJbwu15IopmmDkS32PPL
         tNEmmBI0vNz9/Mydz6ArfC24pv2VrzwdsLMsf84Yms+r/DvKK2uUnGk8lAb6J3LpDch/
         hzT/WYx4ugDyw4a5sICOVIRHCLT96cpcof/bhY3NZcW0mnM/ispEckofu/No/6QLbmPj
         HzkEMzhgOMYUJIewtIiyD/BPzELZg9mfZSt7Ce3v1cdBxRU8NVs5Lo5l5ke8gpmHz4T3
         7/IWy7u2LVZc6VR2ykF8rEpCSWFZIeYXrLYPqwXGu3vjef92ycMR9pJl14BBzZQSS61j
         x0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CUVRXEQjDfoKEnIhwgTgR29LkrM8Q5Udo+mcuXgqxmY=;
        b=zHHCA+jvl2EKigiBuCFL2JBp8EwG5kJ29RQufDMPcMuWuF6Ts5ID+t8fL1zij3rAbK
         +JNpJ2lWOlRkiATQhsjHTlxG3D7ayXWG8wQle7m4PArPCAlG5VWDkxREbwzmhYZX0Gf6
         XiQT7n8VmI0TnoxetJMrVPc/32qx3DQOyLuLQfgAddgwKZReHg6IXv1IC/6EUdSdmID/
         JwFS5fQN9UG6J8zIcBy+6uHpn/o39qwhiatIp2yZh5tYxVODp7ZbtTyosGtVuhHa3GxA
         UtFXEqrjdCXa72uEQacmO0iSqy2/dOk4PEmv9qPRU263mEWTz7rn3FHm5f8E/2+WpyR9
         EE3Q==
X-Gm-Message-State: AOAM531KcJ6c4J6uLHcVj7S7b5UbdcngvuOEQy627Q6qidmFwaFlBlVl
        x6lYzDqnv60q5WmiwdmhKk454k/S3tvgpQ==
X-Google-Smtp-Source: ABdhPJyX3DH6/7pRuo98AF5k/wsbwDDIgDR8b7/uEgUSRy3dwdVRxE2BVCaEZc+fx8I6+XwbcMw8zA==
X-Received: by 2002:a17:902:7205:b0:14c:9586:f9d5 with SMTP id ba5-20020a170902720500b0014c9586f9d5mr12627831plb.77.1645893505599;
        Sat, 26 Feb 2022 08:38:25 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id g7-20020a656cc7000000b00375948e63d6sm5602217pgw.91.2022.02.26.08.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 08:38:25 -0800 (PST)
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
Subject: [PATCH bpf-next v2] bpftool: Remove redundant slashes
Date:   Sun, 27 Feb 2022 00:38:15 +0800
Message-Id: <20220226163815.520133-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225161507.470763-1-ytcoode@gmail.com>
References: <20220225161507.470763-1-ytcoode@gmail.com>
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

Because the OUTPUT variable ends with a slash but CURDIR doesn't, to keep
the _OUTPUT value consistent, we add a trailing slash to CURDIR when
defining _OUTPUT variable.

Since the _OUTPUT variable holds a value ending with a trailing slash,
there is no need to add another one when defining BOOTSTRAP_OUTPUT and
LIBBPF_OUTPUT variables.

When defining LIBBPF_INCLUDE and LIBBPF_BOOTSTRAP_INCLUDE, we shouldn't
add an extra slash either for the same reason.

When building libbpf, the value of the DESTDIR argument should also not
end with a trailing slash.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
---
v1 -> v2: make the commit message more accurate

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

