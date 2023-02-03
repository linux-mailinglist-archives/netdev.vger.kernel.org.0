Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B7B68A1F6
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 19:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbjBCSZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 13:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjBCSZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 13:25:47 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0BD8C1E3;
        Fri,  3 Feb 2023 10:25:44 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso4524398wmq.5;
        Fri, 03 Feb 2023 10:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A9+L91q4Y7ms9E+KXhHDeHePJSJvCyWgjUqHcqtgEvs=;
        b=TIG8D9EIkXGrmfAC9RvBRv41fMrl9rMSgYEN+8axLYF87oPg3WmQZT/xnPJ7tu1FQB
         IYWGbd4K4Utgmx7w/g7aUuHdIv0G4+/48K4fnnfPus3GOPvyUPw/Ca6Tumhilo5dBJdR
         lYaHGFX9U0KGUiffRWLu8HTrV/0ZbY9woaH5oehnC1xYu+9aD+w9G5WJA15M18PmfE6o
         6aQIwALdGNNAMKUrSnikm6oW7iDZwhek9I0bvA3HJci032kjfAKBUmLsDte06Gf1jp10
         ybPJx2bdM8I1ATg3bx7CFR2qqvxyEJYdHkWdqjsgUaDEOgUTN+50vYfoHpsCT9NG19Xw
         waMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A9+L91q4Y7ms9E+KXhHDeHePJSJvCyWgjUqHcqtgEvs=;
        b=Gctxwgvkg01jhkddVb33p/HSUxPDC81TJuRlStVSsl8jB89ek0kKJxwpRn3kW2PtPu
         P+sFmIsMoHzS64yna++lyKfQ/LbEAWouEUp7zOAfUFi/iUdVCAFW75c+UkP41+Qmzxjs
         gMcvAeXiHZIa3ViIYR8YbTN5lOKwehoucKp5wdmu3VSfjMRDe246MEI/ZBnNJTC1UW7z
         WptRSWz1aJa2Hnz93+46yWuHXmwIu/fd/9zIE94vyUzvGp6ByvnX2BfJgLzajiMv3UbW
         9tD3Z/0gx4HpQiSTaVclPw6yap7YTPi4SXnZYchhFoCzJ/riX+bhRkX/Mzdyp5R67PMK
         9Z+Q==
X-Gm-Message-State: AO0yUKXlwLIN/2DRltQmASx4Jn5nZPQx1tPt0VlDzpZ9n3doBzBgLtc1
        6Tj8uFWXj6Xkw3Zzf+eRxxRWuA7TPVJQWA==
X-Google-Smtp-Source: AK7set/1B3a5jioQF02ucCwqP7mq6Es+J+y2qFYHUcrQrkzqr3ptxw7+sBMaLDVYwinrb74ZTc2SHA==
X-Received: by 2002:a05:600c:314e:b0:3d3:52bb:3984 with SMTP id h14-20020a05600c314e00b003d352bb3984mr10442696wmo.17.1675448742575;
        Fri, 03 Feb 2023 10:25:42 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id g42-20020a05600c4caa00b003de664d4c14sm3291428wmp.36.2023.02.03.10.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 10:25:42 -0800 (PST)
Date:   Fri, 3 Feb 2023 20:25:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, Ian Rogers <irogers@google.com>,
        x86@kernel.org, netdev@vger.kernel.org
Subject: Re: [tip: objtool/core] objtool: Fix HOSTCC flag usage
Message-ID: <20230203182540.7linqqtr3tlrbfe7@skbuf>
References: <20230126190606.40739-4-irogers@google.com>
 <167526879495.4906.2898311831401901292.tip-bot2@tip-bot2>
 <Y9qbGHDBFtGoqnKK@FVFF77S0Q05N>
 <20230201173637.cyu6yzudwsuzl2vj@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230201173637.cyu6yzudwsuzl2vj@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 09:36:37AM -0800, Josh Poimboeuf wrote:
> On Wed, Feb 01, 2023 at 05:02:16PM +0000, Mark Rutland wrote:
> > Hi,
> > 
> > I just spotted this breaks cross-compiling; details below.
> 
> Thanks, we'll fix it up with
> 
> diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
> index 29a8cd7449bf..83b100c1e7f6 100644
> --- a/tools/objtool/Makefile
> +++ b/tools/objtool/Makefile
> @@ -36,7 +36,7 @@ OBJTOOL_CFLAGS := -Werror $(WARNINGS) $(KBUILD_HOSTCFLAGS) -g $(INCLUDES) $(LIBE
>  OBJTOOL_LDFLAGS := $(LIBELF_LIBS) $(LIBSUBCMD) $(KBUILD_HOSTLDFLAGS)
>  
>  # Allow old libelf to be used:
> -elfshdr := $(shell echo '$(pound)include <libelf.h>' | $(CC) $(CFLAGS) -x c -E - | grep elf_getshdr)
> +elfshdr := $(shell echo '$(pound)include <libelf.h>' | $(HOSTCC) $(OBJTOOL_CFLAGS) -x c -E - | grep elf_getshdr)
>  OBJTOOL_CFLAGS += $(if $(elfshdr),,-DLIBELF_USE_DEPRECATED)
>  
>  # Always want host compilation.

Profiting off of the occasion to point out that cross-compiling with
CONFIG_DEBUG_INFO_BTF=y is also broken (it builds the resolve_btfids
tool):

I source this script when cross-compiling, which has worked up until now:

#!/bin/bash

export TOPDIR=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
export PATH="${TOPDIR}/bin:$PATH"
export ARCH="arm64"
export CROSS_COMPILE="aarch64-none-linux-gnu-"
export SYSROOT="${TOPDIR}/sysroot"
export CC="aarch64-none-linux-gnu-gcc"
export CXX="aarch64-none-linux-gnu-g++"
export LDFLAGS="-L${SYSROOT}/usr/lib -L${SYSROOT}/usr/local/lib"
export CFLAGS="-I${SYSROOT}/usr/include -I${SYSROOT}/usr/local/include"
export CFLAGS="${CFLAGS} -Wno-format-nonliteral"
export KBUILD_OUTPUT="output-arm64"


Before reverting this patch, the build fails like this:

$ make -j 8 Image.gz dtbs modules W=1 C=1
make[1]: Entering directory '/opt/net-next/output-arm64'
  SYNC    include/config/auto.conf.cmd
  GEN     Makefile
  GEN     Makefile
  DESCEND bpf/resolve_btfids
  CC      scripts/mod/empty.o
  CC      scripts/mod/devicetable-offsets.s
  CHECK   ../scripts/mod/empty.c
  INSTALL libsubcmd_headers
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/sumversion.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/main.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/rbtree.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/string.o
In file included from /opt/net-next/tools/include/linux/rbtree_augmented.h:19,
                 from ../../lib/rbtree.c:12:
/opt/net-next/tools/include/linux/rbtree.h: In function ‘rb_link_node’:
/opt/net-next/tools/include/linux/rbtree.h:70:42: error: ‘NULL’ undeclared (first use in this function)
   70 |         node->rb_left = node->rb_right = NULL;
      |                                          ^~~~
/opt/net-next/tools/include/linux/rbtree.h:21:1: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
   20 | #include <linux/kernel.h>
  +++ |+#include <stddef.h>
   21 | #include <linux/stddef.h>
/opt/net-next/tools/include/linux/rbtree.h:70:42: note: each undeclared identifier is reported only once for each function it appears in
   70 |         node->rb_left = node->rb_right = NULL;
      |                                          ^~~~
/opt/net-next/tools/include/linux/rbtree.h: At top level:
/opt/net-next/tools/include/linux/rbtree.h:131:43: error: unknown type name ‘bool’
  131 |                                           bool leftmost)
      |                                           ^~~~
/opt/net-next/tools/include/linux/rbtree.h:21:1: note: ‘bool’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
   20 | #include <linux/kernel.h>
  +++ |+#include <stdbool.h>
   21 | #include <linux/stddef.h>
/opt/net-next/tools/include/linux/rbtree.h:179:15: error: unknown type name ‘bool’
  179 |               bool (*less)(struct rb_node *, const struct rb_node *))
      |               ^~~~
/opt/net-next/tools/include/linux/rbtree.h:179:15: note: ‘bool’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
/opt/net-next/tools/include/linux/rbtree.h:207:8: error: unknown type name ‘bool’
  207 |        bool (*less)(struct rb_node *, const struct rb_node *))
      |        ^~~~
/opt/net-next/tools/include/linux/rbtree.h:207:8: note: ‘bool’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
/opt/net-next/tools/include/linux/rbtree.h: In function ‘rb_find_add’:
/opt/net-next/tools/include/linux/rbtree.h:238:34: error: ‘NULL’ undeclared (first use in this function)
  238 |         struct rb_node *parent = NULL;
      |                                  ^~~~
/opt/net-next/tools/include/linux/rbtree.h:238:34: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
/opt/net-next/tools/include/linux/rbtree.h: In function ‘rb_find’:
/opt/net-next/tools/include/linux/rbtree.h:283:16: error: ‘NULL’ undeclared (first use in this function)
  283 |         return NULL;
      |                ^~~~
/opt/net-next/tools/include/linux/rbtree.h:283:16: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
/opt/net-next/tools/include/linux/rbtree.h: In function ‘rb_find_first’:
/opt/net-next/tools/include/linux/rbtree.h:299:33: error: ‘NULL’ undeclared (first use in this function)
  299 |         struct rb_node *match = NULL;
      |                                 ^~~~
/opt/net-next/tools/include/linux/rbtree.h:299:33: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
/opt/net-next/tools/include/linux/rbtree.h: In function ‘rb_next_match’:
/opt/net-next/tools/include/linux/rbtree.h:330:24: error: ‘NULL’ undeclared (first use in this function)
  330 |                 node = NULL;
      |                        ^~~~
/opt/net-next/tools/include/linux/rbtree.h:330:24: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
In file included from ../../lib/rbtree.c:12:
/opt/net-next/tools/include/linux/rbtree_augmented.h: At top level:
/opt/net-next/tools/include/linux/rbtree_augmented.h:57:57: error: unknown type name ‘bool’
   57 |                            struct rb_root_cached *root, bool newleft,
      |                                                         ^~~~
/opt/net-next/tools/include/linux/rbtree_augmented.h:20:1: note: ‘bool’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
   19 | #include <linux/rbtree.h>
  +++ |+#include <stdbool.h>
   20 |
/opt/net-next/tools/include/linux/rbtree_augmented.h: In function ‘__rb_erase_augmented’:
/opt/net-next/tools/include/linux/rbtree_augmented.h:208:37: error: ‘NULL’ undeclared (first use in this function)
  208 |                         rebalance = NULL;
      |                                     ^~~~
/opt/net-next/tools/include/linux/rbtree_augmented.h:20:1: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
   19 | #include <linux/rbtree.h>
  +++ |+#include <stddef.h>
   20 |
../../lib/rbtree.c: In function ‘__rb_insert’:
../../lib/rbtree.c:90:16: error: ‘true’ undeclared (first use in this function)
   90 |         while (true) {
      |                ^~~~
../../lib/rbtree.c:14:1: note: ‘true’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
   13 | #include <linux/export.h>
  +++ |+#include <stdbool.h>
   14 |
../../lib/rbtree.c:100:51: error: ‘NULL’ undeclared (first use in this function)
  100 |                         rb_set_parent_color(node, NULL, RB_BLACK);
      |                                                   ^~~~
../../lib/rbtree.c:14:1: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
   13 | #include <linux/export.h>
  +++ |+#include <stddef.h>
   14 |
../../lib/rbtree.c: In function ‘____rb_erase_color’:
../../lib/rbtree.c:230:32: error: ‘NULL’ undeclared (first use in this function)
  230 |         struct rb_node *node = NULL, *sibling, *tmp1, *tmp2;
      |                                ^~~~
../../lib/rbtree.c:230:32: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
../../lib/rbtree.c:232:16: error: ‘true’ undeclared (first use in this function)
  232 |         while (true) {
      |                ^~~~
../../lib/rbtree.c:232:16: note: ‘true’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
../../lib/rbtree.c: In function ‘rb_first’:
../../lib/rbtree.c:468:24: error: ‘NULL’ undeclared (first use in this function)
  468 |                 return NULL;
      |                        ^~~~
../../lib/rbtree.c:468:24: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
../../lib/rbtree.c: In function ‘rb_last’:
../../lib/rbtree.c:480:24: error: ‘NULL’ undeclared (first use in this function)
  480 |                 return NULL;
      |                        ^~~~
../../lib/rbtree.c:480:24: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
../../lib/rbtree.c: In function ‘rb_next’:
../../lib/rbtree.c:491:24: error: ‘NULL’ undeclared (first use in this function)
  491 |                 return NULL;
      |                        ^~~~
../../lib/rbtree.c:491:24: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
../../lib/rbtree.c: In function ‘rb_prev’:
../../lib/rbtree.c:522:24: error: ‘NULL’ undeclared (first use in this function)
  522 |                 return NULL;
      |                        ^~~~
../../lib/rbtree.c:522:24: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
../../lib/rbtree.c: In function ‘rb_next_postorder’:
../../lib/rbtree.c:577:24: error: ‘NULL’ undeclared (first use in this function)
  577 |                 return NULL;
      |                        ^~~~
../../lib/rbtree.c:577:24: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
../../lib/rbtree.c: In function ‘rb_first_postorder’:
../../lib/rbtree.c:594:24: error: ‘NULL’ undeclared (first use in this function)
  594 |                 return NULL;
      |                        ^~~~
../../lib/rbtree.c:594:24: note: ‘NULL’ is defined in header ‘<stddef.h>’; did you forget to ‘#include <stddef.h>’?
../../lib/string.c:48:30: error: unknown type name ‘bool’
   48 | int strtobool(const char *s, bool *res)
      |                              ^~~~
../../lib/string.c:21:1: note: ‘bool’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
   20 | #include <linux/ctype.h>
  +++ |+#include <stdbool.h>
   21 | #include <linux/compiler.h>
../../lib/string.c:172:33: error: unknown type name ‘u8’
  172 | static void *check_bytes8(const u8 *start, u8 value, unsigned int bytes)
      |                                 ^~
../../lib/string.c:172:44: error: unknown type name ‘u8’
  172 | static void *check_bytes8(const u8 *start, u8 value, unsigned int bytes)
      |                                            ^~
../../lib/string.c: In function ‘memchr_inv’:
../../lib/string.c:194:9: error: unknown type name ‘u8’
  194 |         u8 value = c;
      |         ^~
../../lib/string.c:195:9: error: unknown type name ‘u64’
  195 |         u64 value64;
      |         ^~~
../../lib/string.c:199:24: warning: implicit declaration of function ‘check_bytes8’ [-Wimplicit-function-declaration]
  199 |                 return check_bytes8(start, value, bytes);
      |                        ^~~~~~~~~~~~
../../lib/string.c:199:24: warning: returning ‘int’ from a function with return type ‘void *’ makes pointer from integer without a cast [-Wint-conversion]
  199 |                 return check_bytes8(start, value, bytes);
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../../lib/string.c:204:28: warning: left shift count >= width of type [-Wshift-count-overflow]
  204 |         value64 |= value64 << 32;
      |                            ^~
../../lib/string.c:208:17: error: unknown type name ‘u8’
  208 |                 u8 *r;
      |                 ^~
../../lib/string.c:211:19: warning: assignment to ‘int *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
  211 |                 r = check_bytes8(start, value, prefix);
      |                   ^
../../lib/string.c:221:23: error: ‘u64’ undeclared (first use in this function)
  221 |                 if (*(u64 *)start != value64)
      |                       ^~~
../../lib/string.c:221:23: note: each undeclared identifier is reported only once for each function it appears in
../../lib/string.c:221:28: error: expected expression before ‘)’ token
  221 |                 if (*(u64 *)start != value64)
      |                            ^
../../lib/string.c:222:32: warning: returning ‘int’ from a function with return type ‘void *’ makes pointer from integer without a cast [-Wint-conversion]
  222 |                         return check_bytes8(start, value, 8);
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../../lib/string.c:227:16: warning: returning ‘int’ from a function with return type ‘void *’ makes pointer from integer without a cast [-Wint-conversion]
  227 |         return check_bytes8(start, value, bytes % 8);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
make[4]: *** [Build:9: /opt/net-next/output-arm64/tools/bpf/resolve_btfids/rbtree.o] Error 1
make[4]: *** Waiting for unfinished jobs....
make[4]: *** [Build:9: /opt/net-next/output-arm64/tools/bpf/resolve_btfids/string.o] Error 1
In file included from main.c:73:
/opt/net-next/tools/include/linux/rbtree.h:131:43: error: unknown type name ‘bool’
  131 |                                           bool leftmost)
      |                                           ^~~~
/opt/net-next/tools/include/linux/rbtree.h:21:1: note: ‘bool’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
   20 | #include <linux/kernel.h>
  +++ |+#include <stdbool.h>
   21 | #include <linux/stddef.h>
/opt/net-next/tools/include/linux/rbtree.h:179:15: error: unknown type name ‘bool’
  179 |               bool (*less)(struct rb_node *, const struct rb_node *))
      |               ^~~~
/opt/net-next/tools/include/linux/rbtree.h:179:15: note: ‘bool’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
/opt/net-next/tools/include/linux/rbtree.h:207:8: error: unknown type name ‘bool’
  207 |        bool (*less)(struct rb_node *, const struct rb_node *))
      |        ^~~~
/opt/net-next/tools/include/linux/rbtree.h:207:8: note: ‘bool’ is defined in header ‘<stdbool.h>’; did you forget to ‘#include <stdbool.h>’?
In file included from main.c:75:
/opt/net-next/tools/include/linux/err.h:35:35: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘ERR_PTR’
   35 | static inline void * __must_check ERR_PTR(long error_)
      |                                   ^~~~~~~
/opt/net-next/tools/include/linux/err.h:40:33: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘PTR_ERR’
   40 | static inline long __must_check PTR_ERR(__force const void *ptr)
      |                                 ^~~~~~~
/opt/net-next/tools/include/linux/err.h:45:15: error: unknown type name ‘bool’
   45 | static inline bool __must_check IS_ERR(__force const void *ptr)
      |               ^~~~
/opt/net-next/tools/include/linux/err.h:45:33: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘IS_ERR’
   45 | static inline bool __must_check IS_ERR(__force const void *ptr)
      |                                 ^~~~~~
/opt/net-next/tools/include/linux/err.h:50:15: error: unknown type name ‘bool’
   50 | static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
      |               ^~~~
/opt/net-next/tools/include/linux/err.h:50:33: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘IS_ERR_OR_NULL’
   50 | static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
      |                                 ^~~~~~~~~~~~~~
/opt/net-next/tools/include/linux/err.h:55:32: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘PTR_ERR_OR_ZERO’
   55 | static inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
      |                                ^~~~~~~~~~~~~~~
/opt/net-next/tools/include/linux/err.h:70:35: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘ERR_CAST’
   70 | static inline void * __must_check ERR_CAST(__force const void *ptr)
      |                                   ^~~~~~~~
In file included from main.c:76:
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/btf.h:208:35: warning: ‘enum btf_func_linkage’ declared inside parameter list will not be visible outside of this definition
 or declaration
  208 |                              enum btf_func_linkage linkage, int proto_type_id);
      |                                   ^~~~~~~~~~~~~~~~
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/btf.h: In function ‘btf_kflag’:
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/btf.h:332:16: warning: implicit declaration of function ‘BTF_INFO_KFLAG’; did you mean ‘BTF_INFO_KIND’? [-Wimplicit-function
-declaration]
  332 |         return BTF_INFO_KFLAG(t->info);
      |                ^~~~~~~~~~~~~~
      |                BTF_INFO_KIND
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/btf.h: In function ‘btf_member_bit_offset’:
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/btf.h:534:24: warning: implicit declaration of function ‘BTF_MEMBER_BIT_OFFSET’ [-Wimplicit-function-declaration]
  534 |         return kflag ? BTF_MEMBER_BIT_OFFSET(m->offset) : m->offset;
      |                        ^~~~~~~~~~~~~~~~~~~~~
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/btf.h: In function ‘btf_member_bitfield_size’:
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/btf.h:546:24: warning: implicit declaration of function ‘BTF_MEMBER_BITFIELD_SIZE’ [-Wimplicit-function-declaration]
  546 |         return kflag ? BTF_MEMBER_BITFIELD_SIZE(m->offset) : 0;
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from main.c:77:
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/libbpf.h: At top level:
/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/sysroot/usr/include/bpf/libbpf.h:70:54: warning: ‘enum bpf_link_type’ declared inside parameter list will not be visible outside of this definition
or declaration
   70 | LIBBPF_API const char *libbpf_bpf_link_type_str(enum bpf_link_type t);
      |                                                      ^~~~~~~~~~~~~
In file included from main.c:73:
main.c: In function ‘btf_id__find’:
/opt/net-next/tools/include/linux/rbtree.h:37:37: warning: implicit declaration of function ‘container_of’ [-Wimplicit-function-declaration]
   37 | #define rb_entry(ptr, type, member) container_of(ptr, type, member)
      |                                     ^~~~~~~~~~~~
main.c:174:22: note: in expansion of macro ‘rb_entry’
  174 |                 id = rb_entry(p, struct btf_id, rb_node);
      |                      ^~~~~~~~
main.c:174:34: error: expected expression before ‘struct’
  174 |                 id = rb_entry(p, struct btf_id, rb_node);
      |                                  ^~~~~~
/opt/net-next/tools/include/linux/rbtree.h:37:55: note: in definition of macro ‘rb_entry’
   37 | #define rb_entry(ptr, type, member) container_of(ptr, type, member)
      |                                                       ^~~~
main.c: In function ‘btf_id__add’:
main.c:196:39: error: expected expression before ‘struct’
  196 |                 id = rb_entry(parent, struct btf_id, rb_node);
      |                                       ^~~~~~
/opt/net-next/tools/include/linux/rbtree.h:37:55: note: in definition of macro ‘rb_entry’
   37 | #define rb_entry(ptr, type, member) container_of(ptr, type, member)
      |                                                       ^~~~
main.c: In function ‘__symbols_patch’:
main.c:632:37: error: expected expression before ‘struct’
  632 |                 id = rb_entry(next, struct btf_id, rb_node);
      |                                     ^~~~~~
/opt/net-next/tools/include/linux/rbtree.h:37:55: note: in definition of macro ‘rb_entry’
   37 | #define rb_entry(ptr, type, member) container_of(ptr, type, member)
      |                                                       ^~~~
main.c: In function ‘sets_patch’:
main.c:662:39: error: expected expression before ‘struct’
  662 |                 id   = rb_entry(next, struct btf_id, rb_node);
      |                                       ^~~~~~
/opt/net-next/tools/include/linux/rbtree.h:37:55: note: in definition of macro ‘rb_entry’
   37 | #define rb_entry(ptr, type, member) container_of(ptr, type, member)
      |                                                       ^~~~
In file included from main.c:78:
main.c: In function ‘main’:
/opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/include/subcmd/parse-options.h:118:32: warning: implicit declaration of function ‘BUILD_BUG_ON_ZERO’ [-Wimplicit-function-declaration]
  118 | #define check_vtype(v, type) ( BUILD_BUG_ON_ZERO(!__builtin_types_compatible_p(typeof(v), type)) + v )
      |                                ^~~~~~~~~~~~~~~~~
/opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/include/subcmd/parse-options.h:131:106: note: in expansion of macro ‘check_vtype’
  131 | #define OPT_INCR(s, l, v, h)        { .type = OPTION_INCR, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
      |                                                                                                          ^~~~~~~~~~~
main.c:736:17: note: in expansion of macro ‘OPT_INCR’
  736 |                 OPT_INCR('v', "verbose", &verbose,
      |                 ^~~~~~~~
make[4]: *** [/opt/net-next/tools/build/Makefile.build:97: /opt/net-next/output-arm64/tools/bpf/resolve_btfids/main.o] Error 1
make[3]: *** [Makefile:80: /opt/net-next/output-arm64/tools/bpf/resolve_btfids//resolve_btfids-in.o] Error 2
make[2]: *** [Makefile:76: bpf/resolve_btfids] Error 2
make[1]: *** [/opt/net-next/Makefile:1451: tools/bpf/resolve_btfids] Error 2
make[1]: *** Waiting for unfinished jobs....
  HOSTLD  scripts/mod/modpost
  CC      kernel/bounds.s
  CC      arch/arm64/kernel/asm-offsets.s
  CALL    ../scripts/checksyscalls.sh
make[1]: Leaving directory '/opt/net-next/output-arm64'
make: *** [Makefile:242: __sub-make] Error 2


After reverting:

make -j 8 Image.gz dtbs modules W=1 C=1
make[1]: Entering directory '/opt/net-next/output-arm64'
  GEN     Makefile
  DESCEND bpf/resolve_btfids
  CALL    ../scripts/checksyscalls.sh
  INSTALL libsubcmd_headers
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/exec-cmd.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/help.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/pager.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/parse-options.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/run-command.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/sigchain.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/subcmd-config.o
  LDS     arch/arm64/kernel/vdso/vdso.lds
  CC      arch/arm64/kernel/vdso/vgettimeofday.o
  AS      arch/arm64/kernel/vdso/note.o
  AS      arch/arm64/kernel/vdso/sigreturn.o
  CHECK   ../arch/arm64/kernel/vdso/vgettimeofday.c
../arch/arm64/kernel/vdso/vgettimeofday.c:9:5: warning: symbol '__kernel_clock_gettime' was not declared. Should it be static?
../arch/arm64/kernel/vdso/vgettimeofday.c:15:5: warning: symbol '__kernel_gettimeofday' was not declared. Should it be static?
../arch/arm64/kernel/vdso/vgettimeofday.c:21:5: warning: symbol '__kernel_clock_getres' was not declared. Should it be static?
  LD      arch/arm64/kernel/vdso/vdso.so.dbg
  VDSOSYM include/generated/vdso-offsets.h
  OBJCOPY arch/arm64/kernel/vdso/vdso.so
  LD      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/libsubcmd-in.o
  AR      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/libsubcmd/libsubcmd.a
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/main.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/rbtree.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/zalloc.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/string.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/ctype.o
  CC      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/str_error_r.o
  LD      /opt/net-next/output-arm64/tools/bpf/resolve_btfids/resolve_btfids-in.o
  LINK     resolve_btfids
  (...)

Sadly idk how to fix it. I put this print in tools/bpf/resolve_btfids/Makefile
if it helps:

$(error CC $(CC) HOSTCC $(HOSTCC) HOSTCFLAGS $(HOSTCFLAGS) KBUILD_HOSTCFLAGS $(KBUILD_HOSTLDFLAGS))

which outputs:

Makefile:24: *** CC aarch64-none-linux-gnu-gcc HOSTCC gcc HOSTCFLAGS  KBUILD_HOSTCFLAGS  .  Stop.
