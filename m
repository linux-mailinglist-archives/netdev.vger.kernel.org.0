Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7942B76BE
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 08:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgKRHQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 02:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRHQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 02:16:58 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6A1C0613D4;
        Tue, 17 Nov 2020 23:16:57 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id js21so579929pjb.0;
        Tue, 17 Nov 2020 23:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CdQI5C98t7LZ1pEv4GMZDnMVWKgqmMtUOYvNiSvzudA=;
        b=LMjkAtbU4YDRmAuKc1jYATFtY1xW7glvFoPkf7S2JWBOQ0kTN+dAtwdm7zubvImgYy
         k4A+dfh5ZO5JdVTYcuOanXzZERNSr7OXwOhe4qiaWKp5Ys5+ZifRBkxFQtMC8hHDkBNM
         qz+1+enyAZSYwvVt/jQ5Y/8FhxxD5BTzjebVzTvDye3TXAoLO2Mi8jLUWHEBonDknnOs
         381JUdSP+2sRsHGlUTwn7VOcFpRfLwSI1Azd9vs3JPKHlatZ0x7qTUAyyE3j8zAnYN48
         DzZ1eR9jNhy0ZM/45WaEHjb9e0A+zmezNYeeKSoxs5mSkZooBcyLOS/1cd4SxgREdyuJ
         jX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CdQI5C98t7LZ1pEv4GMZDnMVWKgqmMtUOYvNiSvzudA=;
        b=YRUXkZK7YUYGG19818MIrgLk/suGIFWD7Xd9Y3qIzEvO6YzUzua4Aag4X4BLqDNtD7
         o1OxRYXuDHYaAag1qqvUHZEswRKzENxVtFs32zpbCehX/7f60o6sdCo41O/Qey5eMXh1
         m/qRP6jl8wfNfsSEIi6/ERKYvVAPZ8mbPibvoP9lQmZy6RAYEx6UjoJn4TFp9HFazX50
         gtiIBD9O7G24ihqOgB4bYflJoScXhLCWBD3AJkc3SSKvIcdePtOKrnk4VABxeXVX9wuk
         fk97hXrPQr2Jz1n/WBJFO8EOEpaVK+0NBPTV/GeML3omW9pmupotvhuUEzCRinQxV8YQ
         FSPA==
X-Gm-Message-State: AOAM5317xNkjR6kCroMsyF9OYZy/Pnde85eKTxtL4rMhcGgpmqzat+CK
        hB7ZRIFKBI84ko1QcthNw9s=
X-Google-Smtp-Source: ABdhPJw4/1/t7nwcBfpsnRyXSKkYvjQkLheyRuyIbHbgq6Y1wC5ljFFmZBpinmQxPd6ZLHhfnLxeiQ==
X-Received: by 2002:a17:90a:de93:: with SMTP id n19mr2847217pjv.142.1605683817025;
        Tue, 17 Nov 2020 23:16:57 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id e128sm23019382pfe.154.2020.11.17.23.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 23:16:55 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org, andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v2 1/3] selftests/bpf: Fix broken riscv build
Date:   Wed, 18 Nov 2020 08:16:38 +0100
Message-Id: <20201118071640.83773-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201118071640.83773-1-bjorn.topel@gmail.com>
References: <20201118071640.83773-1-bjorn.topel@gmail.com>
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
index c1708ffa6b1c..3d5940cd110d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -219,7 +219,8 @@ $(RESOLVE_BTFIDS): $(BPFOBJ) | $(BUILD_DIR)/resolve_btfids	\
 # build would have failed anyways.
 define get_sys_includes
 $(shell $(1) -v -E - </dev/null 2>&1 \
-	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen ' | sed 's/#define /-D/' | sed 's/ /=/')
 endef
 
 # Determine target endianness.
-- 
2.27.0

