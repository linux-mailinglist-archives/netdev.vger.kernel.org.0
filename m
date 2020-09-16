Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37ED26CE72
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgIPWOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:14:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbgIPWOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600294447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FUQQkJBSEXhHHJy6s1SaaoSkEHkFlPj5l/FPaNy4sK8=;
        b=YHKAEtZbQMKsc/K3KFSJtrL2/EvRDWjGknT59UB5iLGzgKg74RejGkh5NGm+4/wfK0Nq21
        kGA9cQOzur5MuS9TZ1ieo53Afy7sQEyjKiKvsNrdJg+C3H8dKwmWnXoEyJ1agaIKs/9wjc
        HzMMqA6GUKsl8D3qbRUM6ZWc6Lb9g3A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-4isqEUQWMpuYhfJ8zvWKyA-1; Wed, 16 Sep 2020 17:13:20 -0400
X-MC-Unique: 4isqEUQWMpuYhfJ8zvWKyA-1
Received: by mail-wr1-f72.google.com with SMTP id s8so3022261wrb.15
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 14:13:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FUQQkJBSEXhHHJy6s1SaaoSkEHkFlPj5l/FPaNy4sK8=;
        b=lkOUFmAYCuOfYQ9P2bkwFmMjLMJvG3eYr1DP9AuRTxnYidY0HSn+1PGEoBfZWPkv5H
         m/+Q14wFxGmm9GnaMdWJMX8uXevrqMCaFawIfdix4LEwmAM+ehoEb9e09ta5YgeR+zAu
         40IQH4CVgJvK4Hs5dRbVHXUnWkpaYVmABs9x/rLF1H5KWdpiGSPI2qk1JfkOG41YIWCM
         bHZSlymSoJiX3Zn8EHU9sASjEgXj3tv0b2Ecdpl+gL6QGjBMqfOdBR1qg3sEKtxV9N7a
         xODSBQDB7GF61Z//L6xYZ2REp4VB3tWcwdf6asp3Xmx821PpqwKmhhLpJYj1uiZNa+DM
         oM8g==
X-Gm-Message-State: AOAM532DHx/C4nE0qdaCfZ5PPyHg2jqyt7fmxzYKnKB+v1ZAbwlmn7nU
        wFxVtvsxcbGchm+Ftf2u5nXB7F+XvB9IOoYtZYniN2y1efasj64i14nKdhTZPvLANgCz76vEmku
        Kv+2bpQDi5MjbJZCl
X-Received: by 2002:adf:f846:: with SMTP id d6mr30881671wrq.56.1600290799275;
        Wed, 16 Sep 2020 14:13:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqlJX/o81Ta6Y8ACfKNLXSwBXTK76xwK8801ODbiXzpda7zvpFBoI4iETyzq0ydgXmUx2P7Q==
X-Received: by 2002:adf:f846:: with SMTP id d6mr30881656wrq.56.1600290799050;
        Wed, 16 Sep 2020 14:13:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q186sm7459889wma.45.2020.09.16.14.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:13:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2EAFE183A90; Wed, 16 Sep 2020 23:13:18 +0200 (CEST)
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
Subject: Re: [PATCH bpf-next v5 4/8] bpf: support attaching freplace
 programs to multiple attach points
In-Reply-To: <CAEf4BzYP6MpVEqJ1TVW6rcfqJjkBi9x9U9F8MZPQdGMmoaUX_A@mail.gmail.com>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006133.98230.8867570651560085505.stgit@toke.dk>
 <CAEf4BzYP6MpVEqJ1TVW6rcfqJjkBi9x9U9F8MZPQdGMmoaUX_A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Sep 2020 23:13:18 +0200
Message-ID: <87r1r1pgr5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[ will fix all your comments above ]

>> @@ -3924,10 +3983,16 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *
>>             prog->expected_attach_type == BPF_TRACE_ITER)
>>                 return bpf_iter_link_attach(attr, prog);
>>
>> +       if (attr->link_create.attach_type == BPF_TRACE_FREPLACE &&
>> +           !prog->expected_attach_type)
>> +               return bpf_tracing_prog_attach(prog,
>> +                                              attr->link_create.target_fd,
>> +                                              attr->link_create.target_btf_id);
>
> Hm.. so you added a "fake" BPF_TRACE_FREPLACE attach_type, which is
> not really set with BPF_PROG_TYPE_EXT and is only specified for the
> LINK_CREATE command. Are you just trying to satisfy the link_create
> flow of going from attach_type to program type? If that's the only
> reason, I think we can adjust link_create code to handle this more
> flexibly.
>
> I need to think a bit more whether we want BPF_TRACE_FREPLACE at all,
> but if we do, whether we should make it an expected_attach_type for
> BPF_PROG_TYPE_EXT then...

Yeah, wasn't too sure about this. But attach_type seemed to be the only
way to disambiguate between the different link types in the LINK_CREATE
command, so went with that. Didn't think too much about it, TBH :)

I guess an alternative could be to just enforce attach_type==0 and look
at prog->type? Or if you have any other ideas, I'm all ears!

-Toke

