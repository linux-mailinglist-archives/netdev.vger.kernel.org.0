Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DF82765EC
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIXBh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXBh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:37:59 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859A8C0613CE;
        Wed, 23 Sep 2020 18:38:13 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id k2so1140802ybp.7;
        Wed, 23 Sep 2020 18:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SahSrWNUq4rlPLyB42HUuU8snZRgbRV4bsSIoqj8x2Y=;
        b=nHvYncvHVynZfqJBxKn16vTxw21Kaj9PhKH/GQ59a/mtqSZAbcTnXuD8on24It+pIi
         igyT9d2ZD0tFuT8z//iO4YWs+bYDPsSFKqgXj3Dfs1xDg/qLxjHGR+aUlwpw8ueynhFx
         8rEXAlvNwV+KPI8GOtdj87l9NWovm6Srdd3VgPOWK5Es5iNdchnVKG+Ojt4If3xwEtxf
         NBOSHTHRXPNVWhFn7wRg8/wxTcd6SbgzHutzA5wajsEMjTeAwnPffdmU2SU5w9ByIgdM
         UZxPjmIkxvOZPJ4OOCJljOiRx1IbsfaGh7Mp0z69f1GStKffpbgMM022TqPHrV3gZ48X
         VnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SahSrWNUq4rlPLyB42HUuU8snZRgbRV4bsSIoqj8x2Y=;
        b=iJ7PQDJ1pJldwdsw7jrtyDB8s1I/tqJGyBqcIEUguPGvZpFvBUU9oxkSa4fGrxIfHC
         73DWEUFHdBphjVeVziYRmwfCa6q8CvcAS8Vlod133bpqQ/fwLJTIIcjgN4IlbyYJmDtK
         ZljVmX929DGyMFaaLncQp9IIW4eNwOIXKKnyBYAj7dm0K1nRGVpqZ4zVFxCorrR5/YtY
         Ef1QOSQ6S8WvzlIYhoDzVE2KJ79NaDZBQovzvZSJfa+4gqW+IX+KCC3qSqMvKG9/0GH8
         jf4ub81TnPJjdwyI7PyiOxONoTnpptaiP5E7bt/PpgsCznYJqBiiczDyCt4dmWEel76g
         PB8g==
X-Gm-Message-State: AOAM5339nu4SW0tgCuCb71daTrqvjriquxfSw353qz9+DWUhe7w0/3SI
        oQzYa+q7rK0A4VEb8hRuuDB/pbMjwPaHP5xx4OE=
X-Google-Smtp-Source: ABdhPJwsRAgo1FmSZI9osmBNLL0QAoD6c2SzK3OiK2UmtU85ayOw5hW4I5uFzN2e5yhYP6vDzQeE2l+VnuImBYbvkYk=
X-Received: by 2002:a25:4446:: with SMTP id r67mr3753093yba.459.1600911492522;
 Wed, 23 Sep 2020 18:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079992560.8301.11225602391403157558.stgit@toke.dk> <20200924010811.kwrkzdzh6za3w3fz@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200924010811.kwrkzdzh6za3w3fz@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 18:38:01 -0700
Message-ID: <CAEf4BzZ8f9osvJ3CD7kL4-SmdH9v_EQ73A9c=oGOBgeTziiFzw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 11/11] selftests: Remove fmod_ret from
 benchmarks and test_overhead
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 6:08 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 22, 2020 at 08:38:45PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > -const struct bench bench_trig_fmodret =3D {
> > -     .name =3D "trig-fmodret",
> > -     .validate =3D trigger_validate,
> > -     .setup =3D trigger_fmodret_setup,
> > -     .producer_thread =3D trigger_producer,
> > -     .consumer_thread =3D trigger_consumer,
> > -     .measure =3D trigger_measure,
> > -     .report_progress =3D hits_drops_report_progress,
> > -     .report_final =3D hits_drops_report_final,
> > -};
> > diff --git a/tools/testing/selftests/bpf/progs/trigger_bench.c b/tools/=
testing/selftests/bpf/progs/trigger_bench.c
> > index 9a4d09590b3d..1af23ac0c37c 100644
> > --- a/tools/testing/selftests/bpf/progs/trigger_bench.c
> > +++ b/tools/testing/selftests/bpf/progs/trigger_bench.c
> > @@ -45,10 +45,3 @@ int bench_trigger_fentry_sleep(void *ctx)
> >       __sync_add_and_fetch(&hits, 1);
> >       return 0;
> >  }
> > -
> > -SEC("fmod_ret/__x64_sys_getpgid")
> > -int bench_trigger_fmodret(void *ctx)
> > -{
> > -     __sync_add_and_fetch(&hits, 1);
> > -     return -22;
> > -}
>
> why are you removing this? There is no problem here.
> All syscalls are error-injectable.
> I'm surprised Andrii acked this :(

Andrii didn't know that all syscalls are error-injectable, thanks for
catching :) after fmod_ret/__set_task_comm I just assumed that I've
been abusing fmod_ret all this time...
