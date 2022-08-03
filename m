Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C6B5887FF
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 09:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiHCHcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 03:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbiHCHcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 03:32:53 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488241E3D6;
        Wed,  3 Aug 2022 00:32:52 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m8so20331887edd.9;
        Wed, 03 Aug 2022 00:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc;
        bh=b7xFxPpTc9t+6GAirB/ZpAqypHutZv7FafDpzu9bEwk=;
        b=YRP0lkjofXKPjlTcgBErcfXR3LO16U3Pljon8ji+RlMBZBK2e0GrH3Dr7am85bNw1U
         Ul1EvLGyHUXukriFFDa2soNf2a0sdbukicLCEdCHJVdeu+jGHmSyzu/yowUIW1tOkRrb
         fk3FnyiPKGqzb6dUUg8tnY4osAfNY84sJtimjKOgCgV7wwLo0CHDFpqKOa69DzD+vWJE
         WhabznjFM+HaRjJhPIh3Oo6lP8NhATpI1V+EVfQX/9gaSmlpz8cI15OU2avS6IXsp7eX
         kFiYgGqd3MDrUMws/SU9Ti2gEkjMc20mNyIUOl4zfNY4Uhi/NG7gdo28IT+YHmRHlqow
         66Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc;
        bh=b7xFxPpTc9t+6GAirB/ZpAqypHutZv7FafDpzu9bEwk=;
        b=4Sj7trMJ/dvLALcgPtonPpSqVkSDiiaEaIGl38Rhi5eeufnukQBM3zeZ5qJ6RHsNtv
         YhWEBXCWGky/vp81j9jiHaguZTjHopwLwMkChbyRKYA8bLEi3ZeEGiBfvC7E1cZXRsue
         +7MRoB7OK0G5JJUqw3wtNdFQoRwdqDcUmlU5TWbJTvDHsduCyBFo1JU0gpCGTJo6JAQj
         Ob+ATFMJCJo5nNJMkwPcRBcgjMoAaThXj0/8wIlkSKAwCdmxzGxaKjPQR6wctlDuMQgX
         eeXEacVjktKcB9HNy544BkgzgLn4zxQRjKZTMFTjLyAqu+SX1gHdhgFH28XspieKafKy
         ECUg==
X-Gm-Message-State: ACgBeo2ksYGlC2NTf6m6kaYNGnuwtirr5oei39ZpdSItBEACRH3mHM1j
        A2MBJcimD239Ycc+dE+yEhk=
X-Google-Smtp-Source: AA6agR7xgkvPGABt6ZsWbe+W4GLQVN7fxxnQaqfOoZcLjjDjLxwGo3S+CNeZNMboLZs1LWK0wybk7w==
X-Received: by 2002:a05:6402:95c:b0:43d:6297:f241 with SMTP id h28-20020a056402095c00b0043d6297f241mr17974743edz.373.1659511970651;
        Wed, 03 Aug 2022 00:32:50 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id o5-20020a056402038500b0043cfb6af49asm9073578edv.16.2022.08.03.00.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 00:32:50 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 3 Aug 2022 09:32:48 +0200
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        =?utf-8?B?6LCt5qKT54WK?= <tanzixuan.me@gmail.com>,
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
Message-ID: <YuokoBdtJ2Jp1R25@krava>
References: <20220625153439.513559-1-tanzixuan.me@gmail.com>
 <YrhxE4s0hLvbbibp@krava>
 <CABwm_eT_LE6VbLMgT31yqW=tc_obLP=6E0jnMqVn1sMdWrVVNw@mail.gmail.com>
 <Yrqcpr7ICzpsoGrc@krava>
 <YufUAiLqKiuwdvcP@krava>
 <YuloQYU72pe4p3eK@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YuloQYU72pe4p3eK@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 03:09:05PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 01, 2022 at 03:24:18PM +0200, Jiri Olsa escreveu:
> > On Tue, Jun 28, 2022 at 08:16:06AM +0200, Jiri Olsa wrote:
> > > On Mon, Jun 27, 2022 at 11:08:34AM +0800, 谭梓煊 wrote:
> > > > On Sun, Jun 26, 2022 at 10:45 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > > >
> > > > > On Sat, Jun 25, 2022 at 11:34:38PM +0800, Zixuan Tan wrote:
> > > > > > With OpenSSL v3 installed, the libcrypto feature check fails as it use the
> > > > > > deprecated MD5_* API (and is compiled with -Werror). The error message is
> > > > > > as follows.
> > > > > >
> > > > > > $ make tools/perf
> > > > > > ```
> > > > > > Makefile.config:778: No libcrypto.h found, disables jitted code injection,
> > > > > > please install openssl-devel or libssl-dev
> > > > > >
> > > > > > Auto-detecting system features:
> > > > > > ...                         dwarf: [ on  ]
> > > > > > ...            dwarf_getlocations: [ on  ]
> > > > > > ...                         glibc: [ on  ]
> > > > > > ...                        libbfd: [ on  ]
> > > > > > ...                libbfd-buildid: [ on  ]
> > > > > > ...                        libcap: [ on  ]
> > > > > > ...                        libelf: [ on  ]
> > > > > > ...                       libnuma: [ on  ]
> > > > > > ...        numa_num_possible_cpus: [ on  ]
> > > > > > ...                       libperl: [ on  ]
> > > > > > ...                     libpython: [ on  ]
> > > > > > ...                     libcrypto: [ OFF ]
> > > > > > ...                     libunwind: [ on  ]
> > > > > > ...            libdw-dwarf-unwind: [ on  ]
> > > > > > ...                          zlib: [ on  ]
> > > > > > ...                          lzma: [ on  ]
> > > > > > ...                     get_cpuid: [ on  ]
> > > > > > ...                           bpf: [ on  ]
> > > > > > ...                        libaio: [ on  ]
> > > > > > ...                       libzstd: [ on  ]
> > > > > > ...        disassembler-four-args: [ on  ]
> > > > > > ```
> > > > > >
> > > > > > This is very confusing because the suggested library (on my Ubuntu 20.04
> > > > > > it is libssl-dev) is already installed. As the test only checks for the
> > > > > > presence of libcrypto, this commit suppresses the deprecation warning to
> > > > > > allow the test to pass.
> > > > > >
> > > > > > Signed-off-by: Zixuan Tan <tanzixuan.me@gmail.com>
> > > > > > ---
> > > > > >  tools/build/feature/test-libcrypto.c | 6 ++++++
> > > > > >  1 file changed, 6 insertions(+)
> > > > > >
> > > > > > diff --git a/tools/build/feature/test-libcrypto.c b/tools/build/feature/test-libcrypto.c
> > > > > > index a98174e0569c..31afff093d0b 100644
> > > > > > --- a/tools/build/feature/test-libcrypto.c
> > > > > > +++ b/tools/build/feature/test-libcrypto.c
> > > > > > @@ -2,6 +2,12 @@
> > > > > >  #include <openssl/sha.h>
> > > > > >  #include <openssl/md5.h>
> > > > > >
> > > > > > +/*
> > > > > > + * The MD5_* API have been deprecated since OpenSSL 3.0, which causes the
> > > > > > + * feature test to fail silently. This is a workaround.
> > > > > > + */
> > > > >
> > > > > then we use these deprecated MD5 calls in util/genelf.c if libcrypto is detected,
> > > > > so I wonder how come the rest of the compilation passed for you.. do you have
> > > > > CONFIG_JITDUMP disabled?
> > > > >
> > > > > thanks,
> > > > > jirka
> > > > >
> > > > No, CONFIG_JITDUMP is not disabled. I am using the default configuration.
> > > > 
> > > > Yes, you are right. The rest of the compilation should fail, but it doesn't.
> > > > I checked the verbose build commands. This seems to be the result of another
> > > > inconsistency.
> > > > 
> > > > If libcrypto is detected, the macro "HAVE_LIBCRYPTO_SUPPORT" will be
> > > > defined, but in perf/util/genelf.c, "HAVE_LIBCRYPTO" without the "_SUPPORT"
> > > > prefix is checked. This causes urandom always be used to create build id
> > > > rather than MD5 and SHA1, no matter what the detection result is.
> > > > 
> > > > In perf/Makefile.config, from line 776
> > > > ```
> > > > ifndef NO_LIBCRYPTO
> > > >   ifneq ($(feature-libcrypto), 1)
> > > >     msg := $(warning No libcrypto.h found, disables jitted code injection,
> > > >             please install openssl-devel or libssl-dev);
> > > >     NO_LIBCRYPTO := 1
> > > >   else                                  <-- if libcrypto feature detected
> > > >     CFLAGS += -DHAVE_LIBCRYPTO_SUPPORT  <-- define this
> > > >     EXTLIBS += -lcrypto
> > > >     $(call detected,CONFIG_CRYPTO)
> > > >   endif
> > > > endif
> > > > ```
> > > > 
> > > > In perf/util/genelf.c, from line 33
> > > > ```
> > > > #ifdef HAVE_LIBCRYPTO                <-- but check this, it's always false
> > > 
> > > nice :)
> > > 
> > > > 
> > > > #define BUILD_ID_MD5
> > > > #undef BUILD_ID_SHA /* does not seem to work well when linked with Java */
> > > > #undef BUILD_ID_URANDOM /* different uuid for each run */
> > > > 
> > > > #ifdef BUILD_ID_SHA
> > > > #include <openssl/sha.h>
> > > > #endif
> > > > 
> > > > #ifdef BUILD_ID_MD5
> > > > #include <openssl/md5.h>
> > > > #endif
> > > > #endif                               <-- this block will be skipped
> > > > ```
> > > > 
> > > > Maybe we should fix this, to really make use of libcrypto if it is available?
> > > 
> > > yea, I think that was the original idea, let's keep the variable with
> > > SUPPORT suffix and use the -Wdeprecated-declarations for genelf.c
> > > 
> > > full fix would be to detect the new API and use it when it's available but..
> > > given that the check was false at least since 2016, perhaps we could remove
> > > that code? ;-) Stephane?
> > 
> > ping
> 
> So, we should start with 谭梓煊 patch, then fix that ifdef and go on
> from there?

yes, I thought we could remove that, but there's no reply from
Stephane so let's fix that

jirka
