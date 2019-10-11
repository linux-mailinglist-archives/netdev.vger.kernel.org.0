Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B34D35DA
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfJKA2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:28:31 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:33672 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfJKA23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:28:29 -0400
Received: by mail-lj1-f176.google.com with SMTP id a22so8065615ljd.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dRRusRl3mddScRkdUTvMTuf5U4XldYcoWbxA4ajO70k=;
        b=JiDnktEVbjGXgr5jDkjz+nyzDLWoFzL++RSonmBJ1+BCVuJHjKwvQRzKF2N/0yd6X3
         rRShXLxxe8luonjB3if8Jju9/CgVbuDGlKy/tg8MSeZioRHeKgP5R4sAwJ5pVtugVZwQ
         JLSmYuNW4Tkf/qJPHii/E3gkbv2vFALS202fCqRZBL05OL+6ne+UYEpmQga9PbjCPqSN
         0nWRvKpvNQVVfZbRUm6eOPYne/3Ur1hzKNikB6xuy0ht798+2g9CoCrzv5U9X0ClflYt
         bD2ySMU/NdPjLvXb8qgPsw5CokeevbTK2D02ulcZeGt2HKfrL+qGbxbpXdo/hefjqt84
         jA9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dRRusRl3mddScRkdUTvMTuf5U4XldYcoWbxA4ajO70k=;
        b=V5AfoDaOkcwTxHObFWtzQl/iCaFxCuuw8tDcJf51PMD/rlQKOcfYttXBT/EVg6E3Wr
         iQcnWvW39IJMSmR/scluOZfpjVGeJYBgUIB6mvVsG6y0FsFWLwb/6bRXkd6aEQIjcrdQ
         H6rpppI4Z0+ynyJQEI6Em3oXAfBzc2bbSg9xsaMgFJLOclZCwRRYJFON3LBeWZZjTVtP
         wcIHVnewFDjQmftdQVJNmVM6tG7m8TMo3NDmfzLUt0ecB+T9F+vGSFet2+wBEmnpaxdE
         1pA8OvPqWaoxvSCwlXDpdRxxnTeNZ+DHBwz/r1xh6xTkgQOBB6lZBBVEFdMWTTmWGjR3
         Kxhg==
X-Gm-Message-State: APjAAAWWNexHShDShc6HOTF5prhn57sMK0pCVDchdUa4r4zdL9E1pph/
        Tx0+GxDPRGUpKSg6yMzGecZWH7uOrCM=
X-Google-Smtp-Source: APXvYqzUQuIDYXVqvleZeaiTHjhwry2+VSzhEq2mtNCyA7UuGrBLAmUOj5lnWPr/cyPl23bZHeF5gA==
X-Received: by 2002:a2e:a211:: with SMTP id h17mr7749678ljm.251.1570753707769;
        Thu, 10 Oct 2019 17:28:27 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id 126sm2367010lfh.45.2019.10.10.17.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:28:27 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 bpf-next 05/15] samples/bpf: use __LINUX_ARM_ARCH__ selector for arm
Date:   Fri, 11 Oct 2019 03:27:58 +0300
Message-Id: <20191011002808.28206-6-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
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

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
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

