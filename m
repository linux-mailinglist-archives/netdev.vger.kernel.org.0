Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4025881C3
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 20:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiHBSN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 14:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiHBSNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 14:13:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3551817E1C;
        Tue,  2 Aug 2022 11:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C42B81EF4;
        Tue,  2 Aug 2022 18:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F43C433D6;
        Tue,  2 Aug 2022 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659464000;
        bh=nQJbrO57DyZP6Khfo1y4+FRa0/uoV/1hWZd8ykEAbQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KkZKasLRcXY0UBRLQpQCt2HQeH+bQJ1EurBm17qTjnGcjMFX7FlDsFYfMlc//PNrs
         rFG7UFwDqSKio7gMApA2khxLmHdsWrmSFmlu/5J5VQo2p+fG51lXBQcABrf/owkFq0
         hnQ+djSIN+1DE05gj0AQAbawTkbxQJTcOUnoQysbS91lTcj/8M6sf/UKwuVpVES1jb
         N7iQn+MIzbkQyn59h47K0cGQLhExl2cifL9HAklbI6QScYHfNwzRldQq9iXSamtxvB
         8btn6IUoD0XLlzco8f2s9dLVHg32tpNXRFgTuCCx6tcNHzqZTB2zWIp/y1CZGzHhqY
         WIOFYjDeMbbcQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1B8CE40736; Tue,  2 Aug 2022 15:13:18 -0300 (-03)
Date:   Tue, 2 Aug 2022 15:13:18 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Stephane Eranian <eranian@google.com>,
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
Message-ID: <YulpPqXSOG0Q4J1o@kernel.org>
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
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Aug 02, 2022 at 03:09:05PM -0300, Arnaldo Carvalho de Melo escreveu:
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

I.e. with this:


diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
index aed49806a09bab8f..953338b9e887e26f 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -30,7 +30,11 @@
 
 #define BUILD_ID_URANDOM /* different uuid for each run */
 
-#ifdef HAVE_LIBCRYPTO
+// FIXME, remove this and fix the deprecation warnings before its removed and
+// We'll break for good here...
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
+#ifdef HAVE_LIBCRYPTO_SUPPORT
 
 #define BUILD_ID_MD5
 #undef BUILD_ID_SHA	/* does not seem to work well when linked with Java */
