Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C114FC796
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350346AbiDKWYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiDKWYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:24:19 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41376445;
        Mon, 11 Apr 2022 15:22:00 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 125so20352002iov.10;
        Mon, 11 Apr 2022 15:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sVrk99jK5gTxl0PxzjdJZQxsj8dU0oJ85F8Hhavp+iQ=;
        b=IDzHXOtiq49zpd6i3rO4En/xTuVuDQozx+2ZlXg/2PjrcZLN0zv1Lib0RYxTc99yRn
         MJzx2OQr/27DngFWWRLEKzjYfce5In/L1UiVgBgTn75qg3JBUP20ngwTyPj3K0qRso/2
         Wtx6Y3xvMqNIq+6o7wKbPCVWqnvUr+jmZp6hCHQ0ZPIsG8CNSlmdNR8JQm7H/n78l0LT
         /+mEdVk91PG5+H77rQyXCIMRUmSBpSjHnohkI5Vk3uPI//X4lC3Cir+ZEn2N+2/i1tEA
         RqXfMJU3Gl+DEkglYplUoDHL9XA5lSgrephUYGpwCT7TkOUjqVqoV453dj9B3+mSaals
         6mPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sVrk99jK5gTxl0PxzjdJZQxsj8dU0oJ85F8Hhavp+iQ=;
        b=b96NcSzDg4HnnDRZ9FyQv05RNp/u8f4w5RRktFHT6FUdnZ6N89GoqekiJr65RATVqk
         VcGcS3zTtVp0R0n3k0XWe0l77sPbUl5nvOJh4KdbVwC2/uIbWMqTtlrcV569emvUIVti
         xjNooOkuLOp+vs//JrvNWs8Snis2EjKhWSMdptmQYx7T8LcgiTmBUY/Qxo/FFtYSfVjp
         i2CspF2k5ZSpoTe/38wGJU6urapCykgJudtQbSq1fg7tK33A8RRw7SQzf0YFzecpSjen
         2XaDl3PFz+UwCz2l5bQiIReeSz3VOLYv02cxN2xRIoD07Yi9UPcpwZe0E9L3GjEC5H4I
         fx8w==
X-Gm-Message-State: AOAM531+SGxQfSvj2JGaaWjE2dLFu5QwVaYLeenVjyFoJ0128W2wUD01
        IBb2/7s0k2YkNEvINQUIOKWpmQHencBYOa0Nsfw=
X-Google-Smtp-Source: ABdhPJw9XPMkEqORTNjHBOAB03SPoNqX6ianDhxyxywfgFDVskJEzt2devdZllPujqXGxj0NrzDiWRLgaxDi9eahETU=
X-Received: by 2002:a05:6602:3c6:b0:63d:cac9:bd35 with SMTP id
 g6-20020a05660203c600b0063dcac9bd35mr14274524iov.144.1649715720304; Mon, 11
 Apr 2022 15:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220408232922.mz2vi2oaxf2fvnvt@MBP-98dd607d3435.dhcp.thefacebook.com>
 <YlHrdhkfz+IuGbZM@krava> <CAEf4BzYXHeM+m64cV6_5TU0_BjotDVo+iw_wpJEWLkU9gsvfXg@mail.gmail.com>
 <CAADnVQLQj-ixQo5xEJEZaJavoNpVdhizDmkqFm+pDJq97_Ecpw@mail.gmail.com>
In-Reply-To: <CAADnVQLQj-ixQo5xEJEZaJavoNpVdhizDmkqFm+pDJq97_Ecpw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Apr 2022 15:21:49 -0700
Message-ID: <CAEf4BzbV2PObd26scnTfQ8C1508k=z4cc7mvPS5BAc+9sXhVVg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/4] bpf: Speed up symbol resolving in kprobe multi link
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
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

On Mon, Apr 11, 2022 at 3:18 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 11, 2022 at 10:15 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sat, Apr 9, 2022 at 1:24 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > On Fri, Apr 08, 2022 at 04:29:22PM -0700, Alexei Starovoitov wrote:
> > > > On Thu, Apr 07, 2022 at 02:52:20PM +0200, Jiri Olsa wrote:
> > > > > hi,
> > > > > sending additional fix for symbol resolving in kprobe multi link
> > > > > requested by Alexei and Andrii [1].
> > > > >
> > > > > This speeds up bpftrace kprobe attachment, when using pure symbols
> > > > > (3344 symbols) to attach:
> > > > >
> > > > > Before:
> > > > >
> > > > >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> > > > >   ...
> > > > >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> > > > >
> > > > > After:
> > > > >
> > > > >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> > > > >   ...
> > > > >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> > > > >
> > > > >
> > > > > There are 2 reasons I'm sending this as RFC though..
> > > > >
> > > > >   - I added test that meassures attachment speed on all possible functions
> > > > >     from available_filter_functions, which is 48712 functions on my setup.
> > > > >     The attach/detach speed for that is under 2 seconds and the test will
> > > > >     fail if it's bigger than that.. which might fail on different setups
> > > > >     or loaded machine.. I'm not sure what's the best solution yet, separate
> > > > >     bench application perhaps?
> > > >
> > > > are you saying there is a bug in the code that you're still debugging?
> > > > or just worried about time?
> > >
> > > just the time, I can make the test fail (cross the 2 seconds limit)
> > > when the machine is loaded, like with running kernel build
> > >
> > > but I couldn't reproduce this with just paralel test_progs run
> > >
> > > >
> > > > I think it's better for it to be a part of selftest.
> > > > CI will take extra 2 seconds to run.
> > > > That's fine. It's a good stress test.
> >
> > I agree it's a good stress test, but I disagree on adding it as a
> > selftests. The speed will depend on actual host machine. In VMs it
> > will be slower, on busier machines it will be slower, etc. Generally,
> > depending on some specific timing just causes unnecessary maintenance
> > headaches. We can have this as a benchmark, if someone things it's
> > very important. I'm impartial to having this regularly executed as
> > it's extremely unlikely that we'll accidentally regress from NlogN
> > back to N^2. And if there is some X% slowdown such selftest is
> > unlikely to alarm us anyways. Sporadic failures will annoy us way
> > before that to the point of blacklisting this selftests in CI at the
> > very least.
>
> Such selftest shouldn't be measuring the speed, of course.
> The selftest will be about:
> 1. not crashing
> 2. succeeding to attach and getting some meaningful data back.

Yeah, that's totally fine with me. My biggest beef is using time as a
measure of test success, which will be flaky. Just a slow-ish test
doing a lot of work sounds totally fine.
