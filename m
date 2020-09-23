Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121EA275BC0
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 17:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgIWPZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 11:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgIWPZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 11:25:13 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A4DC0613CE;
        Wed, 23 Sep 2020 08:25:12 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u8so374801lff.1;
        Wed, 23 Sep 2020 08:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rLfEU7869XKoXFTwPISywhYfvr/QZg3s6i2yiGekn4=;
        b=cRCQMZ6kxWSTOqn93Mh5pkZceMXfKaqs1w4Qh/VZUEApekypCk9lzfeJISkcqVdFFF
         W3fx1O/rkmL8Pd/+yJgWrHMRFjfeAFUeBArAOVuMeUUWOisylaC8QbTvZDOGT+p3iP88
         lenYU2HU18PjDPRIQaJHFVKzjJh8CQQrBNp2RS+120Epf0tpy1+t8FgkKfyf6zs1pmlp
         ML/EEME/tQQY/5LmUxGbz2TnqGYsYll9KAH39wDwlDhIRA60st/fFIyadm/BW1ElMTCa
         bmGqkB5FHpRM0wnAovnE5ezr5QmzkDKMx5iuLzeMrEYj8YJBTQZZxg32JY2BwIurmGMt
         Myjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rLfEU7869XKoXFTwPISywhYfvr/QZg3s6i2yiGekn4=;
        b=Dd/UuSJEo7tar7Wgm+YRbbXqV9IT2rMXlzdCMtHeOcDEfosgjNSYjDM3VbuPupHYRZ
         1Z4ICN0alnjQMFNb4o/vrhQvwFKU45uAogtBTgjn+5w49d4DI8uqGIWjza/hRUH7YwdB
         +R1yT/YgSQ5w2KDJ7+EB10qK4Q7HWj0qFKoVqTsjLeI8VPfEetF/KM+q+z+U+EovceuH
         KW/mabTjii4Nby+zgVnq6RkXTs+JhA7o71LGB7bkFppXZKsNMH6fv9QE7CVcib75XCIa
         E1hOnusBF34GSctNe0I1mwjDFMByvLB+DwtyNIKEJMLb02yiEdF2DNd9whjRONJWG822
         m+7g==
X-Gm-Message-State: AOAM530DdAzv4K4FnDu/zzsqI1PDjabWMA9sDoxLYVb/miJebIz2Ugml
        //2DF1j+wrQXVGkqYpQ5caZb9/BTBTHNXfNsWLsEycjbEY0=
X-Google-Smtp-Source: ABdhPJx1pjUnh7eMgaIHoRXBcnbazHbb7xsrRzstxapgZGG6w70laHVYKRlUPKUnbsnnTsGWeVz4LVrYgdFteIC+pWw=
X-Received: by 2002:a19:50d:: with SMTP id 13mr113164lff.500.1600874710814;
 Wed, 23 Sep 2020 08:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200921121227.255763-1-lmb@cloudflare.com> <20200921121227.255763-12-lmb@cloudflare.com>
 <20200921222335.lew7wmyrtuej5mrh@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98XfkMy4TDFnHBCFzXxauLrZ56w+84-R_NQO1SLMgPJYA@mail.gmail.com>
 <20200922200748.gv6x6yhkyxnbqxx4@ast-mbp.dhcp.thefacebook.com> <CACAyw9-K15TMNzWkg3PtFt47X2iQCD9fwbUaVdF2jJZn3poZ3A@mail.gmail.com>
In-Reply-To: <CACAyw9-K15TMNzWkg3PtFt47X2iQCD9fwbUaVdF2jJZn3poZ3A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Sep 2020 08:24:58 -0700
Message-ID: <CAADnVQ+sXH-9ffONAdggbix427iiX3mzn1f1_SwLJH=+pBfcJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 11/11] bpf: use a table to drive helper arg
 type checks
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 2:45 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 22 Sep 2020 at 21:07, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Sep 22, 2020 at 09:20:27AM +0100, Lorenz Bauer wrote:
> > > On Mon, 21 Sep 2020 at 23:23, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Mon, Sep 21, 2020 at 01:12:27PM +0100, Lorenz Bauer wrote:
> > > > > +struct bpf_reg_types {
> > > > > +     const enum bpf_reg_type types[10];
> > > > > +};
> > > >
> > > > any idea on how to make it more robust?
> > >
> > > I kind of copied this from the bpf_iter context. I prototyped using an
> > > enum bpf_reg_type * and then terminating the array with NOT_INIT.
> > > Writing this out is more involved, and might need some macro magic to
> > > make it palatable. The current approach is a lot simpler, and I
> > > figured that the compiler will error out if we ever exceed the 10
> > > items.
> >
> > The compiler will be silent if number of types is exactly 10,
> > but at run-time the loop will access out of bounds.
>
> Which loop do you refer to?
>
> The one in check_reg_type shouldn't go out of bounds due to ARRAY_SIZE:
>
>     for (i = 0; i < ARRAY_SIZE(compatible->types); i++) {

ahh. right. it will always be 10 here. got it.

>         expected = compatible->types[i];
>         if (expected == NOT_INIT)
>             break;
>
> >
> > > >
> > > > > +
> > > > > +static const struct bpf_reg_types *compatible_reg_types[] = {
> > > > > +     [ARG_PTR_TO_MAP_KEY]            = &map_key_value_types,
> > > > > +     [ARG_PTR_TO_MAP_VALUE]          = &map_key_value_types,
> > > > > +     [ARG_PTR_TO_UNINIT_MAP_VALUE]   = &map_key_value_types,
> > > > > +     [ARG_PTR_TO_MAP_VALUE_OR_NULL]  = &map_key_value_types,
> > > > > +     [ARG_CONST_SIZE]                = &scalar_types,
> > > > > +     [ARG_CONST_SIZE_OR_ZERO]        = &scalar_types,
> > > > > +     [ARG_CONST_ALLOC_SIZE_OR_ZERO]  = &scalar_types,
> > > > > +     [ARG_CONST_MAP_PTR]             = &const_map_ptr_types,
> > > > > +     [ARG_PTR_TO_CTX]                = &context_types,
> > > > > +     [ARG_PTR_TO_CTX_OR_NULL]        = &context_types,
> > > > > +     [ARG_PTR_TO_SOCK_COMMON]        = &sock_types,
> > > > > +     [ARG_PTR_TO_SOCKET]             = &fullsock_types,
> > > > > +     [ARG_PTR_TO_SOCKET_OR_NULL]     = &fullsock_types,
> > > > > +     [ARG_PTR_TO_BTF_ID]             = &btf_ptr_types,
> > > > > +     [ARG_PTR_TO_SPIN_LOCK]          = &spin_lock_types,
> > > > > +     [ARG_PTR_TO_MEM]                = &mem_types,
> > > > > +     [ARG_PTR_TO_MEM_OR_NULL]        = &mem_types,
> > > > > +     [ARG_PTR_TO_UNINIT_MEM]         = &mem_types,
> > > > > +     [ARG_PTR_TO_ALLOC_MEM]          = &alloc_mem_types,
> > > > > +     [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
> > > > > +     [ARG_PTR_TO_INT]                = &int_ptr_types,
> > > > > +     [ARG_PTR_TO_LONG]               = &int_ptr_types,
> > > > > +     [__BPF_ARG_TYPE_MAX]            = NULL,
> > > >
> > > > I don't understand what this extra value is for.
> > > > I tried:
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index fc5c901c7542..87b0d5dcc1ff 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -292,7 +292,6 @@ enum bpf_arg_type {
> > > >         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
> > > >         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
> > > >         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> > > > -       __BPF_ARG_TYPE_MAX,
> > > >  };
> > > >
> > > >  /* type of values returned from helper functions */
> > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > index 15ab889b0a3f..83faa67858b6 100644
> > > > --- a/kernel/bpf/verifier.c
> > > > +++ b/kernel/bpf/verifier.c
> > > > @@ -4025,7 +4025,6 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
> > > >         [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
> > > >         [ARG_PTR_TO_INT]                = &int_ptr_types,
> > > >         [ARG_PTR_TO_LONG]               = &int_ptr_types,
> > > > -       [__BPF_ARG_TYPE_MAX]            = NULL,
> > > >  };
> > > >
> > > > and everything is fine as I think it should be.
> > > >
> > > > > +     compatible = compatible_reg_types[arg_type];
> > > > > +     if (!compatible) {
> > > > > +             verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
> > > > >               return -EFAULT;
> > > > >       }
> > > >
> > > > This check will trigger the same way when somebody adds new ARG_* and doesn't add to the table.
> > >
> > > I think in that case that value of compatible will be undefined, since
> > > it points past the end of compatible_reg_types. Hence the
> > > __BPF_ARG_TYPE_MAX to ensure that the array has a NULL slot for new
> > > arg types.
> >
> > I still don't see a point.
> > If anyone adds one more ARG_ to the end (or anywhere else)
> > the compatible_reg_types array will be zero inited in that place by the compiler.
> > Just like it does already for ARG_ANYTHING and ARG_DONTCARE.
>
> I looked up designated initializers when I wrote this, since I wasn't
> super familiar with them:
> https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html#Designated-Inits
>
>     Note that the length of the array is the highest value specified plus one.
>
> So ARG_ANYTHING and ARG_DONTCARE are OK since there is a higher enum
> value present in the initializer. If someone adds a new item to enum
> bpf_arg_type I assume they would add it to the end. In that case the
> highest value of the initializer doesn't change, and then indexing
> into compatible_reg_types with the new enum value would be out of
> bounds. Adding __BPF_ARG_TYPE_MAX fixes that.

I see. Could you do this instead then:
-static const struct bpf_reg_types *compatible_reg_types[] = {
+static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
        [ARG_PTR_TO_MAP_KEY]            = &map_key_value_types,
        [ARG_PTR_TO_MAP_VALUE]          = &map_key_value_types,
        [ARG_PTR_TO_UNINIT_MAP_VALUE]   = &map_key_value_types,
@@ -4025,7 +4025,6 @@ static const struct bpf_reg_types
*compatible_reg_types[] = {
        [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
        [ARG_PTR_TO_INT]                = &int_ptr_types,
        [ARG_PTR_TO_LONG]               = &int_ptr_types,
-       [__BPF_ARG_TYPE_MAX]            = NULL,
 };

That way is more obvious.
That =NULL initializer just for the last element and not for
ARG_ANYTHING/DONTCARE
bothered me enough to start this whole discussion.
