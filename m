Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D3427408D
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIVLQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:16:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30968 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726454AbgIVLQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 07:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600773376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtujSmMB6nTw7h5UTnW9OabKvVTDf3TP6d+sgwQFf7Q=;
        b=FfJIYSb4pQAWe26l684vJ49f7u3Iwr7Mvia+Rl2EQTW9M8ylcL1LlMoha//6y4xLtLUXv5
        SQ4RlPF8N8iZCYceCsJyRvyvGGBuEKeqbgf3PKkh2mNI3UkDHy/l3/ZeagOqphnwaXiDe+
        rQ1R47zXnSxzFn45zcz2vWB16vsA/B8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-1Wrc7f2kOo6Au4l6fSks8g-1; Tue, 22 Sep 2020 07:16:12 -0400
X-MC-Unique: 1Wrc7f2kOo6Au4l6fSks8g-1
Received: by mail-wm1-f72.google.com with SMTP id x81so769665wmg.8
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 04:16:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dtujSmMB6nTw7h5UTnW9OabKvVTDf3TP6d+sgwQFf7Q=;
        b=pWO/IvzYbKkze43UrqufyGaSTXw3y5Wnx1LmFHLd7SqgOEcWcWMy4Hh0VWiYkRW/qG
         6dy2sa8Tjl9DxR8AgpDeBDUq9brieOZQyHC/xERsybkVV5ze/9oArvZWORjZHUJhbdQc
         uRWanPviBak9Qkb0Uu0TVlOXosQtQYlxsvYAdvoo8WwDPVzcyqMxtVyakvfbUg3BRhEa
         vRo4rUnCmJSURmm89EINwAtP8ZVpjb6sZEkwgp4oaa6XdS/lwqfeFUB6NuYjBQE+WFb5
         oernlkwryGR5ZWjqGocM/bBjc+gYLH0u3Dq1onUZoVK3R4DcREsQVjmbtzGrMQbKFdr7
         snhQ==
X-Gm-Message-State: AOAM5308KThBDw7J0u9z1Id5+xjBwuo7RM46nwQ52X4gUaJUFZRGm8mV
        n4bvEl5f0u1ovg8GynkPMlkCxvbHp37wigC3rvu5iIanzHqlvTxa103mPQYSD3HKLUL5YvpvvCU
        VJMXrKmi7Ob5AiY3F
X-Received: by 2002:a05:6000:118a:: with SMTP id g10mr4910908wrx.67.1600773371607;
        Tue, 22 Sep 2020 04:16:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDLh49J2igFsBPt8GTl/dJj7UTzsBsHQ8nK/1AvF2774elWuJah9Mr401GPU/xFxj8r77Cug==
X-Received: by 2002:a05:6000:118a:: with SMTP id g10mr4910864wrx.67.1600773371307;
        Tue, 22 Sep 2020 04:16:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d5sm27935960wrb.28.2020.09.22.04.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 04:16:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 36273183A99; Tue, 22 Sep 2020 13:16:10 +0200 (CEST)
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
Subject: Re: [PATCH bpf-next v7 03/10] bpf: verifier: refactor
 check_attach_btf_id()
In-Reply-To: <CAEf4BzY4UR+KjZ3bY6ykyW5CPNwAzwgKVhYHGdgDuMT2nntmTg@mail.gmail.com>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
 <160051618622.58048.13304507277053169557.stgit@toke.dk>
 <CAEf4BzY4UR+KjZ3bY6ykyW5CPNwAzwgKVhYHGdgDuMT2nntmTg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Sep 2020 13:16:10 +0200
Message-ID: <87a6xioydh.fsf@toke.dk>
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
>> The check_attach_btf_id() function really does three things:
>>
>> 1. It performs a bunch of checks on the program to ensure that the
>>    attachment is valid.
>>
>> 2. It stores a bunch of state about the attachment being requested in
>>    the verifier environment and struct bpf_prog objects.
>>
>> 3. It allocates a trampoline for the attachment.
>>
>> This patch splits out (1.) and (3.) into separate functions in preparati=
on
>> for reusing them when the actual attachment is happening (in the
>> raw_tracepoint_open syscall operation), which will allow tracing programs
>> to have multiple (compatible) attachments.
>>
>> No functional change is intended with this patch.
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> Ok, so bad news: you broke another selftest (test_overhead). Please,
> do run test_progs and make sure everything succeeds, every time before
> you post a new version.

Right, so I looked into this, and it seems the only reason it was
succeeding before were those skipped checks you pointed out that are now
fixed. I.e., __set_task_comm() is not actually supposed to be
fmod_ret'able according to check_attach_modify_return(). So I'm not sure
what the right way to fix this is?

The fmod_ret bit was added to test_overhead by:

4eaf0b5c5e04 ("selftest/bpf: Fmod_ret prog and implement test_overhead as p=
art of bench")

so the obvious thing is to just do a (partial) revert of that? WDYT?

-Toke

