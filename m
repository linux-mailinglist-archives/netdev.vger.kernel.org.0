Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E6767AA2F
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 07:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbjAYGHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 01:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjAYGHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 01:07:33 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B4A1BCA;
        Tue, 24 Jan 2023 22:07:30 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id h24so22953119lfv.6;
        Tue, 24 Jan 2023 22:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=25jMM77qoNhLMrn8AMJzPlEVfBj8k8RbdPA119mhwbE=;
        b=BZzsq844KEVQsOKniO42tpzVN9wTwav/dJ+XAP4CgplzAX6g9G+hh1ft5E5mOICbpf
         KhvSUZVdySGOUcdMvIQABgNGBvRbI2CWn+LoJzh1/oW3GahRgw/tGR1w9NcFnyQfKrCm
         ObDdoWEGJTYrzsN46fx14VhmA64/U5og8f/YJwMO80w+PkLJh2jw/lq2ZzQXQe3XrqYF
         VHzxtDQHeiltltFVTxxH9Nm/0tYdhnny5t+gh+h+9VIiFAImQjzdaKKyWQZ7eWOI0tZU
         BsyGrBpxXJVTFQ+X0tegJvrqO6fyBRQNW2rKJcQcRTvhm29e1PSa457GWojRKYoPu4QM
         5ztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=25jMM77qoNhLMrn8AMJzPlEVfBj8k8RbdPA119mhwbE=;
        b=sZAxzRBWNsxvFtvARb/CxYHYHLHxs3tE/D1mUrsdeElxxewQBaRSlRE1J0zJj/r7ij
         wnKyifXhlKre/VM6aS1hG1AwlJfANLZQbE9azJ1yhuuOOcjOSl8UTt52ps/i150EryA4
         gfxDRa/hII0w/jIzwBSTEjmH7dUy9CNcsEazXWlYGvi9hRWg6e2ikVD8hA0/QSRtTJeG
         PEtElydIrgv8PR7JG/v6wbxmfmam8bH2MVsTLkJHFeldf24/pJdk+wR0bnSoxngIvB6h
         2iVyODbplYQnsP1Ct+el2SKnlOh6hL0ao43Hw4XujoWzShV8RNfJ8P7Hpw6z/aZfjAyZ
         H1Fw==
X-Gm-Message-State: AFqh2kqtqj0ipENnbEZIB0mJrqQXBHZQJ1D/AxXh65ZuM8KtBZxHAPjm
        743SL0Iz19AjSuG4Hw7MguqGCtsYaeVnGf9dCw==
X-Google-Smtp-Source: AMrXdXsbwi2mT00SYPsyH8yTHdzGuZuws2V7VeXaNzMyTX4yJS2xyK2zElfNRKjs/QkNrA4tZ+tIJG2lucJ7s52Ffwk=
X-Received: by 2002:a19:a40b:0:b0:4cb:435b:69d0 with SMTP id
 q11-20020a19a40b000000b004cb435b69d0mr1495046lfc.49.1674626848465; Tue, 24
 Jan 2023 22:07:28 -0800 (PST)
MIME-Version: 1.0
References: <20230121064128.67914-1-danieltimlee@gmail.com> <32195f48-8b45-1a78-1964-dfe7b5a4933f@iogearbox.net>
In-Reply-To: <32195f48-8b45-1a78-1964-dfe7b5a4933f@iogearbox.net>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 25 Jan 2023 15:07:11 +0900
Message-ID: <CAEKGpzjc4Yr-pwUQK8spVt18ZYKNav=4=SQv=7Te2jsM7o35ew@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: fix vmtest static compilation error
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 1:21 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/21/23 7:41 AM, Daniel T. Lee wrote:
> > As stated in README.rst, in order to resolve errors with linker errors,
> > 'LDLIBS=-static' should be used. Most problems will be solved by this
> > option, but in the case of urandom_read, this won't fix the problem. So
> > the Makefile is currently implemented to strip the 'static' option when
> > compiling the urandom_read. However, stripping this static option isn't
> > configured properly on $(LDLIBS) correctly, which is now causing errors
> > on static compilation.
> >
> >      # LDLIBS=-static ./vmtest.sh
> >      ld.lld: error: attempted static link of dynamic object liburandom_read.so
> >      clang: error: linker command failed with exit code 1 (use -v to see invocation)
> >      make: *** [Makefile:190: /linux/tools/testing/selftests/bpf/urandom_read] Error 1
> >      make: *** Waiting for unfinished jobs....
> >
> > This commit fixes this problem by configuring the strip with $(LDLIBS).
> >
> > Fixes: 68084a136420 ("selftests/bpf: Fix building bpf selftests statically")
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >   tools/testing/selftests/bpf/Makefile | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 22533a18705e..7bd1ce9c8d87 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -188,7 +188,7 @@ $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
> >   $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
> >       $(call msg,BINARY,,$@)
> >       $(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^) \
> > -                  liburandom_read.so $(LDLIBS)                              \
> > +                  liburandom_read.so $(filter-out -static,$(LDLIBS))      \
>
> Do we need the same also for liburandom_read.so target's $(LDLIBS) further above?
>

Oops, I didn't notice that.
I'll apply the review and send the next version of patch!

> >                    -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
> >                    -Wl,-rpath=. -o $@
> >
> >
>


-- 
Best,
Daniel T. Lee
