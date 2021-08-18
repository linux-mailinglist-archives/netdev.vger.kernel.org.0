Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1A03EFB56
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbhHRGKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239351AbhHRGJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:09:42 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47059C0698C2
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:02 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a21so1069828pfh.5
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6lG0U8bM2TUXGlj9bAHKfwVFEdBo2YZlvkgJ69Lo3ko=;
        b=Y/DVgqUz//veWIPGInRHjxd8QhbyKfsy0kdugXO1nEyKRG4J+RATjtzLJoSS87jCco
         VSjAoqrkaHNZh0+mHRdYJBCbqV9xxVXdwGu7uaa7PR+N6pyz9+QKjSd2/AWYtac6EKNc
         sHLZn6ndy938GBH63DZ5ESf+mXsv8jS252ytM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6lG0U8bM2TUXGlj9bAHKfwVFEdBo2YZlvkgJ69Lo3ko=;
        b=AQQRghToyrAXs0xIcT92h9wXQ/0WDMzbmKmx2IJa71Lg1HosCL18dneWJmgXODZZnp
         akt7TehT1kB8ohEnaE9od3sdDSscPapcmwtnw6vLgAKzzy+tjQTfNaY6QWjcLjL+tU7c
         Gxxc/5qiNnLX9Qr9ixXQh7a0aMJOpwsq++MYixtbtEvbdIWxaIe+NdYubkdI5+nWZFC5
         tpuxSWg7ieO9JhDOIFNzS0mhGwFBdhxn4S/J9YOgxh9VbgKhUZAXV68acOfKZwDa1XYY
         e8BDzMmLw/Bse/INuOEWhDwVCz8ovr/3ko0Usdf0Z9kzQ+9mwZ5ynq5isFwIMpVQwMnc
         n64g==
X-Gm-Message-State: AOAM532zQeN4FzBhenelIeFMr/AlmVtL14aPkYB+l/u/4/XxODWLqNNj
        FnEirnwPfFtzVk0PtEfshzMpJw==
X-Google-Smtp-Source: ABdhPJx9i0gP/tEqucjw5t2MRNzXtgPICZZmJol3/cEVKCeeDWJ8qCew27BG46wra+MkbfYjKbKkfg==
X-Received: by 2002:a05:6a00:cd0:b0:3e2:209e:4e30 with SMTP id b16-20020a056a000cd000b003e2209e4e30mr7598474pfv.59.1629266761883;
        Tue, 17 Aug 2021 23:06:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r10sm4624434pff.7.2021.08.17.23.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:05:58 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 28/63] fortify: Explicitly disable Clang support
Date:   Tue, 17 Aug 2021 23:04:58 -0700
Message-Id: <20210818060533.3569517-29-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1427; h=from:subject; bh=MScHo/g3fAm2U5yn8644/6JAGaRCvw+x4s3NMxUkYP4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMkDmaoP7/LrBvrUTwAq8PIwkOtE8yNEb1/iGaE eotqJxGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjJAAKCRCJcvTf3G3AJvkeD/ wK2I9wXb6VkTqNx8ve7VdNSMmlz+1i164ClH9CGR/35x6hLdSQ8qayX0H9g6LrgzVflJDSu0VPqZq6 B60wT0GUsaN+NPYsGb2bVu1Rg3uumqZGiK90AHNJmSYkYU2G3Fqfi/WbeuSh9MygcOeGp/a9x/PQH5 e8dULezGq6dCpC7cs5Zl3okkhjEBCJNG2UsDzKuR/shPokEXvmczONNPE0wD9SGKoJlCrtTATmKvin 4tu2+3vQYizkssvftVjPL/zU+2R6x89hzrj96XdH+uAmeG5P820sWztifwnAHNcLVL5gq7wUOMrJ+f Z4XjIAC/G5EaSS4AhVIu9sD/iX8aeWmFJWF/Y21WLVPcvT0CbToC2WmKfl6Cf/5cmduks3BDmUc73D LWQ9JncTl44MKCvuBhARaFmlaFAJHnLG2EvjMIRi62WS27zMVn6Had7IAo/qffp70xB+LqBNwHlEFR 1DOf7RDGukFMS2YPB64C7srE0otlJasITjwoT2VlC8SUubfSWf2Xs29w2K9ID2LufJo4jW+DES/y1x In7sKpTi8O1ywlBFrMpRGpBZemeuMVX+n2a4KW0Dlmr8PJZVEczotW0P4mEO8JYhohZFLrpQR/oM0d v1l42WB3iKEQLRJlt/B8Os8r3w8Ad46AyHq8GE3PhyPABlRRPciSKq8TGApQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang has never correctly compiled the FORTIFY_SOURCE defenses due to
a couple bugs:

	Eliding inlines with matching __builtin_* names
	https://bugs.llvm.org/show_bug.cgi?id=50322

	Incorrect __builtin_constant_p() of some globals
	https://bugs.llvm.org/show_bug.cgi?id=41459

In the process of making improvements to the FORTIFY_SOURCE defenses, the
first (silent) bug (coincidentally) becomes worked around, but exposes
the latter which breaks the build. As such, Clang must not be used with
CONFIG_FORTIFY_SOURCE until at least latter bug is fixed (in Clang 13),
and the fortify routines have been rearranged.

Update the Kconfig to reflect the reality of the current situation.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/Kconfig b/security/Kconfig
index 0ced7fd33e4d..fe6c0395fa02 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -191,6 +191,9 @@ config HARDENED_USERCOPY_PAGESPAN
 config FORTIFY_SOURCE
 	bool "Harden common str/mem functions against buffer overflows"
 	depends on ARCH_HAS_FORTIFY_SOURCE
+	# https://bugs.llvm.org/show_bug.cgi?id=50322
+	# https://bugs.llvm.org/show_bug.cgi?id=41459
+	depends on !CC_IS_CLANG
 	help
 	  Detect overflows of buffers in common string and memory functions
 	  where the compiler can determine and validate the buffer sizes.
-- 
2.30.2

