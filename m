Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE34BC4B6
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 03:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbiBSCKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 21:10:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240986AbiBSCKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 21:10:38 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EC95418B;
        Fri, 18 Feb 2022 18:10:21 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 10so8514997plj.1;
        Fri, 18 Feb 2022 18:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+aB/FGXt2XpQqCXbTpQFLvS98YQQn2+KdMWsD6bNbw8=;
        b=G0nXxjMog2ETCRgq7C8oy9WvUASJ+8lR1+OhAWGwaLxorKCuD2ILI8WOWxsD832AAp
         DcmEdyDz7NX/pa0Xy9IGHZzFlIoinWxe4LovIBCAMCAEJcbpdCz19oe1GBLFgYbP0HTh
         bu0V1sx6+J03iQ7PWHeWJ5p/e58XLknvpl5uX1HvzAnjJX9U5qo5EErLJRtsXE/WAO2c
         2IzoefVi25lxzkmP8K1bfkkgdJyV3GCLI0ofbvMOKh69yjBNY8ljB+mhf+EftgZabM39
         LupDYYmn+QvCpCyvVxsmEFWNjHGSr8dE3dePhzHZ4pJCf5CVPO2dCzJ+29YOWx+iQK60
         BTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+aB/FGXt2XpQqCXbTpQFLvS98YQQn2+KdMWsD6bNbw8=;
        b=pHuZdxWDjtqoumFwIK3A7pRhZxaTrPPOaFLFwHqRRFcDW81O1gfRNFjNjIMTuJpBW1
         T9yJ9pW9LkixKL03IKTx0zVEjvHAPr3lxLnWJDV9qB8dM6U9rcO6B30DkMkAfR4NOKz1
         tgecSsaxBkcx46cTd2NyoYKZfOT574vwJ80UXgDgWSNEzE6kqXOkpaGUZXzONiGnqtnj
         JDzWOhYy3d6GVgcv0YkAjEA3PtzHxtjcwuRtWNsWWSKTIMtMJbK0nz/oTPZ4nOgjG0gC
         tlEod5z4xFbHc7r2iX+sZoP6O6hjZXaO6+JbiqRwUlRMy4NnjShC6Kc+osB6VnaI7dQJ
         HtVw==
X-Gm-Message-State: AOAM53307xFNu5UvRx58Aqq8evJAX7hehGKP5omaIJf9c8upEGU2rKyn
        9/2UjYCmc5HlxqAQGBrDLti30+xZoKLDSYIKfzDJa1Hh
X-Google-Smtp-Source: ABdhPJwogpM9kP609BsMhPX4xux9kQv0xcsSfxr3o29faLZkP58pYyGGODASt78M4zuapI9QzCBrxCRVsbe3j8arOug=
X-Received: by 2002:a17:902:76c5:b0:14e:e325:9513 with SMTP id
 j5-20020a17090276c500b0014ee3259513mr9955087plt.55.1645236620285; Fri, 18 Feb
 2022 18:10:20 -0800 (PST)
MIME-Version: 1.0
References: <Yfq+PJljylbwJ3Bf@krava> <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
 <YfvvfLlM1FOTgvDm@krava> <20220204094619.2784e00c0b7359356458ca57@kernel.org>
 <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
 <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org> <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
 <20220203211954.67c20cd3@gandalf.local.home> <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
 <20220204125942.a4bda408f536c2e3248955e1@kernel.org> <Yguo4v7c+3A0oW/h@krava>
 <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com>
 <20220217230357.67d09baa261346a985b029b6@kernel.org> <CAEf4BzYxcSCae=sF3EKNUtLDCZhkhHkd88CEBt4bffzN_AZrDw@mail.gmail.com>
 <20220218130727.51db96861c3e1c79b45daafb@kernel.org>
In-Reply-To: <20220218130727.51db96861c3e1c79b45daafb@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 18 Feb 2022 18:10:08 -0800
Message-ID: <CAADnVQ+eojJ8KMwbieJrtOf7oWPqw7VDYV9EAAWpx3UoFHZFDQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <olsajiri@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
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

On Thu, Feb 17, 2022 at 8:07 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Thu, 17 Feb 2022 14:01:30 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
>
> > > > Is there any chance to support this fast multi-attach for uprobe? If
> > > > yes, we might want to reuse the same link for both (so should we name
> > > > it more generically?
> > >
> > > There is no interface to do that but also there is no limitation to
> > > expand uprobes. For the kprobes, there are some limitations for the
> > > function entry because it needs to share the space with ftrace. So
> > > I introduced fprobe for easier to use.
> > >
> > > > on the other hand BPF program type for uprobe is
> > > > BPF_PROG_TYPE_KPROBE anyway, so keeping it as "kprobe" also would be
> > > > consistent with what we have today).
> > >
> > > Hmm, I'm not sure why BPF made such design choice... (Uprobe needs
> > > the target program.)
> > >
> >
> > We've been talking about sleepable uprobe programs, so we might need
> > to add uprobe-specific program type, probably. But historically, from
> > BPF point of view there was no difference between kprobe and uprobe
> > programs (in terms of how they are run and what's available to them).
> > From BPF point of view, it was just attaching BPF program to a
> > perf_event.
>
> Got it, so that will reuse the uprobe_events in ftrace. But I think
> the uprobe requires a "path" to the attached binary, how is it
> specified?
>
> > > > But yeah, the main question is whether there is something preventing
> > > > us from supporting multi-attach uprobe as well? It would be really
> > > > great for USDT use case.
> > >
> > > Ah, for the USDT, it will be useful. But since now we will have "user-event"
> > > which is faster than uprobes, we may be better to consider to use it.
> >
> > Any pointers? I'm not sure what "user-event" refers to.
>
> Here is the user-events series, which allows user program to define
> raw dynamic events and it can write raw event data directly from
> user space.
>
> https://lore.kernel.org/all/20220118204326.2169-1-beaub@linux.microsoft.com/

Is this a way for user space to inject user bytes into kernel events?
What is the use case?
