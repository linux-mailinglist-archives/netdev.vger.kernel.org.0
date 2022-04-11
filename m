Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50984FC769
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348541AbiDKWRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiDKWRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:17:35 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131E7DEE8;
        Mon, 11 Apr 2022 15:15:20 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 125so20336437iov.10;
        Mon, 11 Apr 2022 15:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g7ssmbicXhxLGtEZMln9w3mBi5v8MseNWcKzGLM3lmg=;
        b=oBdDL9gNuHStJN1VZPf6NZy5rO0aWRZkD7c3AdMooQ8lHzP/QfcwM3Lw+1FOQ0Uy6w
         nULa6eS13L1Ydz9pUu1RB+M63pIIZJZLD3QV5ItOhO8kGqgE53x5Lv37UgeKGpeJZO5i
         m0V6xIaHv+RcM32g1kbQMZ+OJPstaFiSxu7/F/LEwg2vcLKjiSLdqdB0VpzqRqi5ZpBv
         wpFWpKSVelhKxxvbl68hH5ZVo0v+QKTNQZ+MixAUVJ8PEAAEqTsC6JR7gEU8hQghtXBj
         a9dLou/R9Trdmzz84wBWq7uNWvk5qUM0RBNuSHxZfZIJ/PZeeY7Zz5x6N7vKV/VaiwX0
         Oisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g7ssmbicXhxLGtEZMln9w3mBi5v8MseNWcKzGLM3lmg=;
        b=XSBI8uoU+p3JTwzEi634cioeMlp7LD6Fym2KBPKXhCh7DNUqC9I5FE3cIn3g1bP5d2
         fde1Y1xIEAEf/Vgl3UYPWRlzWbKDV3lv6BIOUvZUe6aKWJWQoKUHF//PHazCNX4XV2Fa
         SvDH2FdY3n5sxfVUFcaLD/69hqHw+2QfFYFhkJF045MFj1eCfO+zqV8noSv3cNCtYB6M
         yUzNKLIhXIDTbRlUQL4hB2/PkJYMFhNANQEjoM5trruapXg4YpLyAyS2rwukOy10N4xr
         lSVA/HasGWHuEWZTkgz0cBw6U+UnG8o5D3vZtLOme8/nu/5uLpVrgo15DmwkbQH3ODI7
         FkxA==
X-Gm-Message-State: AOAM532HYqzW+2xuwxffTpd4GbaF+BlWc+1gSrjO9wbLPpmJBs46TRx5
        wjdlX378E4cRQOsoCd0CXkSQEO0+KB0O7q2owvw=
X-Google-Smtp-Source: ABdhPJweTm72MgwgMK+cRhRotLA0K3mOHxz8lljDaGTlNN1M2KM4QNsJkE6lERPm+9pRv/P3xaqFX4vP1fj3thmnbhA=
X-Received: by 2002:a05:6638:1696:b0:326:2d59:7b40 with SMTP id
 f22-20020a056638169600b003262d597b40mr4219180jat.103.1649715319123; Mon, 11
 Apr 2022 15:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220408232922.mz2vi2oaxf2fvnvt@MBP-98dd607d3435.dhcp.thefacebook.com>
 <YlHrdhkfz+IuGbZM@krava>
In-Reply-To: <YlHrdhkfz+IuGbZM@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Apr 2022 15:15:08 -0700
Message-ID: <CAEf4BzYXHeM+m64cV6_5TU0_BjotDVo+iw_wpJEWLkU9gsvfXg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/4] bpf: Speed up symbol resolving in kprobe multi link
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Sat, Apr 9, 2022 at 1:24 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Fri, Apr 08, 2022 at 04:29:22PM -0700, Alexei Starovoitov wrote:
> > On Thu, Apr 07, 2022 at 02:52:20PM +0200, Jiri Olsa wrote:
> > > hi,
> > > sending additional fix for symbol resolving in kprobe multi link
> > > requested by Alexei and Andrii [1].
> > >
> > > This speeds up bpftrace kprobe attachment, when using pure symbols
> > > (3344 symbols) to attach:
> > >
> > > Before:
> > >
> > >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> > >   ...
> > >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> > >
> > > After:
> > >
> > >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> > >   ...
> > >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> > >
> > >
> > > There are 2 reasons I'm sending this as RFC though..
> > >
> > >   - I added test that meassures attachment speed on all possible functions
> > >     from available_filter_functions, which is 48712 functions on my setup.
> > >     The attach/detach speed for that is under 2 seconds and the test will
> > >     fail if it's bigger than that.. which might fail on different setups
> > >     or loaded machine.. I'm not sure what's the best solution yet, separate
> > >     bench application perhaps?
> >
> > are you saying there is a bug in the code that you're still debugging?
> > or just worried about time?
>
> just the time, I can make the test fail (cross the 2 seconds limit)
> when the machine is loaded, like with running kernel build
>
> but I couldn't reproduce this with just paralel test_progs run
>
> >
> > I think it's better for it to be a part of selftest.
> > CI will take extra 2 seconds to run.
> > That's fine. It's a good stress test.

I agree it's a good stress test, but I disagree on adding it as a
selftests. The speed will depend on actual host machine. In VMs it
will be slower, on busier machines it will be slower, etc. Generally,
depending on some specific timing just causes unnecessary maintenance
headaches. We can have this as a benchmark, if someone things it's
very important. I'm impartial to having this regularly executed as
it's extremely unlikely that we'll accidentally regress from NlogN
back to N^2. And if there is some X% slowdown such selftest is
unlikely to alarm us anyways. Sporadic failures will annoy us way
before that to the point of blacklisting this selftests in CI at the
very least.


>
> ok, great
>
> thanks,
> jirka
>
> >
> > >   - copy_user_syms function potentially allocates lot of memory (~6MB in my
> > >     tests with attaching ~48k functions). I haven't seen this to fail yet,
> > >     but it might need to be changed to allocate memory gradually if needed,
> > >     do we care? ;-)
> >
> > replied in the other email.
> >
> > Thanks for working on this!
