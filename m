Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421725193AB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbiEDBvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245488AbiEDBvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:51:16 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6029D2ED4C
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:47:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so2750410pjb.1
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=911JnfKaG9oxLMZbIRJVKqmgZoLrOSfR0+bBHDgrI5Q=;
        b=XpaB8pfu8eVojSjAsTEUujhhPhU3ucUSWYxDz/8sQ6z59UWvf3i1yrd7kb6SWG2Tnt
         HAfw08l7QKrj5Y9xBESf9NlJZEn9vrEgx5ueLfnIKaMH/WYs9aAiD55J+sDOumyzi4NC
         ygqjXeva6u5ldSCOC93c/m2TPIGafNG0RRrsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=911JnfKaG9oxLMZbIRJVKqmgZoLrOSfR0+bBHDgrI5Q=;
        b=rL9x1Mba2EW0qyfsCGhKyskV9raH2ulTGm/H2VvX+LrTmDEXnSVkYspmkRSA4huZbz
         FuuqRF2FRepi8iOaylj/xITINej0Q+t+UylZaJnkoTmaCfzwT/KoBNQ/LqIyJjipFoCF
         GFAv28cJGGaPLhB9Hptdbqs7uKktjRX6So18MEz4m+o6LEajl0OmB4bSBckKBbIC3f1y
         wqFihC3xgBSaPxNt2DiLh7MpGhtDFwkvV6M7HTjBkl7hOT96tT+hggO3YVdaq7cM48qP
         EGKEfYvjeqT1QvCvQOEf+VSZiwr1EBMvuTvdxX/RF2WWFvuBMjLagLpoG0E6+LAQFf7L
         f3JQ==
X-Gm-Message-State: AOAM533VpSZzTOFrvQ42d69ym1tdcdsGai2NobDV4fG0+0Xym0lUtPYj
        NUwowkXm9d79ojjiFmrNMF2N9g==
X-Google-Smtp-Source: ABdhPJxrHNegJmGAxW56M+/xNDI5Rp9q10uc3LuqY84v7Q4/SyroP5sNMa7kEu3GhSOoTkFJMy4yVA==
X-Received: by 2002:a17:902:d4ce:b0:15e:90f8:216c with SMTP id o14-20020a170902d4ce00b0015e90f8216cmr17719945plg.65.1651628856716;
        Tue, 03 May 2022 18:47:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902860600b0015e8d4eb2b8sm6950573plo.258.2022.05.03.18.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:35 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-hardening@vger.kernel.org,
        llvm@lists.linux.dev, Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 04/32] fortify: Add run-time WARN for cross-field memcpy()
Date:   Tue,  3 May 2022 18:44:13 -0700
Message-Id: <20220504014440.3697851-5-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7485; h=from:subject; bh=tR948KPQeb2PYDrDjEae6GxtJ84K9V5KxBtP7gPRR/0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqBJdrO+OL3bCOY6akLjwosSFqhKtDoTb/Zh8Fy uzSMohWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagQAKCRCJcvTf3G3AJu6nD/ 4nHJdgb4XE8OHMjojOaPl9nULa44o03t//4waAm5Xj50QbDOyrBIKqeaRsc5tWg7tp/Z6v0nmG1RJ6 XSHy4AfPcewPHlkIjBTKQ1jbxZcS7qaEExIyWtMJtQ7GtiOD1AWiQbAW4KJ769iV/0me51Vamo+8Ip veorWN0jTQ+xDJ7fyb9mbxXsI7lvSOQUBdZzwAzPgJazmEXjwO8ozXnn0AaGKNv31py+LgyPwV3P64 KAQ04Gxp/rMnWduFhSm2pHXhcI6M++J1CvvtB/IPwWfRbr9CNUU4Jk3s04sG/XIIP/XCeyAn9u7lla 0QyhfHAuqHdIkCdiPXrp7mi2GKNlqOsemPZjnRNTm7F8RVQ7axjkLgPu/OdKyoIjcu4+Gxe1+1ddUe aX6mQB2mGmzNYtycr4ZILXoVPXUX2aUg4K+tE9BlmcAPTi2DTbr35TkFDaDVuBx1qu3sfaOS7h4cb8 ktu5OJHSekWrtF+UVSH3EdBatG6D2HeS6wxcx6SHUNtMwugLr34tjLkliqOflvnPJpRccxYFyzl9dZ qy69k3TaXevsfsMBn7XO5PIzGI74pL+vRzFTRl1RwbUS4WyKiQh9d4h/hZVD2tYMHxvgBj3q9keCdw H22GUCBSF28gbojQv8oqLHwc2cPU6T+4DFzfvbOlpZYHDcM7+2IPrnwnqyXQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable run-time checking of dynamic memcpy() and memmove() lengths,
issuing a WARN when a write would exceed the size of the target struct
member, when built with CONFIG_FORTIFY_SOURCE=y. This would have caught
all of the memcpy()-based buffer overflows from 2018 through 2020,
specifically covering all the cases where the destination buffer size
is known at compile time.

This change ONLY adds a run-time warning. As false positives are currently
still expected, this will not block the overflow. The new warnings will
look like this:

  memcpy: detected field-spanning write (size N) of single field "var->dest" (size M)
  WARNING: CPU: n PID: pppp at source/file/path.c:nr function+0xXX/0xXX [module]

The false positives are most likely where intentional field-spanning
writes are happening. These need to be addressed similarly to how the
compile-time cases were addressed: add a struct_group(), split the
memcpy(), use a flex_array.h helper, or some other refactoring.

In order to make identifying/investigating instances of added runtime
checks easier, each instance includes the destination variable name as a
WARN argument, prefixed with 'field "'. Therefore, on any given build,
it is trivial to inspect the artifacts to find instances. For example
on an x86_64 defconfig build, there are 78 new run-time memcpy() bounds
checks added:

  $ for i in vmlinux $(find . -name '*.ko'); do \
      strings "$i" | grep '^field "'; done | wc -l
  78

Currently, the common case where a destination buffer is known to be a
dynamic size (i.e. has a trailing flexible array) does not generate a
WARN. For example:

    struct normal_flex_array {
	void *a;
	int b;
	size_t array_size;
	u32 c;
	u8 flex_array[];
    };

    struct normal_flex_array *instance;
    ...
    /* These cases will be ignored for run-time bounds checking. */
    memcpy(instance, src, len);
    memcpy(instance->flex_array, src, len);

This code pattern will need to be addressed separately, likely by
migrating to one of the flex_array.h family of helpers.

Note that one of the dynamic-sized destination cases is irritatingly
unable to be detected by the compiler: when using memcpy() to target
a composite struct member which contains a trailing flexible array
struct. For example:

    struct wrapper {
	int foo;
	char bar;
	struct normal_flex_array embedded;
    };

    struct wrapper *instance;
    ...
    /* This will incorrectly WARN when len > sizeof(instance->embedded) */
    memcpy(&instance->embedded, src, len);

These cases end up appearing to the compiler to be sized as if the
flexible array had 0 elements. :( For more details see:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101832
https://godbolt.org/z/vW6x8vh4P

Regardless, all cases of copying to/from flexible array structures
should be migrated to using the new flex*()-family of helpers to gain
their added safety checking, but priority will need to be given to the
"composite flexible array structure destination" cases noted above.

As mentioned, none of these bounds checks block any overflows
currently. For users that have tested their workloads, do not encounter
any warnings, and wish to make these checks stop any overflows, they
can use a big hammer and set the sysctl panic_on_warn=1.

Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: linux-hardening@vger.kernel.org
Cc: llvm@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/fortify-string.h | 70 ++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 295637a66c46..9f65527fff40 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -3,6 +3,7 @@
 #define _LINUX_FORTIFY_STRING_H_
 
 #include <linux/const.h>
+#include <linux/bug.h>
 
 #define __FORTIFY_INLINE extern __always_inline __gnu_inline __overloadable
 #define __RENAME(x) __asm__(#x)
@@ -303,7 +304,7 @@ __FORTIFY_INLINE void fortify_memset_chk(__kernel_size_t size,
  * V = vulnerable to run-time overflow (will need refactoring to solve)
  *
  */
-__FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
+__FORTIFY_INLINE bool fortify_memcpy_chk(__kernel_size_t size,
 					 const size_t p_size,
 					 const size_t q_size,
 					 const size_t p_size_field,
@@ -352,16 +353,79 @@ __FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
 	if ((p_size != (size_t)(-1) && p_size < size) ||
 	    (q_size != (size_t)(-1) && q_size < size))
 		fortify_panic(func);
+
+	/*
+	 * Warn when writing beyond destination field size.
+	 *
+	 * We must ignore p_size_field == 0 and -1 for existing
+	 * 0-element and flexible arrays, until they are all converted
+	 * to flexible arrays and use the flex()-family of helpers.
+	 *
+	 * The implementation of __builtin_object_size() behaves
+	 * like sizeof() when not directly referencing a flexible
+	 * array member, which means there will be many bounds checks
+	 * that will appear at run-time, without a way for them to be
+	 * detected at compile-time (as can be done when the destination
+	 * is specifically the flexible array member).
+	 * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101832
+	 */
+	if (p_size_field != 0 && p_size_field != (size_t)(-1) &&
+	    p_size != p_size_field && p_size_field < size)
+		return true;
+
+	return false;
 }
 
 #define __fortify_memcpy_chk(p, q, size, p_size, q_size,		\
 			     p_size_field, q_size_field, op) ({		\
 	size_t __fortify_size = (size_t)(size);				\
-	fortify_memcpy_chk(__fortify_size, p_size, q_size,		\
-			   p_size_field, q_size_field, #op);		\
+	WARN_ONCE(fortify_memcpy_chk(__fortify_size, p_size, q_size,	\
+				     p_size_field, q_size_field, #op),	\
+		  #op ": detected field-spanning write (size %zu) of single %s (size %zu)\n", \
+		  __fortify_size,					\
+		  "field \"" #p "\" at " __FILE__ ":" __stringify(__LINE__), \
+		  p_size_field);					\
 	__underlying_##op(p, q, __fortify_size);			\
 })
 
+/*
+ * Notes about compile-time buffer size detection:
+ *
+ * With these types...
+ *
+ *	struct middle {
+ *		u16 a;
+ *		u8 middle_buf[16];
+ *		int b;
+ *	};
+ *	struct end {
+ *		u16 a;
+ *		u8 end_buf[16];
+ *	};
+ *	struct flex {
+ *		int a;
+ *		u8 flex_buf[];
+ *	};
+ *
+ *	void func(TYPE *ptr) { ... }
+ *
+ * Cases where destination size cannot be currently detected:
+ * - the size of ptr's object (seemingly by design, gcc & clang fail):
+ *	__builtin_object_size(ptr, 1) == -1
+ * - the size of flexible arrays in ptr's obj (by design, dynamic size):
+ *      __builtin_object_size(ptr->flex_buf, 1) == -1
+ * - the size of ANY array at the end of ptr's obj (gcc and clang bug):
+ *	__builtin_object_size(ptr->end_buf, 1) == -1
+ *	https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101836
+ *
+ * Cases where destination size is currently detected:
+ * - the size of non-array members within ptr's object:
+ *	__builtin_object_size(ptr->a, 1) == 2
+ * - the size of non-flexible-array in the middle of ptr's obj:
+ *	__builtin_object_size(ptr->middle_buf, 1) == 16
+ *
+ */
+
 /*
  * __builtin_object_size() must be captured here to avoid evaluating argument
  * side-effects further into the macro layers.
-- 
2.32.0

