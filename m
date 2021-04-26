Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E48436B64B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhDZP7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:59:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234113AbhDZP7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:59:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619452747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ruDPCNmpKlM9UkncM1GlQmtvB1B2d8y5gAqrjBieAY8=;
        b=A+Pw+2rVKmfsY0cdE0bTM0Aq06OT/TGVMd1Jq7fU6HuMPNRTaGDHxcs4OWfX43/+Mp4Qpl
        y9IPCDrKk+COCOghoVjJ/CE6VE16SRowLy2lZ3f6YGgqzasQdoNqf8GJW9wLnWZ39rhvS+
        xDqoQrMLyLzv51/xjtlWYGPGhhHxIEs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-nuUfxBgpMmydOyL04u1NkA-1; Mon, 26 Apr 2021 11:59:05 -0400
X-MC-Unique: nuUfxBgpMmydOyL04u1NkA-1
Received: by mail-ed1-f71.google.com with SMTP id c13-20020a05640227cdb0290385526e5de5so13191096ede.21
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ruDPCNmpKlM9UkncM1GlQmtvB1B2d8y5gAqrjBieAY8=;
        b=qZhg1p7BsK+2kDkK0n2EJZOIR9VRABrXNAjPWwsvnN+9SN3WyS6flYwEvxcLWGoTbS
         0OYz9QmHOJ8Xz7JWOJVNsj7IU6eqSaVnDjoaDgHHLKc3aWQaoTVkqMl/II+icA2qNhE8
         1pnqAf8uTf6lE2AkKCsGfUJHTr8BmpFLKnr4cR/PB/PvvKV6T1DuPI1Hh/Zvv07coT2S
         spS8lbArCxPtSFfFlyYmmZqf3AIw+1OW706x4qpdM1fT33+0mT53WzvsMlSs+cZcmhJ0
         dyP12j2gAyT9nVR1cBfTMzpPjSdnlH2HDQhYeQ2tJePKz5J0F9e7LbPdf0GXwCl7N9GR
         VDYQ==
X-Gm-Message-State: AOAM530qxjT/HuxDvZf7kzj0VErTFY4VhAa3DCoh/zTrI5aLoglmljSx
        5fxN+zuFaOatZ4DyqYARhhobrpjYrlEEw6ZwLYB6EbZ/w5BtYge9Zi/KR25qN8Pf4xpwfX7hI2Q
        Nfy5XPsDyyObdLMCO
X-Received: by 2002:a17:906:3d41:: with SMTP id q1mr19093990ejf.282.1619452743731;
        Mon, 26 Apr 2021 08:59:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbFcJtnW4X8v2PwXQHrhLxYVuyf5mOG935FzKINZcRhOKVoWT7qWbD4WW6tVyZ8wmIghhfjA==
X-Received: by 2002:a17:906:3d41:: with SMTP id q1mr19093978ejf.282.1619452743562;
        Mon, 26 Apr 2021 08:59:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r18sm11729378ejd.106.2021.04.26.08.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 08:59:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5D5D4180615; Mon, 26 Apr 2021 17:59:02 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/5] selftests/bpf: add remaining ASSERT_xxx()
 variants
In-Reply-To: <CAEf4BzYQZCYZ7aXeSW2xJKLeQTvObiO5eabA5XvX34wF1NTBhw@mail.gmail.com>
References: <20210423233058.3386115-1-andrii@kernel.org>
 <20210423233058.3386115-2-andrii@kernel.org>
 <CACAyw985JaDmA6n3c_sLDn3Ltwndc_zkNWu84b-cMh2NqjVeNA@mail.gmail.com>
 <CAEf4BzYQZCYZ7aXeSW2xJKLeQTvObiO5eabA5XvX34wF1NTBhw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 26 Apr 2021 17:59:02 +0200
Message-ID: <875z09ca0p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Apr 26, 2021 at 1:06 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>>
>> On Sat, 24 Apr 2021 at 00:36, Andrii Nakryiko <andrii@kernel.org> wrote:
>> >
>> > Add ASSERT_TRUE/ASSERT_FALSE for conditions calculated with custom logic to
>> > true/false. Also add remaining arithmetical assertions:
>> >   - ASSERT_LE -- less than or equal;
>> >   - ASSERT_GT -- greater than;
>> >   - ASSERT_GE -- greater than or equal.
>> > This should cover most scenarios where people fall back to error-prone
>> > CHECK()s.
>> >
>> > Also extend ASSERT_ERR() to print out errno, in addition to direct error.
>> >
>> > Also convert few CHECK() instances to ensure new ASSERT_xxx() variants work as
>> > expected. Subsequent patch will also use ASSERT_TRUE/ASSERT_FALSE more
>> > extensively.
>> >
>> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>> > ---
>> >  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
>> >  .../selftests/bpf/prog_tests/btf_endian.c     |  4 +-
>> >  .../selftests/bpf/prog_tests/cgroup_link.c    |  2 +-
>> >  .../selftests/bpf/prog_tests/kfree_skb.c      |  2 +-
>> >  .../selftests/bpf/prog_tests/resolve_btfids.c |  7 +--
>> >  .../selftests/bpf/prog_tests/snprintf_btf.c   |  4 +-
>> >  tools/testing/selftests/bpf/test_progs.h      | 50 ++++++++++++++++++-
>> >  7 files changed, 56 insertions(+), 15 deletions(-)
>> >
>> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
>> > index c60091ee8a21..5e129dc2073c 100644
>> > --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
>> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
>> > @@ -77,7 +77,7 @@ static int test_btf_dump_case(int n, struct btf_dump_test_case *t)
>> >
>> >         snprintf(out_file, sizeof(out_file), "/tmp/%s.output.XXXXXX", t->file);
>> >         fd = mkstemp(out_file);
>> > -       if (CHECK(fd < 0, "create_tmp", "failed to create file: %d\n", fd)) {
>> > +       if (!ASSERT_GE(fd, 0, "create_tmp")) {
>>
>> Nit: I would find ASSERT_LE easier to read here. Inverting boolean
>> conditions is easy to get wrong.
>
> You mean if (ASSERT_LE(fd, -1, "create_tmp")) { err = fd; goto done; } ?
>
> That will mark the test failing if fd >= 0, which is exactly opposite
> to what we wan't. It's confusing because CHECK() checks invalid
> conditions and returns "true" if it holds. But ASSERT_xxx() checks
> *valid* condition and returns whether valid condition holds. So the
> pattern is always

There's already an ASSERT_OK_PTR(), so maybe a corresponding
ASSERT_OK_FD() would be handy?

-Toke

