Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A8A573F30
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 23:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiGMVxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 17:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiGMVxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 17:53:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0DDF44;
        Wed, 13 Jul 2022 14:53:36 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id t3so131834edd.0;
        Wed, 13 Jul 2022 14:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6h8nwT3wHI/G8fWECnnlp48GjuVHmio/5V1kdbrTAg=;
        b=fVEvcxa6Zg5/R5hgh/I2OAeCJsJ8mp5FVqJO+2kTq/pv3Toq4sV+zfDMyudGVeX4AD
         EyHRPuPnPaDzlDntlz+SbYmeBzv8p2nu1+e2/K07YhlySg7kTo2Z24kNYn0ult7JXC7c
         Yk3JnZoJ1RjpZjYXQ9AcA81gTa/pMf6oZLlumoIYJ5WomcqLSRaQKbLg3VBdGzCj45/y
         OhgXPBcV+kSe/9olpU32uQdKT8AMxIpITUL8ZWqPPx/CeuLzw1JproyeQJs+oJnlalZy
         tFpO8shm2eSHGF/mNhI+RfbuJ7eQh/bGdxbsamgWZVV4zWfwDMWYdqskq6sp/uoIVQc9
         yDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T6h8nwT3wHI/G8fWECnnlp48GjuVHmio/5V1kdbrTAg=;
        b=PhHco417ekApHrXMJxMVr1acXZwzzjdzg2owhyw+IW6hEHgMBWUCQeKZKH5gqJjY44
         AMD6YQbuRaeGQH9owIn/mh6+7pCs+m516ismdqhvzDBhw5xKEOvzzh3xkr5Wre9l6L3J
         HWm20LkRkpjYbCQvG+LUb2erHpszR+N+AVGs3CewDD2h8lD1t02TXptwnytgvlYH4wl+
         enfoozycTeprQ7S7cHnivz2z0u+WxUH1BUYk4JANp5Z/Lo/70A/ZFtX1ou3ORHfYdB3o
         5nz5dM+h+/t3MMBsLtglzf5mwe1WoxBynoiG7pzPMZ2ceFpzVej+YvGWeOV455h+kXwy
         FYAw==
X-Gm-Message-State: AJIora8B3OwnwTnL7SU/KG9hnXCj2/rs/Sk+oBoDJS7BVY+Ps9ZUW5JN
        VXS0RmHPx9aAbga06PV5npn1HaSL/I9w2Gup3JA=
X-Google-Smtp-Source: AGRyM1vBas0lLGWrTC7WLCsEbmA4FhW75fzZJVJfZ4kfchJdJ0JNKVDsHUxiirrUsdD9hzdwgoJc+Tz5kHRURQ0NQBw=
X-Received: by 2002:a05:6402:350c:b0:43a:e25f:d73 with SMTP id
 b12-20020a056402350c00b0043ae25f0d73mr7986308edd.66.1657749214964; Wed, 13
 Jul 2022 14:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220623192637.3866852-1-memxor@gmail.com> <20220623192637.3866852-2-memxor@gmail.com>
 <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
 <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
 <CAP01T75cVLehQbkE3LLwSG5wVecNz0FH9QZpmzoqs-e8YKpGtg@mail.gmail.com>
 <20220706184436.mf7oeexxfwswgdqf@MacBook-Pro-3.local> <CAP01T75-EZfdBx+W+6pV0vDDD3Qi07KVLsFTupPfptTyAFxx1Q@mail.gmail.com>
 <20220706212903.az2mtqodtzmn2gwq@MacBook-Pro-3.local> <CAADnVQJsAfjFwgoiWdsmuWBi9BX7eaCw8Tpe7sd=HPG4QQck1A@mail.gmail.com>
 <CAP01T77GxdU6AQE3ADVFZ6YA89diFFAev3aQFpYNboxM76QJ6w@mail.gmail.com>
In-Reply-To: <CAP01T77GxdU6AQE3ADVFZ6YA89diFFAev3aQFpYNboxM76QJ6w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 13 Jul 2022 14:53:23 -0700
Message-ID: <CAADnVQL1=cxAhowFsMLDDUup10okDcRSfBwndCKx99qjCDEcnA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
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

On Wed, Jul 13, 2022 at 5:13 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
> > > Ahh. Now I remember. Thanks for reminding :)
> > > Could you please summarize this thread and add all of it as a big comment
> > > in the source code next to __ref handling to explain the motivation
> > > and an example on when and how this __ref suffix should be used.
> > > Otherwise somebody, like me, will forget the context soon.
> > >
> > > I was thinking of better name than __ref, but couldn't come up with one.
> > > __ref fits this use case the best.
> >
> > Actually, maybe a kfunc flag will be better?
> > Like REF_ARGS
> > that would apply to all arguments of the kfunc
> > (not only those with __ref suffix).
> >
> > We have three types of ptr_btf_id:
> > - ref counted
> > - untrusted
> > - old legacy that we cannot be break due to backward compat
> >
> > In the future we'll probably be adding new kfuncs where we'd want
> > every argument to be trusted. In our naming convention these are
> > the refcounted ptr_to_btf_id that come from lookup-like kfuncs.
> > To consume them in the release kfunc they have to be refcounted,
> > but non-release kfunc (like set_timeout) also want a trusted ptr.
> > So the simple way of describe the intent would be:
> > BTF_ID(func, bpf_ct_release, RELEASE)
> > BTF_ID(func, bpf_ct_set_timeout, REF_ARGS)
> >
> > or maybe TRUSTED_ARGS would be a better flag name.
> > wdyt?
>
> Ok, I've implemented the kfunc flags and kept TRUSTED_ARGS as the
> name. Just need to do a little bit of testing and will post it
> together with this.

Awesome!

> Just to confirm, should I still keep __ref or drop it? I think
> TRUSTED_ARGS has its use but it may be too coarse. I already have the
> patch so if you like we can add both ways now.

TRUSTED_ARGS may become too coarse, but let's cross that bridge
when there is actual need.
If we land __ref support right now there won't be any users
and the code will start to bit rot. So let's delay it.
Pls post that patch as an extra RFC patch anyway, so
it won't get lost.
