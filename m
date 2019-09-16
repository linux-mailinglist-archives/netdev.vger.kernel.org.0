Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B344BB38BF
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbfIPKzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:55:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40620 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732564AbfIPKy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:54:58 -0400
Received: by mail-lf1-f65.google.com with SMTP id d17so9214935lfa.7
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GxawIQ/MKoaOi42wOtzkwYPMR5CVbDtqJel19jnEoB8=;
        b=kBKPwGq0mxxasnUu8ZX4K5BUyfdUDK4at7rwgKR0KzP3udeJcRypxl6J6mXwSYptEI
         GTvX/Y9iRzZddsykOu7Nlc8Pw/gKhZd+iad9pzVoqIiGe8rjSNE+J2mVt23GFITZ+Zy1
         ENpShtY9dvkl0TIxofqTrkdzjwgILVAW6GT1zul5j6yyGWB56wXx34c7J7RUYINRpTdl
         cu7B1+uzv1Nz4WWCL4UcKSvh8ShMCvcLzxr4WZSRinLS7NDUSri7YzJM1k6fvRn5p3+n
         3Naodq56EveQzQ5cGR1+YAil3F1aalEHLr4w0rRvTpue+DuT6rfDoAYi0+8uPQ0+a3t9
         utlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GxawIQ/MKoaOi42wOtzkwYPMR5CVbDtqJel19jnEoB8=;
        b=caV6yHaUaMidlFRMgY0/L3Py6+fPHeZqkuLCyMpvuc1rHcm2MarzXzyBnDtMPFHwBS
         BuTCAAUNaX4fUzajrzXombue2TImef8kJs9G1eI4XwlMwuq08O/89vQPwXAXtu6gRVqN
         ji/o1/6AiIE7kCtL5CNWmXwpPFuxw4Wn7VUC6UjedWAR4A2q0VrY3MXUwjPlM+i6BLLM
         S4yQHdLCfgQu+BVIgl99RuxDTGKHwyfPKMCy3Utnkqs9/XYRHLxyC2/dg4bL+Qa+fuv7
         jCd9XZBdTWBLhqINESAmtI3IP8ATyySW9YP+yH7N31POoiGOaEDx8iYVCKqu88hGOLRL
         QMfg==
X-Gm-Message-State: APjAAAV8UaIsljOpBHpNWpNGnQAVvjeW7mPwfkWSi0MgXyotjKDDce/J
        6AtpTYfgs2pjcsQF0+6NnN5ZiA==
X-Google-Smtp-Source: APXvYqybDDXo4hm0aSUXkdMe63uO/eDR7vCuhBu9UXylhlta4Tq7LeJLlEG5S6mxBfSUaSqbl6/OHg==
X-Received: by 2002:ac2:5090:: with SMTP id f16mr39613241lfm.66.1568631295949;
        Mon, 16 Sep 2019 03:54:55 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id v1sm8987737lfq.89.2019.09.16.03.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:54:55 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v3 bpf-next 12/14] samples: bpf: makefile: provide C/CXX/LD flags to libbpf
Date:   Mon, 16 Sep 2019 13:54:31 +0300
Message-Id: <20190916105433.11404-13-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to build libs using C/CXX/LD flags of target arch,
provide them to libbpf make.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 18ec22e7b444..133123d4c7d7 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -182,8 +182,6 @@ ifdef CROSS_COMPILE
 TPROGS_CFLAGS += -Wall
 TPROGS_CFLAGS += -O2
 TPROGS_CFLAGS += -fomit-frame-pointer
-TPROGS_CFLAGS += -Wmissing-prototypes
-TPROGS_CFLAGS += -Wstrict-prototypes
 else
 TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
 TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
@@ -196,6 +194,14 @@ TPROGS_CFLAGS += -I$(srctree)/tools/lib/
 TPROGS_CFLAGS += -I$(srctree)/tools/include
 TPROGS_CFLAGS += -I$(srctree)/tools/perf
 
+EXTRA_CXXFLAGS := $(TPROGS_CFLAGS)
+
+# options not valid for C++
+ifdef CROSS_COMPILE
+$(TPROGS_CFLAGS) += -Wmissing-prototypes
+$(TPROGS_CFLAGS) += -Wstrict-prototypes
+endif
+
 TPROGCFLAGS_bpf_load.o += -Wno-unused-variable
 
 TPROGS_LDLIBS			+= $(LIBBPF) -lelf
@@ -257,7 +263,9 @@ clean:
 
 $(LIBBPF): FORCE
 # Fix up variables inherited from Kbuild that tools/ build system won't like
-	$(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(BPF_SAMPLES_PATH)/../../ O=
+	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
+		EXTRA_CXXFLAGS="$(EXTRA_CXXFLAGS)" LDFLAGS=$(TPROGS_LDFLAGS) \
+		srctree=$(BPF_SAMPLES_PATH)/../../ O=
 
 $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
-- 
2.17.1

