Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CEC52E15A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344080AbiETAsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiETAsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:48:21 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27666131282;
        Thu, 19 May 2022 17:48:20 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id f9so4709992ils.7;
        Thu, 19 May 2022 17:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oj7MrD85RT/bMm8gL3PkltfI4HET7Lu7FGmvmGW0/28=;
        b=as2ZITbTtHudPfEicLOBd1exjgyLGfFo22nQX/5EGXC+XZ53fZ/rMPxVW0JtP26wJr
         dCILoFQhTFhggQKauJbEMyPHs8bdXNcFmekeNnBfZVX1sF8kAnC2XcapJ+vsZ5atiq8M
         n7aK+v2TO6xFqOco1ZpvpgTTBzUzMkrOfzpz4eWPkkTeXD9HUJtz/yD8xXw4SO3qqjvY
         Ntkr3i+CZbv/OJx8TVAi5evHzM3cMW0mV6gvrjxiorWPuz0IzsyztC3nOImpHob5luGA
         syXrJ8VM1UnNfYA1iFR57EP+SnhjBvnJVVUH+J1WNq5JekkVSCbJwH5SFrl7q+YEeOW3
         JXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oj7MrD85RT/bMm8gL3PkltfI4HET7Lu7FGmvmGW0/28=;
        b=j7PSDM7oQ0I7EURvSiGAQUmhDtdRzxcLbN+Z/lZH+kNdcC2EMCsGjMqz6nJzpURvcU
         qy4NH5TVBjvb7zaAL8GOQoGktpweCAN3uNe/doKv1Nh3J7qDV9orOIqqXXltY03EuWqX
         7C0AQVZmwvtfYnqgFbmq2dBQDPYMXffub8K/s08raOP/xYJNMwsC+pIEFqHMsey5LVQB
         JUBQGdkf/FTLkuamE7S133mmvMV5WGff8T8zgl+VyCIsn90ekNlwARQl8ULhReBxkDd6
         n2zlm6QXpPiCRYM6pq4N1jVN/UK0RsavgTTubOE2cO8YL8TR0jNbig5WdG3V2n/dut6y
         bK2g==
X-Gm-Message-State: AOAM533ChAkFmZVKN233czg6gJwy9XjI5COpMPp3+j19CgaSdl3emhxG
        bUkIHqYLtYa8d2WZ9lNiVEUyHgy++PBwHYX34UlWJNt46qU=
X-Google-Smtp-Source: ABdhPJw5wgU//yKzajDuQ5MvxxZPylTGsw5+T5ctfpLdd1eJFUGoUgIdN6HhevKpJU67Dn7YYZgBo2jQHLha0RHrcJo=
X-Received: by 2002:a05:6e02:1c01:b0:2d1:262e:8d5f with SMTP id
 l1-20020a056e021c0100b002d1262e8d5fmr4026979ilh.98.1653007699548; Thu, 19 May
 2022 17:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652772731.git.esyr@redhat.com> <9e4171972a3d75e656073e0c25cd4071a6f652e4.1652772731.git.esyr@redhat.com>
 <CAEf4BzYpNZSY+D6_QP4NE2dN25g4wD43UmJyzmqXCL=HOE9HFA@mail.gmail.com> <20220519143702.GA22773@asgard.redhat.com>
In-Reply-To: <20220519143702.GA22773@asgard.redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 May 2022 17:48:08 -0700
Message-ID: <CAEf4BzYLyR7=KUqoFLCdgw0+YeAJ=r9SEzdmve8r+obv+4TBVw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/4] bpf_trace: check size for overflow in bpf_kprobe_multi_link_attach
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Thu, May 19, 2022 at 7:37 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> On Wed, May 18, 2022 at 04:30:14PM -0700, Andrii Nakryiko wrote:
> > On Tue, May 17, 2022 at 12:36 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> > >
> > > Check that size would not overflow before calculation (and return
> > > -EOVERFLOW if it will), to prevent potential out-of-bounds write
> > > with the following copy_from_user.  Use kvmalloc_array
> > > in copy_user_syms to prevent out-of-bounds write into syms
> > > (and especially buf) as well.
> > >
> > > Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> > > Cc: <stable@vger.kernel.org> # 5.18
> > > Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> > > ---
> > >  kernel/trace/bpf_trace.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index 7141ca8..9c041be 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -2261,11 +2261,11 @@ static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32
> > >         int err = -ENOMEM;
> > >         unsigned int i;
> > >
> > > -       syms = kvmalloc(cnt * sizeof(*syms), GFP_KERNEL);
> > > +       syms = kvmalloc_array(cnt, sizeof(*syms), GFP_KERNEL);
> > >         if (!syms)
> > >                 goto error;
> > >
> > > -       buf = kvmalloc(cnt * KSYM_NAME_LEN, GFP_KERNEL);
> > > +       buf = kvmalloc_array(cnt, KSYM_NAME_LEN, GFP_KERNEL);
> > >         if (!buf)
> > >                 goto error;
> > >
> > > @@ -2461,7 +2461,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> > >         if (!cnt)
> > >                 return -EINVAL;
> > >
> > > -       size = cnt * sizeof(*addrs);
> > > +       if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> > > +               return -EOVERFLOW;
> > >         addrs = kvmalloc(size, GFP_KERNEL);
> >
> > any good reason not to use kvmalloc_array() here as well and delegate
> > overflow to it. And then use long size (as expected by copy_from_user
> > anyway) everywhere?
>
> Just to avoid double calculation of size, otherwise I don't have
> any significant prefernce, other than -EOVERFLOW would not be reported
> separately (not sure if this a good or a bad thing), and that
> it would be a bit more cumbersome to incorporate the Yonghong's
> suggestion[1] about the INT_MAX check.
>

I think it's totally fine to return ENOMEM if someone requested some
unreasonable amount of symbols. And INT_MAX won't be necessary if we
delegate all the overflow checking to kvmalloc_array()

> [1] https://lore.kernel.org/lkml/412bf136-6a5b-f442-1e84-778697e2b694@fb.com/
>
> > >         if (!addrs)
> > >                 return -ENOMEM;
> > > --
> > > 2.1.4
> > >
> >
>
