Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A8DE7850
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404366AbfJ1SXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:23:23 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38325 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404359AbfJ1SXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:23:22 -0400
Received: by mail-qk1-f193.google.com with SMTP id e2so850741qkn.5;
        Mon, 28 Oct 2019 11:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V/TfInN/7wY8IImWBzQpaHXY95U6VOk93yirrzOxwLU=;
        b=B/PjCMTxJNTwZ8B9zkfxkl75Mweia5dDzHco9vbMkewQf2D8BIZPnLQdrKMI3jvZHc
         EYH5l5ceDoTtgiOP2kRNneEQpxUhCGgHw1ORHEug7nkpj+rzSMxMSL3tW4svUbEq5lCH
         XsOGgvbk8pczZMFneuWgnnLOWdGqrfNL58GkzpxTMdGEmRzRvpYh6ipwmdW1jipNHUFd
         QyyLYhdbJ5yVhpBFF7NmnkVixZ1lMi40wgXUyZP24E6bAjxsSPLSf0OYA2ulNmMLyTJ+
         nSHginjQMrAAnT3UVB4zL9yk0jK4XsQmX9XZ+d2Q7jkapWD5K8uGaqXKshE+spTdI+ZD
         9Fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V/TfInN/7wY8IImWBzQpaHXY95U6VOk93yirrzOxwLU=;
        b=LaAzxAK3LHvYnHzt/LSAOx8XKX5eAspF01uWBDWoGDv9qiJsS30wZJW2uV7Bd/kUp2
         ABY07F99Injbd5grMzAKWsKjErkI/ePNNKqe2a/57fyuC4Ikb6mgoqqevR9oKLsURK/3
         6HaGYnojXL65xs+XKZhhkoxDAWP9uqPoU6Al/vKxR1z4ILCRa3qiOtL+zoRXN1CqhqMf
         h1n6i+e58beJ/+FDB25EYDtO2wQuvjhUhZsRNIEgndN0XV4chpE0ZI5wxfuGzaEHCbf6
         V1mM3RkdneYRrGVuRXh4A3kuUer95XxIwlQI6jc7hM1sZNAUBpH5lYhKoJU8hAIoDL+W
         S/NQ==
X-Gm-Message-State: APjAAAWFKlXJN+7P1KAvBM9mJB6hP3ln6Zv1H7j9TmnfcQLjKKrwZ3bO
        CJ1l3nwxuzqk9Dn86e1trljtirdB/MdPoYcC3po=
X-Google-Smtp-Source: APXvYqxGjZumUkmmPMdXJDDA1+igKXAbOzkMalSA1cFjGrNHM3dGgS9IVfqmmcFsBd+0Sca6GJaVwiix5YQU4hCmTmM=
X-Received: by 2002:a37:8046:: with SMTP id b67mr17706996qkd.437.1572287001355;
 Mon, 28 Oct 2019 11:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
 <157220959980.48922.12100884213362040360.stgit@toke.dk> <20191028140624.584bcc1e@carbon>
 <87imo9roxf.fsf@toke.dk> <483546c6-14b9-e1f1-b4c1-424d6b8d4ace@fb.com> <20191028171303.3e7e4601@carbon>
In-Reply-To: <20191028171303.3e7e4601@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Oct 2019 11:23:09 -0700
Message-ID: <CAEf4BzbL_5VHyKkDuCcUjzaUDJAa=-0i0+mFGJtkkbm5pKyycQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/4] selftests: Add tests for automatic map pinning
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Anton Protopopov <aspsk2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 9:13 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Mon, 28 Oct 2019 15:32:26 +0000
> Yonghong Song <yhs@fb.com> wrote:
>
> > On 10/28/19 6:15 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> > >
> > >> On Sun, 27 Oct 2019 21:53:19 +0100
> > >> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> > >>
> > >>> diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/too=
ls/testing/selftests/bpf/progs/test_pinning.c
> > >>> new file mode 100644
> > >>> index 000000000000..ff2d7447777e
> > >>> --- /dev/null
> > >>> +++ b/tools/testing/selftests/bpf/progs/test_pinning.c
> > >>> @@ -0,0 +1,29 @@
> > >>> +// SPDX-License-Identifier: GPL-2.0
> > >>> +
> > >>> +#include <linux/bpf.h>
> > >>> +#include "bpf_helpers.h"
> > >>> +
> > >>> +int _version SEC("version") =3D 1;
> > >>> +
> > >>> +struct {
> > >>> + __uint(type, BPF_MAP_TYPE_ARRAY);
> > >>> + __uint(max_entries, 1);
> > >>> + __type(key, __u32);
> > >>> + __type(value, __u64);
> > >>> + __uint(pinning, LIBBPF_PIN_BY_NAME);
> > >>> +} pinmap SEC(".maps");
> > >>
> > >> So, this is the new BTF-defined maps syntax.
> > >>
> > >> Please remind me, what version of LLVM do we need to compile this?
> > >
> > > No idea what the minimum version is. I'm running LLVM 9.0 :)
> >
> > LLVM 9.0 starts to support .maps.
> > There is no dependency on pahole.
>
> LLVM 9.0.0 is still very new:
>  - 19 September 2019: LLVM 9.0.0 is now available
>
> For my XDP-tutorial[1], I cannot required people to have this new llvm
> version.  But I would like to teach people about this new syntax (note,
> I can upgrade libbpf version via git-submodule, and update bpf_helpers.h)=
.
>
> To Andrii, any recommendations on how I can do the transition?
>
> I'm thinking, it should be possible to define both ELF-object sections
> SEC "maps" and ".maps" at the same time. But how does libbpf handle that?
> (Who takes precedence?)

Yes, libbpf will load both maps and .maps. There is no precedence,
they are treated equally and are just added to the list of maps. But
if there is .maps section without associated BTF, bpf_object__open
will fail (because BTF is mandatory at that point).

>
>
> (Alternatively, I can detect the LLVM version, in the Makefile, and have
> a #ifdef define in the code)
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
> [1] https://github.com/xdp-project/xdp-tutorial
>
