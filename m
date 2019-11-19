Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9C41019DC
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 07:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKSG5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 01:57:20 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42362 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfKSG5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 01:57:20 -0500
Received: by mail-qk1-f196.google.com with SMTP id i3so4913317qkk.9;
        Mon, 18 Nov 2019 22:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u+jeWdT6HWTb1SiVsdvOoED7kd1OzXTEqmkrgMVmLe4=;
        b=ec3ThnPBroQs1KdrIxDdHnWXX5aSdcy1bVLbCZGfxoeIy25kQWJeY4u6oKxQA9uQl9
         SE4MLtjjnJju9VXe1RfUn8+AITP8hTrX4uxh29N6vQCWgzY2ZVMkWueHDXR4nkFHTZ51
         ng/6vEbYHd9FaJVEMvg93qLEijoxWPFtWWVPvNS2OCT7OA2nOIbuOHVwLXnbapwD55qv
         qCCsn9SPjITWjmfz0dGYD8VM4p7BMOli09a6GvlOZnhpZ6qld85aDVScWj/UZU/057T9
         MubXMJ/ifS4PhKTpZ1EbXBNw95sow4EoWOrhgNXWnISoFude8I/dQXYRg4Qt/Qx/hOc5
         SQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u+jeWdT6HWTb1SiVsdvOoED7kd1OzXTEqmkrgMVmLe4=;
        b=K8PGVMWKuAyOSdGUyLgdsuYcdTiiF9+PeBj6NrqvK2rZ8xdOnWtiIMbl/iPYSQT4O7
         6uLx8Av8aaLOHIWZO7itqyYJnXJ4JMZh3Mrm7kkowOITqHjo0R6N1rwfEwPoTB6lf4/d
         B6r0GmPBxnQ+gzzALW8Ts31io08vID3hOlAvelm433oFCj0+PWI3ZlW1+19bvRX+xZ4J
         ZCOBZsWPUamkdP61Q6xsIA6qRYjOxUA0tss1MzAClOdy2L8Bon1XdQegzZZgJTN/evj/
         K1mWR2ZwCQUMMu5tzg8lfjefI/gZAxWyRjZHcLT0rxzzyHLEtwQyMq7ZRVmS1wYYRn+V
         mCjA==
X-Gm-Message-State: APjAAAWWVeyaJ87bs2pYVvOWQerqVf1smi7v35ZJux28JGJd79ny3nvD
        v7+h+UZnMKp+ceGYph3ISlSLCLuEQbBDQsaU9Gs=
X-Google-Smtp-Source: APXvYqyZu/hAmGZI40SLnJPzk46kN9gaNV1C85B0lg9O0tFUEvAs7+AA02ZDDor8bEPf+uxOcU7UNq4EJVb2+rLsMB8=
X-Received: by 2002:a37:aa8b:: with SMTP id t133mr15874996qke.449.1574146636809;
 Mon, 18 Nov 2019 22:57:16 -0800 (PST)
MIME-Version: 1.0
References: <20191117070807.251360-1-andriin@fb.com> <20191117070807.251360-6-andriin@fb.com>
 <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Nov 2019 22:57:05 -0800
Message-ID: <CAEf4BzaNEU_vpa98QF1Ko_AFVX=3ncykEtWy0kiTNW9agsO+xg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern variables
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

On Mon, Nov 18, 2019 at 7:21 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Nov 16, 2019 at 11:08:06PM -0800, Andrii Nakryiko wrote:
> > Add support for extern variables, provided to BPF program by libbpf. Currently
> > the following extern variables are supported:
> >   - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
> >     executing, follows KERNEL_VERSION() macro convention;
> >   - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
> >     boolean, and integer values are supported. Strings are not supported at
> >     the moment.
> >
> > All values are represented as 64-bit integers, with the follow value encoding:
> >   - for boolean values, y is 1, n or missing value is 0;
> >   - for tristate values, y is 1, m is 2, n or missing value is 0;
> >   - for integers, the values is 64-bit integer, sign-extended, if negative; if
> >     config value is missing, it's represented as 0, which makes explicit 0 and
> >     missing config value indistinguishable. If this will turn out to be
> >     a problem in practice, we'll need to deal with it somehow.
>
> I read that statement as there is no extensibility for such api.

What do you mean exactly?

Are you worried about 0 vs undefined case? I don't think it's going to
be a problem in practice. Looking at my .config, I see that integer
config values set to their default values are still explicitly
specified with those values. E.g.,

CONFIG_HZ_1000=y
CONFIG_HZ=1000

CONFIG_HZ default is 1000, if CONFIG_HZ_1000==y, but still I see it
set. So while I won't claim that it's the case for any possible
integer config, it seems to be pretty consistent in practice.

Also, I see a lot of values set to explicit 0, like:

CONFIG_BASE_SMALL=0

So it seems like integers are typically spelled out explicitly in real
configs and I think this 0 default is pretty sane.

Next, speaking about extensibility. Once we have BTF type info for
externs, our possibilities are much better. It will be possible to
support bool, int, in64 for the same bool value. Libbpf will be able
to validate the range and fail program load if declared extern type
doesn't match actual value type and value range. So I think
extensibility is there, but right now we are enforcing (logically)
everything to be uin64_t. Unfortunately, with the way externs are done
in ELF, I don't know neither type nor size, so can't be more strict
than that.

If we really need to know whether some config value is defined or not,
regardless of its value, we can have it by convention. E.g.,
CONFIG_DEFINED_XXX will be either 0 or 1, depending if corresponding
CONFIG_XXX is defined explicitly or not. But I don't want to add that
until we really have a use case where it matters.

>
> > Generally speaking, libbpf is not aware of which CONFIG_XXX values is of which
> > expected type (bool, tristate, int), so it doesn't enforce any specific set of
> > values and just parses n/y/m as 0/1/2, respectively. CONFIG_XXX values not
> > found in config file are set to 0.
>
> This is not pretty either.

What exactly: defaulting to zero or not knowing config value's type?
Given all the options, defaulting to zero seems like the best way to
go.

>
> > +
> > +             switch (*value) {
> > +             case 'n':
> > +                     *ext_val = 0;
> > +                     break;
> > +             case 'y':
> > +                     *ext_val = 1;
> > +                     break;
> > +             case 'm':
> > +                     *ext_val = 2;
> > +                     break;

reading some more code from scripts/kconfig/symbol.c, I'll need to
handle N/Y/M and 0x hexadecimals, will add in v2 after collecting some
more feedback on this version.

> > +             case '"':
> > +                     pr_warn("extern '%s': strings are not supported\n",
> > +                             ext->name);
> > +                     err = -EINVAL;
> > +                     goto out;
> > +             default:
> > +                     errno = 0;
> > +                     *ext_val = strtoull(value, &value_end, 10);
> > +                     if (errno) {
> > +                             err = -errno;
> > +                             pr_warn("extern '%s': failed to parse value: %d\n",
> > +                                     ext->name, err);
> > +                             goto out;
> > +                     }
>
> BPF has bpf_strtol() helper. I think it would be cleaner to pass whatever
> .config has as bytes to the program and let program parse n/y/m, strings and
> integers.

Config value is not changing. This is an incredible waste of CPU
resources to re-parse same value over and over again. And it's
incredibly much worse usability as well. Again, once we have BTF for
externs, we can just declare values as const char[] and then user will
be able to do its own parsing. Until then, I think pre-parsing values
into convenient u64 types are much better and handles all the typical
cases.

>
> LINUX_KERNEL_VERSION is a special case and can stay as u64.
>
