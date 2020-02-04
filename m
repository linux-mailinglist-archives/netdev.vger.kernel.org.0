Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB9215209E
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 19:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgBDSsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 13:48:11 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44045 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbgBDSsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 13:48:10 -0500
Received: by mail-qt1-f195.google.com with SMTP id w8so15133241qts.11;
        Tue, 04 Feb 2020 10:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pZ3lRV9H5GXmdJmVKgZelLW8v0KJbkKxQiunQLx4arI=;
        b=lviyihjaQlK93Z0tUJEGUeDEM7tmqTxavD7sfrMkXhQcfo5j2pdcqgBteI+yb9GNzU
         rwgJXk/uf+OizdrVCX1PTovV32kK2ce9eoQuOTjrKJk9YBb3QbOSa0sqJLTblGGXSutP
         9pCtEJ2zDGoPSfbJexSh1C54k26C6tqibEu23O7xPJY6TToyNnoxy5ck8wUqbxTmXXi6
         L3B3I4vMww9o4l9KCbMmlqo6iuBOTGP3y4f9m+om0V/30Evb5+GfiL9v2xXqXgEGjm0o
         jJ5JB2TtZj3kK4Oc3yTfyQLdsTge9Ibll4rweuGg2ORm62glV5k2l7QQPRvJ02ejDBMt
         18Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pZ3lRV9H5GXmdJmVKgZelLW8v0KJbkKxQiunQLx4arI=;
        b=rXCtpatQQ1N/XXp1dhe9Etxp8C9uS0y7lPW9ZkvYB1k2gqLWo1+Wsb70y4oZLglitv
         ucGfR87mPavcCsW1ChYWus70rRM+X9vsDD7egsy5t7I5Q2qCuAlADquE7O4fnvbOtbf+
         DZ5jA8j8QElGmH/CCdKzkIHe03Xns9zxjIwcE+l3UH/pKQJqnFRJcy2aTIU/xskFcrYa
         DaPg/etdtqbchqr4pSVRF/VhL9Ngtdj/W25OtfdTUB+jPHNyMP2jP7gsYMMkeYsdW8EF
         PqvZ70nzsOXBxzhkkhBVaOeyCz3Kvh/8xbCy7w4yXwnQRyOYQ+EfZ2/5cQJEhSVyTjqm
         glHQ==
X-Gm-Message-State: APjAAAWtwBEziu/hI//bO5cWRaG/1aQU6gD9JyuTHdck87ChtXp8Epsh
        Id4OgT1ZbZHCrP5M8YKxvp6Vx6hZsi1qV3VoUZE=
X-Google-Smtp-Source: APXvYqzAjb9rZmpKaAxpthXum21Sd9DUKvNAWQccHwUeJUvyMfw2XqIRfK3n0jKGnYlzDyN6z6CL6OOz1bjDJBmpdjE=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr29797867qtj.117.1580842089603;
 Tue, 04 Feb 2020 10:48:09 -0800 (PST)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk> <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk> <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com> <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
 <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com> <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
 <87h80669o6.fsf@toke.dk>
In-Reply-To: <87h80669o6.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Feb 2020 10:47:58 -0800
Message-ID: <CAEf4BzYGp95MKjBxNay2w=9RhFAEUCrZ8_y1pqzdG-fUyY63=w@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 4, 2020 at 12:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Feb 3, 2020 at 8:53 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 2/3/20 8:41 PM, Andrii Nakryiko wrote:
> >> > On Mon, Feb 3, 2020 at 5:46 PM David Ahern <dsahern@gmail.com> wrote=
:
> >> >>
> >> >> On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
> >> >>> Great! Just to disambiguate and make sure we are in agreement, my =
hope
> >> >>> here is that iproute2 can completely delegate to libbpf all the EL=
F
> >> >>>
> >> >>
> >> >> iproute2 needs to compile and continue working as is when libbpf is=
 not
> >> >> available. e.g., add check in configure to define HAVE_LIBBPF and m=
ove
> >> >> the existing code and move under else branch.
> >> >
> >> > Wouldn't it be better to statically compile against libbpf in this
> >> > case and get rid a lot of BPF-related code and simplify the rest of
> >> > it? This can be easily done by using libbpf through submodule, the
> >> > same way as BCC and pahole do it.
> >> >
> >>
> >> iproute2 compiles today and runs on older distributions and older
> >> distributions with newer kernels. That needs to hold true after the mo=
ve
> >> to libbpf.
> >
> > And by statically compiling against libbpf, checked out as a
> > submodule, that will still hold true, wouldn't it? Or there is some
> > complications I'm missing? Libbpf is designed to handle old kernels
> > with no problems.
>
> My plan was to use the same configure test I'm using for xdp-tools
> (where I in turn copied the structure of the configure script from
> iproute2):
>
> https://github.com/xdp-project/xdp-tools/blob/master/configure#L59
>
> This will look for a system libbpf install and compile against it if it
> is compatible, and otherwise fall back to a statically linking against a
> git submodule.

How will this work when build host has libbpf installed, but target
host doesn't? You'll get dynamic linker error when trying to run that
tool.

If the goal is to have a reliable tool working everywhere, and you
already support having libbpf as a submodule, why not always use
submodule's libbpf? What's the concern? Libbpf is a small library, I
don't think a binary size argument is enough reason to not do this. On
the other hand, by using libbpf from submodule, your tool is built
*and tested* with a well-known libbpf version that tool-producer
controls.

>
> We'll need to double-check that this will work on everything currently
> supported by iproute2, and fix libbpf if there are any issues with that.
> Not that I foresee any, but you never know :)
>
> -Toke
>
