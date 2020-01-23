Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A6F14603C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAWBQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:16:33 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40395 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWBQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 20:16:33 -0500
Received: by mail-lf1-f67.google.com with SMTP id c23so168339lfi.7;
        Wed, 22 Jan 2020 17:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BUOdE4wpkgkZk4Hhigcog/IRl3QaveS9cvScHToG9tk=;
        b=d3sDwnWvRY5yrnIsk9RiLbgQtQQYEgB9aWMyF6GNNmNVxgjqQeNnsRvOI7VoZU8/SN
         nWj7rp7vRmiuVVoXP8mtdoYikaBqNOo5qbCBhdoLU0yzDVVaJgGsjkbFjFYUzqCU8WOd
         ZmFVfFkOiOEeNVBnTKMEnCTDgdeGqaGy7yCVoY8hGwvLJfGNJpjK4rgQLhN5rN9B5Yf1
         1IJYh2yC/6I2sIIKdtVkFJ+bhHXJHCZ8s5iXtebTddHE5SoswLYfWOUXM6Oz0cKmuA3j
         DWPOiM/vuWFYyN4UQGeAxeSzvDQWj+FJ/PDGo0OvnPgSWRE5lNPA5SboRKQ2fPuQDKAF
         5Mag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BUOdE4wpkgkZk4Hhigcog/IRl3QaveS9cvScHToG9tk=;
        b=c941iJ7HPF56nO2KiDp32CMKQPA50WCDSmdUxv9B88CMVUqhGP24g2bRatRsjaiY70
         5DfwPF8NgTaBQqNlihX2Rrq3W0/A5IOLGqAhdoyhJg7L9fjy3rXIFj7pJ7nz2CI719r1
         XyCt2awX/FoTynUxV3oiwbdzO7AeeZ9ow7KL+HNcj+uGinXXQGcJrlkJ1dP7bokQbr5q
         ginyNzQQQQBYCUHQbc4m/EBkhR/+RAh6OfvRb3HRU6jAHe72LU/TUpXBjxqLX060ED1Q
         FLtScKOUzCPm3cTsVaveu+5rPqGQplCzmxXdfy/968TGGwmKqAuYej4ErwGqUW1tJaLd
         Zw+w==
X-Gm-Message-State: APjAAAUmfEL9Qbm+mNDmU0yrQcEkQk+fO06yoE9dKARBP3aGQhvGtSvW
        uZIL/xA8dQHq55PieN013EQiiTixRmuLuDH+ayg=
X-Google-Smtp-Source: APXvYqzxzhKZDe8q2GC6Fw9N+XtHxc3+hz9u5Y5/Lv4vsHEqbDLrV9glknOfFLECcbNZ+i/YcR97NRM/T6zf+q10uH4=
X-Received: by 2002:ac2:5f68:: with SMTP id c8mr3152355lfc.196.1579742191342;
 Wed, 22 Jan 2020 17:16:31 -0800 (PST)
MIME-Version: 1.0
References: <20200121120512.758929-1-jolsa@kernel.org> <20200121120512.758929-2-jolsa@kernel.org>
 <CAADnVQKeR1VFEaRGY7Zy=P7KF8=TKshEy2inhFfi9qis9osS3A@mail.gmail.com>
 <0e114cc9-421d-a30d-db40-91ec7a2a7a34@fb.com> <20200122091336.GE801240@krava>
 <20200122160957.igyl2i4ybvbdfoiq@ast-mbp> <20200122211838.GA828118@krava>
In-Reply-To: <20200122211838.GA828118@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Jan 2020 17:16:20 -0800
Message-ID: <CAADnVQJEkWT1VWW2h_ZO4UTMhfHuRzFjdXizwrbBG=tVf3Y9=w@mail.gmail.com>
Subject: Re: [PATCH 1/6] bpf: Allow ctx access for pointers to scalar
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 1:18 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Jan 22, 2020 at 08:09:59AM -0800, Alexei Starovoitov wrote:
>
> SNIP
>
> > > > > It cannot dereference it. Use it as what?
> > > >
> > > > If this is from original bcc code, it will use bpf_probe_read for
> > > > dereference. This is what I understand when I first reviewed this patch.
> > > > But it will be good to get Jiri's confirmation.
> > >
> > > it blocked me from accessing 'filename' argument when I probed
> > > do_sys_open via trampoline in bcc, like:
> > >
> > >     KRETFUNC_PROBE(do_sys_open)
> > >     {
> > >         const char *filename = (const char *) args[1];
> > >
> > > AFAICS the current code does not allow for trampoline arguments
> > > being other pointers than to void or struct, the patch should
> > > detect that the argument is pointer to scalar type and let it
> > > pass
> >
> > Got it. I've looked up your bcc patches and I agree that there is no way to
> > workaround. BTF type argument of that kernel function is 'const char *' and the
> > verifier will enforce that if bpf program tries to cast it the verifier will
> > still see 'const char *'. (It's done this way by design). How about we special
> > case 'char *' in the verifier? Then my concern regarding future extensibility
> > of 'int *' and 'long *' will go away.
> > Compilers have a long history special casing 'char *'. In particular signed
> > char because it's a pointer to null terminated string. I think it's still a
> > special pointer from pointer aliasing point of view. I think the verifier can
> > treat it as scalar here too. In the future the verifier will get smarter and
> > will recognize it as PTR_TO_NULL_STRING while 'u8 *', 'u32 *' will be
> > PTR_TO_BTF_ID. I think it will solve this particular issue. I like conservative
> > approach to the verifier improvements: start with strict checking and relax it
> > on case-by-case. Instead of accepting wide range of cases and cause potential
> > compatibility issues.
>
> ok, so something like below?
>
> jirka
>
>
> ---
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 832b5d7fd892..dd678b8e00b7 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3664,6 +3664,19 @@ struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
>         }
>  }
>
> +static bool is_string_ptr(struct btf *btf, const struct btf_type *t)
> +{
> +       /* t comes in already as a pointer */
> +       t = btf_type_by_id(btf, t->type);
> +
> +       /* allow const */
> +       if (BTF_INFO_KIND(t->info) == BTF_KIND_CONST)
> +               t = btf_type_by_id(btf, t->type);
> +
> +       /* char, signed char, unsigned char */
> +       return btf_type_is_int(t) && t->size == 1;
> +}

yep. looks like btf doesn't distinguish signedness for chars.
So above is good.
