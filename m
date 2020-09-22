Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9DE2747AF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIVRsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:48:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726563AbgIVRsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 13:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600796889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4aKlfnMKe2hannLgSs/cK7bKvlb7YGrZQ7tCDYBs9I=;
        b=KAqWyoKp42GLOjt5hyy0LpnFB/9aFvc+SsGfYVJ+uPsT1Zfiyvfhk7djMF9Q8Q+YsANgTf
        Wer2URRcF02yu6DWPTNqrXmPk+ozluFxXaC9pdnbk9QnE6RqXf3h8juG9HIMpYUL4PAgjd
        +cRzT6FGfhwkymgVsc/lSN7FU62X2z8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-Jt0pNLArMC-J0FD3JLifOQ-1; Tue, 22 Sep 2020 13:48:07 -0400
X-MC-Unique: Jt0pNLArMC-J0FD3JLifOQ-1
Received: by mail-wr1-f72.google.com with SMTP id v12so7730109wrm.9
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 10:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=l4aKlfnMKe2hannLgSs/cK7bKvlb7YGrZQ7tCDYBs9I=;
        b=kyqr4CgrDeX6fzA9z8+h7tIQwNsDEX6OKNEj4UMqEVSVkOYxI94NoD6UiaGGGwgx0F
         M5mssl02xRNbc+6bwK/NbanzDRwCvw60ah8fzsYmhbo4mlrUWa1jcP0eNi43yQDmAloM
         zwz6xhQDp9FJkNHg+eOoRB8k2GdKdjgH7xXY1TXUs16bWFIfEipDlgEftn98GSGkg/cW
         AKfvI2LSWNOpxmvdhIYdFNRdDpP00XYLkkoSYCKUbQt73KUNbfBw8eeP5AQws5YF4BlX
         8zvVqdqxT3LM40zf3jfIkbHDxML0nJdC5pShqtTcS9ky+wWgV2VqZsq/hzVeFbVU4+7y
         Dx9Q==
X-Gm-Message-State: AOAM530nRsHD7tPmFjb2PSIm1/zTI83SaGyvLriDy2LHdokUXh8F0TKp
        AO+NDKBj83Q7Z63Iagpxs/M8ogrSIqNaP5pya2wCYzVnZQqUEC8eOlJYL4PMMsYCkFlrrwIDwSs
        80t3lUkFMinycVJxI
X-Received: by 2002:adf:ef48:: with SMTP id c8mr6755212wrp.370.1600796882530;
        Tue, 22 Sep 2020 10:48:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1bQt1Ju2SgqAHz7F277XKKzYha9ohMajA3u/z5Bc1E2QvMxzPXYS0N7WGqp2hkEaKAmR33w==
X-Received: by 2002:adf:ef48:: with SMTP id c8mr6755184wrp.370.1600796882314;
        Tue, 22 Sep 2020 10:48:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z9sm5728975wmg.46.2020.09.22.10.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 10:48:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3B94F183A8F; Tue, 22 Sep 2020 19:48:01 +0200 (CEST)
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
Subject: Re: [PATCH bpf-next v7 04/10] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
In-Reply-To: <CAEf4BzYdBy0xOVBb3RSVqtrc9+XL459LjT9hNGfmTy=QYDQ+AQ@mail.gmail.com>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
 <160051618733.58048.1005452269573858636.stgit@toke.dk>
 <CAEf4BzYrc1j0i5qVKfyHA98C37D7xR6i4GL4BLeprNL=HfjCBg@mail.gmail.com>
 <87lfh2p12x.fsf@toke.dk>
 <CAEf4BzYdBy0xOVBb3RSVqtrc9+XL459LjT9hNGfmTy=QYDQ+AQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Sep 2020 19:48:01 +0200
Message-ID: <87y2l1g0tq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Sep 22, 2020 at 3:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>
>> >> In preparation for allowing multiple attachments of freplace programs=
, move
>> >> the references to the target program and trampoline into the
>> >> bpf_tracing_link structure when that is created. To do this atomicall=
y,
>> >> introduce a new mutex in prog->aux to protect writing to the two poin=
ters
>> >> to target prog and trampoline, and rename the members to make it clea=
r that
>> >> they are related.
>> >>
>> >> With this change, it is no longer possible to attach the same tracing
>> >> program multiple times (detaching in-between), since the reference fr=
om the
>> >> tracing program to the target disappears on the first attach. However,
>> >> since the next patch will let the caller supply an attach target, tha=
t will
>> >> also make it possible to attach to the same place multiple times.
>> >>
>> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> ---
>> >>  include/linux/bpf.h     |   15 +++++++++-----
>> >>  kernel/bpf/btf.c        |    6 +++---
>> >>  kernel/bpf/core.c       |    9 ++++++---
>> >>  kernel/bpf/syscall.c    |   49 +++++++++++++++++++++++++++++++++++++=
++--------
>> >>  kernel/bpf/trampoline.c |   12 ++++--------
>> >>  kernel/bpf/verifier.c   |    9 +++++----
>> >>  6 files changed, 68 insertions(+), 32 deletions(-)
>> >>
>> >
>> > [...]
>> >
>> >> @@ -741,7 +743,9 @@ struct bpf_prog_aux {
>> >>         u32 max_rdonly_access;
>> >>         u32 max_rdwr_access;
>> >>         const struct bpf_ctx_arg_aux *ctx_arg_info;
>> >> -       struct bpf_prog *linked_prog;
>> >> +       struct mutex tgt_mutex; /* protects writing of tgt_* pointers=
 below */
>> >
>> > nit: not just writing, "accessing" would be a better word
>>
>> Except it's not, really: the values are read without taking the mutex.
>
> Huh? So you are taking a mutex in bpf_tracing_prog_attach before
> reading prog->aux->tgt_prog and prog->aux->tgt_trampoline just for
> fun?.. Why don't you read those pointers outside of mutex and let's
> have discussion about race conditions?

No, of course not. What I meant was that not everywhere that accesses
the field takes the lock; it's not just check_attach_btf_id(), it's also
resolve_prog_type() which is called from several places.

Of course, as you point out this is all technically part of the
'constructor', as it's all inside the verifier. But you have to keep
quite a lot of mental state to realise that, so I thought it would be
confusing to have a comment that says the mutex protects all accesses to
the field, and then have a bunch of places access the field without
holding the mutex.

However, just adding the "*after* prog becomes visible" bit to the
comment helps with that, so I'm not arguing for keeping it, just
explaining why I did it the way I did initially :)

-Toke

