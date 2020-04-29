Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B861BECA8
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgD2XdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgD2XdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 19:33:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9997C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 16:33:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t2so5517044ybq.11
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 16:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NsQTVycOGMKsU1+TvPQ2vv/5lC2AdXfUMp8A3FRSsp0=;
        b=kwxHmWZiLG1DFm/MNQlgiq3L/0CAWBkY3PQXx2qgOOuAerWX0QZ0SuWxehD0e14kS7
         wCtP+ZGqVw3GErxX8YdQBOKW2pIa4YQsDiXZXNKzUWBZaUiW61uno2xVf+kY5YmCobjm
         LQOFbmy+UIIMyzdVKTidvabq9WeQCm7JNs62Ud/ilduUehXDlv1pWVgnNdY0bM9hu0jd
         dAz+uWUukDdXBNrnJPvPIAy+KRxkGcECN/usdgdEqBwLTlq9CYyV8P/O8CDuZskSz/AK
         atSAKrQzAxIWUfeWJDQwx8/TERwKVLIjN49SwRhW/OJZr46Gv5s1Cz/z6mRcJxhO4dje
         8cXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NsQTVycOGMKsU1+TvPQ2vv/5lC2AdXfUMp8A3FRSsp0=;
        b=kf5QNrm0OHGnzwg2eSWvxiCh2GHv4++RGPtFTyQzNqmacZuJ928l6HoGEfq+xd9DEJ
         5za1dIt5TOEaiAVyk4HHEY27ofjknJwnkG+CXi3Sltkf9nEFgYVDj/MtS/CSta2b//9e
         cPoX+BkAyuAhkm/hGqgZvJ2yyO+EXurUuoid2WfVO3tyFohpuF8NfdCchMtexae06lO6
         O9A/jvztIvNd2ZodxaOIKRhs9XnmjWThuSC75t1VlQg3ZJ7FyHBgUb00wnnw0R7KnBdI
         ly8/z6HtD91K+tPZwF59DJwRkg4BtRHzSdAz7PmxyWtu01T8wf80f1NNsWrfIzTynLZX
         JLEQ==
X-Gm-Message-State: AGi0PubJdiZnmrMAZsOg8c/0MfxO3Cr8CsZExa081a//kcebIN44BHPe
        TEk+5qM3H3uI9fTJ7dKSteFdKKE=
X-Google-Smtp-Source: APiQypIqBgBL21PQ0Eq3F36MJk2aEaVJQ+nW8Yrqnsa+UQUqFyB8Xg4xqgB9exsepK/Eu2XoICeVI+k=
X-Received: by 2002:a25:afd2:: with SMTP id d18mr1270079ybj.321.1588203193776;
 Wed, 29 Apr 2020 16:33:13 -0700 (PDT)
Date:   Wed, 29 Apr 2020 16:33:12 -0700
In-Reply-To: <640e7fd3-4059-5ff8-f9ed-09b1becd0f7b@iogearbox.net>
Message-Id: <20200429233312.GB241848@google.com>
Mime-Version: 1.0
References: <20200429170524.217865-1-sdf@google.com> <640e7fd3-4059-5ff8-f9ed-09b1becd0f7b@iogearbox.net>
Subject: Re: [PATCH bpf-next v2] bpf: bpf_{g,s}etsockopt for struct bpf_sock
From:   sdf@google.com
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/30, Daniel Borkmann wrote:
> On 4/29/20 7:05 PM, Stanislav Fomichev wrote:
> > Currently, bpf_getsocktop and bpf_setsockopt helpers operate on the
> > 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> > Let's generalize them and make the first argument be 'struct bpf_sock'.
> > That way, in the future, we can allow those helpers in more places.
> >
> > BPF_PROG_TYPE_SOCK_OPS still has the existing helpers that operate
> > on 'struct bpf_sock_ops', but we add new bpf_{g,s}etsockopt that work
> > on 'struct bpf_sock'. [Alternatively, for BPF_PROG_TYPE_SOCK_OPS,
> > we can enable them both and teach verifier to pick the right one
> > based on the context (bpf_sock_ops vs bpf_sock).]
> >
> > As an example, let's allow those 'struct bpf_sock' based helpers to
> > be called from the BPF_CGROUP_INET{4,6}_CONNECT hooks. That way
> > we can override CC before the connection is made.
> >
> > v2:
> > * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
> >
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> [...]
> > +BPF_CALL_5(bpf_setsockopt, struct sock *, sk,
> > +	   int, level, int, optname, char *, optval, int, optlen)
> > +{
> > +	u32 flags = 0;
> > +	return _bpf_setsockopt(sk, level, optname, optval, optlen, flags);
> > +}
> > +
> > +static const struct bpf_func_proto bpf_setsockopt_proto = {
> > +	.func		= bpf_setsockopt,
> > +	.gpl_only	= false,
> > +	.ret_type	= RET_INTEGER,
> > +	.arg1_type	= ARG_PTR_TO_SOCKET,
> > +	.arg2_type	= ARG_ANYTHING,
> > +	.arg3_type	= ARG_ANYTHING,
> > +	.arg4_type	= ARG_PTR_TO_MEM,
> > +	.arg5_type	= ARG_CONST_SIZE,
> > +};
> > +
> > +BPF_CALL_5(bpf_getsockopt, struct sock *, sk,
> > +	   int, level, int, optname, char *, optval, int, optlen)
> > +{
> > +	return _bpf_getsockopt(sk, level, optname, optval, optlen);
> > +}
> > +
> >   static const struct bpf_func_proto bpf_getsockopt_proto = {
> >   	.func		= bpf_getsockopt,
> >   	.gpl_only	= false,
> >   	.ret_type	= RET_INTEGER,
> > +	.arg1_type	= ARG_PTR_TO_SOCKET,
> > +	.arg2_type	= ARG_ANYTHING,
> > +	.arg3_type	= ARG_ANYTHING,
> > +	.arg4_type	= ARG_PTR_TO_UNINIT_MEM,
> > +	.arg5_type	= ARG_CONST_SIZE,
> > +};
> > +
> [...]
> > @@ -6043,6 +6098,22 @@ sock_addr_func_proto(enum bpf_func_id func_id,  
> const struct bpf_prog *prog)
> >   		return &bpf_sk_storage_get_proto;
> >   	case BPF_FUNC_sk_storage_delete:
> >   		return &bpf_sk_storage_delete_proto;
> > +	case BPF_FUNC_setsockopt:
> > +		switch (prog->expected_attach_type) {
> > +		case BPF_CGROUP_INET4_CONNECT:
> > +		case BPF_CGROUP_INET6_CONNECT:
> > +			return &bpf_setsockopt_proto;

> Hm, I'm not sure this is safe. In the sock_addr_func_proto() we also have
> other helpers callable from connect hooks like sk_lookup_{tcp,udp} which
> return a PTR_TO_SOCKET_OR_NULL, and now we can pass those sockets also  
> into
> bpf_{get,set}sockopt() helper after lookup to change various sk related  
> stuff
> but w/o being under lock. Doesn't the sock_owned_by_me() yell here at  
> minimum
> (I'd expect so)?
Ugh, good point, I missed the fact that sk_lookup_{tcp,udp} are there
for sock_addr :-( I can try to do a simple test case to verify
that sock_owned_by_me triggers, but I'm pretty certain it should
(I've been calling bpf_{s,g}etsockopt for context socket so it's quiet).

I don't think there is any helper similar to sock_owned_by_me() that
I can call to verify that the socket is held by current thread
(without the lockdep splat) and bail out?

In this case, is something like adding new PTR_TO_LOCKED_SOCKET_OR_NULL
is the way to go? Any other ideas?
