Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AB22A3C91
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 07:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgKCGGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 01:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCGGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 01:06:00 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6483C0617A6;
        Mon,  2 Nov 2020 22:06:00 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id b138so13848319yba.5;
        Mon, 02 Nov 2020 22:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BkHNdvekNpFBtDOo1TDcnKNomP3ALEaor20sqebrboo=;
        b=RNhDGW6qrJjIYrwb0FDJGa0oY3+pE2WtEjU/+PNfaNePS58qf5raCAFTYIN3bZ6vtN
         ctpm0Ls2LQEjRun5WXXFPNKoiRbSqJOxqXJOGj7qzvHyGEIAE1J6DJhj47UJOIqoYW7l
         S3D1ivCEWQiU+zb1IpQd2HqTZk42S3CWkFWU80PDreCfYsNnE9G7+7a9ERfQQRPuZeBA
         CNuQyl0edVRf4Vw5CWIuVrfKofQplmJ7vXqKk8s2L1LUu+FMl1cT05Dv6YGIJNsa0iSJ
         SN0fXy06bYarJidX7iGkTjiKQ4OhsKRJqgprPz1j2IOlTum7QvT5RIsJKHdo7dKZZ8JY
         5nJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BkHNdvekNpFBtDOo1TDcnKNomP3ALEaor20sqebrboo=;
        b=G9vpYFUNaGko10y2ZV+CrxeTEp562xIqQF9r7VbR42a6tJQ2F4O7S7736NkqbO6t8Z
         phUhVHAQSygyr9QrQUlfwzKH3dNDsIVroAvsQFv+7uuG+BIj4hBQml0hUGGcZbgTM4ZG
         zzEucwneee2YbnSHoBxb7KVp9C6E2F6OzmzhDF4wonthAQn3MEWLQJgJVmi1Z0Ctm+lC
         TjNVw3a1b4cPOjkclTfYpYVR+wh6hM1ZVCEIVOAcE2slKPF6BrF6CguMfOlVP4GNsEcX
         /PYcrEraZBjXeF+WA9a8lDcxTPS76RPbAcFiKRadXpzNJvAwdO9o1XRA0TwC3mSKbEX1
         za5Q==
X-Gm-Message-State: AOAM532EuZ80NZpBq5QomsNHadtXjI0J7gfVETCZ0vOu74VbYdaseNF8
        L4pVjEidJsEjwehYuQCyhcl0xkstsFRFcKT+Okk=
X-Google-Smtp-Source: ABdhPJxpO+OzaJycdr7flXWkg9BYiVSiSCkMwwbWnVG5WsSuZqh04G3Szi8YFcoCVqrQitYP6oVkEZiKv7x25tjepDw=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr26901830ybl.347.1604383560007;
 Mon, 02 Nov 2020 22:06:00 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-11-andrii@kernel.org>
 <23399683-99A4-4E91-9C7B-8B0E3A4083DE@fb.com>
In-Reply-To: <23399683-99A4-4E91-9C7B-8B0E3A4083DE@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 22:05:48 -0800
Message-ID: <CAEf4Bzbqi_PNU8ZJHBwjxDoHNieDwaviPojox_LynmQjcmaFLw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/11] selftests/bpf: add split BTF dedup selftests
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 9:35 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 28, 2020, at 5:59 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Add selftests validating BTF deduplication for split BTF case. Add a helper
> > macro that allows to validate entire BTF with raw BTF dump, not just
> > type-by-type. This saves tons of code and complexity.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> with a couple nits:
>
> [...]
>
> >
> > int fprintf_btf_type_raw(FILE *out, const struct btf *btf, __u32 id);
> > const char *btf_type_raw_dump(const struct btf *btf, int type_id);
> > +int btf_validate_raw(struct btf *btf, int nr_types, const char *exp_types[]);
> >
> > +#define VALIDATE_RAW_BTF(btf, raw_types...)                          \
> > +     btf_validate_raw(btf,                                           \
> > +                      sizeof((const char *[]){raw_types})/sizeof(void *),\
> > +                      (const char *[]){raw_types})
> > +
> > +const char *btf_type_c_dump(const struct btf *btf);
> > #endif
> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
> > new file mode 100644
> > index 000000000000..097370a41b60
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
> > @@ -0,0 +1,326 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Facebook */
> > +#include <test_progs.h>
> > +#include <bpf/btf.h>
> > +#include "btf_helpers.h"
> > +
> > +
> > +static void test_split_simple() {
> > +     const struct btf_type *t;
> > +     struct btf *btf1, *btf2 = NULL;
> > +     int str_off, err;
> > +
> > +     btf1 = btf__new_empty();
> > +     if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
> > +             return;
> > +
> > +     btf__set_pointer_size(btf1, 8); /* enforce 64-bit arch */
> > +
> > +     btf__add_int(btf1, "int", 4, BTF_INT_SIGNED);   /* [1] int */
> > +     btf__add_ptr(btf1, 1);                          /* [2] ptr to int */
> > +     btf__add_struct(btf1, "s1", 4);                 /* [3] struct s1 { */
> > +     btf__add_field(btf1, "f1", 1, 0, 0);            /*      int f1; */
> > +                                                     /* } */
> > +
>
> nit: two empty lines.

There is a comment on one of them, so I figured it's not an empty line?

>
> > +     VALIDATE_RAW_BTF(
> > +             btf1,
> > +             "[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
> > +             "[2] PTR '(anon)' type_id=1",
> > +             "[3] STRUCT 's1' size=4 vlen=1\n"
> > +             "\t'f1' type_id=1 bits_offset=0");
> > +
>
> [...]
>
> > +
> > +cleanup:
> > +     btf__free(btf2);
> > +     btf__free(btf1);
> > +}
> > +
> > +static void test_split_struct_duped() {
> > +     struct btf *btf1, *btf2 = NULL;
>
> nit: No need to initialize btf2, for all 3 tests.

yep, fixed all three

>
> > +     int err;
> > +
> [...]
>
