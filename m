Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D0DD19DE
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbfJIUl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:41:58 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35913 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732114AbfJIUl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:41:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id v24so3899501ljj.3
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wbL2nu6acnton90gIbsX5qxq9tLlNkmN4RUryN8fm7M=;
        b=A3gY6o7HgTJ8YPTLbW0H4/UT2ZFoBSmF3dt74q0EUM3FTy6EnbqRwhaISluNSdHvUX
         CIawMYyGoTlYyjuuN/AxQM4IG/BMqNKUl+BPKvdsxEq50+r7fA4jI4lTQ1TO+R066sXk
         e7QCppCoKQ++RV9uKddTSrIyVbHD2INrvkF3Ffu2ISQMHRpqp9w9ljJoIeEPfbKLAWxQ
         urHJWqszpXSN4THwBKlG9/N/woZ8qllhLGFCX1DeT/IzKtBd20H2eeFSdY0HTEnbS6N9
         rw4DTH0s5ogzG+ZqTmvII3XMHWFfRIYNURW5r9/hOhHoiOYH598aERl9cfycrKxgW4gA
         9eQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wbL2nu6acnton90gIbsX5qxq9tLlNkmN4RUryN8fm7M=;
        b=GsADTsW8U3GSzWTk0bb7U4wrNDtfbE3o+Imblo3zjxDWha5N37C6ze0bfa1Okm/ZkR
         Q4KpKc19SOmdvfNJh8t65wOlBTFcG5KqvJUGW6EI4OUiABLv6uwtHnTgHkzCTb/vDQ6Z
         SIv9u0uu3fTBFHvhVzAn6+eRY7aohzillYsRYnbz2d/+4/d2QxdCWZ4BKlyhd0h3bObl
         IOqMyhrZ8Qlu4fymlz5nwPqXhRre5x14nhRVwNi24ilDFPqy/qiYtpJzigabL+lCiDGH
         nk13zGnVWon/hqtyIaEsmUaAiA6jJdzEK5xgrJfHpJIXAPKm0oePyR8IyV9ax9z7BiwO
         tmJw==
X-Gm-Message-State: APjAAAV8XLt6R2FfSrRYKwDlDTBznWVjfGDsNhAHeuSufkqEe9MuUlh0
        awB7Ir7Bu3waLl5A11ROCUjpbcrspbQ=
X-Google-Smtp-Source: APXvYqzzMJ/Xt+QwJqqo7iV2M9ovOX+F48KIoP3wwDBFtBp5+MeCB0SWdgoowUD7hVsKgWLwjOX1yw==
X-Received: by 2002:a2e:9449:: with SMTP id o9mr3534903ljh.110.1570653713531;
        Wed, 09 Oct 2019 13:41:53 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:52 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 10/15] samples/bpf: use target CC environment for HDR_PROBE
Date:   Wed,  9 Oct 2019 23:41:29 +0300
Message-Id: <20191009204134.26960-11-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need in hacking HOSTCC to be cross-compiler any more, so drop
this trick and use target CC for HDR_PROBE.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 57a15ff938a6..a6c33496e8ca 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -205,15 +205,14 @@ BTF_PAHOLE ?= pahole
 
 # Detect that we're cross compiling and use the cross compiler
 ifdef CROSS_COMPILE
-HOSTCC = $(CROSS_COMPILE)gcc
 CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
 endif
 
 # Don't evaluate probes and warnings if we need to run make recursively
 ifneq ($(src),)
 HDR_PROBE := $(shell printf "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
-	$(HOSTCC) $(KBUILD_HOSTCFLAGS) -x c - -o /dev/null 2>/dev/null && \
-	echo okay)
+	$(CC) $(TPROGS_CFLAGS) $(TPROGS_LDFLAGS) -x c - \
+	-o /dev/null 2>/dev/null && echo okay)
 
 ifeq ($(HDR_PROBE),)
 $(warning WARNING: Detected possible issues with include path.)
-- 
2.17.1

