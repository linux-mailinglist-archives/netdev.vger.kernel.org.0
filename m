Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A91A4D0D75
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbiCHBYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiCHBYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:24:38 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDF626E0;
        Mon,  7 Mar 2022 17:23:42 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id 9so12944544ily.11;
        Mon, 07 Mar 2022 17:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hDD4kejVrYrdIp/0ION3LJ6B/27HmC/bJYw40UoeBx4=;
        b=ZGkrtym8ExhEtic8ReBzJQtL2O5rKwNPGqMJtygnWTgkzBwxEhWeDmtTWy2ETLi3mN
         UFh5969wG6VbfGOTwDrL1gyrbBeQZFK7hitiTUDKy5Sioe46/vQ51mUDKGlVSfytxwsf
         G/7x743YkeUhVNfJXKhpgeO2wwvjNB3V44NMZ/7PhFRU/Qpp0aesilmHabJWf9gYKlh8
         bDse0ot4gaQHB0rF5anWxySiEBcAMX9fY+npd9KMLF+m5Tik9GR531n7MHC84W6x1m9T
         VN6I5U0fJwcJjBODekEOhFp75pNs/eBmAmw5Wa8qvvGPj/gZM0UFsXXaooOI6cV7PP5B
         gTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hDD4kejVrYrdIp/0ION3LJ6B/27HmC/bJYw40UoeBx4=;
        b=6EXmJ3fXcYI07MwKo/UtoXfTpiH78bM9ASgO7uoVXTKYWl25MLMQdm6+tmX/3jZxYa
         vgkpROc4uoOznFrBWvB4fw/i+IgcKxHyfuVpGxXKAuYkFoFo4bI1Qg8J2C7qWtIReESe
         nrPMgjpzESQ7S9aZnv7lD1UFF0e/L1SQ8INzoiye1UaUAe9C99NthVTQJ6TRUQrgOqFn
         Md78N9BvQQew8SKbu3BRGBs7tA3dmyVgxy+to3xyHMal5idGyJcO60UCkPJVz6UGg69s
         J1kyox/ojvD7LJwWsBCHuBKe2/aTnufMVvBjf7haxYL1TVpLykl3JIoLdYiR+3YPf1iR
         KhRg==
X-Gm-Message-State: AOAM531wJhtYNsDzPTsUdAyw3EkQOBj2cFhymoFsUqan2zahR4zchaTC
        q88Oro35TL8es1LgI6tj1QYe/DJMFM8OJ0XNEU9wAGe/1Ic=
X-Google-Smtp-Source: ABdhPJwRurygy4RQRycJdCJr7s5FtaeABHS4hYUFZnGF2gK8fp0EupK6GsG7uOTvSo4SQBq7NyQfddXbXf3aDcBf2Hk=
X-Received: by 2002:a92:d241:0:b0:2c6:d22:27cf with SMTP id
 v1-20020a92d241000000b002c60d2227cfmr13630674ilg.98.1646702622050; Mon, 07
 Mar 2022 17:23:42 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-6-jolsa@kernel.org>
 <CAEf4Bzab_crw+e_POJ39E+JkBDG4WJQqDGz-8Gz_JOt0rYnigA@mail.gmail.com> <YiTvY2Ly/XWICP2H@krava>
In-Reply-To: <YiTvY2Ly/XWICP2H@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 17:23:31 -0800
Message-ID: <CAEf4BzatkcxOdttWc92GYF7SY09nYk26RgpKsLGpd4fqX7my+Q@mail.gmail.com>
Subject: Re: [PATCH 05/10] bpf: Add cookie support to programs attached with
 kprobe multi link
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Sun, Mar 6, 2022 at 9:29 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Fri, Mar 04, 2022 at 03:11:08PM -0800, Andrii Nakryiko wrote:
> > On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding support to call bpf_get_attach_cookie helper from
> > > kprobe programs attached with kprobe multi link.
> > >
> > > The cookie is provided by array of u64 values, where each
> > > value is paired with provided function address or symbol
> > > with the same array index.
> > >
> > > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  include/linux/sort.h           |   2 +
> > >  include/uapi/linux/bpf.h       |   1 +
> > >  kernel/trace/bpf_trace.c       | 103 ++++++++++++++++++++++++++++++++-
> > >  lib/sort.c                     |   2 +-
> > >  tools/include/uapi/linux/bpf.h |   1 +
> > >  5 files changed, 107 insertions(+), 2 deletions(-)
> > >
> >
> > [...]
> >
> > >  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
> > >  {
> > >         struct bpf_trace_run_ctx *run_ctx;
> > > @@ -1297,7 +1312,9 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > >                         &bpf_get_func_ip_proto_kprobe_multi :
> > >                         &bpf_get_func_ip_proto_kprobe;
> > >         case BPF_FUNC_get_attach_cookie:
> > > -               return &bpf_get_attach_cookie_proto_trace;
> > > +               return prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI ?
> > > +                       &bpf_get_attach_cookie_proto_kmulti :
> > > +                       &bpf_get_attach_cookie_proto_trace;
> > >         default:
> > >                 return bpf_tracing_func_proto(func_id, prog);
> > >         }
> > > @@ -2203,6 +2220,9 @@ struct bpf_kprobe_multi_link {
> > >         struct bpf_link link;
> > >         struct fprobe fp;
> > >         unsigned long *addrs;
> > > +       struct bpf_run_ctx run_ctx;
> >
> > clever, I like it! Keep in mind, though, that this trick can only be
> > used here because this run_ctx is read-only (I'd leave the comment
> > here about this, I didn't realize immediately that this approach can't
> > be used for run_ctx that needs to be modified).
>
> hum, I don't see it at the moment.. I'll check on that and add the
> comment or come up with more questions ;-)

if run_ctx is used to store some information, it has to be per program
execution (private to a single bpf program run, just like bpf
program's stack). So you can't just reuse bpf_link for that, because
bpf_link is shared across all CPUs and thus (potentially) across
multiple simultaneous prog runs

>
> >
> > > +       u64 *cookies;
> > > +       u32 cnt;
> > >  };
> > >

[...]

> >
> > >  {
> > >         do {
> > >  #ifdef CONFIG_64BIT
> > > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > > index 6c66138c1b9b..d18996502aac 100644
> > > --- a/tools/include/uapi/linux/bpf.h
> > > +++ b/tools/include/uapi/linux/bpf.h
> > > @@ -1482,6 +1482,7 @@ union bpf_attr {
> > >                         struct {
> > >                                 __aligned_u64   syms;
> > >                                 __aligned_u64   addrs;
> > > +                               __aligned_u64   cookies;
> >
> > looks a bit weird to change layout of UAPI. That's not really a
> > problem, because both patches will land at the same time. But if you
> > move flags and cnt to the front of the struct it would a bit better.
>
> I was following your previous comment:
>   https://lore.kernel.org/bpf/CAEf4BzbPeQbURZOD93TgPudOk3JD4odsZ9uwriNkrphes9V4dg@mail.gmail.com/
>

yeah, I didn't anticipate the cookies change at that time, but now it
became obvious

> I like the idea that syms/addrs/cookies stay together,
> because they are all related to cnt.. but yes, it's
> 'breaking' KABI in between these patches
>
> jirka
>
> >
> >
> > >                                 __u32           cnt;
> > >                                 __u32           flags;
> > >                         } kprobe_multi;
> > > --
> > > 2.35.1
> > >
