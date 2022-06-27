Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C236E55B5B1
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 05:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiF0DJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 23:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiF0DJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 23:09:06 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A2E21BC;
        Sun, 26 Jun 2022 20:09:04 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r9so4090342ljp.9;
        Sun, 26 Jun 2022 20:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WvIC9OvUBfBvTPqKiHij6MJ+gTuN01q56rsASlI6Vw4=;
        b=N4ePTGRVI2MbUavCF5Mr07vChNUUP9Ug6sycoWzNN846VPxMvy5OUFetl+mfFFEK90
         COjDBwnM80/IFCJnc84ahmtOVMyAP59zt0By/C18yiI0oluLQXf37J2RiKH0QrxX01wG
         J3V0UuPH5L4Q899OFl7oG2rIZjWSikE0eQP6eAO1twUtVP+BzTcfLyqpWShqTbfx3mhW
         ziARONAC+fQejRJivwMB6G9lVLaKaTJe8osTQTwjMak/GhbBaycisUUIQWNim38/Ib2c
         Xmo2rWzbuec5Vd6QsdUYjJ9Z6jg6QyPOS1g+SDBVKliDmBoSjAKM1KUyScQy1eSx+LDq
         kMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WvIC9OvUBfBvTPqKiHij6MJ+gTuN01q56rsASlI6Vw4=;
        b=HSEN/4fZjAluM6dqLIQ7Uk0NauDWEbicgTkpmWOWCSUdFKXrwBZm9+cIk16BReTRgx
         1aQCymHZ6VrcJ4sDqiZ6yQnEIMiekv1TZc4Lbvyg/YBc9PLp0HsyRCGLvbIj/SyLmKi7
         f4zOwWyUL9eMN67y0S3TYa6MmLpOvHsexPaauqeF8l+xWTUnh/EGYRJAgwa4PJFLUSFt
         v1xL6BaoFhw8UZDEoe6WzM17LJ8w7Epn17Rv8nso/kiJI09kMpQR7HvlgpyVF3uc7ii8
         nHXqiwWlur56NDRtLcE3PX/Il1ZEeXiElU9ALuxXFZmoBfRFRb9Xj2jozRkjsJEE3hpr
         wpZQ==
X-Gm-Message-State: AJIora/TaKVCEiPihGT8c2SC7lgPjwm2H3ynO+vj+XrKeL/7yGVkSPC1
        0BRV7Dp2H7hXwBWb6ExP9JPOnr0Nl/OjkZKK+tU=
X-Google-Smtp-Source: AGRyM1se/Xl2csUNLIaa15GXvPosumiIesoPofcb9H+G41ZaW5mACO49PGUcBi0NrOheV0NXPgqFw3EU9HzrHS4cG/A=
X-Received: by 2002:a2e:b4b4:0:b0:25b:b56e:9c9d with SMTP id
 q20-20020a2eb4b4000000b0025bb56e9c9dmr4000703ljm.168.1656299342700; Sun, 26
 Jun 2022 20:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220625153439.513559-1-tanzixuan.me@gmail.com> <YrhxE4s0hLvbbibp@krava>
In-Reply-To: <YrhxE4s0hLvbbibp@krava>
From:   =?UTF-8?B?6LCt5qKT54WK?= <tanzixuan.me@gmail.com>
Date:   Mon, 27 Jun 2022 11:08:34 +0800
Message-ID: <CABwm_eT_LE6VbLMgT31yqW=tc_obLP=6E0jnMqVn1sMdWrVVNw@mail.gmail.com>
Subject: Re: [PATCH] perf build: Suppress openssl v3 deprecation warnings in
 libcrypto feature test
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Zixuan Tan <tanzixuangg@gmail.com>, terrelln@fb.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 26, 2022 at 10:45 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Sat, Jun 25, 2022 at 11:34:38PM +0800, Zixuan Tan wrote:
> > With OpenSSL v3 installed, the libcrypto feature check fails as it use the
> > deprecated MD5_* API (and is compiled with -Werror). The error message is
> > as follows.
> >
> > $ make tools/perf
> > ```
> > Makefile.config:778: No libcrypto.h found, disables jitted code injection,
> > please install openssl-devel or libssl-dev
> >
> > Auto-detecting system features:
> > ...                         dwarf: [ on  ]
> > ...            dwarf_getlocations: [ on  ]
> > ...                         glibc: [ on  ]
> > ...                        libbfd: [ on  ]
> > ...                libbfd-buildid: [ on  ]
> > ...                        libcap: [ on  ]
> > ...                        libelf: [ on  ]
> > ...                       libnuma: [ on  ]
> > ...        numa_num_possible_cpus: [ on  ]
> > ...                       libperl: [ on  ]
> > ...                     libpython: [ on  ]
> > ...                     libcrypto: [ OFF ]
> > ...                     libunwind: [ on  ]
> > ...            libdw-dwarf-unwind: [ on  ]
> > ...                          zlib: [ on  ]
> > ...                          lzma: [ on  ]
> > ...                     get_cpuid: [ on  ]
> > ...                           bpf: [ on  ]
> > ...                        libaio: [ on  ]
> > ...                       libzstd: [ on  ]
> > ...        disassembler-four-args: [ on  ]
> > ```
> >
> > This is very confusing because the suggested library (on my Ubuntu 20.04
> > it is libssl-dev) is already installed. As the test only checks for the
> > presence of libcrypto, this commit suppresses the deprecation warning to
> > allow the test to pass.
> >
> > Signed-off-by: Zixuan Tan <tanzixuan.me@gmail.com>
> > ---
> >  tools/build/feature/test-libcrypto.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/tools/build/feature/test-libcrypto.c b/tools/build/feature/test-libcrypto.c
> > index a98174e0569c..31afff093d0b 100644
> > --- a/tools/build/feature/test-libcrypto.c
> > +++ b/tools/build/feature/test-libcrypto.c
> > @@ -2,6 +2,12 @@
> >  #include <openssl/sha.h>
> >  #include <openssl/md5.h>
> >
> > +/*
> > + * The MD5_* API have been deprecated since OpenSSL 3.0, which causes the
> > + * feature test to fail silently. This is a workaround.
> > + */
>
> then we use these deprecated MD5 calls in util/genelf.c if libcrypto is detected,
> so I wonder how come the rest of the compilation passed for you.. do you have
> CONFIG_JITDUMP disabled?
>
> thanks,
> jirka
>
No, CONFIG_JITDUMP is not disabled. I am using the default configuration.

Yes, you are right. The rest of the compilation should fail, but it doesn't.
I checked the verbose build commands. This seems to be the result of another
inconsistency.

If libcrypto is detected, the macro "HAVE_LIBCRYPTO_SUPPORT" will be
defined, but in perf/util/genelf.c, "HAVE_LIBCRYPTO" without the "_SUPPORT"
prefix is checked. This causes urandom always be used to create build id
rather than MD5 and SHA1, no matter what the detection result is.

In perf/Makefile.config, from line 776
```
ifndef NO_LIBCRYPTO
  ifneq ($(feature-libcrypto), 1)
    msg := $(warning No libcrypto.h found, disables jitted code injection,
            please install openssl-devel or libssl-dev);
    NO_LIBCRYPTO := 1
  else                                  <-- if libcrypto feature detected
    CFLAGS += -DHAVE_LIBCRYPTO_SUPPORT  <-- define this
    EXTLIBS += -lcrypto
    $(call detected,CONFIG_CRYPTO)
  endif
endif
```

In perf/util/genelf.c, from line 33
```
#ifdef HAVE_LIBCRYPTO                <-- but check this, it's always false

#define BUILD_ID_MD5
#undef BUILD_ID_SHA /* does not seem to work well when linked with Java */
#undef BUILD_ID_URANDOM /* different uuid for each run */

#ifdef BUILD_ID_SHA
#include <openssl/sha.h>
#endif

#ifdef BUILD_ID_MD5
#include <openssl/md5.h>
#endif
#endif                               <-- this block will be skipped
```

Maybe we should fix this, to really make use of libcrypto if it is available?

Links:
 This commit include the genelf.c:
  https://lore.kernel.org/all/1448874143-7269-3-git-send-email-eranian@google.com/T/#mb6d3e18bee4901b71a4d4ef4f406feaaf48346d9
 This commit include the feature test:
  https://lore.kernel.org/all/1448874143-7269-3-git-send-email-eranian@google.com/T/#m12a2ababf8ad3e366d56d9efab870592e6ff60a5

Thanks,
Zixuan

> > +#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> > +
> >  int main(void)
> >  {
> >       MD5_CTX context;
> > --
> > 2.34.1
> >
