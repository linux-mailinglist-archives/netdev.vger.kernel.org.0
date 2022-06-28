Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D570855C661
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244430AbiF1GQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiF1GQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:16:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F105E2654D;
        Mon, 27 Jun 2022 23:16:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id b26so3673739wrc.2;
        Mon, 27 Jun 2022 23:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jL6/nk5mBr7/ytmWLmxAvqcskohZ9iudhvPPHLK4gS0=;
        b=MUmjUAva8jZWOiLJo/WMaOdx5+FUo9uA9MGM5dGj4bqlxk01Qr8NhH+lnf+I+xQFhp
         peufVdNsXDAvOjejrCjQajQMt/XguuC5u+nhxQ/AyPTy5cYdaklplQMWldHffeARjbzM
         6hEIx54W+hXnYNtWlH4qU8nq9JltXVL4rBexGRelZvlzWWok6o4slHKPhgWJiSI0RrPB
         OYrb/l1mtKgyHGJYkt/exAtRkFHjV/Iua6DIPzT8eYNFgSXUBxVGp/kc99u9C3l4PQZ5
         pgRM/EN8rPKnIY474h8gS57lzzqAjAZKo96l/0vlpcqBdW4Ijm7D+txcupeeSw3NDuAZ
         Be+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jL6/nk5mBr7/ytmWLmxAvqcskohZ9iudhvPPHLK4gS0=;
        b=I3lOb/BwsdZtanThNm8DDD2Rs6RUx7djupFS4+HUbSRCR8/pKGomPFilYaRaFBRUyq
         fwC7AbzarbmAqUB8hnBhnxHm/kSXS0nmjnERhaSx98X85GQo2zyNh/VuodFr2lzysxLQ
         aDrQPaO7qEQMzqpoQqY/BlEjoMNMGqdPcws/n3cHhkNpdotAPAuA1Z9wmuGkm2fjyE9p
         C0ToN3963fO7RR5M8I74EvHCdy5zYt3wmLBYpxVSLuy2nrCagal51C9YeGOT1bXuXlgw
         IfBKvWxSuz5GMX6TYGmaxKydYWhrmdbGg5DsuQU4bKw9l3b2yQ7dKSeZGVd0Df7HBfuX
         0T+g==
X-Gm-Message-State: AJIora8Cpok+DgGvC/X6ycHxSDkKsFGOYToTiymp09p4Q7AWeSgcKIkf
        0HWNYyDtVWptxvmZi+RCumsz1vwuTjH5NluoSys=
X-Google-Smtp-Source: AGRyM1vApcFYIBL9BwMQUNHvEUvqE/LrM3XPz+Bp+ziz1nWRpqTI7onJrFgw2USTDrnFSp6YVSq//A==
X-Received: by 2002:a05:6000:1ac8:b0:21b:923a:1c44 with SMTP id i8-20020a0560001ac800b0021b923a1c44mr16587928wry.31.1656396970415;
        Mon, 27 Jun 2022 23:16:10 -0700 (PDT)
Received: from krava (net-109-116-206-47.cust.vodafonedsl.it. [109.116.206.47])
        by smtp.gmail.com with ESMTPSA id p26-20020a1c741a000000b0039c798b2dc5sm19480276wmc.8.2022.06.27.23.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 23:16:10 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 28 Jun 2022 08:16:06 +0200
To:     =?utf-8?B?6LCt5qKT54WK?= <tanzixuan.me@gmail.com>,
        Stephane Eranian <eranian@google.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Zixuan Tan <tanzixuangg@gmail.com>,
        terrelln@fb.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] perf build: Suppress openssl v3 deprecation warnings in
 libcrypto feature test
Message-ID: <Yrqcpr7ICzpsoGrc@krava>
References: <20220625153439.513559-1-tanzixuan.me@gmail.com>
 <YrhxE4s0hLvbbibp@krava>
 <CABwm_eT_LE6VbLMgT31yqW=tc_obLP=6E0jnMqVn1sMdWrVVNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABwm_eT_LE6VbLMgT31yqW=tc_obLP=6E0jnMqVn1sMdWrVVNw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 11:08:34AM +0800, 谭梓煊 wrote:
> On Sun, Jun 26, 2022 at 10:45 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Sat, Jun 25, 2022 at 11:34:38PM +0800, Zixuan Tan wrote:
> > > With OpenSSL v3 installed, the libcrypto feature check fails as it use the
> > > deprecated MD5_* API (and is compiled with -Werror). The error message is
> > > as follows.
> > >
> > > $ make tools/perf
> > > ```
> > > Makefile.config:778: No libcrypto.h found, disables jitted code injection,
> > > please install openssl-devel or libssl-dev
> > >
> > > Auto-detecting system features:
> > > ...                         dwarf: [ on  ]
> > > ...            dwarf_getlocations: [ on  ]
> > > ...                         glibc: [ on  ]
> > > ...                        libbfd: [ on  ]
> > > ...                libbfd-buildid: [ on  ]
> > > ...                        libcap: [ on  ]
> > > ...                        libelf: [ on  ]
> > > ...                       libnuma: [ on  ]
> > > ...        numa_num_possible_cpus: [ on  ]
> > > ...                       libperl: [ on  ]
> > > ...                     libpython: [ on  ]
> > > ...                     libcrypto: [ OFF ]
> > > ...                     libunwind: [ on  ]
> > > ...            libdw-dwarf-unwind: [ on  ]
> > > ...                          zlib: [ on  ]
> > > ...                          lzma: [ on  ]
> > > ...                     get_cpuid: [ on  ]
> > > ...                           bpf: [ on  ]
> > > ...                        libaio: [ on  ]
> > > ...                       libzstd: [ on  ]
> > > ...        disassembler-four-args: [ on  ]
> > > ```
> > >
> > > This is very confusing because the suggested library (on my Ubuntu 20.04
> > > it is libssl-dev) is already installed. As the test only checks for the
> > > presence of libcrypto, this commit suppresses the deprecation warning to
> > > allow the test to pass.
> > >
> > > Signed-off-by: Zixuan Tan <tanzixuan.me@gmail.com>
> > > ---
> > >  tools/build/feature/test-libcrypto.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/tools/build/feature/test-libcrypto.c b/tools/build/feature/test-libcrypto.c
> > > index a98174e0569c..31afff093d0b 100644
> > > --- a/tools/build/feature/test-libcrypto.c
> > > +++ b/tools/build/feature/test-libcrypto.c
> > > @@ -2,6 +2,12 @@
> > >  #include <openssl/sha.h>
> > >  #include <openssl/md5.h>
> > >
> > > +/*
> > > + * The MD5_* API have been deprecated since OpenSSL 3.0, which causes the
> > > + * feature test to fail silently. This is a workaround.
> > > + */
> >
> > then we use these deprecated MD5 calls in util/genelf.c if libcrypto is detected,
> > so I wonder how come the rest of the compilation passed for you.. do you have
> > CONFIG_JITDUMP disabled?
> >
> > thanks,
> > jirka
> >
> No, CONFIG_JITDUMP is not disabled. I am using the default configuration.
> 
> Yes, you are right. The rest of the compilation should fail, but it doesn't.
> I checked the verbose build commands. This seems to be the result of another
> inconsistency.
> 
> If libcrypto is detected, the macro "HAVE_LIBCRYPTO_SUPPORT" will be
> defined, but in perf/util/genelf.c, "HAVE_LIBCRYPTO" without the "_SUPPORT"
> prefix is checked. This causes urandom always be used to create build id
> rather than MD5 and SHA1, no matter what the detection result is.
> 
> In perf/Makefile.config, from line 776
> ```
> ifndef NO_LIBCRYPTO
>   ifneq ($(feature-libcrypto), 1)
>     msg := $(warning No libcrypto.h found, disables jitted code injection,
>             please install openssl-devel or libssl-dev);
>     NO_LIBCRYPTO := 1
>   else                                  <-- if libcrypto feature detected
>     CFLAGS += -DHAVE_LIBCRYPTO_SUPPORT  <-- define this
>     EXTLIBS += -lcrypto
>     $(call detected,CONFIG_CRYPTO)
>   endif
> endif
> ```
> 
> In perf/util/genelf.c, from line 33
> ```
> #ifdef HAVE_LIBCRYPTO                <-- but check this, it's always false

nice :)

> 
> #define BUILD_ID_MD5
> #undef BUILD_ID_SHA /* does not seem to work well when linked with Java */
> #undef BUILD_ID_URANDOM /* different uuid for each run */
> 
> #ifdef BUILD_ID_SHA
> #include <openssl/sha.h>
> #endif
> 
> #ifdef BUILD_ID_MD5
> #include <openssl/md5.h>
> #endif
> #endif                               <-- this block will be skipped
> ```
> 
> Maybe we should fix this, to really make use of libcrypto if it is available?

yea, I think that was the original idea, let's keep the variable with
SUPPORT suffix and use the -Wdeprecated-declarations for genelf.c

full fix would be to detect the new API and use it when it's available but..
given that the check was false at least since 2016, perhaps we could remove
that code? ;-) Stephane?

jirka

> 
> Links:
>  This commit include the genelf.c:
>   https://lore.kernel.org/all/1448874143-7269-3-git-send-email-eranian@google.com/T/#mb6d3e18bee4901b71a4d4ef4f406feaaf48346d9
>  This commit include the feature test:
>   https://lore.kernel.org/all/1448874143-7269-3-git-send-email-eranian@google.com/T/#m12a2ababf8ad3e366d56d9efab870592e6ff60a5
> 
> Thanks,
> Zixuan
> 
> > > +#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> > > +
> > >  int main(void)
> > >  {
> > >       MD5_CTX context;
> > > --
> > > 2.34.1
> > >
