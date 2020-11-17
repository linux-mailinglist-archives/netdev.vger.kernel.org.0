Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6912B5AF0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgKQI1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgKQI1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:27:00 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ABDC0613CF;
        Tue, 17 Nov 2020 00:26:59 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w14so16824241pfd.7;
        Tue, 17 Nov 2020 00:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=thC0vwUoC+dS5Z/fyfQ4HgfqnUUZ2rF5Qe//4cJ/e/s=;
        b=RSih97Qg5lNmEj0m87IY+niwHqXQAIC0ruEFGfQ30wLErhKzhrQ/CxWBfri5UoFeld
         Gim6tHlV6PtmyWAhIqA3IPrcXvEuQKObM42h1lCx3Ig5eMwhemVLyVXlXGYPNlv+QtiW
         GP7RbKgbLDoi34rHR4sn6rA7LydveHF5Ct2mJ/nlCJNyjvJTbn+BsihXINkZVHhsJgU9
         DdU6Nu5+Q7G8KvUDixsnqLHkbTbvc3dzrf8XHGmYNMhdC+b1DsvkI6Nq9N3om+PMNOKr
         tsAg+hvHCONXRTybQAwlqJ2ZlFGlzw4zs7UWeCJsor4+3V60Ud6WRhs1epEDwUYt916a
         i1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=thC0vwUoC+dS5Z/fyfQ4HgfqnUUZ2rF5Qe//4cJ/e/s=;
        b=fWzlVbOctZvdBLLjRWecsR3Q2p2I1lybQIevTTy/+2szTyPcMi2CD1DUUwN9tj1zYm
         44GXzD9TyBocgtTWt7TOy4PVZo1qNxvdEGsvN8R/ztiTgA9Ux+3RnT/V8BvNYXJOAybJ
         CIVSASwG4JFoO62fos4FzZeWG3bFsI2sjtRmC4KJ0C5EvhfRGU4m+cSEWNDJQlqqHFiS
         k/Y0Jkeilp7nB4wvSrQoLVMa9QPx7h4tpyTSykrN4FmXTm1D4G9A15FqLIHu4rwTeKny
         x88v4MDcBMx955w1pZX6Zqzy+FJsiv4QwnJ1VNZM2/SWnIxHeQkBnUP61dZpnDoPkTd3
         soZw==
X-Gm-Message-State: AOAM530Ri8ep766SAT3se3q05+3Nr+hh/hTky3rVVleAMiF8gv8KbbLa
        /ioqIF6d88rmFURvKjPCbQ8=
X-Google-Smtp-Source: ABdhPJwHbpYcDC4CrF1mzIpvea+B1cveoQuoSptG8JPZ/wuGPZ8c47r1CEbwD7dwW7n1FDA6IsIGyQ==
X-Received: by 2002:a65:5948:: with SMTP id g8mr2607912pgu.51.1605601619614;
        Tue, 17 Nov 2020 00:26:59 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id c12sm2251671pjs.8.2020.11.17.00.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 00:26:58 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 1/3] selftests/bpf: Fix broken riscv build
Date:   Tue, 17 Nov 2020 09:26:36 +0100
Message-Id: <20201117082638.43675-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117082638.43675-1-bjorn.topel@gmail.com>
References: <20201117082638.43675-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The selftests/bpf Makefile includes system include directories from
the host, when building BPF programs. On RISC-V glibc requires that
__riscv_xlen is defined. This is not the case for "clang -target bpf",
which messes up __WORDSIZE (errno.h -> ... -> wordsize.h) and breaks
the build.

By explicitly defining __risc_xlen correctly for riscv, we can
workaround this.

Fixes: 167381f3eac0 ("selftests/bpf: Makefile fix "missing" headers on build with -idirafter")
Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c1708ffa6b1c..9d48769ad268 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -219,7 +219,8 @@ $(RESOLVE_BTFIDS): $(BPFOBJ) | $(BUILD_DIR)/resolve_btfids	\
 # build would have failed anyways.
 define get_sys_includes
 $(shell $(1) -v -E - </dev/null 2>&1 \
-	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+	$(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen ' |sed 's/#define /-D/' | sed 's/ /=/')
 endef
 
 # Determine target endianness.
-- 
2.27.0

