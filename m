Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA3541D8E1
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350551AbhI3Lfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350532AbhI3Lfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:35:50 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA208C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:07 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d21so9466466wra.12
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6G1NPylBOR/ww+hDOMCQFvHQVyGOy8KdOupILpftMKg=;
        b=kpV1autVa2E0Ief9wVAQqL5K7HLT9trRbeMj6PgYMLuhPr5DC0lRElikLdZSvHd4mO
         pFxrGCYkbpUaeIm7WqqAx1Y9ROP+Icbhu3l8RLvr2dqKd2ceTxfPhC+woaLOS8+JmhrW
         KAcGKAz9AQkqlSg5lMd+DEg5L/o+3EPQ0w8aZxHAAt5aKsoiJYiwvJ5776u6hYGRjxCj
         vy1BKFF8sSsNkbVqbtD2xekBZrx3F+bvQi7qPgMaYSR+qqWHy0T9RktETl2lXF/YHwx6
         NVV7KzC4zVw4959mQFyon+wXYfcOZwkZl3nWjZg9CiBePfT32bds0GcJyCOhv98NUAuA
         KPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6G1NPylBOR/ww+hDOMCQFvHQVyGOy8KdOupILpftMKg=;
        b=jeR+zJt7IPv/kuzHn3Gip8EuB5ubPLaOd6HurK+1+sAGT3QZpLG5aoZaSkC29HGYVo
         WvGJVULAJf9uxh6IERpove8KsswCZ8yhd8zxGPFJIJMXZgms4trFF63K9x6TyCper07p
         C/vPgzkWsjI247EyBAB8X2zDYTnrc9H5jPZRu/6FaCTjZJ9y3dFuzRoNgXeYQuHZDruM
         OHDne0hXxDjE6a5Zn/G6buFurCGZlH+vOjJ0ki6OdOcRh8OszXXVGeMmDuuGLTrBsvii
         ZSr9CErO+bnnndXcz4ASAOPLDy16YooEDIwK9E99EY1XPvQbj5LEleKZmMuDWde9iaYQ
         wgDw==
X-Gm-Message-State: AOAM531h3oNpFa0mem3uAFsy6CInLzMYZLpyvBvM5c8/Hera/VIvKakD
        O3ThobYZdQOJVw8J4PSPw0yMBT+iX+CXO7F8
X-Google-Smtp-Source: ABdhPJy9TILGrseKztGLzOKWyVsdXh4NoWKLUdV+GEtnN3oCHlsZXqIsB1Kfe2HBXWmjzLDQdPCz/A==
X-Received: by 2002:adf:f946:: with SMTP id q6mr5508000wrr.437.1633001646344;
        Thu, 30 Sep 2021 04:34:06 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.95])
        by smtp.gmail.com with ESMTPSA id v10sm2904660wrm.71.2021.09.30.04.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:34:05 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 6/9] bpf: iterators: install libbpf headers when building
Date:   Thu, 30 Sep 2021 12:33:03 +0100
Message-Id: <20210930113306.14950-7-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930113306.14950-1-quentin@isovalent.com>
References: <20210930113306.14950-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's make sure that bpf/preload/iterators/Makefile
installs the headers properly when building.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 kernel/bpf/preload/iterators/Makefile | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
index 28fa8c1440f4..cf549dab3e20 100644
--- a/kernel/bpf/preload/iterators/Makefile
+++ b/kernel/bpf/preload/iterators/Makefile
@@ -6,9 +6,11 @@ LLVM_STRIP ?= llvm-strip
 DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 LIBBPF_SRC := $(abspath ../../../../tools/lib/bpf)
-BPFOBJ := $(OUTPUT)/libbpf.a
-BPF_INCLUDE := $(OUTPUT)
-INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../../../tools/lib)        \
+LIBBPF_OUTPUT := $(abspath $(OUTPUT))/libbpf
+LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
+LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
+BPFOBJ := $(LIBBPF_OUTPUT)/libbpf.a
+INCLUDES := -I$(OUTPUT) -I$(LIBBPF_INCLUDE)				       \
        -I$(abspath ../../../../tools/include/uapi)
 CFLAGS := -g -Wall
 
@@ -44,13 +46,15 @@ $(OUTPUT)/iterators.bpf.o: iterators.bpf.c $(BPFOBJ) | $(OUTPUT)
 		 -c $(filter %.c,$^) -o $@ &&				      \
 	$(LLVM_STRIP) -g $@
 
-$(OUTPUT):
+$(OUTPUT) $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE):
 	$(call msg,MKDIR,$@)
-	$(Q)mkdir -p $(OUTPUT)
+	$(Q)mkdir -p $@
 
-$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)	       \
+	   | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)			       \
-		    OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
+		    OUTPUT=$(abspath $(dir $@))/ prefix=		       \
+		    DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
 
 $(DEFAULT_BPFTOOL):
 	$(Q)$(MAKE) $(submake_extras) -C ../../../../tools/bpf/bpftool			      \
-- 
2.30.2

