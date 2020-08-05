Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A22A23CF70
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgHETUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgHERrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:47:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0875C06179E;
        Wed,  5 Aug 2020 10:45:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so24880229pgq.1;
        Wed, 05 Aug 2020 10:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HFuNCX7vqXeZP0x+Utx9kB2XZUBqZjp8rc7Bdm45/qU=;
        b=tT0P2gfIBM66/aJTeoG1Ry7EK5FwTaNH/hlK9HkMVvLN+kVAmmhOdPAi8ELLHeEDCU
         0KXraLAtr1n8NyIr/QEri23c7DWrpESf+63g9VTADVPubl7bW1Z+EP6v1tlSB/1JfTXO
         R2Ee3Q9xlZZBppnEA29QGNXWPd0zDiCL+Bapiw+xtI6AI2WQ+U8EN9bp9+EIOmYICacP
         LLjt8e6wVyuUViQDMPBq5A0c2uHfEujrgGYPHh7CFpvTFAwqPYkZ3bHCARgdKHyEPw8Y
         7asQguu96AFxxFYEsEFKKyTL1HTZRj5YaEsbWrkd1zij4iO1vMkPYzPBe21ixFgCrxOR
         OsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HFuNCX7vqXeZP0x+Utx9kB2XZUBqZjp8rc7Bdm45/qU=;
        b=MUK8EN+2eKUV9r6eUZYE6/NCxU6rJnGjxSs8uxVsVwRgeU/1RykwUOEfnvZvxwkHNA
         4I2BD2cAkz8lpGI9vJFoUtrz8kR4hSL2VHYeJWdocuHsWBXU2teOsliHSqoP6GHunQKT
         qm0CvUDYRh8PHjMkw3ZjWQWDNuqSThUzmgetIv5xhEg8QvBkHE4V+umz8cQyzwdQI7CS
         MsfctzgwPsFUtlyh684m+aD2B+ruC6tQ5+SeRo8Vt+5uPAYsuMDyC0LUCAgujf5iU5qe
         2lPuw88leEcgkWf3p0bp9SPFQYWHAs8GRWwm4QddBgW4tfvgaIryBkQDu3N+UJFKuDci
         qNAg==
X-Gm-Message-State: AOAM532z17hWDXdNZf6drMYWSgnxsLjcXz0siVdUQHv3nstCZSFzfUCq
        73kaZaChDKbAY1tStxvsMlwWunVQ
X-Google-Smtp-Source: ABdhPJz/iOEFhIC/CFRoJ1NFwM7w82wEaRPvuLiln4IJEueHqgu17lX1jCDSmDaz9r2m2Alk9DYwMw==
X-Received: by 2002:a63:8f08:: with SMTP id n8mr4130648pgd.9.1596649556565;
        Wed, 05 Aug 2020 10:45:56 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:16b0])
        by smtp.gmail.com with ESMTPSA id a2sm4840937pfh.152.2020.08.05.10.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 10:45:54 -0700 (PDT)
Date:   Wed, 5 Aug 2020 10:45:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Message-ID: <20200805174552.56q6eauad7glyzgm@ast-mbp.dhcp.thefacebook.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com>
 <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
 <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com>
 <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
 <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYFfAubxo1QY6Axth=gwS9DfzwRkvnYLspfk9tLia0LPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYFfAubxo1QY6Axth=gwS9DfzwRkvnYLspfk9tLia0LPg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 10:27:28AM -0700, Andrii Nakryiko wrote:
> On Wed, Aug 5, 2020 at 10:16 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Aug 05, 2020 at 04:47:30AM +0000, Song Liu wrote:
> > >
> > > Being able to trigger BPF program on a different CPU could enable many
> > > use cases and optimizations. The use case I am looking at is to access
> > > perf_event and percpu maps on the target CPU. For example:
> > >       0. trigger the program
> > >       1. read perf_event on cpu x;
> > >       2. (optional) check which process is running on cpu x;
> > >       3. add perf_event value to percpu map(s) on cpu x.
> >
> > If the whole thing is about doing the above then I don't understand why new
> > prog type is needed. Can prog_test_run support existing BPF_PROG_TYPE_KPROBE?
> > "enable many use cases" sounds vague. I don't think folks reading
> > the patches can guess those "use cases".
> > "Testing existing kprobe bpf progs" would sound more convincing to me.
> 
> Was just about to propose the same :) I wonder if generic test_run()
> capability to trigger test programs of whatever supported type on a
> specified CPU through IPI can be added. That way you can even use the
> XDP program to do what Song seems to need.
> 
> TRACEPOINTs might also be a good fit here, given it seems simpler to
> let users specify custom tracepoint data for test_run(). Having the
> ability to unit-test KPROBE and TRACEPOINT, however rudimentary, is
> already a big win.
> 
> > If the test_run framework can be extended to trigger kprobe with correct pt_regs.
> > As part of it test_run would trigger on a given cpu with $ip pointing
> > to some test fuction in test_run.c. For local test_run the stack trace
> > would include bpf syscall chain. For IPI the stack trace would include
> > the corresponding kernel pieces where top is our special test function.
> > Sort of like pseudo kprobe where there is no actual kprobe logic,
> > since kprobe prog doesn't care about mechanism. It needs correct
> > pt_regs only as input context.
> > The kprobe prog output (return value) has special meaning though,
> > so may be kprobe prog type is not a good fit.
> 
> It does? I don't remember returning 1 from KPROBE changing anything. I
> thought it's only the special bpf_override_return() that can influence
> the kernel function return result.

See comment in trace_call_bpf().
And logic to handle it in kprobe_perf_func() for kprobes.
and in perf_trace_run_bpf_submit() for tracepoints.
It's historical and Song actually discovered an issue with such behavior.
I don't remember whether we've concluded on the solution.
