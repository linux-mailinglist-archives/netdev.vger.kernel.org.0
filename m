Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8E838F51D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhEXVsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbhEXVr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 17:47:59 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8895C061574;
        Mon, 24 May 2021 14:46:29 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id d14so32127072ybe.3;
        Mon, 24 May 2021 14:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IokXhe/JMoOKpYZxcxBZDKoLFYxRo182OnW6SWl5g0U=;
        b=omBD7bbeH83znojh+6LlUt8iKOIGHDBNKR5OPpbWwIFXgL/Plw+S8kxBysFKsQfF6R
         1Qjj3geVMov9bDjfBY32YlqRQtaS5Cur9yhKyzTweG5SFnqCBOwzr+yuFdDkoiMMsOuh
         dI86JbT0eDjT+e2iAhv6MEiOKx/jjHgXgFvA4t31OltM9l+SfaPo+HOh8yy1ky3UEVj/
         eLpWM2kHzi8r/A+jjQnhOh7p+hmABOrodAKnMmAb93NSeRxrxsjDsEjM7OKDw4yFpubF
         PHJHAMvMZZ6NnAX1O+f9Ncu7WX30/DB+g8GvNPJrJbu0VtD7gZ1qE07N0zFkdXXjiHNw
         HEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IokXhe/JMoOKpYZxcxBZDKoLFYxRo182OnW6SWl5g0U=;
        b=rDAVNX8mSnLTO8IvhN88OhhXQYHLOrZqLVW5fn3rQflPFKb1sVtOG72NlgcMzCM6iz
         n8B3uCa6kGwFc2hOGPevoshA6KPU1CdGd0SHAfsU6uOlWgIEuR6HsikhKyYi3LAeIdo+
         BuqJI7NXu46l/TNyCwjx8AlR8t3ex6+F/UO/R8mkE/4BYUbFSeK2mc4qjX8yzb1HHjJt
         91L1XNSOv4MPdHcGvoEoiufYg3gHoD/0wlkkCHABLWLbBtnkIGHCMdT7NFHld6Ic65P8
         NKfd26l/zoYnnmxPmkxes+MhPshBgsY6G4HV7Rj4jwJhuVSO1y9lS0hPBcawYreHm7hf
         XPzw==
X-Gm-Message-State: AOAM531wrAmZmqmSEDAjNz0mJBkN4NsoAy7xiSO6mytJ9hmFONMzLMSq
        8Hq5uN2SKDcYiYRUdeQT9wCdW6BlQdJwL4dlui4=
X-Google-Smtp-Source: ABdhPJw0k8lePTh5eTK8pgzFP5SvN6bngvJYl2Jhyos4kCEKu3sKO4PxgsWcprje+v1gL//Zz2lHiBApJKCfWA1APeA=
X-Received: by 2002:a25:7246:: with SMTP id n67mr37804486ybc.510.1621892789045;
 Mon, 24 May 2021 14:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210521234203.1283033-1-andrii@kernel.org> <60ab496e3e211_2a2cf208d2@john-XPS-13-9370.notmuch>
 <CAEf4BzY0=J1KP4txDSVJdS93YVLxO8LLQTn0UCJ0RKDL_XzpYw@mail.gmail.com>
 <87a6ojzwdi.fsf@toke.dk> <CAEf4BzadPCOboLov7dbVAQAcQtNj+x4CP7pKutXxo90q7oUuLQ@mail.gmail.com>
 <87y2c3yfxm.fsf@toke.dk>
In-Reply-To: <87y2c3yfxm.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 14:46:18 -0700
Message-ID: <CAEf4Bzb9qRhW0uwxzPpL15zgRk-YTghGw6OtgQMF0+59Xdv5xQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] libbpf: error reporting changes for v1.0
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 2:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, May 24, 2021 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Sun, May 23, 2021 at 11:36 PM John Fastabend
> >> > <john.fastabend@gmail.com> wrote:
> >> >>
> >> >> Andrii Nakryiko wrote:
> >> >> > Implement error reporting changes discussed in "Libbpf: the road =
to v1.0"
> >> >> > ([0]) document.
> >> >> >
> >> >> > Libbpf gets a new API, libbpf_set_strict_mode() which accepts a s=
et of flags
> >> >> > that turn on a set of libbpf 1.0 changes, that might be potential=
ly breaking.
> >> >> > It's possible to opt-in into all current and future 1.0 features =
by specifying
> >> >> > LIBBPF_STRICT_ALL flag.
> >> >> >
> >> >> > When some of the 1.0 "features" are requested, libbpf APIs might =
behave
> >> >> > differently. In this patch set a first set of changes are impleme=
nted, all
> >> >> > related to the way libbpf returns errors. See individual patches =
for details.
> >> >> >
> >> >> > Patch #1 adds a no-op libbpf_set_strict_mode() functionality to e=
nable
> >> >> > updating selftests.
> >> >> >
> >> >> > Patch #2 gets rid of all the bad code patterns that will break in=
 libbpf 1.0
> >> >> > (exact -1 comparison for low-level APIs, direct IS_ERR() macro us=
age to check
> >> >> > pointer-returning APIs for error, etc). These changes make selfte=
st work in
> >> >> > both legacy and 1.0 libbpf modes. Selftests also opt-in into 100%=
 libbpf 1.0
> >> >> > mode to automatically gain all the subsequent changes, which will=
 come in
> >> >> > follow up patches.
> >> >> >
> >> >> > Patch #3 streamlines error reporting for low-level APIs wrapping =
bpf() syscall.
> >> >> >
> >> >> > Patch #4 streamlines errors for all the rest APIs.
> >> >> >
> >> >> > Patch #5 ensures that BPF skeletons propagate errors properly as =
well, as
> >> >> > currently on error some APIs will return NULL with no way of chec=
king exact
> >> >> > error code.
> >> >> >
> >> >> >   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11=
_iaRuec6U-ZESZ54nNTY
> >> >> >
> >> >> > Andrii Nakryiko (5):
> >> >> >   libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0
> >> >> >     behaviors
> >> >> >   selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR check=
s
> >> >> >   libbpf: streamline error reporting for low-level APIs
> >> >> >   libbpf: streamline error reporting for high-level APIs
> >> >> >   bpftool: set errno on skeleton failures and propagate errors
> >> >> >
> >> >>
> >> >> LGTM for the series,
> >> >>
> >> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >> >
> >> > Thanks, John!
> >> >
> >> > Toke, Stanislav, you cared about these aspects of libbpf 1.0 (by
> >> > commenting on the doc itself), do you mind also taking a brief look
> >> > and letting me know if this works for your use cases? Thanks!
> >>
> >> Changes LGTM:
> >>
> >> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> As a side note, the series seems to have been chopped up into individu=
al
> >> emails with no threading; was a bit weird that I had to go hunting for
> >> the individual patches in my mailbox...
> >>
> >
> > That's my bad, I messed up and sent them individually and probably
> > that's why they weren't threaded properly.
>
> Right, OK, I'll stop looking for bugs on my end, then :)
>
> BTW, one more thing that just came to mind: since that gdoc is not
> likely to be around forever, would it be useful to make the reference in
> the commit message(s) point to something more stable? IDK what that
> shoul be, really. Maybe just pasting (an abbreviated outline of?) the
> text in the document into the cover letter / merge commit could work?

I was hoping Google won't deprecate Google Docs any time soon and I
had no intention to remove that document. But I was also thinking to
start wiki page at github.com/libbpf/libbpf with migration
instructions, so once that is up and running I can link that from
libbpf_set_strict_mode() doc comment. But I'd like to avoid blocking
on that.

>
> -Toke
>
