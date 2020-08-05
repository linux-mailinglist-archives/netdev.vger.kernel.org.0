Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A1623D408
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHEWuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 18:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHEWuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 18:50:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0304C061574;
        Wed,  5 Aug 2020 15:50:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id x6so10420718pgx.12;
        Wed, 05 Aug 2020 15:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vj9AUo1zpNQ5RuH9pFdCoBk8bA+DrgMBZZmQXR9xOD8=;
        b=MnrfV5sDmox75nbL/EDwsBfnjbjk4wXfaW38MnNMWcBe/rvK0oLdauM3j4zaPvRezZ
         V2z86kueOxOfTJh5eQIZ/xtfs4AidyIAwpzIJv5DxVn9IZMMnNeRZa6PucxRepTLw5XG
         fRz0eaYQ60VEfilOViLIaNcKlxkqwrWsaoL2Fpii1kIB9ltrVGagU51uh386AQu0nHOL
         1bwo1DZc2Dhch3cVLdEmdXSjJ2a5YhnR4Ch6JAgtWwmboNqv8HGxlKwAgu2lCoStwCnD
         b8P0gb7mgVkVNdEzhbR1MMTwdGJYjLIFWaWmSWS15K3m1+WaTnIX2kFJBHgrefcH8BU/
         I82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vj9AUo1zpNQ5RuH9pFdCoBk8bA+DrgMBZZmQXR9xOD8=;
        b=jfGEkPKNy3IAeMYAx320QmgHq4Y0FI1015lW9Jt60LenwAozt96zHSKsSqpsbCcBll
         VWqBWArqDXH750qhER/D7PFSxN3Wk+XNdITQ37feE+S7szpnfTeA8VaSLhE7zjTAKfJa
         AoOFkMmKJE29aNaSJCHRn6bx6ANHZHfAH6pbcgVjGwkD641FP83uhxwTPyxJBJWLKy6U
         Nt3KrL/KuS4NCGI3aoQ0uGgGyX+04MQWXY1TCEp2fS2QlpjTr5Y6UgVae6MfxDlr5tZy
         7mEcE/U3XsjZm4z5cEkiuk103eTk1C7zz6d1h7yvLJm8C3hYaKGasrQzH02QVpndSM3p
         H3gg==
X-Gm-Message-State: AOAM533a4LZf/bvLDm/doLkLUGK/n80n6VPUqSPzVJa7EAnRLM6Drfev
        4REyepdFA6RxpIe2/uxng88=
X-Google-Smtp-Source: ABdhPJxBt3cAwNTqbiQptRNm2RKUT8txQ2j3cJfjVsGIP+XbaA3iJlUnkY1SCFLE8odILc2Q4V82Zw==
X-Received: by 2002:a63:ec06:: with SMTP id j6mr4752828pgh.328.1596667818628;
        Wed, 05 Aug 2020 15:50:18 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:634])
        by smtp.gmail.com with ESMTPSA id a17sm4489949pgi.26.2020.08.05.15.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 15:50:17 -0700 (PDT)
Date:   Wed, 5 Aug 2020 15:50:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <20200805225015.kd4tx6w3wh67oara@ast-mbp.dhcp.thefacebook.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com>
 <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
 <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com>
 <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
 <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
 <31754A5F-AD12-44D2-B80A-36638684C2CE@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31754A5F-AD12-44D2-B80A-36638684C2CE@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 06:56:26PM +0000, Song Liu wrote:
> 
> 
> > On Aug 5, 2020, at 10:16 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Wed, Aug 05, 2020 at 04:47:30AM +0000, Song Liu wrote:
> >> 
> >> Being able to trigger BPF program on a different CPU could enable many
> >> use cases and optimizations. The use case I am looking at is to access
> >> perf_event and percpu maps on the target CPU. For example:
> >> 	0. trigger the program
> >> 	1. read perf_event on cpu x;
> >> 	2. (optional) check which process is running on cpu x;
> >> 	3. add perf_event value to percpu map(s) on cpu x. 
> > 
> > If the whole thing is about doing the above then I don't understand why new
> > prog type is needed.
> 
> I was under the (probably wrong) impression that adding prog type is not
> that big a deal. 

Not a big deal when it's necessary.

> > Can prog_test_run support existing BPF_PROG_TYPE_KPROBE?
> 
> I haven't looked into all the details, but I bet this is possible.
> 
> > "enable many use cases" sounds vague. I don't think folks reading
> > the patches can guess those "use cases".
> > "Testing existing kprobe bpf progs" would sound more convincing to me.
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
> > Something like fentry/fexit may be better, since verifier check_return_code()
> > enforces 'return 0'. So their return value is effectively "void".
> > Then prog_test_run would need to gain an ability to trigger
> > fentry/fexit prog on a given cpu.
> 
> Maybe we add a new attach type for BPF_PROG_TYPE_TRACING, which is in 
> parallel with BPF_TRACE_FENTRY and BPF_TRACE_EXIT? Say BPF_TRACE_USER? 
> (Just realized I like this name :-D, it matches USDT...). Then we can 
> enable test_run for most (if not all) tracing programs, including
> fentry/fexit. 

Why new hook? Why prog_test_run cmd cannot be made to work
BPF_PROG_TYPE_TRACING when it's loaded as BPF_TRACE_FENTRY and attach_btf_id
points to special test function?
The test_run cmd will trigger execution of that special function.
Devil is in details of course. How attach, trampoline, etc going to work
that all needs to be figured out. Parallel test_run cmd ideally shouldn't
affect each other, etc.
