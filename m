Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC4A261F76
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgIHUDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730312AbgIHPXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:23:54 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE24C0619C9
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:20:07 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id c18so1320338qtw.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z2zEcPrDOEXtenqcSm/YjsHy5a17RGaHKUKz5UTd9dw=;
        b=Cu/56IEHMRAN0rbp0KcVFoAxNXRiG8uj7NNBgaqPg1pihWNsPtbInLktB0tNhJviiV
         atY5oBOocekRqdx06+245jPcK9RxrJngS84/SPWgs7TyRI2Am99FBaYSsYBYECrNHyUF
         kzn+AGkte+wKaYdhfaIPfpEHGqOUT0USUZMezTJUDcHM5Mez8oo1t8e3iC1qr7GDRzx9
         XyFSrnVSO+nbdfzXdiBcvFcwCQaapKyXAgRpXwnj8upuJacWFZQroWONgByJPjAj1FrD
         hrH2VJ+hSKf0fpwsfD0sZRvs6Ux92eTgWXvz4a8Ie63ZW619BhbxMH1qIi/9jUjsvyuz
         u3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z2zEcPrDOEXtenqcSm/YjsHy5a17RGaHKUKz5UTd9dw=;
        b=DsVZuGybqEmYUOmH96XIk8gK8mzsQiu03nAuiXYOrswkZwmc3rvy6s9KKOajOt9hcr
         Shmy9q8fkfWI9CS+TSTeWZHxN93bfHXWSpWhb1DWwkGjbnqx34j4JNmnvd/0aUVTZUCK
         d15fXBIrOxsjHAi4fTNaqTELaCYiIxz3fTy05N8eDVm1AezCs2MbMAqBmyqLcjPAxCww
         mgZ206rM1wEkeFNsHnoKZyV/s/gN2Vr+zJpWG69ijtWqc30iipynC6A1yrInzXLi6Y6x
         bp9iqEW9l0TxHBdj6M0BVOhY8dh1RxjGQVu/P4T6Iy4080H71nH078b9ziqyLKIhnUgc
         UL/Q==
X-Gm-Message-State: AOAM530p31sAfwgxi8ljntuaOcvKIvHm78JxkUxuI58NW4VGFenG3buY
        8pY9ZaeX79WndJJ78dfJEFs1UDufd1Xe+lFy6fxtlw==
X-Google-Smtp-Source: ABdhPJxfZqPPo92H7ajgNrQCy8SRwH8pjaiQof6spmn2G4AhL3ZYJyUzlgpka/jybSCW+X6+AVnE9rabmY9IXTcvS+4=
X-Received: by 2002:ac8:6648:: with SMTP id j8mr574001qtp.326.1599578405126;
 Tue, 08 Sep 2020 08:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
 <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com> <87mu22ottv.fsf@toke.dk>
In-Reply-To: <87mu22ottv.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 8 Sep 2020 08:19:59 -0700
Message-ID: <CAKH8qBuTwNhCjdE91d+9bYsLko08qNf4E2B_33x8Zcc4KAK36g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 1:49 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> >> May be we should talk about problem statement and goals.
> >> Do we actually need metadata per program or metadata per single .o
> >> or metadata per final .o with multiple .o linked together?
> >> What is this metadata?
> >
> > Yep, that's a very valid question. I've also CC'ed Andrey.
>
> For the libxdp use case, I need metadata per program. But I'm already
> sticking that in a single section and disambiguating by struct name
> (just prefixing the function name with a _ ), so I think it's fine to
> have this kind of "concatenated metadata" per elf file and parse out the
> per-program information from that. This is similar to the BTF-encoded
> "metadata" we can do today.
We've come full circle :-)
I think we discussed that approach originally - to stick everything
into existing global .data/.rodata and use some variable prefix for
the metadata. I'm fine with that approach. The only thing I don't
understand is - why bother with the additional .rodata.metadata
section and merging?
Can we unconditionally do BPF_PROG_BIND_MAP(.rodata) from libbpf (and
ignore the error) and be done?

Sticking to the original question: for our use-case, the metadata is
per .o file. I'm not sure how it would work in the 'multiple .o linked
together' use case. Ideally, we'd need to preserve all metadata?

> >> If it's just unreferenced by program read only data then no special na=
mes or
> >> prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any ma=
p to any
> >> program and it would be up to tooling to decide the meaning of the dat=
a in the
> >> map. For example, bpftool can choose to print all variables from all r=
ead only
> >> maps that match "bpf_metadata_" prefix, but it will be bpftool convent=
ion only
> >> and not hard coded in libbpf.
> >
> > Agree as well. It feels a bit odd for libbpf to handle ".metadata"
> > specially, given libbpf itself doesn't care about its contents at all.
> >
> > So thanks for bringing this up, I think this is an important
> > discussion to have.
>
> I'm fine with having this be part of .rodata. One drawback, though, is
> that if any metadata is defined, it becomes a bit more complicated to
> use bpf_map__set_initial_value() because that now also has to include
> the metadata. Any way we can improve upon that?
Right. One additional thing we wanted this metadata to have is the
comm of the process who loaded this bpf program (to be filled/added by
libbpf).
I suppose .rodata.metadata section can help with that?
