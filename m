Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BF3D85E7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 04:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbfJPC24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 22:28:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35132 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfJPC24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 22:28:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so13711154pfw.2;
        Tue, 15 Oct 2019 19:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Jm69mMa5/aBKYuDOATPnZC0M6PDEkyeYrzPV6NlHjXI=;
        b=Q/PT6ewAOlSK5TyR09IH/H9qzg13DDYVDNhQ+5huWT5EcyJtK7dtl4vBACt8EcEYLG
         yXgDNxDZb7aZQN6r8Fc19SqYl6qbPCllhfiTjkPMLfKohyoWALI6xtkpflfRw/8kJFax
         ei5jUUTNRPHHZ2BkttXbSG+Vb119TWyealsab1Dhd4AIqRJtn4cGg1zjRW515pSZ9wB1
         n3HyMR6nzAKpSjkKHfEecOxP0cO2+eyyxOlTPqSAfr3HBWZmt/6sbfGhLpDBQy3mGVDB
         byqdjfTpAIhPt0PQbqOn1cbb9zew87Lh2AaNgSrgF4ltIXfseni+P71KVYqIelPUTdGB
         HBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Jm69mMa5/aBKYuDOATPnZC0M6PDEkyeYrzPV6NlHjXI=;
        b=bZmLpVfpbV3PzZpMSBCxhmp8K/s4ByQg+0ZgR2n5XZDP6yFxIP9JfpUs2YzVQTTWGT
         xLfS1vRseT5EJgJVTlvVvuQAGB5+D/ZYNVfoUbKVaAvY4GkyawCfilQpxLixYVNQnwGk
         mvGx4VcOI05/9xiKa4xMvKNyezDk3LHK2CZYmwV/1NXXp5+d4QyzyKvSXgFr80yudQxr
         dAM0jgj6eGdvJCVDPDcRZCAn86dNv2YlgF80YMgBrRDmHZdmkwfQl3DyK+KmwQ36//MK
         Zk2/A71KHvRkf0DeI5nQ94YFkERkE+eoVWIYF6Bmgtq0g7j1cRIVz22GECfjyXw6gqgq
         QSeQ==
X-Gm-Message-State: APjAAAXh/q+MUDy3Daunet/cHljRzK26QTMfsGSp70/ICas1PWWtCPvG
        vLLgl7g8IhhZfDM6sBULzO4=
X-Google-Smtp-Source: APXvYqwI9r1JrmZVeEcedzSXRssum+xrzNpOLpu3fIYfaThZdXkwe3+KednWxoWuHpa2ocYMK09msw==
X-Received: by 2002:a17:90a:858a:: with SMTP id m10mr2057921pjn.128.1571192934703;
        Tue, 15 Oct 2019 19:28:54 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::efaa])
        by smtp.gmail.com with ESMTPSA id f12sm19091989pgo.85.2019.10.15.19.28.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 19:28:53 -0700 (PDT)
Date:   Tue, 15 Oct 2019 19:28:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
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
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
Message-ID: <20191016022849.weomgfdtep4aojpm@ast-mbp>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
 <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk>
 <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
 <87o8yqjqg0.fsf@toke.dk>
 <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87v9srijxa.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 02:35:45PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke Høiland-Jørgensen wrote:
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >> 
> >> > Please implement proper indirect calls and jumps.
> >> 
> >> I am still not convinced this will actually solve our problem; but OK, I
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
> 
> So how would these work? Similar to global variables (i.e., the loader
> creates a single-entry PROG_ARRAY map for each one)? Presumably with
> some BTF to validate the argument types?
> 
> So what would it take to actually support this? It doesn't quite sound
> trivial to add?

Depends on definition of 'trivial' :)
The kernel has a luxury of waiting until clean solution is implemented
instead of resorting to hacks.

> > Essentially it's live debugging (tracing) of cooperative bpf programs
> > that added debugpoints to their code.
> 
> Yup, certainly not disputing that this would be useful for debugging;
> although it'll probably be a while before its use becomes widespread
> enough that it'll be a reliable tool for people deploying XDP programs...

same for any new api.

> > Obviously indirect calls can be used for a ton of other things
> > including proper chaing of progs, but I'm convinced that
> > you don't need chaining to solve your problem.
> > You need debugging.
> 
> Debugging is certainly also an area that I want to improve. However, I
> think that focusing on debugging as the driver for chaining programs was
> a mistake on my part; rudimentary debugging (using a tool such as
> xdpdump) is something that falls out of program chaining, but it's not
> the main driver for it.

xdpdump can be done already the way I suggested without adding new kernel
code and it will work on old-ish kernels. Aside from xdp itself
the other requirement is to have get_fd_by_id sys_bpf command.

> > If you disagree please explain _your_ problem again.
> > Saying that fb katran is a use case for chaining is, hrm, not correct.
> 
> I never said Katran was the driver for this. I just used Katran as one
> of the "prior art" examples for my "how are people solving running
> multiple programs on the same interface" survey.

and they solved it. that's the point.

> What I want to achieve is simply the ability to run multiple independent
> XDP programs on the same interface, without having to put any
> constraints on the programs themselves. I'm not disputing that this is
> *possible* to do completely in userspace, I just don't believe the
> resulting solution will be very good.

What makes me uneasy about the whole push for program chaining
is that tc cls_bpf supported multiple independent programs from day one.
Yet it doesn't help to run two firewalls hooked into tc ingress.
Similarly cgroup-bpf had a ton discussions on proper multi-prog api.
Everyone was eventually convinced that it's flexible and generic.
Yet people who started to use it complain that it's missing features
to make it truly usable in production.
Tracing is the only bit where multi-prog works.
Because kernel always runs all programs there.
If we could use PROG_RUN_ARRAY for XDP that could have been a solution.
But we cannot. Return codes matter for XDP.

