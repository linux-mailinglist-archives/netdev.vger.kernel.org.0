Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF57556454D
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 07:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiGCFfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 01:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiGCFfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 01:35:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9645B6559;
        Sat,  2 Jul 2022 22:35:02 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p69so5892796iod.10;
        Sat, 02 Jul 2022 22:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GXf8SKBOuU3KwphSh6GHGhz85X2fwFD7jZBuWEYSZs8=;
        b=fFDRsPryBlyx5HweWHW49+r6soSaP2zs54Mpt3d2EZI7EJhOPnxNnrheCZx3PZ7HM6
         L+9UHyYZM5c0UDY+a2+cUfO6PdIQboFwlP9s6iRvrlCz6XcV8EEjv3eQiFy1kdMu905I
         y4XyBUFLggqJ/Gxp5Dnrcv9PkLaR1IDj3FfLqx1nmeeR0mOCmHTOr5UDRI5Nj5tQO4J5
         wIw/c8YNWf0TWkHwq1j/eb61CbYm0w1LhjQULxp/CilxHHJ67gGWJRujM109t++rbtYi
         P36ibnSu506paRlGdxpmE4GF2pXryb3Y+sXXYwSTSXvoG7dXP5d2FJUlztjodlxeAHZV
         Rf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GXf8SKBOuU3KwphSh6GHGhz85X2fwFD7jZBuWEYSZs8=;
        b=e8EtNpIqo3t0RikEmkR+OguGwGrJLgWbXLcJOvnZCMZVOM2uIu9c7VklBbydKcTvB4
         Yj+U8ZY9XPxy6TkqrAp7MoYQ4WC0EKTekw2XbcB8D6vMC2CxgeE1zaJQQhQNvOynO//B
         wYZWOMttcC3V073VIqb4Z51cHwknIk/FRAx5M73Aiz5PHPGjGQwmUrVRuuUzN6w6l92o
         QdTHBs7B9/8lzGyzT05aiFFrkW/PK1sGcRk+MCiPw1dm6pmrKuaOTe/oacDUoHtKnLuw
         ND0UExBu6FSonO4y72EESd+d+G9/hIhDpTNfzYPBcz8ynlWJuGy0u25MhXS//E1F2vya
         nb2w==
X-Gm-Message-State: AJIora86QZEwrQDj2Ke2nS7NY0K8s98EejFeXwufuNAQCN+vfMkx6nqC
        WBfaLFePRY6XI8BtVL2wns9v4LG5CdHRFHCFDf4=
X-Google-Smtp-Source: AGRyM1uOGLP5UYV8vtUBJ1pt1ATQYI8uGI+5cgj842Fkr4J6CeW1pe4NOGgD9pKXoy6VHLiVj/wYFma8bJlg+2Opq7U=
X-Received: by 2002:a6b:6512:0:b0:674:ee9a:21fe with SMTP id
 z18-20020a6b6512000000b00674ee9a21femr12157626iob.168.1656826501842; Sat, 02
 Jul 2022 22:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220623192637.3866852-1-memxor@gmail.com> <20220623192637.3866852-2-memxor@gmail.com>
 <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com> <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
In-Reply-To: <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sun, 3 Jul 2022 11:04:22 +0530
Message-ID: <CAP01T75cVLehQbkE3LLwSG5wVecNz0FH9QZpmzoqs-e8YKpGtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 3 Jul 2022 at 10:54, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Wed, 29 Jun 2022 at 08:53, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Jun 24, 2022 at 12:56:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > Similar to how we detect mem, size pairs in kfunc, teach verifier to
> > > treat __ref suffix on argument name to imply that it must be a
> > > referenced pointer when passed to kfunc. This is required to ensure that
> > > kfunc that operate on some object only work on acquired pointers and not
> > > normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> > > walking. Release functions need not specify such suffix on release
> > > arguments as they are already expected to receive one referenced
> > > argument.
> > >
> > > Note that we use strict type matching when a __ref suffix is present on
> > > the argument.
> > ...
> > > +             /* Check if argument must be a referenced pointer, args + i has
> > > +              * been verified to be a pointer (after skipping modifiers).
> > > +              */
> > > +             arg_ref = is_kfunc_arg_ref(btf, args + i);
> > > +             if (is_kfunc && arg_ref && !reg->ref_obj_id) {
> > > +                     bpf_log(log, "R%d must be referenced\n", regno);
> > > +                     return -EINVAL;
> > > +             }
> > > +
> >
> > imo this suffix will be confusing to use.
> > If I understand the intent the __ref should only be used
> > in acquire (and other) kfuncs that also do release.
> > Adding __ref to actual release kfunc will be a nop.
> > It will be checked, but it's not necessary.
> >
> > At the end
> > +struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
> > will behave like kptr_xchg with exception that kptr_xchg takes any btf_id
> > while here it's fixed.
> >
> > The code:
> >  if (rel && reg->ref_obj_id)
> >         arg_type |= OBJ_RELEASE;
> > should probably be updated with '|| arg_ref'
> > to make sure reg->off == 0 ?
> > That looks like a small bug.
> >
>
> Indeed, I missed that. Thanks for catching it.
>
> > But stepping back... why __ref is needed ?
> > We can add bpf_ct_insert_entry to acq and rel sets and it should work?
> > I'm assuming you're doing the orthogonal cleanup of resolve_btfid,
> > so we will have a single kfunc set where bpf_ct_insert_entry will
> > have both acq and rel flags.
> > I'm surely missing something.
>
> It is needed to prevent the case where someone might do:
> ct = bpf_xdp_ct_alloc(...);
> bpf_ct_set_timeout(ct->master, ...);
>

A better illustration is probably bpf_xdp_ct_lookup and
bpf_ct_change_timeout, since here the type for ct->master won't match
with bpf_ct_set_timeout, but the point is the same.

> Or just obtain PTR_TO_BTF_ID by pointer walking and try to pass it in
> to bpf_ct_set_timeout.
>
> __ref allows an argument on a non-release kfunc to have checks like a
> release argument, i.e. refcounted, reg->off == 0 (var_off is already
> checked to be 0), so use the original pointer that was obtained from
> an acquire kfunc. As you noted, it isn't strictly needed on release
> kfunc (like bpf_ct_insert_entry) because the same checks happen for it
> anyway. But both timeout and status helpers should use it if they
> "operate" on the acquired ct (from alloc, insert, or lookup).
