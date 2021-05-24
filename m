Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5413C38F49A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhEXUz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:55:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232442AbhEXUzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621889636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pY7YPuUNBdXRSUKD1wB6Zju3YiaGhBni11l0v/aof6M=;
        b=G3iiJHK1XxMGBnpKUetrJOSJXZYKks2bYXmSOQdPlqGBRO5ulv51lmQU9zIhG+mn8s1iGT
        mk5RhCl4jdk/ILNLNMEWQazZGZHzfcurgR+AJP0od/v+2OdI4CSGS+93ZJsnMrkj/2VGRk
        rAZ/8HJ/TWqyRjkiIfhpnwMsNBH+Wdk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-WpZ5jqlHN9a7rRmNC08gvg-1; Mon, 24 May 2021 16:53:54 -0400
X-MC-Unique: WpZ5jqlHN9a7rRmNC08gvg-1
Received: by mail-ed1-f70.google.com with SMTP id y17-20020a0564023591b02903886c26ada4so16173368edc.5
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pY7YPuUNBdXRSUKD1wB6Zju3YiaGhBni11l0v/aof6M=;
        b=IA15Ie6pa7+NGfL7/qBSL2DCtCEGJCFVDaueQjv5XqMLef/QXI7FH4XCdJHvgBjJh/
         LjHJF629XAXNZsmb0+BIgnNSYfWILS1XNpNpez5jTs1N7DCAxuAQB3gGchPgIPe1PWe5
         6Z5waltadrU8ENe20ygyRv1RRS8bBXO2AqG/E0+OMS5pyfMQ+CChpRpgN8RxVUZyxNhU
         rRARFd5xAk1afXYJhaWwGZfuTzJih30iUJ+JzrRebcYF2BnoM/dKpml4u8gT9wjuDHBA
         CIZ7jiJ6AZL8Td/qI58B4aQjMiXnzPgrJtJZ4TQCUOBg39lyTgQoQpWkUEbmBhun/a7i
         0CtA==
X-Gm-Message-State: AOAM532nessuePt42CH6EOXdaNlTDUWokpozRcaLxd8OzrqYEpTBPUbA
        wxDe39OzkQF3NJk4et5fwXyEZu8FSJXWDpDcF3poxWez1kD+zQdIgU3xrzE+4TDVrODiqpPnloT
        zQlxey9kyMOjOscrB
X-Received: by 2002:a17:906:3f86:: with SMTP id b6mr25415470ejj.530.1621889632935;
        Mon, 24 May 2021 13:53:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlPK4VVyU70bz6wRz+jJVqqGCNxRSCDFSc/Uc2WjF5Rmh737IYywfGwnUh2II6yz9RwlAUcw==
X-Received: by 2002:a17:906:3f86:: with SMTP id b6mr25415445ejj.530.1621889632414;
        Mon, 24 May 2021 13:53:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a19sm9685711edv.80.2021.05.24.13.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 13:53:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9E750180275; Mon, 24 May 2021 22:53:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/5] libbpf: error reporting changes for v1.0
In-Reply-To: <CAEf4BzY0=J1KP4txDSVJdS93YVLxO8LLQTn0UCJ0RKDL_XzpYw@mail.gmail.com>
References: <20210521234203.1283033-1-andrii@kernel.org>
 <60ab496e3e211_2a2cf208d2@john-XPS-13-9370.notmuch>
 <CAEf4BzY0=J1KP4txDSVJdS93YVLxO8LLQTn0UCJ0RKDL_XzpYw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 May 2021 22:53:45 +0200
Message-ID: <87a6ojzwdi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sun, May 23, 2021 at 11:36 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
>>
>> Andrii Nakryiko wrote:
>> > Implement error reporting changes discussed in "Libbpf: the road to v1=
.0"
>> > ([0]) document.
>> >
>> > Libbpf gets a new API, libbpf_set_strict_mode() which accepts a set of=
 flags
>> > that turn on a set of libbpf 1.0 changes, that might be potentially br=
eaking.
>> > It's possible to opt-in into all current and future 1.0 features by sp=
ecifying
>> > LIBBPF_STRICT_ALL flag.
>> >
>> > When some of the 1.0 "features" are requested, libbpf APIs might behave
>> > differently. In this patch set a first set of changes are implemented,=
 all
>> > related to the way libbpf returns errors. See individual patches for d=
etails.
>> >
>> > Patch #1 adds a no-op libbpf_set_strict_mode() functionality to enable
>> > updating selftests.
>> >
>> > Patch #2 gets rid of all the bad code patterns that will break in libb=
pf 1.0
>> > (exact -1 comparison for low-level APIs, direct IS_ERR() macro usage t=
o check
>> > pointer-returning APIs for error, etc). These changes make selftest wo=
rk in
>> > both legacy and 1.0 libbpf modes. Selftests also opt-in into 100% libb=
pf 1.0
>> > mode to automatically gain all the subsequent changes, which will come=
 in
>> > follow up patches.
>> >
>> > Patch #3 streamlines error reporting for low-level APIs wrapping bpf()=
 syscall.
>> >
>> > Patch #4 streamlines errors for all the rest APIs.
>> >
>> > Patch #5 ensures that BPF skeletons propagate errors properly as well,=
 as
>> > currently on error some APIs will return NULL with no way of checking =
exact
>> > error code.
>> >
>> >   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRu=
ec6U-ZESZ54nNTY
>> >
>> > Andrii Nakryiko (5):
>> >   libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0
>> >     behaviors
>> >   selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR checks
>> >   libbpf: streamline error reporting for low-level APIs
>> >   libbpf: streamline error reporting for high-level APIs
>> >   bpftool: set errno on skeleton failures and propagate errors
>> >
>>
>> LGTM for the series,
>>
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
> Thanks, John!
>
> Toke, Stanislav, you cared about these aspects of libbpf 1.0 (by
> commenting on the doc itself), do you mind also taking a brief look
> and letting me know if this works for your use cases? Thanks!

Changes LGTM:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

As a side note, the series seems to have been chopped up into individual
emails with no threading; was a bit weird that I had to go hunting for
the individual patches in my mailbox...

