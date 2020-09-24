Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69A276C23
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 10:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgIXIiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 04:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbgIXIiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 04:38:21 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F21C0613D3
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 01:38:21 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id u126so2797075oif.13
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 01:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9thzJJdAavMiSJ5/pm++HTJc7iZZ4XwwFqkjRurdaX0=;
        b=ObK+C/1VLxF5+ZOH4ij2qlxMckD+ILzK3ivawIhKno/4n+4YMAWTBcvr+JwUhNqF1i
         pge9LK+LKtNA/81M9Dfz1vVmi4PYLiJXFIRDMUF4KSa3YC21ZwcYpZXllu4rpXq2u9qe
         76cc/K5Ii/SqsUXyc1Uf1MSB1HhaJYewTfbNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9thzJJdAavMiSJ5/pm++HTJc7iZZ4XwwFqkjRurdaX0=;
        b=OZJXLFLc4r5g+qkq+DbNpETMl4bDYmuCPN43LynPcQy/AZBEVhRFrBsycHd4MhPHzM
         C37BlMZgofpJccwFx7REGkULps4LTx8BUeQ0fF0LExUecJyAorsvhnvTx3c1aQoblok5
         TL1Z4ebnRhT04XFHKMjfuQ2mlWaSTZagSOAeId8P4JQb/xqsfm0R24wLMTn0Vd8MDF1M
         BiTs++wBX4QdfMsp1gHCJYjvWcLnDgjR6NVxjdB8Tw1Ge+Di3Ro0vFkztYXX2yHks7P1
         UTEQ24ENAoeOknGku8y8haUANKu7fR+2Sru1aOfjrG8MhekAC2eTz1Sr2VFQHWt8yfzu
         e5hg==
X-Gm-Message-State: AOAM531c5gSTZuF6vzLMRKBxavxpvPvEc5UZDVgr2CUIVI5iIP8GaDzZ
        6nLX3sFUE92gjEsNXtQ0oIpMhQPJNDoV+/FMtdJd+BdoD5o=
X-Google-Smtp-Source: ABdhPJyDcjUHgSiiaAo0w6VDHJdzNUSXC/Tnd1htTghJxRehV8W0PgZd6nGKbw0K162bn6zaxJo3xqFbAYyWNE3Jb+g=
X-Received: by 2002:aca:3087:: with SMTP id w129mr1798398oiw.102.1600936700249;
 Thu, 24 Sep 2020 01:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200922070409.1914988-1-kafai@fb.com> <20200922070422.1917351-1-kafai@fb.com>
 <CACAyw9-LoKFuYxaMODtacJM-rOR0P5Y=j_yEm9bsFZe_j_9rYQ@mail.gmail.com>
 <20200922182622.zcrqwpzkouvlndbw@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw99xbeVyzUT+fhHtRQEGoef-9vvTfiOEFaJWX6aoVL+Z9A@mail.gmail.com> <20200923170552.65i7bnht3qkkikp5@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200923170552.65i7bnht3qkkikp5@kafai-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 24 Sep 2020 09:38:09 +0100
Message-ID: <CACAyw98yYLD-oLQpj05Yrmphf285DUD4aXJMTK1GS8_eMy7jow@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/11] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Sep 2020 at 18:06, Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Sep 23, 2020 at 10:27:27AM +0100, Lorenz Bauer wrote:
> > On Tue, 22 Sep 2020 at 19:26, Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Tue, Sep 22, 2020 at 10:46:41AM +0100, Lorenz Bauer wrote:
> > > > On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > There is a constant need to add more fields into the bpf_tcp_sock
> > > > > for the bpf programs running at tc, sock_ops...etc.
> > > > >
> > > > > A current workaround could be to use bpf_probe_read_kernel().  However,
> > > > > other than making another helper call for reading each field and missing
> > > > > CO-RE, it is also not as intuitive to use as directly reading
> > > > > "tp->lsndtime" for example.  While already having perfmon cap to do
> > > > > bpf_probe_read_kernel(), it will be much easier if the bpf prog can
> > > > > directly read from the tcp_sock.
> > > > >
> > > > > This patch tries to do that by using the existing casting-helpers
> > > > > bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
> > > > > func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
> > > > > kernel "struct tcp_sock".
> > > > >
> > > > > These helpers are also added to is_ptr_cast_function().
> > > > > It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id.
> > > > > That will keep the ref-tracking works properly.
> > > > >
> > > > > The bpf_skc_to_* helpers are made available to most of the bpf prog
> > > > > types in filter.c. They are limited by perfmon cap.
> > > > >
> > > > > This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> > > > > this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> > > > > or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> > > > > helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> > > > > they will accept pointer obtained from skb->sk.
> > > > >
> > > > > PTR_TO_*_OR_NULL is not accepted as an ARG_PTR_TO_BTF_ID_SOCK_COMMON
> > > > > at verification time.  All PTR_TO_*_OR_NULL reg has to do a NULL check
> > > > > first before passing into the helper or else the bpf prog will be
> > > > > rejected by the verifier.
> > > > >
> > > > > [ ARG_PTR_TO_SOCK_COMMON_OR_NULL was attempted earlier.  The _OR_NULL was
> > > > >   needed because the PTR_TO_BTF_ID could be NULL but note that a could be NULL
> > > > >   PTR_TO_BTF_ID is not a scalar NULL to the verifier.  "_OR_NULL" implicitly
> > > > >   gives an expectation that the helper can take a scalar NULL which does
> > > > >   not make sense in most (except one) helpers.  Passing scalar NULL
> > > > >   should be rejected at the verification time.
> > > >
> > > > What is the benefit of requiring a !sk check from the user if all of
> > > > the helpers know how to deal with a NULL pointer?
> > > I don't see a reason why the verifier should not reject an incorrect
> > > program at load time if it can.
> > >
> > > >
> > > > >
> > > > >   Thus, this patch uses ARG_PTR_TO_BTF_ID_SOCK_COMMON to specify that the
> > > > >   helper can take both the btf-id ptr or the legacy PTR_TO_SOCK_COMMON but
> > > > >   not scalar NULL.  It requires the func_proto to explicitly specify the
> > > > >   arg_btf_id such that there is a very clear expectation that the helper
> > > > >   can handle a NULL PTR_TO_BTF_ID. ]
> > > >
> > > > I think ARG_PTR_TO_BTF_ID_SOCK_COMMON is actually a misnomer, since
> > > > nothing enforces that arg_btf_id is actually an ID for sock common.
> > > > This is where ARG_PTR_TO_SOCK_COMMON_OR_NULL is much easier to
> > > > understand, even though it's more permissive than it has to be. It
> > > > communicates very clearly what values the argument can take.
> > > _OR_NULL is incorrect which implies a scalar NULL as mentioned in
> > > this commit message.  From verifier pov, _OR_NULL can take
> > > a scalar NULL.
> >
> > Yes, I know. I'm saying that the distinction between scalar NULL and
> > runtime NULL only makes sense after you understand how BTF pointers
> > are implemented. It only clicked for me after I read the support code
> > in the JIT that Yonghong pointed out. Should everybody that writes a
> > helper need to read the JIT? In my opinion we shouldn't. I guess I
> > don't even care about the verifier rejecting scalar NULL or not, I'd
> > just like the types to have a name that conveys their NULLness.
> It is not only about verifier and/or JIT, not sure why it is related to
> JIT also.
>
> For some helpers, explicitly passing NULL may make sense.
> e.g. bpf_sk_assign(ctx, NULL, 0) makes sense.
>
> For most helpers, the bpf prog is wrong for sure, for example
> in sockmap, what does bpf_map_update_elem(sock_map, key, NULL, 0)
> mean?  I would expect a delete from the sock_map if the verifier
> accepted it.
>
> >
> > >
> > > >
> > > > If you're set on ARG_PTR_TO_BTF_ID_SOCK_COMMON I'd suggest forcing the
> > > > btf_id in struct bpf_reg_types. This avoids the weird case where the
> > > > btf_id doesn't actually point at sock_common, and it also makes my
> > > I have considered the bpf_reg_types option.  I prefer all
> > > arg info (arg_type and arg_btf_id) stay in the same one
> > > place (i.e. func_proto) as much as possible for now
> > > instead of introducing another place to specify/override it
> > > which then depends on a particular arg_type that some arg_type may be
> > > in func_proto while some may be in other places.
> >
> > In my opinion that ship sailed when we started aliasing arg_type to
> > multiple reg_type, but OK.
> >
> > >
> > > The arg_btf_id can be checked in check_btf_id_ok() if it would be a
> > > big concern that it might slip through the review but I think the
> > > chance is pretty low.
> >
> > Why increase the burden on human reviewers? Why add code to check an
> > invariant that we could get rid of in the first place?
> Lets take the scalar NULL example that requires to read multiple
> pieces of codes in different places (verifier, JIT...etc.).
> As you also mentioned, yes, it may be easy for a few people.
> However, for most others, having some obvious things in the same place is
> easier to review.
>
> I think we have to agree we disagree on this one implementation details
> which I think it has been over-thought (and time also).
>
> If you insist that should go into bpf_reg_types (i.e. compatible->btf_id),
> I can do that in v4 and then add another check in another place to
> ensure "!compatible->btf_id" as in v2.

No, I don't insist. I was hoping I could convince you, but alas :)

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
