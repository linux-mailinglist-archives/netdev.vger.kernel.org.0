Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F7D58942
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfF0RsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:48:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41172 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfF0RsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:48:10 -0400
Received: by mail-qt1-f196.google.com with SMTP id d17so3381805qtj.8;
        Thu, 27 Jun 2019 10:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8KacmKH3cAO5KqfGKUf465nKcuX4PFadp3LJhvSKwIs=;
        b=LIO1JaSOWhbmy1kvAJwKb4R99OykBWxYGbpMlusudxd3jz9ynRFJi2xKxYX1hbCTjv
         e3Mk8R8bq/s5ikWyb3YrBBZ5wbNtBbwQQkFZA8NebJP6oGBklu76Y8oh0h720MQV1yxB
         LNy5bHOaNng0sfiI81c13SOM6lqoJ8VhwDOYNG15+C1CDtF0bPo75rbbta8G/uH9UliB
         VQJMUZO29r6nykWsXNNqRpn3vHECq3Oqp+ku/KF4TE9ub6xE6C+vk5Nht8uPGREGZI8x
         HcFsrC2p5Zm4urqi17Ry+Yr6bPbqa8C6A2JaR3M7BvKH3m9pFNM+okdx98ImXAJm3ZO4
         zIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8KacmKH3cAO5KqfGKUf465nKcuX4PFadp3LJhvSKwIs=;
        b=FX2dVZSOAwNgplMSw/+Idq1yj/A5+6ylslBCsAYX4E6bZwLuGNXZcSxE7ujLTcAGF/
         SgePFW4NxEb7LzMjcQLAZnS2M3zWPxt2Lc+KEBuAXZnSKuN4xw1cWOhX4qplN2wHIlkD
         wE3azyu1Inp1cs4Lt0ClF9wsh2Hsnpz6qS2qE5y9jzSiPF5xI+qRF2hAG4gvoGsZFEmz
         kBvjqJrdyKBTf3jsTWdnWsxrFZ/CDm/JhvxEjgH/A5S1HZ9FL4LuTdivthx7cwwccWOT
         4YMf4BO9v/ElZijPxGrbk2j+KlrNV+I/g3cb0ED8KP+EIQ/TWLrOFt4tyzFZweTjKakc
         ELUg==
X-Gm-Message-State: APjAAAUi8Td5BJDPlpS6SPT9ny2kJ2uMt/Cd6nL/G6c0NU+5/LExO5hI
        ecLlOwTBpoOk7dFPE2BPSeBMcB9IaXTaslfkhXU=
X-Google-Smtp-Source: APXvYqw2tJRG6DqVL95VyMi07GDvSgvk/Wbctb69x3VIWEQHo79Ah6mpijT7SNu/YAxiv8yR98Kkuf+KgI75ufYVmvQ=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr4245279qta.171.1561657689407;
 Thu, 27 Jun 2019 10:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190626232133.3800637-1-andriin@fb.com> <20190626232133.3800637-2-andriin@fb.com>
 <E28D922F-9D97-4836-B687-B4CBC3549AE1@fb.com>
In-Reply-To: <E28D922F-9D97-4836-B687-B4CBC3549AE1@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 Jun 2019 10:47:58 -0700
Message-ID: <CAEf4Bza1p4ozVV-Vn8ibV6JRtGc_voh-Mkx51eWvuVi1P8ogSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: capture value in BTF type info for
 BTF-defined map defs
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jun 26, 2019, at 4:21 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Change BTF-defined map definitions to capture compile-time integer
> > values as part of BTF type definition, to avoid split of key/value type
> > information and actual type/size/flags initialization for maps.
>
> If I have an old bpf program and compiled it with new llvm, will it
> work with new libbpf?

You mean BPF programs that used previous incarnation of BTF-defined
maps? No, they won't work. But we never released them, so I think it's
ok to change them. Nothing should be using that except for selftests,
which I fixed.

>
>
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---

<snip>

> > diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> > index 1a5b1accf091..aa5ddf58c088 100644
> > --- a/tools/testing/selftests/bpf/bpf_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> > @@ -8,6 +8,9 @@
> >  */
> > #define SEC(NAME) __attribute__((section(NAME), used))
> >
> > +#define __int(name, val) int (*name)[val]
> > +#define __type(name, val) val *name
> > +
>
> I think we need these two in libbpf.

Yes, but it's another story for another set of patches. We'll need to
provide bpf_helpers as part of libbpf for inclusion into BPF programs,
but there are a bunch of problems right now with existing
bpf_heplers.h that prevents us from just copying it into libbpf. We'll
need to resolve those first.

But then again, there is no use of __int and __type for user-space
programs, so for now it's ok.

>
> Thanks,
> Song
>
> > /* helper macro to print out debug messages */
> > #define bpf_printk(fmt, ...)                          \
> > ({                                                    \
> > --
> > 2.17.1
> >
>
