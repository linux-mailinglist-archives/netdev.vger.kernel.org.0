Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3974838F58C
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 00:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhEXWVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 18:21:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230008AbhEXWVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 18:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621894803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfD6zZEHWPiEUO4rFdOhgqC1vo03POxorC+jg1EsxHQ=;
        b=MHEW/7oatwSysmnd/eVTOTMHZpSdHvA4e6uKVi6JQOmG/Rh5A9x6u8ynnN6cBvoNcZSBd+
        8KykWsFcfLG4V58h1Ydj6KYx0ONvbsvpduIM4NIJczERMxQEgz6u1LS+odESphgYzh9WCg
        UNhgvDAnh7GELPcPC+VMbWQ9IEVclCM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-1cNzAxP9P0-8mfjSj1ugAg-1; Mon, 24 May 2021 18:19:59 -0400
X-MC-Unique: 1cNzAxP9P0-8mfjSj1ugAg-1
Received: by mail-ed1-f69.google.com with SMTP id q18-20020a50cc920000b029038cf491864cso16244964edi.14
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 15:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FfD6zZEHWPiEUO4rFdOhgqC1vo03POxorC+jg1EsxHQ=;
        b=V4zQjJA3RU5wxOoF5mrQqGEKyDLgf4bUmYWZStwKwysqKEpYaaHJ2eRqhjAnz3SL9Y
         gW2CeeQCiQsoQC2H4verCDfyAiP6H9gv+Tbspto0ilATEfXcx1DQq32Sji1YKQlhG0mK
         nO0iyxvghlDt8uVR0T23SMLRC0FU7UdO0gFXw/JI8++0gn1YPKUmpc1qwmcYVRKJwMlQ
         IC+1v0F9w7YkdTMlaAu5who089voYI06HN2ZhxSK9yUgIH/J14JpkUHa1WSkW02TRov0
         Y9IVYt2nQUIMC9Fza8i4DFxjF42ueOsITI0YKGrpagMiHSaxorG2D0C86MIfyppMjfya
         Gkxw==
X-Gm-Message-State: AOAM531ggRG9/NBqxRf+EtEOfvj4z10no5A4m+8FOTefCoL9qG4Fo8Nt
        ZZZVlLp3u5KkUvEmfz8aYvqL2lK+njHVX98WLpfLf6Qgum1gogPLmhkqrYvp7saXWadb8dEluhu
        753P0MDSjRA1zvo3J
X-Received: by 2002:a17:906:aac8:: with SMTP id kt8mr24828636ejb.402.1621894798086;
        Mon, 24 May 2021 15:19:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpK/3GwW8AYnSjPU1AGAReRiJ/qf1K1sCGlCfqe5J2OhdsIeBbGcDIMk5AJ6UswZfAxyNjJg==
X-Received: by 2002:a17:906:aac8:: with SMTP id kt8mr24828595ejb.402.1621894797409;
        Mon, 24 May 2021 15:19:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a22sm9204800edu.39.2021.05.24.15.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 15:19:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 82523180275; Tue, 25 May 2021 00:19:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/5] libbpf: error reporting changes for v1.0
In-Reply-To: <CAEf4Bzb9qRhW0uwxzPpL15zgRk-YTghGw6OtgQMF0+59Xdv5xQ@mail.gmail.com>
References: <20210521234203.1283033-1-andrii@kernel.org>
 <60ab496e3e211_2a2cf208d2@john-XPS-13-9370.notmuch>
 <CAEf4BzY0=J1KP4txDSVJdS93YVLxO8LLQTn0UCJ0RKDL_XzpYw@mail.gmail.com>
 <87a6ojzwdi.fsf@toke.dk>
 <CAEf4BzadPCOboLov7dbVAQAcQtNj+x4CP7pKutXxo90q7oUuLQ@mail.gmail.com>
 <87y2c3yfxm.fsf@toke.dk>
 <CAEf4Bzb9qRhW0uwxzPpL15zgRk-YTghGw6OtgQMF0+59Xdv5xQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 25 May 2021 00:19:49 +0200
Message-ID: <87sg2bydtm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, May 24, 2021 at 2:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Mon, May 24, 2021 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >>
>> >> > On Sun, May 23, 2021 at 11:36 PM John Fastabend
>> >> > <john.fastabend@gmail.com> wrote:
>> >> >>
>> >> >> Andrii Nakryiko wrote:
>> >> >> > Implement error reporting changes discussed in "Libbpf: the road=
 to v1.0"
>> >> >> > ([0]) document.
>> >> >> >
>> >> >> > Libbpf gets a new API, libbpf_set_strict_mode() which accepts a =
set of flags
>> >> >> > that turn on a set of libbpf 1.0 changes, that might be potentia=
lly breaking.
>> >> >> > It's possible to opt-in into all current and future 1.0 features=
 by specifying
>> >> >> > LIBBPF_STRICT_ALL flag.
>> >> >> >
>> >> >> > When some of the 1.0 "features" are requested, libbpf APIs might=
 behave
>> >> >> > differently. In this patch set a first set of changes are implem=
ented, all
>> >> >> > related to the way libbpf returns errors. See individual patches=
 for details.
>> >> >> >
>> >> >> > Patch #1 adds a no-op libbpf_set_strict_mode() functionality to =
enable
>> >> >> > updating selftests.
>> >> >> >
>> >> >> > Patch #2 gets rid of all the bad code patterns that will break i=
n libbpf 1.0
>> >> >> > (exact -1 comparison for low-level APIs, direct IS_ERR() macro u=
sage to check
>> >> >> > pointer-returning APIs for error, etc). These changes make selft=
est work in
>> >> >> > both legacy and 1.0 libbpf modes. Selftests also opt-in into 100=
% libbpf 1.0
>> >> >> > mode to automatically gain all the subsequent changes, which wil=
l come in
>> >> >> > follow up patches.
>> >> >> >
>> >> >> > Patch #3 streamlines error reporting for low-level APIs wrapping=
 bpf() syscall.
>> >> >> >
>> >> >> > Patch #4 streamlines errors for all the rest APIs.
>> >> >> >
>> >> >> > Patch #5 ensures that BPF skeletons propagate errors properly as=
 well, as
>> >> >> > currently on error some APIs will return NULL with no way of che=
cking exact
>> >> >> > error code.
>> >> >> >
>> >> >> >   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an1=
1_iaRuec6U-ZESZ54nNTY
>> >> >> >
>> >> >> > Andrii Nakryiko (5):
>> >> >> >   libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0
>> >> >> >     behaviors
>> >> >> >   selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR chec=
ks
>> >> >> >   libbpf: streamline error reporting for low-level APIs
>> >> >> >   libbpf: streamline error reporting for high-level APIs
>> >> >> >   bpftool: set errno on skeleton failures and propagate errors
>> >> >> >
>> >> >>
>> >> >> LGTM for the series,
>> >> >>
>> >> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> >> >
>> >> > Thanks, John!
>> >> >
>> >> > Toke, Stanislav, you cared about these aspects of libbpf 1.0 (by
>> >> > commenting on the doc itself), do you mind also taking a brief look
>> >> > and letting me know if this works for your use cases? Thanks!
>> >>
>> >> Changes LGTM:
>> >>
>> >> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>
>> >> As a side note, the series seems to have been chopped up into individ=
ual
>> >> emails with no threading; was a bit weird that I had to go hunting for
>> >> the individual patches in my mailbox...
>> >>
>> >
>> > That's my bad, I messed up and sent them individually and probably
>> > that's why they weren't threaded properly.
>>
>> Right, OK, I'll stop looking for bugs on my end, then :)
>>
>> BTW, one more thing that just came to mind: since that gdoc is not
>> likely to be around forever, would it be useful to make the reference in
>> the commit message(s) point to something more stable? IDK what that
>> shoul be, really. Maybe just pasting (an abbreviated outline of?) the
>> text in the document into the cover letter / merge commit could work?
>
> I was hoping Google won't deprecate Google Docs any time soon and I
> had no intention to remove that document. But I was also thinking to
> start wiki page at github.com/libbpf/libbpf with migration
> instructions, so once that is up and running I can link that from
> libbpf_set_strict_mode() doc comment.

Right, that sounds reasonable :)

> But I'd like to avoid blocking on that.

Understandable; but just pasting an outline into the commit message (and
keeping the link) could work in the meantime?

-Toke

