Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5090D67FF
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388126AbfJNRIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:08:11 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41298 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732046AbfJNRIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:08:11 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so39411126ioj.8;
        Mon, 14 Oct 2019 10:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=h6BPR1BA97p9++a8Txt+LR4LDB6CVhKf78yugbDC77U=;
        b=UTEYJdb3C7SAdoAD08B4nNi0zGmGLGS8bXz/GDLzflF/zHQv7PM/FfSYxhOtg3M+TG
         HewAT0RRfuzE5goTUQjI4pR0BPZ+94yVz5XaQhYQVMHNFVSu6XrEL418ImjUhnJFOtvJ
         YVOW3Chc/Api8Xf8H7kfkGtTGBwJ1vetJh71Gtejb2LlR8M1kv5ZggkRthcwkxxGUzMA
         dIozZTqhAl+djGjMbT8TrQ0lnbDxDRWRbS3Ve81TxX7bxacOEmtXfRfU/IKJh8VYiSFa
         oNL4QLlPkpDc7rMRBGVFoFgAYCLXUu1Tih2WuNWQ5Gu5A0w5GxvDeuVPgOJMbr5P2CM9
         QQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=h6BPR1BA97p9++a8Txt+LR4LDB6CVhKf78yugbDC77U=;
        b=ujmi3IGOpax08TvAQkAfPVSRwcg8zV6Ug0myz4Z+OKXO3uU9X9HQ1HhBSrOsnTkjVD
         IeDSxILSpGClnVTWwtunBt2w6f1j7OCLsB2amTAwYQ6ky9OIYjBSgkI7fxvx8K6rlWo/
         tocoZ0irk9FBxaBl8CYp4O1xqRa3gPJTjfPIkOooylnQs1tw2p5aaUQlMnyqysrkqsAN
         l/IVTlA5bOpI81WM4bJ8MQ0vxygitvGsFwtBQevC2JUiVniWUPqNtjKthjdTz+sibaqt
         zAHJCH36DyA89asKmZWEMrP9IVYSSptnXF96r1pDqoU1kcQa2m7WJJcREsYc3BchQUiB
         8FXA==
X-Gm-Message-State: APjAAAVXJYjbb4NLpN8sc38EhQ2F/iimzGiBW6+/bVl0nPStmK4/jWyF
        AuPrGPqoS4aZCKm39SSmIrY=
X-Google-Smtp-Source: APXvYqx9mp16GBggal25cVYGejE6Az+spTSbPa8M7iARejA1A67TpGUT7wYiD+dhBfoeCClk5QptyA==
X-Received: by 2002:a02:4807:: with SMTP id p7mr38497822jaa.100.1571072889950;
        Mon, 14 Oct 2019 10:08:09 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r12sm1410288ilq.70.2019.10.14.10.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 10:08:09 -0700 (PDT)
Date:   Mon, 14 Oct 2019 10:08:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
In-Reply-To: <87v9srijxa.fsf@toke.dk>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
 <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk>
 <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
 <87o8yqjqg0.fsf@toke.dk>
 <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk>
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> =

> > On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >> =

> >> > Please implement proper indirect calls and jumps.
> >> =

> >> I am still not convinced this will actually solve our problem; but O=
K, I
> >> can give it a shot.
> >
> > If you're not convinced let's talk about it first.
> >
> > Indirect calls is a building block for debugpoints.
> > Let's not call them tracepoints, because Linus banned any discusion
> > that includes that name.
> > The debugpoints is a way for BPF program to insert points in its
> > code to let external facility to do tracing and debugging.
> >
> > void (*debugpoint1)(struct xdp_buff *, int code);
> > void (*debugpoint2)(struct xdp_buff *);
> > void (*debugpoint3)(int len);

I was considering some basic static linking from libbpf side. Something
like,

  bpf_object__link_programs(struct bpf_object *obj1, struct bpf_object *o=
bj2);

This way you could just 'link' in debugpoint{1,2,3} from libbpf before
loading? This would be useful on my side for adding/removing features
and handling different kernel versions. So more generally useful IMO.

We can manage this now but its a bit ugly the above seems nicer to me.
Also not quite as daunting as getting llvm-lld working although that
would also be worth while.

> =

> So how would these work? Similar to global variables (i.e., the loader
> creates a single-entry PROG_ARRAY map for each one)? Presumably with
> some BTF to validate the argument types?
> =

> So what would it take to actually support this? It doesn't quite sound
> trivial to add?
> =

> > Essentially it's live debugging (tracing) of cooperative bpf programs=

> > that added debugpoints to their code.
> =

> Yup, certainly not disputing that this would be useful for debugging;
> although it'll probably be a while before its use becomes widespread
> enough that it'll be a reliable tool for people deploying XDP programs.=
..
> =


I guess linking would be a bit different than tracing. Both seem
useful.

> > Obviously indirect calls can be used for a ton of other things
> > including proper chaing of progs, but I'm convinced that
> > you don't need chaining to solve your problem.
> > You need debugging.
> =

> Debugging is certainly also an area that I want to improve. However, I
> think that focusing on debugging as the driver for chaining programs wa=
s
> a mistake on my part; rudimentary debugging (using a tool such as
> xdpdump) is something that falls out of program chaining, but it's not
> the main driver for it.
> =

> > If you disagree please explain _your_ problem again.
> > Saying that fb katran is a use case for chaining is, hrm, not correct=
.
> =

> I never said Katran was the driver for this. I just used Katran as one
> of the "prior art" examples for my "how are people solving running
> multiple programs on the same interface" survey.
> =

> What I want to achieve is simply the ability to run multiple independen=
t
> XDP programs on the same interface, without having to put any
> constraints on the programs themselves. I'm not disputing that this is
> *possible* to do completely in userspace, I just don't believe the
> resulting solution will be very good. Proper kernel support for indirec=
t
> calls (or just "tail calls that return") may change that; but in any
> case I think I need to go write some userspace code to have some more
> concrete examples to discuss from. So we can come back to the
> particulars once I've done that :)

I was imaging that because you have to develop some sort of coordination
by using linking you could enforce call signatures which would allow
you to drop in any XDP program at a call site as long as it matches the
signature.

> =

> -Toke


