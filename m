Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A872D35E1
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfJKA2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:28:42 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45460 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbfJKA2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:28:41 -0400
Received: by mail-lf1-f66.google.com with SMTP id r134so5712277lff.12
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dPicZ6dKiXggVDaTmZsHbexmmGF0NBX0XkLCl2NE9e8=;
        b=t3MFZlp7JrKOCwmfn7u1hOiMi68CPBBmhejF5DP7FCApB0OUHnL1e1Vz0PnjgoLIqj
         wAkQ0GsgS4/ldLyAt8/zw9mgK+sFqHd4lVWktvbzEARep/C0sshXBBKSEaDAGcVo0/6V
         8BTYD9LaGz/q/C5QeVOsLb/AKAwgJehXdhpIyM/J8HjfAaW5Btm4K7VJtZpNYWUEfCbY
         V7wShmtXIoIbmuXnBXoESSkwV7otaZ4ffWiRKF6rodq/UYfP4y6E9PWlD7sMelgEXZIG
         kjdyeC45fhvQOlabnZHkFElf7V9BeT+hBH7v0X8MgAM1mpO27+xgEXiqHAKtawGnSvK1
         yzqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dPicZ6dKiXggVDaTmZsHbexmmGF0NBX0XkLCl2NE9e8=;
        b=GUqcOArrsRW9Gf1UKhKEvvtL4kDD/GA1t2xg0rAlCIIWLKHGC65H5aoWMXxGY9QG0/
         wQhNfV3Tyzuh1hHJOkaCl4TN0NdEDfBKDfrHoiMGzhP71plMctruBJxYzo529vmI0+vk
         eNA8enN+71hhqk1I9UmX0ZFKVT0m2rKAK8UjcMKSnvRwPyHlVHNqkfQ/9ls/KzJ6Y/BF
         PRkIDkXepVCC9l4zn/Q6bC2X1cz8YKYVvV9ST7M4a2O6kf09i5F2tvGDfR9rFP9GPXzx
         g23O9Qjm8bA7xy71F6ZOP7+49kNOtKvz/zzKjKZ6mfp/tb8vb7j4vpUO9vXFdrjHUiE5
         VRSw==
X-Gm-Message-State: APjAAAXpuMOKjiI1Pzp/jZslRkhHEd+dcPmbSY/F1nK6usjL9ym8TgPZ
        G3QV+Aa4MoTtHQEe5dR6KSc/Pg==
X-Google-Smtp-Source: APXvYqzLwdRMPb489Yj1aqW3Q1PJbqbKOk1Y8p49pmLW2Luy9x6kzXc2gUyxjMp2Ov4+EzwjU94LOg==
X-Received: by 2002:a19:c392:: with SMTP id t140mr7564752lff.156.1570753717149;
        Thu, 10 Oct 2019 17:28:37 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id 126sm2367010lfh.45.2019.10.10.17.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:28:36 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 bpf-next 12/15] libbpf: add C/LDFLAGS to libbpf.so and test_libpf targets
Date:   Fri, 11 Oct 2019 03:28:05 +0300
Message-Id: <20191011002808.28206-13-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of C/LDFLAGS there is no way to pass them correctly to build
command, for instance when --sysroot is used or external libraries
are used, like -lelf, wich can be absent in toolchain. This can be
used for samples/bpf cross-compiling allowing to get elf lib from
sysroot.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 tools/lib/bpf/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 46280b5ad48d..75b538577c17 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -174,8 +174,9 @@ bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
 $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
-	$(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
-				    -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
+	$(QUIET_LINK)$(CC) $(LDFLAGS) \
+		--shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
+		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
 	@ln -sf $(@F) $(OUTPUT)libbpf.so
 	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
 
@@ -183,7 +184,7 @@ $(OUTPUT)libbpf.a: $(BPF_IN)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
 $(OUTPUT)test_libbpf: test_libbpf.c $(OUTPUT)libbpf.a
-	$(QUIET_LINK)$(CC) $(INCLUDES) $^ -lelf -o $@
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
 
 $(OUTPUT)libbpf.pc:
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
-- 
2.17.1

