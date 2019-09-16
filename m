Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07F4B38CD
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732657AbfIPKz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:55:28 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46252 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732548AbfIPKy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:54:56 -0400
Received: by mail-lj1-f195.google.com with SMTP id e17so33223128ljf.13
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MLJcNNJZkagwGK0zIyaqmigCmuc2QO9sJ0CkQCG94a8=;
        b=E9WHFu0TVM9YPIg7e9FZQRJiw7GUUX46qDnJ7XJhp3tzqNkGIEkdZ/VfJkd5CiXCIu
         soL1+mGe5drovecAMdpE93IRIhgR5mqv5Inm7FMZtz3sR+ufpAD/Vj+CYguj9jaX979F
         eFqpi/6RF90/XKCxiwnqHbTubyY2+/Q2q7UmsEzAUVdYX0iubLOvOOMtNb6rLhLftlI8
         LGDNDWirLx7qPTGiEj+xYJs+l+TAonQmkRLwyJcjWSOCrpnM1a9qakwXyDalWaCOcOpj
         avbgMt/cu6EWydrCF+LYQy6vWHBc6xfHcI6HCINSXEg03CYbhAha+4hat/DwPB08BSH0
         IXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MLJcNNJZkagwGK0zIyaqmigCmuc2QO9sJ0CkQCG94a8=;
        b=dZ8p5Qkp9iOsr1gD3wppxd/xexzNHesbQo5HtDSj8YEp59dq/Q4e32EQAbxErSVpiV
         +qTnewWg0eQG98w6CXhiTfTgFmD3+D7FGv3rN9ndgmEz7Mw4HJSsoT43fV2UkeennQpe
         zAUKQKLYZikpmxklvrxsNNX3nZoiwmD1QKzif5+Xl8AQAYgViRE6j/CdYBOFL8Ov6X9M
         UevQJXqx/fRQfeMDYgLaLQ9VDsFZYoRxk49wDTBpBcXEcfa57CFh6M/JGDC5A1u54rmV
         2+jwi06J6380TklvmP8DY6BaU6ivMoLOEE5b2tymllBVRcm7V4MVdxrp9et4KWYEaY6H
         i6yA==
X-Gm-Message-State: APjAAAXE6Nxn/x90yArb1rG7fgSh/ff9Scg6+PD1UIOGtILmM2N7uDNx
        Qz8PEf7EtCbpyJ8t6rirRiA5KA==
X-Google-Smtp-Source: APXvYqwG3Sc5PdJ1BDI/ndJboxqwuppsJ0jjMTGaqjlVv0sD9MuujWpRu2ErqSb6ATwnfxiTcaiRgQ==
X-Received: by 2002:a2e:9f17:: with SMTP id u23mr2122827ljk.241.1568631294682;
        Mon, 16 Sep 2019 03:54:54 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id v1sm8987737lfq.89.2019.09.16.03.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:54:54 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v3 bpf-next 11/14] libbpf: makefile: add C/CXX/LDFLAGS to libbpf.so and test_libpf targets
Date:   Mon, 16 Sep 2019 13:54:30 +0300
Message-Id: <20190916105433.11404-12-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of LDFLAGS and EXTRA_CC/CXX flags there is no way to pass them
correctly to build command, for instance when --sysroot is used or
external libraries are used, like -lelf, wich can be absent in
toolchain. This can be used for samples/bpf cross-compiling allowing
to get elf lib from sysroot.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 tools/lib/bpf/Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c6f94cffe06e..bccfa556ef4e 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -94,6 +94,10 @@ else
   CFLAGS := -g -Wall
 endif
 
+ifdef EXTRA_CXXFLAGS
+  CXXFLAGS := $(EXTRA_CXXFLAGS)
+endif
+
 ifeq ($(feature-libelf-mmap), 1)
   override CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
 endif
@@ -176,8 +180,9 @@ $(BPF_IN): force elfdep bpfdep
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
 $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
-	$(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
-				    -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
+	$(QUIET_LINK)$(CC) $(LDFLAGS) \
+		--shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
+		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
 	@ln -sf $(@F) $(OUTPUT)libbpf.so
 	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
 
@@ -185,7 +190,7 @@ $(OUTPUT)libbpf.a: $(BPF_IN)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
 $(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
-	$(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
+	$(QUIET_LINK)$(CXX) $(CXXFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
 
 $(OUTPUT)libbpf.pc:
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
-- 
2.17.1

