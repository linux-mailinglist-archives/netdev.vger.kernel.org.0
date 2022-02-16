Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882B24B9031
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbiBPS1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:27:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiBPS1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:27:44 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A974C2E78;
        Wed, 16 Feb 2022 10:27:32 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id f13so449418ilq.5;
        Wed, 16 Feb 2022 10:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cOcn/3/cCrzj4+eIAU0TlZEiW9Bi0T8velPLnnoMOp0=;
        b=jOM726r1yxEA2eI2TR0QzX0YLb9iOufgfJvh4rq/1h4SoZupiLLygPCjLAXSAthCoL
         IjD02c3rvV0JyCS3PqSRNLvfwNaWi7Jep1fksNnvVm7XuVjlRpRCd8qmxyw0Zpk5Nf21
         UOk5hYAysOfiVCyEhBmeLsUC6CsqitTYndFgTQfAOzw27qLWTRicHkxI9PjHvJrB6swF
         LWaOI21XTxT6Fmz9Ij3mcqxUZYcnn0+59fA8L6aZ6M8kbEj69gMF5lgf7msjTgsKtGmT
         u1p+fGNCkY82lE+V0fQViponTbd2A2Hm0+u95UWN6F30EoY6etJcH6+sf8Cne8jkiZWq
         Pavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cOcn/3/cCrzj4+eIAU0TlZEiW9Bi0T8velPLnnoMOp0=;
        b=yDJehPgOOD1ImKncK6sz5xxBqI1DmBq8Bk0HPsVBKhwmUwEffiEzbiikQIPhZMVPnT
         Av9ZdSB2UkUxUw3kzVIcKhywP11Z5XhKalVO5c+bIimZjD8ixpXdRckWwSJkMKXRiDgZ
         8JYXAK4v7qsQabZEpTA0vfruYcIVeNYEbhbdTC1D6/oG/y1PDe000C9WHqrQefm4lnrK
         mgLOFGA8lgMG2+kVydvj+UQJvnvnPk4S2Z87mUeTjrWS3r2KlZQab4r2yb1V5Lv3Ocsc
         sc40MI2oYNR7bhacrxvF2iPkcFPsXevbR7Pgr+w4rjP7Prz6/+ts9KPUVUHAPw/OCXva
         1Sjw==
X-Gm-Message-State: AOAM530+xghtXJqKMnMXddN5lQqnbUTY93bqjFPg8epljI476xPVnvXn
        vmnDBYbuT8+ydtSt+RI2cJUe2qIm1NDW4iIjzwE=
X-Google-Smtp-Source: ABdhPJz03m6QSAKciXBJlhqx6g/VA+DU1qsNokOaIwc7qNLUgzmEV9FgtdX5O9XGnzAxX2JjwVYNY08XcmDKePbY5GA=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr2561159ilb.305.1645036051512; Wed, 16
 Feb 2022 10:27:31 -0800 (PST)
MIME-Version: 1.0
References: <Yfq+PJljylbwJ3Bf@krava> <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
 <YfvvfLlM1FOTgvDm@krava> <20220204094619.2784e00c0b7359356458ca57@kernel.org>
 <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
 <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org> <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
 <20220203211954.67c20cd3@gandalf.local.home> <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
 <20220204125942.a4bda408f536c2e3248955e1@kernel.org> <Yguo4v7c+3A0oW/h@krava>
In-Reply-To: <Yguo4v7c+3A0oW/h@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Feb 2022 10:27:19 -0800
Message-ID: <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

On Tue, Feb 15, 2022 at 5:21 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Fri, Feb 04, 2022 at 12:59:42PM +0900, Masami Hiramatsu wrote:
> > Hi Alexei,
> >
> > On Thu, 3 Feb 2022 18:42:22 -0800
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > > On Thu, Feb 3, 2022 at 6:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > >
> > > > On Thu, 3 Feb 2022 18:12:11 -0800
> > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > > > No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> > > > > > transparently.
> > > > >
> > > > > Not true.
> > > > > fprobe is nothing but _explicit_ kprobe on ftrace.
> > > > > There was an implicit optimization for kprobe when ftrace
> > > > > could be used.
> > > > > All this new interface is doing is making it explicit.
> > > > > So a new name is not warranted here.
> > > > >
> > > > > > from that viewpoint, fprobe and kprobe interface are similar but different.
> > > > >
> > > > > What is the difference?
> > > > > I don't see it.
> > > >
> > > > IIUC, a kprobe on a function (or ftrace, aka fprobe) gives some extra
> > > > abilities that a normal kprobe does not. Namely, "what is the function
> > > > parameters?"
> > > >
> > > > You can only reliably get the parameters at function entry. Hence, by
> > > > having a probe that is unique to functions as supposed to the middle of a
> > > > function, makes sense to me.
> > > >
> > > > That is, the API can change. "Give me parameter X". That along with some
> > > > BTF reading, could figure out how to get parameter X, and record that.
> > >
> > > This is more or less a description of kprobe on ftrace :)
> > > The bpf+kprobe users were relying on that for a long time.
> > > See PT_REGS_PARM1() macros in bpf_tracing.h
> > > They're meaningful only with kprobe on ftrace.
> > > So, no, fprobe is not inventing anything new here.
> >
> > Hmm, you may be misleading why PT_REGS_PARAM1() macro works. You can use
> > it even if CONFIG_FUNCITON_TRACER=n if your kernel is built with
> > CONFIG_KPROBES=y. It is valid unless you put a probe out of function
> > entry.
> >
> > > No one is using kprobe in the middle of the function.
> > > It's too difficult to make anything useful out of it,
> > > so no one bothers.
> > > When people say "kprobe" 99 out of 100 they mean
> > > kprobe on ftrace/fentry.
> >
> > I see. But the kprobe is kprobe. It is not designed to support multiple
> > probe points. If I'm forced to say, I can rename the struct fprobe to
> > struct multi_kprobe, but that doesn't change the essence. You may need
> > to use both of kprobes and so-called multi_kprobe properly. (Someone
> > need to do that.)
>
> hi,
> tying to kick things further ;-) I was thinking about bpf side of this
> and we could use following interface:
>
>   enum bpf_attach_type {
>     ...
>     BPF_TRACE_KPROBE_MULTI
>   };
>
>   enum bpf_link_type {
>     ...
>     BPF_LINK_TYPE_KPROBE_MULTI
>   };
>
>   union bpf_attr {
>
>     struct {
>       ...
>       struct {
>         __aligned_u64   syms;
>         __aligned_u64   addrs;
>         __aligned_u64   cookies;
>         __u32           cnt;
>         __u32           flags;
>       } kprobe_multi;
>     } link_create;
>   }
>
> because from bpf user POV it's new link for attaching multiple kprobes
> and I agree new 'fprobe' type name in here brings more confusion, using
> kprobe_multi is straightforward
>
> thoguhts?

I think this makes sense. We do need new type of link to store ip ->
cookie mapping anyways.

Is there any chance to support this fast multi-attach for uprobe? If
yes, we might want to reuse the same link for both (so should we name
it more generically? on the other hand BPF program type for uprobe is
BPF_PROG_TYPE_KPROBE anyway, so keeping it as "kprobe" also would be
consistent with what we have today).

But yeah, the main question is whether there is something preventing
us from supporting multi-attach uprobe as well? It would be really
great for USDT use case.

>
> thanks,
> jirka
