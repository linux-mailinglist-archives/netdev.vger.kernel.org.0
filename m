Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FEE4FE511
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357274AbiDLPtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiDLPtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:49:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142C95FF23;
        Tue, 12 Apr 2022 08:46:54 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bh17so38149044ejb.8;
        Tue, 12 Apr 2022 08:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gwZ9CHvYhZZ9147CrVLA+yjNadbJUhOCmSfrIzjUHWg=;
        b=P+vpgkwx8MjQx+ycKCwc6BgaPi7uKHrw/x7OkuGiydyZW8GRegFWgWZSktFmeoBJHl
         y+XpOHd0TvosGRU4ZnFkTGFcBmh+NoISJ6JkQxso/rBSxn+3A/uBJ6rwxHCD/sS/jcCU
         V/MOKfTg6mg4jZKkI3fObyPuXVaFZyRRRBEormnhQIJyM6SpwLoktBhfVkPFcwl2kdSQ
         lVZ16fap4LpHCqNGCzRpLJJ71IBEQWfqdN5T0C+bu1q97QhmnkekHEQzPXcVXzZwoe8s
         Q6Xm9UGV6eWFo5EXc5fHt7AyvMQ8VpGosW/MIjaFK7Gb5nSyp6Qrx1wzhMsgf8wn3XJk
         Q/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gwZ9CHvYhZZ9147CrVLA+yjNadbJUhOCmSfrIzjUHWg=;
        b=WkYucC9JGgbHucWxvG93IsLEOMIz3vTrSINBkKis3O+6KmtCNy1hh0lUytuVNzmrtE
         14dN/JLcJvJd5pQ/bLvf9GAr2K5eOJF7e/hvYuCvfZopQoabuea0k0Z0vI9Wj+rfzEJv
         hIKUffmQumMu47R3YyJ0P6ppLH6DyJAnV+DU16vLdJwbI2sphP41kMaTYFxVtlLNb/Jq
         AQazSEP7oyl9FOshdjRoIDxVuMExALMFwcCiryXd4sUhajIF6nQX3FlbxedXuXwNdJGr
         Ugir7gKl7ZCYMfwdyAI29Mf87g/GxeoQKW773G+6aW6jFZoGXIlSxo4tTwjSHOxea46X
         GVfQ==
X-Gm-Message-State: AOAM532Bf/3Va7SkP7V2tfTiecyVuBY7Z7QxK7aejftrc0p6nLzIXUdU
        cwvsvcXU2/TB0yCct1LypEw=
X-Google-Smtp-Source: ABdhPJz0ggnoLW3vkCVf9b6N6Oatr4EM1jR37FXRi8Iw3QENChkAGly44hf54w3k/WSzhNIqvsrpaw==
X-Received: by 2002:a17:907:160b:b0:6e8:58c1:8850 with SMTP id hb11-20020a170907160b00b006e858c18850mr15415064ejc.284.1649778412502;
        Tue, 12 Apr 2022 08:46:52 -0700 (PDT)
Received: from krava ([83.240.62.142])
        by smtp.gmail.com with ESMTPSA id s11-20020a170906284b00b006e108693850sm13214817ejc.28.2022.04.12.08.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 08:46:52 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:46:49 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [RFC bpf-next 0/4] bpf: Speed up symbol resolving in kprobe
 multi link
Message-ID: <YlWe6U7qSsFA7DYK@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220408232922.mz2vi2oaxf2fvnvt@MBP-98dd607d3435.dhcp.thefacebook.com>
 <YlHrdhkfz+IuGbZM@krava>
 <CAEf4BzYXHeM+m64cV6_5TU0_BjotDVo+iw_wpJEWLkU9gsvfXg@mail.gmail.com>
 <CAADnVQLQj-ixQo5xEJEZaJavoNpVdhizDmkqFm+pDJq97_Ecpw@mail.gmail.com>
 <CAEf4BzbV2PObd26scnTfQ8C1508k=z4cc7mvPS5BAc+9sXhVVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbV2PObd26scnTfQ8C1508k=z4cc7mvPS5BAc+9sXhVVg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:21:49PM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 11, 2022 at 3:18 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Apr 11, 2022 at 10:15 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Sat, Apr 9, 2022 at 1:24 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > >
> > > > On Fri, Apr 08, 2022 at 04:29:22PM -0700, Alexei Starovoitov wrote:
> > > > > On Thu, Apr 07, 2022 at 02:52:20PM +0200, Jiri Olsa wrote:
> > > > > > hi,
> > > > > > sending additional fix for symbol resolving in kprobe multi link
> > > > > > requested by Alexei and Andrii [1].
> > > > > >
> > > > > > This speeds up bpftrace kprobe attachment, when using pure symbols
> > > > > > (3344 symbols) to attach:
> > > > > >
> > > > > > Before:
> > > > > >
> > > > > >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> > > > > >   ...
> > > > > >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> > > > > >
> > > > > > After:
> > > > > >
> > > > > >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> > > > > >   ...
> > > > > >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> > > > > >
> > > > > >
> > > > > > There are 2 reasons I'm sending this as RFC though..
> > > > > >
> > > > > >   - I added test that meassures attachment speed on all possible functions
> > > > > >     from available_filter_functions, which is 48712 functions on my setup.
> > > > > >     The attach/detach speed for that is under 2 seconds and the test will
> > > > > >     fail if it's bigger than that.. which might fail on different setups
> > > > > >     or loaded machine.. I'm not sure what's the best solution yet, separate
> > > > > >     bench application perhaps?
> > > > >
> > > > > are you saying there is a bug in the code that you're still debugging?
> > > > > or just worried about time?
> > > >
> > > > just the time, I can make the test fail (cross the 2 seconds limit)
> > > > when the machine is loaded, like with running kernel build
> > > >
> > > > but I couldn't reproduce this with just paralel test_progs run
> > > >
> > > > >
> > > > > I think it's better for it to be a part of selftest.
> > > > > CI will take extra 2 seconds to run.
> > > > > That's fine. It's a good stress test.
> > >
> > > I agree it's a good stress test, but I disagree on adding it as a
> > > selftests. The speed will depend on actual host machine. In VMs it
> > > will be slower, on busier machines it will be slower, etc. Generally,
> > > depending on some specific timing just causes unnecessary maintenance
> > > headaches. We can have this as a benchmark, if someone things it's
> > > very important. I'm impartial to having this regularly executed as
> > > it's extremely unlikely that we'll accidentally regress from NlogN
> > > back to N^2. And if there is some X% slowdown such selftest is
> > > unlikely to alarm us anyways. Sporadic failures will annoy us way
> > > before that to the point of blacklisting this selftests in CI at the
> > > very least.
> >
> > Such selftest shouldn't be measuring the speed, of course.
> > The selftest will be about:
> > 1. not crashing
> > 2. succeeding to attach and getting some meaningful data back.
> 
> Yeah, that's totally fine with me. My biggest beef is using time as a
> measure of test success, which will be flaky. Just a slow-ish test
> doing a lot of work sounds totally fine.

ok, I'll remove the 2 seconds check

thanks,
jirka
