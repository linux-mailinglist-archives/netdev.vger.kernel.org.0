Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C6A8A9E2
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfHLVwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:52:11 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:43643 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbfHLVwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:52:10 -0400
Received: by mail-yw1-f73.google.com with SMTP id b188so77903287ywb.10
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q0pM2ZOzYJiqEFARYUko9qZH/ZZGqfD1MaH3ngq3us8=;
        b=I5dGVSJwg+v5RyOEC5gi6oytJS0yW4Mmt+c5xThJQxWY5OwURmEGt6K8eSF+EP+4xu
         GWwPrzEgPlmom5u3yG+mZn+HMrBWpuoLnyRNOlMaBcSAQVMFjL1WwGTWu+h7UCq/edOu
         IPYgNr5h5jsFfbpOYcOPgU3hxgjjymdwaD1Os4IRGlzRO5zwXEbOr/J2EEIZ56I/YU9r
         66AwX7+wwFlPujGUTM80/eieOR0jQG+KnscBiHOUapeinqDEidNrRFDbQmV1qSYPXlBt
         x2wzJDK4lftnnSeYI2g4mn2UraIxEOp9NQ2HP3bcmiyvE5m6RB2vrwSKVpQ9zn9XKLzZ
         2IQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q0pM2ZOzYJiqEFARYUko9qZH/ZZGqfD1MaH3ngq3us8=;
        b=SyXFJW0Hd8fKiNCLfCObceWHbvUPOVw5zvUaHEY/Mgq++SRBt6shLb5hgNG4y/s0Ts
         6nklijcd2yh1eEo06j5cwbtEKuFtjGQA9Phq/eCe6RaNCC98QLk6JjMkDvvjKl/q67hv
         dMIsZS0Ts8WTQoaCsZGTOZt6kRYm4A+On/XUvw1Kdj7Fg4yVGWeM1sukMUh312v1+mMa
         JOnLau4F2IMz/Y0WkxqGQMXUVI/O3qdwIWd7qa5I20vqIdcnGIf3XZVNhenRWTY4R4bg
         LzZDISd5q0xt/k495GO5b+C+tl5R6Y/wio+OVXNEqsDiFIHn+oXTvtqqQQM829QYBm1S
         woPQ==
X-Gm-Message-State: APjAAAU9HHfiTdaxCmvJO7/z/zlvKgi67OHx7Ld1qbScftfccWqicpAu
        MnU+9c8EQcMdjaTeamD2+NuC7Xn7u6LE1UGJTDs=
X-Google-Smtp-Source: APXvYqxHC7+rS2qjpS3IPZOB5pIRQxGdfIUG5M/NEIEtRIJhLY8Opqpv36wf9jko8QIKzBKhKeboh5I3CYvreDjxFhQ=
X-Received: by 2002:a0d:d807:: with SMTP id a7mr4425576ywe.112.1565646729583;
 Mon, 12 Aug 2019 14:52:09 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:41 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-8-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 08/16] mips: prefer __section from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-mips@vger.kernel.org,
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
 arch/mips/include/asm/cache.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/cache.h b/arch/mips/include/asm/cache.h
index 8b14c2706aa5..af2d943580ee 100644
--- a/arch/mips/include/asm/cache.h
+++ b/arch/mips/include/asm/cache.h
@@ -14,6 +14,6 @@
 #define L1_CACHE_SHIFT		CONFIG_MIPS_L1_CACHE_SHIFT
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data..read_mostly")))
+#define __read_mostly __section(.data..read_mostly)
 
 #endif /* _ASM_CACHE_H */
-- 
2.23.0.rc1.153.gdeed80330f-goog

