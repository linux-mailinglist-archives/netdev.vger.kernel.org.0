Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEDC38F500
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhEXVf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:35:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232744AbhEXVf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 17:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621892067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTCKYsWxQRwDEtQKQlwfAxPJEz+/6KdUvGrbt+lkixQ=;
        b=LWheXhDtZltmoEXP8G5L7ZQRanedYshHR6VW/Rdr/Z6Q+UZqhc4cfbW86yT/hkPQ4uQDRf
        hnMuQC3FOgfgyfO2cJT7kHPk8U5t0lskbWwDpCRmHxB+y1iz+emvdNnSzSAfLjWe6hNk03
        ggFAEF5Cs92RW91nxIrHSNZxSQg9NrY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-oVrrVc_cMMGIwETbakbxww-1; Mon, 24 May 2021 17:34:25 -0400
X-MC-Unique: oVrrVc_cMMGIwETbakbxww-1
Received: by mail-ed1-f70.google.com with SMTP id w22-20020a05640234d6b029038d04376b6aso16145726edc.21
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 14:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=TTCKYsWxQRwDEtQKQlwfAxPJEz+/6KdUvGrbt+lkixQ=;
        b=JLvJnorh13cQCF8aDwunf0lfcEB84ZehNSZOgEH07lpQWIMdbYcF/UYkveH+koZnuM
         L9Bxkm3B+tYV7NHgNewQAs10tuf3RlX/fAj0MLGPkWDcHckanJww+iyFq+SlYHm8CjbB
         izAstYTsb1+CpHkBvSYq/R48BKiDUOEFD8HKBxpbYELwffwQ9e0CPx5yiKVQelmEeV5A
         0kAv3YXlCaTz4vuD9JaxtALIgpAxccCRwLedIl8FizYEeqtIIyZwSvL+glEUd1VOik4I
         jfC84XINzTrkK+pVeiu/lkVChQ512O41dZYYE/WgFRbZjgC799jeIpOXf5NiiEPihi3k
         CwQA==
X-Gm-Message-State: AOAM532H/j0DBZ9L2dfYfKa6fQQNPfYORPPQeuEuappCWJJ7N/I0jpCA
        Fx9fXIQ/ENqckXzf1b0jBu1PLWVp3YTCc0VYqzdw7I1pZk5BrgA11LNnlsAAZZ+HBm4oURf+Bdc
        MJHAfku6+of1t7wtu
X-Received: by 2002:a17:906:5049:: with SMTP id e9mr24768485ejk.30.1621892063846;
        Mon, 24 May 2021 14:34:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyq+AUQ9rWD9YdzEqeUawUCZ6y+oA/b2idZI+74pV7y7C8qkoftb6ZfV0DBntj3Rh0BdDyc9w==
X-Received: by 2002:a17:906:5049:: with SMTP id e9mr24768367ejk.30.1621892061441;
        Mon, 24 May 2021 14:34:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.95.13])
        by smtp.gmail.com with ESMTPSA id t19sm10177391eds.4.2021.05.24.14.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:34:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C3C32180275; Mon, 24 May 2021 23:34:13 +0200 (CEST)
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
In-Reply-To: <CAEf4BzadPCOboLov7dbVAQAcQtNj+x4CP7pKutXxo90q7oUuLQ@mail.gmail.com>
References: <20210521234203.1283033-1-andrii@kernel.org>
 <60ab496e3e211_2a2cf208d2@john-XPS-13-9370.notmuch>
 <CAEf4BzY0=J1KP4txDSVJdS93YVLxO8LLQTn0UCJ0RKDL_XzpYw@mail.gmail.com>
 <87a6ojzwdi.fsf@toke.dk>
 <CAEf4BzadPCOboLov7dbVAQAcQtNj+x4CP7pKutXxo90q7oUuLQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 May 2021 23:34:13 +0200
Message-ID: <87y2c3yfxm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, May 24, 2021 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Sun, May 23, 2021 at 11:36 PM John Fastabend
>> > <john.fastabend@gmail.com> wrote:
>> >>
>> >> Andrii Nakryiko wrote:
>> >> > Implement error reporting changes discussed in "Libbpf: the road to=
 v1.0"
>> >> > ([0]) document.
>> >> >
>> >> > Libbpf gets a new API, libbpf_set_strict_mode() which accepts a set=
 of flags
>> >> > that turn on a set of libbpf 1.0 changes, that might be potentially=
 breaking.
>> >> > It's possible to opt-in into all current and future 1.0 features by=
 specifying
>> >> > LIBBPF_STRICT_ALL flag.
>> >> >
>> >> > When some of the 1.0 "features" are requested, libbpf APIs might be=
have
>> >> > differently. In this patch set a first set of changes are implement=
ed, all
>> >> > related to the way libbpf returns errors. See individual patches fo=
r details.
>> >> >
>> >> > Patch #1 adds a no-op libbpf_set_strict_mode() functionality to ena=
ble
>> >> > updating selftests.
>> >> >
>> >> > Patch #2 gets rid of all the bad code patterns that will break in l=
ibbpf 1.0
>> >> > (exact -1 comparison for low-level APIs, direct IS_ERR() macro usag=
e to check
>> >> > pointer-returning APIs for error, etc). These changes make selftest=
 work in
>> >> > both legacy and 1.0 libbpf modes. Selftests also opt-in into 100% l=
ibbpf 1.0
>> >> > mode to automatically gain all the subsequent changes, which will c=
ome in
>> >> > follow up patches.
>> >> >
>> >> > Patch #3 streamlines error reporting for low-level APIs wrapping bp=
f() syscall.
>> >> >
>> >> > Patch #4 streamlines errors for all the rest APIs.
>> >> >
>> >> > Patch #5 ensures that BPF skeletons propagate errors properly as we=
ll, as
>> >> > currently on error some APIs will return NULL with no way of checki=
ng exact
>> >> > error code.
>> >> >
>> >> >   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_i=
aRuec6U-ZESZ54nNTY
>> >> >
>> >> > Andrii Nakryiko (5):
>> >> >   libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0
>> >> >     behaviors
>> >> >   selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR checks
>> >> >   libbpf: streamline error reporting for low-level APIs
>> >> >   libbpf: streamline error reporting for high-level APIs
>> >> >   bpftool: set errno on skeleton failures and propagate errors
>> >> >
>> >>
>> >> LGTM for the series,
>> >>
>> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> >
>> > Thanks, John!
>> >
>> > Toke, Stanislav, you cared about these aspects of libbpf 1.0 (by
>> > commenting on the doc itself), do you mind also taking a brief look
>> > and letting me know if this works for your use cases? Thanks!
>>
>> Changes LGTM:
>>
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> As a side note, the series seems to have been chopped up into individual
>> emails with no threading; was a bit weird that I had to go hunting for
>> the individual patches in my mailbox...
>>
>
> That's my bad, I messed up and sent them individually and probably
> that's why they weren't threaded properly.

Right, OK, I'll stop looking for bugs on my end, then :)

BTW, one more thing that just came to mind: since that gdoc is not
likely to be around forever, would it be useful to make the reference in
the commit message(s) point to something more stable? IDK what that
shoul be, really. Maybe just pasting (an abbreviated outline of?) the
text in the document into the cover letter / merge commit could work?

-Toke

