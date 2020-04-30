Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36D31BEE47
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgD3CYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3CYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:24:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F24FC035494;
        Wed, 29 Apr 2020 19:24:09 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id z6so1661621plk.10;
        Wed, 29 Apr 2020 19:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xbSIwRPgvresfcrdfxkSpKBG8zf3ZdkCqm3NBkNr4kM=;
        b=Ek1DNVvEsD6S/hoBW1Bdd5sunrCvd16NsNWLRDlYyUPvoatxxY0H7qROatvS16NvTk
         /MdTnaEOoPjrATERIB/8R2UOIkU9zzKmcl4LqKrIb9Hn3q3mh2VllyYiY1LrykjYGfNT
         1cMCPo3tYXOqXVlmOkeBzuZ8Rg3BGeKqsJ8z8RXWIo2tYVSOUYfEBfQEoKZL1yDiHzLs
         ERJEZSDoYlwjWmf1Uaq4dnt4n3NbZ51P5HQAe5RtHh0QNb77O3sbj/M1z/pCCNGYl2+o
         2ucH0Iu7ObvuCMwhj+SqLHV9raTC46eaTzpmCkkeUjZfurFwJfIL29am4s6c5p/yVS9V
         kwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xbSIwRPgvresfcrdfxkSpKBG8zf3ZdkCqm3NBkNr4kM=;
        b=Sovh4kI+d4WhdzpFGXvee8Bxftfrhug8+E6uXqP2MR1Q5/nCG12QPegD6URlKXUiZE
         CNedzSh4UTJEm/ca3N8zdWOPDRNvfVKyQAWql55ktQMCZO67aPFF/tw0YBq7BOCwKw3l
         syzPmVU3KwMLeEggZfhs4HZ0s0TGd0YzX/u56tZgl+GxoHBXY93iR911WmItFgQIODT2
         45QPM6JVTXdCVr0PZBQQqPflhE5KQb/igWKZx/R1p/KSipVo2eAQTx3Rnco5EBGx5x8n
         G5Y2gFbKZg7sNOlvolRNhz6UBQK8zkC0A4lCg8ijeilWUZSpjM1yHfryJ1bQl4eqHIan
         AF+g==
X-Gm-Message-State: AGi0PuZ5Q9oE1lD145Lb+A9bwOF3PQ26DLBstH6Svdr14XA3kq5aGzZI
        cBNg2MUnNc/uU89Aem80yrQ=
X-Google-Smtp-Source: APiQypL3eMs7VgBGNkhIfVUiFWPQ69gegiWeBI5PDPanJ1CKBpYB0gCyeGlmKToul3AazT9OguebQA==
X-Received: by 2002:a17:902:b58a:: with SMTP id a10mr1461251pls.129.1588213448969;
        Wed, 29 Apr 2020 19:24:08 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:39f2])
        by smtp.gmail.com with ESMTPSA id d20sm1963094pgl.72.2020.04.29.19.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 19:24:08 -0700 (PDT)
Date:   Wed, 29 Apr 2020 19:24:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     sdf@google.com
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2] bpf: bpf_{g,s}etsockopt for struct bpf_sock
Message-ID: <20200430022405.55gt7v3y7ckdkepx@ast-mbp.dhcp.thefacebook.com>
References: <20200429170524.217865-1-sdf@google.com>
 <640e7fd3-4059-5ff8-f9ed-09b1becd0f7b@iogearbox.net>
 <20200429233312.GB241848@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429233312.GB241848@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 04:33:12PM -0700, sdf@google.com wrote:
> On 04/30, Daniel Borkmann wrote:
> > On 4/29/20 7:05 PM, Stanislav Fomichev wrote:
> > > Currently, bpf_getsocktop and bpf_setsockopt helpers operate on the
> > > 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> > > Let's generalize them and make the first argument be 'struct bpf_sock'.
> > > That way, in the future, we can allow those helpers in more places.
> > >
> > > BPF_PROG_TYPE_SOCK_OPS still has the existing helpers that operate
> > > on 'struct bpf_sock_ops', but we add new bpf_{g,s}etsockopt that work
> > > on 'struct bpf_sock'. [Alternatively, for BPF_PROG_TYPE_SOCK_OPS,
> > > we can enable them both and teach verifier to pick the right one
> > > based on the context (bpf_sock_ops vs bpf_sock).]
> > >
> > > As an example, let's allow those 'struct bpf_sock' based helpers to
> > > be called from the BPF_CGROUP_INET{4,6}_CONNECT hooks. That way
> > > we can override CC before the connection is made.
> > >
> > > v2:
> > > * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
> > >
> > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > [...]
> > > +BPF_CALL_5(bpf_setsockopt, struct sock *, sk,
> > > +	   int, level, int, optname, char *, optval, int, optlen)
> > > +{
> > > +	u32 flags = 0;
> > > +	return _bpf_setsockopt(sk, level, optname, optval, optlen, flags);
> > > +}
> > > +
> > > +static const struct bpf_func_proto bpf_setsockopt_proto = {
> > > +	.func		= bpf_setsockopt,
> > > +	.gpl_only	= false,
> > > +	.ret_type	= RET_INTEGER,
> > > +	.arg1_type	= ARG_PTR_TO_SOCKET,
> > > +	.arg2_type	= ARG_ANYTHING,
> > > +	.arg3_type	= ARG_ANYTHING,
> > > +	.arg4_type	= ARG_PTR_TO_MEM,
> > > +	.arg5_type	= ARG_CONST_SIZE,
> > > +};
> > > +
> > > +BPF_CALL_5(bpf_getsockopt, struct sock *, sk,
> > > +	   int, level, int, optname, char *, optval, int, optlen)
> > > +{
> > > +	return _bpf_getsockopt(sk, level, optname, optval, optlen);
> > > +}
> > > +
> > >   static const struct bpf_func_proto bpf_getsockopt_proto = {
> > >   	.func		= bpf_getsockopt,
> > >   	.gpl_only	= false,
> > >   	.ret_type	= RET_INTEGER,
> > > +	.arg1_type	= ARG_PTR_TO_SOCKET,
> > > +	.arg2_type	= ARG_ANYTHING,
> > > +	.arg3_type	= ARG_ANYTHING,
> > > +	.arg4_type	= ARG_PTR_TO_UNINIT_MEM,
> > > +	.arg5_type	= ARG_CONST_SIZE,
> > > +};
> > > +
> > [...]
> > > @@ -6043,6 +6098,22 @@ sock_addr_func_proto(enum bpf_func_id func_id,
> > const struct bpf_prog *prog)
> > >   		return &bpf_sk_storage_get_proto;
> > >   	case BPF_FUNC_sk_storage_delete:
> > >   		return &bpf_sk_storage_delete_proto;
> > > +	case BPF_FUNC_setsockopt:
> > > +		switch (prog->expected_attach_type) {
> > > +		case BPF_CGROUP_INET4_CONNECT:
> > > +		case BPF_CGROUP_INET6_CONNECT:
> > > +			return &bpf_setsockopt_proto;
> 
> > Hm, I'm not sure this is safe. In the sock_addr_func_proto() we also have
> > other helpers callable from connect hooks like sk_lookup_{tcp,udp} which
> > return a PTR_TO_SOCKET_OR_NULL, and now we can pass those sockets also
> > into
> > bpf_{get,set}sockopt() helper after lookup to change various sk related
> > stuff
> > but w/o being under lock. Doesn't the sock_owned_by_me() yell here at
> > minimum
> > (I'd expect so)?
> Ugh, good point, I missed the fact that sk_lookup_{tcp,udp} are there
> for sock_addr :-( I can try to do a simple test case to verify
> that sock_owned_by_me triggers, but I'm pretty certain it should
> (I've been calling bpf_{s,g}etsockopt for context socket so it's quiet).
> 
> I don't think there is any helper similar to sock_owned_by_me() that
> I can call to verify that the socket is held by current thread
> (without the lockdep splat) and bail out?
> 
> In this case, is something like adding new PTR_TO_LOCKED_SOCKET_OR_NULL
> is the way to go? Any other ideas?

Looks like networking will benefit from sleepable progs too.
We could have just did lock_sock() inside bpf_setsockopt
before setting cong control.
In the mean time how about introducing try_lock_sock() 
that will bail out if it cannot grab the lock?
For most practical cases that would work and eventually we
can convert it to full lock_sock ?
