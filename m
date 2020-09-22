Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C782747A0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIVRmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:42:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbgIVRmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 13:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600796520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EzgRUfINIPa2dWPeBHHXd+CrktDRFx/UstOexDPqNzk=;
        b=SYN33eYBiNxyLxXHRjP2rLxSyoY3ag85vWiaUyCtFSIDkC+jK89tNXUCu3g+vzorfOCv1p
        0/IfR//JAOmhVCf2DYNT3PGIJzFzs1nUj0ElKq7JcNmBd1wfAZFowSBKCCywamXhD2YwBD
        G6FO7q2ouFC73zgyps7xJFre9wg3Q48=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-OiSvlHLSPr-kPFgiwhwIPQ-1; Tue, 22 Sep 2020 13:41:58 -0400
X-MC-Unique: OiSvlHLSPr-kPFgiwhwIPQ-1
Received: by mail-wr1-f72.google.com with SMTP id y3so7713932wrl.21
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 10:41:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EzgRUfINIPa2dWPeBHHXd+CrktDRFx/UstOexDPqNzk=;
        b=RtZOsYUlQ/i+gydiC29X9bXJiDOPtYuaQxgYZGPIsJHdMR/vvI8HUunTN0W8dnI4zV
         aHYv4sfeIhre8UBp68nX2MHn9K/U9GoMWQKDIDXyqh1u+6c60qXVPsxnvOCXvX6Ky55e
         QDJaed6Z2g9b+aM7LryMo9Jbs4aez1BtdY56o4UthZcDgTFrVRhsQNkCRiQLzlDja3T4
         2zzaYGiCEysnvY0o4vCmtt8lFyrHSz+fpKDMiMlxARAwRHQ9JwuI/by90mmZLgBqG6Cg
         EU8nbGZ5EUiDJLJl7K/QRY8RXdK+59R8C7C4n/AAxdwfabLqigythvyvIR7RZLF2flWr
         Vi7A==
X-Gm-Message-State: AOAM532PSgVt3E8/9x2m5BzgyskQdY1AKHHX7UDb8e8ruUa+trrW59EF
        3j2KKROTfJdRXOdOJoi95+xc+WqF/a27WMQmYThfPCQ07qfYOw5XXAkBiRZm5dOsLS6r726SZ1A
        pA4TlV2Jd7jYFCkr0
X-Received: by 2002:a1c:4885:: with SMTP id v127mr2318205wma.129.1600796517775;
        Tue, 22 Sep 2020 10:41:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwsV4oD74wuTdqQ+k/aFuQyD3eOywyYXvHRb0K0hHtdji51PClr6ENPjARBDdDWVbLPVL4sw==
X-Received: by 2002:a1c:4885:: with SMTP id v127mr2318191wma.129.1600796517599;
        Tue, 22 Sep 2020 10:41:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x10sm5596291wmi.37.2020.09.22.10.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 10:41:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 86CF0183A8F; Tue, 22 Sep 2020 19:41:56 +0200 (CEST)
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
In-Reply-To: <CAEf4BzYhKybEg_NUYs4ziP3fu3-76ABWjzwTqXuVFeuk1XjwOg@mail.gmail.com>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
 <160051618622.58048.13304507277053169557.stgit@toke.dk>
 <CAEf4BzY4UR+KjZ3bY6ykyW5CPNwAzwgKVhYHGdgDuMT2nntmTg@mail.gmail.com>
 <87a6xioydh.fsf@toke.dk>
 <CAEf4BzYhKybEg_NUYs4ziP3fu3-76ABWjzwTqXuVFeuk1XjwOg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Sep 2020 19:41:56 +0200
Message-ID: <871rithfob.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Sep 22, 2020 at 4:16 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>
>> >> The check_attach_btf_id() function really does three things:
>> >>
>> >> 1. It performs a bunch of checks on the program to ensure that the
>> >>    attachment is valid.
>> >>
>> >> 2. It stores a bunch of state about the attachment being requested in
>> >>    the verifier environment and struct bpf_prog objects.
>> >>
>> >> 3. It allocates a trampoline for the attachment.
>> >>
>> >> This patch splits out (1.) and (3.) into separate functions in prepar=
ation
>> >> for reusing them when the actual attachment is happening (in the
>> >> raw_tracepoint_open syscall operation), which will allow tracing prog=
rams
>> >> to have multiple (compatible) attachments.
>> >>
>> >> No functional change is intended with this patch.
>> >>
>> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> ---
>> >
>> > Ok, so bad news: you broke another selftest (test_overhead). Please,
>> > do run test_progs and make sure everything succeeds, every time before
>> > you post a new version.
>>
>> Right, so I looked into this, and it seems the only reason it was
>> succeeding before were those skipped checks you pointed out that are now
>> fixed. I.e., __set_task_comm() is not actually supposed to be
>> fmod_ret'able according to check_attach_modify_return(). So I'm not sure
>> what the right way to fix this is?
>
> You have to remove the fmod_ret part from test_overhead, it was never
> supposed to work.

Right, sure, that I can do :)

-Toke

