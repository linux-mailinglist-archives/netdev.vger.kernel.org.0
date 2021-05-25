Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA9C38F6CD
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 02:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhEYAI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 20:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhEYAIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 20:08:25 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041AAC06138A;
        Mon, 24 May 2021 17:06:57 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id f9so40481814ybo.6;
        Mon, 24 May 2021 17:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d0moJC/8/qaPe2PK1YriLklpUaJTGwXpd1ofwvdx6i4=;
        b=fJVajftULsQt1C5PaKASi/CF7k903oyFxFFltDohbEqONRTtiLa8fM+6VRIpsNE+1Z
         0x1JfMf9nQJ7opAeX6KNgY0z5dV77wfE0y7jR5HVTTqQYiTT5Wts7/+UzpIyX04VaSCN
         ysZbqEDonUYF5Cm4IxSMT9FRzeMKHwa491hIsjtMO9L8b44V+vjvM5IGWGn8myv//t2/
         nPW6T86F5vt4wYcvjAgfpKzHb89m6rH9XZyrtfqoTUH7OxJuzxKV1acCZaUX7tQwARsV
         XRnnK2V2IUTGN2wOeC8ThRLdHSy4dn7T9ora2CTv6hckJttoex7KH6BV3UPKlZSCCvdd
         g4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d0moJC/8/qaPe2PK1YriLklpUaJTGwXpd1ofwvdx6i4=;
        b=XeO1ongMDDuaHhsnvmqTXpDM1Mk7DQQ2+PujfZx2E68jvzKVc75OkgoErkBFyJ2EZU
         KPBIpl/W8x6nUnlRXDSBlmvOY4cWuZnhISBsXoFLGlcOsHlpL+It9au8+2ikL0g+gq3V
         SWRLRVRRMnHp4rL7Yp7VsVyPkr+5pp7AIff8r/ppHvipCPnvdQetpw+UqbsvWsTrgnK8
         Le0K04IGyhb9SqHbP4lcoiU0ecPIq8NkDv06EWpD0XfJsV8e6PhY3BmcpuMBN2oyT2ub
         0A5Isud1fOhl5dS6YAE16x0DfX7VumLRZtofeJt2XLvha2G5TZeMd8hAZ8TP+37jF6dn
         HXJw==
X-Gm-Message-State: AOAM532NRrg1qtGNZ4sQIhEwUWw7RJFqhIJ3doafc6ZbbFtaeyJFZPIO
        2pqCxWnlKXJ7yeJjms2aN6itLn4m4AArvNvKqK0=
X-Google-Smtp-Source: ABdhPJzTcLMOBOoUXeYJIKWRZwCbWkwGWCC9Z+CA4qXEs1t6H8JbEbvvjG3iO87lb1/4uXzP4OXLRl5POvBW2Sm/jOk=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr36815561ybg.459.1621901216270;
 Mon, 24 May 2021 17:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210521234203.1283033-1-andrii@kernel.org> <60ab496e3e211_2a2cf208d2@john-XPS-13-9370.notmuch>
 <CAEf4BzY0=J1KP4txDSVJdS93YVLxO8LLQTn0UCJ0RKDL_XzpYw@mail.gmail.com>
 <87a6ojzwdi.fsf@toke.dk> <CAEf4BzadPCOboLov7dbVAQAcQtNj+x4CP7pKutXxo90q7oUuLQ@mail.gmail.com>
 <87y2c3yfxm.fsf@toke.dk> <CAEf4Bzb9qRhW0uwxzPpL15zgRk-YTghGw6OtgQMF0+59Xdv5xQ@mail.gmail.com>
 <87sg2bydtm.fsf@toke.dk>
In-Reply-To: <87sg2bydtm.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 17:06:45 -0700
Message-ID: <CAEf4BzaaTPbdUSCobSBL68Y7n7v49P0GmUAn_rvU4cENpZ6yvg@mail.gmail.com>
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

On Mon, May 24, 2021 at 3:20 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, May 24, 2021 at 2:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Mon, May 24, 2021 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >>
> >> >> > On Sun, May 23, 2021 at 11:36 PM John Fastabend
> >> >> > <john.fastabend@gmail.com> wrote:
> >> >> >>
> >> >> >> Andrii Nakryiko wrote:
> >> >> >> > Implement error reporting changes discussed in "Libbpf: the ro=
ad to v1.0"
> >> >> >> > ([0]) document.
> >> >> >> >
> >> >> >> > Libbpf gets a new API, libbpf_set_strict_mode() which accepts =
a set of flags
> >> >> >> > that turn on a set of libbpf 1.0 changes, that might be potent=
ially breaking.
> >> >> >> > It's possible to opt-in into all current and future 1.0 featur=
es by specifying
> >> >> >> > LIBBPF_STRICT_ALL flag.
> >> >> >> >
> >> >> >> > When some of the 1.0 "features" are requested, libbpf APIs mig=
ht behave
> >> >> >> > differently. In this patch set a first set of changes are impl=
emented, all
> >> >> >> > related to the way libbpf returns errors. See individual patch=
es for details.
> >> >> >> >
> >> >> >> > Patch #1 adds a no-op libbpf_set_strict_mode() functionality t=
o enable
> >> >> >> > updating selftests.
> >> >> >> >
> >> >> >> > Patch #2 gets rid of all the bad code patterns that will break=
 in libbpf 1.0
> >> >> >> > (exact -1 comparison for low-level APIs, direct IS_ERR() macro=
 usage to check
> >> >> >> > pointer-returning APIs for error, etc). These changes make sel=
ftest work in
> >> >> >> > both legacy and 1.0 libbpf modes. Selftests also opt-in into 1=
00% libbpf 1.0
> >> >> >> > mode to automatically gain all the subsequent changes, which w=
ill come in
> >> >> >> > follow up patches.
> >> >> >> >
> >> >> >> > Patch #3 streamlines error reporting for low-level APIs wrappi=
ng bpf() syscall.
> >> >> >> >
> >> >> >> > Patch #4 streamlines errors for all the rest APIs.
> >> >> >> >
> >> >> >> > Patch #5 ensures that BPF skeletons propagate errors properly =
as well, as
> >> >> >> > currently on error some APIs will return NULL with no way of c=
hecking exact
> >> >> >> > error code.
> >> >> >> >
> >> >> >> >   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5a=
n11_iaRuec6U-ZESZ54nNTY
> >> >> >> >
> >> >> >> > Andrii Nakryiko (5):
> >> >> >> >   libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1=
.0
> >> >> >> >     behaviors
> >> >> >> >   selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR ch=
ecks
> >> >> >> >   libbpf: streamline error reporting for low-level APIs
> >> >> >> >   libbpf: streamline error reporting for high-level APIs
> >> >> >> >   bpftool: set errno on skeleton failures and propagate errors
> >> >> >> >
> >> >> >>
> >> >> >> LGTM for the series,
> >> >> >>
> >> >> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >> >> >
> >> >> > Thanks, John!
> >> >> >
> >> >> > Toke, Stanislav, you cared about these aspects of libbpf 1.0 (by
> >> >> > commenting on the doc itself), do you mind also taking a brief lo=
ok
> >> >> > and letting me know if this works for your use cases? Thanks!
> >> >>
> >> >> Changes LGTM:
> >> >>
> >> >> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >>
> >> >> As a side note, the series seems to have been chopped up into indiv=
idual
> >> >> emails with no threading; was a bit weird that I had to go hunting =
for
> >> >> the individual patches in my mailbox...
> >> >>
> >> >
> >> > That's my bad, I messed up and sent them individually and probably
> >> > that's why they weren't threaded properly.
> >>
> >> Right, OK, I'll stop looking for bugs on my end, then :)
> >>
> >> BTW, one more thing that just came to mind: since that gdoc is not
> >> likely to be around forever, would it be useful to make the reference =
in
> >> the commit message(s) point to something more stable? IDK what that
> >> shoul be, really. Maybe just pasting (an abbreviated outline of?) the
> >> text in the document into the cover letter / merge commit could work?
> >
> > I was hoping Google won't deprecate Google Docs any time soon and I
> > had no intention to remove that document. But I was also thinking to
> > start wiki page at github.com/libbpf/libbpf with migration
> > instructions, so once that is up and running I can link that from
> > libbpf_set_strict_mode() doc comment.
>
> Right, that sounds reasonable :)
>
> > But I'd like to avoid blocking on that.
>
> Understandable; but just pasting an outline into the commit message (and
> keeping the link) could work in the meantime?

I'm not sure what are we trying to achieve by copy/pasting parts of
that doc here. Each patch succinctly explains how each feature
behaves, so it's completely self-describing. I put the link to the
document for anyone that wants to read the entire discussion or leave
some more comments, but it's not mandatory to understand this patch
set.

>
> -Toke
>
