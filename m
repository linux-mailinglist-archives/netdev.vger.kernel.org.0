Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350B236B725
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhDZQpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:45:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234694AbhDZQpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 12:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619455459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7yIN30fdvOqyAxcZJQwSEHTCrNbzSKATlf8QynDErg=;
        b=a0dKdoRWXRXpyv0ghDhpGBEbGYyDuoGRDNnIPHeYIHU48fE7fynTAvXnL1Vw6tDLnWPszA
        PTUOF5WhfJxYxKfjip1y34Zp67I3EyfgxSBgpVT06WGPZTgnGzXVclWne9sZqeKB41Iu6S
        sVX52WX9nu8dly82Iou51t1h2RY4rdI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-A55TdyDuOlmJu5vGlTTVOw-1; Mon, 26 Apr 2021 12:44:18 -0400
X-MC-Unique: A55TdyDuOlmJu5vGlTTVOw-1
Received: by mail-ej1-f69.google.com with SMTP id f15-20020a170906738fb029037c94426fffso10465862ejl.22
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 09:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=q7yIN30fdvOqyAxcZJQwSEHTCrNbzSKATlf8QynDErg=;
        b=IPvLM+VksWR1OpH86Se9L80HPW5grZgmyNNq6VCPAnBTpWYTx/VhZ8hSFCCiZpkSxY
         nALsjx7RWhGBFDnGJYti7WjnVnHW34YOyKsCxojQ4aFsQTSlSz5AAd7ASleZnM2TIfcA
         6IGyEJOBY6/Ulgp+YAhbgB129VlHvY18HneYPJu/lQnRHcPQSZR/JyJ0vFqyyWEp+tCO
         OqIDzff2rkKDUw023vnzvFlvj0jkVR1jRuMthhq/AOWNymnCInWHTxE0YgTBJsm+Fjug
         ZF+FqdzAGgYL557vyr9YKwldUEBUbTo/CpSoz/ryqQPteRNPUa5F8EQZAnw0cw/3s4GL
         ywFA==
X-Gm-Message-State: AOAM530vLq0XlM/Z7jURFada3p6OqBoNphDitfbjf4gIeMY1iYzQ+nuq
        JC28riJ+r0RY3i7mIyBL6pL0phyVvXsmIZUqRwk2K8CNFGeFw2B5exBXpZSxpS0DRnPFZSBI+MT
        n1EnD7gTvHuypSPj3
X-Received: by 2002:aa7:d587:: with SMTP id r7mr22161522edq.388.1619455456733;
        Mon, 26 Apr 2021 09:44:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuO2OfFpZh/fNWyhe7YYpEynfHBolMMlRddgsf2GilgkVE5m+UUBxFRJ/VZYrHp/W3YGanyQ==
X-Received: by 2002:aa7:d587:: with SMTP id r7mr22161498edq.388.1619455456481;
        Mon, 26 Apr 2021 09:44:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w6sm11745819eje.107.2021.04.26.09.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 09:44:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3124F180615; Mon, 26 Apr 2021 18:44:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/5] selftests/bpf: add remaining ASSERT_xxx()
 variants
In-Reply-To: <CAEf4BzYixzoqzE_c+sd7QoQDg8dGaKf_UBf06AqTmCdUagoJvg@mail.gmail.com>
References: <20210423233058.3386115-1-andrii@kernel.org>
 <20210423233058.3386115-2-andrii@kernel.org>
 <CACAyw985JaDmA6n3c_sLDn3Ltwndc_zkNWu84b-cMh2NqjVeNA@mail.gmail.com>
 <CAEf4BzYQZCYZ7aXeSW2xJKLeQTvObiO5eabA5XvX34wF1NTBhw@mail.gmail.com>
 <875z09ca0p.fsf@toke.dk>
 <CAEf4BzYixzoqzE_c+sd7QoQDg8dGaKf_UBf06AqTmCdUagoJvg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 26 Apr 2021 18:44:14 +0200
Message-ID: <8735vdc7xd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Apr 26, 2021 at 8:59 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Mon, Apr 26, 2021 at 1:06 AM Lorenz Bauer <lmb@cloudflare.com> wrot=
e:
>> >>
>> >> On Sat, 24 Apr 2021 at 00:36, Andrii Nakryiko <andrii@kernel.org> wro=
te:
>> >> >
>> >> > Add ASSERT_TRUE/ASSERT_FALSE for conditions calculated with custom =
logic to
>> >> > true/false. Also add remaining arithmetical assertions:
>> >> >   - ASSERT_LE -- less than or equal;
>> >> >   - ASSERT_GT -- greater than;
>> >> >   - ASSERT_GE -- greater than or equal.
>> >> > This should cover most scenarios where people fall back to error-pr=
one
>> >> > CHECK()s.
>> >> >
>> >> > Also extend ASSERT_ERR() to print out errno, in addition to direct =
error.
>> >> >
>> >> > Also convert few CHECK() instances to ensure new ASSERT_xxx() varia=
nts work as
>> >> > expected. Subsequent patch will also use ASSERT_TRUE/ASSERT_FALSE m=
ore
>> >> > extensively.
>> >> >
>> >> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>> >> > ---
>> >> >  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
>> >> >  .../selftests/bpf/prog_tests/btf_endian.c     |  4 +-
>> >> >  .../selftests/bpf/prog_tests/cgroup_link.c    |  2 +-
>> >> >  .../selftests/bpf/prog_tests/kfree_skb.c      |  2 +-
>> >> >  .../selftests/bpf/prog_tests/resolve_btfids.c |  7 +--
>> >> >  .../selftests/bpf/prog_tests/snprintf_btf.c   |  4 +-
>> >> >  tools/testing/selftests/bpf/test_progs.h      | 50 +++++++++++++++=
+++-
>> >> >  7 files changed, 56 insertions(+), 15 deletions(-)
>> >> >
>> >> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/to=
ols/testing/selftests/bpf/prog_tests/btf_dump.c
>> >> > index c60091ee8a21..5e129dc2073c 100644
>> >> > --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
>> >> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
>> >> > @@ -77,7 +77,7 @@ static int test_btf_dump_case(int n, struct btf_d=
ump_test_case *t)
>> >> >
>> >> >         snprintf(out_file, sizeof(out_file), "/tmp/%s.output.XXXXXX=
", t->file);
>> >> >         fd =3D mkstemp(out_file);
>> >> > -       if (CHECK(fd < 0, "create_tmp", "failed to create file: %d\=
n", fd)) {
>> >> > +       if (!ASSERT_GE(fd, 0, "create_tmp")) {
>> >>
>> >> Nit: I would find ASSERT_LE easier to read here. Inverting boolean
>> >> conditions is easy to get wrong.
>> >
>> > You mean if (ASSERT_LE(fd, -1, "create_tmp")) { err =3D fd; goto done;=
 } ?
>> >
>> > That will mark the test failing if fd >=3D 0, which is exactly opposite
>> > to what we wan't. It's confusing because CHECK() checks invalid
>> > conditions and returns "true" if it holds. But ASSERT_xxx() checks
>> > *valid* condition and returns whether valid condition holds. So the
>> > pattern is always
>>
>> There's already an ASSERT_OK_PTR(), so maybe a corresponding
>> ASSERT_OK_FD() would be handy?
>
> I honestly don't see the point. OK_PTR is special, it checks NULL and
> the special ERR_PTR() variants, which is a lot of hassle to check
> manually. While for FD doing ASSERT_GE(fd, 0) seems to be fine and
> just mostly natural. Also for some APIs valid FD is > 0 and for other
> cases valid FD is plain >=3D 0, so that just adds to the confusion.

Alright, fair enough. I just wondered because I had the same feeling of
slight awkwardness when I was writing an fd check the other day, so
thought I'd air the thought; but as you say not *really* a big deal, so
I'm also OK with just using LE or GE for this...

-Toke

