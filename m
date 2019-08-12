Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3F78A9DE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfHLVwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:52:06 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:35045 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfHLVwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:52:05 -0400
Received: by mail-qk1-f202.google.com with SMTP id z2so13792050qkf.2
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4H9PWcGFWTnQRRpR6qzftNQ0lP7jmcpJc1z5bvKXC0c=;
        b=GOYts8y62z5hDG5UBvKTyRA53eo64IPfTWzoj20oJPWRcHrTKxwsvLxh3a4n5gbZEv
         PEmhfuyQJErUyzHsQgmc+BxiQ+0zaHqdQPYkHNoGmXn1M/p3nNSyCS4YS+QnjsSu15e/
         4p9ECmVJbtW52/m719Gd9XDThtFlJaVi8EAw8eYS5rrF7pNdIpC8S3YQAtKU4R/HoM1y
         BQi3xcPQqrL81dRaMBvh/8Aty6jeE0XDlyzQopxkixPirRMhNQ2BW7dcG4t34N56iTRJ
         t5GaJvbA2lpJTkd80ffPOg6j49O1q9MIvTWyeV3HEdK0REH1ZKW2JM3VYuddT4rKkiLa
         91eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4H9PWcGFWTnQRRpR6qzftNQ0lP7jmcpJc1z5bvKXC0c=;
        b=K/CrJ1K/rt+VhFoPjs+ssilkV2TK0I5T2DiiowW+Jnx2VHIc8Xtk8BtSatJqhSH164
         HFRVHe5ere2HZLIGJybshgbOojXS2Qsg/1qMHO1HymqF6qsw+Z8Weo38w2QiVke3XKQ8
         8eqFOtRhjh2pLnh/Da/bepQvAKVJq42pMWYv/aRE3RKhrXuQfWEWcX/4oy9lnCKmZpxr
         btMJJ1UFxf8KzZRs9eD7nSN/dlMCmRf9cweZyohaeVN1uSc3RjJfwMxj9kfDvrXHIG/p
         1gPWzOJAXXVQO+Wtmq/fdPnRax5LVJ4TKYfjYrYybFWhANsAYzjySg7+/Ky0/WCxS0Ay
         W3JA==
X-Gm-Message-State: APjAAAXLt/d+CedRwcEDmRHJHP+iAtjjJ6qYJD06/XrpTsAf6f0ZCEsy
        hCvGIdOvCqn6C44GM7pMI/gLSpGvSlShwvxZqHA=
X-Google-Smtp-Source: APXvYqwes1gV2IDw+8Qi/1BZf+2RvRVqWZMirG+2WSzT6D2Sl6v9dobOMCg6A6UD4p/INQTsMrciAWtKuTDBsrcdsyU=
X-Received: by 2002:ac8:45d2:: with SMTP id e18mr6288417qto.241.1565646724122;
 Mon, 12 Aug 2019 14:52:04 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:40 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-7-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 07/16] arm: prefer __section from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Enrico Weigelt <info@metux.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
 arch/arm/include/asm/cache.h     | 2 +-
 arch/arm/include/asm/mach/arch.h | 4 ++--
 arch/arm/include/asm/setup.h     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/cache.h b/arch/arm/include/asm/cache.h
index 1d65ed3a2755..cc06079600e0 100644
--- a/arch/arm/include/asm/cache.h
+++ b/arch/arm/include/asm/cache.h
@@ -24,6 +24,6 @@
 #define ARCH_SLAB_MINALIGN 8
 #endif
 
-#define __read_mostly __attribute__((__section__(".data..read_mostly")))
+#define __read_mostly __section(.data..read_mostly)
 
 #endif
diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index e7df5a822cab..2986f6b4862d 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -81,7 +81,7 @@ extern const struct machine_desc __arch_info_begin[], __arch_info_end[];
 #define MACHINE_START(_type,_name)			\
 static const struct machine_desc __mach_desc_##_type	\
  __used							\
- __attribute__((__section__(".arch.info.init"))) = {	\
+ __section(.arch.info.init) = {	\
 	.nr		= MACH_TYPE_##_type,		\
 	.name		= _name,
 
@@ -91,7 +91,7 @@ static const struct machine_desc __mach_desc_##_type	\
 #define DT_MACHINE_START(_name, _namestr)		\
 static const struct machine_desc __mach_desc_##_name	\
  __used							\
- __attribute__((__section__(".arch.info.init"))) = {	\
+ __section(.arch.info.init) = {	\
 	.nr		= ~0,				\
 	.name		= _namestr,
 
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 67d20712cb48..00190f1f0574 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -14,7 +14,7 @@
 #include <uapi/asm/setup.h>
 
 
-#define __tag __used __attribute__((__section__(".taglist.init")))
+#define __tag __used __section(.taglist.init)
 #define __tagtable(tag, fn) \
 static const struct tagtable __tagtable_##fn __tag = { tag, fn }
 
-- 
2.23.0.rc1.153.gdeed80330f-goog

