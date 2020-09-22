Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82643273EF0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIVJw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:52:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgIVJw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600768346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nx9mv10dV8y4dzoFloRA6309JVx8lLnXd7Rnl/kRaH8=;
        b=ZUBQQTJVF+jPdTF1QbaTlaRcZ7+WaIUlk6ObfA8qs+yuqmUIPcQ5b78VH/1R8GDcTrYzrD
        mTxxy9ft0AlohYfbEaCupWRtvQdnYojg721J/C9xhprowBPhOIzkYLIVCRsRSs5CeDnfct
        u6lBxN7EmpdhCMByiuvuNsqaM5oq1Ps=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-ixxYuwJjO9ydVEjmmZapxg-1; Tue, 22 Sep 2020 05:52:25 -0400
X-MC-Unique: ixxYuwJjO9ydVEjmmZapxg-1
Received: by mail-pg1-f198.google.com with SMTP id e15so8542916pgl.16
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Nx9mv10dV8y4dzoFloRA6309JVx8lLnXd7Rnl/kRaH8=;
        b=NpsTzEVAbr2i/6VEMj9yfQkdXgSgt14TbG+c2tX44OYQezb/05bjcGysn40SdfGoZZ
         W0JufAyTmvEpdCKlcs/7PWNeFjPG0GfsOAiRgrySLN1WCwhJlGBRQ648qnZ5bJRKI0tx
         QSegyTJox/cUMKzm5FBtEqZtKVIwq7D1aDTHDTrwb4EBgtwkL0H8t4J7ogrbbL52CYD4
         58RsX+txpM1OONUkoeu+hVo7uOWAiCDI/UsABcZ1kKFsfglGQ5tSiDgGogYTZgIIo01Q
         J9qZ0aUm9GRWsvz+3OuoUdfGhwUwdvB/zJ/3AmuivrO1/4X8zLdmx4MrfgBW4d57I5lO
         UMxg==
X-Gm-Message-State: AOAM533B2ogqqb1W481iaDCrUTgo5xMOg9cEk3J4Ar2+da/HsWflLrHN
        kPFj+WU+f8mVOA/wc+q7/tdV5nxpeFkHA/c3F5zcv9oRNue8b+kkMriR+h1QX/x816rsc9TWjgi
        Y6SSGVbCTtiZNhrXz
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr2968140pjb.221.1600768343816;
        Tue, 22 Sep 2020 02:52:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBm9x92QvsEvbQnDTGXDaepFv4G+EzNXVg9nsB0Uk3HD4gjqovWBAWyq8+HkgHhLhnoZWkVg==
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr2968116pjb.221.1600768343597;
        Tue, 22 Sep 2020 02:52:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r15sm13900813pgg.17.2020.09.22.02.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 02:52:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F18DC183A99; Tue, 22 Sep 2020 11:52:16 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v7 01/10] bpf: disallow attaching modify_return
 tracing functions to other BPF programs
In-Reply-To: <CAEf4Bzbb5gt7KgmfXM6FiC750GjxL23XO4GPnVHFgCGaMTuDCg@mail.gmail.com>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
 <160051618391.58048.12525358750568883938.stgit@toke.dk>
 <CAEf4Bzbb5gt7KgmfXM6FiC750GjxL23XO4GPnVHFgCGaMTuDCg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Sep 2020 11:52:16 +0200
Message-ID: <87r1qup29b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> From the checks and commit messages for modify_return, it seems it was
>> never the intention that it should be possible to attach a tracing progr=
am
>> with expected_attach_type =3D=3D BPF_MODIFY_RETURN to another BPF progra=
m.
>> However, check_attach_modify_return() will only look at the function nam=
e,
>> so if the target function starts with "security_", the attach will be
>> allowed even for bpf2bpf attachment.
>>
>> Fix this oversight by also blocking the modification if a target program=
 is
>> supplied.
>>
>> Fixes: 18644cec714a ("bpf: Fix use-after-free in fmod_ret check")
>> Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN=
")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  kernel/bpf/verifier.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 4161b6c406bc..cb1b0f9fd770 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -11442,7 +11442,7 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
>>                                         prog->aux->attach_func_name);
>>                 } else if (prog->expected_attach_type =3D=3D BPF_MODIFY_=
RETURN) {
>>                         ret =3D check_attach_modify_return(prog, addr);
>> -                       if (ret)
>> +                       if (ret || tgt_prog)
>
> can you please do it as a separate check with a more appropriate and
> meaningful message?

Heh, okay, maybe I was being a bit too lazy here ;)

-Toke

