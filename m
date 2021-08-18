Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1493EFB66
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhHRGMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240270AbhHRGKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:10:12 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA6EC0698C6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:03 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g14so1064399pfm.1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yj6MSRHjUgDQQeVVOJJG7wsN0XYzp0WPRrxqPpzxE8c=;
        b=CzXk1xRppwdRJolegZtv49GA2NFQ14/wBYjHzPVUV6FFSCAV81rN+Zkew6HAM1134z
         9VMz6EAZM3OEiyOfJEz/43Jc+GeEg/kZ/l9C0CVoA8ABd/sj4sEJwPwqNtbgpylRBB0X
         jSjlWs/gCENWo/7C7d9KpfTsqLvHYTfxkxT94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yj6MSRHjUgDQQeVVOJJG7wsN0XYzp0WPRrxqPpzxE8c=;
        b=OqaEmU82Uau/2MZRIqoJtGVDlse2OqcTW1C4oNOazwnrpnkJKm8xyQ/v9moWIMmMHp
         82G/von8EzJTNQigBeSbT/Qm9A1Rh40j1bWWRNQsVBHcnoRLaOHyCaERKZFX0M/gNEog
         NqB0gp7aqQAdGTL1MA3iO5xienEopOLR0ZuTTophzlPEc4IYBObSReXvx8kJVjdquHn5
         rpV2gnl8UhySmEh0y/bJXL1ikijgk8qB6gBv4NS4gkAsZazI0lNXrVsJvFfH0Ju9Ic+x
         Ku/wc3unaZazWUNftJDopkQaLwtWWgE0SwAx/JEg1SI+xR7eTMg75urfcb1RZGdA0DuW
         FqGw==
X-Gm-Message-State: AOAM531mNBnhrZgUgTUowiuEVeqZMZATzpNDJbt6TO0MrcW09jJuppPk
        LdOxhU1hf7zTScKmE370LpNPIw==
X-Google-Smtp-Source: ABdhPJxiDT7B9pY6vGyClkQcsM0XG6Kg+GcLSvpUD3c8DNni73mb9LN7FVhCwNs3jsvIZgdTk/kz/A==
X-Received: by 2002:aa7:850c:0:b0:3e2:edf3:3d09 with SMTP id v12-20020aa7850c000000b003e2edf33d09mr806951pfn.42.1629266763221;
        Tue, 17 Aug 2021 23:06:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id mr18sm3750578pjb.39.2021.08.17.23.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:06:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Daniel Axtens <dja@axtens.net>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 37/63] string.h: Introduce memset_after() for wiping trailing members/padding
Date:   Tue, 17 Aug 2021 23:05:07 -0700
Message-Id: <20210818060533.3569517-38-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4092; h=from:subject; bh=ynt+tRmRAcx7nox2wqu1NNTkTOzsqx2+YTbDvMLTbxE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMmwbMjodaindknTsBVe7537WHFelKIadd+u5e3 SxHIQdeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjJgAKCRCJcvTf3G3AJnBLEA CdNu7o5W+92HzRi1fko57n/mLwv/f7ERDN9lR9c1k1ZpJRD294w1BBHne+86h1ErieaOKABkA1tR9Z RPuVXQx84Ll35fJ448mje10Vlj4xMIsIO7I2+pCjPpZeZUknIkUAfgL4BIt11O1QZKIXt5gv0ApWLk F0vG/OdP1EsH7UfN0sGFW3dUPcQnV365DGpsYsXEbfYPUtv7V0sIo4u2EqY+DWjZNXgimvh1QDuwFD ASW7FG+u7LV5vdhie6SOhQtFr9ccWj/RPLaI95ILtuhSn99zvuAmxmiV9Sq50joZ8BHWNBKRMezCGO 3/YVBD1ioQyCyuoiDxeL9UMcrdPSZQt6aLznsfSXoKOqLO+Ir7tMR4XrhkEg8MfM+mA6JudX+GjyI5 HhSyIFjb1vJpco5l2tSPxCz4ioyocE52DQfc0wA9/yfi2liO4gbBZCqBmTCsIZpwdwhQkDkVBK5ZvR HOtc2ADG105U1yBtwAKKBM1Kpn6jPowZCs5D1qDOHYz1gAWljX17P6SuxaG3G/dMeo5MT0LpM97ZfJ VauEeeQUKsZsz2LSYtk7JsMuq3dNZ28R5tJc/mwglhdLai09Fi/99TDZ2wV4u2YvpwKr9UaxVWIuT5 e3kxAxaDFTyXoo70DNH9x1G7c+SuCaUbgMUIaDh6BALQ3dZqhLv+3W2zODmg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A common idiom in kernel code is to wipe the contents of a structure
after a given member. This is especially useful in places where there is
trailing padding. These open-coded cases are usually difficult to read
and very sensitive to struct layout changes. Introduce a new helper,
memset_after() that takes the target struct instance, the byte to write,
and the member name after which the zeroing should start.

Additionally adds memset_startat() for wiping trailing members _starting_
at a specific member instead of after a member, which is more readable
in certain circumstances, but doesn't include any preceding padding.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Francis Laniel <laniel_francis@privacyrequired.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/string.h | 29 +++++++++++++++++++++++++++++
 lib/test_memcpy.c      | 24 ++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index cbe889e404e2..fe56a1774207 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -272,6 +272,35 @@ static __always_inline void memcpy_and_pad(void *dest, size_t dest_len,
 		memcpy(dest, src, dest_len);
 }
 
+/**
+ * memset_after - Set a value after a struct member to the end of a struct
+ *
+ * @obj: Address of target struct instance
+ * @v: Byte value to repeatedly write
+ * @member: after which struct member to start writing bytes
+ *
+ * This is good for clearing padding following the given member.
+ */
+#define memset_after(obj, v, member) do {				\
+	memset((u8 *)(obj) + offsetofend(typeof(*(obj)), member), v,	\
+	       sizeof(*(obj)) - offsetofend(typeof(*(obj)), member));	\
+} while (0)
+
+/**
+ * memset_startat - Set a value starting at a member to the end of a struct
+ *
+ * @obj: Address of target struct instance
+ * @v: Byte value to repeatedly write
+ * @member: struct member to start writing at
+ *
+ * Note that if there is padding between the prior member and the target
+ * member, memset_after() should be used to clear the prior padding.
+ */
+#define memset_startat(obj, v, member) do {				\
+	memset((u8 *)(obj) + offsetof(typeof(*(obj)), member), v,	\
+	       sizeof(*(obj)) - offsetof(typeof(*(obj)), member));	\
+} while (0)
+
 /**
  * str_has_prefix - Test if a string has a given prefix
  * @str: The string to test
diff --git a/lib/test_memcpy.c b/lib/test_memcpy.c
index be192b8e82b7..50bc99552a17 100644
--- a/lib/test_memcpy.c
+++ b/lib/test_memcpy.c
@@ -215,6 +215,20 @@ static void memset_test(struct kunit *test)
 			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
 			},
 	};
+	struct some_bytes after = {
+		.data = { 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x72,
+			  0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,
+			  0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,
+			  0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,
+			},
+	};
+	struct some_bytes startat = {
+		.data = { 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79,
+			  0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79,
+			  0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79,
+			},
+	};
 	struct some_bytes dest = { };
 	int count, value;
 	u8 *ptr;
@@ -245,6 +259,16 @@ static void memset_test(struct kunit *test)
 	ptr += 8;
 	memset(ptr++, value++, count++);
 	compare("argument side-effects", dest, three);
+
+	/* Verify memset_after() */
+	dest = control;
+	memset_after(&dest, 0x72, three);
+	compare("memset_after()", dest, after);
+
+	/* Verify memset_startat() */
+	dest = control;
+	memset_startat(&dest, 0x79, four);
+	compare("memset_startat()", dest, startat);
 #undef TEST_OP
 }
 
-- 
2.30.2

