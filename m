Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D491AD19F8
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732322AbfJIUmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:42:49 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:37875 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731990AbfJIUls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:41:48 -0400
Received: by mail-lj1-f175.google.com with SMTP id l21so3885691lje.4
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q8GViA3rslKXoIblVB14HOdim3G08AtxcYrIekVeHcE=;
        b=pfrCF401TvMKnGGNl+mGcNqDCp2vUaNFpxEHOZUq1XK5MSPm3P1fYAf7wPUa+ETpQy
         VOVS4CBzr+1pxsUk6OaY9H5cdbJJGJ79afBvAVM7dhtqB3p/rgd3mhnIdLqFLvDK0mTd
         g0BL+HT0f/ysat5klwdZ82W7ujyD7W84PDhXsN3PpZ6AVA+ItryF/xgSXb9ZFPZ0XQH8
         bbDmHihjaFmyodxwsKWZK1D9NAxKeEqJpo8wMBZLQH4UaAtgHRCn4mApNkvdxUcnXGbV
         DQg/S8s66IiuaM28TVfm+AHtC3W49BgIRvSedebxXVHbJ/nrr4jh4KffMFSzscaK04Ud
         MiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q8GViA3rslKXoIblVB14HOdim3G08AtxcYrIekVeHcE=;
        b=MLLmKa13TCF2R+cFhSutYq8ugUu81zmtrUrEqgTZqLq3lqJYNW7TpLZoIuFhhx1S3y
         zTWJ20wlOMSBVm4PYubPyersnvbKLw6lsFxnPF8FJ5VK2XssmtnrJ1T8pryFsjezGyb1
         CEEsBIR004EWnNQlkkADu73/oGzWdTe6k5ytGKiIYKmRQoJpPR1zYJRsqiBOF2eddNpC
         MdZGpePl2Yt0CAJzUS8C5dVV9MgIwmEAlXEak89qoCLuyxkYYEdXPJV8uNGu2HmOBrE/
         T7vtsyyk6YC9n8zuD/bsRf+AlY4PLC+1iY6yI7Mc4MO5zINgwbmGKUh/X0G+ezW1IRL4
         Lspg==
X-Gm-Message-State: APjAAAUoa8YC7M8nmnGpYf5Eqhn48iNQ7N9CnFkvzbvG2Yrg+kdbY0Dl
        uDSDGOjOY98XrV0buOoKn7pMjA==
X-Google-Smtp-Source: APXvYqxuctn/aA7ZrMAT8XQt+9VdRu1DrxUiAKw6n2hPLrMceayMK9zf2VM0qBBS8IA1Bb4098YjEA==
X-Received: by 2002:a2e:9890:: with SMTP id b16mr3652941ljj.4.1570653706617;
        Wed, 09 Oct 2019 13:41:46 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:46 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 05/15] samples/bpf: use __LINUX_ARM_ARCH__ selector for arm
Date:   Wed,  9 Oct 2019 23:41:24 +0300
Message-Id: <20191009204134.26960-6-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For arm, -D__LINUX_ARM_ARCH__=X is min version used as instruction
set selector and is absolutely required while parsing some parts of
headers. It's present in KBUILD_CFLAGS but not in autoconf.h, so let's
retrieve it from and add to programs cflags. In another case errors
like "SMP is not supported" for armv7 and bunch of other errors are
issued resulting to incorrect final object.
---
 samples/bpf/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index cf882e43648a..9b33e7395eac 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -185,6 +185,14 @@ HOSTLDLIBS_map_perf_test	+= -lrt
 HOSTLDLIBS_test_overhead	+= -lrt
 HOSTLDLIBS_xdpsock		+= -pthread
 
+ifeq ($(ARCH), arm)
+# Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
+# headers when arm instruction set identification is requested.
+ARM_ARCH_SELECTOR := $(filter -D__LINUX_ARM_ARCH__%, $(KBUILD_CFLAGS))
+BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
+KBUILD_HOSTCFLAGS += $(ARM_ARCH_SELECTOR)
+endif
+
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
 #  make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
 LLC ?= llc
-- 
2.17.1

