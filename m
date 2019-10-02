Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2FC9297
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 21:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfJBTqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 15:46:48 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38104 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfJBTqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 15:46:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id x10so142304pgi.5;
        Wed, 02 Oct 2019 12:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=5+GW+tww4QM0bMM2ZTZ5j6lLbYkma6vdUWKxb+yyOgM=;
        b=H/iXn7akoCcstnmqXT/xMNVw8gZInuPIiRN4pUZs60+YqIulznWrcfMYZippO4/gUx
         cYmoWLehOSMym5maLB+zPUG01uyifVZtDC0iKgPrdIOLphUAS/6/XlpXy2DmvwG7HsZI
         XeRMiK/MeUG63aqQb7Sc2g1JPUf6FlhqkWj8BK0TlhY3Y9p8+zOe1enhhfXNJFoyDzv4
         NNn6XeA6WujhhdjbvEWdzRuo7NdrCWI6230DEBOtNfmnNNCfu5XvX3aoqOAXfJiFdNl0
         sR2Y1WTs4ykHecvK5MPqKPvsqJCv52YfybFgNNGYZsMY4Nwo5peEGySGIgM7JkLD4pGR
         jFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=5+GW+tww4QM0bMM2ZTZ5j6lLbYkma6vdUWKxb+yyOgM=;
        b=oCHY6r5jTR50dXmUZfqiwet3kAdn+75fE+7ST6iCEXi9QGdIKINHmCPgXEj9mK8F0/
         J1Wz5TAtoVAugOpMinesIyGiNziBlkqDIzZcwjrAE5Vn2haOTpjwM2qap7LoqJRSK+Ph
         nPe+jlC2kKA2hyuH39/qfvCk1tooGKhRo8TKVrD+tUeBNVyEeCtm471mQm6GHLKucy35
         7MvMCPUUEIwcpaXHvYOA+UKdiV7ZVBGC0qyK3UTtqQ3TSxVVzK/b/+7fBF/NZBLYlZE+
         3Jd4m59dj2yEu/NluJYZUAt13R9k+Af+wUfbwjk/iETc9W6W1Fj3zlva0+Guo6ruPKfV
         5JTA==
X-Gm-Message-State: APjAAAUG7MvOoYGZgAzHS3Pnp9VTOvTc6EAlHUJSkrLXrJgHPAzPJvH4
        1Ehn4BFuXCKVhSiHNB0QaUw=
X-Google-Smtp-Source: APXvYqwMhwTdqNX6vhtaDzVbx2FQFgV7e2SBiKFXOvamb8WPuH4FHPokN4L1SdMZqJIM2xxTmQuphA==
X-Received: by 2002:a62:ac02:: with SMTP id v2mr6413074pfe.109.1570045606830;
        Wed, 02 Oct 2019 12:46:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:2790])
        by smtp.gmail.com with ESMTPSA id b123sm203697pgc.72.2019.10.02.12.46.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 12:46:45 -0700 (PDT)
Date:   Wed, 2 Oct 2019 12:46:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Message-ID: <20191002194642.e77o45odwth5gil7@ast-mbp.dhcp.thefacebook.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <5d94d3c5a238f_22502b00ea21a5b4e9@john-XPS-13-9370.notmuch>
 <20191002191522.GA9196@pc-66.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191002191522.GA9196@pc-66.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 09:15:22PM +0200, Daniel Borkmann wrote:
> On Wed, Oct 02, 2019 at 09:43:49AM -0700, John Fastabend wrote:
> > Toke Høiland-Jørgensen wrote:
> > > This series adds support for executing multiple XDP programs on a single
> > > interface in sequence, through the use of chain calls, as discussed at the Linux
> > > Plumbers Conference last month:
> > > 
> > > https://linuxplumbersconf.org/event/4/contributions/460/
> > > 
> > > # HIGH-LEVEL IDEA
> > > 
> > > The basic idea is to express the chain call sequence through a special map type,
> > > which contains a mapping from a (program, return code) tuple to another program
> > > to run in next in the sequence. Userspace can populate this map to express
> > > arbitrary call sequences, and update the sequence by updating or replacing the
> > > map.
> > > 
> > > The actual execution of the program sequence is done in bpf_prog_run_xdp(),
> > > which will lookup the chain sequence map, and if found, will loop through calls
> > > to BPF_PROG_RUN, looking up the next XDP program in the sequence based on the
> > > previous program ID and return code.
> > > 
> > > An XDP chain call map can be installed on an interface by means of a new netlink
> > > attribute containing an fd pointing to a chain call map. This can be supplied
> > > along with the XDP prog fd, so that a chain map is always installed together
> > > with an XDP program.
> > > 
> > > # PERFORMANCE
> > > 
> > > I performed a simple performance test to get an initial feel for the overhead of
> > > the chain call mechanism. This test consists of running only two programs in
> > > sequence: One that returns XDP_PASS and another that returns XDP_DROP. I then
> > > measure the drop PPS performance and compare it to a baseline of just a single
> > > program that only returns XDP_DROP.
> > > 
> > > For comparison, a test case that uses regular eBPF tail calls to sequence two
> > > programs together is also included. Finally, because 'perf' showed that the
> > > hashmap lookup was the largest single source of overhead, I also added a test
> > > case where I removed the jhash() call from the hashmap code, and just use the
> > > u32 key directly as an index into the hash bucket structure.
> > > 
> > > The performance for these different cases is as follows (with retpolines disabled):
> > 
> > retpolines enabled would also be interesting.
> > 
> > > 
> > > | Test case                       | Perf      | Add. overhead | Total overhead |
> > > |---------------------------------+-----------+---------------+----------------|
> > > | Before patch (XDP DROP program) | 31.0 Mpps |               |                |
> > > | After patch (XDP DROP program)  | 28.9 Mpps |        2.3 ns |         2.3 ns |
> > 
> > IMO even 1 Mpps overhead is too much for a feature that is primarily about
> > ease of use. Sacrificing performance to make userland a bit easier is hard
> > to justify for me when XDP _is_ singularly about performance. Also that is
> > nearly 10% overhead which is fairly large. So I think going forward the
> > performance gab needs to be removed.
> 
> Fully agree, for the case where this facility is not used, it must have
> *zero* overhead. This is /one/ map flavor, in future there will be other
> facilities with different use-cases, but we cannot place them all into
> the critical fast-path. Given this is BPF, we have the flexibility that
> this can be hidden behind the scenes by rewriting and therefore only add
> overhead when used.
> 
> What I also see as a red flag with this proposal is the fact that it's
> tied to XDP only because you need to go and hack bpf_prog_run_xdp() all
> the way to fetch xdp->rxq->dev->xdp_chain_map even though the map/concept
> itself is rather generic and could be used in various other program types
> as well. I'm very sure that once there, people would request it. Therefore,
> better to explore a way where this has no changes to BPF_PROG_RUN() similar
> to the original tail call work.

two +1s.

1. new features have to have zero overhead when not used. this is not negotiable.
2. prog chaining is not xdp specific.

two years ago I was thinking about extending tail_call mechanism like this:
https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/commit/?h=prog_chain&id=f54f45d00f91e083f6aec2abe35b6f0be52ae85b

and the program would call the new helper 'bpf_tail_call_next()' to jump
into the next program.
Sample code is here:
https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/commit/?h=prog_chain&id=933a93208f1bd60a9707dc3f51a9aa457c86be87

In my benchmarks it was faster than existing bpf_tail_call via prog_array.
(And fit the rule of zero overhead when not used).

While coding it I figured that we can do proper indirect calls instead,
which would be even cleaner solution.
It would support arbitrary program chaining and calling.

The verifier back then didn't have enough infra to support indirect calls.
I suggest to look into implementing indirect calls instead of hacking
custom prog chaining logic via maps.

