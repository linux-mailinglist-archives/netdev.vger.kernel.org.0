Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F74586BE2
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 15:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiHANY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 09:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiHANYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 09:24:24 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEAD3206B;
        Mon,  1 Aug 2022 06:24:23 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id tk8so20324045ejc.7;
        Mon, 01 Aug 2022 06:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc;
        bh=wHG9uomB3z//oXuVAbnaYlvkAHPtRk7dQYikI60ETu8=;
        b=qefJ8SkBCTvGg27w9gR2wFCgxb8Kj3bUrxFDjrrmwHOnwRT2AUe4aK5aYECwMYJ7gD
         n48a1mXOJ0mMEivPkiHqCglmYXCgp3wN7ta2Zm6RSvj3ozp39L0v3gH+L3sGmrMYUUtd
         otpvuJQiGBIm3B9baXxd4pGPmYOTJ1FpphXqph+zVbVgKyaqqF+Yh1RvyUII0fWzJ9wg
         vUpm/CIo+3SvQhZF4NK8caIfA6A9XilUqgtK6xFjlzHaU1z7c2XW/mHbE3lgZzspQGW/
         C9jxUTtCDrqD5Jjd4x2XoFHCr+xPJ1u/uCMFpB34c4emwq5OwTbsapwRZO+Fevg2+dxE
         UqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc;
        bh=wHG9uomB3z//oXuVAbnaYlvkAHPtRk7dQYikI60ETu8=;
        b=bxqPyJaJ8zxDzpBh542glGu49/7oPXed2hFja6P3ERZTv3DlZWSRB6NWHzPMan+G+Y
         C6z5FJhlfL7wHXtF2wSh9VNjF0ngTMz02fsT/deAoA/EgUromJymjzrwjmaLWIFbJuFL
         zeQIYYDtAeNU6I4/OFM/cWBlepZnxt0duS05StcVxbcobRsgvpxpIj8/1w7Cg5vo9hJA
         WEOZtmuN9wPfq6ZkeIN1bKahWxHdSIEaTL0ZDubjKx6ETMeKMcWJPzI+GiFQBEyUnOVd
         b/yFKe0FmfhKHI3HloNj1ExDTZpHevAfjvXmUeZQuPgsQ/3pNaDYroCtleUt1HNjUYd0
         Qoig==
X-Gm-Message-State: AJIora9tehxye7J6RzYi7hyhH2SEpbvTvKqHP3P+dHuF7L8SxE/OCW8Z
        5eqdtdaVSpZqNbOts/zy+mU=
X-Google-Smtp-Source: AGRyM1vLY8fZMhXk9fdsAMEfR/Cz7pWsIKbhkbn9A4PyqreH0FtK86tf+Rd1XQAo+uywVArkeoMspA==
X-Received: by 2002:a17:907:160f:b0:72f:1442:ed54 with SMTP id hb15-20020a170907160f00b0072f1442ed54mr12119573ejc.339.1659360261725;
        Mon, 01 Aug 2022 06:24:21 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id lb17-20020a170907785100b0072ae174cdd4sm1870689ejc.111.2022.08.01.06.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 06:24:21 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 1 Aug 2022 15:24:18 +0200
To:     Jiri Olsa <olsajiri@gmail.com>,
        Stephane Eranian <eranian@google.com>
Cc:     =?utf-8?B?6LCt5qKT54WK?= <tanzixuan.me@gmail.com>,
        Zixuan Tan <tanzixuangg@gmail.com>, terrelln@fb.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] perf build: Suppress openssl v3 deprecation warnings in
 libcrypto feature test
Message-ID: <YufUAiLqKiuwdvcP@krava>
References: <20220625153439.513559-1-tanzixuan.me@gmail.com>
 <YrhxE4s0hLvbbibp@krava>
 <CABwm_eT_LE6VbLMgT31yqW=tc_obLP=6E0jnMqVn1sMdWrVVNw@mail.gmail.com>
 <Yrqcpr7ICzpsoGrc@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yrqcpr7ICzpsoGrc@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 08:16:06AM +0200, Jiri Olsa wrote:
> On Mon, Jun 27, 2022 at 11:08:34AM +0800, 谭梓煊 wrote:
> > On Sun, Jun 26, 2022 at 10:45 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > On Sat, Jun 25, 2022 at 11:34:38PM +0800, Zixuan Tan wrote:
> > > > With OpenSSL v3 installed, the libcrypto feature check fails as it use the
> > > > deprecated MD5_* API (and is compiled with -Werror). The error message is
> > > > as follows.
> > > >
> > > > $ make tools/perf
> > > > ```
> > > > Makefile.config:778: No libcrypto.h found, disables jitted code injection,
> > > > please install openssl-devel or libssl-dev
> > > >
> > > > Auto-detecting system features:
> > > > ...                         dwarf: [ on  ]
> > > > ...            dwarf_getlocations: [ on  ]
> > > > ...                         glibc: [ on  ]
> > > > ...                        libbfd: [ on  ]
> > > > ...                libbfd-buildid: [ on  ]
> > > > ...                        libcap: [ on  ]
> > > > ...                        libelf: [ on  ]
> > > > ...                       libnuma: [ on  ]
> > > > ...        numa_num_possible_cpus: [ on  ]
> > > > ...                       libperl: [ on  ]
> > > > ...                     libpython: [ on  ]
> > > > ...                     libcrypto: [ OFF ]
> > > > ...                     libunwind: [ on  ]
> > > > ...            libdw-dwarf-unwind: [ on  ]
> > > > ...                          zlib: [ on  ]
> > > > ...                          lzma: [ on  ]
> > > > ...                     get_cpuid: [ on  ]
> > > > ...                           bpf: [ on  ]
> > > > ...                        libaio: [ on  ]
> > > > ...                       libzstd: [ on  ]
> > > > ...        disassembler-four-args: [ on  ]
> > > > ```
> > > >
> > > > This is very confusing because the suggested library (on my Ubuntu 20.04
> > > > it is libssl-dev) is already installed. As the test only checks for the
> > > > presence of libcrypto, this commit suppresses the deprecation warning to
> > > > allow the test to pass.
> > > >
> > > > Signed-off-by: Zixuan Tan <tanzixuan.me@gmail.com>
> > > > ---
> > > >  tools/build/feature/test-libcrypto.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/tools/build/feature/test-libcrypto.c b/tools/build/feature/test-libcrypto.c
> > > > index a98174e0569c..31afff093d0b 100644
> > > > --- a/tools/build/feature/test-libcrypto.c
> > > > +++ b/tools/build/feature/test-libcrypto.c
> > > > @@ -2,6 +2,12 @@
> > > >  #include <openssl/sha.h>
> > > >  #include <openssl/md5.h>
> > > >
> > > > +/*
> > > > + * The MD5_* API have been deprecated since OpenSSL 3.0, which causes the
> > > > + * feature test to fail silently. This is a workaround.
> > > > + */
> > >
> > > then we use these deprecated MD5 calls in util/genelf.c if libcrypto is detected,
> > > so I wonder how come the rest of the compilation passed for you.. do you have
> > > CONFIG_JITDUMP disabled?
> > >
> > > thanks,
> > > jirka
> > >
> > No, CONFIG_JITDUMP is not disabled. I am using the default configuration.
> > 
> > Yes, you are right. The rest of the compilation should fail, but it doesn't.
> > I checked the verbose build commands. This seems to be the result of another
> > inconsistency.
> > 
> > If libcrypto is detected, the macro "HAVE_LIBCRYPTO_SUPPORT" will be
> > defined, but in perf/util/genelf.c, "HAVE_LIBCRYPTO" without the "_SUPPORT"
> > prefix is checked. This causes urandom always be used to create build id
> > rather than MD5 and SHA1, no matter what the detection result is.
> > 
> > In perf/Makefile.config, from line 776
> > ```
> > ifndef NO_LIBCRYPTO
> >   ifneq ($(feature-libcrypto), 1)
> >     msg := $(warning No libcrypto.h found, disables jitted code injection,
> >             please install openssl-devel or libssl-dev);
> >     NO_LIBCRYPTO := 1
> >   else                                  <-- if libcrypto feature detected
> >     CFLAGS += -DHAVE_LIBCRYPTO_SUPPORT  <-- define this
> >     EXTLIBS += -lcrypto
> >     $(call detected,CONFIG_CRYPTO)
> >   endif
> > endif
> > ```
> > 
> > In perf/util/genelf.c, from line 33
> > ```
> > #ifdef HAVE_LIBCRYPTO                <-- but check this, it's always false
> 
> nice :)
> 
> > 
> > #define BUILD_ID_MD5
> > #undef BUILD_ID_SHA /* does not seem to work well when linked with Java */
> > #undef BUILD_ID_URANDOM /* different uuid for each run */
> > 
> > #ifdef BUILD_ID_SHA
> > #include <openssl/sha.h>
> > #endif
> > 
> > #ifdef BUILD_ID_MD5
> > #include <openssl/md5.h>
> > #endif
> > #endif                               <-- this block will be skipped
> > ```
> > 
> > Maybe we should fix this, to really make use of libcrypto if it is available?
> 
> yea, I think that was the original idea, let's keep the variable with
> SUPPORT suffix and use the -Wdeprecated-declarations for genelf.c
> 
> full fix would be to detect the new API and use it when it's available but..
> given that the check was false at least since 2016, perhaps we could remove
> that code? ;-) Stephane?

ping

jirka
