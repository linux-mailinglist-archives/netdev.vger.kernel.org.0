Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53FFCCDE8
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 04:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfJFCfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 22:35:45 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36730 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfJFCfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 22:35:45 -0400
Received: by mail-qt1-f194.google.com with SMTP id o12so14349355qtf.3;
        Sat, 05 Oct 2019 19:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Odf7KAqNDFyuz5mWtDJTadv28d443cvzLQQrE39N2Us=;
        b=LJ0J32fqYDEh7m18OXyIHQ3mlrGbWdAhIFtwCOZc/z1AqtJshy+xB1ITcZqNfEAwcl
         sYHiGtelto3s/po07oFFuZSo5ThjWq+WnlrXtd0nQ10rnPMCOUyUpAl7lN1e39EP+C1x
         ayQ2/pQI64hJ1O3aUh1oOi6YGPUczA7AAoKnj4Fy6PYXc/Slz3Cldq9cdAQ/fUxYD0G8
         jcRXPa/u+5UEcAP/Psaxk2fq9gUh8HposZg1tKVXQU+vfpwaFGE6k+B0XGA6KN6Q3w69
         Z+50Kaj/dJDelnBPs2/vKaeJSrpwOk0ruIP9lJWT/nXRUiZk0EDZ7M3hseZXVodQl4Ec
         XwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Odf7KAqNDFyuz5mWtDJTadv28d443cvzLQQrE39N2Us=;
        b=BqT6NijWpFe21LfhZ2wpcbBsE4jK+FSCsO30AWvTgP9D47qwt08sy4k4cRZeKsXAt2
         BhmN4iWG6zsJT2N7rzZBpw0URIoEbLYN/mxqxnhKHpzFyoOFaQGvpOuMceTix1H5/W0s
         yVede7XXbnnnIIuNWYjRhOqGH66fi5o+JbY59WdtcioOTjYzsEeYTjSxgOWElosNFTGN
         rI8PIBlN0AcehJ22FLX4/gfgdBw8NxLCknIOPihWX8yYxSUiYQ1jMKvfknMGhWHY5Wzj
         hMsw0rJcm6xzzqILxD32X0w/GKTobwHzcxpOaIvTv8Et7zf5iX46xPZJnrosah5bpRuu
         QO/g==
X-Gm-Message-State: APjAAAXa98DAZDCabuYf1g0CbKM4mUJpfTUcbUiLGniza4laHrFHKpHD
        bt+AF77XHT6ji9b+MEhAXkluIMKLqXYX0LJVVUk=
X-Google-Smtp-Source: APXvYqwt9GcXNn+xFqzlBYmaUVgLAD/tAfd1EnrqRz0Vr2i74Psa3qI58aPCT1/KQ/s1pb+Pga3pagMxcyX2dCyV3gY=
X-Received: by 2002:ac8:1417:: with SMTP id k23mr22538165qtj.93.1570329343907;
 Sat, 05 Oct 2019 19:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191004224037.1625049-1-andriin@fb.com> <20191004224037.1625049-3-andriin@fb.com>
 <20191006012416.5lq4xhhmdtgcoemc@ast-mbp>
In-Reply-To: <20191006012416.5lq4xhhmdtgcoemc@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 19:35:32 -0700
Message-ID: <CAEf4Bza_BzDYjzsxYKrz8mJ2CkfseFFoDG9j2XR9b80S4QYp7A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/4] libbpf: add bpf_object__open_{file,mem}
 w/ extensible opts
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 5, 2019 at 6:24 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Oct 04, 2019 at 03:40:35PM -0700, Andrii Nakryiko wrote:
> > Add new set of bpf_object__open APIs using new approach to optional
> > parameters extensibility allowing simpler ABI compatibility approach.
> >
> > This patch demonstrates an approach to implementing libbpf APIs that
> > makes it easy to extend existing APIs with extra optional parameters in
> > such a way, that ABI compatibility is preserved without having to do
> > symbol versioning and generating lots of boilerplate code to handle it.
> > To facilitate succinct code for working with options, add OPTS_VALID,
> > OPTS_HAS, and OPTS_GET macros that hide all the NULL, size, and zero
> > checks.
> >
> > Additionally, newly added libbpf APIs are encouraged to follow similar
> > pattern of having all mandatory parameters as formal function parameters
> > and always have optional (NULL-able) xxx_opts struct, which should
> > always have real struct size as a first field and the rest would be
> > optional parameters added over time, which tune the behavior of existing
> > API, if specified by user.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ...
> > +/* Helper macro to declare and initialize libbpf options struct
> > + *
> > + * This dance with uninitialized declaration, followed by memset to zero,
> > + * followed by assignment using compound literal syntax is done to preserve
> > + * ability to use a nice struct field initialization syntax and **hopefully**
> > + * have all the padding bytes initialized to zero. It's not guaranteed though,
> > + * when copying literal, that compiler won't copy garbage in literal's padding
> > + * bytes, but that's the best way I've found and it seems to work in practice.
> > + */
> > +#define LIBBPF_OPTS(TYPE, NAME, ...)                                     \
> > +     struct TYPE NAME;                                                   \
> > +     memset(&NAME, 0, sizeof(struct TYPE));                              \
> > +     NAME = (struct TYPE) {                                              \
> > +             .sz = sizeof(struct TYPE),                                  \
> > +             __VA_ARGS__                                                 \
> > +     }
> > +
> > +struct bpf_object_open_opts {
> > +     /* size of this struct, for forward/backward compatiblity */
> > +     size_t sz;
> > +     /* object name override, if provided:
> > +      * - for object open from file, this will override setting object
> > +      *   name from file path's base name;
> > +      * - for object open from memory buffer, this will specify an object
> > +      *   name and will override default "<addr>-<buf-size>" name;
> > +      */
> > +     const char *object_name;
> > +     /* parse map definitions non-strictly, allowing extra attributes/data */
> > +     bool relaxed_maps;
> > +};
> > +#define bpf_object_open_opts__last_field relaxed_maps
>
> LIBBPF_OPTS macro doesn't inspire confidence, but despite the ugliness
> it is strictly better than what libbpf is using internally to interface
> into kernel via similar bpf_attr api.
> So I think it's an improvement.
> Should this macro be used inside libbpf as well?
> May be rename it too to show that it's not libbpf specific?
>
> Anyhow all that can be done in follow up.
>
> Applied. Thanks
>

Thanks!

I think I'll keep LIBBPF_OPTS because it's specific to this xxx_opts
convention, which has .sz field. bpf_attr doesn't have that. But I'll
create a similar macro for internal libbpf usage and will put it into
bpf_internal.h.
