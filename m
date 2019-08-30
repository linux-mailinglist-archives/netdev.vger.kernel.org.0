Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08230A3555
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 13:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfH3LAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 07:00:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36375 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfH3LAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 07:00:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so6547513wrd.3
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 04:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5KBK1cGSBEAbGEvyJtoTJ6fJ17kKSEVR9EUqVztgDKw=;
        b=xWDfxIOIYjzAbGRzXVhrfSAcx5KGF/2WAhU5H2OqBZ48pYok+kyM+p1t5Gnaek9CzD
         sXL5M2u80CQUo6GQqdbNNVgybgyl2KdMhvdwY+N4glLtQM2PsCvKZzGDdYvBUuR6Hfeq
         7iSQcGIGm0iopgQyc0B1lyRdp41mPv0wliTg40bx8gR45HfejzIK/qxOmsp47KUsCLJz
         uExjGUBtpeNHZ9Jl+MTMPx/4idDSCToZS8lHY0StfvpVeHdn34J7+GJIJl0eI05m0pVA
         F7XrCLUH1P+budt/kfxmrGDR1fCpT6hUiEzFb1PShYlKaim0uGVgBMl//kEXOyy4JKTM
         Ptxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5KBK1cGSBEAbGEvyJtoTJ6fJ17kKSEVR9EUqVztgDKw=;
        b=Lj+1HJk9lWu96DSSxxNFaUZb8kOFyoxz2AldMdLuuMcawP6ZYcg4A4i/k5bZe8WeJx
         hFhKiKMiO3WUQIewqHTQds8dYtLLwaLZ86UYIXQMTFYbZ+NEJLjmLny+P32hSi2tN6ok
         KZL8thKn+ZoTVM2t77AXuU70p/bU7/hc04JRoj8FRqonCueZ4DeQwJkW4mLjlCWwFIi7
         H2uClNSXm1+HqMqdEtVsFziLjtW6wr/Fki4JKptyuB1aUU7EaMEgJnLci5BdlC2DSq24
         +2iv8Ft/PtmPmNCOh4qHbB7MI1L+LM/rAI5j1fw+kAcb2IJLhpW98B5MdDWA3T3mPU4p
         jArw==
X-Gm-Message-State: APjAAAWeEr8583c9+WTQYdFkius1Q22QHBd1rziqaGu41NLhp9EtIFE+
        baPcy9haCDBp8ywmngkt6UxFOg==
X-Google-Smtp-Source: APXvYqyE5c88n/jExRazKL6s6y59bE1sgrEtKT0LVIyquRCbXmYNa+x6ZT6pa22w1q290hg4aQq0zw==
X-Received: by 2002:adf:eac5:: with SMTP id o5mr18636189wrn.140.1567162851509;
        Fri, 30 Aug 2019 04:00:51 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t198sm7848083wmt.39.2019.08.30.04.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 04:00:50 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next v2 1/4] tools: bpftool: ignore make built-in rules for getting kernel version
Date:   Fri, 30 Aug 2019 12:00:37 +0100
Message-Id: <20190830110040.31257-2-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830110040.31257-1-quentin.monnet@netronome.com>
References: <20190830110040.31257-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bpftool calls the toplevel Makefile to get the kernel version for the
sources it is built from. But when the utility is built from the top of
the kernel repository, it may dump the following error message for
certain architectures (including x86):

    $ make tools/bpf
    [...]
    make[3]: *** [checkbin] Error 1
    [...]

This does not prevent bpftool compilation, but may feel disconcerting.
The "checkbin" arch-dependent target is not supposed to be called for
target "kernelversion", which is a simple "echo" of the version number.

It turns out this is caused by the make invocation in tools/bpf/bpftool,
which attempts to find implicit rules to apply. Extract from debug
output:

    Reading makefiles...
    Reading makefile 'Makefile'...
    Reading makefile 'scripts/Kbuild.include' (search path) (no ~ expansion)...
    Reading makefile 'scripts/subarch.include' (search path) (no ~ expansion)...
    Reading makefile 'arch/x86/Makefile' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.kcov' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.gcc-plugins' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.kasan' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.extrawarn' (search path) (no ~ expansion)...
    Reading makefile 'scripts/Makefile.ubsan' (search path) (no ~ expansion)...
    Updating makefiles....
     Considering target file 'scripts/Makefile.ubsan'.
      Looking for an implicit rule for 'scripts/Makefile.ubsan'.
      Trying pattern rule with stem 'Makefile.ubsan'.
    [...]
      Trying pattern rule with stem 'Makefile.ubsan'.
      Trying implicit prerequisite 'scripts/Makefile.ubsan.o'.
      Looking for a rule with intermediate file 'scripts/Makefile.ubsan.o'.
       Avoiding implicit rule recursion.
       Trying pattern rule with stem 'Makefile.ubsan'.
       Trying rule prerequisite 'prepare'.
       Trying rule prerequisite 'FORCE'.
      Found an implicit rule for 'scripts/Makefile.ubsan'.
        Considering target file 'prepare'.
         File 'prepare' does not exist.
          Considering target file 'prepare0'.
           File 'prepare0' does not exist.
            Considering target file 'archprepare'.
             File 'archprepare' does not exist.
              Considering target file 'archheaders'.
               File 'archheaders' does not exist.
               Finished prerequisites of target file 'archheaders'.
              Must remake target 'archheaders'.
    Putting child 0x55976f4f6980 (archheaders) PID 31743 on the chain.

To avoid that, pass the -r and -R flags to eliminate the use of make
built-in rules (and while at it, built-in variables) when running
command "make kernelversion" from bpftool's Makefile.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index f284c207765a..cd0fc05464e7 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -24,7 +24,7 @@ endif
 
 LIBBPF = $(BPF_PATH)libbpf.a
 
-BPFTOOL_VERSION := $(shell make --no-print-directory -sC ../../.. kernelversion)
+BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
 
 $(LIBBPF): FORCE
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) $(OUTPUT)libbpf.a
-- 
2.17.1

