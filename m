Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10365B0B8C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiIGRdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiIGRdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:33:31 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4AFAA3FD;
        Wed,  7 Sep 2022 10:33:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e17so13157679edc.5;
        Wed, 07 Sep 2022 10:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=EMdYVgrPORJghmWcwCaLMhyYB6LX7bPDOyParbvErPs=;
        b=cs+9ZSYV01bTQ1hYnQmhHmp7bhG89YTNFqdwtSrJ51SP/TepurT9AJ3JkOwiDIT6B/
         EGdl/sTe+1DsjywfitSHGGZctfMwdPw6E2SYHXNQCkdxpKQ2oK9CUSdidc6aB4Dhyq4m
         n6NRHrD8Phw7RRv718tidhAxqQSnUoUUsz5sKqBekvMb8AJmz6fOxZY8bU1k2ELu3Gy0
         rjBGAl9G7gVQMsnCPEJTanmHRCOpmlI07cXAOrmwA0m3DJo7p17dh1IS7LMWuz+f1mjZ
         khu34rcWdhJGeaoXD5tw4JJ/lYnkINHEWdFo2XqzDgE/pnUnfA9ANq9HCtfLVwv62fzK
         MPhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=EMdYVgrPORJghmWcwCaLMhyYB6LX7bPDOyParbvErPs=;
        b=RKi6mbnjSPp+A/Byy8tqcKRnWbvP570vcuGsidqYDHQ+1x33zNbVvcs8pfKzyJ6ZJt
         1KeE1Icc6egmPBGsG3f++vqr21joqLjlt/kIt6pYut6Gbqs9qvNpYSVF8MLiWNjSlWTx
         zAJMLe36A7nbnGyK5v2wnWYtDFr7UnWWCsDej/q6SY/3eqlOotMd2TpYBsSoJeJhI7jq
         1ep1iwqJI5gq2axWFFxIQEWjLwQkyhyAPrknvM+0hV6vghQzUP5QzhEUl0p6olmzamNf
         ZP193YyCr1P6ANKtuE3ZVR8vXmlxtfPJYVoYGyRhcu82ZyBiuV5QqDCToCOd59an7MTh
         tJLg==
X-Gm-Message-State: ACgBeo2NlRThCRsat/Xc/mUk9drXJAkrP9cnpxp2opSOkEHMxBIXZjTZ
        XmN89jGRPTU+X4Lbv7fdaVXsPizcK6Rr9GXwfK8=
X-Google-Smtp-Source: AA6agR7jyBlmHjD6fVjU2V3kZqqc5HVdvc9mt6OH6WYba51qMyt9FU3+AsVluLccZEW6Az48z1cSlC3G8OlUkEy9IXo=
X-Received: by 2002:a05:6402:378f:b0:43a:d3f5:79f2 with SMTP id
 et15-20020a056402378f00b0043ad3f579f2mr4017979edb.338.1662572008559; Wed, 07
 Sep 2022 10:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662383493.git.lorenzo@kernel.org> <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
 <CAADnVQJ4XtFpsEsPRC-cepfQvXr-hN7e_3L5SchieeGHH40_4A@mail.gmail.com>
 <CAP01T77BuY9VNBVt98SJio5D2SqkR5i3bynPXTZG4VVUng-bBA@mail.gmail.com>
 <CAADnVQJ7PnY+AQmyaMggx6twZ5a4bOncKApkjhPhjj2iniXoUQ@mail.gmail.com> <CAP01T77goGbF3GVithEuJ7yMQR9PxHNA9GXFODq_nfA66G=F9g@mail.gmail.com>
In-Reply-To: <CAP01T77goGbF3GVithEuJ7yMQR9PxHNA9GXFODq_nfA66G=F9g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Sep 2022 10:33:17 -0700
Message-ID: <CAADnVQJxe1QT5bvcsrZQCLeZ6kei6WEESP5bDXf_5qcB2Bb6_Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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

On Tue, Sep 6, 2022 at 10:52 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, 7 Sept 2022 at 07:15, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Sep 6, 2022 at 9:40 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > >
> > > On Wed, 7 Sept 2022 at 06:27, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Mon, Sep 5, 2022 at 6:14 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > > +int bpf_ct_set_nat_info(struct nf_conn___init *nfct__ref,
> > > > > +                       union nf_inet_addr *addr, __be16 *port,
> > > > > +                       enum nf_nat_manip_type manip)
> > > > > +{
> > > > ...
> > > > > @@ -437,6 +483,7 @@ BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
> > > > >  BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
> > > > >  BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
> > > > >  BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
> > > > > +BTF_ID_FLAGS(func, bpf_ct_set_nat_info)
> > > > >  BTF_SET8_END(nf_ct_kfunc_set)
> > > >
> > > > Instead of __ref and patch 1 and 2 it would be better to
> > > > change the meaning of "trusted_args".
> > > > In this case "addr" and "port" are just as "trusted".
> > > > They're not refcounted per verifier definition,
> > > > but they need to be "trusted" by the helper.
> > > > At the end the "trusted_args" flags would mean
> > > > "this helper can assume that all pointers can be safely
> > > > accessed without worrying about lifetime".
> > >
> > > So you mean it only forces PTR_TO_BTF_ID to have reg->ref_obj_id > 0?
> > >
> > > But suppose in the future you have a type that has scalars only.
> > >
> > > struct foo { int a; int b; ... };
> > > Just data, and this is acquired from a kfunc and released using another kfunc.
> > > Now with this new definition you are proposing, verifier ends up
> > > allowing PTR_TO_MEM to also be passed to such helpers for the struct
> > > foo *.
> > >
> > > I guess even reg->ref_obj_id check is not enough, user may also pass
> > > PTR_TO_MEM | MEM_ALLOC which can be refcounted.
> > >
> > > It would be easy to forget such subtle details later.
> >
> > It may add headaches to the verifier side, but here we have to
> > think from pov of other subsystems that add kfuncs.
> > They shouldn't need to know the verifier details.
> > The internals will change anyway.
>
> Ok, I'll go with making it work for all args for this case.
>
> > Ideally KF_TRUSTED_ARGS will become the default flag that every kfunc
> > will use to indicate that the function assumes valid pointers.
> > How the verifier recognizes them is irrelevant from kfunc pov.
> > People that write bpf progs are not that much different from
> > people that write kfuncs that bpf progs use.
> > Both should be easy to write.
>
> That is a worthy goal, but it can't become the default unless we
> somehow fix how normal PTR_TO_BTF_ID without ref_obj_id is allowed to
> be valid, valid-looking-but-uaf pointer, NULL all at the same time
> depending on how it was obtained. Currently all helpers, even stable
> ones, are broken in this regard. Similarly recently added
> cgroup_rstat_flush etc. kfuncs are equally unsafe.
>
> All stable helpers taking PTR_TO_BTF_ID are not even checking for at
> least NULL, even though it's right there in bpf.h.
>    592         /* PTR_TO_BTF_ID points to a kernel struct that does not need
>    593          * to be null checked by the BPF program. This does not imply the
>    594          * pointer is _not_ null and in practice this can
> easily be a null
>    595          * pointer when reading pointer chains. The assumption is program
> which just proves how confusing it is right now. And "fixing" that by
> adding a NULL check doesn't fix it completely, since it can also be a
> seemingly valid looking but freed pointer.
>
> My previous proposal still stands, to accommodate direct PTR_TO_BTF_ID
> pointers from loads from PTR_TO_CTX of tracing progs into this
> definition of 'trusted', but not those obtained from walking them. It
> works for iterator arguments also.
>
> We could limit these restrictions only to kfuncs instead of stable helpers.
>
> It might be possible to instead just whitelist the function BTF IDs as
> well, even saying pointers from walks are also safe in this context
> for the kfuncs allowed there, or we work on annotating the safe cases
> using BTF tags.
>
> There are some problems currently (GCC not supporting BTF tags yet, is
> argument really trusted in fexit program in 'xyz_free' function), but
> overall it seems like a better state than status quo. It might also
> finally push GCC to begin supporting BTF tags.
>
> Mapping of a set of btf_ids can be done to a specific kfunc hook
> (instead of current program type), so you are basically composing a
> kfunc hook out of a set of btf_ids instead of program type. It
> represents a safe context to call those kfuncs in.
>
> It is impossible to know otherwise what case is safe to call a kfunc
> for and what is not statically - short of also allowing the unsafe
> cases.
>
> Then the kfuncs work on refcounted pointers, and also unrefcounted
> ones for known safe cases (basically where the lifetime is guaranteed
> by bpf program caller). For arguments it works by default. The only
> extra work is annotating things inside structures.
> Might not even need that extra annotation in many cases, since kernel
> already has __rcu etc. which we can start recognizing like __user to
> complain in non-sleepable programs (e.g. without explicit RCU section
> which may be added in the future).
>
> Then just flip KF_TRUSTED_ARGS by default, and people have to opt into
> 'unsafe' instead to make it work for some edge cases, with a big fat
> warning for the user of that kfunc.

With few minor nits, that I don't want to get into right now,
all of the above makes sense. It can be a plan of record.
But all that will be done later.
The immediate first step I'm proposing is
to extend the definition of KF_TRUSTED_ARGS to include this
particular use case of:
union nf_inet_addr *addr, __be16 *port,

Those won't be PTR_TO_BTF_ID so above plan doesn't affect this case.
They're PTR_TO_MEM (if I'm reading the selftest in the next patch
correctly) and we can relax:
                if (is_kfunc && trusted_arg && !reg->ref_obj_id) {

Just minimal amount of verifier work to enable this specific
bpf_ct_set_nat_info kfunc.

I think that's user friendlier approach than __ref suffix
which forces kfunc writers to understand all of the above
verifier details (valid-looking-but-uaf, null-but-not-null, etc).
