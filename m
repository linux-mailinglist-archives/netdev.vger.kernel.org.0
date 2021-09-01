Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7D3FD788
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhIAKUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:20:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhIAKUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630491556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wpWcIICp9iFhNI7UaFnNLpQfUhXyL/9FmRy00EyVH9M=;
        b=DlW2lpchp3KMv7z14pBZNAvF2RW1WGHS9Gz56PiyZ7QRP/38rDnbMKXDOT4RwmykPHPFRY
        e8Px5JeJD1GMQN8DVxU41k7JEXRQ6Sa9sy5O18G/F3hrPiiE6kW6HOuXAeZTt7TtGkVGx+
        9DLyYJabSMzbBZ5JlBI48f2lBpynNaA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-UCH914elNIan9OU69jNmgg-1; Wed, 01 Sep 2021 06:19:15 -0400
X-MC-Unique: UCH914elNIan9OU69jNmgg-1
Received: by mail-ej1-f70.google.com with SMTP id ga42-20020a1709070c2a00b005dc8c1cc3a1so1167280ejc.17
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 03:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wpWcIICp9iFhNI7UaFnNLpQfUhXyL/9FmRy00EyVH9M=;
        b=pYmS2HD2gSqkKl4TknYqtGnrNcK24qp+KEym9jteZhCI7st/97ccX5c8hKK+lsNLyr
         cR6vHjUkroFnJNE/bKVtADgP7zpQdUNC5MITs4U0/KtUDq0c+VJtHVru6Lwy0lI86RAG
         E8JlpoD7E4mKZHHv9aPBCbKkW9Ad+o3qfin5X5CauKLATmPhkenP/I30MzZgXdmw4aws
         07jKkcOH9ZFKgUGeHwtTGE0r0g0jI5IHDsRi9KTyETfm/CqSbuTVHIp1gFMIz308rhpl
         m0o0JlGyM6Oq87mzxPIdy6Nv3AdzeEadZfAIeJY5CHQ0+vO1PrjoTykGJnK+9+OySxck
         0+JQ==
X-Gm-Message-State: AOAM530/YN1n771motRGI/o+r28oSqKygZCMv6xTGCzksPYpU/QH50HG
        zyGkRjQMm/Iz777URUtNGLrOFG3fGjkLX0R3gdBrdL1lU2Hyt33MJwQ357xMeyJY8TwCurzzIGH
        KwZSQzwOQFfbu21A6
X-Received: by 2002:aa7:dd12:: with SMTP id i18mr34270000edv.368.1630491553379;
        Wed, 01 Sep 2021 03:19:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhQ4jJFhhwKmYay1MqddeY0ug/WgBlq+tMJb5MGlx/WChGkb3G/0db9DFaJI8Jir9o1eUV9A==
X-Received: by 2002:aa7:dd12:: with SMTP id i18mr34269944edv.368.1630491552468;
        Wed, 01 Sep 2021 03:19:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m12sm9796758ejd.21.2021.09.01.03.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:19:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 898221800EB; Wed,  1 Sep 2021 12:19:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: don't crash on object files with no symbol
 tables
In-Reply-To: <CAEf4BzaCukRbk=wBY=jobyCKDpQma-41gH34D=iigpj_AO6Hiw@mail.gmail.com>
References: <20210831165802.168776-1-toke@redhat.com>
 <CAEf4BzaCukRbk=wBY=jobyCKDpQma-41gH34D=iigpj_AO6Hiw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 01 Sep 2021 12:19:10 +0200
Message-ID: <874kb4vbs1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Aug 31, 2021 at 9:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> If libbpf encounters an ELF file that has been stripped of its symbol
>> table, it will crash in bpf_object__add_programs() when trying to
>> dereference the obj->efile.symbols pointer. Add a check and return to av=
oid
>> this.
>>
>> Fixes: 6245947c1b3c ("libbpf: Allow gaps in BPF program sections to supp=
ort overriden weak functions")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  tools/lib/bpf/libbpf.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 6f5e2757bb3c..4cd102affeef 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -668,6 +668,9 @@ bpf_object__add_programs(struct bpf_object *obj, Elf=
_Data *sec_data,
>>         const char *name;
>>         GElf_Sym sym;
>>
>> +       if (!symbols)
>> +               return -ENOENT;
>> +
>
> The more logical place to do this check is in
> bpf_object__elf_collect(). Can you add this there? We can also include
> helpful error message.

Sure, can do.

> But I'm also curious which Clang version is being used to cause no ELF
> symbols being generated?

It's not Clang. I was debugging an issue with 'strip' mangling BPF
object files and ran into this after trying to load an object file that
had been run through a full 'strip bpf_object.o' (whereas 'strip -g
bpf_object.o' works fine, except for that one bug I'm looking at).

-Toke

