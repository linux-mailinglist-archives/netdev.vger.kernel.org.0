Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43E717542F
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 07:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgCBG5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 01:57:51 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:39332 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgCBG5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 01:57:50 -0500
Received: by mail-io1-f67.google.com with SMTP id h3so10319622ioj.6;
        Sun, 01 Mar 2020 22:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nrFu2KKyZmxCAHYq/fyE1aIbF4fy/TeMjczCnvnCazg=;
        b=YldOFDCehBVoWqYwHpoq4EsVquC+KOD4ScKdxAzbtLlwP+gy+k4/dY2jtVh8VjNlEE
         Bk8BsJhPUIZ8Y3HPFSdzPiqLqtQPLKsPlmJXScfPT4k/dIR8KWV2eYTJgMK7XId4STn8
         RsT8rm0m3xCGlfwrwjiWYqov43Qx3nSUX2B/Dp988zYm448u19AwKg99WyG/Uk0nxu2i
         2b10BVGcp/y7CndtYd+VxYK3q2mBN1guPlR5qwxX0J6aEbJ/oZyDdSOOfm3GMCyzj+JX
         9of2iU9BuMUjl+j4A4+ZtCxw9p2/fu4YVOoC2z96tSzQZOyNpQi/YjOeWjK4cpds8dTY
         qGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nrFu2KKyZmxCAHYq/fyE1aIbF4fy/TeMjczCnvnCazg=;
        b=LlD3lKpjxdlEoRVzkEJGI7FI7GaOdzA+XfRL2bQLgvlRmvhf3993IAKjjRefQs1otr
         AqYO3og82nOSBP99kMJl1WzemXMfGrbK6/ON2Z6PsJ+WsZfrAi+3rVpHZgYgsVnFFwid
         TlZ+8DUjdHgeA3A9yjI4KtOEgG+xKNzkcC6oC5Cr/QB1axMXnZtUhZbeZ5L7DMKKKyUM
         OhXIUg1NoyH27eWurTyTNo648oWxJtZDjg1Fh8z3xHEoJ09pIFhxe4fyvjU9XlikRBhZ
         y/OU0/lwQZaga0VFKqAZ7Vs3aalWpsgRJwCH0gDH0/4gmgCFk9EpbSyzb6/BDnB14kq5
         AiSg==
X-Gm-Message-State: APjAAAXvGJZ6rvAQRHFLIbAMeRHR2d/SPSWX5GasdYe8vD6fvUd9/gb9
        FwPqJieprI+gs4penap+FpdH2Syflj9iAmk+CtdAN/Yo
X-Google-Smtp-Source: APXvYqz5+hEEUCW548huA2G7W5d1Sh76hIwgHn+5VBIvXwkZ19HiKX5XJpdkni808XHuzA7Gfe6Lg1hPIOK7NBMkSWA=
X-Received: by 2002:a02:a795:: with SMTP id e21mr12502166jaj.1.1583132269817;
 Sun, 01 Mar 2020 22:57:49 -0800 (PST)
MIME-Version: 1.0
References: <20200228020212.16183-1-komachi.yoshiki@gmail.com> <CAEf4Bza9J3e=dfzDud6KY7_=4Qv77YqW2srfdxKg9ieiUCJgXw@mail.gmail.com>
In-Reply-To: <CAEf4Bza9J3e=dfzDud6KY7_=4Qv77YqW2srfdxKg9ieiUCJgXw@mail.gmail.com>
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
Date:   Mon, 2 Mar 2020 15:57:39 +0900
Message-ID: <CAA6waGKtG_fE3Q+Dig9K1L3D9FRErQmpoMtMbPzuzkyODYXV7A@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: btf: Fix BTF verification of the enum size in struct/union
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020=E5=B9=B42=E6=9C=8829=E6=97=A5(=E5=9C=9F) 9:23 Andrii Nakryiko <andrii.=
nakryiko@gmail.com>:
>
> On Thu, Feb 27, 2020 at 6:07 PM Yoshiki Komachi
> <komachi.yoshiki@gmail.com> wrote:
> >
> > btf_enum_check_member() checked if the size of "enum" as a struct
> > member exceeded struct_size or not. Then, the function definitely
> > compared it with the size of "int" now. Therefore, errors could occur
> > when the size of the "enum" type was changed.
> >
> > Although the size of "enum" is 4-byte by default, users can change it
> > as needed (e.g., the size of the following test variable is not 4-byte
> > but 1-byte). It can be used as a struct member as below:
> >
> > enum test : char {
>
> you can't specify that in pure C, but this will work for C:
>
> struct {
>     enum { X, Y, Z } __attribute__((packed)) e;
> } tmp;
>
> Please add such a selftest, as part of fixing this bug. Thanks!
>
> Otherwise logic looks good.

Thank you for kind comments!
I will add a selftest program, and submit the next version later.

Best regards,

> >         X,
> >         Y,
> >         Z,
> > };
> >
> > struct {
> >         char a;
> >         enum test b;
> >         char c;
> > } tmp;
> >
> > With the setup above, when I tried to load BTF, the error was given
> > as below:
> >
> > ------------------------------------------------------------------
> >
> > [58] STRUCT (anon) size=3D3 vlen=3D3
> >         a type_id=3D55 bits_offset=3D0
> >         b type_id=3D59 bits_offset=3D8
> >         c type_id=3D55 bits_offset=3D16
> > [59] ENUM test size=3D1 vlen=3D3
> >         X val=3D0
> >         Y val=3D1
> >         Z val=3D2
> >
> > [58] STRUCT (anon) size=3D3 vlen=3D3
> >         b type_id=3D59 bits_offset=3D8 Member exceeds struct_size
> >
> > libbpf: Error loading .BTF into kernel: -22.
> >
> > ------------------------------------------------------------------
> >
> > The related issue was previously fixed by the commit 9eea98497951 ("bpf=
:
> > fix BTF verification of enums"). On the other hand, this patch fixes
> > my explained issue by using the correct size of "enum" declared in
> > BPF programs.
> >
> > Fixes: 179cde8cef7e ("bpf: btf: Check members of struct/union")
> > Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
> > ---
> >  kernel/bpf/btf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 7871400..32ab922 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -2418,7 +2418,7 @@ static int btf_enum_check_member(struct btf_verif=
ier_env *env,
> >
> >         struct_size =3D struct_type->size;
> >         bytes_offset =3D BITS_ROUNDDOWN_BYTES(struct_bits_off);
> > -       if (struct_size - bytes_offset < sizeof(int)) {
> > +       if (struct_size - bytes_offset < member_type->size) {
> >                 btf_verifier_log_member(env, struct_type, member,
> >                                         "Member exceeds struct_size");
> >                 return -EINVAL;
> > --
> > 1.8.3.1
> >
