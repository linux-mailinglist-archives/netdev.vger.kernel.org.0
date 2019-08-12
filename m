Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243198A9E7
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfHLVwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:52:18 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:39441 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbfHLVwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:52:18 -0400
Received: by mail-qk1-f201.google.com with SMTP id x1so94452227qkn.6
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CMqgCUm+GxLehEdw4ZyFc9UqjqXT2SeM4A16UJsbPIg=;
        b=cEJcf9Y0TRBDvUfh7MDfEoOyZM+EmdiGeHKpU+4TT2H8QHtoDwx47a0Bdkd4grgnck
         AgKdxC7cLoC0YgryFCmAsQacbbELc3GMXpyG5foU2D3IorLvYpb3u4LbP+EWBLb+ONZn
         xu7IiQg3HetB6nQuaBGNlxs7Sr7tIqxEFdlxTcoFSx9y/5H5DOJeHMZBNvraJK4HPofL
         RJsn+4usFleoPDE+Pi/F8rWyKd8I+I1beDSXDkW8gGxrBPE7i61Bujv42XuPx6GAgaek
         494TPvcDlGC6P/e5+FY8HYPsHRt/m6cIUbWe9gHGpZyW8mZYgRY00Km4Z+SYLP5VskTG
         2U7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CMqgCUm+GxLehEdw4ZyFc9UqjqXT2SeM4A16UJsbPIg=;
        b=Pa21tIMSaSI5e/SYiwOJiJsWe0Gb6iFwV0K4YCXwqq3Wwk0Y98uSzckuH7AxNHyx4n
         AgdB+kT7KSQGDWDuhxLNCH3Jhy0zxIJPPYG/xsohG9M2Bhn1v9BFsJ3UOBZVawXkVpil
         trON4vloaKQ9OEwXkH2zggsYps9eV/NEyP4ysKSF8gb4Yf0moTqaYVE4bOqZ4xoBU7nZ
         uVvo60G5F9VFWs7Gj2jLWGmo1yLErhdpjThZNR7K7NxD5ETR571QvN2pW1QwqPV3ggUF
         1y4Gj3Z2DWEk53VK5OiODfLieBXn9iFOzZ6sRfjYJTWN3hJI9yR9Q+J729EFBA+L9W9I
         Dhiw==
X-Gm-Message-State: APjAAAUG3Fuq0yrtbRxF2y9oXH91yPM471sVskdK1Sa2MLh20eOliJSM
        TJFwP1Z6zQVFhmlFMh9Oi3EiwSn+QeMHZWYu7J4=
X-Google-Smtp-Source: APXvYqzQFJN/qlVvUNeiMuVCHF2UNgPcW3Ylev0M+rUpavcq5oQsKnHk5LDh1iN6YRuu2esK+vHi3t7qoB6T+Vrv3Xk=
X-Received: by 2002:ad4:54a1:: with SMTP id r1mr7354704qvy.213.1565646737123;
 Mon, 12 Aug 2019 14:52:17 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:42 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-9-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 09/16] sparc: prefer __section from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/sparc/include/asm/cache.h | 2 +-
 arch/sparc/kernel/btext.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/cache.h b/arch/sparc/include/asm/cache.h
index dcfd58118c11..9a9effdd01e2 100644
--- a/arch/sparc/include/asm/cache.h
+++ b/arch/sparc/include/asm/cache.h
@@ -21,6 +21,6 @@
 
 #define SMP_CACHE_BYTES (1 << SMP_CACHE_BYTES_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data..read_mostly")))
+#define __read_mostly __section(.data..read_mostly)
 
 #endif /* !(_SPARC_CACHE_H) */
diff --git a/arch/sparc/kernel/btext.c b/arch/sparc/kernel/btext.c
index 5869773f3dc4..b2eff8f8f27b 100644
--- a/arch/sparc/kernel/btext.c
+++ b/arch/sparc/kernel/btext.c
@@ -24,7 +24,7 @@ static void draw_byte_32(unsigned char *bits, unsigned int *base, int rb);
 static void draw_byte_16(unsigned char *bits, unsigned int *base, int rb);
 static void draw_byte_8(unsigned char *bits, unsigned int *base, int rb);
 
-#define __force_data __attribute__((__section__(".data")))
+#define __force_data __section(.data)
 
 static int g_loc_X __force_data;
 static int g_loc_Y __force_data;
-- 
2.23.0.rc1.153.gdeed80330f-goog

