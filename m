Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F988A9C9
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfHLVvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:51:39 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:48984 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727694AbfHLVvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:51:39 -0400
Received: by mail-qk1-f202.google.com with SMTP id k5so4081787qke.15
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ci0/dDTEQ/TKTYA4PTTz/x+w1WNnSFlT+0iZElVTbkg=;
        b=Qz1M7PvURpf39A2GyB2ThYI6sZWekP4kv2/wK2aFuwloN8lbCxPc3rjZudsxak4kpn
         ajMlDmgK9Lu/NgFxIw4npr3+GQxp/RQRN77R18W7n5T1GJzD68w0MkzsXaIMJTN2I3Le
         IHTkYpbbFG1xRAubUMnsy18g9+4aGGoJv5yhML4ehVYces0T86ip2lzBf4TV3/1dBFmz
         rkizrYzDKRP1z/p0c9ysugw9oGhpmhEmP4orYaxGYbj9wc0ZPxEtrXqTMSL0umYO8f9P
         ZwBLT+KUw35Au9CQtI70zlZPeMbTJ6ylaDdbqr04CdqMW5iZjo+waL464CSdJCPaWl3S
         Z3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ci0/dDTEQ/TKTYA4PTTz/x+w1WNnSFlT+0iZElVTbkg=;
        b=H9MzFuL/aHNws2LpsjtENpFyIJp683MJAU0nbIzHRj/Zl8ulfeYJooVsBBdWhaiUR8
         RV+VqUWfnbM8xakqBgBvmOb9lJHtur9BgdKOEkQ8ywB02slNJl52amAUpyoarjSbbJF1
         BNOMZLJm0L7MxHFKnbHnfvP9abWv93cMdpM51FUzb61O6HjrBP6bTqPAJbTJhosljCun
         28Ls4knR4d56rel7TNajXGEvsnFIVP1+GcVFnZQqExJnV/k9Dq1uRgWgIeCd0xb6o1aH
         1W+fwbTEpD2SH2JlWXbQsre8rmebJco6l+MUlzzLTaiXLK5faQ1LVJdN7rfV7CFWtyG9
         yFEA==
X-Gm-Message-State: APjAAAUFz9E44FuAVlo7vnewGGDSwbPpx8Ur6JyPGkXrKB91O21yd3IS
        CBW7X3eEzJNm2K8VaYId07oVP9DHkQhiKGpgV4s=
X-Google-Smtp-Source: APXvYqx/cQmoHx7pahdoX11IzIW90P81FVgmK45vE2bdFVoFA+GBOZlIRuQdPPi0pnv12XzVEJvNaipQjrXdt9hMI8o=
X-Received: by 2002:a0c:98e9:: with SMTP id g38mr31135758qvd.187.1565646697667;
 Mon, 12 Aug 2019 14:51:37 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:36 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-3-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 03/16] parisc: prefer __section from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/parisc/include/asm/cache.h | 2 +-
 arch/parisc/include/asm/ldcw.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/cache.h b/arch/parisc/include/asm/cache.h
index 73ca89a47f49..e5de3f897633 100644
--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -22,7 +22,7 @@
 
 #define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
-#define __read_mostly __attribute__((__section__(".data..read_mostly")))
+#define __read_mostly __section(.data..read_mostly)
 
 void parisc_cache_init(void);	/* initializes cache-flushing */
 void disable_sr_hashing_asm(int); /* low level support for above */
diff --git a/arch/parisc/include/asm/ldcw.h b/arch/parisc/include/asm/ldcw.h
index 3eb4bfc1fb36..e080143e79a3 100644
--- a/arch/parisc/include/asm/ldcw.h
+++ b/arch/parisc/include/asm/ldcw.h
@@ -52,7 +52,7 @@
 })
 
 #ifdef CONFIG_SMP
-# define __lock_aligned __attribute__((__section__(".data..lock_aligned")))
+# define __lock_aligned __section(.data..lock_aligned)
 #endif
 
 #endif /* __PARISC_LDCW_H */
-- 
2.23.0.rc1.153.gdeed80330f-goog

