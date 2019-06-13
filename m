Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C0A44E44
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfFMVUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:20:23 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37197 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMVUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:20:22 -0400
Received: by mail-pl1-f193.google.com with SMTP id bh12so65741plb.4
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 14:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uSZRQ5JFckbl2yH+4beDjUiPmzf2p41Uo+IA2IwXq+o=;
        b=Fxs9EEjGxpUvaW9DJi6f+WYDmAU/2UQgL/ohdVF8R6qOT/hp+IDyblrZaEVQF/f0mr
         vVS6yWOWujrFEDza45YQLYH6lrNNERrqqjqhywaF1FlliSAdymE1s0NVxuNxxRIN87W8
         lhiIfAKfxYgoXS07cz/xRKWTE77XQ8l+vUgZEurbd5CjYurKNAu36UcPORmUckXhByFa
         UENirVX4oEmG2RAU3XoswvPWj2ZetLGhjFfHkFALAFWz/8DJ+m80cUupM4/D2z6JQv/B
         Fwjr7WEbeIMrOMC8UbH9JMNMIHTG24lW2qUOm/uHZ3tJiaypnloGZrtQ2gBzO8mTe/NB
         DNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uSZRQ5JFckbl2yH+4beDjUiPmzf2p41Uo+IA2IwXq+o=;
        b=GLZJ3FXl03ZvlZ3SsqGE9IINSaKd2n+EU5um8tcxcDleGVW3EOCCRPAI4Xn0BtoB4m
         vYRlOzoOE68wyDLAbJzr/7FU22HaFQI0mSiNI6cZ+GbQjoLXLp3jyQKsD1Gf0kqCMQyz
         XdjWUwYjpIFbVL17Kz4w27xOqsW+VvrfgNjKkruzs/LVoTs+jzsRzlsXT7DxvEJmu2vp
         5LmZhg2jBS1VYmk70gSxAp2N1ty7ABNS9YzKZyD5PxAWrXzZRylFdhY3nLgZq+dU5IWl
         52ztCEsVB4gqciL8EV4fSdw8EebT9A9ucm0o+sLJjW78xBb2fUlFosJlfV/KS7GFvcZV
         w9Qg==
X-Gm-Message-State: APjAAAVKtLGB6nS1nH/6ucAkwEUYDxNtfhsy1plEo/OpMEUcEnbmVG4g
        6H+h1zYMhRWMEUlGtdTrv2yw7w==
X-Google-Smtp-Source: APXvYqyTsrHFm1KThlgoKTCyn6j+PWJEer+sJ0ZKrUjVNbokFLpvczwxibqDiz57y8cL6Bc7aXrj1w==
X-Received: by 2002:a17:902:2a26:: with SMTP id i35mr50891578plb.315.1560460821708;
        Thu, 13 Jun 2019 14:20:21 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id a12sm707942pgq.0.2019.06.13.14.20.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 14:20:20 -0700 (PDT)
Date:   Thu, 13 Jun 2019 14:20:20 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Martin Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190613212020.GB9636@mini-arch>
References: <20190610210830.105694-1-sdf@google.com>
 <20190610210830.105694-2-sdf@google.com>
 <20190613201632.t7npizqhtnohzwmc@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613201632.t7npizqhtnohzwmc@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/13, Alexei Starovoitov wrote:
> C based example doesn't use ret=1.
> imo that's a sign that something is odd in the api.
I decided not to test ret=1 it because there are tests in the test_sockopt.c
for ret=1 usecase. But I can certainly extend C based test to cover
ret=1 as well. I agree that C based test can be used as an example,
will extend that to cover ret=0/1/2.

> In particular ret=1 doesn't prohibit bpf prog to modify the optval.
That's a good point, Martin brought that up as well. We were trying
to remedy it by doing copy_to_user only if any program returned 2 ("BPF
handled that, bypass the kernel"). But I agree, the fact that the prog in
the chain can modify optval and return 1 is suboptimal. Especially if
the previous one filled in some valid data and returned 2.

> Multiple progs can overwrite it and still return 1.
> But that optval is not going to be processed by the kernel.
> Should we do copy_to_user(optval, ctx.optval, ctx.optlen) here
> and let kernel pick it up from there?
I was thinking initially about that, that kernel can "transparently"
modify user buffer and then kernel (or next BPF program in the chain)
can run standard getsockopt on that.

But it sounds a bit complicated and I don't really have a good use case
for that.

> Should bpf prog be allowed to change optlen as well?
> ret=1 would mean that bpf prog did something and needs kernel
> to continue.
> 
> Now consider a sequence of bpf progs.
> Some are doing ret=1. Some others are doing ret=2
> ret=2 will supersede.
> If first executed prog (child in cgroup) did ret=2
> the parent has no way to tell kernel to handle it.
> Even if parent does ret=1, it's effectively ignored.
> Parent can enforce rejection with ret=0, but it's a weird
> discrepancy.
> The rule for cgroup progs was 'all yes is yes, any no is no'.
My canonical example when reasoning about multiple progs was that each one
of them would implement handling for a particular level+optname. So only
a single one form the chain would return 2 or 0, the rest would return 1
without touching the buffer. I can't come up with a good use-case where
two programs in the chain can both return 2 and fill out the buffer.
The majority of the sockopts would still be handled by the kernel,
we'd have only a handful of bpf progs that handle a tiny subset
and delegate the rest to the kernel.

How about we stop further processing as soon as some program in the chain
returned 2? I think that would address most of the concerns?
Maybe, in this case, also stop further processing as soon as
we get ret=0 (EPERM) for consistency?

> So if ret=1 means 'kernel handles it'. Should it be almost
> as strong as 'reject it': any prog doing ret=1 means 'kernel does it'
> (unless some prog did ret=0. then reject it) ?
> if ret=1 means 'bpf did some and needs kernel to continue' that's
> another story.
> For ret=2 being 'bpf handled it completely', should parent overwrite it?
See above, I was thinking the opposite. Treat ret=1 from the BPF
program as "I'm not interested in this level+optname, other BPF
program or kernel should do the job". Essentially, as soon as bpf program
returns 2, that means BPF had consumed the request and no further processing
from neither BPF, nor kernel is requred; we can return to userspace.

There is a problem that some prog in the chain might do some
"background" work and still return 1, but so far I don't see why
that can be useful. The pattern should be: filter the option
you want, handle it, otherwise return 1 to let the other progs/kernel
run.

That BPF_F_ALLOW_MULTI use-case probably deserves another selftest :-/

> May be retval from child prog should be seen by parent prog?
> 
> In some sense kernel can be seen as another bpf prog in a sequence.
> 
> Whatever new behavior is with 3 values it needs to be
> documented in uapi/bpf.h
> We were sloppy with such docs in the past, but that's not
> a reason to continue.
Good point on documenting that, I was trying to document everything
in Documentation/bpf/prog_cgroup_sockopt.rst, uapi/bpf.h seems too
constrained (I didn't find a good place to put that ret 1 vs 2 info).
Do you think having a file under Documentation/ with all the details
is not enough? Where can I put this ret=0/1/2 handing info in the
uapi/bpf.h?
