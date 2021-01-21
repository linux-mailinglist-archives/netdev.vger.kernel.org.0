Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099EF2FF522
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbhAUTwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 14:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbhAUTwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 14:52:35 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8818C06174A;
        Thu, 21 Jan 2021 11:51:54 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id r32so3214836ybd.5;
        Thu, 21 Jan 2021 11:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+ryxI2bZ0j1bhmK50ERwXaK1thGqk3WteUbJ53i1ic=;
        b=nikmWnXA40vWCwZZVZZ5j0u1OqClkFGXfPfH6h5HRuYzVE4DSuawQF7VqmvpNe8Mtz
         GDtonQs5pYYLSZxVEMhbHHgFhUVSfmL26s9qp38hCV8nU5aC4ujtDqfAwxAkY3Ml7CAs
         ikEmVcDOins6/8X8WXmGSQcWU3Asm1ZTjq7o1eyKRO9UXtmn5ovccnC5BcOYEbzh3yhf
         +b5zl1mxeIFvCL6o6DFXcoBAIuG5UMWKHEhFaj/tCpJUqprd9b5d261pO1cIL0j4XDJe
         yfQZtUkp5mbXRgVv80J17ja2o0ag9mTZymUyqlQioxYKJnhk44DoOUD/H0lt1bqX2d2W
         nHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+ryxI2bZ0j1bhmK50ERwXaK1thGqk3WteUbJ53i1ic=;
        b=cUB1OtZFGkPBwcjI03XKRPob/KHA1HSJPQeT/dsbOWfArEMfjbyGgfTfRp6qL/gIa+
         TEXRU63U+2Cm/Uy8KouO6ovLzEcapXSZX8y/y705p3y6cqwoks70z2psf0tsiSqmbz8M
         XpAjzqrRAnVZevx9KD7JFOMTLEZVexAF5v4xxm/NobrgkQnrvQMqhJHhjwuCwphRGHEQ
         /pJJ+qOAHuvhxaxXqbb/oko8i8MzQQy1Wu2U2ElQlaYpQJLuKFs0zyIcoCRLadwIg2Dx
         aOSEwrqD1ZMPVPoXwTjUqu5hhWJL7+I+3iWZ8wI2PT20FZjxoedtebv769kMgQCWkPcE
         2asg==
X-Gm-Message-State: AOAM530WC90lHuge56pQU0fkRs1BIaAe2UlZB3IVhQOleiuEGw47d5Mq
        biB1MrQ9QRWcRrK/Z8GwWmFaYd/9Q6OUFnsySI28N6Dy+yiiQQ==
X-Google-Smtp-Source: ABdhPJytes9LDpHx1Bo4tt/+3nzBLErqkMs9KmRH9qNLLMFrQ4ALSFqZyyK7xkNsATVIzwxKb6W2jv+rt1D4z3DKlKM=
X-Received: by 2002:a25:f40e:: with SMTP id q14mr1431799ybd.230.1611258714152;
 Thu, 21 Jan 2021 11:51:54 -0800 (PST)
MIME-Version: 1.0
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
 <1610921764-7526-4-git-send-email-alan.maguire@oracle.com> <CAEf4BzZ6bYenSTUmwu7jXqQOyD=AG75oLsLE5B=9ycPjm1jOkw@mail.gmail.com>
In-Reply-To: <CAEf4BzZ6bYenSTUmwu7jXqQOyD=AG75oLsLE5B=9ycPjm1jOkw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Jan 2021 11:51:42 -0800
Message-ID: <CAEf4Bzb4z+ZA+taOEo=N9eSGZaCqMALpFxShujm9GahBOFnhvg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] libbpf: BTF dumper support for typed data
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 10:56 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Jan 17, 2021 at 2:22 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > Add a BTF dumper for typed data, so that the user can dump a typed
> > version of the data provided.
> >
> > The API is
> >
> > int btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
> >                              const struct btf_dump_emit_type_data_opts *opts,
> >                              void *data);
> >

Two more things I realized about this API overnight:

1. It's error-prone to specify only the pointer to data without
specifying the size. If user screws up and scecifies wrong type ID or
if BTF data is corrupted, then this API would start reading and
printing memory outside the bounds. I think it's much better to also
require user to specify the size and bail out with error if we reach
the end of the allowed memory area.

2. This API would be more useful if it also returns the amount of
"consumed" bytes. That way users can do more flexible and powerful
pretty-printing of raw data. So on success we'll have >= 0 number of
bytes used for dumping given BTF type, or <0 on error. WDYT?

> > ...where the id is the BTF id of the data pointed to by the "void *"
> > argument; for example the BTF id of "struct sk_buff" for a
> > "struct skb *" data pointer.  Options supported are
> >
> >  - a starting indent level (indent_lvl)
> >  - a set of boolean options to control dump display, similar to those
> >    used for BPF helper bpf_snprintf_btf().  Options are
> >         - compact : omit newlines and other indentation
> >         - noname: omit member names
> >         - zero: show zero-value members
> >
> > Default output format is identical to that dumped by bpf_snprintf_btf(),
> > for example a "struct sk_buff" representation would look like this:
> >
> > struct sk_buff){
> >  (union){
> >   (struct){
>
> Curious, these explicit anonymous (union) and (struct), is that
> preferred way for explicitness, or is it just because it makes
> implementation simpler and thus was chosen? I.e., if the goal was to
> mimic C-style data initialization, you'd just have plain .next = ...,
> .prev = ..., .dev = ..., .dev_scratch = ..., all on the same level. So
> just checking for myself.
>
> >    .next = (struct sk_buff *)0xffffffffffffffff,
> >    .prev = (struct sk_buff *)0xffffffffffffffff,
> >    (union){
> >     .dev = (struct net_device *)0xffffffffffffffff,
> >     .dev_scratch = (long unsigned int)18446744073709551615,
> >    },
> >   },
> > ...
> >
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
>

[...]
