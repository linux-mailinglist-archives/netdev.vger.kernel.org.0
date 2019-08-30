Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1185AA2BD6
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfH3Aut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:50:49 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34878 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfH3Aur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:50:47 -0400
Received: by mail-lj1-f196.google.com with SMTP id l14so4830541lje.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=baF6/BEW5KEVo2LOFkZZTRTkQs3Veu82MyQ6XaftpOU=;
        b=biPM7KPdLtnr+xQRNp5xESVEeouLUJKehD24Gd9ioxx2OUh6OIbrndSWFIo+qFylSI
         kWdpwF+J69U+3pO4IuT7c63y1CwY11q0cXDK5OXsQnG4N+5QSF0rdTNyreizSd4oQ8ux
         Am84VUumVDcjZ1RoEaa413ZVsTrv4I2GuzRZa59p3t9MedXqHlG7BxfFeXGP1smCN1Rm
         pj+FEwpD4ZadSIML4/3wTI9ldsdEy1/4SBL2pH8rHBRmKHSJVdGhBCPlnrs46hM1tr7p
         VF5+0TZbcNTyjM8g81MSG9ZbEwNHniA392B0IqMVwrg9G2ma9dMcEqh7oNjuVlu+1z81
         Z/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=baF6/BEW5KEVo2LOFkZZTRTkQs3Veu82MyQ6XaftpOU=;
        b=g7HhPFI1b4QshDOw/qYhCvK6A1jv30eoP2dKMol2EeJO3QObqwp0QoIlsaDPpvlV49
         6tQufRi03ZFKq9FSl47O0qyyBma9SND64oj2pB33UClvhU2wh2oh4m46j3riKCA2ARkN
         JfShXz9pxbrHsRzhekwb7dMV3n9uGzTFUjh0Cv0InNA7vXxM8MF+XIJR2y09drXf7wDR
         CR2rZaw0zp9azZIG6kwAm6Sp+tDuE90jXovjbAqIdVhE72AdUGR1hDHadZFZv8ztsaCG
         xAlKd/ggrvSHOekHjrRvkvTxUAdDUhu93q0QR7rEpxo6H6f660CsMX3PXhmASOWdz1jk
         7QUg==
X-Gm-Message-State: APjAAAUF5ZM+/pKSFxcPWpxLuykEknC+W8TQ3CMt6N1EAZSJfj+I1qhA
        QDUfQCwnQv+sLw+N9597g7B0fw==
X-Google-Smtp-Source: APXvYqwlf7D/N+8AETmyrADFpsR/4uDHEHGgehGXXJJxn9PraZ2fAYxITTtvWqzPcr0SP5k+C+brcg==
X-Received: by 2002:a2e:900c:: with SMTP id h12mr6901426ljg.151.1567126245707;
        Thu, 29 Aug 2019 17:50:45 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id f19sm628149lfk.43.2019.08.29.17.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:50:45 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH RFC bpf-next 03/10] libbpf: Makefile: add C/CXX/LDFLAGS to libbpf.so and test_libpf targets
Date:   Fri, 30 Aug 2019 03:50:30 +0300
Message-Id: <20190830005037.24004-4-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
References: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of LDFLAGS and EXTRA_CC flags there is no way to pass them
correctly to build command, for instance when --sysroot is used or
external libraries are used, like -lelf. In follow patches this is
used for samples/bpf cross-compiling.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 tools/lib/bpf/Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 844f6cd79c03..d606d249e334 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -99,6 +99,10 @@ else
   CFLAGS := -g -Wall
 endif
 
+ifdef EXTRA_CXXFLAGS
+  CXXFLAGS := $(EXTRA_CXXFLAGS)
+endif
+
 ifeq ($(feature-libelf-mmap), 1)
   override CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
 endif
@@ -179,8 +183,9 @@ $(BPF_IN): force elfdep bpfdep
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
 $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
-	$(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(VERSION) \
-				    -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
+	$(QUIET_LINK)$(CC) $(LDFLAGS) \
+		--shared -Wl,-soname,libbpf.so.$(VERSION) \
+		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
 	@ln -sf $(@F) $(OUTPUT)libbpf.so
 	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(VERSION)
 
@@ -188,7 +193,7 @@ $(OUTPUT)libbpf.a: $(BPF_IN)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
 $(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
-	$(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
+	$(QUIET_LINK)$(CXX) $(CXXFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
 
 $(OUTPUT)libbpf.pc:
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
-- 
2.17.1

