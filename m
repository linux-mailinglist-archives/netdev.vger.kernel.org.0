Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34220273F57
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 12:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIVKOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 06:14:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgIVKOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 06:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600769659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RVoV+Gzw2IKyfoXH9wl+/oRsyv0cBYhdyCroTITZT4M=;
        b=WqNjOHawREhLQxdNSB9EwSvUg2O7eLO2eE+hiILDSTXUDYkw4yGImqp92TvDHZnBQwwPWj
        tF8MLIcXLP9fk03+pXWRo9fqjj21V0PbVDqurJhjltxP5B+qoBNA7YJ/rX4DKcT6ICoZm1
        fT0hXJ0wAGe+7BDhxEKjjkiX+L6l74g=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-AaSSaFPJOhO8Mgmk_KW7oQ-1; Tue, 22 Sep 2020 06:14:17 -0400
X-MC-Unique: AaSSaFPJOhO8Mgmk_KW7oQ-1
Received: by mail-pj1-f72.google.com with SMTP id n19so1712138pjt.1
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 03:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RVoV+Gzw2IKyfoXH9wl+/oRsyv0cBYhdyCroTITZT4M=;
        b=dUqoUyO26B8VGpFN0jHGMN+FnP0cXNsG8MJhVK3e4aPjeeW2rhoV5k9JKDb2VdO/o5
         aDS/ABukPpZF9ChDCuXI8GVjpYKTNT5NBaMK4FBaLIVXxCBN7m4XJAeQr4NVJLSrk+5v
         64KBHXFmKjWQ8NQuHFu4MaU8I5S6Yx0au6mNWeBYwdL4Bs8rL1ha0wfSNfrNlyaHBH/f
         XGGWEvOiIoTbftU6vG+wfLTe4fBhBC4moPomu6pqdeXeuGaLqbRC0Gl4loqlJC2LbvR5
         XBM/4H4rxsdcwfqJy8vOvj4WzTicrdCZPSfU1bUbPPuFsdJSV402NvYJy4GA5pcSmLyq
         Y3Yg==
X-Gm-Message-State: AOAM530WkasAs1rQZ7rsCxt3gQnRzFPT8RV+dpxZoLif475moQOOzJ2W
        zw/nRow5h3xwQZy8xOpZ4c2NuNxB8aSYo/e7RQ7sFaaFqNQ1vge6WxujVRZ4X38QJjH9nPlEZ1e
        37xiyjmAUH566aZza
X-Received: by 2002:a63:c910:: with SMTP id o16mr2876215pgg.102.1600769656436;
        Tue, 22 Sep 2020 03:14:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTWr8X1BmwvbjVD+bLgt/048uuelmVQft2sUeoAX852/eyOLwo6Sz5IUiwybGm0mXNwsj1Sg==
X-Received: by 2002:a63:c910:: with SMTP id o16mr2876196pgg.102.1600769656149;
        Tue, 22 Sep 2020 03:14:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v204sm14823736pfc.10.2020.09.22.03.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 03:14:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EA444183A99; Tue, 22 Sep 2020 12:14:10 +0200 (CEST)
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
Date:   Tue, 22 Sep 2020 12:14:10 +0200
Message-ID: <87o8lyp18t.fsf@toke.dk>
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

Ah, right, I'll take a look. I have had some trouble with running all
the tests because my VM runs out of memory, so I was picking and
choosing. Guess I'll go and actually fix this and run the full test
suite...

> Good news, though, is that this refactoring actually fixed a pretty
> nasty bug in check_attach_btf_id logic: whenever bpf_trampoline
> already existed (e.g., due to successful fentry to function X), all
> subsequent fentry/fexit/fmod_ret and all their sleepable variants
> would skip a bunch of check. So please attach the following Fixes
> tags:
>
> Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN")
> Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")

Ah, yes, well spotted! Will add the Fixes tags :)

> As for selftests, feel free to just drop the fmod_ret program, it was
> never supposed to be possible, I just never realized that.

Well, doesn't hurt to have it, does it? If you don't mind I think I'll
just keep it...

-Toke

