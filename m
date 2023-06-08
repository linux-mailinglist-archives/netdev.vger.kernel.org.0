Return-Path: <netdev+bounces-9382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB971728A36
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4FB21C21051
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D5834CE4;
	Thu,  8 Jun 2023 21:25:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ACA2D279;
	Thu,  8 Jun 2023 21:25:02 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6D82D51;
	Thu,  8 Jun 2023 14:25:00 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-977c89c47bdso195217266b.2;
        Thu, 08 Jun 2023 14:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686259499; x=1688851499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6hC2dHqFlK9hnqWGu/Mm586Qh7RRYwrMorqiQE0m4Y=;
        b=gVhhBEApIuyqWd5fVVm3w2yNexpC5jMyQj496KgFHBKuCKHTU8M7K+1UYTPSra8wH0
         d1LCQMO9nguY+coR0zIUbVP3zTq54Wihq0mEpDcJFweTHW80hN+es09ugh0/9sotOlCr
         39MJlzkZcNgAaizZ7nJAuiryx/V0n7AoPRYL4HPbyBYU1uJztbkgww83UxP3YFXq77Cz
         282ikGvgbUEMiABBnqzF+Ce9eSkPzOJnDmdhztE4HQEqjZqp7aEQ46q9rrw2iXgg/yro
         BHWa8KBZ3WeRNlU+28A5D/HXpyc+MisJqV7Qqgqw5YpXfbjQ9zu7/gnokUAAk4sLFk47
         VS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686259499; x=1688851499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M6hC2dHqFlK9hnqWGu/Mm586Qh7RRYwrMorqiQE0m4Y=;
        b=E38XElyAbqDRAa8A05pDmpQbQa6DIl9Khuvog7Qgd2nDPug6Gq01ZiX96qViJLJohD
         mvEDkw/LH9V03ij592CZwW6IJADXurkoz6ZNrIBXSgSLNQ4tQ3dBho+FaWpz8TDX1D35
         XLGhUKYH+fAzBRm8dwr18O8KI+cs6OGoWZb8IG6/+OD+E4HrcqVzy0AUxfYiQQN7yHJv
         qbmjZlITohF0der8hYwyivgyXancJj/mWwrkcbb8zXBVdJpzyHqTSkXvfIlwRyQ9VOV1
         hNaLIkvrfWMdSej1hbnlf/znUzQYDttA6/F/bIFbk8ShCywJAGvXtFnYtJoAPiRfUcXu
         8EGQ==
X-Gm-Message-State: AC+VfDy8IcsBNBza2c83qFociR5JZLQCGIfoGL7d5SuO37aVez7Eig4l
	fSXlvCrFzE6plOjXG/lCXG8t/PZyIx6WXF/K280=
X-Google-Smtp-Source: ACHHUZ6cJxZIqXcfqv48eCQDHxhx3sr3GFRrt0cldq5PK75qKB6W0Wjxs9Q8CstXf6Euj76Yis1Y+FglKy/BRts4YRA=
X-Received: by 2002:a17:907:3f22:b0:974:6390:40a8 with SMTP id
 hq34-20020a1709073f2200b00974639040a8mr305116ejc.71.1686259499079; Thu, 08
 Jun 2023 14:24:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-3-daniel@iogearbox.net>
 <CAM0EoMm25tdjxp+7Mq4fowGfCJzFRhbThHhaO7T_46vNJ9y-NQ@mail.gmail.com>
 <fe2e13a6-1fb6-c160-1d6f-31c09264911b@iogearbox.net> <CAM0EoM=FFsTNNKaMbRtuRxc8ieJgDFsBifBmZZ2_67u5=+-3BQ@mail.gmail.com>
In-Reply-To: <CAM0EoM=FFsTNNKaMbRtuRxc8ieJgDFsBifBmZZ2_67u5=+-3BQ@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 14:24:47 -0700
Message-ID: <CAEf4BzbuzNw4gRXSSDoHTwGH82moaSWtaX1nvmUAVx4+OgaEyw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/7] bpf: Add fd-based tcx multi-prog infra
 with link support
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org, andrii@kernel.org, 
	martin.lau@linux.dev, razor@blackwall.org, sdf@google.com, 
	john.fastabend@gmail.com, kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io, 
	toke@kernel.org, davem@davemloft.net, bpf@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 12:46=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> Hi Daniel,
>
> On Thu, Jun 8, 2023 at 6:12=E2=80=AFAM Daniel Borkmann <daniel@iogearbox.=
net> wrote:
> >
> > Hi Jamal,
> >
> > On 6/8/23 3:25 AM, Jamal Hadi Salim wrote:
> > [...]
> > > A general question (which i think i asked last time as well): who
> > > decides what comes after/before what prog in this setup? And would
> > > that same entity not have been able to make the same decision using t=
c
> > > priorities?
> >
> > Back in the first version of the series I initially coded up this optio=
n
> > that the tc_run() would basically be a fake 'bpf_prog' and it would hav=
e,
> > say, fixed prio 1000. It would get executed via tcx_run() when iteratin=
g
> > via bpf_mprog_foreach_prog() where bpf_prog_run() is called, and then u=
sers
> > could pick for native BPF prio before or after that. But then the feedb=
ack
> > was that sticking to prio is a bad user experience which led to the
> > development of what is in patch 1 of this series (see the details there=
).
> >
>
> Thanks. I read the commit message in patch 1 and followed the thread
> back including some of the discussion we had and i am still
> disagreeing that this couldnt be solved with a smart priority based
> scheme - but i think we can move on since this is standalone and
> doesnt affect tc.
>
> Daniel - i am still curious in the new scheme of things how would
> cilium vs datadog food fight get resolved without some arbitration
> entity?
>
> > > The idea of protecting programs from being unloaded is very welcome
> > > but feels would have made sense to be a separate patchset (we have
> > > good need for it). Would it be possible to use that feature in tc and
> > > xdp?
> > BPF links are supported for XDP today, just tc BPF is one of the few
> > remainders where it is not the case, hence the work of this series. Wha=
t
> > XDP lacks today however is multi-prog support. With the bpf_mprog conce=
pt
> > that could be addressed with that common/uniform api (and Andrii expres=
sed
> > interest in integrating this also for cgroup progs), so yes, various ho=
ok
> > points/program types could benefit from it.
>
> Is there some sample XDP related i could look at?  Let me describe our
> use case: lets say we load an ebpf program foo attached to XDP of a
> netdev  and then something further upstream in the stack is consuming
> the results of that ebpf XDP program. For some reason someone, at some
> point, decides to replace the XDP prog with a different one - and the
> new prog does a very different thing. Could we stop the replacement
> with the link mechanism you describe? i.e the program is still loaded
> but is no longer attached to the netdev.

If you initially attached an XDP program using BPF link api
(LINK_CREATE command in bpf() syscall), then subsequent attachment to
the same interface (of a new link or program with BPF_PROG_ATTACH)
will fail until the current BPF link is detached through closing its
last fd.

That is, until we allow multiple attachments of XDP programs to the
same network interface. But even then, no one will be able to
accidentally replace attached link, unless they have that link FD and
replace underlying BPF program.

>
>
> > >> +struct tcx_entry {
> > >> +       struct bpf_mprog_bundle         bundle;
> > >> +       struct mini_Qdisc __rcu         *miniq;
> > >> +};
> > >> +
> > >
> > > Can you please move miniq to the front? From where i sit this looks:
> > > struct tcx_entry {
> > >          struct bpf_mprog_bundle    bundle
> > > __attribute__((__aligned__(64))); /*     0  3264 */
> > >
> > >          /* XXX last struct has 36 bytes of padding */
> > >
> > >          /* --- cacheline 51 boundary (3264 bytes) --- */
> > >          struct mini_Qdisc *        miniq;                /*  3264   =
  8 */
> > >
> > >          /* size: 3328, cachelines: 52, members: 2 */
> > >          /* padding: 56 */
> > >          /* paddings: 1, sum paddings: 36 */
> > >          /* forced alignments: 1 */
> > > } __attribute__((__aligned__(64)));
> > >
> > > That is a _lot_ of cachelines - at the expense of the status quo
> > > clsact/ingress qdiscs which access miniq.
> >
> > Ah yes, I'll fix this up.
>
> Thanks.
>
> cheers,
> jamal
> > Thanks,
> > Daniel

