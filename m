Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEB844C04B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 12:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhKJLt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 06:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhKJLt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 06:49:27 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB58C061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:39 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so1717470wmb.5
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uFsDhVwNfx2+wkoea0+L+uj6nk2RYNAhjgBsFkxBpOc=;
        b=LGuOHPNv5SM+Efl20xjITHcexnv/lLd9xDAvK0xXDYAM1Zuzey8RxnUiiLUbO2RO4Q
         l2LboeCRNrAKIpCsRdQ0zTmbU3D+IWFZ7Flqbcu6mlYNePFyZqgT2Dr1QnQhKrQFVkV5
         Bop2d6/nCinD7lw87akAXcFWfV8IHnDtFzyAc9HIqKv3tlc2/mJe5I9zUkUlSFZUg6F/
         a+o/jpb45DZSLo5OO5UJ21FdK244oIZ95VUbXO5Kvh2H2XWrq8SnvTsLiffZLP2/1IMH
         l9WmJR0HSmiRngOEQU9g62y3RFbAyaXy2vLEpdWAThQYWXywxej13J6k9ZN5L0rIcOn9
         lxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uFsDhVwNfx2+wkoea0+L+uj6nk2RYNAhjgBsFkxBpOc=;
        b=IvtQW6HEEQSeiatwcG+9d/a8v8ZljisGrNnY6Z9RXUdkvsrwLUd7ZjDvmkdERN/NkC
         aFdrBUUgf8ZBMfTUNx2aLoUbRvbQ/m4v185CdfrrgLiTpPEfNuEdCBEvCkYl2lwo0FNP
         DwhlZ/hkHuwtTmSBGVs5IdL2FyuHVzHulYkKk84SgOJu1rW3a4gHSSsJS9Lz49iypXZf
         6dBGCvgRrz50bzNhDyVOxrCSCb9fbDukyqFZUdZm0KkB7LGxYQjZ0rtk1hYBMqCB2MGh
         /SwV/viACwVKInJx3PX78clpJxwHcETOj1FYsUSTm9Gj4KDGzHCW2TZAXrHl6JkbFvus
         kP7w==
X-Gm-Message-State: AOAM530mASKUS/RmW/O9zh7y7RSPWVh4oC+4uMHQOIFzURU5ZsxPsHw5
        d2WsljGB4tiGJYDNMqZ0pC2C43PtL1KxGg==
X-Google-Smtp-Source: ABdhPJzRX4of9vIT8wZ5LBq5RdCJb+hTM8osAAIprtsMS+oFv3HstM8wzOlGAQOEQlO9LH6Mmp+Qcg==
X-Received: by 2002:a05:600c:5101:: with SMTP id o1mr15660896wms.81.1636544798013;
        Wed, 10 Nov 2021 03:46:38 -0800 (PST)
Received: from localhost.localdomain ([149.86.79.190])
        by smtp.gmail.com with ESMTPSA id i15sm6241152wmq.18.2021.11.10.03.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:46:37 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 3/6] bpftool: Use $(OUTPUT) and not $(O) for VMLINUX_BTF_PATHS in Makefile
Date:   Wed, 10 Nov 2021 11:46:29 +0000
Message-Id: <20211110114632.24537-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211110114632.24537-1-quentin@isovalent.com>
References: <20211110114632.24537-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Makefile for bpftool relies on $(OUTPUT), and not on $(O), for
passing the output directory. So $(VMLINUX_BTF_PATHS), used for
searching for kernel BTF info, should use the same variable.

Fixes: 05aca6da3b5a ("tools/bpftool: Generalize BPF skeleton support and generate vmlinux.h")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 2a846cb92120..40abf50b59d4 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -150,7 +150,7 @@ $(BOOTSTRAP_OBJS): $(LIBBPF_BOOTSTRAP)
 OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
 $(OBJS): $(LIBBPF) $(LIBBPF_INTERNAL_HDRS)
 
-VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+VMLINUX_BTF_PATHS ?= $(if $(OUTPUT),$(OUTPUT)/vmlinux)			\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
 		     ../../../vmlinux					\
 		     /sys/kernel/btf/vmlinux				\
-- 
2.32.0

