Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A1A273F72
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 12:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIVKRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 06:17:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgIVKRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 06:17:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600769866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LB+yOIPH6nLh4xY3BWfBsW3mUfxqHf33CvpwSia9QhM=;
        b=ChZUe55PvFccLqOB5aBD5I8wyp0aiW4GOMDpscVKF9OmbLnKZZokVsmS0ytHZYs9SSKIbf
        qi15itmGTeKnTU7GDc7vG1IgEG/3AA8UjsHLFgUAWeZGQGR1GKnmCa07TJFKyaKyxT5nWu
        IvEVL6NFrPTSqhuyWjheUICAY8EgAWY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-7Q78yAg5MdGNgd9ZgfX2Mg-1; Tue, 22 Sep 2020 06:17:45 -0400
X-MC-Unique: 7Q78yAg5MdGNgd9ZgfX2Mg-1
Received: by mail-wr1-f72.google.com with SMTP id y3so7198438wrl.21
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 03:17:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LB+yOIPH6nLh4xY3BWfBsW3mUfxqHf33CvpwSia9QhM=;
        b=QiwyYIvxr7NKJm7a9eg4VOkjQAT+hmJpIvumTrNQa9VSdt+wRaPKfQSH0dnvJJClpU
         K2qQ3sNMMPiljzhQ1sqX9Y0WPCRvAdumbap3/8fMPjoqp3d6ltox4IcDc4I63r3YLcmz
         4yj0zORtFRZdTlA9JN+YLPT1TzMEd7P4DE2o2htSDcQiF4A6Ws4YeCmL/OQ0y1EdcWCQ
         ItGZxDv9WDbJVEmX0d5JQ1Xy7dc79TqO4JhxT8fUeddstj6K+RCG84OloylrO8mD+oQr
         xp7X+0ZNt1vL2EDJxkq7cxsot1Ik4m61/pop3DPuiaEXC9GeKls0CfoQQJyTmFDKKzAH
         2yaw==
X-Gm-Message-State: AOAM532R3H8jjEmOmop5KhP/3r8ihqdHYFMB3qxS7F/TgFf6X+wDYlSj
        esFPEu/Psgb25iog2H9ZN9/EshZntbqBiYh/bZX9OBy4EmPRmLTLKKFStBEBsg3WqSOm1gxo85M
        7jnNHSJT9OvWLP65e
X-Received: by 2002:a1c:23c9:: with SMTP id j192mr246606wmj.6.1600769863486;
        Tue, 22 Sep 2020 03:17:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGMBhzxwkSG9B+hLdE3WuCpLWFK2QB/3th4UgYOM8C/GMYblB1apZwOfQ0YpY3Jof6rBF7Jg==
X-Received: by 2002:a1c:23c9:: with SMTP id j192mr246572wmj.6.1600769863135;
        Tue, 22 Sep 2020 03:17:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i83sm4008495wma.22.2020.09.22.03.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 03:17:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 29BEF183A99; Tue, 22 Sep 2020 12:17:42 +0200 (CEST)
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
In-Reply-To: <CAEf4BzYrc1j0i5qVKfyHA98C37D7xR6i4GL4BLeprNL=HfjCBg@mail.gmail.com>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
 <160051618733.58048.1005452269573858636.stgit@toke.dk>
 <CAEf4BzYrc1j0i5qVKfyHA98C37D7xR6i4GL4BLeprNL=HfjCBg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Sep 2020 12:17:42 +0200
Message-ID: <87lfh2p12x.fsf@toke.dk>
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
>> In preparation for allowing multiple attachments of freplace programs, m=
ove
>> the references to the target program and trampoline into the
>> bpf_tracing_link structure when that is created. To do this atomically,
>> introduce a new mutex in prog->aux to protect writing to the two pointers
>> to target prog and trampoline, and rename the members to make it clear t=
hat
>> they are related.
>>
>> With this change, it is no longer possible to attach the same tracing
>> program multiple times (detaching in-between), since the reference from =
the
>> tracing program to the target disappears on the first attach. However,
>> since the next patch will let the caller supply an attach target, that w=
ill
>> also make it possible to attach to the same place multiple times.
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  include/linux/bpf.h     |   15 +++++++++-----
>>  kernel/bpf/btf.c        |    6 +++---
>>  kernel/bpf/core.c       |    9 ++++++---
>>  kernel/bpf/syscall.c    |   49 +++++++++++++++++++++++++++++++++++++++-=
-------
>>  kernel/bpf/trampoline.c |   12 ++++--------
>>  kernel/bpf/verifier.c   |    9 +++++----
>>  6 files changed, 68 insertions(+), 32 deletions(-)
>>
>
> [...]
>
>> @@ -741,7 +743,9 @@ struct bpf_prog_aux {
>>         u32 max_rdonly_access;
>>         u32 max_rdwr_access;
>>         const struct bpf_ctx_arg_aux *ctx_arg_info;
>> -       struct bpf_prog *linked_prog;
>> +       struct mutex tgt_mutex; /* protects writing of tgt_* pointers be=
low */
>
> nit: not just writing, "accessing" would be a better word

Except it's not, really: the values are read without taking the mutex.
This is fine because it is done in the verifier before the bpf_prog is
visible to the rest of the kernel, but saying the mutex protects all
accesses would be misleading, I think.

I guess I could change it to "protects access to tgt_* pointers after
prog becomes visible" or somesuch...

>> +       struct bpf_prog *tgt_prog;
>> +       struct bpf_trampoline *tgt_trampoline;
>>         bool verifier_zext; /* Zero extensions has been inserted by veri=
fier. */
>>         bool offload_requested;
>>         bool attach_btf_trace; /* true if attaching to BTF-enabled raw t=
p */
>
> [...]
>
>>  static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
>> @@ -11418,8 +11417,8 @@ int bpf_check_attach_target(struct bpf_verifier_=
log *log,
>>  static int check_attach_btf_id(struct bpf_verifier_env *env)
>>  {
>>         struct bpf_prog *prog =3D env->prog;
>> -       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
>>         u32 btf_id =3D prog->aux->attach_btf_id;
>> +       struct bpf_prog *tgt_prog =3D prog->aux->tgt_prog;
>>         struct btf_func_model fmodel;
>>         struct bpf_trampoline *tr;
>>         const struct btf_type *t;
>> @@ -11483,7 +11482,9 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
>>         if (!tr)
>>                 return -ENOMEM;
>>
>> -       prog->aux->trampoline =3D tr;
>> +       mutex_lock(&prog->aux->tgt_mutex);
>> +       prog->aux->tgt_trampoline =3D tr;
>> +       mutex_unlock(&prog->aux->tgt_mutex);
>
> I think here you don't need to lock mutex, because
> check_attach_btf_id() is called during verification before bpf_prog
> itself is visible to user-space, so there is no way to have concurrent
> access to it. If that wasn't the case, you'd need to take mutex lock
> before you assign tgt_prog local variable from prog->aux->tgt_prog
> above (and plus you'd need extra null checks and stuff).

Yeah, I did realise that (see above), but put it in because it doesn't
hurt, and it makes the comment above (about protecting writing) actually
be true :)

But changing the wording to include 'after it becomes visible' would
also fix this, so I'll remove the locking here...

-Toke

