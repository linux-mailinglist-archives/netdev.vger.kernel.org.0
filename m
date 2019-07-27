Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AD17755A
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 02:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfG0AEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 20:04:52 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38800 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfG0AEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 20:04:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so40369084qkk.5;
        Fri, 26 Jul 2019 17:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:message-id;
        bh=yEvpl38D8sG8Fmd6CnxMdgnTxakE4VKx/zKiKcoGuD4=;
        b=V+7PL03lE+p2H6/xaV9wZwIHwnTIZT7V+0eEXwBiM6F7R/c98hovmaYJ1RGG20R2D2
         BbdQlWFk0PzNskCvoqE1hTT0GqTlv3SzVhC5hG1cENoXCZnpTTg5DO7VANYvZMlBABYo
         6NgBE9FxKUEd5JSQ5lqFLqMWBEoH9SJ5FFh4RFzByQBepa3WYb67bE+QjkSrWngTYcKM
         uWQ8AGufcwcqo3pGiXiPhqQPWjTHEZwZwFWk/ia4OYTvbytgNCH8/vZeqRoJbr5zIDq8
         TRvgMdrgFUKdsqRwvRcpbHTbFKgGaAAxgtr8Wfg7NRafLp4FwfrlyC3lT3nePAFGkcn1
         FVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:message-id;
        bh=yEvpl38D8sG8Fmd6CnxMdgnTxakE4VKx/zKiKcoGuD4=;
        b=hP2mWk1sza4C1U4ap5Ek2sVAvrs/j0wRlUga8CaBUA/SQl/lXwBAKpJXn4Ni/sEJG8
         DAAEpaRQVR6wJRAFWbvAeMfE4lecmVHF+mboTY5V/lSSuARQ85CnPurxVPCHM5Cfgvd1
         QVjcjynDbOVw2bt8C4A0OJGWBWOdqmUg14Y8kdfnWUgxwvDFZ51Fu4eQO3woE9BqsdA/
         KBak1dEfkrZa6gHlnDwvyIC85+3+4zvmHDgcDohoE4bWoED6DL2umNdiFxmePU2xN1i2
         svrqQep8jD2wSG3+spOAc4iTKtfUQmjZVu0iqGV3pcvEOyPbZyBo4Hyw6cpru+v5UBSy
         XCHA==
X-Gm-Message-State: APjAAAVIm4GufAIGc/4M1tHkyc+AACc79bXLpAQG39ZNLogbLYZpReor
        1BHpNdTsFW9tphpbH4bR3Kk=
X-Google-Smtp-Source: APXvYqynJEShzSIx4mKZiMv9NupDEt4rF0pqJ4FnH3RqAzg9w7OZxJwssira63sat2BUTMWGbwZlZw==
X-Received: by 2002:a05:620a:4d4:: with SMTP id 20mr31438023qks.95.1564185891289;
        Fri, 26 Jul 2019 17:04:51 -0700 (PDT)
Received: from [192.168.86.196] ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id o10sm27408517qti.62.2019.07.26.17.04.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 17:04:50 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date:   Fri, 26 Jul 2019 21:03:33 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <CAEf4BzYZT3fmQUuGp45+Mn6hLLyWnT2NE3PxfpD88sThX8JS_w@mail.gmail.com>
References: <20190718173021.2418606-1-andriin@fb.com> <20190726204937.GD24867@kernel.org> <CAEf4BzYZT3fmQUuGp45+Mn6hLLyWnT2NE3PxfpD88sThX8JS_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 bpf] libbpf: fix missing __WORDSIZE definition
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <6A88D470-1D16-4724-A50C-05D5BE2B080E@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On July 26, 2019 8:01:10 PM GMT-03:00, Andrii Nakryiko <andrii=2Enakryiko@g=
mail=2Ecom> wrote:
>On Fri, Jul 26, 2019 at 1:49 PM Arnaldo Carvalho de Melo
><arnaldo=2Emelo@gmail=2Ecom> wrote:
>>
>> Em Thu, Jul 18, 2019 at 10:30:21AM -0700, Andrii Nakryiko escreveu:
>> > hashmap=2Eh depends on __WORDSIZE being defined=2E It is defined by
>> > glibc/musl in different headers=2E It's an explicit goal for musl to
>be
>> > "non-detectable" at compilation time, so instead include glibc
>header if
>> > glibc is explicitly detected and fall back to musl header
>otherwise=2E
>> >
>> > Fixes: e3b924224028 ("libbpf: add resizable non-thread safe
>internal hashmap")
>> > Reported-by: Arnaldo Carvalho de Melo <acme@redhat=2Ecom>
>> > Signed-off-by: Andrii Nakryiko <andriin@fb=2Ecom>
>>
>> Couldn't find ths in the bpf tree, please consider applying it:
>>
>> Tested-by: Arnaldo Carvalho de Melo <acme@redhat=2Ecom>
>
>Arnaldo, I somehow got impression that you were going to pull this
>into your perf tree=2E Can you please confirm that it wasn't pulled into
>your tree, so that Alexei can apply it to bpf tree? Thanks!
>

I can process it, just was unsure about where it should go by,

I'll have it in my next perf/urgent pull req,

Thanks,

- Arnaldo
>
>>
>>
>> - Arnaldo
>>
>> > ---
>> >  tools/lib/bpf/hashmap=2Eh | 5 +++++
>> >  1 file changed, 5 insertions(+)
>> >
>> > diff --git a/tools/lib/bpf/hashmap=2Eh b/tools/lib/bpf/hashmap=2Eh
>> > index 03748a742146=2E=2Ebae8879cdf58 100644
>> > --- a/tools/lib/bpf/hashmap=2Eh
>> > +++ b/tools/lib/bpf/hashmap=2Eh
>> > @@ -10,6 +10,11 @@
>> >
>> >  #include <stdbool=2Eh>
>> >  #include <stddef=2Eh>
>> > +#ifdef __GLIBC__
>> > +#include <bits/wordsize=2Eh>
>> > +#else
>> > +#include <bits/reg=2Eh>
>> > +#endif
>> >  #include "libbpf_internal=2Eh"
>> >
>> >  static inline size_t hash_bits(size_t h, int bits)
>> > --
>> > 2=2E17=2E1
>>
>> --
>>
>> - Arnaldo

