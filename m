Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D8DF57A8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387971AbfKHTeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:34:00 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35855 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfKHTeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:34:00 -0500
Received: by mail-qk1-f194.google.com with SMTP id d13so6326128qko.3;
        Fri, 08 Nov 2019 11:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vVjFDTyHHoe23R65Js+fJ8Q7TkZs+QvYfoQUfDVq0/w=;
        b=TcEjfklmtjueAi+SFsccwG240WSdsdJRa6/jtA1GROQxG7rcZHbUBhL+oqhbTaPS2B
         HLW4w0RTrcnomUwXQ2CKOXzAOiDm3+/VsCQt6vOTYGk0tAf7iAnipqO/XNIKfJNfbuZb
         2aVoZjPHiJZ0nYPSrvWhQRYAu6PRzj7qZGJ/1LqVTcLnlW4vNIHMLefM43rFhUnS0yrh
         KIGmPCnC3Di9gJvqBzLG5lg6u093NbTwqak4ZcRIZ2diIGSFVt6j4/cflEABsVKuk6ss
         dB5g/n+vGUJTgcWuiO4eiHscNMxMjnhnZBkh9H8k1KzK42/YR7fkFSfFdtlTezneHXT2
         Rx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vVjFDTyHHoe23R65Js+fJ8Q7TkZs+QvYfoQUfDVq0/w=;
        b=DzGU+fpawzzdM48aHy2qlomtJsLSmhmw1NMEkq9oLdR6AnDlJcQgKcQrEFhMMZkM+6
         2MATH336Xem9jGuCgPzM4q6dl70hsuorsxKlqHtGjwlOIe/E56aWwawctlUjRhF7KFow
         Cvus81gJeix68gsRhklSAPl85fe0Dz6m0BmCfO1ywmCqJdFi0ALIj4mj70tteG+7i9kK
         UOFa3A8cuUoNuhes8dvaM/EABiV3IzwsQ3kfE78FKYLKVYEzkjEopvQ/PjK4X2WzaKqT
         WG3gs/k23MZ5V9BW7eK59LoyithMC+i3mxBEibpF4Sb7Z2i79kT3qFvlC7vlvPaMWBhq
         1wFQ==
X-Gm-Message-State: APjAAAWbmWrqUsSyTQlpVomqIqBUIj7TxAVf2SfaJOVAe6mwha1Nc7VC
        rVjSp5HoIIwxu7xQvtB771MfJrRZXm7l8vw1Kz0QlQ==
X-Google-Smtp-Source: APXvYqye2s1OlQRwGHpX8Y5BDWB9Uf1rhcLgoUQOpOrXjN3c0oMJ7m916whutYY/N1N9le/ODEvqTaA5Glbl7aU7I+Q=
X-Received: by 2002:a37:b801:: with SMTP id i1mr10915924qkf.497.1573241639236;
 Fri, 08 Nov 2019 11:33:59 -0800 (PST)
MIME-Version: 1.0
References: <157314553801.693412.15522462897300280861.stgit@toke.dk> <157314554027.693412.3764267220990589755.stgit@toke.dk>
In-Reply-To: <157314554027.693412.3764267220990589755.stgit@toke.dk>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 8 Nov 2019 11:33:48 -0800
Message-ID: <CAPhsuW5stGGGiVH9dSHC4i0kwNcrUhj892DypkfzL=b7woRLvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] selftests/bpf: Add tests for automatic map
 unpinning on load failure
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 8:52 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This add tests for the different variations of automatic map unpinning on
> load failure.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/tes=
ting/selftests/bpf/progs/test_pinning.c
> index f69a4a50d056..f20e7e00373f 100644
> --- a/tools/testing/selftests/bpf/progs/test_pinning.c
> +++ b/tools/testing/selftests/bpf/progs/test_pinning.c
> @@ -21,7 +21,7 @@ struct {
>  } nopinmap SEC(".maps");
>
>  struct {
> -       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(type, BPF_MAP_TYPE_HASH);

Why do we need this change?

>         __uint(max_entries, 1);
>         __type(key, __u32);
>         __type(value, __u64);
>
